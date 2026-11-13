# Liner-Shipping Fleet Repositioning: Model and Reformulation

## Real-world interpretation

The model represents the repositioning of six container vessels from existing services into a new liner-shipping service. Each vessel chooses a **phase-out action**, identifying a departure opportunity with a fixed time, and a **phase-in week** at a common destination port. The six vessels must enter the new service in six distinct consecutive weeks.

Three repositioning modes are represented:

1. **Direct sailing**, with a tabulated cost for each departure action, destination port, and arrival week.
2. **SOS activity**, an intermediate service opportunity with associated savings and sailing costs before and after the activity.
3. **Sail-equipment activity**, an equipment-transport opportunity with three sailing stages: before, during, and after the activity.

This interpretation follows from the model’s names, comments, timing tables, and cost structure. The supplied file fixes all instance data internally, including 13 candidate phase-in ports and 11 weeks.

## Original mathematical structure

### Variables

The original model declares **97 independent integer decision variables**, plus a defined integer objective variable:

- Six phase-out action choices and one common phase-in port.
- Six phase-in weeks and six repositioning-mode choices.
- Six entries each for SOS action, SOS identifier, SOS savings, and the two SOS sailing costs.
- Six equipment-action choices.
- Six entries each for the three equipment-stage fixed costs and three stage durations.
- Six direct-sailing costs.

The vessel arrays are indexed from 1 to 6, while phase-out actions and activity domains include zero. Zero denotes an inactive SOS or equipment activity.

### Constraints

The formulation combines conditional constraints, variable-indexed table lookups, and global constraints:

- **Mode compatibility:** Each repositioning mode activates its corresponding costs and activities and sets incompatible quantities to zero.
- **Activity uniqueness:** `alldifferent_except_0` prevents vessels from sharing a positive SOS identifier, SOS action, or equipment action.
- **Duration bounds:** Equipment-stage durations must lie between tabulated minimum and maximum values.
- **Temporal feasibility:** Total equipment-sailing duration cannot exceed the time between phase-out and phase-in.
- **Required total duration:** For equipment repositioning, the three durations must sum to the smaller of the available time and the sum of their tabulated maxima.
- **Phase-in coordination:** Arrival weeks are all different, and their maximum minus minimum is five.
- **Cost restrictions:** Two separate cost expressions must each be strictly below 500,000.

Negative table entries are effectively infeasibility markers when a selected entry must equal a nonnegative cost variable.

### Objective

The model minimizes an integer cost expression comprising:

- A hotel-time charge of **66 per time unit** between phase-out and phase-in.
- Direct-sailing costs.
- SOS sailing costs, minus SOS savings.
- Equipment fixed costs, plus duration-dependent terms.

The equipment-duration coefficient is −1,138 for every vessel. The reformulation preserves this sign, the original coefficient 66, both strict cost caps, and the objective’s nonnegative domain. In particular, the SOS savings appear **positively** in the first cost-cap constraint but **negatively** in the objective; these are distinct original expressions.

## Reformulation and justification

### 1. Eliminate the infeasible SOS mode

Every entry of `sosSailCostAArr` for a **positive SOS action** equals −1. However:

- `reposType[v] = 2` requires `sosAct[v] > 0`.
- The same mode requires `sosActACost[v]` to equal the selected after-sailing table entry.
- `sosActACost[v]` has a nonnegative domain.

Thus mode 2 would require a nonnegative variable to equal −1 and is infeasible for every vessel.

The remaining modes explicitly force SOS actions, identifiers, savings, and sailing costs to zero. Consequently, fixing these quantities to zero preserves every feasible solution. Their uniqueness constraints then hold automatically.

### 2. Express equipment usage as a binary capacity

The fixed data set `seActSize = 1`, so each equipment action is either zero or one.

The original implications establish both directions:

- Mode 3 requires a positive equipment action, hence action 1.
- A positive equipment action requires mode 3.

After eliminating mode 2, this gives the exact relation

\[
\text{reposType}_v = 1 + 2\,\text{seAct}_v.
\]

Because 1 is the only positive equipment action, `alldifferent_except_0(seAct)` is equivalent to

\[
\sum_v \text{seAct}_v \leq 1.
\]

This replaces a global uniqueness constraint with a linear capacity constraint.

### 3. Precompute feasible route alternatives

For each vessel, the reformulation enumerates combinations of:

- Phase-out action.
- Phase-in port and week.
- Direct or equipment repositioning.

It removes only combinations excluded by the original constraints:

- A direct alternative requires a nonnegative direct-cost entry and nonnegative elapsed time.
- An equipment alternative requires a nonnegative after-stage fixed-cost entry and enough elapsed time for the sum of the three minimum stage durations.

The latter test follows by adding the three original lower duration bounds and comparing their sum with the original elapsed-time constraint.

For each retained equipment alternative, the required total duration is calculated as

\[
T=\min\{B_{\max}+D_{\max}+A_{\max},\ \text{elapsed time}\}.
\]

This is the original total-duration equality evaluated at fixed route indices, not an objective-based approximation.

### 4. Use a binary route-selection formulation

Exactly one retained alternative is selected for each vessel. Linear weighted sums connect the selected alternative to the original departure choice, arrival choices, equipment indicator, costs, elapsed time, and duration bounds.

The three individual equipment durations remain integer decision variables. Their lower bounds, upper bounds, and required sum remain enforced. Therefore, the reformulation does **not** choose an arbitrary duration split or discard feasible splits that may be fixed externally.

This extended formulation replaces conditional multidimensional lookups and variable-dependent minimum expressions with constant coefficients and linear constraints. It is intended to provide HiGHS with a more direct mixed-integer formulation; no measured speedup is asserted here.

### 5. Represent consecutive arrivals by a selected window

The reformulation selects one six-week window and assigns exactly one vessel to each week inside it, with no vessels outside it.

This is equivalent to the original conditions: six distinct integer weeks whose maximum minus minimum is five must occupy every week in that interval. Conversely, assigning one vessel to each week of a six-week window satisfies both original constraints.

A shared one-hot port selection likewise preserves the requirement that all vessels use the same phase-in port.

### 6. Compress fixed data and provide solution mapping

Repeated fixed tables are represented using comprehensions, repeated-tail row constructors, and explicit week-shift boundary values. These are storage changes, not aggregation or rounding: original table values, indices, and vessel correspondences are retained.

The original independent variables remain in the model. The mapping script exports only those variables, excluding reformulation auxiliaries. Where solver output omits quantities that are fixed or exactly recoverable, it reconstructs them using proved relations—such as zero SOS quantities and the equipment-mode equation—and otherwise reports missing fields rather than inventing values.

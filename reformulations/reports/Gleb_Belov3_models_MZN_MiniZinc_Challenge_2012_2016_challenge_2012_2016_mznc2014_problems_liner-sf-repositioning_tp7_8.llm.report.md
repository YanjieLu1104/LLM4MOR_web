# Liner-Shipping Fleet Repositioning: Model and Reformulation

## 1. Background

The model represents a **liner-shipping fleet repositioning problem**: six vessels leave existing services and enter a new service. Each vessel selects a phase-out event, while all vessels share a phase-in port and enter in different weeks.

The embedded instance contains:

- Six vessels and 13 candidate phase-in ports.
- An 11-week planning horizon.
- Respectively 18, 18, 11, 11, 16, and 14 phase-out events for the vessels.
- Four optional SOS activities, apparently representing opportunities to serve an additional shipping activity during repositioning.

A vessel either travels directly to the phase-in service or undertakes an SOS activity, with sailing legs before and after it. A third repositioning type is declared but explicitly forbidden. Cost tables encode the available movements; entries of `-1` cannot be selected because the corresponding cost variables must be nonnegative.

The vessels must enter the new service in **six consecutive weeks, with exactly one vessel entering each week**. This resembles the establishment of a weekly service.

## 2. Original Model

### Variables

The original formulation contains **55 independent bounded integer variables**, plus a defined objective variable:

| Variables | Count | Meaning |
|---|---:|---|
| `poAct0`–`poAct5` | 6 | Selected phase-out event for each vessel |
| `piPort` | 1 | Common phase-in port |
| `piWeek` | 6 | Phase-in week of each vessel |
| `reposType` | 6 | Direct or SOS repositioning |
| `sosAct`, `sos` | 12 | Selected SOS activity and its identifier; zero denotes no activity |
| `sosActSavings` | 6 | Activity-dependent savings |
| `directCost` | 6 | Direct sailing costs |
| `sosActBCost`, `sosActACost` | 12 | Sailing costs before and after an SOS activity |

Although several parameters are initially declared without values, subsequent assignments fix all instance data in the supplied file.

### Constraints

The main constraint groups are:

1. **Route selection and cost lookup.**  
   Repositioning type 1 selects a direct-cost table entry and sets the SOS variables and costs to zero. Type 2 selects a positive SOS activity, sets direct cost to zero, and obtains savings and both sailing-leg costs from tables.

2. **Activity availability.**  
   Two `alldifferent_except_0` constraints prevent different vessels from using the same nonzero activity or activity identifier. The fixed `sosIds` table links these representations.

3. **Phase-in scheduling.**  
   `alldifferent(piWeek)` requires distinct entry weeks. Together with
   \[
   \max(\text{piWeek})-\min(\text{piWeek})=5,
   \]
   this forces the six vessels to occupy precisely six consecutive weeks.

4. **Budget.**  
   Total direct and SOS sailing costs, **plus the stored savings values**, must be strictly below 500,000.

### Objective

The model minimizes elapsed-time costs plus repositioning costs. Elapsed time is the selected phase-in time minus the selected phase-out time, weighted by 88 for the first two vessels and 66 for the other four.

Writing the four aggregate cost components as \(D,S,B,A\), the objective is
\[
\min\; H+D-S+B+A,
\]
where \(H\) is the weighted elapsed-time cost.

The stored savings values are nonpositive. Consequently, the budget uses \(D+S+B+A\), whereas the objective uses \(H+D-S+B+A\). **The reformulation preserves this sign difference exactly**, rather than changing it to match an inferred business interpretation. It also preserves the original nonnegative objective domain.

## 3. Reformulation

The reformulation replaces conditional multidimensional table lookups with a **binary selection and flow formulation**, intended to give HiGHS a more explicit linear mixed-integer model.

### Feasible-movement preprocessing

Binary variables are created only for movements whose relevant sailing-cost table entries are nonnegative.

This filtering is valid because the original constraints equate each selected sailing cost to its table entry, while the corresponding cost variable has a nonnegative domain. Thus, selecting a negative entry is already infeasible. No movement is removed merely because it is expensive or appears unattractive.

### Direct-movement selection

For each vessel, a binary variable represents a feasible combination of:

- Phase-out event.
- Phase-in port.
- Phase-in week.

Selecting a direct movement determines its cost, phase-out event, arrival week, and elapsed-time contribution through linear weighted sums.

This is equivalent to the original direct-mode implication: exactly one direct movement is selected when the vessel chooses no SOS activity, and none is selected otherwise.

### SOS flow decomposition

SOS movements are split into two sets of binary choices:

- A phase-out event and SOS activity, determining the before-activity cost.
- An SOS activity, phase-in port, and phase-in week, determining the after-activity cost.

For each vessel and positive activity, both selection sums equal the same activity-selection binary. Hence an active SOS choice selects exactly one leg on each side, with matching activity identifiers.

This decomposition is valid because the original before-activity table depends only on the phase-out event and activity, while the after-activity table depends only on the vessel, activity, phase-in port, and week. The source contains no additional constraint directly coupling the two legs. The decomposition therefore avoids enumerating their full Cartesian product without losing a required relationship.

### Linear port and activity constraints

A one-hot port vector selects the common phase-in port. Each vessel’s selected arrival movement must use that port.

A one-hot activity vector includes activity zero, representing direct repositioning. The equation
\[
\text{reposType}_v=2-\text{activity}_{v,0}
\]
is valid because the original model forbids type 3, forces activity zero in direct mode, and requires a positive activity in SOS mode.

At-most-one constraints on positive activities and identifiers replace the two `alldifferent_except_0` constraints. These are equivalent because each vessel selects exactly one activity, and zero remains unrestricted across vessels.

### Consecutive-week occupancy

The reformulation selects one six-week window using binary start variables. Vessel–week assignment binaries then enforce:

- Exactly one week per vessel.
- Exactly one vessel in each week of the selected window.
- No vessel outside that window.

This is equivalent to the original scheduling constraints: six distinct integer weeks spanning five weeks necessarily fill every position in that interval. Conversely, filling a six-week window satisfies both original constraints.

### Lossless representation of fixed data

The fixed cost tables are stored more compactly using:

- Prefix encoding of leading infeasible entries.
- Repetition of constant row tails.
- Reuse of identical SOS after-activity cost blocks.

These are data-representation changes, not optimization reductions. Decoding reconstructs the original arrays with their original names, index domains, values, and entity correspondences.

### Preservation of original solutions

All original independent decision variables remain in the model and are linked to the binary choices by linear equations. The mapping script therefore copies their values directly, excludes auxiliary variables, and reports missing values rather than supplying defaults.

## 4. Expected Effect and Limitations

The formulation exposes route choices, activity capacities, and scheduling assignments directly as linear constraints, avoiding much of the implicit linearization associated with conditional element lookups. Splitting SOS choices also limits the number of combined movement alternatives.

No dominance pruning, symmetry-breaking restriction, or additional objective cutoff was introduced. The intended benefit is a clearer formulation for HiGHS, but **compilation, numerical equivalence, and runtime improvements have not been experimentally established in this conversation**.

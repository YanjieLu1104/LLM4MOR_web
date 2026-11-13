# Liner-Shipping Fleet Repositioning: Model and Reformulation

## 1. Real-world background

The model represents a **liner-shipping fleet repositioning problem**: five vessels leave their current services and join a new service at a common destination port. Each vessel chooses a departure opportunity and a phase-in week. The five vessels must join in distinct, consecutive weeks, consistent with establishing a weekly service.

Three repositioning modes are represented:

1. **Direct sailing** from the selected departure opportunity to the phase-in port.
2. **SOS activity**, apparently an intermediate service or sailing opportunity that earns savings but requires sailing before and afterward.
3. **Equipment sailing**, an intermediate activity with fixed costs and adjustable sailing durations for three legs.

The instance contains 13 candidate phase-in ports and 11 weeks. Its dimensions and numerical tables are embedded in the original file, so it is self-contained despite the general external-data interface described in the task.

## 2. Original model structure

### Variables

The original model declares **81 independent bounded integer variables**, together with a defined integer objective:

- Five departure-opportunity variables and one common phase-in port.
- Five phase-in weeks and five repositioning-mode choices.
- Per-vessel SOS activity, SOS identifier, savings, and before/after sailing costs.
- Per-vessel equipment activity, three fixed-cost components, and three sailing durations.
- Five direct-sailing costs.

Departure opportunities are vessel-specific and use zero-based indices. Activity value zero denotes no activity.

### Constraints

The formulation combines conditional constraints, variable-indexed table lookups, and global constraints:

- **Mode-dependent accounting:** each repositioning mode activates its associated costs and activities and sets unrelated components to zero.
- **Activity compatibility:** SOS identifiers are determined by the selected SOS activities. Positive SOS and equipment activities imply their corresponding repositioning modes.
- **Exclusivity:** `alldifferent_except_0` prevents reuse of nonzero activities and SOS identifiers.
- **Timing:** total equipment sailing duration cannot exceed the interval between departure and phase-in. For equipment repositioning, each leg has tabulated minimum and maximum durations, and their sum must equal the smaller of the total maximum duration and the available interval.
- **Phase-in scheduling:** all phase-in weeks are distinct, and their maximum minus minimum equals four. Thus the five weeks form a consecutive block.
- **Cost limits:** two separate expressions must be strictly below 500,000. The first includes direct costs, SOS savings **with a positive sign**, and SOS sailing costs. The second includes equipment fixed costs and duration-dependent terms.

Negative table entries can exclude choices because the corresponding cost variables have nonnegative domains.

### Objective

The model **minimizes** total repositioning cost, comprising:

- 66 times each vessel’s departure-to-phase-in interval;
- direct sailing costs;
- SOS sailing costs minus SOS savings;
- equipment fixed costs;
- equipment duration terms with coefficient −1138 per vessel.

The objective itself is constrained to be nonnegative. Both this restriction and the two separate strict cost limits are retained in the reformulation.

## 3. Reformulation and justification

### Elimination of infeasible SOS modes

Every entry in the fixed SOS after-sailing cost table is −1 for a positive activity. In the original model:

1. Repositioning mode 2 requires a positive SOS activity.
2. That mode equates the after-sailing cost to the selected table entry.
3. The after-sailing cost variable is nonnegative.

Therefore mode 2 would require a nonnegative variable to equal −1 and is impossible. The reverse activity implications then force SOS activities and identifiers to zero. The remaining mode constraints force SOS savings and both sailing-cost components to zero as well.

The reformulated model retains these original variables and explicitly fixes them to their implied values.

### Multiple-choice MILP formulation

For each vessel, preprocessing enumerates alternatives consisting of:

- a departure opportunity;
- a phase-in port;
- a phase-in week;
- either direct sailing or the equipment activity.

A binary variable selects each alternative, and exactly one alternative is selected per vessel. Linear equations connect the selections to the original decisions, fixed costs, direct costs, and elapsed times.

This replaces conditional, variable-indexed relationships with a **multiple-choice extended formulation** designed for HiGHS. Its linear relaxation directly links the attributes of each alternative, rather than relying on separate conditional table relations.

### Feasibility-based alternative filtering

Alternatives are removed only for conditions implied by the original constraints:

- **Phase-in before departure:** impossible because the original timing inequality has a nonnegative duration sum on its left-hand side.
- **Negative active costs:** impossible because the selected table value must equal a nonnegative cost variable.
- **Insufficient equipment sailing time:** impossible when the sum of the three minimum leg durations exceeds the available departure-to-phase-in interval.

No cost-dominance assumption is used to remove otherwise feasible alternatives.

For every retained equipment alternative, the required total duration is precomputed using the original minimum-of-two-values equation. The three individual duration variables remain, with their original bounds and prescribed total. Consequently, feasible allocations of time among the legs are preserved.

### Explicit scheduling and capacity equations

The common phase-in port is represented by a one-hot selection. Each vessel’s alternative selections must agree with it.

The consecutive-week requirement is represented by selecting one possible five-week block. Week-occupancy equations require exactly one vessel in each selected week and none outside the block. This is equivalent to the original distinctness and span constraints: five distinct integer weeks spanning four weeks necessarily occupy every week in that interval.

There is only one positive equipment activity. Hence `alldifferent_except_0(seAct)` is equivalent to:

\[
\sum_v seAct_v \leq 1.
\]

With SOS excluded, the original mode/activity implications also yield:

\[
reposType_v = 1 + 2\,seAct_v.
\]

These relationships are imposed directly.

### Lossless data compression and solution mapping

Repeated fixed tables are expressed through comprehensions and run-length decoding. This changes their representation, not their values, index domains, or vessel/port correspondences.

The mapping script returns the original independent decision variables and excludes reformulation auxiliaries. It copies retained decisions from the default DZN solution and reconstructs omitted fixed SOS arrays as zero using the infeasibility argument above.

## 4. Expected computational effect

The reformulation removes an impossible mode, filters locally infeasible alternatives before solving, and exposes scheduling and activity capacities as linear equations. These changes are intended to reduce conditional-constraint overhead and strengthen the MILP relaxation.

No solve-time measurements were supplied, so the computational improvement remains an expectation rather than a demonstrated benchmark result.

## Project Planning with Internal Capacity and Outsourcing

### Problem background

The model represents a small project-planning problem with **13 tasks scheduled over 13 calendar days, numbered 17–29**. Each task is assigned to one day and is either performed internally or outsourced. This interpretation follows from the model’s resource updates: a task consumes internal capacity precisely when its `chooseBool` variable is false; when true, it contributes to outsourcing costs instead.

The task workloads are **[3, 1, 2, 2, 1, 1, 2, 3, 4, 3, 1, 1, 4] hours**. Available internal capacity varies by day, including days with zero capacity. Eight precedence relations impose minimum separations between particular task dates, regardless of whether those tasks are outsourced.

Workloads are charged entirely to the assigned day; the model does not describe continuous, multi-day task execution. Nor does it impose a capacity limit on outsourced work.

### Original model structure

The source declares **826 scalar variables**: 554 without declaration-time definitions and 272 defined auxiliary variables. Although many of the 554 are determined by constraints, they must still be reconstructed under the solution-mapping contract.

The main scheduling decisions are:

- **13 integer day variables**, each ranging from 17 to 29.
- **13 Boolean mode variables**, with true indicating outsourcing.

The remaining variables encode an automatically generated procedural calculation:

- Calendar indices and day-number lookups.
- Daily internal workloads after each successive task assignment.
- Capacity lookups and conditional feasibility checks.
- Outsourcing counts and intermediate task ranks.
- Lookup chains that recover tasks from those ranks.
- Distinct outsourcing-day indicators and accumulated costs.

The constraints use conditional updates, variable-index array lookups, reified comparisons, and arithmetic equalities. Some arithmetic constraints are duplicated verbatim apart from multiplication by one.

The model minimizes `ite553`, which is equivalent to

\[
5\,\bigl|\{\text{days containing outsourced tasks}\}\bigr|
+2\sum_{\text{outsourced tasks }t}p_t,
\]

where \(p_t\) is task \(t\)’s workload. The original distinct-day expressions count the first outsourced task on each date. Its rank-update mechanism places outsourced tasks first, preserving their original order; the subsequent lookups therefore accumulate the workloads of exactly those tasks.

### Reformulation and justification

The reformulation replaces the procedural encoding with a **time-indexed binary mixed-integer formulation** designed for HiGHS. It preserves the original task identities, calendar dates, workloads, capacities, precedence relations, objective values, and minimization direction.

#### Task/day/mode assignment formulation

Two binary variables are introduced for each task–day pair: one for internal execution and one for outsourcing. Their sum over all days is one for each task. Linear equalities recover the original day and Boolean decisions.

This is an exact representation: every original task has exactly one date and one mode, and every binary assignment determines those same choices.

#### Aggregated daily capacity constraints

The original model adds each internal task’s workload to its selected day and checks that day’s updated load against capacity. These sequential checks are replaced by one constraint per day:

\[
\sum_t p_t x^{\mathrm{internal}}_{td}\le C_d.
\]

This is equivalent because workloads are positive and updates only add work. A feasible final load implies that every intermediate load was feasible. Conversely, the original check after the last internal assignment to a day bounds that day’s final load; an unused day has load zero.

#### Direct outsourcing-cost calculation

A binary variable indicates whether each day contains any outsourced task. Each external assignment implies that the day is used, and a reverse inequality prevents a day from being marked used without an external assignment.

These constraints make the indicator exact, rather than relying on minimization to remove unnecessary charges. The hourly cost is computed directly from the outsourcing Booleans and fixed workloads. This removes the nested distinct-day expressions, stable-partition ranks, and duration-lookup chains from the optimization model.

The equivalence follows from their original roles: the distinct-day expressions count each occupied outsourcing date once, while the rank and lookup calculations enumerate every outsourced task once.

#### Preprocessing and valid inequalities

The formulation also includes the following strengthening techniques:

- **Impossible-assignment fixing.** An internal assignment is fixed to zero whenever its task workload exceeds that day’s capacity. Even that task alone would violate the original capacity check.
- **Cumulative precedence cuts.** For a precedence relation \(s_v\ge s_u+\ell\), assigning the successor by date \(k\) requires assigning the predecessor by \(k-\ell\). Prefix-sum inequalities over assignment binaries express this implication and strengthen the linear relaxation. They apply to both modes because the original precedence constraints are unconditional.
- **Pairwise capacity-cover inequalities.** Two tasks whose combined workload exceeds a day’s capacity cannot both execute internally on that day. These inequalities follow directly from the daily capacity constraint and nonnegative resource consumption.
- **Aggregate outsourcing-workload bound.** Total workload is 28 hours, while total internal capacity is 20 hours. Summing the daily capacity constraints therefore proves that at least **8 hours must be outsourced**.

### Reconstruction and expected benefit

The accompanying mapping script reconstructs all 554 original variables declared without initializers from the retained scheduling decisions and unchanged instance data. It replays the original workload updates, rank updates, lookup chains, and cost accumulation, preserving their meanings rather than assigning arbitrary auxiliary values.

The main expected benefit is a smaller and more explicit linear optimization structure, with fewer conditional calculations and variable-index lookups. The added inequalities strengthen the relaxation available to HiGHS. **No measured runtime improvement is claimed**, since no comparative solver timings were reported.

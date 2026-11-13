# Project Planning with Internal Capacity and Outsourcing

## Problem background

The model represents a small project-planning problem with **12 tasks scheduled over 12 days**, identified by calendar values 16–27. Each task is assigned to one day and is either performed internally or outsourced.

This interpretation follows from the model’s resource and cost calculations:

- Internally performed tasks consume daily working-hour capacity.
- Outsourced tasks do not consume that capacity.
- Outsourcing incurs a charge of **two units per task-hour**, together with a **five-unit charge for each distinct day on which outsourcing occurs**.
- Eight precedence inequalities impose minimum day separations between specified tasks, regardless of whether they are performed internally or outsourced.

Task workloads are `[3,1,2,2,1,1,2,3,4,3,1,1]`, totaling 24 hours. Daily internal capacities are `[2,4,0,1,2,0,0,2,4,0,1,2]`, totaling 18 hours. A workload is charged entirely to its assigned day; the model does not represent tasks occupying consecutive days.

## Original model structure

### Variables

The source declares **715 scalar variables**: 244 Boolean variables and 471 bounded integer variables. Of these, 233 have defining expressions, while 482 are declared without such expressions.

The substantive scheduling choices are:

- Twelve `chooseDay...` variables, each selecting a calendar day from 16–27.
- Twelve `chooseBool...` variables, where `true` denotes outsourcing.

The remaining variables encode intermediate calculations:

- Day indices and selected daily capacities.
- Daily internal loads after processing each successive task.
- Counts and ranks used to place outsourced tasks before internal tasks.
- Inverse rank lookups and corresponding task durations.
- Indicators identifying the first outsourced task on each distinct day.
- Successive partial objective values.

Although many auxiliaries are declared without defining expressions, the constraints determine them from the scheduling choices.

### Constraints

The generated formulation uses element lookups, conditional updates, reified comparisons, and arithmetic equalities.

**Internal capacity.** Tasks are processed in a fixed order. An internal task adds its workload to its assigned day’s load; an outsourced task leaves all loads unchanged. After each internal addition, the updated load must not exceed that day’s capacity.

**Precedence.** Eight inequalities relate assigned day numbers. They include both non-strict ordering and minimum separations of one or two days. These constraints are unconditional: outsourcing does not remove them.

**Task ordering and lookup.** A sequence of conditional rank updates constructs a stable partition: outsourced tasks come first, preserving their original order, followed by internal tasks, also preserving their order. Further conditional expressions invert this ordering to retrieve durations for the cost calculation.

Several arithmetic equalities are duplicated in the generated source.

### Objective

The model minimizes `ite481`, the final accumulated outsourcing cost. Its expanded calculation is equivalent to

\[
2\sum_{t=1}^{12} p_t o_t
+
5\sum_{d=1}^{12} u_d,
\]

where \(p_t\) is task workload, \(o_t\) indicates outsourcing, and \(u_d\) indicates that at least one outsourced task is assigned to day \(d\).

The original search annotations branch first on outsourcing choices and then on assigned days.

## Reformulation and justification

### 1. Time-indexed binary assignments

The reformulation introduces two binary assignment variables for every task–day pair: one for internal execution and one for outsourcing. Exactly one of these assignments is selected for each task.

The selected assignment determines both its day index and outsourcing flag. This is an exact representation of the original pair of choices, not a restriction on them. It exposes assignment and resource constraints directly as linear equations and inequalities for HiGHS.

### 2. Aggregate daily capacity constraints

The sequential load-update mechanism is replaced by one capacity inequality per day:

\[
\sum_t p_t x^{\mathrm{internal}}_{td}\le C_d.
\]

This replacement is valid because the original loads start at zero and increase only by positive task workloads. Consequently:

- If the final load satisfies capacity, every intermediate load also satisfies capacity.
- If every original incremental check holds, the final load satisfies capacity: its last increase was checked, and subsequent outsourced tasks do not change it.

Thus, aggregate capacity constraints preserve exactly the feasible internal assignments.

### 3. Capacity-based assignment preprocessing

An internal assignment is fixed to zero whenever \(p_t>C_d\).

The original model cannot permit such an assignment: the load before adding the task is nonnegative, so adding that task alone would exceed capacity. This preprocessing also excludes all internal assignments on zero-capacity days.

### 4. Direct outsourcing-day indicators

The nested “first occurrence on a day” expressions are replaced by a binary indicator for each day. Linking constraints make this indicator one **if and only if** at least one external assignment uses the day.

The original first-occurrence calculation counts each distinct outsourcing day exactly once. Therefore, summing the new indicators gives the same fixed-charge component for every feasible schedule.

### 5. Elimination of rank-based objective calculations

The original rank updates place all outsourced tasks in the first positions of a permutation. The subsequent inverse lookups retrieve the durations in those positions, and the accumulated cost includes precisely as many positions as there are outsourced tasks.

Therefore, the duration contribution is exactly twice the sum of outsourced task workloads. Replacing the rank construction, inverse lookups, and conditional cost accumulation with this weighted sum preserves the objective value for every schedule.

A mapping script reconstructs all 482 original variables declared without defining expressions, including these intermediate calculations.

### 6. Cumulative precedence inequalities

The original day-separation inequalities are retained. Additional cumulative assignment inequalities strengthen their linear relaxation.

For a precedence relation \(a\rightarrow b\) with lag \(\ell\), and each day threshold \(q\), the formulation requires

\[
\sum_{d\le q}x_{bd}
\le
\sum_{d\le q-\ell}x_{ad},
\]

where \(x_{td}\) combines internal and external assignment.

This is valid because assigning task \(b\) by day \(q\) requires task \(a\) to occur by day \(q-\ell\). If \(b\) occurs later, the left side is zero and the inequality imposes no additional restriction. These inequalities therefore exclude no feasible integer schedule, while potentially tightening fractional solutions.

### 7. Aggregate workload lower bound

The reformulation adds the redundant inequality

\[
\sum_t p_t o_t \ge 24-18=6.
\]

Every task must be either internal or outsourced. Summing daily capacity constraints bounds total internal workload by 18 hours, whereas total task workload is 24 hours. At least six hours must therefore be outsourced. This bound is a consequence of the original constraints; it does not assert that six outsourced hours are sufficient once precedence and daily packing are considered.

## Expected computational effect

The reformulation replaces a large generated network of conditional updates and variable-index lookups with a structured mixed-integer linear formulation. Capacity preprocessing removes impossible assignments, while cumulative precedence inequalities and the workload bound provide explicit strengthening.

The fixed instance data, task identities, precedence requirements, objective values, and minimization direction are preserved. The expected benefit is a simpler formulation and a stronger relaxation for HiGHS; no measured runtime improvement is claimed.

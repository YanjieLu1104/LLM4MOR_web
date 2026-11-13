## Project-planning model: background and reformulation

### 1. Inferred application

The model represents a small project with **12 tasks scheduled over 12 calendar days, numbered 16–27**. Each task is assigned to one day and can be performed either:

- **internally**, consuming that day’s limited working-hour capacity; or
- **externally**, avoiding internal capacity consumption but incurring a cost.

This interpretation follows from the constraints: a false `chooseBool` adds the task’s duration to internal daily workload, while a true value contributes to the objective.

Task durations are **[3, 1, 2, 2, 1, 1, 2, 3, 4, 3, 1, 1]** hours. Daily internal capacities are **[2, 4, 0, 1, 2, 0, 0, 2, 4, 0, 1, 2]** hours. A task’s entire duration is charged to its assigned day; the model does not schedule within-day start times or split tasks across days.

Seven precedence inequalities impose minimum day separations between specified tasks. These apply **regardless of whether the tasks are performed internally or externally**. External work has no explicit daily capacity limit.

### 2. Original formulation

The substantive scheduling decisions are **12 integer day choices and 12 Boolean work-mode choices**. The automatically generated formulation surrounds these decisions with numerous bounded integer and Boolean intermediate variables.

Its main components are:

- **Day lookup:** element constraints translate calendar dates into positions in the daily-capacity array.
- **Sequential workload updates:** tasks are processed in their original order. An internal task increases the workload of its chosen day; an external task leaves workloads unchanged. After an internal assignment, the updated workload must not exceed that day’s capacity.
- **Precedence:** seven inequalities link the selected day positions, with minimum separations of zero, one, or two days.
- **External-task bookkeeping:** conditional rank updates place externally assigned tasks before internally assigned tasks. Inverse-rank lookups then recover task durations for the cost calculation.
- **Distinct-day bookkeeping:** nested Boolean expressions identify the first externally assigned task on each date, thereby counting external-work dates once.

The model **minimizes**
\[
5\,\bigl|\{\text{dates containing external work}\}\bigr|
+2\sum_{\text{externally assigned tasks }t}p_t,
\]
where \(p_t\) is task duration. The original objective is evaluated through a long chain of intermediate accumulators.

### 3. Reformulation and validity

#### Direct task–day assignment formulation

The new model introduces binary variables indicating whether each task is assigned internally or externally on each day. An exactly-one constraint selects one task–day–mode combination. Linear channeling equations preserve the original calendar-day and Boolean decisions.

This is an exact representation of the original choices: every original assignment selects one binary combination, and every feasible binary assignment determines one original day and mode.

#### Aggregated daily capacities

The sequential workload-update constraints are replaced by
\[
\sum_t p_t x^{\mathrm{internal}}_{td}\le C_d
\quad\text{for every day }d.
\]

This is equivalent because all task durations are positive and the original updates only add internal workload. Consequently, every intermediate workload is bounded by the final workload. Conversely, the original capacity check after the last internal addition to a day bounds that day’s final total.

#### Direct external-work costs

A binary activation variable represents whether a day contains any external task. Assignment-to-activation inequalities, together with the reverse aggregate inequality, make this indicator exact.

The objective directly sums activated-day charges and external-task duration charges. This replaces the original first-occurrence and rank/inverse-rank calculations without changing their result: the former counts distinct external dates, and the latter enumerates externally assigned tasks.

#### Capacity-based preprocessing and valid inequalities

The reformulation adds several logically implied restrictions:

- **Infeasible internal assignments:** an internal assignment is fixed to zero when its task duration exceeds the day’s capacity. The original workload update would otherwise exceed capacity even with no other internal work.
- **Pairwise capacity covers:** two tasks cannot both be internal on a day if their combined duration exceeds its capacity. This follows directly from the daily workload inequality and nonnegative contributions from other tasks.
- **Aggregate workload bound:** external workload must be at least total duration minus total internal capacity. Here, these totals are 24 and 18 hours, so at least 6 hours must be external.
- **Duration-threshold packing cuts:** for each positive integer threshold \(q\), day \(d\) can accommodate at most \(\lfloor C_d/q\rfloor\) internal tasks of duration at least \(q\). Summing these bounds is valid because tasks are indivisible and each such task consumes at least \(q\) hours.

#### Cumulative precedence strengthening

For every precedence relation \(s\ge p+\ell\) and date cutoff \(D\), the model requires the indicator that the successor occurs by \(D\) to be no greater than the indicator that the predecessor occurs by \(D-\ell\).

These inequalities follow from the original precedence relation. They preserve integer-feasible schedules while strengthening the linear relaxation of the assignment formulation.

### 4. Intended computational benefit and solution recovery

The reformulation replaces nested conditional expressions, variable-index lookups, and sequential state updates with a predominantly linear binary formulation suited to **HiGHS**. The additional inequalities aim to improve relaxation strength and reduce search; no measured speedup is asserted.

The supplied mapping script reconstructs all original independent scalar variables, including intermediate workloads, ranks, lookup results, and objective accumulators, from the retained day and work-mode decisions.

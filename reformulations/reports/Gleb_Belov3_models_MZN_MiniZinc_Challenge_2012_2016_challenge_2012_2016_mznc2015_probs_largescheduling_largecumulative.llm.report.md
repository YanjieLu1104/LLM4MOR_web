## Problem background

The model represents **non-preemptive scheduling on a shared, capacity-limited resource**. Each task has a fixed duration `d[i]` and resource demand `r[i]`. Once a task starts, it runs continuously for its duration, consuming that amount of resource. Tasks may overlap provided their combined demand does not exceed capacity `capa`.

This structure can describe production jobs sharing equipment capacity or computing jobs sharing processors or memory. The model does not specify an application, release dates, or precedence relations. Its source describes a scalability benchmark for cumulative scheduling with many tasks and large durations.

## Original formulation

The model contains:

- `n_tasks` integer start-time variables `s[i]`, each bounded between zero and `horizon`, where `horizon` is the sum of task durations.
- One defined integer makespan variable:
  \[
  \text{objective}=\max_i(s[i]+d[i]),
  \]
  also bounded between zero and `horizon`.
- One global `cumulative` constraint enforcing the shared-resource capacity.
- An explicitly redundant family of completion-time constraints:
  \[
  s[i]+d[i]\le \text{objective}.
  \]

The objective is to **minimize the makespan**, the latest task completion time. The original search annotation selects start times in input order and tries their smallest values first.

## Reformulation and justification

### 1. Identify resource-consuming tasks

For nonnegative durations, demands, and capacity, the reformulation derives the set of tasks with both positive duration and positive demand.

Only these tasks need to appear in resource-overlap calculations: a zero-duration task occupies no time interval, and a zero-demand task consumes no resource. Their start variables and completion-time constraints remain in the model, so their contribution to the makespan is preserved.

The specialized formulation is guarded by a check that durations, demands, and capacity are nonnegative. Otherwise, the model retains the original `cumulative` constraint rather than applying deductions that require those conditions.

### 2. Replace cumulative capacity with task-start checks

Resource usage is checked at the start of each resource-consuming task. Another task contributes to that check precisely when
\[
s[j]\le s[i]<s[j]+d[j].
\]

For nonnegative demands, usage can increase only when a task starts; task completions can only decrease it. Consequently, any capacity violation must also be present immediately after some resource-consuming task starts. Checking these events is therefore sufficient to enforce capacity throughout the schedule.

This is an **event-based reformulation** with at most quadratic pairwise overlap tests. Its size depends on the number of tasks rather than the numerical time horizon, which is useful for a benchmark with large durations.

### 3. Extract incompatible task pairs

For two positive-duration tasks satisfying
\[
r[i]+r[j]>\text{capa},
\]
the reformulation explicitly enforces
\[
s[i]+d[i]\le s[j]
\quad\lor\quad
s[j]+d[j]\le s[i].
\]

This disjunction follows directly from the original cumulative constraint: the two tasks cannot overlap without exceeding capacity, even if no other task is running. Once non-overlap is enforced, their mutual overlap tests can be omitted from the task-start capacity sums.

### 4. Add an energy lower bound

When capacity is positive, the model adds
\[
\text{objective}\ge
\left\lceil
\frac{\sum_i d[i]r[i]}{\text{capa}}
\right\rceil.
\]

Every resource-consuming task starts at or after zero and finishes by the makespan. Its resource usage integrated over time is `d[i] * r[i]`. Since the original capacity constraint limits total usage to `capa` at every instant, the schedule can supply at most `capa * objective` units of resource-time. This proves the bound.

### 5. Add demand-threshold workload bounds

For each distinct positive task demand \(q\le\text{capa}\), the model adds
\[
\text{objective}\ge
\left\lceil
\frac{\sum_{i:r[i]\ge q}d[i]}
{\lfloor\text{capa}/q\rfloor}
\right\rceil.
\]

At most \(\lfloor\text{capa}/q\rfloor\) tasks demanding at least \(q\) can run simultaneously; any larger number would violate the original capacity constraint. Integrating this limit over the makespan bounds the total duration of those tasks and establishes the inequality. These are **resource-derived workload cuts** that can strengthen the optimization relaxation.

## Preservation and solution mapping

The reformulation preserves the external data interface, all original start-time variables, the exact makespan definition, and the minimization direction. It introduces no symmetry-breaking restrictions or assumptions about task order.

The accompanying mapping script copies `s` directly from the reformulated solution. It need not reconstruct `objective`, because the original model defines that value from the start times and durations. The added bounds are valid consequences of the original constraints; their practical speed benefit remains instance- and backend-dependent.

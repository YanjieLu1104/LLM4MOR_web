# Multi-Skilled Project Scheduling: Model and Reformulation

## 1. Problem background

The model schedules project activities using workers with different skill sets. Each activity has a fixed duration, may require several skills, and may have predecessor activities that must finish before it starts. Workers are assigned to activities and cannot perform overlapping activities.

An important modeling detail is that a multi-skilled worker contributes to **every required skill they possess** on an assigned activity. The model does not allocate a worker exclusively to one skill within that activity. Assignments also remain unchanged throughout the activity.

The goal is to minimize project duration, measured by the completion times of activities with no listed successors.

## 2. Original formulation

### Data and decision variables

The input describes workers and their skills, activity durations, skill requirements, and immediate successor sets. The start-time horizon is `0 .. tmax`, where `tmax` is the sum of all activity durations.

The independent decision variables are:

- `s[i]`: integer start time of activity \(i\);
- `w[j,i]`: Boolean indicating whether worker \(j\) is assigned to activity \(i\);
- `objective`: integer project-duration variable.

Thus, the original model declares `n_tasks + 1` integer variables and `n_workers × n_tasks` Boolean variables, excluding auxiliaries introduced during compilation.

### Constraints

1. **Precedence.** Each listed successor starts no earlier than the completion of its predecessor:
   \[
   s_i+d_i\le s_j.
   \]

2. **Skill coverage.** For every positive skill requirement, the number of assigned workers possessing that skill must meet the requirement. Workers with no skill positively required by an activity are forbidden from being assigned to it.

3. **Worker availability.** For each worker with more than one eligible activity, a cumulative constraint imposes capacity one. An activity consumes one unit of that worker’s capacity precisely when the worker is assigned to it.

4. **Skill-based pairwise non-overlap.** Some activity pairs are explicitly ordered when their combined demand for a skill exceeds the number of workers possessing that skill. These constraints apply to pairs without a direct precedence relationship.

5. **Aggregate skill capacity.** Selected cumulative constraints limit simultaneous demand for each skill to the number of workers possessing it.

6. **Project duration.** Every activity with an empty successor set must finish by `objective`.

The solve item **minimizes `objective`**. The original source also supplies a sequential search annotation for start times, assignments, and objective.

## 3. Reformulation and justification

The reformulation targets the HiGHS mixed-integer programming backend. It preserves the original data interface and decision variables.

### Eligibility preprocessing

The model precomputes each worker’s eligible activities: those requiring at least one skill the worker possesses. These sets reproduce the eligibility test already used by the original model.

Skill-coverage sums are simplified to range directly over workers possessing the required skill. This is equivalent because, whenever that skill’s requirement is positive, every worker possessing it is necessarily eligible. Assignments outside the eligible sets remain fixed to false.

### Linear worker non-overlap with shared ordering variables

For a worker whose eligible activities all have **strictly positive durations**, the capacity-one cumulative constraint is replaced by assignment-conditional pairwise non-overlap inequalities.

This replacement is exact: with positive durations and unit resource consumption, capacity one holds if and only if every pair of assigned activities has non-overlapping execution intervals.

An ordering Boolean is shared across workers for each relevant activity pair. Sharing is valid because the activities have common start times regardless of which workers are assigned. Whenever non-overlap is required, one temporal order can therefore satisfy all affected workers.

Additional worker-specific inequalities are unnecessary when:

- a direct precedence constraint already orders the pair; or
- an existing skill-based pairwise constraint already requires non-overlap.

The original worker cumulative constraint is retained whenever the worker’s eligible set contains a nonpositive duration. This avoids extending the positive-duration equivalence to exceptional cases.

### Bound-derived big-M coefficients

Both the original unconditional pairwise disjunctions and the new assignment-conditional disjunctions are expressed as linear inequalities.

For an inequality ordering activity \(i\) before activity \(j\), the model uses
\[
M_i=\max(0,\ tmax+d_i).
\]
This follows from the original bounds \(0\le s_i,s_j\le tmax\), which imply
\[
s_i+d_i-s_j\le tmax+d_i.
\]
Consequently, the inactive branch is genuinely nonrestrictive. These coefficients require neither a new scheduling assumption nor an externally supplied bound.

### Removal of implied skill cumulative constraints

An aggregate skill cumulative constraint is removed only when all its participating activities have strictly positive durations.

Its validity follows from two retained requirements:

1. Skill coverage assigns at least the required number of workers possessing the skill to each activity.
2. Worker availability prevents any worker from serving two simultaneously active, positive-duration activities.

At any time, these assigned worker sets are therefore disjoint across active activities. Their total size cannot exceed the number of workers possessing the skill, so total skill demand cannot exceed that same capacity.

The original skill cumulative constraint is retained when any participating activity has a nonpositive duration.

### Preserved objective and solution correspondence

The reformulation retains the original terminal-activity makespan constraints rather than adding completion bounds for every activity. It therefore does not assume that the precedence graph is acyclic or that every activity reaches a terminal activity.

The CP-oriented search annotation is omitted for the MIP-targeted formulation; the minimization objective is unchanged. No symmetry breaking, critical-path bounds, or additional scheduling assumptions are introduced.

Finally, the mapping script returns the unchanged original variables `s`, `w`, and `objective`, excluding ordering auxiliaries. No schedule reconstruction is needed.

These changes aim to give HiGHS a more explicit linear formulation and avoid redundant global-constraint decompositions. Their runtime benefit remains instance-dependent; no empirical speedup was established in this exchange.

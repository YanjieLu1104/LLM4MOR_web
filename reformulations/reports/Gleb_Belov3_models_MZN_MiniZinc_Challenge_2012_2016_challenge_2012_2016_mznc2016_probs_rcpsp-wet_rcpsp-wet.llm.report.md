# Resource-Constrained Project Scheduling with Earliness/Tardiness Costs

## Problem background

The model schedules tasks that compete for limited renewable resources, such as workers, machines, or equipment. Each task has a fixed duration, resource requirements, and a desired start time. Successor relationships specify that certain tasks cannot start until their predecessors finish.

Starting a task before or after its desired time incurs a task-specific weighted penalty. The goal is therefore to balance resource availability and precedence requirements against the cost of deviating from preferred start times.

The planning horizon bounds **start times**, not completion times: a task may finish after the latest permitted start time.

## Original model

The original model declares `|Tasks| + 1` integer decision variables:

- `s[i]`: the start time of task \(i\), in \(0,\ldots,t_{\max}-1\).
- `objective`: the total scheduling penalty, with the explicit bounds given in the source.

Its constraints comprise:

1. **Precedence constraints:** for every declared successor \(j\) of task \(i\),
   \[
   s_i+d_i\le s_j.
   \]

2. **Pairwise non-overlap constraints:** if two tasks’ combined requirement exceeds the capacity of any resource, the model requires one task to finish before the other starts. These constraints appear inside a `redundant_constraint` wrapper in the original.

3. **Conditional cumulative resource constraints:** for each resource, only tasks with positive duration and positive requirement participate. A cumulative constraint is posted when this set is nonempty and its total requirement exceeds capacity.

4. **Exact objective equality:**
   \[
   \text{objective}
   =
   \sum_i\left[
   w_i^E\max(0,a_i-s_i)
   +
   w_i^T\max(0,s_i-a_i)
   \right],
   \]
   where \(a_i\) is the desired start time and \(w_i^E,w_i^T\) are the supplied weights.

The objective is minimized. No numerical instance data were supplied, so numerical variable and constraint counts cannot be reported.

## Reformulation and justification

### Time-indexed binary formulation

The reformulation introduces a binary indicator \(x_{it}\) for every task and permitted start time. It imposes
\[
\sum_t x_{it}=1,
\qquad
s_i=\sum_t t\,x_{it}.
\]

These equations establish an exact correspondence between an original integer start time and a single selected time slot. The original `s` and `objective` variables remain available with their original meanings and bounds.

This adds `|Tasks| × |Times|` binary variables but exposes scheduling decisions directly to the HiGHS mixed-integer linear solver.

### Direct precedence-bound preprocessing

Impossible start indicators are fixed to zero using immediate precedence relationships.

- If \(j\) precedes \(i\), then \(s_j\ge0\) and \(s_j+d_j\le s_i\) imply \(s_i\ge d_j\). Taking the maximum over immediate predecessors gives a valid lower bound.
- If \(i\) has a successor \(j\), then \(s_j\le t_{\max}-1\) and \(s_i+d_i\le s_j\) imply
  \[
  s_i\le t_{\max}-1-d_i.
  \]

Both bounds are intersected with the original start-time domain. These deductions require no assumption that all durations are positive. The original precedence inequalities are retained.

### Cumulative-start precedence inequalities

For each precedence arc \(i\to j\) and time \(t\), the reformulation adds
\[
\sum_{u\le t}x_{ju}
\le
\sum_{u\le t-d_i}x_{iu}.
\]

If task \(j\) starts by \(t\), precedence requires task \(i\) to start by \(t-d_i\). Otherwise the left-hand side is zero and the inequality is automatically satisfied.

These are valid strengthening inequalities: they preserve every feasible integer schedule while restricting fractional start distributions in the LP relaxation.

### Linear resource-capacity constraints

The cumulative constraints are replaced by time-indexed capacity rows:
\[
\sum_{\substack{i,u\\u\le t<u+d_i}}
r_{ri}x_{iu}\le c_r.
\]

The reformulation preserves the original filtering of participating tasks and the original condition determining whether a resource constraint is posted.

This replacement is exact because starts and durations are integral, so resource usage changes only at integer times. Checks beyond the latest permitted start are unnecessary: after that point, no task can begin, and usage can only decrease because every participating duration and requirement is positive. Thus the reformulation does **not** impose a new completion deadline.

### Time-indexed pairwise non-overlap

For each conflicting pair with positive durations, the reformulation requires that at most one task be active at each permitted time.

This is equivalent to the original non-overlap disjunction: two positive-length intervals with integer endpoints overlap only if they share an integer time slot. Any overlap starts at the later task start, which lies within the checked start-time horizon.

When either duration is nonpositive, the original disjunction is retained rather than relying on an interval interpretation that might change its meaning.

### Exact linear objective

For every task and possible start time, the earliness/tardiness cost is computed from the supplied data. The objective becomes
\[
\text{objective}=\sum_{i,t}c_{it}x_{it}.
\]

Exactly one start indicator is selected per task, so this expression equals the original penalty function. The equality and original objective bounds are preserved. Unlike an epigraph-only formulation, this transformation does not require nonnegative penalty weights.

## Interface preservation and expected effect

All original external parameters, index domains, and data bindings remain unchanged. The mapping script copies only `s` and `objective` from the reformulated solution, preserving their encoded values and rejecting missing fields.

The main intended benefit is a linear, time-indexed MIP formulation with explicit capacity rows, preprocessed start choices, and stronger precedence inequalities. Its principal trade-off is size: a long planning horizon creates many binary variables and constraints. Consequently, faster solution times are plausible but were not established by benchmarking in this conversation.

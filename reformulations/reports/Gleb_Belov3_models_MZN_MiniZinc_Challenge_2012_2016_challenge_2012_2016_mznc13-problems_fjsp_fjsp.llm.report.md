## Flexible Job-Shop Scheduling: Model and Reformulation

### 1. Background and interpretation

The model represents a **flexible job-shop scheduling problem**. A manufacturing facility has several machines and jobs. Each job consists of ordered tasks, and each task has alternative processing options. An option specifies a machine and a processing duration.

The scheduler must choose processing options and task start times so that job precedences are respected and no machine processes overlapping selected tasks. Processing is non-preemptive: a selected operation occupies its machine for its full duration.

The objective is to minimize the **makespan**, represented by an upper bound on the completion time of each job’s last task. No particular instance data were supplied, so numerical model sizes and performance improvements cannot be reported.

### 2. Original formulation

#### Variables and bounds

The original model declares:

- `start[t]`: an integer start time for each of the `no_task` tasks.
- `dur[t]`: an integer duration for each task; tasks with identical alternative durations have a fixed duration.
- `b[o]`: a Boolean selection variable for each of the `no_optt` processing options.
- `objective`: an integer makespan variable.

The horizon `t_max` is the sum of the maximum alternative duration for every task. Start times also have task-specific bounds computed from minimum processing durations within their associated jobs. These original bounds are retained in the reformulation.

#### Constraints

The original constraints provide:

1. **Job precedence.** For each task index `i` in a job below that job’s last task index,
   \[
   start_i+dur_i\le start_{i+1}.
   \]
   The formulation explicitly uses the numerical successor `i+1`.

2. **Alternative selection.** Tasks with multiple options select exactly one, expressed originally through an at-most-one inequality and an existence constraint. A further Boolean equivalence is included for two-option tasks.

3. **Duration consistency.** Selecting an option fixes its owning task’s duration to the option’s processing time. An option whose owning task has only one alternative is forced selected.

4. **Machine capacity.** A capacity-one `cumulative` constraint is posted for each machine. Each option contributes its fixed duration and a resource requirement equal to its selection Boolean.

5. **Makespan bounds.** Every job’s final task must finish no later than `objective`.

The solve direction is **minimization**.

### 3. Reformulation and its justification

The changes target the **HiGHS mixed-integer backend**, using explicit linear scheduling constraints and additional valid inequalities.

#### Exact-one selection equations

The original at-most-one and existence constraints are combined into
\[
\sum_{o\in optts[t]} b_o=1
\]
for every task with multiple options.

This is equivalent because Boolean variables sum to at least one precisely when at least one is true. For two options, the same equation already implies that each Boolean is the negation of the other, so the separate equivalence is redundant.

#### Weighted duration equations with an ownership guard

For a task whose alternatives all identify that task as their owner, duration is expressed as
\[
dur_t=\sum_{o\in optts[t]}p_o b_o.
\]

For a multiple-option task, exactly one Boolean is true, and the original implication for that selected option fixes the duration to its processing time. The equation therefore has exactly the same effect. For an owned singleton alternative, the original model forces selection and already fixes the task duration to that option’s duration.

This replacement is guarded because the source does not explicitly require alternative sets to be disjoint: option ownership is defined using the minimum task index containing the option. Where the ownership condition fails, the original duration implications are retained.

#### Capacity-one disjunctive formulation

For machines whose option durations are all nonnegative, the cumulative constraint is replaced by pairwise ordering constraints.

Two selected positive-duration options on the same capacity-one machine must satisfy one of:
\[
s_a+p_a\le s_c,
\qquad
s_c+p_c\le s_a.
\]

Conversely, pairwise non-overlap ensures that no two selected positive-duration options consume machine capacity simultaneously. Thus these orderings are equivalent to the capacity-one cumulative constraint. Zero-duration options occupy no positive-length interval and need no conflict constraints.

Pairs sharing the same owning task are omitted: both options belong to that task’s alternative set, whose exact-one constraint prevents their simultaneous selection. Options assigned to machines outside the original `Mach` set remain unconstrained by machine capacity, as in the original model.

Machines containing negative option durations retain the original cumulative constraint rather than applying a reformulation that requires nonnegative durations.

#### Bound-based conflict elimination and big-M tightening

The reformulation intersects the original task-specific start bounds with the horizon bounds to obtain \(L_t\) and \(U_t\).

A pair requires no ordering variable if, for example,
\[
U_a+p_a\le L_c.
\]
Every allowed start-time assignment already places option \(a\) before option \(c\). The reverse ordering is tested similarly.

For remaining pairs, the formulation uses direction-specific coefficients such as
\[
M_{ac}=\max(0,U_a+p_a-L_c).
\]
This bounds the largest possible violation of the corresponding precedence inequality. The big-M term can therefore deactivate that inequality without excluding any assignment permitted by the original bounds. Using these coefficients avoids an unnecessarily loose common constant.

#### Guarded completion and machine-workload cuts

Additional inequalities are enabled only when:

- all option durations are nonnegative; and
- every job’s task set is a contiguous numerical interval.

Contiguity ensures that the original `i+1` precedences form a complete chain from each task to its job’s final task. Nonnegative durations then imply that every task finishes no later than that final task. Consequently,
\[
start_t+dur_t\le objective
\]
is valid for every task.

Under the same conditions, the selected workload on each machine satisfies
\[
\sum_{o:\,machine(o)=m}p_o b_o\le objective.
\]
Selected operations start at nonnegative times, finish by the makespan, and do not overlap on their machine. Their total processing time therefore cannot exceed the available interval from zero to the makespan.

These guards avoid assuming job contiguity or duration properties beyond those explicitly checked.

### 4. Interface and solution mapping

The original external parameter names, index domains, derived-data meanings, and objective direction are preserved. `start` and `dur` are explicitly declared decision arrays, with constraints reproducing their original bounds; this supports their inclusion in default DZN solution output.

The supplied mapping script copies `start`, `dur`, `b`, and `objective`, preserves their encoded array indices, and excludes auxiliary ordering variables. It reports missing required values rather than inventing them.

The reformulation aims to improve MIP solving through explicit disjunctions, fewer unnecessary conflicts, tighter big-M coefficients, and valid workload inequalities. Actual speedups remain instance-dependent and have not been established by timing experiments here.

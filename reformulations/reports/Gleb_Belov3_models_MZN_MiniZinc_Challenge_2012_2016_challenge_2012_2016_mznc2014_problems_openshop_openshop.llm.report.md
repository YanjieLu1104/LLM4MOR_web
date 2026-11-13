# Open-Shop Scheduling: Model and Reformulation

## Problem background

The model describes an **open-shop scheduling problem**. There are \(J=n_{\text{jobs}}\) jobs and \(M=n_{\text{machines}}\) machines. Every job has one operation on each machine, with a specified processing duration. Operations are non-preemptive: once started, an operation runs to completion.

Each machine can process at most one operation at a time, and each job can undergo at most one operation at a time. Unlike job-shop scheduling, there is **no prescribed order** for a job’s operations. The scheduler chooses both their order and start times.

This structure represents settings such as manufacturing or maintenance in which items require several different services, but those services may be performed in any order. The goal is to minimize the time needed to complete all operations.

## Original formulation

Let \(p_{jk}\) denote the supplied duration of job \(j\)’s operation on machine \(k\). The model enforces \(p_{jk}\ge 0\).

### Variables and bounds

The original model contains:

- \(JM\) integer start-time variables, `job_task_start[j,k]`;
- one integer makespan variable, `objective`;
- one local Boolean ordering variable for every pair of operations sharing a job or a machine.

The number of such conflicting pairs is
\[
P=J\binom{M}{2}+M\binom{J}{2}.
\]

The scheduling horizon is
\[
H=\sum_{j,k}p_{jk},
\]
and every start time lies in \([0,H]\). The objective lies between \(H\) and the lower bound
\[
L=\max\left\{
\max_j\sum_k p_{jk},
\max_k\sum_j p_{jk}
\right\}.
\]
More precisely, its domain is \([L,H]\). This lower bound follows because operations belonging to any one job, or using any one machine, must execute sequentially.

### Constraints and objective

The model imposes:

1. **Pairwise non-overlap:** for each conflicting pair \(a,b\), either
   \[
   s_a+p_a\le s_b
   \quad\text{or}\quad
   s_b+p_b\le s_a.
   \]
2. **Capacity-one cumulative constraints:** one for every job and one for every machine.
3. **Completion bounds:** every operation satisfies
   \[
   s_{jk}+p_{jk}\le C,
   \]
   where \(C\) is `objective`.
4. Explicit start-time nonnegativity constraints for some operations, although all start-time domains already enforce nonnegativity.

The objective is to **minimize \(C\)**. At an unconstrained optimum, this gives the latest operation completion time.

## Reformulation for HiGHS

### Explicit binary-order inequalities

The reformulation replaces the original Boolean implications with integer binary ordering variables. For each conflicting pair, \(x_{ab}=1\) selects operation \(a\) before operation \(b\):
\[
s_a+p_a\le s_b+H(1-x_{ab}),
\]
\[
s_b+p_b\le s_a+Hx_{ab}.
\]

This is an exact **big-\(M\) disjunctive reformulation**. The value \(H\) is valid because the retained completion constraints and objective domain imply
\[
s_a+p_a\le C\le H,
\]
while every start time is nonnegative. Thus, adding \(H\) makes the inactive inequality automatically satisfied; the active inequality enforces the selected order.

The implementation uses rectangular ordering arrays for straightforward indexing. Only entries corresponding to distinct, ordered pairs are free; all unused entries are fixed to zero. There are \(P\) free binary ordering variables.

### Removal of redundant cumulative constraints

The cumulative constraints are removed because the retained pairwise constraints already prevent any two positive-duration operations from overlapping on the same resource. Consequently, resource usage cannot exceed one.

Zero-duration operations require particular care: the original pairwise constraints can forbid placing a zero-duration operation strictly inside another operation. The reformulation retains those pairwise inequalities, so this aspect of the original semantics is preserved rather than replaced by a weaker capacity interpretation.

Removing the cumulative constraints avoids an additional global-constraint decomposition in the MIP backend. Explicit nonnegativity constraints are also omitted because the unchanged variable domains already imply them.

### Predecessor and successor workload cuts

For each operation and each of its two resources—its job and its machine—the reformulation adds:

- a lower bound on its start time equal to the total duration of operations ordered before it;
- an upper-horizon inequality requiring its completion time plus the total duration of operations ordered after it to be at most \(C\).

These are valid **resource workload inequalities**. Every selected predecessor must finish before the operation starts. Since those predecessors are mutually non-overlapping and start at or after zero, their total duration cannot exceed the operation’s start time. Similarly, selected successors are mutually non-overlapping and must fit between the operation’s completion and \(C\).

The cuts add \(4JM\) linear inequalities. They are redundant for integral feasible schedules but can strengthen the linear relaxation by aggregating information from multiple pairwise ordering decisions. Zero-duration operations contribute zero workload, so the argument does not require strictly positive durations.

### Interface and solution preservation

All original external parameters, derived bounds, start-time variables, and the objective variable retain their names and meanings. No instance-specific preprocessing, new input data, or symmetry-breaking assumptions are introduced. The minimization direction and objective values are unchanged.

The accompanying mapping script copies only `job_task_start` and `objective` from the reformulated solution, preserving their supplied array encoding and indices. Auxiliary ordering variables are not exported to the original model. Missing required solution fields produce an explicit error.

Overall, the reformulation aims to give HiGHS a direct linear mixed-integer formulation with stronger workload bounds and without redundant scheduling-global decompositions. Its performance benefit remains instance-dependent.

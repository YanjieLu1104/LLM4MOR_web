# Cyclic Resource-Constrained Scheduling Reformulation

## Background

The model represents a **resource-constrained modulo scheduling problem**: a collection of tasks repeats indefinitely with a common period. Applications include scheduling repeated manufacturing operations and constructing software pipelines under limited machine or processor capacity.

Each ordinary task lasts one time unit. Two artificial tasks mark the schedule’s start and end and have zero duration. Tasks consume specified amounts of renewable resources, whose capacities cannot be exceeded. Generalized precedence data specify a latency and an iteration distance between pairs of tasks.

The model assigns each task a within-period start coordinate and an iteration coordinate. The final artificial task’s start coordinate defines the period.

## Original formulation

### Variables and objective

For `n_tasks` tasks, the model declares **`2*n_tasks` independent integer variables**:

- `s[i] ∈ 0..t_max`: task start coordinates.
- `k[i] ∈ 0..n_tasks`: iteration coordinates.

Here, `t_max` is the sum of positive precedence latencies.

Writing \(P=s[n\_tasks]\), the model defines an unwrapped coordinate
\[
u_i=s_i-k_iP.
\]
The makespan is the range of these coordinates over all tasks except the final artificial task, plus one:
\[
M=\max_{i<n\_tasks}u_i-\min_{i<n\_tasks}u_i+1.
\]
Both the makespan and the weighted objective are derived decision variables. The objective is
\[
\min\; t_{\max}P+M.
\]
This is the original period-prioritizing objective; its coefficients and minimization direction are preserved.

### Constraints

The original model contains:

- **Generalized precedences.** Each precedence introduces a local Boolean indicating whether its time inequality holds. If it does not, an additional unit of iteration separation is required.
- **Pairwise non-overlap.** A task pair must not overlap whenever its combined demand exceeds any resource capacity.
- **Cumulative resource constraints.** For each resource, these consider only positive-demand, positive-duration tasks. A cumulative constraint is skipped when their total demand already fits within capacity.
- **Period bounds.** Every task except the final artificial task finishes by \(P\), and the final iteration coordinate equals the maximum preceding iteration coordinate.
- **Fixed source coordinates.** The first artificial task has `s[1] = 0` and `k[1] = 0`.

The products \(k_iP\), reified precedences, extrema, and scheduling constraints make this a mixed discrete, nonlinear formulation before backend translation.

## Reformulation and justification

### 1. Replace reified precedences with linear inequalities

For a precedence from task \(a\) to task \(b\), let
\[
A=s_a+\text{latency}-s_b,\qquad
\Delta=k_b+\text{distance}-k_a.
\]

The original constraint requires \(\Delta\ge0\) when \(A\le0\), and \(\Delta\ge1\) when \(A>0\). Because \(\Delta\) is integer, this is exactly represented by
\[
\Delta\ge0,\qquad A\le U\Delta,
\]
where
\[
U=\max(0,t_{\max}+\text{latency}).
\]

The bound is valid because both start coordinates lie in \(0..t_{\max}\). If \(\Delta=0\), the second inequality enforces the time precedence. If \(\Delta\ge1\), it imposes no additional restriction because \(A\le U\). Negative iteration slack remains forbidden.

This **bound-derived big-\(M\) reformulation** removes the explicit precedence Boolean and its equivalence constraint.

### 2. Linearize the makespan products exactly

For each task used in the makespan, the reformulation expands its bounded integer iteration coordinate in binary:
\[
k_i=\sum_j2^{j-1}b_{ij}.
\]

Each binary–period product \(z_{ij}=b_{ij}P\) is enforced by
\[
0\le z_{ij},\quad
z_{ij}\le t_{\max}b_{ij},\quad
z_{ij}\le P,\quad
z_{ij}\ge P-t_{\max}(1-b_{ij}).
\]

These inequalities force \(z_{ij}=0\) when the bit is zero and \(z_{ij}=P\) when it is one. Thus
\[
q_i=\sum_j2^{j-1}z_{ij}=k_iP
\]
exactly, and the makespan can use \(s_i-q_i\).

This **binary-expansion and bounded-product linearization** replaces integer–integer multiplication with linear constraints suited to HiGHS. The original bounds on `k` prevent binary encodings outside its permitted domain.

### 3. Add resource-energy cuts

For each resource with nonnegative capacity, the reformulation adds
\[
\sum_{\substack{i:\ d_i>0\\rreq_{ir}>0}}
d_i\,rreq_{ir}
\le rcap_rP.
\]

Every included task starts at a nonnegative time and finishes by \(P\), by the original variable domains and period constraints. Integrating the cumulative capacity restriction over that interval therefore bounds total resource use by capacity times period.

The cut also remains valid when the original cumulative constraint was skipped: total included demand then fits within capacity, all included tasks have unit duration, and any such task requires \(P\ge1\). Empty included sets contribute zero.

These **resource-energy inequalities** expose aggregate period lower bounds without replacing the necessary scheduling constraints.

### 4. Add bounds implied by the makespan and fixed source

The first task belongs to the makespan calculation and has unwrapped coordinate zero. Since the original model bounds \(M\le t_{\max}\), the range of unwrapped coordinates is at most \(t_{\max}-1\). Consequently,
\[
1-t_{\max}\le s_i-q_i\le t_{\max}-1,
\]
or equivalently,
\[
s_i-t_{\max}+1\le q_i\le s_i+t_{\max}-1.
\]

These **redundant bound-strengthening cuts** follow directly from the original makespan definition and fixed source coordinates. They tighten the product formulation without removing feasible schedules.

## Interface and reconstruction

All original external parameters, independent variables, resource constraints, period constraints, and objective values are preserved. No instance-specific data are hard-coded.

The mapping script performs an **identity reconstruction** of `s` and `k`, preserving their array indices and omitting reformulation auxiliaries. It reports missing required values rather than inventing them.

The changes target a stronger and more explicit mixed-integer linear representation. No instance-specific runtime improvement was established in the conversation.

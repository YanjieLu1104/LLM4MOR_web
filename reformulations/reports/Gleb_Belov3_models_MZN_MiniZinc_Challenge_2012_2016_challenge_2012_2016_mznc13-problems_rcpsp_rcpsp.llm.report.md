## Problem background

The model represents a **resource-constrained project scheduling problem (RCPSP)**. A project consists of tasks with fixed durations and resource demands. Resources have constant capacities, and specified precedence relationships require some tasks to finish before others start.

Applications include construction planning, manufacturing, and project execution with limited personnel or equipment. Tasks execute without interruption. The goal is to minimize the project’s **makespan**, the time by which all tasks have finished.

No instance data were supplied, so task counts, resource counts, and numerical improvements in solving time cannot be reported.

## Original formulation

### Data and variables

The inputs specify task durations `d`, resource capacities `rc`, task resource demands `rr`, and successor sets `suc`.

Let \(H=\sum_i d_i\), corresponding to `sum_d`. The original model has:

- One integer start-time variable \(s_i\in[0,H]\) per task.
- One integer makespan variable \(C\in[0,H]\), named `objective`.
- One local Boolean ordering variable for each task pair whose combined demand exceeds at least one resource’s capacity.

Thus, there are \(|Tasks|+1\) primary integer variables; the number of ordering variables depends on the data.

### Constraints and objective

The model enforces:

1. **Precedence:** \(s_i+d_i\le s_j\) whenever \(j\in suc_i\).
2. **Pairwise sequencing:** resource-incompatible task pairs must execute in one order or the other.
3. **Resource capacity:** one `cumulative` constraint per resource limits the total demand of simultaneously executing tasks.
4. **Completion:** \(s_i+d_i\le C\) for every task.

The objective is to **minimize \(C\)**. The original solve item also supplies a start-time-first search annotation.

## Reformulation and justification

### 1. Time-indexed binary MILP

For inputs with nonnegative durations, resource demands, and capacities, the reformulation replaces the cumulative constraints with an explicit time-indexed formulation suitable for HiGHS.

A binary variable \(x_{i,t}\) indicates whether task \(i\) starts at integer time \(t\). Each task selects exactly one candidate start time, and the original variable is retained through
\[
\sum_t x_{i,t}=1,\qquad s_i=\sum_t t\,x_{i,t}.
\]

For every resource \(r\) and slot \(u=0,\ldots,H-1\), the model imposes
\[
\sum_{i,t:\ t\le u<t+d_i} rr_{r,i}\,x_{i,t}\le rc_r.
\]

**Why this is valid:** start times and durations are integral, so resource usage is constant on each unit interval between consecutive integer times. Checking every such slot therefore enforces the original cumulative capacity condition. The original completion constraints and \(C\le H\) ensure that every positive-duration task finishes within the represented horizon. Zero-duration tasks occupy no slots.

The nonnegativity test is a derived condition, not a new input restriction. Inputs outside this case retain the original cumulative and sequencing formulation.

### 2. Direct-precedence window preprocessing

Candidate start times are restricted to
\[
L_i=\max\bigl(\{0\}\cup\{d_p:i\in suc_p\}\bigr)
\]
and
\[
U_i=\min\bigl(\{H-d_i\}\cup\{H-d_i-d_j:j\in suc_i\}\bigr).
\]

**Why this is valid:**

- For a predecessor \(p\), the original constraints give \(s_i\ge s_p+d_p\ge d_p\), because \(s_p\ge0\).
- Completion gives \(s_i\le H-d_i\).
- For a successor \(j\), combining \(s_i+d_i\le s_j\) with \(s_j+d_j\le C\le H\) gives \(s_i\le H-d_i-d_j\).

These bounds remove only impossible start choices. An empty candidate window correctly makes the formulation infeasible. This preprocessing uses direct precedence relationships, not a full transitive or critical-path computation.

### 3. Resource-workload inequalities

For each resource, the reformulation adds
\[
\sum_i d_i\,rr_{r,i}\le rc_r\,C.
\]

**Why this is valid:** the left side is the total resource-time consumed by all tasks. Every task executes between time zero and \(C\), and cumulative usage never exceeds \(rc_r\). Summing capacity over that interval yields the inequality.

These redundant inequalities provide direct makespan bounds and can strengthen the MILP relaxation.

### 4. Selective removal of pairwise ordering variables

Explicit sequencing constraints are removed for incompatible pairs in which both tasks have positive duration.

**Why this is valid:** if two such tasks overlap, their integral execution intervals share at least one unit slot. Their combined demand exceeds a resource capacity, and all other demands are nonnegative. The corresponding time-indexed capacity constraint therefore prohibits the overlap.

Sequencing constraints are retained when either task has zero duration. This distinction is necessary: a zero-duration task consumes no time-indexed capacity, but the original model still imposes its pairwise ordering condition.

The retained conditions use a big-\(M\) value of \(H\). This is valid because every task’s completion is at most \(H\), while every start time is nonnegative, so the inactive ordering inequality is always satisfied.

## Interface, mapping, and expected trade-offs

The external data interface, original start-time variables, makespan variable, precedence constraints, and completion constraints remain unchanged. The mapping script copies only `s` and `objective` from the solver output and explicitly reports missing fields; no solution reconstruction is needed.

The reformulation replaces scheduling globals with explicit binary and linear constraints and omits the original CP-oriented search annotation. This exposes the scheduling structure directly to HiGHS. Its principal trade-off is size: it introduces one binary variable per retained task/start-time combination and capacity constraints across the scheduling horizon. It may be advantageous for moderate horizons, but no runtime improvement has been established without instance-specific testing.

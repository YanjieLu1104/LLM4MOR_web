# Scenario-Based Flexible Job-Shop Scheduling

## Background and interpretation

The model represents a small flexible job-shop scheduling problem with uncertain machine availability. Eight tasks form two jobs, each containing four tasks that must execute in increasing task-index order. Each task has a fixed processing duration and a set of eligible machines.

There are six scenarios, each specifying a fixed interval associated with an unavailable machine or an additional activity. Machine assignments are shared across all scenarios, while task start times and schedule completion bounds can vary by scenario. This has the structure of a two-stage scheduling model: machine choices are made before the scenario is known, and timing decisions adapt afterward.

Two details are important to the instance’s meaning:

- The machine domain is **only `{1, 2}`**, even though some eligibility sets mention machine 3. Those references do not make machine 3 available.
- Exclusion from a scenario’s fixed interval is **strict**: an assigned task must finish strictly before its start or begin strictly after its end. This is stronger than the usual scheduling convention that permits touching endpoints.

The sixth scenario references machine 3 and therefore imposes no effective availability restriction. Its supplied interval endpoints are retained unchanged.

## Original formulation

### Decision variables

The original model contains **63 integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `machine` | 8 | One machine assignment per task, shared across scenarios |
| `start_time` | 48 | One start time per task and scenario |
| `makespan` | 6 | One upper bound on task completion times per scenario |
| `objective` | 1 | Weighted sum of scenario makespans |

Start times and makespans lie in `1..200`; the objective lies in `0..1600`.

### Constraints

The formulation enforces:

- **Job precedence:** every earlier-indexed task precedes every later-indexed task of the same job. An additional loop over jobs duplicates these constraints without changing their meaning.
- **Machine capacity:** tasks assigned to the same machine cannot overlap. The original formulation considers both orientations of each relevant task pair.
- **Machine eligibility:** assignments to machines outside a task’s eligibility set are forbidden.
- **Scenario availability:** tasks assigned to the affected machine must avoid the fixed interval using the strict inequalities described above.
- **Completion bounds:** each task’s finish time is at most its scenario’s makespan.
- **Objective definition:** the objective equals the weighted sum of the six makespans.

The model minimizes
\[
\sum_{s=1}^{6} w_s C_s,
\qquad
w=(3,2,1,2,1,3).
\]
These are scenario weights, not explicitly normalized probabilities. The makespan variables are completion upper bounds; their positive objective coefficients encourage tight values at an optimum.

## Reformulation and justification

The reformulation retains all original decision variables, fixed data, domains, and objective direction. It replaces logical scheduling constraints with an explicit mixed-integer linear formulation suitable for HiGHS.

### 1. Effective machine eligibility

Each task’s effective eligibility set is the intersection of its supplied eligibility set with `MACHINE`.

This is valid because the original `machine` variables already have domain `MACHINE`, and the eligibility constraints further restrict that domain. Consequently, task 2 and task 5 must use machine 2, while task 3 and task 8 must use machine 1. This preprocessing does not alter the supplied eligibility data.

Binary assignment variables encode these choices, with exactly one selected machine per task and a linear equality connecting them to the original `machine` variables.

### 2. Transitive reduction of job precedence

The reformulation retains only consecutive precedence arcs within each job and removes the redundant outer job loop.

Consecutive arcs imply all original earlier-to-later precedence constraints: summing the intervening inequalities gives the earlier task’s completion before the later task’s start, because every processing duration in this instance is positive. Conversely, every retained arc appears in the original formulation. The two precedence representations therefore describe the same feasible schedules.

### 3. Removal of redundant machine-conflict constraints

Only unordered, cross-job task pairs with a common effective machine are considered.

Each reduction follows from the original constraints:

- Reversing a pair gives the same non-overlap disjunction, so only one orientation is needed.
- Same-job tasks are already ordered without overlap by precedence.
- Tasks with disjoint effective eligibility sets cannot receive the same machine, so their original conditional non-overlap constraint is always inactive.

A scenario-specific binary ordering variable chooses the order of each remaining pair. Assignment-dependent big-M terms deactivate the timing inequalities unless both tasks use the relevant machine.

### 4. Precedence-based time bounds and tighter big-M values

For task \(t\), the reformulation derives
\[
L_t=1+\sum_{\substack{u<t\\job(u)=job(t)}}p_u,
\qquad
R_t=\sum_{\substack{u\ge t\\job(u)=job(t)}}p_u,
\qquad
U_t=200-R_t.
\]

Here \(L_t\) is an earliest start bound, \(R_t\) is the task’s remaining job processing time, and \(U_t\) is a latest start bound.

These follow from the original start-time lower bound, job precedence, and the requirement that all task completions occur by a makespan no greater than 200. They also justify the valid inequality
\[
start_{s,t}+R_t\le C_s.
\]

The derived bounds give pair-specific big-M coefficients. For example, the maximum possible violation of “\(u\) finishes before \(v\) starts” is bounded by
\[
\max(0,U_u+p_u-L_v).
\]
Using this value preserves the disjunction while avoiding unnecessarily large coefficients.

### 5. Exact linearization of availability exclusions

Since times are integer-valued, the original strict conditions are exactly equivalent to
\[
start_{s,t}+p_t\le a-1
\quad\text{or}\quad
start_{s,t}\ge b+1,
\]
where \(a\) and \(b\) are the supplied interval endpoints.

Binary branch variables and bound-derived big-M coefficients encode this disjunction. Restrictions are omitted only when the affected machine is outside the task’s effective eligibility set, making the original implication inactive.

Additional conditional branch restrictions follow from the time bounds: a task whose earliest completion is at least \(a\) cannot take the “before” branch, and a task whose latest start is at most \(b\) cannot take the “after” branch.

### 6. Machine-workload inequalities

For each scenario and machine, the formulation adds
\[
C_s\ge 1+\sum_t p_t x_{t,m}.
\]

All tasks assigned to a machine must be non-overlapping, start no earlier than 1, and finish by \(C_s\). Their total processing time therefore cannot exceed \(C_s-1\). This necessary condition strengthens the linear relaxation without excluding feasible schedules.

## Solution compatibility

The mapping script copies `machine`, `start_time`, `makespan`, and `objective` directly from the reformulated solution, preserving their encoded index domains and omitting auxiliary binaries. Missing required values produce an explicit error rather than an invented reconstruction.

The changes aim to improve HiGHS performance through fewer redundant constraints, explicit linear disjunctions, tighter bounds, and valid inequalities. No measured runtime improvement is established here.

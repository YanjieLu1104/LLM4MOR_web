# Scenario-Based Flexible Job-Shop Scheduling

## Background and interpretation

The model represents a small flexible job-shop scheduling problem with uncertain machine availability. Eight operations belong to two jobs, each containing four operations that must run in their listed order. Processing times are fixed, and each operation has a set of eligible machines.

Machine assignments are shared across four scenarios, while operation start times can differ by scenario. This suggests a two-stage planning interpretation: machines are selected before the availability scenario is known, and schedules are adjusted afterward. Each scenario specifies one additional fixed machine-occupancy interval.

Although some eligibility sets and one fixed interval reference machine 3, the declared machine domain is **only machines 1 and 2**. Consequently, operations cannot use machine 3, and its fixed interval imposes no restriction. The reformulation preserves this distinction rather than changing the instance to match its filename or eligibility lists.

## Original formulation

### Decision variables

The original model contains **45 integer decision variables**:

- **8 machine assignments**, one per operation, shared across scenarios.
- **32 start times**, one per operation and scenario, in `1..200`.
- **4 makespans**, one per scenario, also in `1..200`.
- **1 objective variable**, in `0..1600`.

### Constraints

The model imposes:

1. **Within-job precedence.** Every earlier-indexed operation of a job must finish before every later-indexed operation starts. An unused loop over the two jobs duplicates these constraints.
2. **Machine non-overlap.** Operations assigned to the same machine cannot overlap. The original formulation generates both orientations of each eligible operation pair, including pairs already ordered by job precedence.
3. **Machine eligibility.** Each assignment must belong to the operation’s eligibility set and the declared machine domain.
4. **Fixed-interval avoidance.** An operation using the affected machine must either finish strictly before the interval starts or start strictly after it ends.
5. **Makespan bounds.** Every operation must finish no later than its scenario’s makespan.

The strict fixed-interval inequalities are important: unlike ordinary operation-to-operation sequencing, they prohibit equality at the interval boundaries.

### Objective

The model minimizes the weighted sum of scenario makespans:

\[
\min\; 3C_1+2C_2+C_3+2C_4.
\]

These are the supplied weights; the model does not normalize them into probabilities.

## Reformulation and justification

The reformulation replaces logical scheduling disjunctions with an explicit mixed-integer linear formulation suitable for **HiGHS**. It retains all original decision variables, fixed data, and objective semantics.

### 1. Preprocess effective machine eligibility

For each operation, the reformulation intersects its eligibility set with the declared machine domain.

This is exact because the original assignment variable already lies in `MACHINE`, while the eligibility constraints exclude any declared machine not in its eligibility set. The intersection therefore describes precisely the original feasible assignments.

Fixed-interval constraints are generated only when the affected machine belongs to this intersection. Otherwise, the original implication’s antecedent can never hold.

### 2. Replace all-pairs job precedence with consecutive precedence

Only consecutive operations within each job are explicitly linked, and the unused outer job loop is removed.

This preserves the original ordering because processing times are positive. Chaining consecutive precedences implies that every earlier operation finishes before every later operation starts. Conversely, the original all-pairs constraints include every consecutive link.

### 3. Remove redundant machine-conflict pairs

Machine conflicts are generated only for unordered pairs of operations that:

- belong to different jobs; and
- share at least one effective eligible machine.

Each reduction follows directly from the original constraints:

- Reversing a pair produces the same non-overlap disjunction, so only one orientation is needed.
- Same-job operations already cannot overlap because of precedence.
- Operations with disjoint effective eligibility sets cannot receive the same machine.

### 4. Derive job-chain bounds and tighten big-M coefficients

For operation \(t\), define

\[
L_t=1+\sum_{\substack{u<t\\job(u)=job(t)}}p_u,
\qquad
R_t=\sum_{\substack{u\ge t\\job(u)=job(t)}}p_u.
\]

The reformulation enforces

\[
s_{qt}\ge L_t,
\qquad
s_{qt}+R_t\le C_q.
\]

These are implied by the original constraints: start times are at least one, all predecessors must finish before \(t\), and \(t\) plus its successors must finish by the scenario makespan. Since \(C_q\le200\), they also imply \(s_{qt}\le200-R_t\).

These bounds yield operation-specific big-M coefficients. Each coefficient is large enough to cover the maximum possible violation when its corresponding ordering inequality is inactive, without using an unnecessarily loose common constant.

### 5. Use binary assignment and ordering variables

Binary assignment indicators select exactly one effective eligible machine per operation and are linked to the original `machine` variables.

For each remaining operation pair and scenario, a binary ordering variable selects which operation comes first. Linear big-M inequalities enforce that ordering whenever both operations use the same machine; otherwise, the inequalities are inactive.

Separate binary variables select the side of each relevant fixed interval. Because all times are integers, the original strict inequalities are represented exactly as

\[
s_{qt}+p_t\le a-1
\quad\text{or}\quad
s_{qt}\ge b+1,
\]

where \(a\) and \(b\) are the interval’s start and end.

### 6. Add machine-workload lower bounds

For each scenario \(q\) and machine \(m\), the reformulation adds

\[
C_q\ge1+\sum_t p_t x_{tm}.
\]

This is valid because all operations assigned to a machine are non-overlapping, start no earlier than one, and finish by \(C_q\). Their total processing time therefore cannot exceed \(C_q-1\). Fixed unavailability can only reduce usable time, so ignoring it in this lower bound remains valid.

## Solution compatibility

All original decision variables remain directly available. The mapping script copies `machine`, `start_time`, `makespan`, and `objective` unchanged and excludes auxiliary variables.

The changes aim to reduce redundant constraints and improve the linear relaxation through tighter bounds and workload cuts. No empirical speedup is claimed without solver benchmarking.

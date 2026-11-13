# Scenario-Based Flexible Job-Shop Scheduling

## Problem background

The model represents a production scheduling problem with **20 operations, four jobs, and three machines**. Each job consists of five operations that must follow their listed order. Each operation has a fixed processing duration and a set of eligible machines.

There are three scenarios with different fixed machine-unavailability intervals. These intervals can be interpreted as maintenance periods or previously committed work. Each operation must use the **same selected machine across all scenarios**, but its starting time may vary by scenario. Thus, the model combines a shared resource-allocation decision with scenario-dependent schedules.

The objective minimizes the weighted sum of the three scenario makespans, with weights **1, 2, and 2**. These weights express relative importance; the model does not explicitly define probabilities.

## Original formulation

### Variables and objective

The original model contains **84 integer decision variables**:

| Variables | Count | Meaning |
|---|---:|---|
| `machine` | 20 | Machine assigned to each operation |
| `start_time` | 60 | Operation starting time in each scenario |
| `makespan` | 3 | Completion-time upper bound for each scenario |
| `objective` | 1 | Weighted sum of scenario makespans |

Starting times and makespans lie in `1..200`. The objective is defined by
\[
\text{objective}=C_1+2C_2+2C_3,
\]
and is minimized.

### Constraints

The original constraints enforce:

- **Job precedence:** Every operation precedes all later-indexed operations of its job. An unused outer loop over jobs repeats each such constraint four times.
- **Machine capacity:** Operations assigned to the same machine cannot overlap in any scenario. The formulation generates both ordered versions of each task pair.
- **Machine eligibility:** Each operation must use one of its permitted machines.
- **Scenario-specific unavailability:** An operation assigned to an affected machine must finish strictly before the interval’s start or begin strictly after its end.
- **Makespan coverage:** Every operation must finish by its scenario’s makespan.
- **Objective definition:** The objective equals the weighted makespan sum.

The strict unavailability inequalities are important: they impose more separation than ordinary non-overlap with a half-open maintenance interval.

## Reformulation and justification

The reformulation retains the original data, decision variables, objective values, and minimization direction. It replaces logical scheduling constraints with an explicit mixed-integer linear formulation intended for **HiGHS**.

### 1. Reduce precedence constraints to adjacent operations

Only consecutive operations within each job need explicit precedence constraints.

This is valid because all supplied processing durations are positive. Chaining consecutive precedence inequalities implies that an operation finishes before every later operation of its job begins. Consequently, all original nonconsecutive precedence constraints are implied. The unused outer job loop can also be removed because it only duplicates constraints.

This reduces the **480 generated precedence instances to 48**: four links per job, four jobs, and three scenarios.

### 2. Remove redundant machine-conflict pairs

Same-job operation pairs need no additional machine-conflict constraint: job precedence already prevents them from overlapping, regardless of their assigned machines.

For different jobs, each unordered pair is considered once rather than twice. The original constraints for the two ordered versions of a pair express the same disjunction.

All eligible-machine sets in this instance intersect pairwise. After removing same-job pairs, **150 unordered operation pairs remain**, giving **450 scenario-specific conflict pairs**.

### 3. Derive job-chain time bounds

For operation \(t\), define:

- \(E_t\): one plus the total duration of its earlier job operations;
- \(R_t\): the total duration of \(t\) and all its later job operations.

The original lower bound of one on starting times and the job precedences imply
\[
s_{s,t}\ge E_t.
\]
The same precedences, together with the makespan constraint for the job’s final operation, imply
\[
C_s\ge s_{s,t}+R_t.
\]
Since \(C_s\le200\), this also gives
\[
s_{s,t}\le200-R_t.
\]

These bounds preserve feasible schedules and provide tighter constants for the linearized disjunctions. The tail-based makespan inequality also implies the original individual-operation completion bound, since \(R_t\ge p_t\).

### 4. Linearize assignment and sequencing

Binary assignment variables select exactly one machine per operation. Ineligible assignments are fixed to zero, and a linear channeling equation preserves the meaning of the original `machine` variable.

For every retained conflict pair and scenario, two directional binary variables represent the possible processing orders. If the operations share an assigned machine, exactly one direction must be selected. If they use different machines, both directions can be inactive.

Each selected direction activates a precedence inequality through a **task-specific big-M formulation**. The constants are derived from the job-chain time bounds, ensuring that an inactive inequality excludes no feasible schedule while avoiding unnecessarily large coefficients.

### 5. Preserve strict unavailability constraints exactly

Because all times are integral, the original condition
\[
s_t+p_t<a \quad\text{or}\quad s_t>b
\]
is equivalent to
\[
s_t+p_t\le a-1 \quad\text{or}\quad s_t\ge b+1.
\]

The reformulation uses binary before/after choices activated by assignment to the affected machine. Thus, it preserves the original strict separation rather than replacing it with weaker ordinary interval non-overlap.

### 6. Add valid workload cuts

A common makespan lower bound follows from two necessary conditions:

- Every job must execute its full sequential chain.
- Three machines must accommodate all processing time after the earliest permitted start.

The model therefore uses the larger of the longest-job bound and
\[
1+\left\lceil\frac{\sum_t p_t}{3}\right\rceil.
\]

For each machine and scenario, an additional capacity cut limits assigned processing time by the available horizon. It also subtracts unavailable unit-time slots lying before this proven makespan lower bound. Those slots necessarily lie within every feasible horizon and cannot be used by assigned operations under the original strict unavailability constraints. Slots are counted by their union, avoiding double counting.

These cuts strengthen the linear relaxation without removing feasible original schedules.

## Solution mapping

All four original variable fields—`machine`, `start_time`, `makespan`, and `objective`—remain in the reformulated model. The accompanying mapping script copies those fields unchanged and excludes auxiliary variables. It reports missing required fields instead of reconstructing them from unsupported assumptions.

The reformulation is designed to reduce redundancy and improve the mixed-integer relaxation; no measured runtime improvement was established in this exchange.

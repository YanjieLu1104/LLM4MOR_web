## Problem background

The model represents a **two-scenario flexible job-shop scheduling problem**. Fifteen tasks belong to three jobs, with five tasks per job. Each task has a fixed processing duration and a specified set of eligible machines among three available machines.

A task’s machine assignment must be the same in both scenarios, but its start time may differ. This structure represents an assignment decision made before the scenario is known, followed by scenario-dependent scheduling. The scenarios differ in the timing of an unavailable period on machine 1, plausibly representing maintenance or another reserved activity.

The model minimizes a weighted sum of scenario makespans. The weights are 1 and 2; the source does not explicitly identify them as probabilities.

## Original formulation

### Decision variables and objective

The original model contains **48 integer decision variables**:

- 15 machine assignments, one per task;
- 30 start times, one per task and scenario;
- two scenario makespans;
- one objective variable.

Start times and makespans lie in `1..200`. The objective is minimized and satisfies
\[
\text{objective}=C_1+2C_2,
\]
where \(C_s\) is the makespan variable for scenario \(s\).

### Constraints

The original constraints enforce:

1. **Job precedence.** Within each job, every task must finish before every higher-indexed task starts. An unused outer job loop repeats these constraints three times, yielding 180 generated precedence inequalities.
2. **Machine capacity.** Tasks assigned to the same machine cannot overlap in either scenario. The formulation generates both orientations of each potentially conflicting task pair.
3. **Machine eligibility.** Each task must use one of its specified eligible machines.
4. **Machine unavailability.** A task assigned to the machine affected by a blackout must either finish **strictly before** the blackout starts or start **strictly after** it ends.
5. **Makespan bounds.** Every task must finish by its scenario’s makespan.

The strict blackout inequalities are stronger than the usual convention allowing activities to touch the endpoints of an unavailable interval.

## Reformulation and justification

### 1. Reduce precedence constraints to adjacent tasks

The reformulation retains only consecutive-task precedence constraints within each job: four per job and scenario, or **24 inequalities** overall.

This reduction is valid for two reasons:

- The original outer job loop does not affect the constraints it contains, so its repetitions are redundant.
- Consecutive precedence inequalities imply every nonconsecutive precedence inequality by transitivity. All supplied task durations are positive, so intermediate tasks cannot invalidate that implication.

### 2. Derive start-time bounds from job chains

For each task, preprocessing computes:

- an earliest start equal to 1 plus the total duration of its job predecessors;
- a remaining processing time equal to its own duration plus those of its job successors;
- a latest start equal to 200 minus that remaining processing time.

These bounds follow from the original lower bound of 1 on start times, job precedence, and the requirement that all tasks finish by a makespan no greater than 200.

The reformulation also adds
\[
\text{start}_{s,t}+\text{remaining duration}_t\le C_s.
\]
This inequality follows by chaining the task’s successor precedences through the last task’s original makespan constraint. It therefore strengthens the formulation without excluding any original feasible schedule.

### 3. Linearize machine assignment and sequencing

Binary assignment variables indicate whether a task uses a particular machine. Exactly one is selected for each task, ineligible assignments are fixed to zero, and a linear channeling equation retains the original machine variable and its meaning.

Binary sequencing variables represent directed task orders within each scenario. Whenever two tasks select the same machine, at least one direction must be active. An active direction enforces the corresponding finish-before-start inequality.

The reformulation omits machine-conflict constraints between tasks belonging to the same job: their original precedence constraints already prevent overlap, regardless of machine choice. It also avoids duplicating the conflict requirement for both orientations of an unordered task pair.

This is an **explicit disjunctive mixed-integer linear reformulation**, intended to expose the scheduling structure directly to HiGHS.

### 4. Use task-specific big-M coefficients

Each conditional sequencing inequality uses a coefficient derived from the predecessor’s latest possible finish and the successor’s earliest possible start.

When a sequencing direction is inactive, that coefficient is large enough to make its inequality redundant over the derived bounds. When active, the inequality enforces the required precedence exactly. These task-specific coefficients avoid unnecessarily loose horizon-based constants and can improve the linear relaxation and numerical behavior.

### 5. Preserve blackout semantics through integer linearization

A binary variable chooses whether a task lies before or after each relevant blackout. Because all times are integers, the original strict inequalities are represented exactly as
\[
\text{finish}\le \text{blackout start}-1
\quad\text{or}\quad
\text{start}\ge \text{blackout end}+1.
\]

Assignment-dependent big-M terms deactivate these restrictions when the task uses another machine. Their coefficients are derived from the same valid start-time bounds.

### 6. Add machine workload inequalities

For each machine and scenario, the reformulation adds
\[
C_s\ge 1+\sum_t d_t x_{t,m},
\]
where \(x_{t,m}\) indicates assignment to machine \(m\).

This is valid because tasks assigned to one machine cannot overlap, cannot start before time 1, and must all finish by \(C_s\). Their total processing duration must therefore fit within the interval from 1 to \(C_s\). Ignoring idle time and blackouts only weakens this necessary bound.

## Preservation and expected effect

All original instance data, decision variables, objective values, and minimization direction are retained. The supplied mapping script copies the four original variable entities and omits reformulation auxiliaries.

The changes combine **redundancy elimination, precedence-based bound propagation, binary linearization, tightened big-M coefficients, and valid workload inequalities**. They are intended to reduce redundant constraints and strengthen the formulation presented to HiGHS; no measured runtime improvement was established in the conversation.

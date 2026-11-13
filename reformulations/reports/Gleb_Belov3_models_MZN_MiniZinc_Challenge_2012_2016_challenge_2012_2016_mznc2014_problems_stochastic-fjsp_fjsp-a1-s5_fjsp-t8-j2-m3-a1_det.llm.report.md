# Reformulation Report: Scenario-Based Flexible Job-Shop Scheduling

## 1. Problem background

The model represents a small **flexible job-shop scheduling problem with scenario-dependent machine unavailability**. A plausible application is production planning when equipment outages or maintenance windows vary across possible operating conditions.

The instance contains eight tasks belonging to two jobs. Each job consists of four tasks that must execute in task-index order. Processing times are fixed, and tasks cannot be interrupted. Each task has a set of eligible machines.

Machine assignments are shared across five scenarios, whereas task start times and completion horizons may differ by scenario. This structure represents a planning decision made before the scenario is known, followed by scenario-specific scheduling adjustments.

Two details are important when interpreting the supplied data:

- Although some eligibility sets contain machine 3, the declared machine domain is only `{1, 2}`. Machine 3 is therefore unavailable for assignment.
- The fifth scenario’s additional-task record refers to machine 3 and has its end before its start. Its exclusion constraint is inactive because no task can be assigned to that machine. The reformulation preserves this data rather than correcting or reinterpreting it.

The scenario weights are positive but not normalized. The objective is therefore a **weighted total makespan**, not explicitly an expected makespan.

## 2. Original model structure

### Decision variables

The original model declares 54 integer decision variables:

| Variable | Count | Meaning |
|---|---:|---|
| `machine` | 8 | One shared machine assignment per task |
| `start_time` | 40 | One start time per task and scenario |
| `makespan` | 5 | One completion horizon per scenario |
| `objective` | 1 | Weighted sum of scenario makespans |

Start times and makespans lie in `1..200`. The objective variable lies in `0..1600`.

### Constraints

The model imposes:

- **Job precedence:** Every earlier-indexed task of a job must finish before every later-indexed task starts. An outer loop over jobs repeats these constraints without changing their meaning.
- **Machine non-overlap:** Tasks assigned to the same machine cannot overlap within a scenario. The original formulation generates both orientations of each relevant task pair.
- **Machine eligibility:** Assignments to machines outside a task’s eligibility set are forbidden.
- **Scenario-specific unavailability:** A task assigned to the affected machine must finish strictly before the additional task starts or begin strictly after it ends.
- **Makespan bounds:** Every task must finish by its scenario’s makespan.

The minimization objective is

\[
\sum_{s=1}^{5} w_s C_s,
\qquad w=(3,2,1,2,3),
\]

where \(C_s\) is the makespan in scenario \(s\).

## 3. Reformulation and justification

### Eligibility preprocessing

Each task’s eligibility set is intersected with the declared machine domain. This is exact because `machine` already excludes every value outside `{1, 2}`.

Binary task–machine assignment variables are introduced and linked to the original machine variables by one-hot constraints and a weighted-sum equality. Ineligible assignment binaries are fixed to zero. The original variables remain available for solution checking.

### Transitive reduction of job precedence

Only consecutive tasks within each job retain explicit precedence constraints.

This is sufficient because consecutive precedences form a chain. With the supplied positive processing times, the chain implies every original earlier-to-later precedence. Duplicate constraints from the unused outer job loop are also removed.

Likewise, only each job’s final task requires an explicit makespan constraint: the chain ensures that every preceding task finishes before that final task finishes.

### Job-chain time bounds

For each task, an earliest start is derived from the minimum start time, 1, plus the processing times of its job predecessors. A latest start is derived from the maximum makespan, 200, minus its own processing time and those of its job successors.

These bounds follow directly from job precedence and the original makespan domain; they introduce no scheduling assumptions.

The longer job has total processing time 23, so every scenario makespan is at least 24.

### Reduced machine-conflict set

Explicit machine conflicts are omitted for:

- Tasks belonging to the same job, since precedence already prevents overlap.
- Tasks with disjoint effective eligibility sets, since their machine assignments cannot coincide.

Each remaining unordered pair is represented once. This leaves **14 relevant cross-job pairs per scenario**.

### Explicit bounded linear disjunctions

The remaining machine-conflict constraints use binary ordering variables and linear big-\(M\) inequalities. If two tasks share a machine, one ordering must hold. Otherwise, both ordering variables may be zero.

The big-\(M\) coefficients are calculated from the derived task-specific time bounds. Consequently, inactive inequalities are genuinely nonrestrictive, while avoiding unnecessarily large coefficients. This formulation targets the HiGHS mixed-integer backend.

Maintenance exclusions are linearized similarly. Their strict inequalities are preserved exactly using integer-time identities:

\[
S_t+p_t<a \iff S_t+p_t\le a-1,
\qquad
S_t>b \iff S_t\ge b+1.
\]

### Machine-load cuts

Each scenario makespan is additionally bounded below by the earliest permitted start plus the total processing assigned to each machine. This follows because tasks sharing a machine cannot overlap.

The bound is strengthened by unavailable time lying inside the guaranteed horizon from time 1 to the makespan lower bound. Under the original strict maintenance constraints, an affected machine cannot process tasks between \(a-1\) and \(b+1\). Any portion of that interval inside the guaranteed horizon consumes capacity in every feasible schedule. The formulation uses a maximum across individual outage contributions rather than summing potentially overlapping intervals, avoiding double counting.

## 4. Preservation and solution mapping

All original fixed data, decision-variable domains, and the weighted minimization objective are retained. The auxiliary binaries provide a linear representation of existing scheduling choices; the added bounds and load cuts are consequences of the original constraints.

The mapping script copies only `machine`, `start_time`, `makespan`, and `objective`, preserving their supplied array encodings and excluding auxiliary variables. Missing required solution fields produce an explicit error.

The changes are intended to reduce redundant constraints and strengthen the MIP formulation. No measured runtime improvement is established by the conversation.

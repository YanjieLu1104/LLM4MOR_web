# Multi-Mode Resource-Constrained Project Scheduling

## Background

The model represents a project whose activities must be scheduled subject to precedence relationships and limited resources. Each activity has alternative execution **modes**, such as different staffing or equipment configurations. Selecting a mode determines both the activity’s duration and its resource requirements.

Resources have two modeled types:

- **Renewable resources:** capacity limits the total demand of activities executing simultaneously, as with workers or machines.
- **Non-renewable resources:** a project-wide budget limits the sum of activity requirements, as with materials or a fixed expenditure allowance.

The aim is to minimize the latest completion time of activities with no successors. In a conventional acyclic project network, this is the project makespan. The reformulation preserves the model’s explicit terminal-activity definition rather than assuming additional network properties.

## Original Model

### Variables

The declared scheduling variables comprise:

| Variable | Size | Meaning |
|---|---:|---|
| `mrun` | `n_opt` Booleans | Whether each mode is selected |
| `start` | `n_tasks` integers | Activity start times |
| `adur` | `n_tasks` integers | Selected activity durations |
| `arreq` | `n_res × n_tasks` integers | Selected resource requirements |
| `objective` | One integer | Latest terminal-activity completion time |

Start times and the objective lie between zero and `UB`, where `UB` is the sum of the maximum mode duration of each activity. The original model also introduces one local mode-index variable per activity.

### Constraints and objective

For each activity, the original model selects exactly one mode. A local mode index points to a selected mode, and variable-index array lookups determine the activity’s duration and resource requirements.

The remaining constraints enforce:

- **Precedence:** every listed successor starts after its predecessor finishes.
- **Renewable capacity:** one cumulative scheduling constraint per renewable resource.
- **Non-renewable budgets:** total activity demand cannot exceed the corresponding budget.
- **Objective definition:** `objective` equals the maximum completion time among activities with no successors.
- **Additional non-overlap conditions:** certain activity pairs must not overlap, either unconditionally or when their selected demands exceed a renewable capacity together.

The solve item minimizes `objective`.

## Reformulation and Its Justification

### 1. Linear one-hot mode selection

The local mode-index variables and variable-index lookups were replaced by linear equations. For each activity \(i\),

\[
\sum_{m\in\mathrm{mode}[i]} \mathbf{1}[\mathrm{mrun}_m]=1,
\]

\[
\mathrm{adur}_i
=\sum_{m\in\mathrm{mode}[i]}
\mathrm{mdur}_m\,\mathbf{1}[\mathrm{mrun}_m],
\]

\[
\mathrm{arreq}_{k,i}
=\sum_{m\in\mathrm{mode}[i]}
\mathrm{mrreq}_{k,m}\,\mathbf{1}[\mathrm{mrun}_m].
\]

**Why this is valid:** the original exactly-one constraint and the requirement that the local index reference a selected mode force that index to identify the unique selected mode. Consequently, each weighted sum equals the original lookup value. Conversely, any Boolean assignment satisfying exactly-one selection provides a valid original local index.

This equivalence does not require mode sets of different activities to be disjoint: shared mode Booleans retain their original coupling.

**Why this may help:** HiGHS can handle these linear equalities directly, avoiding the encoding overhead of variable-index element constraints.

### 2. Interval domains for duration and demand

The original enumerated duration and demand domains were replaced with intervals between their activity-specific minimum and maximum values.

**Why this is valid:** although an interval may contain values absent from the original enumeration, the one-hot equations force every integer solution to take the duration and demand of an actual selected mode. The wider standalone domains therefore introduce no additional feasible scheduling solutions.

**Why this may help:** this avoids separately encoding non-contiguous domains whose restrictions are already enforced by mode selection.

### 3. Non-renewable budget preprocessing

For each resource \(k\) and activity \(j\), the reformulation computes

\[
L_{k,j}=\min_{m\in\mathrm{mode}[j]}\mathrm{mrreq}_{k,m}.
\]

A mode \(m\) of activity \(i\) is forbidden if, for any non-renewable resource \(k\),

\[
\mathrm{mrreq}_{k,m}+\sum_{j\ne i}L_{k,j}
>\mathrm{rcap}_k.
\]

**Why this is valid:** selecting that mode fixes activity \(i\)’s requirement to \(\mathrm{mrreq}_{k,m}\). Every other activity must select one of its own modes, so its requirement is at least \(L_{k,j}\). The displayed expression is therefore a lower bound on total consumption. If even that lower bound exceeds capacity, the original budget constraint cannot be satisfied.

This test remains valid with negative requirements or shared mode sets. Dependencies between selections can make the lower bound unattainable, but cannot make it exceed the consumption of a feasible selection.

**Why this may help:** fixing impossible mode Booleans before search can simplify mode choices and associated scheduling constraints.

## Preservation and Expected Effect

The reformulation retains the original external data interface, start-time bounds, precedence constraints, cumulative constraints, budget constraints, terminal-activity objective, and posted non-overlap conditions. It does not assume an acyclic precedence graph or remove modes merely because another mode appears preferable.

The mapping script copies the unchanged original independent variables—`mrun`, `start`, and `objective`—while preserving their encoded indices. The original model’s defined duration and demand arrays are recovered through its mode-selection constraints.

The expected benefit is a more direct mixed-integer formulation and earlier elimination of budget-infeasible modes. No instance-specific runtime improvement has been established.

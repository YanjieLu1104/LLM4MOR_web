# Workforce Scheduling Model: Background and Reformulation

## 1. Inferred real-world setting

The model represents workforce scheduling for **130 agents over six days**, with **11 time periods per day**. It seeks the smallest workforce capable of meeting period-specific demand while respecting daily and weekly working-time limits.

Each working day consists of a single uninterrupted block of at least four periods and at most ten periods. Agents have two weekly capacity classes: 95 agents can work up to 47 periods, and 35 can work up to 24 periods.

The model also requires a daily amount of surplus staffing: total assigned work above demand must be at least one quarter of the number of daily work blocks. The precise operational purpose of this surplus is not specified. Although a parameter named `Descanso_diario` suggests daily rest, it is unused, so the model does **not** impose a separate rest requirement.

## 2. Original mathematical structure

### Variables and objective

The original formulation declares **34,450 binary variables**:

| Variable | Count | Meaning inferred from its use |
|---|---:|---|
| `X[a,d,t]` | 8,580 | Agent works during a particular period |
| `XE[a,d,t]` | 8,580 | Agent starts a daily work block |
| `Y[a]` | 130 | Agent is selected |
| `Q[a,d,t]` | 8,580 | Assigned work counted as surplus rather than demand coverage |
| `B[a,d,t]` | 8,580 | Unused variable, with no inferable operational role |

The objective is to **minimize the number of selected agents**, \(\sum_a Y_a\). Selection does not itself require an agent to work, although unused selected agents are unattractive to this objective.

### Constraints

The source defines **44,662 scalar constraints**, before presolve:

- **R1:** Weekly work cannot exceed the selected agent’s weekly capacity.
- **R2–R3:** Daily work is bounded above by daily capacity and below by four times the number of starts.
- **R4:** Assigned work equals demand plus surplus work in every period.
- **R5–R6:** Work cannot precede a start, and a transition from not working to working requires a start.
- **R7–R8:** Surplus work can only be assigned to a working agent whose day has a start.
- **R9:** Each selected agent has at most one start per day; unselected agents have none.
- **R10:** Only selected agents may work.
- **R11:** Daily surplus work must be at least one quarter of the total number of starts.

Together, these constraints give each nonempty agent-day exactly one contiguous work block. In particular, R5 requires a start no later than the first working period, while R6 requires a start at that first period if it is not period 1. R9 prevents any additional start, so work cannot resume after stopping.

## 3. Reformulation and justification

### Elimination of surplus-allocation variables

The reformulation removes `Q` and replaces R4 with direct coverage inequalities:

\[
\sum_a X_{adt}\geq \mathrm{Demanda}_{dt}.
\]

Summing R4 over periods and substituting into R11 gives the aggregate daily condition

\[
4\left(\sum_{a,t}X_{adt}-\sum_t\mathrm{Demanda}_{dt}\right)
\geq \sum_{a,t}XE_{adt}.
\]

This elimination is exact for the supplied instance because its demands are nonnegative integers. For any binary assignment satisfying coverage, the period surplus
\[
s_{dt}=\sum_aX_{adt}-\mathrm{Demanda}_{dt}
\]
is an integer between zero and the number of working agents. Therefore, exactly \(s_{dt}\) working agents can be assigned `Q = 1`.

This reconstruction satisfies R4 and R7. It also satisfies R8 because every working agent-day has a start. The aggregate inequality ensures R11. Thus, individual surplus allocations need not be decision variables.

### Removal of unused variables

All `B` variables are removed because they appear in neither the objective nor any constraint. Setting them to zero reconstructs a valid original assignment without affecting feasibility or objective value.

The unused `Descanso_diario` declaration is retained without inventing missing values or adding rest constraints.

### Stronger daily work-block formulation

The original capacity-scaled prefix inequalities are replaced by

\[
X_{adt}\leq\sum_{s\leq t}XE_{ads},
\]

and minimum-duration inequalities are added:

\[
X_{adt}\geq
\sum_{\substack{s\leq t\\s>t-4}}XE_{ads}.
\]

These inequalities express the original block structure more directly: work requires an earlier or simultaneous start, and a start forces four consecutive working periods.

Their validity follows from R3, R5, R6, and R9: an original working day has one contiguous block beginning at its unique start, and R3 makes that block at least four periods long. Conversely, the new inequalities, retained transition constraints, and single-start bound enforce this same structure. The daily capacity bound then also implies the original capacity-scaled prefix constraints.

**Late-start preprocessing** fixes starts in periods 9–11 to zero. A start there cannot accommodate four consecutive working periods before the end of the 11-period day.

### Relaxation of start-variable integrality

`XE` is changed from binary to continuous between zero and one, without introducing fractional starts in solutions with binary `X`.

To see why:

- If an agent does not work that day, the minimum-duration inequalities force every start to zero.
- If the first working period is period 1, the prefix inequality forces `XE` in that period to one.
- If the first working period is later, the retained transition inequality forces its start to one.
- The single-start bound forces all other starts to zero.

Thus, start integrality follows from the remaining constraints rather than requiring explicit binary declarations.

### Symmetry breaking among interchangeable agents

The reformulation orders both selection and total weekly workload within classes having identical daily capacity, weekly capacity, and minimum block length.

These restrictions preserve an optimal representative because agents within a class have identical operative parameters and objective coefficients. Their complete schedules can be permuted without changing demand coverage, daily surplus, capacities, or objective value. Ordering selected agents first and sorting their workloads gives the required representative; unselected agents necessarily have zero workload.

These are **symmetry-breaking restrictions**, not inequalities satisfied by every original labeling.

## 4. Result and expected computational effect

The reformulated model declares **8,710 binary variables** and **8,580 continuous start variables**, of which 2,340 have zero upper bounds.

The intended computational benefits are fewer explicit binary decisions, removal of unnecessary surplus-allocation choices, stronger work-block inequalities, and reduced agent-permutation symmetry. The mapping script restores surplus variables deterministically and sets unused `B` variables to zero, preserving the original objective and feasibility.

No solver timings were reported, so these are structural improvements rather than a demonstrated runtime reduction.

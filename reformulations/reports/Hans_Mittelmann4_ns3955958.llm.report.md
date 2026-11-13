# Workforce Scheduling Model: Structure and Reformulation

## 1. Inferred application

The model represents a **workforce scheduling problem**: select agents and assign working periods so that staffing meets a time-dependent demand while minimizing the number of agents selected.

The supplied instance contains **130 agents**, **one day**, and **44 discrete periods**. Staffing demand ranges from 53 to 119 agents per period. Each working agent must work at least 16 periods and at most 40 periods that day. Weekly capacities are also supplied, although they do not restrict schedules in this one-day instance.

The duration of a period and the operational setting are not specified. Although a daily-rest parameter is declared, it is unused and has no supplied values; the model therefore does not enforce daily-rest requirements.

## 2. Original formulation

### Variables and objective

The original model declares **23,010 binary variables**:

| Variable | Count | Role |
|---|---:|---|
| `X[a,d,t]` | 5,720 | Agent works during a period |
| `XE[a,d,t]` | 5,720 | Start indicator associated with the agent’s daily work |
| `Y[a]` | 130 | Agent is selected |
| `Q[a,d,t]` | 5,720 | Removes a working agent’s contribution from effective demand coverage |
| `B[a,d,t]` | 5,720 | Unused variable, with no effect on feasibility or cost |

The objective minimizes the number of selected agents:

\[
\min \sum_a Y_a.
\]

The interpretation of `Q` follows from its mathematical role rather than an explicit application description: effective staffing is \(\sum_a(X_{adt}-Q_{adt})\).

### Constraints

The formulation contains **29,034 constraints**, excluding variable bounds:

- **R1:** limits total work by weekly capacity and selection.
- **R2–R3:** impose daily maximum and minimum work, scaled by the number of starts.
- **R4:** matches effective staffing exactly to demand.
- **R5:** requires each cumulative prefix of work to be supported by a start within that prefix.
- **R6:** permits a transition from not working to working only when a start occurs.
- **R7:** allows `Q` only when the agent is working.
- **R8:** allows `Q` only when the agent has a daily start.
- **R9:** permits at most one daily start and requires selection for a start.
- **R10:** permits work only for selected agents.

Commented-out constraints are not part of the mathematical model.

## 3. Reformulation and justification

The reformulation replaces individual-agent schedules with **integer counts of feasible working intervals**.

### A. Deriving contiguous working intervals

This reduction follows directly from the original constraints:

1. **R9** and binary `Y` permit at most one start per agent.
2. If the first working period is period 1, **R5** requires a start in period 1.
3. If the first working period is later, **R6** requires a start exactly at that transition.
4. After work stops, another transition into work would require a second start under **R6**, contradicting **R9**.

Consequently, every working agent has exactly one contiguous working interval. With one start, **R2–R3** require its length to be between **16 and 40 periods**.

Conversely, any contiguous interval of that length satisfies these scheduling constraints when its start indicator is placed at its first period and the agent is selected. Thus the interval representation is exact for working agents.

### B. Removing redundant weekly restrictions

There is only one day, and **R2** limits each working agent to 40 periods. Every supplied weekly capacity is either 96 or 188, so **R1** cannot further restrict such a schedule.

After this redundancy is recognized, all agents have identical feasible working intervals. The differing weekly-capacity values therefore do not prevent aggregation. The reformulated file retains the original values and includes checks for the conditions supporting this reduction.

### C. Projecting out surplus-coverage variables

From **R4** and nonnegative `Q`,

\[
\sum_a X_{adt}\geq \mathrm{Demanda}_{dt}.
\]

The converse also holds for the supplied integer demands. Whenever working coverage exceeds demand, set `Q` to one for exactly the surplus number of working agents and zero for everyone else. This satisfies **R4** and **R7**. It also satisfies **R8**, because every working agent has a start.

Demand equalities can therefore be replaced by **coverage inequalities**, eliminating `Q` from the optimization model without changing which working schedules can cover demand.

### D. Aggregating interchangeable agents

For each feasible interval \([s,e]\), the reformulation introduces a nonnegative integer variable counting agents assigned to that interval. There are

\[
\sum_{\ell=16}^{40}(44-\ell+1)=425
\]

such intervals.

The new constraints require:

- enough intervals covering each of the 44 periods to meet demand;
- no more than 130 intervals in total.

The objective minimizes the total interval count. This **symmetry-reducing aggregation** avoids distinguishing schedules that differ only by a permutation of agent labels.

A selected agent with no work cannot occur in an optimum: **R3** forces its start variables to zero, **R7** forces its `Q` variables to zero, and deselecting it preserves feasibility while improving the objective. Thus counting working intervals preserves the optimal objective and at least one optimal solution, although it omits nonoptimal solutions containing unnecessarily selected agents.

### E. Eliminating unused variables and reconstructing solutions

The `B` variables have no constraints beyond their binary domains and do not appear in the objective. They can be omitted and reconstructed as zero.

The mapping script assigns each interval copy to a distinct original agent, reconstructs `X`, `XE`, and `Y`, and assigns surplus coverage to `Q` as described above. Unassigned agents receive zero-valued variables.

## 4. Result

The reformulated model has **425 integer variables and 45 optimization constraints**, plus data-validation checks. It preserves the minimization direction and optimal objective.

The main techniques are **structural interval reformulation, redundant-constraint preprocessing, exact projection of surplus variables, and aggregation of interchangeable agents**. No additional cutting planes were introduced. The expected computational benefit comes from the much smaller model and removal of agent-label symmetry; no measured runtime improvement is claimed.

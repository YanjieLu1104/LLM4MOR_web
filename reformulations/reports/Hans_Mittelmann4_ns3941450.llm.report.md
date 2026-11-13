# Workforce Scheduling Model: Structure and Reformulation

## 1. Inferred application

The model represents workforce scheduling for **130 agents over five days**, with **44 time periods per day**. Each day-period has a specified staffing requirement.

Agents have a daily capacity of 40 periods per activation. Weekly capacity is 188 periods for agents 1–100 and 96 periods for agents 101–130. Each agent-day must contain at least 16 working periods per activation.

The formulation appears intended to schedule work spells while allowing excess staffing. However, its mathematical interpretation requires several qualifications:

- Multiple activations are allowed for an agent on the same day.
- Daily capacity and minimum-duration constraints apply to **total daily work relative to the number of activations**, not separately to each work spell.
- Despite the objective name `AGENTES`, the model minimizes **activations**, not the number of distinct agents.
- The declared daily-rest parameter is unused; no daily-rest requirement is enforced.

## 2. Original mathematical structure

### Variables

The original model declares **114,530 binary variables**:

| Variable | Number | Interpretation from the constraints |
|---|---:|---|
| `X[a,d,t]` | 28,600 | Agent \(a\) works during period \(t\) of day \(d\) |
| `XE[a,d,t]` | 28,600 | Activation that permits work to begin or resume |
| `Y[a]` | 130 | Enables the agent’s weekly working capacity |
| `Q[a,d,t]` | 28,600 | Marks working capacity counted as surplus to demand |
| `B[a,d,t]` | 28,600 | Unused decision variable |

### Constraints

There are **115,400 scalar constraints** in the active original formulation, excluding variable bounds and integrality declarations.

- **`R1`: Weekly capacity.** Total work cannot exceed `Cap_sem[a] * Y[a]`.
- **`R2`: Daily capacity.** Total daily work cannot exceed 40 times the number of daily activations.
- **`R3`: Minimum daily work per activation.** Total daily work must be at least 16 times the number of daily activations.
- **`R4`: Staffing balance.** Working agents equal required demand plus declared surplus.
- **`R5`: Prefix capacity.** Work accumulated through any period cannot exceed 40 times the activations accumulated through that period.
- **`R6`: Work transitions.** A change from not working to working requires an activation in the new period.
- **`R7`: Surplus eligibility.** Only a working agent can be counted as surplus.
- **`R8`: Surplus activation requirement.** Surplus is allowed only on an agent-day with an activation.

### Objective

The minimization objective is

\[
\min \sum_{a,d,t} XE[a,d,t].
\]

Neither agent participation through `Y` nor surplus staffing through `Q` is directly penalized.

## 3. Reformulation and validity

The reformulated model retains only `X` and `XE`, leaving **57,200 binary variables**. Its objective and optimization direction are unchanged.

### 3.1 Elimination of unused variables

`B` appears in no active constraint or objective. Consequently, it has no effect on feasibility or cost and can be removed. The solution mapping assigns every original `B` variable zero, which satisfies its binary domain.

### 3.2 Elimination of unpenalized agent-enabling variables

`Y[a]` appears only in `R1`:

\[
\sum_{d,t}X[a,d,t]\leq Cap\_sem[a]Y[a].
\]

Because weekly capacities are nonnegative and `Y` has no objective cost, choosing `Y[a] = 1` can only relax this constraint. Thus its exact projection onto the remaining variables is

\[
\sum_{d,t}X[a,d,t]\leq Cap\_sem[a].
\]

Every original feasible solution satisfies this projected constraint, and every reformulated feasible solution extends to an original feasible solution by setting all `Y` values to one.

### 3.3 Projection of surplus variables into coverage inequalities

The staffing equations and surplus restrictions are replaced by

\[
\sum_a X[a,d,t]\geq Demanda[d,t].
\]

**Necessity:** Original `R4`, together with nonnegative `Q`, immediately implies this inequality.

**Sufficiency:** For binary `X` and the supplied integer demand, the surplus
\[
\sum_a X[a,d,t]-Demanda[d,t]
\]
is a nonnegative integer no larger than the number of working agents. Assign `Q = 1` to exactly that many working agents and zero to the others. This satisfies `R4` and `R7`.

It also satisfies `R8`: if an agent works during any period of a day, `R2` forces that agent-day to have at least one activation. Therefore every selected surplus agent satisfies the activation requirement.

This is an exact **integer-feasible projection**. The mapping selects surplus agents deterministically in increasing agent-index order.

### 3.4 Prefix-constraint reduction and strengthening

At period 1, original `R5` is

\[
X[a,d,1]\leq 40XE[a,d,1].
\]

For binary variables, this is equivalent to the stronger linear inequality

\[
X[a,d,1]\leq XE[a,d,1].
\]

Together with transition constraints `R6`, this ensures that any prefix containing work also contains an activation: the first working period either is period 1 or follows a nonworking period.

For a prefix ending at period \(t\leq40\):

- If it contains no activation, it contains no work.
- If it contains an activation, its work total is at most \(t\leq40\), while the right-hand side of `R5` is at least 40.

Hence these prefix-capacity constraints are redundant. The period-44 constraint duplicates daily-capacity constraint `R2`. Only prefix constraints for periods **41–43** remain.

This combines **binary-domain strengthening** with **redundant-constraint elimination**.

### 3.5 Valid daily activation bounds

Let \(k\) denote an agent’s daily activation count and \(W\) its daily work total. Since there are 44 periods,

\[
W\leq44.
\]

Original `R3` gives \(W\geq16k\). Therefore, because \(k\) is integer,

\[
k\leq\left\lfloor\frac{44}{16}\right\rfloor=2.
\]

The reformulation adds this explicit bound. It is an **integer-rounding cut** derived from the minimum-work constraint and the finite horizon.

### 3.6 Daily-capacity envelope cuts

The reformulation also adds

\[
W\leq36+4k.
\]

This inequality is valid for every possible integer activation count:

- For \(k=0\), `R2` forces \(W=0\).
- For \(k=1\), `R2` gives \(W\leq40\).
- For \(k=2\), the horizon gives \(W\leq44\).

These are all possible counts by the preceding bound. The cut connects the one-activation and two-activation capacity limits and strengthens the relaxation when the activation count is fractional.

### 3.7 Symmetry breaking among interchangeable agents

Agents with identical daily capacity, weekly capacity, and minimum-work parameters are interchangeable in every active constraint and in the objective.

The reformulation orders total weekly activation counts between adjacent agents within each identical-parameter group. This is valid because complete schedules can be permuted among such agents without changing staffing coverage, feasibility, or objective value. Sorting their activation counts therefore retains at least one representative of every relevant symmetry class, including an optimal solution.

Unlike the variable projections above, this step intentionally removes equivalent labeled schedules rather than preserving every original assignment.

## 4. Expected computational effect

The reformulation removes surplus-allocation and unused-variable decisions, substantially reduces the prefix-constraint system, strengthens the continuous relaxation, and reduces agent-permutation symmetry. These changes target a smaller and less redundant mixed-integer search while preserving an original optimal solution under the supplied mapping.

No solver benchmark was reported, so reduced solution time remains an expected benefit rather than a measured result.

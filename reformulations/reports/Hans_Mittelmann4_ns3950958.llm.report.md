# Workforce Scheduling Model: Structure and Reformulation

## 1. Background and interpretation

The model represents a workforce-selection and scheduling problem with **130 agents**, **five days**, and **44 periods per day**. Its terminology and constraints suggest a service operation—such as a contact center—that must maintain specified staffing levels throughout each day. The particular application and the duration of each period are not stated.

The objective is to meet staffing demand using as few selected agents as possible. Each agent may work at most one shift per day. A working shift must contain at least **16 periods** and at most **40 periods**. Weekly working-time limits distinguish two agent groups:

- Agents 1–100: at most **188 periods** each.
- Agents 101–130: at most **96 periods** each.

Although a parameter named `Descanso_diario` (“daily rest”) is declared, it is neither supplied with values nor used in an active constraint. Thus, no interday rest requirement should be inferred.

The model permits staffing above demand. The original `Q` variables account for that excess; despite their possible operational interpretation, no active constraint requires breaks or specifies their timing.

## 2. Original mathematical structure

### Variables and objective

The original model declares **114,530 binary variables**:

| Variable | Count | Meaning implied by the constraints |
|---|---:|---|
| `X[a,d,t]` | 28,600 | Agent `a` is working in period `t` on day `d` |
| `XE[a,d,t]` | 28,600 | Agent `a` starts the daily working interval in period `t` |
| `Y[a]` | 130 | Agent `a` is selected |
| `Q[a,d,t]` | 28,600 | Working assignment counted as excess rather than required coverage |
| `B[a,d,t]` | 28,600 | Unused binary variable |

The objective is to **minimize the number of selected agents**, \(\sum_a Y[a]\).

### Constraints

There are **144,650 explicitly indexed constraints**, excluding variable bounds and integrality declarations:

- **R1:** Weekly working-time limits linked to selection.
- **R2–R3:** Daily working time lies between the minimum and maximum shift lengths, multiplied by the number of starts.
- **R4:** Total working assignments equal demand plus excess assignments.
- **R5:** A prefix of the day cannot contain work unless a start has already occurred.
- **R6:** Every transition from not working to working requires a start.
- **R7:** Excess assignments can occur only while working.
- **R8:** Excess assignments require a daily start.
- **R9:** At most one daily start, and only for a selected agent.
- **R10:** Only selected agents may work.

Together, these constraints imply a single contiguous working interval on each working agent-day. Specifically, R9 permits at most one start. R5 requires a start by the first working period, while R6 requires a start precisely at any later transition into work. A second working interval would therefore require a second start and violate R9. R2–R3 then bound the interval length between 16 and 40 periods.

## 3. Reformulation and justification

### Eliminate excess-coverage variables

R4 and nonnegativity of `Q` imply
\[
\sum_a X[a,d,t]\geq \mathrm{Demanda}[d,t].
\]
The reformulation uses this inequality directly and removes `Q`, R7, and R8.

This elimination is exact for the supplied data. Demand is integral, so any binary working schedule satisfying the inequality has an integer surplus. Assigning `Q=1` to exactly that many working agents restores R4 and R7. Every working agent-day has a start, so R8 also holds. There are no other active restrictions on `Q`.

The mapping script performs this reconstruction deterministically.

### Remove unused variables

`B` appears in neither the objective nor any constraint. Removing it cannot affect feasibility or objective values. The mapping assigns every original `B` variable zero, which satisfies its binary domain.

### Replace dense prefix constraints

The original R5 family sums working and start variables over every prefix of the day. It is replaced by
\[
X[a,d,1]\leq XE[a,d,1],
\]
while retaining R6.

This is sufficient because any first working period after period 1 requires a start through R6. The one-start restriction R9 then prevents restarting after work stops. For a prefix containing work, the start has occurred and its working time cannot exceed total daily working time, which R2 bounds by `Cap_dia`. A prefix preceding the start contains no work. Thus every original R5 inequality follows.

R10 is also redundant: if `Y=0`, R9 forces all starts to zero, and the first-period inequality together with R6 forces all working variables to zero.

### Relax startup-variable integrality

`XE` is changed from binary to continuous with bounds between zero and one.

For any nonempty binary working schedule, the first-period inequality or R6 forces the first working period’s startup variable to be at least one. R9 limits the sum of starts to at most one, so that start equals one and all others equal zero. If there is no work, R3 and the positive 16-period minimum force every start to zero.

Consequently, `XE` remains integral whenever `X` and `Y` are integral. This is an **implied-integrality reformulation**.

### Add minimum-duration cuts and fix impossible starts

The reformulation adds
\[
X[a,d,t]\geq
\sum_{\substack{s\leq t\\t<s+\mathrm{Periodos\_min}[a]}}XE[a,d,s].
\]

These inequalities express the minimum shift length locally: a start requires work throughout the following 16-period interval. They are valid because the original model permits only one contiguous interval and R3 requires that interval to last at least 16 periods. They strengthen the continuous relaxation without excluding original feasible schedules.

Starts in periods **30–44** are fixed to zero: fewer than 16 periods remain in the day, so such starts cannot satisfy contiguity and R3. This fixes **9,750 startup variables**.

### Break selection symmetry

Selection-order inequalities impose `Y[a] >= Y[a+1]` only between adjacent agents with identical daily capacities, weekly capacities, and minimum shift lengths.

All active agent-specific restrictions are identical within these groups. Permuting complete schedules among interchangeable agents preserves coverage, feasibility, and objective value. Therefore, an optimal solution can always be relabeled to satisfy the ordering. This removes symmetric alternatives while preserving at least one optimum.

## 4. Result

The reformulated model retains **28,730 binary variables** and **28,600 continuous startup variables**, including the 9,750 fixed to zero. It preserves the minimization objective and all supplied instance data.

The intended computational benefits come from fewer integer variables, elimination of surplus-assignment symmetry, removal of dense prefix constraints, stronger minimum-duration implications, and selection symmetry breaking. These are formulation-based improvements; no measured solve-time reduction was established in the conversation.

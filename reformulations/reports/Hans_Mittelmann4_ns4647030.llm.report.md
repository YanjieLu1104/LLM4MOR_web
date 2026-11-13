# Fuel-Cell and Energy-Storage Scheduling Reformulation

## Background and interpretation

The model represents a **1,400-period operating schedule for a fuel cell coupled to an energy-storage device**. This interpretation follows from the variable names, discrete fuel-cell operating points, and storage-loss equations; the source does not specify the application or physical units.

The fuel cell can be off or operate at one of five prescribed power–cost pairs. Storage can absorb or supply power, subject to power limits and cumulative energy bounds. The objective is to minimize total fuel-cell operating cost while meeting the specified demand and ending with at least the initial stored energy.

Demand may be negative, consistent with periods of available regenerative energy. Importantly, the model permits supply to exceed demand and permits simultaneous charging and discharging. Neither feature was removed in the reformulation.

## Original mathematical structure

### Variables and objective

For each period, the original model contains:

- `X_FC`: continuous fuel-cell output between 0 and 60.
- `X_ES_in`: continuous charging power between −60 and 0.
- `X_ES_out`: continuous discharging power between 0 and 60.
- `CostFC`: nonnegative fuel-cell operating cost.
- Five binary `Effpt` variables selecting a fuel-cell operating point.

Thus, the instance has **5,600 continuous variables and 7,000 binary variables**. Its objective minimizes the sum of `CostFC` over all periods.

At most one operating point may be selected. Selecting none sets fuel-cell output and cost to zero through their defining constraints.

### Constraints

The original model has **8,401 scalar constraints**, excluding variable bounds:

| Constraint family | Count | Meaning |
|---|---:|---|
| Demand satisfaction | 1,400 | Fuel-cell output plus net storage output meets or exceeds demand |
| Minimum stored energy | 1,400 | Limits cumulative storage depletion |
| Maximum stored energy | 1,400 | Limits cumulative storage accumulation |
| Fuel-cell output definition | 1,400 | Links output to the selected operating point |
| Fuel-cell cost definition | 1,400 | Links cost to the selected operating point |
| Operating-point selection | 1,400 | Allows at most one selected point |
| Terminal restoration | 1 | Requires final energy to be at least initial energy |

The storage constraints contain overlapping prefix sums, creating a quadratic number of matrix entries as the time horizon grows.

## Reformulation and validity

### 1. Sparse inventory-state formulation

An auxiliary variable, `rf4_energy[t]`, represents stored energy. Define
\[
\alpha=1+\texttt{losscoefSEin}=0.93,\qquad
\beta=1+\texttt{losscoefSEout}=1.0752688172043010.
\]

The reformulation uses the recurrence
\[
E_t=E_{t-1}-\alpha X_{\mathrm{ES,in},t}
                  -\beta X_{\mathrm{ES,out},t},
\]
with \(E_0=900\), \(400\le E_t\le1600\), and \(E_{1400}\ge900\).

**Validity:** Summing the recurrence gives exactly the cumulative expression in the original energy constraints. The state bounds therefore reproduce both original prefix inequalities, and the terminal bound reproduces `RestoreInitialLevel`. Conversely, every original feasible solution uniquely determines these auxiliary states.

This is an **extended formulation using inventory-balance equations**. It replaces dense cumulative rows with local, sparse equations, reducing storage-related matrix growth from quadratic to linear.

### 2. Operating-point feasibility preprocessing

An operating-point binary is fixed to zero whenever
\[
x_j+60<PDem_t.
\]

**Validity:** If point \(j\) is selected, the original selection and output equations imply \(X_{\mathrm{FC},t}=x_j\). Because charging power is nonpositive and discharge is at most 60, total supply cannot exceed \(x_j+60\). Such a point cannot satisfy the original demand constraint.

Similarly, when \(PDem_t>60\), the reformulation requires exactly one point to be selected. With no selection, fuel-cell output is zero and storage alone cannot supply more than 60.

These are **constraint-based binary fixing and off-state elimination**, not assumptions about preferred operating behavior.

### 3. Operating-point-dependent storage-depletion cuts

For residual demand \(r\), define
\[
L(r)=\max\{\alpha(-60),\alpha r,\beta r\}.
\]

**Validity:** Write charging and discharging power as \(u\le0\) and \(v\ge0\). Demand satisfaction requires \(u+v\ge r\), and storage depletion is \(d=\alpha u+\beta v\). Since \(\beta>\alpha>0\),
\[
d\ge\alpha(-60),\qquad d\ge\alpha r,\qquad d\ge\beta r.
\]
Consequently, \(d\ge L(r)\).

The added inequality combines \(L(PDem_t)\) for the off state with \(L(PDem_t-x_j)\) for each selected point. Because the binaries select at most one point, this inequality reduces to the appropriate valid bound at every integer solution.

These **disjunctive valid inequalities** can strengthen the LP relaxation without excluding original feasible schedules.

## Preservation and expected benefit

All original decision variables, input values, and the minimization objective are retained. The solution mapping simply removes auxiliary inventory variables. The reformulation targets faster solution through a sparser matrix, infeasible-choice preprocessing, and stronger relaxation bounds; no measured runtime improvement was established in the conversation.

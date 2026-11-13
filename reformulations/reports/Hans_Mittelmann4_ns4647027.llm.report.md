# Fuel-Cell and Energy-Storage Scheduling Model

## Background and interpretation

This instance represents the operation of a fuel cell coupled with an energy-storage device over **1,400 time periods**. The interpretation follows from the variable names, power-balance constraints, and storage-loss coefficients; the source does not specify a particular application or physical units.

The fuel cell can be off or operate at one of three discrete power levels: **1, 30.5, and 60**, with corresponding period costs of **8.3701, 66.2805, and 158.7023**. Storage can absorb or supply power, subject to charging and discharging limits and an energy-capacity range.

Demand can be negative, consistent with periods of available regenerative energy or surplus power. Since the demand constraint is an inequality, the model does not require exact power balance or absorption of every available surplus. Likewise, simultaneous charging and discharging are permitted by the original formulation.

## Original mathematical structure

### Variables and objective

The original model contains **9,800 variables**:

| Variable | Meaning | Type and count |
|---|---|---:|
| `X_FC[i]` | Fuel-cell power, bounded between 0 and 60 | 1,400 continuous |
| `X_ES_in[i]` | Charging power, represented negatively, between −60 and 0 | 1,400 continuous |
| `X_ES_out[i]` | Discharging power, between 0 and 60 | 1,400 continuous |
| `CostFC[i]` | Nonnegative fuel-cell operating cost | 1,400 continuous |
| `Effpt[i,j]` | Selection of efficiency point \(j\) in period \(i\) | 4,200 binary |

The objective **minimizes total fuel-cell cost**:
\[
\min \sum_{i=1}^{1400}\mathrm{CostFC}_i.
\]

### Constraints

There are **8,401 explicit constraints**, excluding variable bounds:

- **1,400 demand constraints:** fuel-cell power plus net storage power must meet or exceed demand.
- **2,800 cumulative storage constraints:** stored energy must remain between 400 and 1,600, starting from 900.
- **One terminal constraint:** final stored energy must be at least its initial value—not necessarily equal to it.
- **2,800 linking equalities:** selected efficiency points determine fuel-cell power and cost.
- **1,400 selection constraints:** at most one efficiency point may be selected per period. Selecting none represents the off state.

Define period storage depletion as
\[
d_i=0.93X_{\mathrm{ES,in},i}
   +1.075268817204301X_{\mathrm{ES,out},i}.
\]
The original storage constraints bound each prefix sum of \(d_i\). Consequently, although the number of rows is linear in the horizon, the cumulative storage rows contain a **quadratic number of nonzero coefficients**.

## Reformulation and justification

### 1. Sparse storage-state formulation

The reformulation introduces stored-energy variables \(E_i\), including an initial state, and imposes
\[
E_0=900,\qquad E_i=E_{i-1}-d_i,
\]
with
\[
400\le E_i\le1600,\qquad E_{1400}\ge900.
\]

This is an **exact extended formulation**. Summing the recurrence gives
\[
E_i=900-\sum_{k=1}^{i}d_k.
\]
Thus, the state bounds reproduce both original cumulative storage inequalities, and the terminal bound reproduces the original restoration inequality. Conversely, every original feasible solution uniquely defines these energy states.

This replacement reduces the storage representation from quadratic to linear matrix size. It is intended to reduce model-generation, memory, and LP-processing costs without changing the feasible assignments of the original variables.

### 2. Demand-based preprocessing of discrete choices

An efficiency point with power \(p_j\) is fixed unavailable in period \(i\) whenever
\[
p_j+60<\mathrm{PDem}_i.
\]

This follows directly from the original constraints: selecting point \(j\) fixes fuel-cell power to \(p_j\), charging power is nonpositive, and discharging power cannot exceed 60. Therefore, even the largest possible demand-constraint left-hand side would be insufficient.

Similarly, when \(\mathrm{PDem}_i>60\), the selection constraint is strengthened from “at most one” to **exactly one**. With no selected point, the fuel-cell linking equality gives zero fuel-cell power, so storage alone cannot meet such demand.

These are **bound-based feasibility deductions**, not assumptions about desirable operating behavior. All original binary variables remain declared.

### 3. Disjunctive storage-depletion cuts

The reformulation adds one valid inequality per period that uses the discrete fuel-cell choice to strengthen the LP relaxation.

Let
\[
a=0.93,\qquad b=1.075268817204301,
\]
and suppose the selected fuel-cell power is \(p\). Write \(u=X_{\mathrm{ES,in},i}\), \(v=X_{\mathrm{ES,out},i}\), and \(q=\mathrm{PDem}_i-p\). The original model implies
\[
u+v\ge q,\qquad -60\le u\le0,\qquad v\ge0.
\]
Since \(0<a<b\), depletion satisfies all three bounds:
\[
au+bv\ge -60a,
\]
\[
au+bv=a(u+v)+(b-a)v\ge aq,
\]
\[
au+bv=b(u+v)+(a-b)u\ge bq.
\]
Hence a valid conditional lower bound is
\[
L_i(p)=\max\{-60a,\;a(\mathrm{PDem}_i-p),\;b(\mathrm{PDem}_i-p)\}.
\]

Using the original at-most-one binary selection structure, the added cut is
\[
d_i\ge L_i(0)+
\sum_j\bigl(L_i(p_j)-L_i(0)\bigr)\mathrm{Effpt}_{i,j}.
\]
For every integer selection, its right-hand side is precisely the bound for the selected operating state, including the off state. The inequality therefore preserves every original integer-feasible solution, while potentially excluding fractional selections admitted by the original LP relaxation.

## Preservation and expected benefit

The reformulation retains all original decision variables, instance data, costs, and minimization direction. It does not impose exact demand balance, exact terminal-energy restoration, or charging/discharging exclusivity. The solution mapping simply omits the auxiliary energy states.

The principal expected benefit is the much sparser storage formulation, supplemented by infeasible-choice fixing and stronger relaxation bounds. **No solve-time improvement has been measured in the conversation**, so these are formulation-based expectations rather than benchmark results.

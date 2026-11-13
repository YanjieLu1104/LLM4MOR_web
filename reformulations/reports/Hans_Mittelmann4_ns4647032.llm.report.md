# Fuel-Cell Dispatch with Energy Storage: Model and Reformulation

## 1. Application background

The model appears to describe the operation of a **fuel-cell power source coupled with an energy-storage system** over 1,400 time periods. A prescribed demand profile must be supplied using fuel-cell generation and storage discharge; surplus generation or negative demand can support charging. Negative demand is consistent with regenerative energy, although the source does not explicitly identify the application.

The fuel cell can be off or operate at one of nine discrete power–cost points. Storage has charging and discharging power limits, energy-capacity limits, and asymmetric losses. The objective is to minimize total fuel-cell operating cost while ending with **at least** the initial stored energy.

Two modeling details matter: demand satisfaction is an inequality, so excess supply is permitted, and simultaneous charging and discharging are not prohibited. The reformulation retains both features.

## 2. Original mathematical structure

### Variables and objective

For each period, the model contains:

| Variable | Meaning | Domain |
|---|---|---|
| `X_FC` | Fuel-cell power | Continuous, 0 to 60 |
| `X_ES_in` | Charging power, represented negatively | Continuous, −60 to 0 |
| `X_ES_out` | Discharging power | Continuous, 0 to 60 |
| `CostFC` | Fuel-cell operating cost | Continuous, nonnegative |
| `Effpt` | Selection of one of nine operating points | Nine binary variables |

Thus, the instance has **5,600 continuous variables and 12,600 binary variables**. The objective minimizes the sum of `CostFC` over all periods.

At most one operating point can be selected per period. Two equalities define fuel-cell power and cost from the selected point. Selecting no point gives zero power and zero cost. The declared parameter `P_FC_min` does not impose a separate minimum-output constraint.

### Constraints

The original formulation has **8,401 constraints**, excluding variable bounds:

- 1,400 demand-satisfaction inequalities;
- 2,800 cumulative storage-energy inequalities;
- one terminal-storage inequality;
- 1,400 fuel-cell power-definition equalities;
- 1,400 cost-definition equalities;
- 1,400 operating-point selection inequalities.

Let \(u_t=X_{\mathrm{ES,in},t}\), \(v_t=X_{\mathrm{ES,out},t}\), and define storage depletion as
\[
q_t=a u_t+b v_t,
\qquad
a=1+\texttt{losscoefSEin}=0.93,\quad
b=1+\texttt{losscoefSEout}\approx1.07527.
\]
The original storage constraints bound every prefix sum of \(q_t\). These repeated prefix sums produce a quadratic number of matrix coefficients as the time horizon grows.

## 3. Reformulation and its justification

### Sparse inventory-state reformulation

An auxiliary stored-energy variable \(E_t\) replaces the cumulative expressions:
\[
E_0=900,\qquad E_t=E_{t-1}-q_t,
\qquad 400\le E_t\le1600.
\]
The terminal condition becomes \(E_{1400}\ge900\).

This is an **exact extended formulation**. Summing the balance equations gives
\[
E_t=900-\sum_{k=1}^{t}q_k.
\]
Consequently, the energy-variable bounds are precisely the original cumulative storage inequalities, and the terminal bound is precisely the original total-depletion inequality. Conversely, every original feasible solution uniquely determines these inventory variables.

This introduces 1,401 continuous variables but replaces dense cumulative rows with local balance equations. The intended benefit is lower matrix-storage and linear-algebra cost, not a change in the feasible operating schedules.

### Demand-based operating-point preprocessing

An operating-point binary is fixed to zero whenever
\[
x_j+60<D_t,
\]
where \(x_j\) is that point’s power and \(D_t\) is demand.

This follows directly from the original constraints: selecting point \(j\) forces fuel-cell power to \(x_j\), charging power cannot exceed zero, and discharging power cannot exceed 60. Total supply therefore cannot exceed \(x_j+60\), making that point infeasible when the inequality holds.

Likewise, when \(D_t>60\), the selection constraint is strengthened from “at most one point” to “exactly one point.” With no point selected, fuel-cell power is zero, so storage alone cannot meet such demand.

These are **logical bound-tightening and infeasible-choice preprocessing**, not economic dominance assumptions.

### Operating-point-dependent depletion cuts

The reformulation adds one valid depletion inequality per period. For a fixed fuel-cell output \(x\), write \(d=D_t-x\). Demand satisfaction implies
\[
u_t+v_t\ge d.
\]
Because \(b\ge a>0\), \(u_t\le0\), \(v_t\ge0\), and \(u_t\ge-60\), the original constraints imply
\[
q_t\ge ad,\qquad q_t\ge bd,\qquad q_t\ge-60a.
\]
For example,
\[
q_t=a(u_t+v_t)+(b-a)v_t\ge ad,
\]
and the other bounds follow analogously. Hence a valid lower bound is
\[
L_t(x)=\max\{a(D_t-x),\,b(D_t-x),\,-60a\}.
\]

Using the operating-point binaries \(z_{tj}\), the added cut is
\[
q_t\ge
L_t(0)+\sum_j\bigl(L_t(x_j)-L_t(0)\bigr)z_{tj}.
\]
For every integer selection, the right-hand side equals the valid bound for the chosen operating point—or for the off state. Thus, the cut excludes no original integer-feasible solution. It is a **disjunctive valid inequality** that can strengthen the continuous relaxation by exploiting discrete fuel-cell choices.

## 4. Preservation and expected benefit

All original decision variables and instance data are retained. The solution mapping simply discards the auxiliary inventory variables. Objective values, minimization direction, and the original feasible schedules are preserved.

The expected computational gains come from **sparser storage equations**, **early exclusion of infeasible choices**, and **stronger relaxation bounds**. No measured solve-time improvement was established in the conversation.

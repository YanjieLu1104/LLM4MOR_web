# Reformulation Report: Fuel-Cell and Energy-Storage Scheduling

## 1. Inferred application and background

The model appears to describe operational scheduling for a fuel-cell system coupled to electrical energy storage over **561 time periods**. The system must supply a time-varying power demand while minimizing fuel-cell operating cost.

The fuel cell can be off or operate at one of **nine discrete output–cost points**. Storage can absorb power through charging or supply power through discharging, subject to power limits and cumulative energy limits. Different charging and discharging coefficients account for losses.

Negative demand values may represent regenerative power or other available surplus energy, although the model does not explicitly identify their source. Importantly, demand satisfaction is an inequality: excess supply is permitted. The model also permits simultaneous charging and discharging.

Storage starts at an energy level of 900, must remain between 400 and 1,600, and must finish with **at least** its initial energy. The terminal condition is not an equality.

## 2. Original mathematical structure

### Decision variables

For each period, the model contains:

| Variable | Meaning | Domain |
|---|---|---|
| `X_FC` | Fuel-cell power output | Continuous, between 0 and 62 |
| `X_ES_in` | Signed charging power | Continuous, between −60 and 0 |
| `X_ES_out` | Discharging power | Continuous, between 0 and 60 |
| `CostFC` | Fuel-cell operating cost | Nonnegative continuous |
| `Effpt` | Selection of an output–cost point | Nine binary variables |

The original instance therefore has **2,244 continuous variables** and **5,049 binary variables**.

### Constraints

The model has **3,367 explicit constraints**, excluding variable bounds:

- **561 demand constraints:** fuel-cell output plus signed storage power must meet or exceed demand.
- **1 terminal storage constraint:** total loss-adjusted withdrawal cannot be positive.
- **1,122 cumulative storage constraints:** lower and upper energy limits apply after every period.
- **561 output-definition constraints:** fuel-cell output equals the output associated with the selected point.
- **561 cost-definition constraints:** operating cost equals the cost associated with that point.
- **561 selection constraints:** at most one point may be selected per period.

Selecting no point gives zero fuel-cell output and cost. Although `P_FC_min` is declared, it is not directly imposed as a variable bound; the smallest positive output is determined by the point data.

### Objective

The objective **minimizes total fuel-cell operating cost** over all periods. There is no separate storage operating cost.

The main structural inefficiency is the repeated use of cumulative sums in the storage constraints. Each later-period constraint includes all preceding charging and discharging decisions, producing a quadratic-size coefficient structure.

## 3. Reformulation and preprocessing

### Sparse storage-state formulation

The cumulative energy constraints were replaced by explicit energy states \(E_i\), linked by

\[
E_i=E_{i-1}-aX^{\mathrm{in}}_i-bX^{\mathrm{out}}_i,
\qquad
a=0.93,\quad b=1.075268817204301.
\]

The initial state is fixed at 900, subsequent states have bounds of 400 and 1,600, and the final state must be at least 900.

**Why this is valid:** Summing the balance equations gives

\[
E_i=900-\sum_{k=1}^{i}
\left(aX^{\mathrm{in}}_k+bX^{\mathrm{out}}_k\right).
\]

Substituting this expression into the state bounds reproduces both original cumulative storage inequalities. The terminal state bound likewise reproduces the original terminal withdrawal constraint.

This is an exact extended formulation. It introduces continuous states but replaces the dense cumulative structure with a linear-size sequence of local equations.

### Infeasible operating-point fixing

An efficiency-point binary is fixed to zero if its output or cost violates the original variable bounds, or if

\[
y_j+60<PDem_i.
\]

**Why this is valid:** Selecting point \(j\) forces `X_FC` to equal \(y_j\) and `CostFC` to equal its associated cost, because all other point indicators must be zero. Moreover, charging power cannot exceed zero and discharging power cannot exceed 60. Thus, \(y_j+60\) is the largest possible supply with that point selected. If this is below demand, the selection cannot occur in any feasible solution.

For the supplied point data, all output and cost values satisfy their respective bounds; the demand-based test provides the relevant fixing opportunities.

### Mandatory operation during high demand

For every period with demand greater than 60, the reformulation requires exactly one operating point.

**Why this is valid:** With no point selected, the output-definition equation forces fuel-cell output to zero. Storage alone can supply at most 60, so the original demand constraint rules out the off state. Together with the original at-most-one constraint, this implies exactly one selection.

### Disjunctive withdrawal cuts

Let \(r\) denote demand minus a fixed fuel-cell output. A valid lower bound on loss-adjusted storage withdrawal is

\[
g(r)=\max\{aP_{\mathrm{ES,min}},\,ar,\,br\}.
\]

To verify this, write charging and discharging powers as \(u\le0\) and \(v\ge0\), respectively. Demand requires \(u+v\ge r\). Since \(b\ge a>0\),

\[
au+bv\ge ar,\qquad
au+bv\ge br,\qquad
au+bv\ge aP_{\mathrm{ES,min}}.
\]

The reformulation combines these conditional bounds into the linear cut

\[
au_i+bv_i\ge
g(PDem_i)+
\sum_j
\left[g(PDem_i-y_j)-g(PDem_i)\right]Effpt_{i,j}.
\]

**Why this is valid:** At every integer-feasible solution, either no point is selected or exactly one is selected. The right-hand side therefore becomes the valid withdrawal bound for precisely that operating mode. These disjunctive cuts can strengthen the continuous relaxation without excluding any original feasible integer solution.

## 4. Preservation and expected benefit

All original decision variables, fixed data, and the minimization objective were retained. The reformulation preserves demand oversupply, simultaneous charging/discharging, and the original terminal inequality. The solution-mapping script simply removes auxiliary storage states.

The intended benefits are a substantially sparser storage representation, fewer available binary choices, and stronger relaxation bounds. Actual solve-time improvements remain solver-dependent and were not established by a computational benchmark.

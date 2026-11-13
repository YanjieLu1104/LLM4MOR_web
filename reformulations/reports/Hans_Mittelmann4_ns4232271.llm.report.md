# Fixed-Charge Redistribution Across 61 Locations

## Background and interpretation

The model describes a **multicommodity redistribution problem** involving 61 locations and 10 products. The Portuguese names suggest that the locations are stores: `Disponibilidade` denotes available stock, `Procura` denotes demand, `caixas` denotes boxes shipped, and `Envios` denotes activated shipments.

Each location’s available stock must be allocated to destinations, and each destination’s demand must be met exactly. Supply and demand are divided by five in the balance equations, suggesting a conversion from individual units to boxes of five. However, shipment quantities are continuous, so fractional boxes are permitted.

The model charges a fixed cost for using an origin–destination pair, independently of the quantity or number of products shipped along it. Location 61 appears to play a special balancing or external-depot role: its supply and demand are much larger than those of the other locations, its connections to them cost 50, and its self-shipment costs zero. This interpretation is inferred from the data rather than explicitly specified by the model.

## Original formulation

Let \(x_{ijk}\) denote `caixas[i,j,k]` and \(y_{ij}\) denote `Envios[i,j]`.

### Variables

- **37,210 continuous shipment variables** \(x_{ijk}\), indexed by 61 origins, 61 destinations, and 10 products.
- **3,721 binary activation variables** \(y_{ij}\), one per directed origin–destination pair.

Although the shipment variables are initially declared without bounds, explicit constraints impose nonnegativity.

### Constraints

The original model contains **42,751 explicit constraints**:

| Family | Count | Meaning |
|---|---:|---|
| Shipment activation | 3,721 | \(\sum_k x_{ijk}\le 10^6 y_{ij}\): positive flow requires an activated pair. |
| Supply balances | 610 | \(\sum_j x_{ijk}=\text{Disponibilidade}_{ik}/5\): all available stock must be shipped. |
| Demand balances | 610 | \(\sum_i x_{ijk}=\text{Procura}_{jk}/5\): demand must be met exactly. |
| Prohibited self-shipments | 600 | \(x_{iik}=0\) for locations 1–60. |
| Nonnegativity | 37,210 | \(x_{ijk}\ge 0\). |

Importantly, **self-shipments at location 61 are allowed**.

### Objective

The objective minimizes total activation cost:

\[
\min \sum_{i,j}\text{custo}_{ij}y_{ij}.
\]

There is no active per-unit transportation cost. A quantity-based objective appears only as a comment in the source.

## Reformulation and its justification

The reformulation retains all original decision variables, instance data, and objective coefficients. It strengthens the formulation using **bound propagation, variable fixing, arc-specific big-\(M\) tightening, and disaggregated activation inequalities**.

### 1. Replace explicit nonnegativity and diagonal rows with bounds

Nonnegativity is imposed directly through shipment-variable lower bounds. For locations 1–60, diagonal shipment variables receive both lower and upper bounds of zero.

These changes are exact translations of the original nonnegativity and diagonal constraints. They remove **37,810 explicit rows**, although additional activation inequalities are introduced elsewhere. They do not impose a diagonal restriction at location 61.

### 2. Derive commodity-specific upper bounds

Write

\[
s_{ik}=\frac{\text{Disponibilidade}_{ik}}5,
\qquad
d_{jk}=\frac{\text{Procura}_{jk}}5.
\]

For an allowed shipment, the reformulation uses

\[
U_{ijk}=\min\{s_{ik},d_{jk},10^6\}.
\]

This is valid because:

- Nonnegativity and the supply equality imply \(x_{ijk}\le s_{ik}\).
- Nonnegativity and the demand equality imply \(x_{ijk}\le d_{jk}\).
- The original activation constraint and \(y_{ij}\le1\) imply \(x_{ijk}\le10^6\).

For prohibited self-shipments, \(U_{iik}=0\).

Consequently, any shipment with zero origin supply or zero destination demand is fixed to zero. This is **data-driven bound propagation**, not an assumption that unused routes should be removed. The variables remain declared, allowing presolve to eliminate fixed columns while preserving the original variable interface.

### 3. Tighten the aggregate activation coefficient

The original coefficient \(10^6\) is replaced by

\[
M_{ij}=\min\left\{10^6,\sum_k U_{ijk}\right\},
\]

giving

\[
\sum_k x_{ijk}\le M_{ij}y_{ij}.
\]

For \(y_{ij}=0\), both formulations force every shipment on the pair to zero. For \(y_{ij}=1\), the new bound follows from the commodity upper bounds and the original aggregate capacity. Thus, no original integer-feasible solution is excluded.

This **arc-specific big-\(M\) tightening** reduces the excessive fractional activation permitted by the original linear programming relaxation.

### 4. Add disaggregated activation inequalities

For each commodity with \(U_{ijk}>0\), the reformulation adds

\[
x_{ijk}\le U_{ijk}y_{ij}.
\]

These inequalities are valid for binary activations: when \(y_{ij}=0\), the original packing constraint and nonnegativity already imply zero flow; when \(y_{ij}=1\), the inequality is the derived commodity upper bound.

They strengthen the relaxation by linking each product’s flow directly to the shared activation decision. Aggregate activation alone can permit a product’s flow to be supported by capacity associated with other products.

### 5. Derive transportation-balance lower bounds

Define total supply and demand for product \(k\) as \(S_k=\sum_i s_{ik}\) and \(D_k=\sum_j d_{jk}\). For allowed shipments, the reformulation imposes

\[
x_{ijk}\ge
\max\{0,\ s_{ik}+d_{jk}-D_k,\ s_{ik}+d_{jk}-S_k\}.
\]

The first nonzero candidate follows because origin \(i\) can send at most \(D_k-d_{jk}\) to destinations other than \(j\). Its supply equality therefore requires

\[
x_{ijk}\ge s_{ik}-(D_k-d_{jk}).
\]

Similarly, origins other than \(i\) can provide at most \(S_k-s_{ik}\) to destination \(j\), yielding the second candidate. Both arguments use the original balance equalities and nonnegativity.

For this instance, these bounds expose necessarily positive self-flow at location 61. The activation constraints then force its self-shipment binary to one, consistently with the original model.

## Expected computational effect and preservation

The main expected benefit is a stronger linear programming relaxation, supplemented by fewer explicit bound-like constraints and more opportunities for presolve fixing. Actual runtime improvement depends on the solver and requires benchmarking.

All changes preserve the original integer-feasible solutions and their objective values. In particular, shipment quantities remain continuous, the minimization direction is unchanged, and location 61 retains its special self-shipment allowance. Because no original decision variables were removed or renamed, the solution mapping copies their values unchanged.

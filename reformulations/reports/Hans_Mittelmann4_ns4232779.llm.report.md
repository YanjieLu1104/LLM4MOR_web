# Fixed-Charge Multi-Product Store Redistribution

## Problem background

The model represents a distribution or inventory-redistribution problem involving **76 stores and five products**. The Portuguese parameter names indicate product availability (*Disponibilidade*), demand (*Procura*), shipments (*Envios*), and shipment quantities measured in boxes (*caixas*).

Each store’s available quantity must be shipped, and each store’s demand must be met exactly. Availability and demand are divided by five in the balance equations, suggesting conversion from individual units to five-unit boxes. Despite this interpretation, shipment quantities are **continuous**, so fractional boxes are allowed.

Opening a directed shipping route incurs a fixed cost, independent of its shipment volume. Store 76 has unusually large availability and demand, uniform costs of 50 for routes to and from other stores, and a zero-cost self-route. This suggests a balancing or external supply-and-demand role, although the model does not explicitly identify it as such.

## Original formulation

### Variables and objective

The model contains:

- **28,880 continuous variables** `caixas[i,j,k]`, representing the quantity of product \(k\) shipped from store \(i\) to store \(j\).
- **5,776 binary variables** `Envios[i,j]`, indicating whether the directed route from \(i\) to \(j\) is opened.

The objective minimizes total fixed route-opening cost:

\[
\min \sum_{i=1}^{76}\sum_{j=1}^{76}
\mathrm{custo}_{ij}\,\mathrm{Envios}_{ij}.
\]

There is no active variable transportation cost. Opening a route without shipping on it is permitted.

### Constraints

The original model has **35,791 explicit constraints**:

| Constraint family | Count | Meaning |
|---|---:|---|
| Route activation (`Packing`) | 5,776 | Total shipment on a route cannot exceed \(10^6\) times its opening indicator. |
| Supply balances (`Disponivel`) | 380 | All available quantity of each product at each origin must be shipped. |
| Demand balances (`PROCURA`) | 380 | Each destination’s demand for each product must be met exactly. |
| Prohibited self-shipments (`Diagonal`) | 375 | Product shipments from a store to itself are zero at stores 1–75. |
| Nonnegativity (`naonegatividade`) | 28,880 | All shipment quantities must be nonnegative. |

The diagonal restriction deliberately excludes store 76. Its self-shipment variables therefore remain available.

## Reformulation and justification

The reformulation retains all original decision variables, input data, balance equations, and the minimization objective. It uses **bound propagation, constraint-to-bound conversion, big-M tightening, and disaggregated variable linking**.

### 1. Replace nonnegativity and prohibited-diagonal equations with bounds

Every shipment variable receives a lower bound of zero, replacing its explicit nonnegativity constraint. Shipments on prohibited self-routes receive an upper bound of zero.

These changes are exact: a variable lower bound expresses the same condition as the original nonnegativity inequality, and matching lower and upper bounds of zero express the same condition as the original diagonal equality. The exception for store 76 is preserved.

### 2. Derive product-specific shipment upper bounds

For each permitted origin–destination–product combination, define

\[
U_{ijk}
=
\min\left\{
10^6,\,
\frac{\mathrm{Disponibilidade}_{ik}}{5},\,
\frac{\mathrm{Procura}_{jk}}{5}
\right\}.
\]

For prohibited self-shipments, set \(U_{ijk}=0\). These values are imposed as shipment upper bounds.

Each component follows from the original formulation:

- The supply equation fixes the sum of nonnegative outgoing shipments of product \(k\) at origin \(i\). No individual shipment can exceed that sum.
- The demand equation similarly bounds each incoming shipment by the destination’s demand.
- The original packing inequality, nonnegativity, and `Envios[i,j] ≤ 1` imply that every individual shipment is at most \(10^6\).

Consequently, zero availability or zero demand fixes the corresponding shipment variables to zero without excluding any feasible solution. This makes such fixings explicit for solver presolve.

### 3. Tighten the aggregate route capacity

The original uniform big-M coefficient is replaced by

\[
M_{ij}
=
\min\left\{
10^6,\,
\sum_{k=1}^{5}U_{ijk}
\right\},
\]

giving

\[
\sum_k \mathrm{caixas}_{ijk}
\le M_{ij}\,\mathrm{Envios}_{ij}.
\]

This preserves integer-feasible solutions. If a route is closed, the original packing constraint and nonnegativity already force every shipment on it to zero. If it is open, the original capacity and the derived individual bounds imply the new aggregate capacity.

The smaller coefficients strengthen the linear programming relaxation and reduce the numerical scaling disparity caused by the original million-unit coefficient.

### 4. Add disaggregated linking inequalities

For every combination with \(U_{ijk}>0\), the reformulation adds

\[
\mathrm{caixas}_{ijk}
\le U_{ijk}\,\mathrm{Envios}_{ij}.
\]

These are valid because a closed route carries no flow, while an open route satisfies the derived product-specific upper bound. Zero-bound combinations need no additional linking inequality because their shipment variables are already fixed to zero.

These inequalities strengthen the relaxation beyond aggregate linking: when a route indicator is fractional, each product’s shipment is limited separately rather than only through the total route volume.

## Expected effect and preservation of meaning

The reformulation exposes forced-zero shipments, replaces simple rows with bounds, and strengthens the relationship between shipment quantities and binary route decisions. These changes are intended to improve presolve and branch-and-bound performance; no measured runtime improvement was established in the conversation.

For the supplied instance, the reformulation preserves the original integer-feasible solutions and their objective values. No original variable is eliminated, so solution mapping is the identity.

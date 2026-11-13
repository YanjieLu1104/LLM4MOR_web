# Fixed-Charge Multicommodity Redistribution Model

## Background and interpretation

The model describes redistribution of 10 products among 76 locations, apparently stores: the Portuguese names *Disponibilidade*, *Procura*, *caixas*, and *Envios* indicate availability, demand, boxes, and shipments.

Each location must distribute its entire available quantity of each product and receive exactly its required quantity. Availability and demand are divided by five to obtain the modeled shipment quantities, suggesting a conversion into boxes or another shipping unit. Shipment quantities are nevertheless **continuous**, not integer.

A directed route incurs a fixed cost when activated, independent of the quantity or number of products transported. Location 76 has exceptionally large availability and demand, so it appears to serve as a balancing location or depot; this interpretation is inferred rather than explicitly declared. Unlike the other locations, it may ship to itself.

## Original formulation

### Variables and objective

The model contains:

- **57,760 continuous variables** `caixas[i,j,k]`, representing shipments of product \(k\) from location \(i\) to location \(j\). Explicit constraints enforce nonnegativity.
- **5,776 binary variables** `Envios[i,j]`, indicating whether a directed route is activated.

The objective minimizes total route-opening cost:
\[
\min \sum_{i,j} custo_{ij}\,Envios_{ij}.
\]

Activation permits shipment but does not require a positive shipment.

### Constraints

The original model has **65,806 explicit scalar constraints**:

| Constraint family | Count | Meaning |
|---|---:|---|
| Route activation (`Packing`) | 5,776 | Total shipment on a route is at most \(10^6 Envios_{ij}\). |
| Supply balance (`Disponivel`) | 760 | All available supply of each product must be dispatched. |
| Demand balance (`PROCURA`) | 760 | Each location’s demand for each product must be met exactly. |
| Self-shipment prohibition (`Diagonal`) | 750 | Product shipments from a location to itself are zero at locations 1–75. |
| Nonnegativity (`naonegatividade`) | 57,760 | All shipment quantities are nonnegative. |

This is a **fixed-charge multicommodity transportation MILP**. Products share route-opening decisions but have separate supply and demand balances. The original million-unit activation coefficient is much larger than most feasible shipments, which can produce a weak LP relaxation.

## Reformulation and validity

All original decision variables, instance data, and the minimization objective were retained. The changes use **bound propagation**, **big-M tightening**, and **disaggregated activation inequalities**.

Let
\[
s_{ik}=\frac{Disponibilidade_{ik}}5,\qquad
d_{jk}=\frac{Procura_{jk}}5.
\]

### 1. Replace explicit nonnegativity and diagonal equations with bounds

Nonnegativity is enforced through shipment-variable lower bounds. For \(i=j<76\), the shipment upper bound is zero.

These bounds preserve the original restrictions: a nonnegative variable with upper bound zero must equal zero. The self-route at location 76 remains available, exactly as in the original model.

### 2. Derive product-specific shipment upper bounds

For an allowed route, the reformulation uses
\[
U_{ijk}=\min\{10^6,s_{ik},d_{jk}\}.
\]
For prohibited self-routes, \(U_{ijk}=0\).

Each component follows from an original constraint:

- Nonnegativity and the supply equation imply \(caixas_{ijk}\le s_{ik}\).
- Nonnegativity and the demand equation imply \(caixas_{ijk}\le d_{jk}\).
- The original packing constraint and \(Envios_{ij}\le1\) imply \(caixas_{ijk}\le10^6\).

Consequently, zero supply or zero demand fixes the corresponding shipment variables to zero without changing feasibility. The variables remain declared, allowing standard presolve to remove fixed columns.

### 3. Tighten aggregate route capacities

The original packing coefficient is replaced by
\[
M_{ij}=\min\left\{10^6,\sum_k U_{ijk}\right\},
\]
giving
\[
\sum_k caixas_{ijk}\le M_{ij}Envios_{ij}.
\]

This is valid for both binary activation values. If a route is inactive, the original packing constraint already forces every shipment on it to zero. If it is active, the sum of the valid product upper bounds limits its total shipment, while the original million-unit limit still applies.

### 4. Add disaggregated activation inequalities

For every positive \(U_{ijk}\), the reformulation adds
\[
caixas_{ijk}\le U_{ijk}Envios_{ij}.
\]

An inactive route already has zero shipments, and an active route already satisfies the derived upper bound. Thus these inequalities preserve every original integer-feasible solution.

Their benefit arises in the LP relaxation: fractional route activation must now support each product’s shipment proportionally, rather than relying only on a comparatively loose aggregate capacity.

### 5. Derive unavoidable-shipment lower bounds

The reformulation also imposes
\[
caixas_{ijk}\ge
\max\left\{
0,\;
s_{ik}-\sum_{\ell}d_{\ell k}+d_{jk},\;
d_{jk}-\sum_h s_{hk}+s_{ik}
\right\}.
\]

These bounds follow directly from the transportation balances:

- Origin \(i\) can send at most \(\sum_{\ell\ne j}d_{\ell k}\) units to destinations other than \(j\). Any remaining supply must go to \(j\).
- Destination \(j\) can receive at most \(\sum_{h\ne i}s_{hk}\) units from origins other than \(i\). Any remaining demand must come from \(i\).

The large quantities at location 76 make these bounds particularly useful on its self-route. Positive mandatory flow also forces the corresponding route activation through the packing constraint.

## Expected effect and solution correspondence

The reformulation strengthens the LP relaxation and exposes fixed or mandatory shipments to presolve, with the aim of reducing branch-and-bound effort. Additional product-level inequalities increase the number of linking rows, so actual runtime improvement requires computational evaluation.

No shipment integrality, new routing restrictions, or cost-based variable fixings were introduced. The original integer-feasible solutions and their objective values are preserved. Because the original variable names and index domains remain unchanged, the solution mapping is the identity.

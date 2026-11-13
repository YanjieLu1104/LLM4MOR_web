# Report on the Transportation Model Reformulation

## 1. Problem Background

The model represents a **multi-product redistribution problem among stores or locations**. Each location has a specified supply (`Disponibilidade`) and demand (`Procura`) for each product. Shipments transfer products directly from supplying locations to receiving locations.

The supplied instance contains **101 locations and five products**. Supply and demand are divided by five in the balance equations, suggesting that shipment quantities are measured in five-unit boxes or equivalent bundles. Despite the name `caixas` (“boxes”), these quantities are modeled as continuous and may be fractional.

Opening a directed shipment route incurs a fixed cost, regardless of the quantity or number of products transported on it. Multiple products can therefore share one route-opening cost.

Location 101 has exceptionally large supply and demand, uniform costs of 50 for connections to other locations, and a zero-cost self-route. This suggests an auxiliary balancing location or central depot, although its operational role is not explicitly documented. Unlike locations 1–100, it is allowed to ship to itself.

## 2. Original Mathematical Structure

### Decision variables

- **51,005 continuous variables** `caixas[i,j,k]`, representing the quantity of product \(k\) shipped from location \(i\) to location \(j\). They are declared without bounds but are explicitly constrained to be nonnegative.
- **10,201 binary variables** `Envios[i,j]`, indicating whether a directed shipment route is opened.

### Constraints

The original model contains **62,716 explicit constraints**, before presolve:

| Constraint family | Count | Meaning |
|---|---:|---|
| `Packing` | 10,201 | Total flow on a route cannot exceed \(1{,}000{,}000\) times its opening variable. |
| `Disponivel` | 505 | Every location ships exactly its available quantity of each product, divided by five. |
| `PROCURA` | 505 | Every location receives exactly its required quantity of each product, divided by five. |
| `Diagonal` | 500 | Self-shipments are prohibited at locations 1–100 for every product. |
| `naonegatividade` | 51,005 | All shipment quantities are nonnegative. |

The supply and demand equations are equalities: neither unused supply nor unmet demand is permitted. They describe direct transportation rather than a transshipment network with net-flow conservation.

### Objective

The model minimizes the total fixed route-opening cost:

\[
\min \sum_{i,j} custo_{ij}\,Envios_{ij}.
\]

There is no active quantity-dependent transportation cost. A flow-cost objective appears only as a comment in the source.

## 3. Reformulation and Its Justification

The reformulation retains every original decision variable and index, all supplied instance data, and the original minimization objective. Its main purpose is to strengthen the linear programming relaxation and express simple restrictions as variable bounds.

### 3.1 Nonnegativity and prohibited diagonals expressed as bounds

The explicit nonnegativity constraints were replaced by lower bounds:

\[
caixas_{ijk}\ge 0.
\]

For each prohibited diagonal, an upper bound of zero was also imposed. Together with nonnegativity, this gives

\[
caixas_{iik}=0 \qquad i=1,\ldots,100.
\]

These bounds are exactly equivalent to the original `naonegatividade` and `Diagonal` constraints. Location 101 is excluded from the diagonal restriction, preserving its permitted self-shipment.

This is **constraint-to-bound preprocessing**: it removes the need for separate rows expressing restrictions that a solver can represent directly as variable bounds.

### 3.2 Product-specific flow bounds derived from transportation balances

Define

\[
s_{ik}=\frac{Disponibilidade_{ik}}5,
\qquad
d_{jk}=\frac{Procura_{jk}}5.
\]

The original supply equation and nonnegativity imply

\[
caixas_{ijk}\le \sum_{j'}caixas_{ij'k}=s_{ik}.
\]

Likewise, the demand equation and nonnegativity imply

\[
caixas_{ijk}\le \sum_{i'}caixas_{i'jk}=d_{jk}.
\]

Consequently, the reformulation introduces the valid upper bound

\[
U_{ijk}=
\begin{cases}
0, & i=j,\ i\le100,\\
\min(s_{ik},d_{jk}), & \text{otherwise}.
\end{cases}
\]

Every flow variable receives the bound \(caixas_{ijk}\le U_{ijk}\).

This is **balance-based bound tightening**. In particular, zero supply or zero demand forces the corresponding flow variables to zero because nonnegative quantities summing to zero must individually be zero. No assumption of integer flows is needed.

### 3.3 Disaggregated route-activation inequalities

For every positive product-specific upper bound, the reformulation adds

\[
caixas_{ijk}\le U_{ijk}\,Envios_{ij}.
\]

These inequalities are valid for both possible binary values:

- If \(Envios_{ij}=0\), the original `Packing` constraint forces the sum of nonnegative route flows to zero, so every product flow on that route is zero.
- If \(Envios_{ij}=1\), the inequality reduces to the upper bound established from the supply and demand equations.

This is a **disaggregated variable-upper-bound formulation**, also known as disaggregated on/off linking. It strengthens the relaxation because a fractional opening variable now restricts each product’s flow relative to its actual maximum, rather than only restricting aggregate flow through a very large common coefficient.

### 3.4 Tightened aggregate big-M coefficients

The aggregate `Packing` constraint is retained with the smaller coefficient

\[
M_{ij}=\min\left(1{,}000{,}000,\ \sum_k U_{ijk}\right),
\]

giving

\[
\sum_k caixas_{ijk}\le M_{ij}\,Envios_{ij}.
\]

For an open route, the original packing limit bounds total flow by \(1{,}000{,}000\), while the derived product bounds independently bound it by \(\sum_k U_{ijk}\). Taking the minimum therefore preserves every original feasible open-route flow. For a closed route, both formulations require zero flow.

This is **data-dependent big-M tightening**. Retaining the original million-unit limit inside the minimum ensures that its capacity restriction is not inadvertently discarded.

## 4. Expected Effect and Semantic Preservation

The reformulation replaces an extremely loose activation formulation with bounds and linking inequalities derived from the transportation structure. These changes are intended to improve relaxation bounds, expose forced-zero flows to presolve, and reduce branch-and-bound effort. The additional disaggregated inequalities increase the number of linking rows, so actual runtime improvement remains solver-dependent and has not been measured here.

The reformulated model preserves the **complete integer-feasible set**, not merely one optimal solution. Conversely, its tightened aggregate constraints imply the original packing constraints, and its variable bounds imply the original nonnegativity and diagonal equations. The balance equations and objective are unchanged.

No original variables are eliminated or reindexed. The supplied mapping script therefore transfers their values unchanged.

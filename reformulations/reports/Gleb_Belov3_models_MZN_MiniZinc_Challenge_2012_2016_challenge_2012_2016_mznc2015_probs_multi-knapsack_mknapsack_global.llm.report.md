# Multidimensional Knapsack: Model and Reformulation

## Problem background

The model represents selecting items under several resource limits. An item might correspond to a project, investment, or shipment: selecting item \(j\) earns profit \(c_j\) and consumes \(a_{ij}\) units of resource \(i\). Each resource has capacity \(b_i\). The same item selection must satisfy every resource limit.

Although this resembles standard profit-maximizing multidimensional knapsack, the supplied model also imposes a **prescribed total profit**. The parameter `z` is described in a comment as ignored, but it is passed as the profit argument of every `knapsack` constraint. Consequently, whenever at least one resource constraint exists, a feasible selection must earn exactly `z`.

## Original formulation

Let \(V=\texttt{VRange}=1..N\) and \(C=\texttt{CRange}=1..M\).

### Variables

- **Item selections:** \(|V|\) binary variables \(x_j\).
- **Resource loads:** \(|C|\) integer variables `bVar[i]`, each initially bounded between zero and `ub_array(b)`.
- **Profit:** one defined integer variable,
  \[
  \texttt{objective}=\sum_{j\in V}c_jx_j,
  \]
  with domain \(0..\sum_j c_j\).

### Constraints and objective

For each resource \(i\), the model bounds its load by its capacity and invokes a global `knapsack` constraint. Together these enforce
\[
\texttt{bVar}_i=\sum_{j\in V}a_{ij}x_j,
\qquad
0\leq\texttt{bVar}_i\leq b_i,
\qquad
\sum_{j\in V}c_jx_j=z.
\]

The profit equality is repeated once per resource. If \(C\) is empty, none of these global constraints exists, so no equality to `z` is imposed.

Assertions require all weights, capacities, profits, and `z` to be nonnegative. The solve item maximizes `objective` and supplies an input-order, maximum-value-first search annotation. When \(C\neq\varnothing\), all feasible solutions already have objective value `z`; the optimization is therefore effectively a feasibility search at that target profit.

## Reformulation and justification

### 1. Explicit linear formulation

The global constraints were replaced with resource-load equations and capacity bounds. Their repeated profit equalities were consolidated into
\[
\texttt{objective}=z
\]
**only when \(C\neq\varnothing\)**.

This is an exact decomposition of the global constraints’ weight and profit equations. It exposes a direct binary linear formulation for HiGHS while preserving the empty-resource case. All original variables, external parameter declarations, and nonnegativity assertions remain.

### 2. Elimination of individually infeasible items

An eligible-item set \(E\) is computed from the data. An item is excluded if:

- \(a_{ij}>b_i\) for any resource \(i\); or
- resource constraints exist and \(c_j>z\).

Excluded items are fixed to zero.

These fixings follow from the original constraints. Nonnegative weights mean that selecting an item exceeding a capacity cannot be compensated for by other items. Similarly, nonnegative profits mean that an item with profit greater than `z` cannot belong to a selection whose total profit must equal `z`. The profit test is deliberately disabled when there are no resource constraints.

### 3. Profit-availability test and mandatory-item fixing

Define the total eligible profit as
\[
P_E=\sum_{j\in E}c_j.
\]

When the target-profit equality applies, the reformulation adds \(z\leq P_E\). This is necessary because excluded items cannot be selected and each eligible binary variable is at most one.

It also fixes an eligible item \(j\) to one whenever
\[
P_E-c_j<z.
\]
If that item were omitted, even selecting every other eligible item would fall short of the required profit. Resource limits can only reduce achievable profit further, so they do not invalidate this deduction.

### 4. Capacity-based clique cuts

For each resource \(i\), the reformulation adds
\[
\sum_{\substack{j\in E\\a_{ij}>\lfloor b_i/2\rfloor}}x_j\leq 1.
\]

Any two items in this set jointly exceed capacity \(b_i\). Because all other resource consumptions are nonnegative, no feasible selection can contain two of them. These are valid clique inequalities derived from pairwise incompatibility under a knapsack capacity; they can strengthen the linear relaxation without removing feasible integer solutions.

### 5. Search and solution mapping

The CP-style search annotation was removed, leaving search decisions to HiGHS. This does not change the feasible set or maximization direction.

The mapping script returns the original independent variables `x` and `bVar`. If `bVar` is not exported, it reconstructs each load as \(\sum_j a_{ij}x_j\), using the original weight data and checking index compatibility. The defined `objective` variable requires no reconstruction.

Overall, the changes preserve the original feasible selections and objective values while exposing linear structure, applying safe variable fixings, and adding valid inequalities. No instance data or timing results were supplied, so a runtime improvement is intended rather than experimentally established.

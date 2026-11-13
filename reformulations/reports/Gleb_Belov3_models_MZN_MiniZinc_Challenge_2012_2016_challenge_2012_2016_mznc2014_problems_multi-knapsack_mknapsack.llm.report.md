# Multidimensional Knapsack Feasibility Model

## Background and interpretation

The model represents the selection of items or projects under several resource limits. Each item has a nonnegative profit and consumes a nonnegative amount of each resource. Applications could include investment selection, cargo loading, or production planning, although no particular application is specified in the source.

Unlike a conventional knapsack optimization model, this model asks whether a selection can achieve **exactly a supplied profit target `z`** while respecting all resource capacities. The source describes `z` as an optimal value, but the model itself only checks feasibility at that value; it does not establish that larger profits are impossible.

## Original formulation

The external data specify:
- `N` items and `M` resource constraints.
- Resource consumption coefficients `a[i,j]`.
- Resource capacities `b[i]`.
- Item profits `c[j]`.
- Target profit `z`.

The decision array contains one binary integer variable `x[j]` per item, indicating whether that item is selected.

The principal constraints are:

\[
\sum_j a_{ij}x_j \le b_i
\qquad\text{for every resource }i,
\]

and

\[
\sum_j c_jx_j=z.
\]

The model also asserts that all resource coefficients, capacities, profits, and the target are nonnegative. It uses `solve satisfy`, with a search annotation that considers variables in input order and tries selection before exclusion.

## Reformulation and its justification

The reformulation preserves the external data interface and the original decision array `x`. It introduces no additional decision variables. Its reductions and cuts follow directly from binary decisions and the asserted nonnegativity.

### 1. Exclude individually infeasible items

An item is excluded if it consumes more than any resource capacity or has profit greater than `z`.

This is valid because selecting it would already violate a capacity inequality or the exact-profit equality. Other selected items cannot compensate: their resource consumption and profits are nonnegative.

### 2. Identify mandatory items using a profit bound

Let \(C\) be the items surviving the first exclusion step, and let

\[
P=\sum_{j\in C}c_j.
\]

If \(P<z\), the model is infeasible: even selecting every surviving item cannot reach the target.

For any surviving item \(j\), if \(P-c_j<z\), that item is mandatory. Without it, the total profit of all remaining available items is insufficient. Resource restrictions can only reduce attainable profit, so this argument remains valid even though \(P\) ignores capacities.

### 3. Subtract mandatory contributions and repeat exclusions

Mandatory items are fixed to one. Their resource consumption and profits are subtracted from the capacities and target, respectively.

The resulting residual constraints are algebraically equivalent to the original constraints after those valid fixings. A negative residual capacity or target establishes infeasibility.

An undecided item is then excluded if it individually exceeds a residual resource capacity or the residual profit target. The same nonnegativity argument used in the initial exclusion applies.

### 4. Remove automatically satisfied capacity rows

A residual resource inequality is omitted when the sum of that resource’s coefficients over all remaining items does not exceed the residual capacity.

This sum is an upper bound on resource use because every remaining decision is binary and all coefficients are nonnegative. Consequently, every assignment to the remaining variables already satisfies that row.

The residual exact-profit equality is retained.

### 5. Add heavy-item clique cuts

For a resource with residual capacity \(B\), consider all remaining items whose resource consumption exceeds \(B/2\). Selecting any two would consume more than \(B\), violating the residual capacity constraint. Therefore, the reformulation adds:

\[
\sum_{j:\,a_{ij}>B/2}x_j\le 1
\]

when this group contains at least two items.

An analogous cut is added for items whose profits exceed half the residual target. Selecting two would exceed that target, and nonnegative profits cannot offset the excess.

These are **pairwise-incompatibility clique cuts**: each group consists of mutually incompatible items. The inequalities preserve every feasible binary assignment and can strengthen the linear relaxation used by HiGHS.

## Solver interface and expected effect

The reformulation removes the original explicit search annotation and leaves search to the backend. This changes search guidance, not feasibility semantics.

The accompanying mapping script copies the unchanged `x` array, including its index encoding, back to the original solution interface. No reconstruction from auxiliary data is required.

The intended benefits are fewer unfixed variables, fewer resource rows, and a stronger relaxation from the clique cuts. Their actual effect on runtime depends on the instance; no performance improvement is established without benchmarking.

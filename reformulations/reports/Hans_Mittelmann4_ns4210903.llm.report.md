# Spine Network Design: Model and Reformulation Report

## 1. Background and interpretation

The model describes the design of a reliable communication-network **spine**: a connected backbone supporting traffic between every pair of network nodes. The supplied instance, labeled as a Polish network, contains **12 nodes and 18 undirected links**, represented by 36 directed arcs.

Each link must receive one of three availability levels, with an associated cost. Negative costs represent a less reliable, cost-saving choice. The objective is to minimize the largest working-path unavailability across all source–destination pairs, subject to an improvement budget.

The path measure is the **sum of link unavailabilities**, not an exact end-to-end failure probability. It is best interpreted as an additive reliability metric.

Although the model contains working-path and backup-path variables, its implemented constraints do not enforce a backup route: `BProuting` repeats the working-path equations using `x`, and the `Incy` product constraints also use `x`, rather than `y`. The reformulation preserves this implemented meaning rather than correcting the apparent modeling errors.

## 2. Original formulation

### Variables

The original instance declares **41,616 binary variables and one nonnegative continuous variable**:

| Variable | Meaning | Count |
|---|---|---:|
| `x[i,j,s,t]` | Working-route arc selection | 5,184 |
| `y[i,j,s,t]` | Nominal backup-route arc selection | 5,184 |
| `xs[i,j]` | Spine arc selection | 36 |
| `Inc[i,j,k]` | Link improvement method selection | 108 |
| `Incx[i,j,s,t,k]` | Product of `x` and `Inc` | 15,552 |
| `Incy[i,j,s,t,k]` | Another product of `x` and `Inc`, as implemented | 15,552 |
| `Mwp` | Upper bound on every working-route unavailability | 1 |

Routing and product variables include diagonal commodities with identical source and destination, although the original constraints exclude those commodities.

### Constraints and objective

The principal constraints impose:

- Unit-flow conservation for every distinct source–destination pair, duplicated under the working- and backup-routing names.
- Inclusion of every working-route arc in the spine.
- Reverse-commodity symmetry for `x` and `y`.
- Arcwise disjointness between `x` and `y`.
- A spine cardinality of \(2(12-1)=22\) directed arcs.
- Exactly one improvement method per arc, with matching methods in opposite directions.
- A directed improvement-cost budget of \(2C=600\).
- Binary-product linearizations for `Incx` and `Incy`.
- An upper bound `Mwp` on each working-route unavailability.

The objective minimizes `alphaWP * Mwp`; here, `alphaWP = 1`. No backup-path reliability term is active.

## 3. Reformulation and justification

### Availability dominance with a nonbinding budget

Method 3 has the greatest availability on every arc. Choosing it on all links costs **158 in the directed representation**, below the budget of 600.

For any original feasible solution, replacing every method choice by method 3 preserves the one-method and reverse-direction constraints and satisfies the budget. Updating the product variables cannot increase any route’s unavailability, because each coefficient \(1-da[i,j,3]\) is no greater than its counterpart under another method.

Thus, **an optimum exists with method 3 selected everywhere**. Fixing `Inc` accordingly is an instance-specific dominance reduction, justified by both coefficient comparisons and simultaneous affordability. The reformulated model includes checks for these conditions.

### Spanning-tree structure

Let the working-route support contain every undirected edge used by any distinct-node commodity. Flow conservation makes this support connected.

If an arc is used, reverse-commodity symmetry forces its reverse arc to be used by the reverse commodity. The spine-inclusion constraints therefore select both directions of every support edge. A connected support on 12 nodes needs at least 11 edges, consuming at least 22 spine arcs.

Since the original cardinality constraint permits exactly 22 arcs, the support must contain exactly 11 edges and the spine cannot contain anything else. Consequently, **the spine is an undirected spanning tree**. Explicit spine symmetry is therefore valid, not an additional network assumption.

### Removal of redundant variables and equations

- **Backup variables:** Setting `y = 0` satisfies its symmetry, disjointness, and wrapping constraints. No implemented flow equation or objective requires nonzero `y`.
- **Diagonal commodities:** Their variables occur in no original constraints or objective, so choosing zero preserves an optimum.
- **Duplicate routing:** The second routing family is identical to the first and can be removed.
- **Reverse commodities:** Routing equations are retained only for \(s<t\); reverse-commodity identities imply the equations for \(s>t\).
- **Products:** With method choices fixed, both product families reduce to copies of `x` for method 3 and zero for the other methods. Their binary declarations and three-inequality linearizations are unnecessary.

### Tree-flow reformulation and circulation removal

The reformulation adds
\[
x_{ij}^{st}+x_{ji}^{st}\le xs_{ij}
\]
and makes routing variables continuous.

A tree has a unique simple path between any two nodes. Original binary flows may additionally contain opposing-arc circulations. Removing these circulations preserves flow conservation and cannot increase route unavailability, since the supplied unavailability coefficients are nonnegative. Therefore, restricting attention to simple tree paths preserves an optimum.

Only the **36 spine variables** remain declared binary, with symmetry leaving 18 independent edge choices.

## 4. Important qualification concerning solution recovery

The earlier explanation overstated the integrality of the continuous routing formulation. On an edge outside a commodity’s unique path, the constraints can permit
\[
x_{ij}^{st}=x_{ji}^{st}=\theta,\qquad 0<\theta\le \tfrac12.
\]
These are fractional opposing-arc circulations. The capacity inequality does **not** eliminate them.

The reformulation still preserves the optimal objective: every such circulation can be removed without increasing unavailability. However, the supplied **identity mapping is not guaranteed to return an original-feasible binary solution**.

A fully reliable recovery procedure must replace each commodity flow by its unique directed path in the selected tree, then reconstruct `Incx` and `Incy` from that path and the fixed method choices. Keeping `Mwp` unchanged preserves the reported objective and satisfies the original unavailability inequalities. This recovery step is necessary to complete the equivalence claim for arbitrary solver-returned solutions.

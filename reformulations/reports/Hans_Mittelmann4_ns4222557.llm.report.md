# Network Spine Design: Model and Reformulation Report

## Problem background

The model represents a telecommunications network in which a connected **spine**, or backbone, must support working routes between every pair of nodes. Each demand also receives a backup route. Working routes must use spine links, while backup routes may use the wider network.

Each physical link has a choice of three intervention methods, with different availability values and costs. These represent reliability improvements or trade-offs: the supplied data include a lower-availability method with negative cost. A shared budget limits the total intervention cost.

The instance is labelled as the **Polska network** and contains 12 nodes and 18 undirected links, represented by 36 directed arcs. There are 132 ordered demands between distinct nodes.

The objective is a worst-case reliability surrogate: minimize the largest sum of link unavailabilities along any working route. This additive measure is not an exact end-to-end failure probability. Although backup routing is mandatory, backup-path unavailability does not appear in the active objective or constraints.

## Original formulation

### Variables

The original model declares **41,616 binary variables** and one nonnegative continuous variable:

| Variable | Meaning | Count |
|---|---|---:|
| `x` | Working-route arc selection for each ordered node pair | 5,184 |
| `y` | Backup-route arc selection for each ordered node pair | 5,184 |
| `xs` | Directed arc included in the spine | 36 |
| `Inc` | Intervention method selected for each arc | 108 |
| `Incx` | Product of working-route selection and intervention selection | 15,552 |
| `Incy` | Product of backup-route selection and intervention selection | 15,552 |
| `Mwp` | Upper bound on all working-route unavailability sums | 1 |

The routing and product variables are declared for all node pairs, including equal endpoints. Their equal-endpoint entries are unused by the active constraints and objective.

### Constraints and objective

The formulation includes:

- **Flow conservation** for working and backup routes between every pair of distinct nodes.
- **Spine membership:** every selected working-route arc must belong to the spine.
- **Reverse-demand symmetry:** routing from \(t\) to \(s\) reverses the routing from \(s\) to \(t\).
- **Working/backup separation:** the two routes cannot select the same directed arc for a demand. This is directed-arc disjointness, not an explicit prohibition on using opposite directions of one physical link.
- **Spine cardinality:** exactly \(2(12-1)=22\) directed spine arcs.
- **Intervention selection:** exactly one method per arc, with matching choices in opposite directions.
- **Budget:** directed intervention costs sum to at most \(2C=600\).
- **Product linearizations:** three inequalities enforce each route–intervention product.
- **Worst-case bounds:** `Mwp` bounds every distinct-node working-route unavailability sum.

The minimization objective is `alphaWP * Mwp`, with `alphaWP = 1` in this instance.

## Reformulation and justification

### 1. Fix all interventions using dominance and budget preprocessing

Method 3 has the highest availability on every supplied arc. Selecting it on every physical link costs **79**, or **158** in the original directed-arc accounting, comfortably below the budget bound of 600.

This makes a global dominance reduction possible:

1. Intervention choices do not affect routing feasibility or spine membership.
2. Replacing every selected method with method 3 satisfies the one-method and opposite-direction consistency constraints.
3. The resulting assignment satisfies the budget.
4. Because route selections are nonnegative, replacing each coefficient \(1-da\) by a smaller or equal coefficient cannot increase any working-route unavailability sum.

Thus any original feasible solution can adopt method 3 while retaining its routes and `Mwp`, preserving feasibility and its objective value. Conversely, fixed-method solutions remain valid original solutions. At least one optimum is therefore preserved.

The reformulation fixes `Inc` accordingly and includes checks for the availability dominance and budget conditions.

### 2. Eliminate route–intervention product variables

With interventions fixed, each product is either the corresponding route variable or zero. The reformulation substitutes these expressions directly into the working-route bounds.

The original product inequalities force exactly these values for distinct-node demands, so eliminating `Incx` and `Incy` is exact under the fixed intervention assignment. Moreover, `Incy` has no other active use because the backup-unavailability constraints are commented out.

### 3. Retain only one orientation of each demand

The original equalities explicitly require
\[
x_{ij,st}=x_{ji,ts},
\qquad
y_{ij,st}=y_{ji,ts}.
\]

Consequently, only the 66 demands with \(s<t\) need independent routing variables. Reverse-demand flow balance, spine membership, and arc-disjointness follow from the retained constraints and the reconstruction rule.

Both directional unavailability bounds are retained, so this reduction does not rely on assuming equal availability coefficients in opposite directions.

### 4. Use one spine variable per physical link

The undirected union of working-route links must connect all nodes: flow conservation supplies a working connection for every distinct-node demand. Any connected graph on 12 nodes uses at least 11 physical links.

Reverse-demand symmetry means that every used physical link is selected in both directions across the working demands. The spine-membership inequalities therefore require at least 22 directed spine arcs. Since the original cardinality constraint permits exactly 22, the spine consists of exactly 11 physical links, with both directions selected and no extra arcs. It is therefore a spanning tree.

This implication justifies replacing the 36 directed spine variables by 18 undirected variables and imposing a cardinality of 11. No additional assumption about simple routing paths is introduced.

### 5. Reconstruct unused and eliminated variables

The mapping script restores reverse demands, both directed copies of each spine variable, and the product variables. Equal-endpoint routing and product entries are assigned zero because they are unconstrained and absent from the objective.

## Resulting formulation

The reformulation has **4,770 unfixed binary variables**, **108 fixed intervention variables**, and one nonnegative continuous variable. Its principal techniques are instance-specific dominance preprocessing, fixed-variable substitution, symmetry-based variable elimination, and a spanning-tree implication derived from connectivity and cardinality.

These changes reduce integer decisions and remove the large product-linearization system while preserving the original optimal objective and enabling reconstruction of an original-model solution. No measured solve-time improvement is claimed without computational testing.

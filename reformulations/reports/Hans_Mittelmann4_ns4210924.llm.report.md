# Reformulation Report: Spine Design for a Communication Network

## 1. Application and instance background

The model describes the design of a reliable communication-network **spine**: a connected backbone used to route traffic between every pair of network nodes. Each physical link can receive one of several availability-improvement methods, subject to a total expenditure limit. The design seeks to minimize the largest accumulated link-unavailability measure over all terminal-to-terminal routes.

The supplied instance, identified in the source as the **Polska network**, contains:

- **12 nodes and 18 undirected physical links**, represented by 36 directed arcs;
- **Three methods per link**, each with a specified cost and availability;
- A budget parameter of **300**.

Because both directions of each physical link are represented, the original budget constraint sums directed-arc costs and uses the limit `2*C = 600`.

The route metric is the sum of `1 - da` over its links. It is therefore an **additive unavailability measure**, not an explicitly modeled end-to-end failure probability.

## 2. Original mathematical formulation

### Variables

The original model declares **41,616 binary variables and one nonnegative continuous variable**:

| Variable | Meaning in the implemented formulation |
|---|---|
| `x[i,j,s,t]` | Whether the working route from `s` to `t` uses arc `(i,j)` |
| `y[i,j,s,t]` | Backup-route indicator, although no effective backup flow-conservation equations are imposed |
| `xs[i,j]` | Whether an arc belongs to the spine |
| `Inc[i,j,kk]` | Whether method `kk` is selected for an arc |
| `Incx[i,j,s,t,kk]` | Product of `x[i,j,s,t]` and `Inc[i,j,kk]` for distinct terminals |
| `Incy[i,j,s,t,kk]` | Also the product of `x` and `Inc`, as actually written |
| `Mwp` | Upper bound on every working route’s additive unavailability |

Routing and product variables are declared even for `s = t`, but those entries are unconstrained and do not affect the objective.

### Constraints and objective

The main constraints enforce:

- Unit working-flow conservation for every ordered pair of distinct nodes;
- Inclusion of every used working arc in the spine;
- Reversal symmetry between opposite terminal-pair routes;
- Arcwise disjointness between `x` and `y`;
- Exactly `2*(nodes-1)` selected spine arcs;
- One method per arc, with the same method in both directions;
- A total method-cost budget;
- Binary-product linearizations;
- An upper bound `Mwp` on every working route’s unavailability.

The objective is to minimize `alphaWP * Mwp`, with `alphaWP = 1` in this instance.

Two implementation details are essential to interpreting the model faithfully:

1. `BProuting` repeats the equations for **`x`**, rather than imposing conservation on `y`.
2. The `Incy` linearization uses **`x`**, not `y`.

Thus, despite the backup-path terminology, the implemented model does **not** require a second connected route. The reformulation preserves the implemented problem rather than correcting these apparent modeling errors.

## 3. Reformulation and justification

### Availability dominance and budget preprocessing

Method 3 has the highest availability on every supplied arc. Selecting it on all links costs **158 in the original directed-arc accounting**, below the limit of 600.

Consequently, any feasible original solution can have all its method selections replaced by method 3 without violating the budget. This replacement cannot increase any route’s unavailability because every coefficient `1 - da` weakly decreases. The corresponding product variables can then be updated accordingly.

Therefore, **an optimal solution exists with method 3 selected everywhere**. The reformulation derives the common dominating method, checks its budget feasibility, and removes method-selection decisions and product linearizations. This reduction relies on the supplied availability and cost data; it is not a general property of budgeted network design.

### Deriving the spanning-tree structure

The original constraints already force the working network to be a tree:

1. All-pairs flow conservation makes the union of working-route links connected.
2. The equality `x[i,j,s,t] = x[j,i,t,s]` ensures that every used physical link appears in both arc directions across the collection of routes.
3. `xs >= x` therefore requires at least two selected spine arcs per used physical link.
4. A connected network on 12 nodes needs at least 11 physical links, while the spine-cardinality equation permits exactly 22 selected arcs.

These bounds coincide. Hence the working network contains exactly 11 physical links, is a spanning tree, and leaves no selected spine arcs outside that tree.

The reformulation represents each physical link with one binary variable, reducing the spine decisions to **18 binaries**.

### Continuous routing for unordered terminal pairs

For an integral selected tree, there is exactly one simple path between any two terminals. Original binary flows may additionally contain back-and-forth circulations, but removing these preserves flow conservation and cannot increase unavailability because all supplied coefficients are nonnegative.

The reformulation therefore uses continuous nonnegative flows with a shared capacity bound on the two directions of each selected edge. On a tree, conservation and this bound force the unique path flow.

Only **66 unordered terminal pairs** are retained. Reverse routes are reconstructed by reversing their paths. This also preserves the objective constraints because the supplied availabilities are symmetric between arc directions.

### Eliminating unused backup decisions

Setting every `y` entry to zero satisfies its reversal-symmetry and disjointness constraints. There is no effective backup-flow requirement or backup objective.

The mapping reconstructs `Incy` as the product of `x` and the selected method, exactly as required by the original equations. Unconstrained diagonal entries are assigned zero.

### Forest inequalities

The reformulation adds induced-subgraph forest inequalities:

\[
\sum_{\{i,j\}\subseteq S} z_{ij}\le |S|-1.
\]

Every subgraph of a tree is acyclic, so these inequalities are valid for the tree structure established above. They strengthen the linear relaxation by excluding fractional edge selections that place excessive weight inside a node subset. Only subsets for which the inequality is nontrivial are included.

## 4. Resulting model

The reformulated model has **18 binary variables and 2,377 continuous variables**, compared with the original 41,616 binaries and one continuous variable.

The principal techniques are **data-dependent dominance preprocessing, implicit-structure extraction, elimination of redundant variables and equations, symmetry reduction, continuous tree-flow reformulation, and forest cutting planes**. Together, they substantially reduce the discrete search space and strengthen its relaxation. Actual runtime improvement remains solver-dependent; no computational speedup was measured here.

The supplied mapping reconstructs all original independent variables and retains `Mwp`, preserving the objective value of the mapped solution.

# Hierarchical Modularity Optimization: Model and Reformulation

## Problem background

The instance appears to represent **hierarchical decomposition of a system into modules**, such as grouping interacting engineering components into subsystems. This interpretation is inferred from the model; the source does not identify a particular application.

The input contains 38 components and a binary dependency structure matrix, `DSM`. Its entries indicate relationships between components. The model constructs a hierarchy with 37 internal nodes and 38 component leaves:

- Every internal node has exactly two children, each either another internal node or a component.
- Every component appears as a leaf exactly once.
- Internal node 1 is the root.
- An internal-node arc from `u` to `v` is allowed only when `0 < v-u <= 19`.

The objective penalizes undesirable component groupings throughout the hierarchy. The restriction on node-index differences is part of the supplied instance and is preserved; it is not an added modeling assumption.

## Original formulation

### Decision variables

All original variables are binary.

| Variable | Meaning for entries used by the model | Declared count |
|---|---|---:|
| `c[u,i]` | Component `i` belongs to the subtree rooted at internal node `u` | 1,406 |
| `x[u,v]` | Internal node `v` is a direct child of internal node `u` | 1,369 |
| `y[u,i]` | Component `i` is a direct leaf child of node `u` | 1,406 |
| `cc[u,i,j]` | Product `c[u,i]c[u,j]`, for `i < j` | 53,428 |
| `cx[u,i,v]` | Product `x[u,v]c[v,i]`, for allowed arcs | 52,022 |

The model therefore declares **109,631 binary variables**, including entries that never appear in its objective or constraints.

### Constraints

The formulation combines product linearizations with tree and membership constraints:

- **Pair membership:** `c_0_1`–`c_0_3` impose `cc[u,i,j] = c[u,i]c[u,j]` for `i < j`.
- **Membership propagation:** `c_1` states that a component belongs to a node’s subtree through either a selected internal child or a direct leaf attachment.
- **Arc–membership products:** `c_1_1`–`c_1_3` impose `cx[u,i,v] = x[u,v]c[v,i]` on allowed arcs.
- **Two children per internal node:** `c_2` counts selected internal children and directly attached components.
- **Unique component attachment:** `c_3` attaches each component exactly once.
- **Unique internal parent:** `c_4` gives every internal node except node 1 exactly one parent.
- **Root membership:** `c_5` requires all components to belong to node 1.

Because every selected arc leads to a strictly larger index, internal-node cycles are impossible. Following parents backward from any nonroot node must therefore reach node 1. Together, these constraints describe a rooted binary tree.

### Objective

The model **minimizes** a linear modularity penalty summed over internal nodes and component pairs `i < j`.

- If `DSM[i,j] = 0`, it charges 2 when both components belong to the node’s subtree.
- If `DSM[i,j] = 1`, it charges 2 when component `i` belongs to that subtree but component `j` does not.

The second term is specifically `2(c[u,i] - cc[u,i,j])`. Thus, the supplied objective uses the ordered pair convention `i < j`; it is not replaced by a symmetric separation penalty.

## Reformulation and justification

### 1. Sparse indexing and removal of unused variables

The reformulation retains:

- `x[u,v]` only on allowed arcs;
- `cx` only on allowed arcs and component indices;
- `cc[u,i,j]` only where `i < j`.

This is **structural preprocessing**. Inspection of the original expressions shows that every removed entry is absent from all constraints and the objective. Such entries can take either binary value independently of the meaningful decisions. Reconstructing them as zero therefore preserves feasibility and objective value.

There are 513 allowed internal-node arcs and 703 relevant component pairs. Removing unused entries eliminates **60,801 declared variables**.

The internal index order of `cx` also changes from `(u,i,v)` to `(u,v,i)` to match the arc representation. The mapping script reverses this change.

### 2. Relaxation of implied-integral variables

Only `x` and `y` remain binary. Variables `c`, `cc`, and `cx` become continuous with bounds `[0,1]`.

This is an **implied-integrality reformulation**, justified by the original constraints:

1. With binary `x[u,v]`, constraints `c_1_1`–`c_1_3` force `cx[u,v,i]` to be zero when the arc is unselected and equal to `c[v,i]` when it is selected.
2. The last internal node has no possible internal children. Its membership equation therefore gives `c[num_node,i] = y[num_node,i]`, which is integral.
3. Proceeding backward through node indices, each membership equation expresses `c[u,i]` as a sum of integral child contributions and binary `y[u,i]`. Its `[0,1]` bounds force it to be binary.
4. Consequently, every retained `cx` is integral. With binary-valued `c`, the three pair-product inequalities likewise force every retained `cc` to its binary product value.

Thus, the relaxation introduces no additional feasible solutions with fractional membership or product variables when `x` and `y` are integral.

The resulting formulation contains **1,919 binary variables and 46,911 continuous variables**.

### 3. Incoming component-flow equalities

For every nonroot node `v` and component `i`, the reformulation adds

\[
\sum_{u:(u,v)\text{ allowed}} cx[u,v,i]=c[v,i].
\]

These are **valid linking equalities**. Constraint `c_4` selects exactly one incoming arc to `v`. The product constraints make the contribution on that arc equal to `c[v,i]`, while all other incoming contributions are zero.

Although redundant for integer-feasible solutions, these equalities can strengthen the linear programming relaxation by linking membership to incoming parent selection.

### 4. Subtree-size inequalities

The reformulation adds

\[
2\leq \sum_i c[u,i]\leq \texttt{num\_node}-u+2.
\]

These are **problem-specific cardinality cuts**:

- By `c_2`, every internal node has two children.
- Acyclicity ensures that descending through internal children eventually reaches component leaves.
- Constraints `c_3` and `c_4` prevent repeated component attachment and shared internal children.
- The membership equations make `c[u,i]` indicate precisely those component leaves in the subtree.

A finite full binary tree with \(k\) internal nodes has \(k+1\) leaves. A subtree contains at least one internal node, giving at least two component leaves. Since descendants of `u` have larger indices, the subtree contains at most `num_node-u+1` internal nodes, giving the stated upper bound.

For each allowed arc, the reformulation also adds

\[
2x[u,v]\leq \sum_i cx[u,v,i]
\leq (\texttt{num\_node}-v+2)x[u,v].
\]

When the arc is selected, its product variables reproduce the membership of subtree `v`, so the same bounds apply. When it is unselected, all those product variables are zero.

## Preservation and expected benefit

The reformulation preserves the supplied parameters, dependency matrix, objective expression, minimization direction, and allowable tree arcs. Every original feasible solution projects to a reformulated feasible solution with the same objective, and the mapping script reconstructs an original feasible solution from every reformulated integer-feasible solution.

The intended computational benefits are fewer declared variables, substantially fewer explicitly binary variables, and stronger relaxation constraints. These are structural improvements; no solver timing results were supplied, so an actual speedup has not been established.

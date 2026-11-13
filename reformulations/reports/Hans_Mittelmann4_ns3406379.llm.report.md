# Hierarchical Modularity Optimization: Model and Reformulation

## 1. Inferred application and problem meaning

The model appears to construct a **hierarchical decomposition of a system into modules**, using a binary design structure matrix (`DSM`) to describe relationships between components. Such models can support product architecture or organizational design, where related components should remain together and unrelated components should be separated. This application interpretation is inferred from the formulation; the source does not specify a particular industry.

The supplied instance contains **20 components and 19 internal hierarchy nodes**. Each internal node has exactly two children, which may be other internal nodes or individual components. Each component appears exactly once as a leaf.

Internal nodes are numbered in parent-before-child order. An internal-node edge from \(u\) to \(v\) is permitted only when
\[
0<v-u\leq 8.
\]
This restriction is part of the original feasible set, not a symmetry-breaking assumption introduced by the reformulation.

The resulting hierarchy is a rooted full binary tree:

- `c_4` gives every internal node except node 1 exactly one parent.
- Permitted edges always increase the node index, preventing cycles. Following parents therefore leads to node 1.
- `c_2` gives each internal node exactly two children, counting both internal-node edges and directly attached components.
- `c_3` assigns each component to exactly one node.

## 2. Original mathematical formulation

### Variables

The original model declares **15,941 binary variables**.

| Variable | Interpretation for entries used by the model | Declared count |
|---|---|---:|
| `c[u,i]` | Component \(i\) belongs to the subtree rooted at \(u\) | 380 |
| `x[u,v]` | Node \(u\) is the parent of internal node \(v\) | 361 |
| `y[u,i]` | Component \(i\) is attached directly to node \(u\) | 380 |
| `cc[u,i,j]` | Product \(c[u,i]c[u,j]\), for \(i<j\) | 7,600 |
| `cx[u,i,v]` | Product \(x[u,v]c[v,i]\), for permitted edges | 7,220 |

The rectangular declarations include entries of `x`, `cc`, and `cx` that never appear in the objective or constraints.

### Constraints

There are **18,247 explicitly indexed constraints**, excluding variable bounds and integrality declarations.

- `c_0_1`–`c_0_3` use three standard binary-product inequalities to enforce  
  \(cc[u,i,j]=c[u,i]c[u,j]\) for \(i<j\).
- `c_1_1`–`c_1_3` similarly enforce  
  \(cx[u,i,v]=x[u,v]c[v,i]\) on permitted edges.
- `c_1` propagates component membership upward: a component belongs to a node’s subtree if it is attached directly there or belongs to a selected child’s subtree.
- `c_2`–`c_4` impose the binary-tree structure described above.
- `c_5` requires every component to belong to the root subtree.

### Objective

The model **minimizes `Modularity_Index`**, summed over internal nodes and component pairs \(i<j\).

- When `DSM[i,j] = 0`, it charges 2 if both components belong to the subtree.
- When `DSM[i,j] = 1`, it charges 2 if component \(i\) belongs to the subtree but component \(j\) does not.

Thus, the objective discourages grouping unrelated components and penalizes certain separations of related components across the hierarchy. Importantly, the supplied matrix is not symmetric, and the objective uses **only its upper-triangular entries**. The reformulation preserves that convention exactly.

## 3. Reformulation techniques and their validity

### Sparse indexing and removal of unused variables

The reformulation retains only:

- the **116 permitted internal-node edges** for `x`;
- pairs \(i<j\) for `cc`;
- permitted edges for each component in `cx`.

This removes **9,135 unused variable entries**, leaving **6,806 variables**.

The deletion is valid because every removed entry was absent from all original constraints and the objective. These entries were independent binary variables with no effect on feasibility or cost. The mapping script restores them to zero, a valid original assignment.

### Incoming-flow conservation instead of local product constraints

For each nonroot node \(v\) and component \(i\), the reformulation imposes
\[
\sum_{u:\,(u,v)\text{ permitted}}cx[u,i,v]=c[v,i],
\qquad
0\leq cx[u,i,v]\leq x[u,v].
\]

This exploits `c_4`: exactly one incoming edge is selected at an integer solution. Every unselected incoming edge carries zero flow, while the selected edge must carry exactly \(c[v,i]\). Consequently, the original product relation holds.

The formulation also strengthens the LP relaxation. Nonnegativity and incoming-flow conservation imply \(cx[u,i,v]\leq c[v,i]\). Moreover,
\[
c[v,i]-cx[u,i,v]
\leq \sum_{w\ne u}x[w,v]
=1-x[u,v],
\]
which recovers the original product lower bound. Thus, the new constraints imply all three original product inequalities while adding conservation across potential parents.

### Implied integrality of auxiliary variables

Only `x` and `y` remain binary, reducing the explicit binary count to **496**. Variables `c`, `cc`, and `cx` become continuous on \([0,1]\).

This is exact, not an approximation. With binary `x`, incoming-flow conservation makes each `cx` either zero or the membership value of its child. Since edges point strictly forward, backward induction applies: at nodes without internal children, `c_1` gives `c = y`; at earlier nodes, it expresses `c` as a sum of binary direct assignments and already integral child memberships. Its bounds restrict that sum to zero or one. The retained product inequalities then force every `cc` to the corresponding binary product.

### Valid subtree-size and pair-membership cuts

Three families of strengthening inequalities were added:

1. **Subtree lower bound**
   \[
   \sum_i c[u,i]\geq 2+\sum_v x[u,v].
   \]
   If a node has \(k\) internal children, `c_2` gives it \(2-k\) directly attached components. Each internal child has at least two component leaves. Unique parentage and `c_3` prevent double counting, giving at least \(2k+(2-k)=2+k\) components.

2. **Subtree upper bound**
   \[
   \sum_i c[u,i]\leq 19-u+2.
   \]
   Forward-only edges limit the subtree to at most \(19-u+1\) internal nodes. A full binary tree with \(t\) internal nodes has \(t+1\) leaves, establishing the bound.

3. **Pair-membership cuts**  
   For every node and component, the sum of pair-membership variables involving that component is at least its membership variable. Every internal-node subtree contains at least two components, so a component present in that subtree must share it with another component.

These cuts preserve all integer-feasible hierarchy decisions while excluding fractional configurations.

## 4. Expected computational effect

The reformulation combines sparse indexing, an exact flow-based product formulation, implied-integrality relaxation, and tree-specific valid inequalities. It preserves the supplied data, minimization direction, and objective values under the accompanying reconstruction mapping.

The intended benefits are fewer explicit binary variables and a stronger LP relaxation. Actual solve-time improvement remains an empirical question; no solver timing results were provided.

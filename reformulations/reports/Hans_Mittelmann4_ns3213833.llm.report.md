# Reformulation Report: Hierarchical Component Modularity

## 1. Inferred application and interpretation

The model appears to construct a **hierarchical decomposition of a system into components**, balancing component dependencies against the desirability of grouping components together. This interpretation is inferred from the formulation; the source does not identify a specific application domain.

The instance contains:

- **20 components**, described by a binary design structure matrix, `DSM`;
- **19 internal hierarchy nodes**;
- A restriction allowing a parent–child arc from node `u` to node `v` only when `0 < v-u <= 8`.

Each internal node has exactly two children, which may be other internal nodes or individual components. Every component is attached once, and every internal node except node 1 has exactly one parent. Because arcs always point toward larger node indices, the hierarchy is acyclic and rooted at node 1.

The resulting structure is a **rooted full binary tree**, with the 20 components as leaves. Variable `c[u,i]` indicates whether component `i` belongs to the subtree rooted at node `u`.

Although `DSM` is not symmetric, the objective uses only entries `DSM[i,j]` with `i < j`. This ordering-dependent interpretation is preserved exactly.

## 2. Original mathematical formulation

### Variables

The original model declares **15,941 binary variables** before presolve:

| Variable | Count | Meaning for entries used by the model |
|---|---:|---|
| `c[u,i]` | 380 | Component `i` belongs to node `u`’s subtree |
| `x[u,v]` | 361 | Node `v` is a direct child of node `u` |
| `y[u,i]` | 380 | Component `i` is a direct leaf child of node `u` |
| `cc[u,i,j]` | 7,600 | Product `c[u,i] c[u,j]`, for `i < j` |
| `cx[u,i,v]` | 7,220 | Product `x[u,v] c[v,i]`, on admissible arcs |

Some declared entries have no role in any constraint or objective expression.

### Constraints

There are **18,247 explicit constraints** before presolve, excluding variable bounds:

- **10,830 component-pair product constraints:** `c_0_1`–`c_0_3` enforce the product represented by `cc`.
- **380 membership equations:** `c_1` propagates component membership from child subtrees and directly attached leaves.
- **6,960 arc–membership product constraints:** `c_1_1`–`c_1_3` enforce the product represented by `cx`.
- **19 degree equations:** `c_2` gives each internal node exactly two children.
- **20 component-assignment equations:** `c_3` attaches each component exactly once.
- **18 parent-assignment equations:** `c_4` gives every nonroot internal node exactly one parent.
- **20 root-membership equations:** `c_5` places every component in the root subtree.

### Objective

The model **minimizes** `Modularity_Index`. For each node and each pair `i < j`:

- If `DSM[i,j] = 0`, it penalizes placing both components in that subtree.
- If `DSM[i,j] = 1`, it penalizes placing component `i` in the subtree without component `j`.

Each such contribution has weight 2. The objective therefore evaluates component grouping across the entire hierarchy, not merely at one partition level.

## 3. Reformulation and justification

### Sparse-domain preprocessing

Only **116 node-to-node arcs** satisfy the distance restriction. The reformulation retains `x` and `cx` only on these arcs and retains `cc` only for `i < j`.

This removes **9,135 unused variable entries**. It is valid because:

- Every original occurrence of `x` or `cx` is restricted to admissible arcs.
- Every original occurrence of `cc` is restricted to `i < j`.
- The deleted entries therefore affect neither feasibility nor the objective.

The mapping script assigns these unused original variables zero. Zero satisfies their original binary domains and cannot change any model expression.

### Exact relaxation of implied-integral variables

Only `x` and `y` remain explicitly binary. Variables `c`, `cx`, and `cc` become continuous on `[0,1]`.

This does not rely on a heuristic relaxation:

1. At the last internal node, there are no admissible outgoing arcs. Equation `c_1` therefore gives `c[u,i] = y[u,i]`, so membership is binary.
2. Proceeding backward through node indices, every potential child already has binary membership. Constraints `c_1_1`–`c_1_3` then force `cx[u,i,v] = x[u,v] c[v,i]`, which is binary.
3. Equation `c_1` makes each remaining `c[u,i]` an integer sum. Its bounds restrict that sum to zero or one.
4. Finally, `c_0_1`–`c_0_3` force `cc` to equal the product of two binary memberships.

Thus every integer solution in the retained binary variables yields valid original binary values for all these continuous variables.

### Subtree-size valid inequalities

The reformulation adds
\[
2\leq \sum_i c[u,i]\leq U_u,
\qquad
U_u=\min\{\texttt{num\_comp},\,\texttt{num\_node}-u+2\}.
\]

These bounds follow from the original tree constraints:

- Forward-only arcs and `c_4` connect every internal node to the root without cycles.
- Constraint `c_2` gives each internal node two children.
- Constraint `c_3` makes component leaves distinct.
- The membership equations identify the leaves below each node.

A full binary subtree with \(k\) internal nodes has \(k+1\) leaves. Each subtree has at least one internal node, hence at least two leaves. Descendants of node `u` have larger indices, so its subtree contains at most `num_node-u+1` internal nodes. This proves the upper bound.

### Aggregate product-envelope cuts

For each admissible arc, let
\[
S_v=\sum_i c[v,i],\qquad T_{uv}=\sum_i cx[u,i,v].
\]
The reformulation adds
\[
2x[u,v]\leq T_{uv}\leq U_vx[u,v],
\]
\[
S_v-U_v(1-x[u,v])\leq T_{uv}
\leq S_v-2(1-x[u,v]).
\]

These are aggregate product-envelope inequalities using the proven bounds \(2\leq S_v\leq U_v\). They are valid because the original product constraints imply \(T_{uv}=x[u,v]S_v\): the aggregate is zero when the arc is absent and equals the child’s subtree size when it is present. The inequalities can exclude fractional relaxation points without excluding original feasible solutions.

## 4. Resulting formulation

The reformulated model contains **496 binary variables**, **6,310 continuous variables**, and **502 additional valid inequalities**. Original instance data, objective values, and minimization direction are unchanged.

The intended benefits are fewer declared variables, substantially fewer explicit integrality requirements, and a stronger linear relaxation. These are structural improvements; no solver benchmark was provided to establish the actual runtime reduction.

## Problem background

The model describes a **prize-collecting directed tour** over \(n\) nodes, with node 1 required to participate. A plausible application is selecting customer visits or service locations and choosing their order to maximize net benefit.

The input \(p[i,j]\) specifies the contribution obtained when node \(i\) selects node \(j\) as its successor. The special choice \(j=0\) means that node \(i\) is omitted, contributing \(p[i,0]\). Thus, omission need not have zero value, and the model does not assume nonnegative rewards or symmetric connections.

Despite an informal comment in the source, `next[i]` identifies a **successor node**, rather than a position. A successor of 1 closes the tour.

## Original formulation

The model has **\(3n+1\) integer decision variables**:

- `pos[i] ∈ 0..n`: the position of node \(i\), with zero indicating omission.
- `next[i] ∈ 0..n`: the successor of node \(i\), with zero indicating omission.
- `prize[i] ∈ min_p..max_p`: the contribution associated with its successor choice.
- `objective ∈ 0..max_obj`: the total contribution.

The constraints fix `pos[1] = 1` and impose four conditions for each node:

1. A node has positive position exactly when it has a nonzero successor.
2. Each node has at most one incoming selected edge.
3. If an edge leads to a node other than node 1, the successor’s position equals the predecessor’s position plus one.
4. `prize[i] = p[i,next[i]]`.

Finally, `objective` equals the sum of all node contributions and is **maximized**. The declared objective bounds are part of the original feasible set and remain unchanged.

### Why these constraints define one tour

Every used node points to another used node. A successor of 1 reaches the mandatory root; any other nonzero successor has positive position by the increment constraint.

Consequently, successor selection maps the finite set of used nodes into itself. Since incoming degree is at most one, this mapping is a permutation, so the used nodes form disjoint directed cycles. A cycle avoiding node 1 is impossible: positions would increase by one along every edge and could not return to their starting value. Therefore, all used nodes belong to one cycle through node 1. The tour consisting only of node 1 is permitted.

## Reformulation and justification

### Binary successor representation

The reformulation introduces \(n(n+1)\) binary variables \(x_{ij}\), represented by `pc_reform_arc`, for successor choices \(j=0,\ldots,n\). Exactly one choice is selected per node. Linear channeling equations retain the original variables:

\[
\text{next}[i]=\sum_{j=0}^{n}j x_{ij},
\qquad
\text{prize}[i]=\sum_{j=0}^{n}p[i,j]x_{ij}.
\]

This replaces variable-index prize lookup with a linear expression. Because precisely one binary is selected, both equations reproduce the original successor and contribution exactly, including omission contributions.

The original usage equivalence becomes

\[
1-x_{i0}\leq \text{pos}[i]\leq n(1-x_{i0}).
\]

These inequalities force position zero for an omitted node and a positive position otherwise.

### Incoming-degree equalities

The original incoming-degree inequalities are strengthened to

\[
\sum_k x_{ki}=1-x_{i0}.
\]

This is valid by the tour argument above: every used node has exactly one incoming edge, and no omitted node can receive an edge. These equalities express implied structure directly and strengthen the linear relaxation.

### Self-loop preprocessing and position bounds

For every non-root node \(i\), the reformulation fixes \(x_{ii}=0\). Such a self-loop would activate the original equation
\(\text{pos}[i]=\text{pos}[i]+1\), which is impossible. The root self-loop is retained.

Used non-root nodes are also constrained to have position at least 2. If \(m\) nodes are used, their positions follow the unique root-containing tour as \(1,\ldots,m\); hence every non-root position is bounded above by

\[
m=\sum_k(1-x_{k0}).
\]

These are problem-specific valid bounds derived from the original constraints, not additional assumptions.

### Bounded linear position implications

For each possible non-root successor, two big-\(M\) inequalities enforce the original position increment when its binary edge variable is one. When the edge is absent, the inequalities are inactive.

The constants follow from the original bounds \(0\leq\text{pos}[i]\leq n\), with tighter constants for edges leaving node 1 because its position is fixed to 1. This replaces variable-index position implications with explicit linear constraints suitable for the HiGHS MIP backend.

## Preservation and intended benefit

The reformulation preserves the external data interface, all original decision variables, the objective bounds, and the maximization direction. The mapping script copies the four original variable symbols and excludes auxiliary binaries; no reconstruction or renumbering is required.

The intended benefit is a more explicit MIP formulation: linear successor selection, linear reward calculation, bounded position implications, and stronger degree and position constraints. These changes may improve relaxation strength and reduce compilation overhead from variable-index expressions, although no instance-specific runtime improvement was established.

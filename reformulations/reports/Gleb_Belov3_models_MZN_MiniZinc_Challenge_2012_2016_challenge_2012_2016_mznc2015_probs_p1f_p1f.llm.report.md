# Perfect 1-Factorization of a Complete Graph

## Problem background

The model seeks a **perfect 1-factorization** of the complete graph \(K_n\), whose vertices represent \(n\) entities and whose edges represent all possible pairwise interactions.

A useful interpretation is round-robin scheduling: each matching is a round in which every participant meets exactly one other participant, and all possible pairs meet exactly once across \(n-1\) rounds. The additional *perfectness* requirement is stronger than ordinary round-robin scheduling: the interactions from any two rounds must form one cycle visiting every participant, rather than several disconnected cycles.

The objective imposes a numerical preference among feasible factorizations; the source does not identify it as an application-specific cost.

## Original formulation

The external parameter is \(n\), and the model defines \(m=n-1\).

### Variables and objective

The array \(p\) contains \(mn\) integer variables with domain \(1,\ldots,n\). Entry \(p[r,i]\) is the partner of vertex \(i\) in matching \(r\).

A derived integer variable represents the objective:
\[
\min \ \mathrm{objective}=\sum_{i=1}^{n} i\,p[1,i].
\]

### Constraints

- **No self-pairing:** \(p[r,i]\ne i\).
- **Perfect matchings:** a self-inverse constraint on each row enforces
  \(p[r,p[r,i]]=i\). Together with the absence of self-pairing, this partitions the vertices into pairs.
- **Edge partition:** an all-different constraint on each column makes every vertex’s partners distinct across the \(n-1\) matchings. Since self-pairing is excluded, every other vertex occurs exactly once.
- **Perfectness:** for each of the \(\binom m2\) pairs of matchings, auxiliary successor variables select edges from their union and must form a Hamiltonian circuit. An auxiliary orientation symmetry breaker fixes the first successor.
- **Matching order:** adjacent rows are strictly lexicographically increasing. This removes permutations of the matching rows while determining which row contributes to the objective.

## Reformulation and justification

The reformulation replaces the principal global constraints with a mixed-integer linear formulation suited to **HiGHS**, while retaining `p`, its meaning, and the original objective.

### 1. Binary undirected-edge representation

For each matching \(r\) and unordered pair \(\{u,v\}\), a binary variable indicates whether that edge belongs to the matching.

Each vertex has exactly one selected incident edge in each matching, and each graph edge is selected in exactly one matching. These equations replace the original self-inverse, no-self-loop, and column all-different constraints.

This is equivalent because the original rows are fixed-point-free involutions: their entries describe disjoint undirected pairs covering every vertex. Conversely, selecting exactly one incident edge per vertex creates such an involution. Linear channeling equations recover each entry of `p` as the endpoint of its unique selected edge.

### 2. Connectivity flows instead of circuit constraints

For every pair of matchings, signed continuous flow variables are introduced on the undirected edges. Vertex 1 supplies \(n-1\) units, and every other vertex consumes one unit. Flow is permitted only on edges belonging to the two matchings.

The matching and edge-partition equations imply that their union is a simple **2-regular graph**: each vertex has two distinct incident edges. A finite simple 2-regular graph is a disjoint union of cycles. Flow conservation rules out any component not containing the root, because its total demand could not be supplied across its boundary. Thus the union is connected and consequently is one Hamiltonian cycle.

The absolute flow capacity is \((n-1)/2\) per selected edge. This does not exclude a Hamiltonian cycle: send half a unit to each non-root vertex along each of the cycle’s two root-to-vertex paths. The largest directional load is \((n-1)/2\), and the resulting net signed flows satisfy the stated bounds.

The original circuit-orientation symmetry breaker does not restrict `p` further: either orientation of a Hamiltonian cycle is available, so the orientation beginning with the first matching’s edge can always be chosen.

### 3. Simplified matching-order symmetry breaking

The original column all-different constraint makes the first entries of all rows distinct. Therefore, comparisons between rows are decided immediately by their first entries, and lexicographic ordering is equivalent to ordering those entries.

They are precisely the \(n-1\) values \(2,\ldots,n\), because vertex 1 must meet every other vertex once. Hence the original ordering is equivalent to
\[
p[r,1]=r+1.
\]
The reformulation fixes the corresponding edge variables instead of using lexicographic constraints. This preserves the original ordered solutions, including the identity of the objective-bearing first matching.

### 4. Parity check and objective bound

Two additional strengthening techniques are used:

- **Odd-order infeasibility check.** Whenever a matching is required, \(n\) must be even: the original self-inverse and no-self-loop constraints partition all vertices into two-element sets.
- **Rearrangement-based objective bound.** If \(p[1,1]=2\), the matching property forces \(p[1,2]=1\), contributing \(4\) to the objective. The remaining partners form a permutation of \(3,\ldots,n\). By the rearrangement inequality, pairing increasing weights with decreasing partner values minimizes their weighted sum, giving the valid bound
  \[
  \mathrm{objective}\ge
  4+\sum_{i=3}^{n} i(n+3-i).
  \]
  This bound remains valid even though the remaining matching and perfectness constraints may impose additional restrictions.

## Interface and solution mapping

The external data interface and the original definitions of \(m\), objective bounds, and objective are unchanged. The reformulation introduces \(m\binom n2\) binary edge variables and \(\binom m2\binom n2\) continuous flow variables for \(n\ge2\).

Because `p` remains explicitly represented, the mapping script copies its values and index sets directly from the solver output. Auxiliary variables are discarded, and the objective is recomputed by its original definition. The intended benefit is a more direct linear formulation for HiGHS; no measured runtime improvement is established here.

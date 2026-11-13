## Problem background

The model represents a fuel-constrained prize-collecting routing problem. Mario visits houses to collect gold, starting at his own house and finishing at Luigi’s house. Travel consumes fuel, and the goal is to maximize the gold collected within a prescribed fuel limit.

The implementation represents the route as a cycle by fixing an artificial closing arc from Luigi’s house to Mario’s house. Importantly, the original fuel expression charges **every selected successor arc**, including this closing arc and the self-loops representing unvisited houses. The reformulation preserves that accounting rather than assuming these costs are zero.

## Original formulation

Let \(n=\texttt{nbHouses}\). The original model declares \(n+2\) integer decision variables:

- `succ[i]`: the successor of house \(i\), with domain \(1,\ldots,n\).
- `fuel`: total consumption, bounded by `0..fuelMax`.
- `objective`: collected gold, bounded by `0..goldTotalAmount`.

Its four principal constraints are:

1. **Fuel accounting**
   \[
   \texttt{fuel}=\sum_i \texttt{conso}[i,\texttt{succ}[i]].
   \]

2. **Gold accounting**
   \[
   \texttt{objective}
   =\sum_i \texttt{goldInHouse}[i]\,[\texttt{succ}[i]\ne i].
   \]
   Thus, a house contributes gold precisely when its successor is not itself.

3. **Subcircuit connectivity:** all non-self successor arcs form a single cycle; houses outside that cycle have self-loops.

4. **Fixed closing arc:** `succ[LuigiHouse] = MarioHouse`.

The objective is to **maximize collected gold**. The original search annotation branches on successors before the objective.

If Mario’s and Luigi’s houses differ, the fixed closing arc forces both onto the cycle. Removing that arc gives the intended Mario-to-Luigi path. If the two houses coincide, the fixed arc is instead a self-loop, and the original model permits a separate cycle excluding that house. This edge-case behavior must be preserved.

## Reformulation and justification

### Linear binary-arc representation

The reformulation introduces \(n^2\) binary variables \(x_{ij}\), indicating whether `succ[i] = j`. Each row and each column sums to one, and the original successors are retained through
\[
\texttt{succ}[i]=\sum_j jx_{ij}.
\]

Exactly one selected entry per row makes this channeling exact. Column equations enforce the permutation structure already implied by the original subcircuit.

Fuel and gold become linear expressions:
\[
\texttt{fuel}=\sum_{i,j}\texttt{conso}[i,j]x_{ij},
\qquad
\texttt{objective}=\sum_i\texttt{goldInHouse}[i](1-x_{ii}).
\]
These are algebraically equivalent to the original expressions. The change avoids variable-indexed cost expressions and exposes a mixed-integer linear structure suitable for HiGHS.

### Ordering-based subtour elimination

When the endpoints differ, \(n\) bounded integer rank variables replace the subcircuit constraint. Mario has rank zero, and every selected non-self arc except the closing arc must increase rank by at least one.

Any separate nontrivial cycle would require ranks to increase strictly around the cycle and return to their starting value, which is impossible. Combined with the row and column equations and the fixed closing arc, this leaves exactly one nontrivial cycle containing both endpoints.

Conversely, every original feasible route admits ranks equal to its successive positions along the Mario-to-Luigi path. Therefore, the ordering formulation preserves every original feasible successor assignment.

Additional strengthening constraints set unvisited-house ranks to zero, require positive ranks for visited houses other than Mario, bound all ranks by Luigi’s rank, and set Luigi’s rank to the number of visited houses minus one. All are satisfied by these path-position ranks.

When the endpoints coincide, the original `subcircuit` constraint is retained to preserve its distinct semantics.

### Fuel-bound arc preprocessing

For each row, preprocessing computes its minimum and maximum arc costs:
\[
m_i=\min_j c_{ij},\qquad M_i=\max_j c_{ij}.
\]

If arc \(i\to j\) is selected, choosing one arc in every other row implies
\[
c_{ij}+\sum_{k\ne i}m_k
\le \texttt{fuel}\le
c_{ij}+\sum_{k\ne i}M_k.
\]

Consequently, an arc is fixed to zero if its lower bound exceeds `fuelMax`, or if its upper bound is below zero. Either condition contradicts the original fuel domain.

These bounds deliberately ignore connectivity and column restrictions, making them potentially weak but safe. Their validity does not require nonnegative costs or zero-cost self-loops.

### Interface and solution preservation

All original external parameters, decision variables, domains, and objective direction remain unchanged. The original CP-oriented search annotation is omitted in favor of the backend’s mixed-integer search.

The supplied mapping script copies only `succ`, `fuel`, and `objective`, preserving their encoded array indices where applicable. No reconstruction is needed because the original variables retain their meanings.

The changes aim to improve solving through explicit linear structure, early arc elimination, and stronger connectivity constraints. No instance-specific performance improvement has been measured.

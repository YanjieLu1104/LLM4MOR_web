## Problem background

The model describes a fuel-constrained prize-collecting routing problem. Mario travels between houses to collect gold, starting at his own house and finishing at Luigi’s house. Each house has a gold value, and each directed connection has a fuel-consumption value. The aim is to maximize collected gold within the available fuel.

The implementation represents the route as a cycle by fixing an artificial closing connection from Luigi back to Mario. Importantly, the original fuel calculation includes this closing connection and the diagonal consumption of every unvisited house. The reformulation preserves these details rather than assuming that their costs are zero.

## Original model

Let \(n=\texttt{nbHouses}\). The original model contains \(n+2\) integer decision variables:

- `succ[i]`, with domain \(1,\ldots,n\), identifies the successor of house \(i\). A self-loop, `succ[i] = i`, denotes an unvisited house.
- `fuel`, bounded by `0..fuelMax`, records total consumption.
- `objective`, bounded by `0..goldTotalAmount`, records collected gold.

Four top-level constraints define feasibility:

1. **Fuel accounting**
   \[
   \texttt{fuel}=\sum_i \texttt{conso}[i,\texttt{succ}[i]].
   \]
2. **Gold accounting**
   \[
   \texttt{objective}
   =\sum_i \texttt{goldInHouse}[i]\,[\texttt{succ}[i]\ne i].
   \]
3. **Route connectivity:** `subcircuit(succ)` requires all non-self-loop successors to form a single directed cycle, with remaining houses represented by self-loops.
4. **Endpoint connection:** `succ[LuigiHouse] = MarioHouse`.

The objective is to **maximize** `objective`. When Mario’s and Luigi’s houses differ, deleting the fixed closing connection from the selected cycle produces the intended Mario-to-Luigi path.

The declared data types do not require consumption or gold values to be nonnegative. Consequently, valid reformulations must not rely on those assumptions.

## Reformulation and preprocessing

### Binary assignment formulation

The reformulation introduces \(n^2\) Boolean arc variables \(x_{ij}\). Each row and each column must contain exactly one selected arc, and the original successors are linked through
\[
\texttt{succ}[i]=\sum_j jx_{ij}.
\]

These assignment equations are valid because a subcircuit is a permutation: every house has exactly one successor and one predecessor, including self-loops for unvisited houses.

Fuel and gold become linear expressions:
\[
\texttt{fuel}=\sum_{i,j}\texttt{conso}[i,j]x_{ij},
\qquad
\texttt{objective}=\sum_i\texttt{goldInHouse}[i](1-x_{ii}).
\]
Exactly one selected arc per row makes these expressions identical to the original accounting equations. This replaces variable-indexed consumption lookups with explicit linear relationships suited to the HiGHS mixed-integer backend.

### Bound-based arc elimination

For each row \(i\), preprocessing computes
\[
m_i=\min_j\texttt{conso}[i,j],
\qquad
M_i=\max_j\texttt{conso}[i,j].
\]

If arc \(i\to j\) is selected, total fuel must lie between
\[
\texttt{conso}[i,j]+\sum_{k\ne i}m_k
\quad\text{and}\quad
\texttt{conso}[i,j]+\sum_{k\ne i}M_k.
\]

An arc is therefore forbidden if its lower bound exceeds `fuelMax`, or its upper bound is below zero.

These bounds follow directly from selecting one consumption value in every row and from the original domain `fuel ∈ 0..fuelMax`. They ignore connectivity and column restrictions, so they may be weak, but cannot remove a feasible solution. They remain valid for negative consumption values and nonzero diagonal costs.

### Continuous ordering constraints for connectivity

When the endpoints differ, the global subcircuit constraint is replaced by a Miller–Tucker–Zemlin-style ordering formulation using \(n\) continuous auxiliary variables.

Mario’s order is fixed to zero. Every selected non-self arc whose destination is not Mario requires its destination’s order to exceed its source’s order by at least one. Bounds \(0\le u_i\le n-1\) make a big-\(M\) value of \(n\) sufficient to deactivate the inequality for an unselected arc.

This eliminates disconnected cycles: summing the strict order increases around any cycle not containing Mario yields a contradiction. The assignment equations decompose the solution into cycles, and the fixed Luigi-to-Mario arc ensures that a nontrivial cycle containing Mario exists. Hence all visited houses belong to that single cycle, exactly as required by `subcircuit`.

Additional strengthening constraints set unvisited houses’ orders to zero, give visited non-Mario houses an order of at least one, and set Luigi’s order to the number of visited houses minus one. These are valid because any original feasible route can be numbered consecutively from Mario to Luigi. Continuous rather than integer orders suffice for the cycle-elimination argument.

### Equal-endpoint case

If `MarioHouse = LuigiHouse`, the fixed successor is a self-loop. The original model can then select a cycle elsewhere, or select no nontrivial cycle at all. Requiring every selected cycle to contain Mario would incorrectly exclude such solutions.

The reformulation therefore retains `subcircuit(succ)` in this case and fixes the unused ordering variables to zero.

## Interface and solution preservation

All original external parameters, decision-variable names, domains, and optimization direction are retained. The mapping script copies only `succ`, `fuel`, and `objective`, preserving their array and scalar encodings and rejecting missing values rather than inventing replacements.

The changes target stronger, more explicit MIP structure and safe arc pruning. No instance-specific assumptions were introduced, and no solve-time improvement was measured in the supplied conversation.

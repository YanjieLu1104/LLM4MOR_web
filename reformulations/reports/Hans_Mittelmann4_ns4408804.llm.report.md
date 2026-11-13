# Reformulation Report: Hans_Mittelmann4_ns4408804

## 1. Problem background and interpretation

The model represents a **single-vehicle routing problem** over 183 locations given by two-dimensional coordinates. One location, \((-20,93)\), is the depot; the other 182 locations must each be visited exactly once.

Travel costs between distinct locations are their Manhattan distances:
\[
c_{uv}=|u_x-v_x|+|u_y-v_y|.
\]
Although the selected route forms a closed tour, the objective excludes the cost of returning to the depot. Thus, the optimization is equivalent to finding a minimum-cost Hamiltonian path starting at the depot, with an unrestricted final location, and adding a cost-free return arc.

This interpretation follows from the mathematical structure. The source includes transportation-related comments but does not establish a specific application or physical distance unit. The continuous flow variables are best understood as an artificial device for enforcing route connectivity, rather than actual transported goods.

## 2. Original formulation

Let \(K\) denote the 183 locations, \(L=K\setminus\{(-20,93)\}\), and \(r=(-20,93)\).

### Variables

The original formulation declares variables for every ordered pair of locations, including self-pairs:

- **33,489 binary variables** \(x_{uv}\), indicating whether the route uses arc \(u\to v\).
- **33,489 nonnegative continuous variables** \(y_{uv}\), representing artificial flow on those arcs.

### Constraints

The original model contains **67,527 scalar constraints**, before presolve:

| Constraint family | Count | Meaning |
|---|---:|---|
| Outgoing degree | 183 | Exactly one selected arc leaves each location |
| Incoming degree | 183 | Exactly one selected arc enters each location |
| Two-cycle restrictions | 33,489 | \(x_{uv}+x_{vu}\leq1\), including self-pairs and duplicate orientations |
| Flow capacities | 33,489 | \(y_{uv}\leq182x_{uv}\) |
| Depot balance | 1 | The depot supplies 182 units of flow |
| Non-depot balances | 182 | Each non-depot location consumes one unit |

The degree equations alone produce a collection of disjoint directed cycles. The flow constraints eliminate every cycle not containing the depot: summing the unit-demand balances over such a cycle would require positive net inflow, but its degree equations and arc capacities permit no flow across its boundary. Consequently, every integer feasible solution is a single Hamiltonian tour.

### Objective

The model minimizes
\[
\sum_{u,v\in K} A_{uv}x_{uv}
-\sum_{u\in K}A_{ur}x_{ur}.
\]
The second term cancels all return-to-depot costs. The large diagonal cost of 100,000 has no effect on feasible integer solutions because the two-cycle restrictions already prohibit self-arcs.

## 3. Reformulation and justification

The reformulation retains both original variable arrays, their indices, and the fixed instance data. It uses exact preprocessing, stronger flow bounds, and selected subtour-elimination inequalities.

### 3.1 Explicitly fix self-arcs and self-flows to zero

For a self-pair, the original two-cycle restriction becomes
\[
2x_{uu}\leq1.
\]
Since \(x_{uu}\) is binary, it must equal zero. The original capacity constraint then implies \(y_{uu}=0\).

The reformulation places these consequences directly in variable bounds, making the fixed variables immediately available to solver presolve.

### 3.2 Remove duplicate two-cycle restrictions

For distinct locations, the restrictions indexed by \((u,v)\) and \((v,u)\) are identical. Only one is retained, using lexicographic coordinate order.

After self-pairs are handled by bounds, this reduces the family from 33,489 rows to
\[
\binom{183}{2}=16,653
\]
without changing its effect.

### 3.3 Fix flow entering the depot and strengthen depot departures

The depot’s outgoing degree equation and original capacities imply
\[
\sum_v y_{rv}\leq182\sum_v x_{rv}=182.
\]
Its original balance requires
\[
\sum_v y_{rv}-\sum_u y_{ur}=182.
\]
Because flow is nonnegative, these relations force total outgoing flow to equal 182 and total incoming flow to equal zero. Hence every \(y_{ur}=0\).

Furthermore, summing the nonnegative capacity slacks \(182x_{rv}-y_{rv}\) gives zero. Each slack must therefore vanish:
\[
y_{rv}=182x_{rv}.
\]

The reformulation fixes incoming depot flows to zero and replaces outgoing depot capacities with these equalities. The original depot balance becomes redundant: the departure equalities, outgoing degree equation, and zero incoming flows imply it directly.

### 3.4 Tighten flow bounds between non-depot locations

For distinct \(u,v\in L\), the reformulation uses
\[
x_{uv}\leq y_{uv}\leq181x_{uv}.
\]

To justify these bounds, recall that the original constraints enforce one Hamiltonian tour. The selected departure from the depot carries 182 units, and each subsequent non-depot location consumes one unit. Flow on successive selected arcs is therefore \(182,181,\ldots,1,0\), with zero on the return to the depot.

Thus, every selected arc between two non-depot locations carries between 1 and 181 units; unselected arcs carry zero by the original capacities. These bounds preserve all original integer feasible solutions while strengthening the linear relaxation.

### 3.5 Simplify the objective algebraically

The positive and negative terms for arcs entering the depot cancel exactly. The objective is rewritten as
\[
\min\sum_{u\in K,\;v\in L}A_{uv}x_{uv}.
\]
This preserves the minimization direction and every objective value while removing unnecessary terms.

### 3.6 Add geographically selected subtour-elimination cuts

For each non-depot location, the reformulation constructs neighborhoods containing non-depot locations within Manhattan distance 4 or 12. For every such neighborhood \(S\) with at least three members, it adds
\[
\sum_{\substack{u,v\in S\\u\ne v}}x_{uv}\leq |S|-1.
\]

These are standard directed subtour-elimination inequalities. Each neighborhood excludes the depot and is therefore a proper subset of all locations. A Hamiltonian tour must leave that subset at least once. Summing the outgoing degree equations over \(S\) then shows that at most \(|S|-1\) selected arcs can remain entirely inside it.

The distance thresholds only select which valid inequalities to include; they impose no assumption about the optimal route. Their purpose is to strengthen the relaxation around geographically close groups of locations without enumerating all exponentially many subsets.

## 4. Expected computational effect and preservation

The reformulation exposes forced zeros, removes duplicate rows, strengthens artificial-flow constraints, and adds a limited family of connectivity cuts. These changes aim to improve presolve and reduce fractional solutions encountered during branch-and-bound. The additional cuts also increase relaxation size, so an actual runtime improvement requires computational testing.

Both original variable arrays remain present, so the supplied solution-mapping script uses an identity mapping. The reformulation preserves the original integer feasible solutions and their objective values.

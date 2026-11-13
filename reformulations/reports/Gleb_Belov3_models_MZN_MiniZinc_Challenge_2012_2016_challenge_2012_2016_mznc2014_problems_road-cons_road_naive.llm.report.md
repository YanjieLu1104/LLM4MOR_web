# Road Construction Model: Reformulation Report

## 1. Background and interpretation

The model represents a budget-constrained road construction problem. There are `n` locations, and a road may be selected between each unordered pair of distinct locations. Selecting a road incurs its construction cost and makes its specified distance available to the model. The objective is to minimize the sum of final pairwise travel measures while keeping total construction cost within `budget`.

Two details distinguish this formulation from a conventional network-design model:

- Only upper-triangular entries of `distance` and `cost` are used. Road decisions are symmetric, but symmetry of the input matrices is not required.
- An unbuilt road receives the finite value `M = 1000000`, rather than being removed from the network. There is no explicit connectivity requirement.

Moreover, the path recurrence is restricted: for endpoints `x < y`, it combines paths through vertices `z > x`. Thus, the model should not be interpreted as an unrestricted all-pairs shortest-path formulation. The reformulation preserves this restriction and the finite-penalty semantics.

## 2. Original mathematical structure

### Variables

For a nonnegative number of locations `n`, the original declarations contain:

- **`construct[x,y]`**: an `n × n` Boolean array indicating road construction.
- **`sp[x,y,s]`**: an `n × n × n` integer array, with every entry bounded by `0..M`, representing pairwise travel measures at successive stages.
- **`objective`**: a derived integer variable equal to the sum of final-stage values over unordered pairs.

The symmetry constraints leave only \(n(n-1)/2\) independent road choices. Diagonal construction decisions are fixed to false.

### Constraints

The original constraints impose:

1. **Diagonal values:** no self-roads, and zero travel measures from a location to itself at every stage.
2. **Initialization:** for `x < y`, the first-stage measure is `distance[x,y]` when the road is selected and `M` otherwise.
3. **Symmetry:** both construction decisions and travel measures agree in the two endpoint orders.
4. **Stage recurrence:** each new travel measure is the minimum of its previous value and eligible sums of two previous-stage measures.
5. **Budget feasibility:** the sum of upper-triangular construction costs for selected roads cannot exceed `budget`.

For \(n \geq 1\), there are \(\binom{n}{2}(n-1)\) scalar recurrence equalities before reformulation. Each minimum can contain up to `n-2` path-sum candidates in addition to the carried-forward value. These repeated minimum constraints are the principal target of the reformulation.

### Objective

The optimization direction is **minimization**:

\[
\min \sum_{x<y} sp[x,y,n].
\]

Construction cost is constrained, not minimized directly.

## 3. Reformulation and justification

### 3.1 Explicit elimination of impossible road selections

The reformulated model fixes `construct[x,y]` to false whenever `distance[x,y]` lies outside `0..M`.

This follows directly from two original requirements:

- `sp[x,y,1]` belongs to `0..M`.
- Selecting the road forces `sp[x,y,1] = distance[x,y]`.

Consequently, such a road could never be selected in a feasible original solution. The added constraints expose an existing implication to the solver; they do not impose a new distance assumption.

### 3.2 Endpoint-based lower bounds

Two parameter arrays are computed from the original data:

- An **edge lower bound** is the specified distance when it lies in `0..M`, and `M` otherwise.
- A **path lower bound** is the smaller of the direct-edge lower bound and a bound obtained by adding the cheapest eligible first-edge and last-edge lower bounds.

The edge bound is valid because a feasible road is either selected at its nonnegative distance or unselected at `M`. Roads with out-of-range distances must be unselected.

For endpoints `x < y`, every indirect walk represented by the recurrence stays within vertices numbered at least `x`. A simple indirect path must therefore start and end through vertices in

\[
\{z : z>x,\ z\neq y\}.
\]

Its first and last edges cost at least the respective endpoint minima. All remaining edges are nonnegative, so omitting their costs gives a valid lower bound. A direct path is covered separately by the direct-edge bound. Nonnegative walks can also be simplified by removing cycles without increasing their length.

The resulting inequalities strengthen the bounds on `sp` without excluding any original feasible solution.

### 3.3 Removal of dominated minimum candidates

A path-sum candidate is omitted when its derived lower bound is at least `M`. First-stage candidates use edge lower bounds; later candidates use path lower bounds.

Every original minimum also contains the carried-forward value `sp[x,y,s]`, which is at most `M` by its declared domain. Therefore, a candidate that is always at least `M` cannot lower that minimum. Removing it preserves the equality exactly.

This is **bound-based candidate dominance preprocessing**. It can reduce the number of expressions—and associated solver machinery—needed to implement each minimum.

### 3.4 Replacement of redundant late stages

For `x < y`, stages after `n-x` are replaced by equalities to `sp[x,y,n-x]`.

The justification is specific to the original recurrence:

1. Every represented walk uses only vertices numbered at least `x`.
2. All feasible initialized edge values are nonnegative, including the finite `M` values for unbuilt roads.
3. Removing cycles cannot increase a walk’s length. A simple path in this subgraph has at most `n-x` edges.
4. Every such simple path is representable by that stage. For an indirect path, choose its smallest-numbered internal vertex as the recurrence’s splitting vertex. Both resulting subpaths satisfy the same endpoint restriction, so induction on the number of edges establishes representability.

Thus, by stage `n-x`, the recurrence has reached its minimum possible value for that pair. Further applications cannot improve it.

This is an **exact dynamic-programming horizon reduction**: nonlinear minimum constraints in redundant stages are replaced with linear equalities.

### 3.5 Solver interface and solution mapping

The original independent arrays, `sp` and `construct`, remain declared with their original domains and meanings. Original external parameters and the objective definition are also retained.

The mapping script therefore performs an identity mapping of these two arrays, preserving their supplied array metadata and excluding reformulation auxiliaries. It reports missing required variable values rather than inventing replacements.

The original search annotations were removed so that the HiGHS backend can use its own search strategy. This changes search guidance, not feasibility or the optimization objective.

## 4. Expected computational effect

The reformulation targets the size and strength of the optimization encoding through explicit implied road fixings, valid lower-bound inequalities, dominated-candidate removal, and elimination of redundant recurrence stages.

No additional assumptions about cost signs, input symmetry, or connectivity are introduced. The expected benefit is fewer minimum constraints and stronger bounds, but no runtime improvement has been established here because external instance data and comparative solve results were not supplied.

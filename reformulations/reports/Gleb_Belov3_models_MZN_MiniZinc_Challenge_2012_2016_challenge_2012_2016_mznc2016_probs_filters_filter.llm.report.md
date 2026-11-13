# Filter Scheduling and Resource Assignment

## Background

The model represents the scheduling of arithmetic operations in a filter computation, plausibly for implementation on hardware with limited arithmetic units. Operations are divided into additions and multiplications. Each operation must receive a start time and a resource identifier, while respecting data dependencies and avoiding simultaneous use of the same resource.

Addition and multiplication resources form separate pools: an adder and a multiplier may share the same numeric identifier without conflicting. The model minimizes the latest completion time among operations listed in `Last`. It does **not** explicitly require `Last` to contain every terminal operation.

## Original formulation

For \(n\) operations, the model has **\(2n+1\) independent integer variables**:

- \(t_i \in \{0,\ldots,100\}\): operation start times.
- \(r_i \in \{1,\ldots,10\}\): resource identifiers.
- `objective` \(\in \{0,\ldots,1000\}\): the latest completion time over `Last`.

The duration array `d` is defined by operation type, rather than independently chosen. Its declared domain requires every used duration to lie between 1 and 10. The arrays `t_add` and `t_mul` are views of the start times.

The constraints enforce:

1. **Operation-type consistency.** The addition and multiplication sets are disjoint and their cardinalities sum to \(n\).
2. **Precedence.** For every \(j \in \texttt{dependencies}[i]\),
   \[
   t_i+d_i\le t_j.
   \]
   Thus, despite the parameter name, its entries identify successors of operation \(i\).
3. **Resource availability.** Each resource identifier is bounded by the available number of units of its type, in addition to the variable-domain limit of 10.
4. **Non-overlap.** Separate `diffn` constraints represent additions and multiplications as rectangles with horizontal interval \([t_i,t_i+d_i)\) and vertical interval \([r_i,r_i+1)\). Two operations of the same type cannot overlap on the same resource.
5. **Exact objective definition.**
   \[
   \texttt{objective}=\max_{i\in\texttt{Last}}(t_i+d_i).
   \]

The optimization direction is minimization. The source also provides a search annotation that considers start times before resource assignments.

## Reformulation and justification

### Precedence preprocessing

The reformulation computes a bounded longest-path closure of the precedence graph. For a path from \(i\) to \(j\), summing its original precedence inequalities gives
\[
t_j\ge t_i+L_{ij},
\]
where \(L_{ij}\) is the sum of durations along the path, excluding the final operation.

Path lengths are capped at 101. This is sufficient because all start times lie between 0 and 100: any required separation greater than 100 already proves infeasibility.

This preprocessing supports three reductions:

- **Cycle detection.** Every duration is positive in a feasible original solution. A directed cycle would therefore imply \(t_i\ge t_i+c\) for some \(c>0\), which is impossible.
- **Tighter start-time bounds.** Since predecessor start times are nonnegative, incoming path lengths give lower bounds on an operation’s start. Since successor start times are at most 100, outgoing path lengths give upper bounds.
- **Removal of redundant non-overlap constraints.** If a precedence path connects two operations, the earlier operation must finish before the later one starts. Their resource-conflict constraint is therefore unnecessary. A pair is also omitted when the tightened bounds alone guarantee temporal separation.

The preprocessing clamps duration values to the declared feasible range for its internal arithmetic. This does not relax invalid input durations: the original definition and domain of `d` remain present and still reject them.

### Explicit mixed-integer non-overlap formulation

For each remaining pair of same-type operations, the two-dimensional non-overlap condition is replaced by four binary-selected alternatives:

- the first operation finishes before the second starts;
- the second finishes before the first starts;
- the first has a smaller resource identifier;
- the second has a smaller resource identifier.

These alternatives exactly describe the original rectangles’ possible separation. Because resource identifiers are integers and rectangle heights are one, distinct resource identifiers guarantee vertical separation.

Exactly one alternative is selected as a **certificate** of separation. This does not require the other alternatives to be false: whenever the original disjunction holds, any one satisfied alternative can be selected.

The resulting inequalities use bound-specific big-M coefficients. Temporal coefficients come from the tightened start-time bounds; resource coefficients use the original resource limits and the maximum identifier of 10. This replaces generic rectangle constraints with explicit linear constraints suited to the HiGHS mixed-integer backend.

### Objective-related workload cuts

The reformulation identifies operations that belong to `Last` or precede an operation in `Last`. Every such operation must finish by `objective`: precedence places its completion before a selected operation’s completion, and the exact maximum bounds that selected completion.

For each resource type, the reformulation adds
\[
\sum_{i\in R_{\text{type}}} d_i
\le
C_{\text{type}}\cdot\texttt{objective},
\]
where \(R_{\text{type}}\) contains these required operations and \(C_{\text{type}}\) is the effective resource capacity.

The inequality follows because these operations execute within the interval from zero to the objective, and each resource can supply at most that interval’s length of non-overlapping processing. For a nonempty type in a feasible instance, the effective capacity is the smaller of the supplied resource count and 10.

Restricting these cuts to precedence ancestors of `Last` is essential: the original model does not require unrelated operations to finish by the objective.

## Interface preservation and solution mapping

The original external parameters, independent decision variables, defined views, and exact objective constraint are retained. No resource-label symmetry breaking is imposed, so externally fixed resource assignments remain compatible.

The mapping script copies only `t`, `r`, and `objective` from the reformulated solution, preserving their supplied encodings and excluding auxiliaries. It reports missing required fields rather than inventing values.

The intended benefit is a stronger and more explicit mixed-integer formulation, with fewer unnecessary pairwise conflicts. No measured runtime improvement is established here; preprocessing and auxiliary-variable costs may affect performance differently across instances.

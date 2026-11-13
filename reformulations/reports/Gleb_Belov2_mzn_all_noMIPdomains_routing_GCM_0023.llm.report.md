# Pipe-Routing Model and Reformulation Report

## 1. Application background

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, in a three-dimensional plant layout. Coordinates are integer multiples of a 200 mm length unit.

The route must avoid equipment modules and existing pipe segments, respect prescribed nozzle-entry and nozzle-exit directions, and place its intermediate nodes in permitted support regions. These regions include module support zones, a pipe rack, and preferred rack levels with lower support costs.

The instance contains one pipe, represented by ten ordered nodes and at most nine axis-aligned legs. Its endpoints are fixed at `(275, 54, 8)` and `(255, 52, 143)`. Unused trailing legs have zero length. The model also imposes a cubic, geometry-based flexibility condition, apparently intended as a simplified pipe-stress or thermal-expansion criterion rather than a full mechanical simulation.

## 2. Original mathematical structure

### Variables

The original independent declarations comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-bound coordinates**, representing lower and upper corners in three dimensions.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, with zero denoting an unused leg and six values denoting signed coordinate directions.
- **20 binary integer flags**, identifying existing legs and the last existing leg.
- **One integer objective variable**.

The leg arrays include a dummy tenth row, which is fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint families are:

1. **Axis-aligned geometry.** Each existing leg moves in exactly one signed coordinate direction. Its bounds enclose its endpoints, and its component lengths agree with those bounds and the chosen direction.

2. **Route sequence.** Existing legs form a contiguous prefix. At least three legs exist, and exactly one is the last leg. Consecutive existing legs must use different coordinate axes, preventing both straight continuation and immediate reversal.

3. **Nozzle requirements.** The first leg has a prescribed direction and bounded length. The last existing leg has its own prescribed direction and length limits and reaches the fixed destination.

4. **Obstacle clearance.** A leg must be separated from an obstacle along at least one coordinate axis, using the supplied safety distance. Specific exceptions allow connection to the endpoint modules. Clearance is generally required even for zero-length trailing legs; the reformulation preserves this detail.

5. **Support requirements.** Intermediate node positions must belong to at least one permitted support region, including nodes associated with unused trailing legs. Preferred rack-level membership determines the support charge.

6. **Flexibility.** For each coordinate axis, the sum of cubes of leg lengths in the other two axes must exceed a coefficient times every individual length in those axes. The coefficients depend on the endpoint displacement, unit conversion, and supplied flexibility factor.

The source also contains inter-pipe clearance constraints, but they generate no restrictions in this single-pipe instance.

### Objective

The model minimizes the original scaled cost:
\[
61\,(\text{total route length})
+601\,(\text{number of existing legs after the first})
+\text{support charges}.
\]

An existing intermediate node costs 51 outside preferred rack levels and 1 inside a preferred level. These values follow from the source’s integer division by 100 followed by adding one; the reformulation preserves that convention exactly.

## 3. Reformulation and validity

### Signed-length linear formulation

Direction-dependent geometry was replaced by positive and negative length components, each controlled by a binary direction selector. Their difference gives the endpoint displacement, and their sum gives the component length. Exactly one signed direction is selected for an existing leg; none is selected for an unused leg.

This is equivalent to the original geometry. Originally, endpoint enclosure and the equation linking length to leg bounds imply that length is at least the absolute endpoint displacement. The selected-direction inequality supplies the reverse bound. Consequently, length equals the signed displacement on the selected axis, and the leg bounds are exactly the endpoint minimum and maximum, adjusted by pipe radius. On other axes, zero length forces equal endpoint coordinates.

The new equations express these consequences directly, avoiding multiple direction implications while retaining the original independent variables.

### Coordinate-specific length bounds

Each component length is bounded by the greatest possible displacement between its two endpoint domains. This bound is intersected with the original leg-length limit and, where applicable, nozzle limits. Components incompatible with a prescribed nozzle axis are fixed to zero.

These are valid domain reductions because the original constraints already make component length equal to absolute endpoint displacement. No additional geometric assumption is introduced.

### Exact reduction of the cubic flexibility constraints

The main nonlinear reformulation uses a threshold rather than representing every possible cube.

Let \(A\) be the largest flexibility coefficient and let
\[
T=\max(1,\lceil\sqrt{A}\rceil).
\]
For a nonnegative integer length \(l\), define a replacement contribution
\[
g(l)=
\begin{cases}
l^3,&l<T,\\
A\,l,&l\ge T.
\end{cases}
\]

The flexibility inequalities use sums of \(g(l)\) instead of sums of \(l^3\). This preserves their feasible set:

- **If all relevant lengths are below \(T\)**, every contribution is unchanged.
- **Otherwise**, let \(M\) be the largest relevant length. Since \(M\ge T\), \(M^2\ge A\). For any relevant length \(l\) and corresponding coefficient \(a\le A\),
  \[
  M^3\ge A M\ge a l.
  \]
  Thus the original inequalities already hold. The replacement contribution of the longest leg is \(g(M)=A M\), which also satisfies every such inequality.
- Moreover, \(g(l)\le l^3\) for every length, so the replacement cannot admit a violation of an original inequality.

Small integer lengths are represented by one-hot selectors with constant cubic coefficients. A separate selector and bounded integer length represent the long-length case. This produces an exact mixed-integer linear feasibility formulation suitable for HiGHS, without variable powers. The replacement contributions are internal quantities, not claims about the actual sums of cubes.

### Linear support-cost calculation

Products involving an existence flag and support membership were replaced by Boolean conjunction indicators. For binary quantities \(u\) and \(v\),
\[
uv=\mathbf{1}[u=1\land v=1].
\]
Distributing the original support-cost expression over its membership terms therefore preserves the charge exactly while avoiding general variable multiplication.

### Interface preservation

The original independent variables retain their names and meanings. The mapping script copies those variables from the reformulated solution, restores fixed endpoint coordinates from their original singleton domains when necessary, and excludes new auxiliary variables. Original arrays defined by expressions can be recomputed by the original model.

These changes target a more explicit and numerically smaller linear formulation. No runtime measurements were supplied, so improved solve time remains an intended benefit rather than a demonstrated result.

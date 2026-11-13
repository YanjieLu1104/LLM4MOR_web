# Pipe-Routing Model: Background and Reformulation

## 1. Real-world interpretation

The model represents the routing of a pipe through a three-dimensional industrial installation. It connects two fixed nozzle locations while avoiding equipment modules and existing pipe segments. Intermediate bends must lie in designated support regions, which include module support zones, a pipe rack, and preferred rack levels.

Coordinates are integer multiples of **200 mm**. The route contains ten node positions, allowing up to nine axis-aligned segments. Unused trailing segments have zero length, so the number of actual segments is a decision.

The model also imposes a cubic flexibility condition, apparently intended to approximate the ability of the pipe layout to accommodate displacement or thermal expansion. This is a constraint of the supplied mathematical model, rather than a full mechanical stress analysis.

## 2. Original formulation

### Variables and route geometry

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer segment-bound coordinates**, representing the lower and upper corners of segment bounding boxes.
- **30 nonnegative integer directional lengths**, three for each of ten segment slots.
- **10 direction variables**, taking values from zero through six: inactive, or positive/negative motion along one coordinate axis.
- **20 binary integer flags**, indicating segment existence and the last active segment.
- An integer objective variable, together with derived Boolean and arithmetic expressions for obstacle separation, support membership, costs, and flexibility.

The tenth segment slot is a dummy slot fixed to zero. The other nine slots connect successive nodes.

Constraints enforce an active prefix of at least three segments, exactly one last active segment, prescribed nozzle directions and nozzle-segment length bounds, and orthogonal consecutive active segments. Bounding-box and direction constraints together make every directional length equal to the corresponding absolute endpoint displacement.

### Obstacles and supports

Obstacle avoidance is expressed as a disjunction: a segment must be separated from an obstacle along at least one coordinate axis, including the specified clearance. Special exceptions allow the first segment to leave its source module and the last segment to enter its destination module.

The source also contains inter-pipe separation constraints. These have no nontrivial instances here because only one pipe is present.

Intermediate node positions must belong to at least one support zone. Importantly, this requirement also applies to intermediate positions associated with inactive trailing segments; the reformulation preserves it. Preferred rack-level membership determines support charges.

### Flexibility constraints

For each coordinate \(k\), let \(S_k\) contain all segment lengths in the other two coordinates. The original flexibility constraints have the form

\[
C_k\,\ell \leq \sum_{s\in S_k}s^3
\qquad \text{for every }\ell\in S_k.
\]

The coefficient \(C_k\) is computed from the fixed nozzle displacement, the supplied flexibility factor, and the unit conversion. For this instance, the coefficients are \(210\), \(21\), and \(1413\) for X, Y, and Z, respectively.

### Objective

The model **minimizes** pipe-length, bend, and support costs. It uses the original integer coefficient transformation—division by 100 followed by addition of one—rather than unscaled monetary costs. The reformulation preserves these coefficients and therefore preserves objective values.

## 3. Reformulation and validity

### Endpoint-based elimination of redundant flexibility constraints

For any coordinate, the sum of segment lengths is at least the absolute displacement between the fixed endpoints. This follows from the segment geometry and the triangle inequality.

The endpoints differ by 135 units in Z. With at most nine segments, at least one Z-direction segment length is therefore at least

\[
\left\lceil \frac{135}{9}\right\rceil=15.
\]

Both the X- and Y-flexibility sums include the Z-direction lengths. Let \(M\) be the largest length in the relevant sum. Then \(M\geq15\), and

\[
\sum_{s\in S_k}s^3\geq M^3.
\]

Because \(15^2=225\) exceeds both \(C_X=210\) and \(C_Y=21\),

\[
M^3\geq C_kM\geq C_k\ell
\]

for every relevant length \(\ell\). Thus these two families are implied by the original routing constraints and can be removed without excluding any feasible route.

### Exact capping and lookup-table reformulation of the remaining cubes

For the Z-flexibility constraints, the reformulation derives

\[
T=\left\lceil\sqrt{1413}\right\rceil=38
\]

and replaces each relevant length by \(t=\min(\ell,T)\) **only within the flexibility expressions**. Actual geometric lengths and objective costs are unchanged.

This transformation is exact:

- If all relevant lengths are below \(T\), the flexibility expressions are unchanged.
- Otherwise, their maximum \(M\) satisfies \(M\geq T\). The original constraints hold automatically because
  \[
  M^3\geq1413M\geq1413\ell.
  \]
  The capped constraints also hold automatically: their cubic sum includes \(T^3\), while every capped left-hand side is at most \(1413T\leq T^3\).

Consequently, both formulations accept exactly the same routes. Cubes of capped lengths are evaluated through a constant lookup table over \(0,\ldots,38\), replacing variable exponentiation with a small finite-domain representation suitable for HiGHS.

### Linearization of support costs

The original support-cost expression multiplies a segment-existence flag by a weighted sum of binary membership indicators.

The reformulation distributes this product and represents each binary product as a Boolean conjunction:

\[
ab=\operatorname{bool2int}(a=1\land b=1).
\]

This identity is exact for binary variables. The original membership constraints and coefficients remain intact, while the resulting expressions admit standard mixed-integer linear encodings.

### Valid linear strengthening

Two families of redundant linear constraints are added:

- **Endpoint-distance cuts:** total length in each coordinate must be at least the corresponding absolute endpoint displacement.
- **Segment-bound identities:**
  \[
  x^{\mathrm{lower}}_{\ell,k}+x^{\mathrm{upper}}_{\ell,k}
  =x_{\ell,k}+x_{\ell+1,k}.
  \]

The second identity follows because the original direction, length, and bounding-box constraints force the bounds to equal the endpoint minimum minus the radius and the endpoint maximum plus the radius. The radius terms cancel in their sum.

These constraints preserve integer feasibility and may strengthen the linear relaxation.

## 4. Preservation and expected benefit

The reformulation retains the fixed instance data, all original independent decision variables, obstacle exceptions, support requirements, optimization direction, and objective coefficients. The accompanying mapping script returns the original variables, reconstructs fixed endpoint coordinates from the unchanged data when needed, and excludes auxiliary variables.

The principal expected benefit is a smaller and more manageable representation of flexibility: two redundant constraint families are eliminated, and the remaining cubic expressions use a short exact lookup table. The additional linear constraints and support-cost linearization are intended to improve mixed-integer optimization. No measured runtime improvement is established by the supplied conversation.

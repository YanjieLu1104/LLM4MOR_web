# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Application and instance

The model represents the routing of an industrial pipe between two fixed nozzles in a three-dimensional environment containing equipment modules, existing pipe sections, support zones, and pipe racks. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The supplied instance contains one pipe represented by **10 ordered nodes and nine candidate legs**. The endpoints are fixed at \((79,41,5)\) and \((125,60,163)\). Intermediate nodes determine the route. Active legs must follow coordinate axes, and consecutive active legs must use different axes. The route can terminate before the final candidate leg; subsequent nodes then coincide with the destination.

Obstacle avoidance accounts for the pipe radius and box-specific safety clearances. Intermediate nodes must lie in support zones, evaluated at the pipe’s bottom in the vertical direction. Preferred rack levels offer lower support costs.

Although the input contains a flag indicating passage through a rack, its associated constraint is commented out in the original model. Consequently, rack passage is **not** a mandatory requirement. Likewise, the model does not prohibit intersections between different legs of this same pipe.

## 2. Original formulation

### Variables

The original model declares the following independent integer variables before presolve:

| Variable group | Number | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates per node; six endpoint coordinates are fixed |
| Leg-box coordinates | 60 | Lower and upper radius-expanded boundaries in each coordinate |
| Component lengths | 30 | Nonnegative length along each coordinate |
| Direction codes | 10 | Zero for an unused leg; six signed coordinate directions otherwise |
| Existence indicators | 10 | Whether a leg is active |
| Last-leg indicators | 10 | Whether a leg is the final active leg |
| Objective | 1 | Total scaled routing cost |

The leg arrays include a tenth, non-leg row that is constrained to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions; these are not independent decisions.

### Constraints

The principal constraint groups are:

- **Geometry and direction:** Leg boxes enclose both endpoints, expanded by the pipe radius. Their widths determine component lengths. Direction implications allow movement along only one signed coordinate axis.
- **Route sequence:** Active legs form a contiguous prefix, with exactly one last leg. The first three legs must exist.
- **Bends:** Consecutive active legs cannot use the same coordinate axis, including opposite directions.
- **Nozzles:** The first and last active legs have prescribed directions and nozzle-specific length bounds. The last active leg ends at the fixed destination.
- **Obstacle separation:** Each required leg–obstacle pair must be separated along at least one coordinate. The original model includes specific exemptions for the starting module and the destination module.
- **Supports:** Every intermediate node indexed by a candidate leg must belong to at least one support zone. Importantly, this requirement also applies to nodes associated with unused legs.
- **Optional physical constraints:** Inter-pipe separation and flexibility constraints are present in the source, but neither imposes an effective restriction in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model **minimizes** pipe-length cost, bend cost, and support cost. It uses the original integer scaling rule: divide each cost coefficient by 100 and add one.

For this instance, that gives:

- **141** per coordinate unit of pipe length;
- **1,401** per active leg after the first;
- **51** per charged support outside preferred rack levels, versus **1** within a preferred level.

The reformulation preserves these scaled values rather than substituting unscaled engineering costs.

## 3. Reformulation and validity

### Linear signed-displacement formulation

The main change replaces direction-dependent length implications with nonnegative positive and negative displacements, together with six binary direction selectors per leg.

For each leg and coordinate, the reformulation enforces
\[
x_{i+1,k}-x_{i,k}=p_{i,k}-m_{i,k},
\qquad
L_{i,k}=p_{i,k}+m_{i,k}.
\]
The sum of the six selectors equals the original existence indicator. Thus, an active leg selects exactly one signed direction, while an unused leg selects none. Selector-dependent lower and upper bounds activate only the corresponding displacement.

**Why this is equivalent:** In the original model, endpoint enclosure implies
\[
L_{i,k}\ge |x_{i+1,k}-x_{i,k}|.
\]
For a selected direction, its implication bounds the length above by the corresponding signed endpoint difference. These inequalities force equality. For every unselected coordinate, the original constraints force length zero and therefore equal endpoint coordinates.

This also forces the original leg boundaries to be the exact radius-expanded endpoint bounds. Consequently, they can be expressed linearly as
\[
B^-_{i,k}=x_{i,k}-m_{i,k}-r,
\qquad
B^+_{i,k}=x_{i,k}+p_{i,k}+r.
\]
The reformulation retains the original boundary variables and links them to these expressions.

### Bound-derived displacement limits

Positive and negative displacement limits are computed separately from the declared endpoint-coordinate bounds and the original maximum leg length. For example,
\[
p_{i,k}\le
\max\!\left(0,\min\!\left(U_L,\overline{x}_{i+1,k}-\underline{x}_{i,k}\right)\right).
\]

**Why valid:** A positive displacement cannot exceed the largest possible difference between its endpoint coordinates, nor the original component-length limit. The analogous argument applies to negative displacement.

This is **bound-based preprocessing**. It supplies tighter coefficients for the mixed-integer formulation without imposing a new geometric restriction.

### Direct obstacle-separation disjunctions

The intermediate Boolean array recording separation by coordinate is replaced by direct disjunctions of the original inequalities.

**Why valid:** The original array entries were defined expressions, not independent choices. Substituting their definitions into the “separated along some coordinate” constraint preserves exactly the same alternatives. The starting-module and destination-module exceptions remain intact, including the original treatment of unused legs.

### Linearization of support-cost products

Products between the binary existence indicator and support-membership indicators are replaced by Boolean conjunctions converted to integers.

**Why valid:** For binary quantities \(a\) and \(b\),
\[
ab=\operatorname{bool2int}(a=1\land b=1).
\]
Distributing the existence indicator across the original support-cost expression therefore preserves every cost contribution. The support-membership definitions and the domain restriction on the “not in a preferred level” indicator are retained.

### Removal of inactive instance-specific constraints

Two parts of the original formulation are inactive:

- **Inter-pipe separation:** Every node belongs to the same pipe. The original constraint generator requires different pipe identifiers, so it produces no relevant separation constraints.
- **Flexibility:** The supplied flexibility coefficient is zero. The original conditional definitions therefore yield zero flexibility sums and impose no flexibility inequalities.

Removing these inactive components is valid for the supplied data. The reformulation includes an assertion checking the single-pipe and inactive-flexibility conditions.

## 4. Interface and expected effect

All original independent variables are retained. The mapping script exports only those variables, preserving array encodings, and reconstructs omitted fixed endpoint coordinates from their unchanged singleton domains. It reports missing required solution fields rather than inventing values.

The reformulation targets HiGHS by replacing implication-heavy geometry with explicit linear displacement equations, binary direction selection, and bound-derived coefficients. It also simplifies support-cost products and removes intermediate or inactive expressions. These changes are intended to improve the generated mixed-integer formulation; **no measured runtime improvement is established by the conversation**.

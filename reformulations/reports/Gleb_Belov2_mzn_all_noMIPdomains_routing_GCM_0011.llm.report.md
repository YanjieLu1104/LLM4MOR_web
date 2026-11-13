# Pipe Routing with Clearance, Support, and Flexibility Constraints

## Background

The model represents the routing of a single industrial pipe between two fixed equipment connections, or *nozzles*, in a three-dimensional installation. Coordinates use discrete units of 200 mm. The route must avoid equipment and existing pipe segments, place intermediate nodes in permitted support regions, and satisfy a flexibility criterion based on sums of cubed leg lengths.

The instance provides 10 route nodes, allowing up to 9 axis-aligned legs. The endpoints are fixed at `(79, 41, 5)` and `(125, 60, 163)`. Fixed boxes describe equipment, existing pipes, equipment support zones, a pipe rack, and preferred rack levels.

Although the data include a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation therefore does **not** impose mandatory rack passage.

## Original Model

### Variables

The independently declared variables comprise **151 integer scalar entries**:

- **30 node coordinates**, including six fixed endpoint coordinates;
- **60 leg-boundary coordinates**, representing lower and upper corners of radius-expanded leg boxes;
- **30 coordinate-wise leg lengths**;
- **10 direction variables**, with zero denoting an inactive leg;
- **10 leg-existence flags** and **10 last-leg flags**;
- **One objective variable**.

The leg arrays contain 10 slots, but only the first nine connect consecutive nodes. The final slot is fixed to zero. Additional defined arrays express obstacle separation, support membership, support costs, and flexibility sums.

### Constraints

The principal constraint groups enforce:

- **Axis-aligned geometry:** an active leg moves along exactly one coordinate axis.
- **Route sequencing:** active legs form a consecutive prefix, at least three legs exist, and exactly one active leg is designated last.
- **Orthogonal bends:** consecutive active legs cannot use the same axis, excluding both straight continuation and immediate reversal.
- **Nozzle connections:** the first leg has a prescribed direction and length limits; the dynamically selected last leg has its own prescribed direction and length limits.
- **Obstacle clearance:** each relevant leg box must be separated from each obstacle along at least one axis, subject to the original nozzle-equipment exceptions.
- **Support membership:** intermediate node positions must belong to a support zone. Membership uses the node center horizontally and the pipe bottom vertically. These requirements also apply to intermediate slots after the active route ends.
- **Flexibility:** for each axis, the sum of cubed leg lengths along the other two axes must exceed a coefficient times each contributing leg length.

Inter-pipe separation is included in the general formulation, but generates no constraints for this one-pipe instance. The original model does not impose self-intersection avoidance.

### Objective

The model minimizes the sum of scaled pipe-length, bend, and support costs. The original integer scaling—including division by 100 and the subsequent `+1` terms—is retained exactly. Consequently, the length coefficient is 141 and the bend coefficient is 1,401; support costs depend on preferred-level membership.

## Reformulation and Its Justification

### 1. Direction-gated signed lengths

Each coordinate-wise length is split into nonnegative positive-direction and negative-direction components, controlled by binary direction indicators. Their difference equals the displacement between consecutive nodes, and their sum equals the original leg length.

This is equivalent to the original constraints: the leg-box containment inequalities require the length to be at least the absolute endpoint displacement, while the selected-direction inequality supplies the matching upper bound. Unselected axes have zero length and therefore zero displacement. The new formulation expresses these relationships directly as linear equations and bounded binary gates.

### 2. Exact linear equations for leg boundaries

The lower and upper leg boundaries are linked directly to endpoint coordinates and leg length. For a coordinate with endpoints \(x_i,x_{i+1}\), length \(L\), and radius \(r\),

\[
2B^- = x_i+x_{i+1}-L-2r,
\qquad
B^+ = B^-+L+2r.
\]

The original constraints imply \(L=|x_{i+1}-x_i|\), as explained above. Their containment and width conditions then force \(B^-=\min(x_i,x_{i+1})-r\) and \(B^+=\max(x_i,x_{i+1})+r\). Thus, these equations preserve—not tighten beyond—the original geometric meaning.

### 3. Bound preprocessing

Coordinate-wise length bounds are derived from endpoint coordinate domains and the original general and nozzle-specific length limits. An endpoint displacement cannot exceed the largest difference permitted by those domains. Prescribed nozzle axes also force the other coordinate lengths to zero.

These bounds strengthen the direction gates and subsequent product linearizations without excluding any original feasible route.

### 4. Exact mixed-integer representation of cubes

Variable powers are replaced by binary expansion. Writing an integer length as

\[
L=\sum_t 2^t b_t
\]

allows its square and cube to be constructed as

\[
Q=\sum_t 2^t(b_tL), \qquad
C=\sum_t 2^t(b_tQ).
\]

Each binary–bounded-variable product uses its standard exact linearization. For example, \(w=bx\), with \(b\in\{0,1\}\) and \(0\le x\le U\), is enforced by

\[
0\le w,\quad w\le Ub,\quad w\le x,\quad
w\ge x-U(1-b).
\]

Hence \(Q=L^2\) and \(C=L^3\) exactly at integer solutions. This is not a piecewise approximation: it preserves the flexibility constraints while expressing them in a form suitable for HiGHS.

### 5. Valid suffix-distance inequalities

For each node and coordinate, the remaining route length is constrained to be at least both signed differences between that node and the destination. These inequalities follow from the triangle inequality: the sum of absolute coordinate movements cannot be smaller than the absolute net displacement.

They are redundant for feasible integer routes but can strengthen the linear relaxation.

### 6. Simplification and solution mapping

Obstacle separation is expressed directly, rather than through the original intermediate separation arrays. Inter-pipe constraints have no eligible pairs because all nodes belong to the same pipe. Neither change removes a required separation condition.

Support cost is expressed conditionally on the binary existence flag, which is equivalent to multiplying the original cost expression by that flag.

The mapping script returns only the original independent variables. Their names and meanings are retained; fixed endpoint values can be restored from the original singleton domains, and the unchanged objective can be taken from the solver’s objective field if necessary.

## Expected Effect

The reformulation replaces nonlinear powers and implication-heavy geometry with explicit linear mixed-integer relationships, tighter bounds, and valid distance inequalities. These changes are intended to improve HiGHS compatibility and relaxation strength. No runtime comparison was supplied, so a measured speedup cannot be claimed.

# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Background and interpretation

The model represents the routing of a single industrial pipe between two fixed equipment connections, or **nozzles**, in a three-dimensional layout. Coordinates are integer multiples of a 200 mm length unit.

The route is described by ten ordered nodes, allowing up to nine straight, axis-aligned legs. Equipment modules and existing pipe sections are represented by rectangular obstacle boxes. Other boxes describe support zones, a pipe rack, and preferred rack levels.

A feasible route must:

- Respect obstacle-clearance requirements, including the modeled pipe radius.
- Follow specified directions and length limits at the two nozzles.
- Turn orthogonally between consecutive active legs.
- Place intermediate nodes in permissible support zones.
- Satisfy a cubic-length flexibility condition, apparently intended to represent piping flexibility requirements.

The objective balances pipe length, bends, and support costs. Although the input contains a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.

## 2. Original model structure

### Variables

The original model declares:

- **30 integer node coordinates**, six of which are fixed endpoint coordinates.
- **60 integer leg-envelope coordinates**, representing lower and upper corners in three dimensions.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, using zero for an inactive leg and six codes for signed coordinate directions.
- **10 binary existence flags** and **10 binary last-leg flags**.
- An integer objective variable.

The leg arrays include a tenth, non-leg entry that is constrained to zero. Additional defined variables represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

**Geometry and directions.** Each active leg moves along exactly one coordinate axis. Its envelope contains both endpoint nodes and extends by the modeled pipe radius. Direction-dependent inequalities connect displacement to length; together with the envelope constraints, they make component lengths equal to absolute coordinate displacements.

**Route sequencing.** Active legs form a prefix of the available leg sequence. Exactly one is designated the last leg, and at least the first three legs exist. Consecutive active legs cannot use the same axis. The first and last active legs obey nozzle-specific direction and length restrictions.

**Obstacle avoidance.** Each relevant leg–obstacle pair must be separated along at least one coordinate axis. Exceptions accommodate entry into and exit from the nozzle modules. These checks are preserved even where the original applies them to inactive, zero-length legs.

**Support requirements.** Intermediate node entries must lie in at least one support zone, using the pipe’s bottom elevation for the vertical membership test. Preferred rack-level membership affects support cost. The support requirement is not conditioned on leg existence in the original and remains unchanged.

**Flexibility.** For each coordinate axis, the model sums the cubes of lengths along the other two axes. That sum must exceed a coefficient times every individual orthogonal component length. The coefficient depends on endpoint separation, the length-unit conversion, and the supplied flexibility parameter.

The source also contains inter-pipe separation constraints, but they generate no restrictions for this single-pipe instance.

### Objective

The model **minimizes** scaled total cost. For this instance, the coefficients are:

- **141** per unit of pipe length.
- **1,401** per active leg after the first, representing bend cost.
- **51** per charged support outside preferred levels, or **1** within a preferred level.

These values include the original integer division by 100 and subsequent addition of one. The reformulation preserves this objective exactly.

## 3. Reformulation and validity

### Exact linear encoding of cubic lengths

Variable expressions \(L^3\) were replaced by binary selectors for admissible positive integer lengths. For each leg and axis, the formulation enforces

\[
\sum_v y_v=\mathbf{1}\{\text{leg uses this axis}\},
\qquad
L=\sum_v v\,y_v,
\]

and represents the cube as

\[
L^3=\sum_v v^3y_v.
\]

This is exact: an active axis selects exactly one length, while an inactive axis selects none and has length zero. Consequently, the flexibility constraints become linear expressions in binary variables rather than variable-power expressions. The trade-off is additional binary variables, but the formulation is directly suitable for HiGHS.

### Preprocessing admissible lengths

The selector domains exclude lengths ruled out by the original constraints:

- Positive lengths must satisfy the original general minimum leg length.
- Coordinate bounds limit the maximum possible endpoint displacement.
- The first leg and last possible leg have nozzle-specific maximum lengths and permitted axes.
- Non-leg entries have length zero.

These reductions follow from the original geometry: the envelope constraints imply that length is at least absolute displacement, while the selected direction imposes the reverse inequality. Thus length equals absolute displacement and cannot exceed the coordinate-derived bound.

The general minimum remains applicable to nozzle legs as well; the reformulation does not replace it with the smaller nozzle-specific minimum.

### Redundant envelope equalities

For each actual leg and axis, the reformulation adds

\[
2B^- = x_i+x_{i+1}-L-2r,
\qquad
2B^+ = x_i+x_{i+1}+L+2r.
\]

These equalities are implied by the original constraints. Since \(L=|x_{i+1}-x_i|\), the envelope-width equation leaves no room for extra extension beyond the endpoint minimum and maximum, apart from radius \(r\). The equalities therefore preserve feasible solutions while making the geometric relationship explicit in the linear relaxation.

### Endpoint-distance inequalities

For each coordinate axis, total component length is constrained to be at least the absolute endpoint separation:

\[
\sum_i L_{i,k}\geq |x_{\mathrm{end},k}-x_{\mathrm{start},k}|.
\]

This follows from the triangle inequality applied to consecutive node displacements. The displacements telescope to the fixed endpoint difference, and each component length equals the corresponding absolute displacement.

### Quadratic-moment flexibility cuts

Let \(C\) be an original flexibility coefficient and \(L_j\) the relevant orthogonal component lengths. The original inequalities imply

\[
C L_j\leq \sum_t L_t^3
\quad\text{for every }j.
\]

If \(M=\max_j L_j>0\), then

\[
CM\leq\sum_j L_j^3\leq M\sum_j L_j^2,
\]

so

\[
\sum_j L_j^2\geq C.
\]

The reformulation adds this valid inequality only when fixed endpoint separation guarantees that at least one orthogonal component is positive. Squared lengths are expressed exactly using the same selectors, so the added cut is linear in the reformulated variables.

### Conditional support costs and solution mapping

The product of a binary existence flag and a support-cost expression was replaced by a conditional expression: charge the cost if the leg exists, otherwise charge zero. This is equivalent because the existence variable has domain \(\{0,1\}\).

All original independent variables remain in the model. The supplied mapping script copies those variables, restores omitted fixed endpoint coordinates from the unchanged embedded data, and excludes reformulation-specific selectors. It reports missing required solution fields rather than inventing values.

## 4. Expected effect and limitations

The principal change is an exact mixed-integer linear representation of the cubic flexibility terms, supplemented by bound preprocessing and valid relaxation-strengthening inequalities. Original data, clearance exceptions, support requirements, objective values, and minimization direction are preserved.

These changes are intended to improve compatibility and relaxation strength for HiGHS. No measured solve-time improvement is established by the supplied conversation.

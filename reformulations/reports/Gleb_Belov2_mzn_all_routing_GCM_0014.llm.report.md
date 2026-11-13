## Background and application

The model represents **three-dimensional industrial pipe routing** between two fixed equipment nozzles. The pipe is represented by a sequence of axis-aligned straight legs, with bends at intermediate nodes. Coordinates are integer multiples of a 200 mm length unit.

Fixed boxes describe equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. A feasible route must respect obstacle clearances, prescribed nozzle directions and connection lengths, and support requirements. Additional cubic inequalities model pipe flexibility, apparently using a guided-cantilever-style approximation; they are not a full mechanical stress analysis.

The supplied instance contains one pipe, ten node positions, and nine possible connecting legs. The first and last node positions are fixed. Although the input includes a flag requesting passage through a rack, the corresponding constraint is commented out in the original model and is therefore not enforced in the reformulation.

## Original model structure

### Variables

The original model declares:

- **30 integer coordinate variables**, including six fixed endpoint coordinates.
- Two arrays of leg-box boundaries, each with **30 integer entries**.
- **30 nonnegative integer component lengths**.
- **10 integer direction variables**, encoding inactivity or one of six signed coordinate directions.
- Two arrays of **10 binary integer flags**, indicating whether a leg exists and whether it is the final active leg.
- An integer objective variable.

These leg arrays include a final non-leg position, whose entries are fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

1. **Leg geometry and direction.** Each active leg follows exactly one coordinate axis. Its bounding box includes the pipe radius, and its component lengths agree with endpoint displacement.
2. **Route sequence.** Active legs form a prefix of the available sequence. Exactly one is marked as the last leg, and the first three legs must exist.
3. **Nozzle connections and bends.** The first and final active legs have prescribed directions and length bounds. Consecutive active legs cannot use the same axis.
4. **Obstacle clearance.** Leg boxes must be separated from equipment and existing-pipe boxes along at least one coordinate. Specific exceptions permit connection to the endpoint modules.
5. **Support.** Intermediate node positions must lie in an allowed support zone. These requirements also apply to intermediate node slots after route termination, as in the original model.
6. **Flexibility.** For each coordinate direction, sums of cubed leg lengths in the other two directions must dominate specified multiples of individual lengths.

The source also includes separation constraints between different routed pipes. Their index set is empty for this single-pipe instance.

### Objective

The model minimizes the sum of:

- Pipe length cost;
- A charge for each existing leg after the first;
- Support costs at corresponding nodes.

The original integer coefficient transformation—division by 100 followed by addition of one—is preserved. Consequently, the objective remains the model’s scaled discrete cost, rather than an unmodified monetary total.

## Reformulation and validity

### 1. Direction-disaggregated linear geometry

The reformulation introduces six binary direction indicators per leg and nonnegative positive- and negative-direction component lengths. Their sum determines leg existence, while their weighted sum reproduces the original direction code.

For each coordinate, endpoint displacement becomes the positive length minus the negative length. The leg-box boundaries are then expressed directly using these lengths and the pipe radius.

This is an exact reformulation. In the original model, box containment and the box-width equation imply that component length is at least the absolute endpoint displacement. The selected-direction implication provides the matching upper bound; unselected components are forced to zero. Thus, the original constraints already force the exact geometry now expressed by linear equations. Direction-dependent lower bounds and nozzle restrictions remain enforced.

### 2. Geometry-based length bounds

Component upper bounds are derived from endpoint coordinate domains and the existing general or nozzle-specific length limits. Components incompatible with a fixed nozzle axis receive an upper bound of zero.

These bounds are valid because the geometric constraints make each component length equal to the absolute displacement of its endpoints. Such displacement cannot exceed the greatest difference permitted by their coordinate domains. At most one component is nonzero, so the maximum component bound also bounds total leg length.

### 3. Exact binary-prefix representation of cubes

Variable cubic expressions are replaced by a bounded binary-prefix construction. If a prefix has value \(p\) and the next binary digit is \(b\), the construction uses
\[
(2p+b)^2=4p^2+4pb+b,
\qquad
(2p+b)^3=8p^3+12p^2b+6pb+b.
\]

Products involving a binary digit are represented by standard exact bounded-product linearizations. Prefix bounds follow from the upper bound on the completed leg length.

Only one cube is constructed per leg. This is sufficient because the direction constraints permit at most one nonzero component. Direction-controlled linear constraints assign that cube to the selected axis and force the other axis cubes to zero. The original flexibility inequalities are then imposed using these exact component cubes.

This avoids nonlinear decision-variable powers without approximating the flexibility requirements.

### 4. Valid strengthening inequalities

The formulation adds inequalities such as
\[
x^3 \le U^2x
\]
for a component length bounded by \(0\le x\le U\). It also uses
\[
x^3 \ge L^2x
\]
when the original direction constraints require \(x=0\) or \(x\ge L\).

Both follow directly by multiplying the relevant squared-length bound by nonnegative \(x\). Substituting the upper bounds into the right-hand sides of the flexibility inequalities gives additional necessary linear inequalities. These strengthen the mixed-integer relaxation without excluding feasible original routes.

### 5. Bound-based obstacle preprocessing

An obstacle test is omitted only when endpoint coordinate bounds prove separation along an axis for every possible leg position, including pipe radius and safety clearance.

This is valid because the exact leg box extends between its endpoint coordinates, enlarged by the radius. If its largest possible upper boundary is already below an obstacle’s clearance boundary—or its smallest possible lower boundary is already above it—the original separation disjunction is necessarily true.

All other obstacle tests and connection exceptions remain enforced.

### 6. Linear support-cost representation and solution mapping

Products of leg-existence flags with support-class indicators are rewritten as Boolean conjunctions multiplied by constant costs. This is exact because the participating indicators are binary; the original preferred-level membership restrictions are retained.

The mapping script returns only original independent variables, preserving array index encodings. Fixed endpoint values can be restored from their original singleton domains if omitted from solver output. The unchanged objective is taken from the emitted objective variable or the solution’s objective field.

## Expected computational effect

The reformulation targets HiGHS by exposing linear geometry, supplying tighter bounds, removing provably redundant obstacle tests, and replacing cubic expressions with an exact mixed-integer linear construction. These changes are intended to improve compilation and solution performance. No measured runtime improvement or optimality result was established in the conversation.

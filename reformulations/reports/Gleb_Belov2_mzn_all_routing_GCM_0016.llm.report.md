# Pipe Routing with Clearance, Support, and Flexibility Requirements

## 1. Real-world background

The model represents the routing of a pipe between two fixed connection points in a three-dimensional industrial installation. The pipe follows straight, axis-aligned segments joined by right-angle bends. Coordinates use a discretization unit of **200 mm**.

The installation is described by fixed rectangular boxes representing equipment modules, existing pipe segments, module support zones, a pipe rack, and preferred rack support levels. The routed pipe must maintain specified clearances from obstacles, and intermediate nodes must lie in permitted support zones.

The model also includes a flexibility requirement based on pipe-segment lengths and endpoint separation. Its structure suggests an engineering approximation for accommodating displacement or thermal expansion; the precise physical derivation is not supplied.

Although the input contains a flag indicating routing through a rack, the corresponding constraint is commented out in the original model. Rack traversal is therefore **not** a requirement of the optimization problem.

## 2. Original model structure

### Variables

The instance contains one pipe with ten node positions and nine possible connecting legs.

- **30 integer coordinate variables:** six endpoint coordinates are fixed, while the remaining 24 describe eight intermediate nodes.
- **Leg bounding boxes:** two three-dimensional arrays describe the lower and upper corners of each leg’s radius-expanded box.
- **Leg lengths:** three nonnegative integer components per leg.
- **Direction variables:** values distinguish an inactive leg from movement in either direction along each coordinate axis.
- **Existence and last-leg indicators:** binary variables determine the active prefix of the route and its final segment.
- **An integer objective variable.**

The leg arrays have ten slots; the final slot is a dummy whose variables are fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint groups are:

1. **Route geometry.** Each active leg moves along exactly one coordinate axis. Lengths, endpoint coordinates, and expanded bounding boxes are linked. Consecutive active legs must use different axes.

2. **Route sequencing.** At least the first three legs exist. Active legs form a consecutive prefix, with exactly one designated final leg. Inactive trailing legs have zero length.

3. **Nozzle connections.** The first and final active legs satisfy prescribed directions and length bounds. The final active leg terminates at the fixed destination.

4. **Obstacle clearance.** A leg and an obstacle must be separated along at least one axis, accounting for pipe radius and safety distance. Specific exceptions permit connection to the endpoint modules.

5. **Support membership.** Intermediate node slots must belong to at least one support zone. Importantly, this requirement is not conditional on leg existence. Membership uses the pipe center horizontally and the pipe’s bottom vertically.

6. **Flexibility.** For each coordinate axis, sums of cubed segment lengths in the other two axes must dominate specified multiples of individual orthogonal segment lengths.

The source also contains inter-pipe separation constraints. They impose no restrictions in this single-pipe instance because their index condition requires different pipes.

### Objective

The model **minimizes** the sum of:

- pipe-length costs;
- charges for active legs after the first, representing bend costs;
- support costs at the associated nodes.

The original objective uses integer-divided cost coefficients with an added unit. These coefficients—not an unscaled physical-cost interpretation—define the objective that the reformulation must preserve.

## 3. Reformulation techniques and their justification

### Geometric preprocessing of length domains

A leg’s component length equals the absolute difference between its endpoint coordinates.

This follows from the original constraints: the expanded bounding box makes the length at least the absolute endpoint displacement, while the selected direction imposes the matching upper bound. For an unselected axis, the length is zero, which also forces equal endpoint coordinates.

Consequently, each component can be bounded by the largest displacement permitted by its two endpoint domains. These bounds are intersected with the original general length limits and the tighter first- and last-position nozzle restrictions.

The allowed length set is further restricted to zero or a value at least the original minimum active-leg length. This is valid because the original direction implications already prohibit positive lengths below that minimum. Dummy slots and prohibited nozzle axes admit only zero.

### Exact linear representation of cubic terms

Variable powers are replaced by a mixed-integer linear representation suitable for HiGHS.

For each length component, nonnegative continuous weights sum to one over its allowed integer lengths. Binary variables encode the selected length: for each binary digit, the total weight on values having that digit equal to one must equal the corresponding binary variable.

This representation is exact. A binary digit fixed to zero excludes all values having that digit equal to one; a digit fixed to one excludes all values having it equal to zero. Because distinct allowed integers have distinct binary encodings, only one length can retain positive weight. Its weight must therefore equal one.

The length and its cube are then weighted sums of fixed constants. Thus the original cubic flexibility constraints are preserved without variable exponentiation. This is a logarithmic binary encoding of a finite discrete function, rather than a piecewise-linear approximation.

### Linearization of support costs

The original support-cost formula multiplies a binary leg-existence indicator by a sum of membership-dependent charges.

The reformulation distributes that product and expresses each binary product as a Boolean conjunction. This is valid because leg existence, preferred-level membership, and the “not in a preferred level” indicator are all binary. The original restriction on the latter indicator is retained, including its implication that a relevant node cannot simultaneously belong to multiple preferred levels.

### Remaining-distance inequalities

Additional inequalities require the sum of remaining component lengths to be at least both signs of the displacement from the current node to the destination.

These inequalities follow directly from the triangle inequality: every component length equals the absolute displacement across its leg, and the signed displacements telescope to the remaining endpoint displacement. They therefore exclude no original feasible route but can strengthen the linear relaxation.

### Solution interface

A Python mapping script was added to return only the original independent variables. It copies retained variables, restores fixed endpoint coordinates from the self-contained instance when necessary, and obtains the objective variable from either its emitted value or the supplied objective field. Auxiliary encoding variables are excluded.

## 4. Validation caveat

The intended transformations above are semantics-preserving, but the last supplied model contains an unintended data transcription discrepancy: **`nBoxType[79]` and `nBoxType[80]` are written as `2, 2`, whereas the original values are `1, 3`.** These entries must be restored before the final artifact can be regarded as equivalent. In particular, changing a support zone to an obstacle changes feasibility; it is not a valid preprocessing step.

No solver timings or successful end-to-end verification were supplied. The formulation is designed to improve compatibility with mixed-integer linear optimization and strengthen bounds, but an actual runtime improvement has not been established.

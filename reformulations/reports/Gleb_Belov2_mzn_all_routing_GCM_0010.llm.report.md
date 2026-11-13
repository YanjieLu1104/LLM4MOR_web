# Orthogonal Pipe Routing with Support and Flexibility Requirements

## 1. Application and instance

The model represents the routing of an industrial pipe between two fixed nozzles in a three-dimensional environment. The route must avoid equipment modules and existing pipe segments, maintain specified clearances, and place bends within suitable support zones.

This instance contains one pipe, ten ordered route nodes, and nine potential connecting legs. The first and last nodes are fixed; intermediate nodes have bounded integer coordinates. Each coordinate unit represents 200 mm. The environment contains 124 boxes describing obstacles, support zones, a pipe rack, and preferred rack support levels.

Each nonzero leg is parallel to a coordinate axis. Consecutive nonzero legs must be perpendicular. Unused legs form a trailing sequence of zero-length segments, allowing the model to choose how many of the available legs are needed.

The model also imposes a flexibility condition involving cubed leg lengths. From its comments and coefficients, this appears to approximate a piping flexibility or thermal-expansion requirement; it is not a full mechanical stress analysis.

## 2. Original formulation

### Variables

The original independent decision variables comprise:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 leg-bound coordinates**, describing the lower and upper corners of radius-expanded leg boxes.
- **30 nonnegative component lengths**, one per coordinate and leg-array position.
- **10 direction variables**, with zero denoting an unused leg and six values denoting signed coordinate directions.
- **20 binary integer flags**, identifying existing and final legs.
- **One objective variable**.

The leg arrays have ten positions, although only nine connect consecutive nodes. The remaining position is explicitly fixed to zero.

Additional defined arrays express obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint groups are:

1. **Leg geometry and directions.**  
   Leg boxes contain both endpoints, expanded by the pipe radius. Their dimensions determine component lengths. Direction implications force motion along exactly one axis for an existing leg and zero displacement for an unused leg.

2. **Route sequence and nozzle connections.**  
   The first three legs must exist. Exactly one leg is final, and the existence recurrence forces all later legs to be unused. The first and final legs have prescribed nozzle directions and length restrictions.

3. **Orthogonality.**  
   Adjacent legs cannot use the same coordinate axis, preventing both straight continuation and immediate reversal.

4. **Obstacle avoidance.**  
   A leg must be separated from each applicable obstacle along at least one coordinate, accounting for safety clearance. Specific exceptions permit connection to the endpoint modules.

5. **Support requirements.**  
   Each intermediate node must lie in a support zone. Horizontal membership uses the node center; vertical membership uses the bottom of the pipe. These requirements also apply to intermediate nodes associated with unused legs.

6. **Flexibility.**  
   For each coordinate, a coefficient derived from nozzle separation and pipe data multiplies each orthogonal component length. The result must not exceed the sum of cubed lengths in the other two coordinates.

The source also defines inter-pipe separation constraints, but they generate no restrictions in this single-pipe instance. Its optional rack-traversal constraint is commented out and therefore is not part of the problem.

### Objective

The model minimizes scaled pipe-length, bend, and support costs. For this instance:

- Each length unit costs **141**.
- Each existing leg after the first incurs **1,401** in bend cost.
- Each applicable existing bend incurs support cost **51** outside preferred rack levels and **1** within a preferred level.

These coefficients include the original integer division and subsequent addition of one.

## 3. Reformulation and validity

### Exact linear direction and geometry formulation

The reformulation introduces one-hot direction indicators and nonnegative positive and negative displacement variables for each leg component. Their difference equals endpoint displacement, and their sum equals component length.

This is equivalent to the original geometry. Originally, endpoint containment implies that a component length is at least the absolute endpoint displacement. For the selected direction, another constraint bounds that length above by the corresponding signed displacement. Together, these inequalities force equality. Unselected components have zero length and therefore zero displacement.

Consequently, the radius-expanded leg bounds can be expressed directly through the start coordinate and signed displacement. The original leg-bound variables are retained and linked to these expressions.

### Exact finite-domain representation of cubes

Variable powers are replaced by binary selections over admissible positive integer lengths. For each leg component:

- The selection sum equals its axis-activity indicator.
- The selected value determines its length.
- The same selection determines its cube through constant cubic coefficients.

This is exact because original lengths are integers. An active component is at least the original minimum leg length; an inactive component is zero. Every admissible positive value remains represented, so the flexibility constraints are neither approximated nor relaxed.

This converts the nonlinear power expressions into linear sums suitable for HiGHS, at the cost of introducing additional binary variables.

### Bound-based preprocessing

The candidate length ranges are bounded by:

- The original leg-length upper bound.
- The maximum possible endpoint separation along the relevant coordinate.
- The applicable first- or last-possible-leg nozzle restrictions.

These bounds are valid because the original constraints make component length equal to absolute endpoint displacement. No feasible length can exceed the separation permitted by the endpoint coordinate domains.

An obstacle check is omitted only when coordinate bounds prove that its separation disjunction is always satisfied. Specifically, if every possible leg box lies entirely on one side of the obstacle along some coordinate, that coordinate already guarantees clearance.

The reformulation preserves obstacle checks on unused legs wherever the original model requires them; it does not assume that unused legs are exempt.

### Linearization of support costs

The product of leg existence and support-category membership is replaced by Boolean conjunctions with constant cost coefficients.

This follows directly from the original definitions: existence and category membership are binary, so their product equals the indicator that both are true. The original preferred-level membership sum and its binary-domain restriction are retained, preserving the treatment of overlapping membership.

### Valid direction-coverage cuts

For each nonzero endpoint displacement, the reformulation requires at least one leg traveling in the corresponding signed direction.

To see why this is valid, sum the signed leg-displacement equations along the route. Intermediate coordinates cancel, leaving the fixed endpoint displacement. A positive total displacement cannot arise without at least one positive leg component; the analogous statement holds for negative displacement.

These inequalities make an implication of the geometry explicit and may strengthen the mixed-integer relaxation.

### Data and solution interface

A transcription error in the box-size array was repaired by restoring the original entries, giving three dimensions for each of the 124 boxes.

All original independent decision variables remain in the reformulated model. The mapping script returns only those variables, preserves encoded array indices, and reconstructs omitted fixed endpoint values from their original singleton domains. It can also obtain the objective variable from the solver’s objective field.

## 4. Expected computational effect

The resulting formulation replaces variable powers and variable products with an exact mixed-integer linear representation. Explicit geometry equations, tighter length domains, redundant-check removal, and direction-coverage cuts are intended to improve compilation and optimization with HiGHS.

The finite-domain cube representation introduces many binary variables, so the net runtime benefit is instance-dependent. No measured speedup or optimality result was established in the conversation.

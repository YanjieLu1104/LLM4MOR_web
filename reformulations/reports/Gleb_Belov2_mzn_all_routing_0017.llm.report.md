# Orthogonal Pipe Routing with Obstacles and Support Zones

## Problem background

The model represents the routing of a pipe through a three-dimensional industrial layout. The layout contains equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The supplied instance contains one pipe with fixed inlet and outlet coordinates and ten ordered node positions. Nine potential straight legs connect consecutive nodes. The model chooses the intermediate coordinates and the number of active legs, subject to prescribed nozzle directions, allowable leg lengths, obstacle clearance, and support availability.

The routing objective balances pipe length, bends, and supports. Two features suggested by the input are **not active constraints in this instance**: the rack-traversal requirement is commented out, and the flexibility coefficient is zero. The reformulation does not activate either feature.

## Original model structure

### Variables

The original model declares:

- **30 integer coordinate variables**, of which six endpoint coordinates are fixed and 24 intermediate coordinates are unfixed.
- Two leg-bounding-box arrays, each containing **30 integer entries**.
- A leg-length array containing **30 nonnegative integer entries**.
- **10 direction variables**, taking values from zero to six.
- **10 binary-valued existence variables** and **10 binary-valued last-leg variables**.
- An integer objective variable.

The leg arrays include a tenth, nonactual leg position, which is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions. These are derived quantities rather than additional independent routing decisions.

### Constraints

The main constraint groups are:

1. **Orthogonal geometry.** Each active leg moves along exactly one coordinate axis. Its direction determines the sign of movement. Consecutive active legs cannot use the same axis, preventing both straight continuation and immediate reversal.

2. **Active-leg sequencing.** Active legs form a contiguous prefix of the nine potential legs. The first three legs must exist, and exactly one active leg is designated as the last leg. Subsequent zero-length legs repeat the outlet position.

3. **Nozzle conditions.** The first leg has a prescribed direction and length bounds. The last active leg has the prescribed incoming outlet direction and its own length bounds. The general minimum active-leg length also applies.

4. **Obstacle avoidance.** Radius-expanded leg boxes must be separated from equipment and existing-pipe boxes along at least one axis, including the specified safety distance. The model provides particular exceptions for the inlet module and for the last or inactive legs at the outlet module.

5. **Support coverage and classification.** Intermediate node positions must belong to a support zone. Membership uses the node center horizontally and the pipe bottom vertically. This coverage requirement also applies to intermediate positions associated with inactive legs. Preferred rack levels determine support costs.

The source also includes inter-pipe separation constraints, but their index set is empty because this instance contains only one pipe.

### Objective

The model minimizes the original scaled construction-cost expression. With the supplied data, its coefficients are:

- **131** per coordinate unit of pipe length;
- **1,301** per active leg after the first, representing bend cost;
- **51** for an active bend outside preferred rack levels, or **1** within a preferred level.

These coefficients include the original integer division and subsequent addition of one. They are preserved exactly rather than replaced with unscaled monetary costs.

## Reformulation and validity

### 1. Signed-displacement formulation

The reformulation introduces positive- and negative-direction indicators and corresponding nonnegative displacement variables for each leg and coordinate. Their sum gives the coordinate-wise leg length, and their difference gives the change in node position. A one-hot constraint permits exactly one signed direction for an active leg and none for an inactive leg.

This is equivalent to the original geometry. Originally, the endpoint-enclosure constraints imply that a leg’s coordinate-wise length is at least the absolute endpoint displacement. The direction constraints impose the matching upper bound on the selected axis and force zero length on the other axes. Together, these constraints already make lengths and bounding boxes exact.

The new linear equations express these consequences directly. Indicator-dependent displacement bounds also strengthen the connection between direction choices and geometry in the mixed-integer relaxation.

### 2. Bound-based geometric preprocessing

Displacement bounds are derived from the original coordinate domains and applicable leg-length limits. Exact bounding-box geometry additionally gives tighter bounds: for example, the minimum endpoint coordinate cannot exceed the smaller of the two endpoint upper bounds.

These bounds are used to simplify obstacle constraints:

- A separation alternative is removed if no endpoint configuration within the declared domains can satisfy it.
- An entire obstacle constraint is omitted if an axis guarantees separation for every configuration within those domains.

Both reductions are valid because they use necessary bounds on the exact leg boxes. They do not rely on a guessed route or an assumed objective cutoff. The original module exceptions remain intact.

### 3. Support-zone containment preprocessing

The support-coverage disjunction retains only zones not contained in another retained candidate zone, with deterministic tie-breaking for identical boxes.

This reduction preserves coverage: a node belonging to a contained zone necessarily belongs to its containing zone. The pipe-bottom adjustment is identical for both zones, so containment of the original boxes also implies containment of their node-membership regions.

Importantly, this reduction applies **only to the coverage disjunction**. Preferred-level membership remains available for cost classification; deleting those memberships could change the objective.

### 4. Boolean linearization of support costs

The original support-cost expression multiplies a leg-existence variable by a membership-dependent integer cost. The reformulation replaces that product with weighted Boolean conjunctions, such as “the leg exists and the node is outside preferred levels.”

This is exact because existence, nonpreferred status, and membership indicators are binary-valued. For binary values, multiplication equals the indicator of logical conjunction. The original nonpreferred-status definition and its domain are retained.

### 5. Mandatory-nozzle directional-flow cuts

For each coordinate and movement sign, the reformulation adds a lower bound on total displacement contributed by mandatory nozzle legs.

These inequalities follow from existing constraints: the first leg must exist, exactly one distinct last leg must exist, both have prescribed directions, and each must satisfy both its nozzle minimum and the general active-leg minimum. Their required signed lengths therefore provide valid lower bounds on aggregate signed travel. The cuts strengthen the relaxation without excluding feasible routes.

### 6. Inactive flexibility expressions and solution mapping

The flexibility sums are fixed to zero because the supplied coefficient is zero. In the original model, this makes every summand zero and every flexibility constraint trivially true.

All original independent variables remain in the reformulated model. The accompanying mapping script returns only those variables, preserves array index encodings, and restores omitted fixed endpoint coordinates from their original singleton domains. Missing nonfixed solution values produce an explicit error rather than an invented assignment.

## Expected effect and limitations

The reformulation targets stronger linear geometry, fewer obstacle alternatives, simpler support coverage, and linear support-cost expressions. It preserves the fixed instance data, original objective values, minimization direction, and routing constraints.

These changes are intended to improve performance with the HiGHS backend, but **no measured speedup or successful compilation result was established in the conversation**.

# Industrial Pipe Routing: Model and Reformulation

## 1. Real-world background

The model describes routing a pipe through a three-dimensional industrial installation. The pipe connects two fixed nozzle locations, while intermediate routing points can move on an integer coordinate grid. The specified grid unit is **200 mm**.

The installation contains rectangular boxes representing equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. The route must avoid physical obstacles, respect clearance requirements, and place intermediate nodes within permitted support zones. Additional flexibility constraints relate pipe-leg lengths to nozzle separation and a supplied pipe-specific coefficient.

This instance contains **one pipe, 10 nodes, and nine candidate legs**. The route may use fewer than nine legs: unused trailing legs have zero length and their nodes coincide with the destination. The supplied rack-traversal flag does not impose a requirement because the corresponding constraint is commented out in the original model; the reformulation preserves that behavior.

## 2. Original model structure

### Variables

The original model declares **151 independent integer scalar entries**:

- **30 node coordinates**, including six fixed endpoint coordinates;
- **60 leg-box coordinates**, representing lower and upper corners in three dimensions;
- **30 nonnegative directional leg lengths**;
- **10 direction codes**;
- **10 binary-valued existence flags**;
- **10 binary-valued last-leg flags**;
- **one objective variable**.

The leg arrays include a tenth, dummy entry that is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

- **Axis-aligned geometry.** Each existing leg travels along exactly one coordinate axis. Its bounding box includes the pipe radius, and its directional length equals the corresponding endpoint displacement.
- **Route sequencing.** Existing legs form a contiguous prefix. Exactly one is marked as the last leg, and at least the first three legs exist. Consecutive existing legs must use different axes.
- **Nozzle connections.** The first and last existing legs have prescribed directions and nozzle-specific length bounds. The last existing leg ends at the fixed destination.
- **Obstacle clearance.** A leg and an obstacle must be separated along at least one axis, including the specified safety distance. The original nozzle-module exceptions are retained.
- **Support requirements.** Intermediate nodes must lie in at least one support zone. Membership uses the node center horizontally and the pipe bottom vertically. This requirement also applies to intermediate nodes associated with unused trailing legs.
- **Flexibility.** For each coordinate axis, the sum of cubes of leg lengths in the other two axes must exceed a specified coefficient times each relevant leg length.

The original general-purpose inter-pipe separation constraints are vacuous in this instance because only one pipe is present.

### Objective

The model **minimizes** the sum of pipe-length, bend, and support costs. After the original integer scaling:

- each unit of pipe length costs **181**;
- each existing leg after the first incurs **1,801** in bend cost;
- its associated support cost is **51** outside preferred levels and **1** inside a preferred level.

The reformulation preserves these coefficients exactly, including the original “divide, then add one” convention.

## 3. Reformulation and justification

### Linear signed-displacement geometry

Each leg-axis pair now has positive- and negative-direction indicators and corresponding nonnegative displacement variables. Their sum gives the directional length, while their difference gives the endpoint displacement. At most one signed direction is active for an existing leg.

This is equivalent to the original geometry. Originally, the bounding-box inequalities and length equation imply that each directional length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality, forcing equality. For unselected axes, the original model forces zero length, which also forces equal endpoint coordinates. Therefore, the box corners are exactly the smaller endpoint minus the radius and the larger endpoint plus the radius. The new linear equations express these same relationships directly.

### Coordinate-domain and nozzle-bound preprocessing

Upper bounds on directional lengths are derived from the largest possible endpoint separation allowed by the coordinate domains. They are intersected with the original leg-length bounds and, where applicable, nozzle bounds.

These bounds are valid because the geometry already forces length to equal absolute displacement. No feasible leg can exceed the maximum separation of its endpoints. The first leg’s prescribed direction fixes its other two directional lengths to zero; the last candidate leg is likewise restricted by its original direction and nozzle bounds.

### Exact finite-domain representation of cubes

Variable powers are replaced by a discrete length-selection formulation:

1. An existing leg selects exactly one integer length.
2. An absent leg selects none.
3. Its cube is a linear weighted sum of the selected length’s precomputed cube.
4. That cube is assigned to the leg’s active axis through bounded linear constraints.

This is **exact**, not a piecewise approximation. The original direction constraints make every existing leg axis-aligned and impose the global minimum length of six. Thus its total length equals its single nonzero directional length, and values below six cannot occur for an existing leg. The tightened upper bounds cover every remaining feasible length. For an absent leg, all lengths and cubes are zero.

This formulation makes the flexibility constraints directly representable as a mixed-integer linear model for HiGHS.

### Boolean reformulation of support-cost products

Products of an existence flag and a support-membership indicator are replaced by Boolean conjunctions.

This preserves their values because the original existence flags and preferred-level membership expressions are binary. For binary quantities, multiplication equals logical conjunction after conversion to an integer. The original restriction on preferred-level membership is retained through the domain of `fNodeNotInPref`.

### Endpoint-distance inequalities

For each axis, the reformulation adds a lower bound stating that the sum of directional leg lengths is at least the absolute separation of the two fixed endpoints.

These inequalities follow from the triangle inequality: signed leg displacements telescope to the endpoint displacement, and the sum of their absolute values cannot be smaller than the absolute total. They exclude no original feasible route and may strengthen the linear relaxation.

### Solution interface and scope

All original independent variables remain in the model. The mapping script returns only those variables, preserves array index information, and supplies omitted fixed endpoint values from the unchanged embedded data.

The changes target a more explicit MILP formulation and stronger bounds. **No measured runtime improvement is established by the conversation.**

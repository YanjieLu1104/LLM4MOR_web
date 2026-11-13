# Pipe-Routing Model and Reformulation

## Real-world interpretation

The model describes the routing of a single pipe between two fixed connection points in a three-dimensional industrial layout. Coordinates use a discretization unit of 200 mm. The layout contains equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels.

The new pipe follows an axis-aligned polyline. Its route must respect prescribed nozzle directions, leg-length limits, obstacle clearance, and support availability. The objective balances pipe length, bends, and support costs.

These interpretations follow from the data and constraints. Some apparent engineering intentions are **not enforced**: the rack-passage constraint is commented out, there is no self-intersection constraint for this pipe, and the flexibility constraints are inactive for the supplied coefficient. The reformulation does not add those requirements.

## Original model structure

### Decision variables

The route has 10 nodes and nine candidate connecting legs.

- **Coordinates:** 30 integer variables, comprising six fixed endpoint coordinates and 24 intermediate-node coordinates.
- **Leg geometry:** two bounding-box corners and three coordinate-wise lengths per leg-array slot.
- **Leg state:** a direction in `0..6`, an existence flag, and a last-leg flag per slot. Direction zero represents a zero-length leg; the other values encode positive or negative movement along each axis.
- **Objective:** an integer variable, `obj`.

The leg arrays contain 10 slots. The final slot is not a connecting leg and is explicitly fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities; they are not independent routing decisions.

### Constraints

The main constraint groups are:

1. **Axis-aligned geometry.** Bounding boxes enclose both endpoints, expanded by the integer pipe radius. Coordinate-wise lengths equal box widths minus twice that radius. Direction constraints restrict movement to one signed axis.

2. **Route sequence.** Existing legs form a prefix, exactly one existing leg is marked last, and at least the first three legs exist. The last leg reaches the fixed destination.

3. **Nozzle and bend restrictions.** The first and last legs have prescribed directions and length limits. Consecutive existing legs cannot use the same axis, preventing both straight continuation and immediate reversal.

4. **Obstacle clearance.** Each relevant leg must lie entirely on one side of an obstacle along at least one coordinate. Specified exceptions allow connection to the starting and destination modules. These checks generally also apply to zero-length trailing legs.

5. **Support availability.** Nodes 2 through 9 must belong to at least one support zone, including nodes associated with unused trailing legs. Membership uses the node center horizontally and the pipe’s bottom vertically.

6. **Conditional engineering constraints.** Separation between different pipes has no applicable pairs in this single-pipe instance. Flexibility inequalities are disabled because the supplied flexibility coefficient is zero.

### Objective

The model minimizes the original scaled cost expression:

- **861 per unit of pipe length;**
- **8,601 per existing leg other than the first**, representing bend cost;
- **51 per supported bend outside preferred rack levels**, or **1 inside a preferred level**.

These coefficients include the original integer division by 100 and subsequent addition of one. The reformulation preserves that expression and its minimization direction.

## Reformulation and validity

### 1. Signed-displacement formulation

The direction implications were replaced by positive and negative displacement variables, with binary direction indicators for each axis.

For each leg, the sum of its six indicators equals its existence flag. Thus, an existing leg selects exactly one signed axis, while an absent leg selects none. Endpoint displacement is the positive displacement minus the negative displacement, and length is their sum.

**Why this is equivalent:** In the original model, endpoint enclosure and the box-width equation imply that each coordinate-wise length is at least the absolute endpoint displacement. For the selected direction, another constraint bounds that length above by the corresponding signed displacement, forcing equality. Unselected dimensions have zero length and therefore equal endpoint coordinates. Consequently, the bounding-box corners are also uniquely determined. The replacement expresses these same relationships directly as linear equations.

### 2. Direction-specific length bounds

Each signed displacement receives an upper bound derived from endpoint coordinate domains. For example, positive movement cannot exceed the next endpoint’s upper bound minus the current endpoint’s lower bound. These limits are intersected with the original leg and applicable nozzle upper bounds.

**Why this is valid:** Every original feasible displacement satisfies both endpoint domains and the original length restrictions. The new bounds therefore exclude no feasible route. Linking displacement to its direction indicator with these tighter bounds strengthens the mixed-integer formulation.

### 3. Direct obstacle-separation disjunctions

The reformulation imposes the obstacle-separation disjunction directly instead of passing it through the defined `bDisjLegBox_K` array.

**Why this is equivalent:** Each original array entry was defined by the same pair of separation inequalities. Substitution preserves the existential condition over coordinates, including both module exceptions. It also retains obstacle checks for unused legs rather than incorrectly disabling them all.

This removes an intermediate logical representation and gives the compiler a simpler expression to linearize.

### 4. Support-membership preprocessing

A node–zone membership expression is replaced by `false` when the node’s coordinate domain cannot intersect the zone in at least one dimension. The vertical test includes the original pipe-radius offset.

**Why this is valid:** Membership requires all coordinate conditions simultaneously. If even one required interval is unreachable within the node’s declared bounds, membership is impossible for every feasible assignment.

### 5. Linearized support costs

The original support cost multiplies the existence flag by a preference-dependent cost. The reformulation writes it as a base cost for an existing leg plus a cost adjustment for each conjunction of existence and preferred-zone membership.

**Why this is equivalent:** The original definition
`fNodeNotInPref = 1 − sum(preferred memberships)`,
together with its `0..1` domain, permits at most one preferred membership for each relevant node. Expanding the original cost algebraically gives exactly the new expression. Boolean conjunctions replace the variable-by-variable product while preserving the cost of every feasible assignment.

### 6. Removal of inactive expressions

Two instance-specific simplifications remove expressions with no effect:

- All nodes belong to the same pipe, so the original different-pipe separation constraints have no applicable pairs.
- The flexibility coefficient is zero, so the original flexibility inequalities evaluate to `true` and their defined cubic sums evaluate to zero.

Neither simplification removes an active engineering restriction.

## Interface and expected benefit

All original independent decision variables are retained. The mapping script returns only those variables, preserves their array encodings, and reconstructs omitted fixed endpoint coordinates from the unchanged embedded data.

The changes aim to improve HiGHS performance through explicit linear geometry, tighter indicator bounds, simpler logical constraints, and elimination of inactive expressions. No measured runtime improvement is established here; the benefit is structural rather than a reported benchmark result.

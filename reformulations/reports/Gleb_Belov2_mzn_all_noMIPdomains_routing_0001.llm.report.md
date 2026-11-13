# Pipe Routing Around Industrial Equipment

## Problem background

The model represents three-dimensional routing of a pipe between two fixed connection points, or *nozzles*, in an industrial installation. Equipment, existing pipe segments, and support regions are represented by axis-aligned boxes. Coordinates use a discretization unit of 200 mm.

A route consists of straight, axis-aligned legs joined at bends. It must maintain specified clearances from obstacles, follow prescribed nozzle directions, and place intermediate nodes in permitted support regions. Preferred rack levels offer cheaper support. The objective balances pipe length, bends, and support costs.

The supplied instance contains one pipe, 10 nodes, and therefore at most nine actual legs. The first and last nodes are fixed. There are 83 boxes, classified as equipment, existing pipe segments, equipment-support zones, a rack region, or preferred rack levels.

## Original formulation

### Variables

The original model declares **151 independent integer variable entries**, before flattening:

- 30 node coordinates, including six fixed endpoint coordinates;
- 60 lower and upper leg-box coordinates;
- 30 coordinate-wise leg lengths;
- 10 direction codes;
- 10 leg-existence flags;
- 10 last-leg flags;
- one objective variable.

Leg arrays include a tenth, dummy entry that is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions. Their declarations do not represent additional independent routing choices, although flattening may introduce auxiliary variables.

### Constraints

The principal constraint groups are:

- **Axis-aligned geometry:** each existing leg has one signed coordinate direction. Its length and bounding box are linked to its endpoint coordinates, with pipe radius added around the segment.
- **Route sequencing:** existing legs form a prefix, exactly one is designated last, and at least the first three exist.
- **Nozzle restrictions:** the first and last existing legs have prescribed directions and length bounds.
- **Bend restrictions:** consecutive existing legs use different coordinate axes, excluding both straight continuation and immediate reversal.
- **Obstacle avoidance:** each applicable obstacle and leg must be separated along at least one coordinate axis, including safety clearance. Specified nozzle-module exceptions are allowed.
- **Support requirements:** intermediate node positions must belong to at least one support region. Membership uses the pipe centre horizontally and its bottom vertically.

Importantly, the original support constraints also apply to intermediate node slots after the last existing leg. Those slots collapse to the endpoint through zero-length legs; the reformulation preserves their support requirements.

Inter-pipe separation has no applicable pairs because this instance contains only one pipe. Flexibility constraints are inactive because its flexibility coefficient is zero. The source’s rack-traversal requirement is commented out, so it is not an active constraint.

### Objective

The model minimizes a scaled integer cost. With the supplied data, it charges:

- **201** per discretized unit of pipe length;
- **2,001** per existing leg after the first;
- **51** per active intermediate-node support outside preferred levels, or **1** within a preferred level.

These coefficients include the original integer division and subsequent addition of one. The reformulation preserves them exactly.

## Reformulation and justification

### 1. Signed-length linear formulation

Each leg receives positive- and negative-direction indicators and corresponding nonnegative lengths for each axis. The sum of its six indicators equals its original existence flag. Consequently, an existing leg selects exactly one signed direction; an absent leg selects none.

Coordinate differences become linear equations:
\[
x_{i+1,k}-x_{i,k}=\ell^+_{i,k}-\ell^-_{i,k}.
\]

The original direction code and coordinate-wise length are recovered algebraically from these indicators and lengths.

**Why this is valid:** in the original model, the bounding-box constraints imply that a coordinate-wise length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality in that direction, forcing equality. Unselected axes have zero length and therefore zero displacement. Thus the new equations express geometry already required by the original constraints.

The bounding-box coordinates also become exact linear expressions:
\[
L_{i,k}=x_{i,k}-\ell^-_{i,k}-r,\qquad
U_{i,k}=x_{i,k}+\ell^+_{i,k}+r.
\]
These preserve the original obstacle-separation geometry, including radius extensions at both ends.

### 2. Bound strengthening

Each signed length receives an upper bound derived from the appropriate endpoint-coordinate bounds and the original maximum leg length. For example,
\[
\ell^+_{i,k}\le
\max\!\left(0,\min\!\left\{\overline{\ell},
\overline{x}_{i+1,k}-\underline{x}_{i,k}\right\}\right).
\]

**Why this is valid:** a positive displacement cannot exceed the largest permitted destination coordinate minus the smallest permitted origin coordinate. The original leg-length limit remains applicable. These bounds strengthen the mixed-integer relaxation without excluding feasible routes.

### 3. Support-zone containment preprocessing

For the support-feasibility test, a zone is removed if another support zone completely contains it. Equal boxes are resolved deterministically by index.

**Why this is valid:** membership in the smaller box implies membership in the containing box. All support zones use the same pipe-radius adjustment to their vertical membership bounds, so containment is preserved under that adjustment. Removing a contained zone therefore leaves the union of feasible support positions unchanged.

This reduction applies only to the support-feasibility test. Preferred-level membership remains separate and exact because it affects cost.

### 4. Support witnesses instead of full membership reification

For each required intermediate node, binary witnesses select one retained support zone. A selected witness implies that the node satisfies that zone’s coordinate bounds; an unselected witness imposes no membership claim.

**Why this is valid:** the original feasibility condition requires membership in *at least one* support zone, not a complete classification of all memberships. Any feasible node can select one containing zone, and any selected witness certifies the original requirement. Selecting exactly one witness does not prohibit physical membership in multiple overlapping zones.

This avoids unnecessary reverse implications for support zones used only to establish feasibility.

### 5. Boolean linearization of support costs

Products between leg-existence flags and support-cost categories are replaced by Boolean conjunctions indicating that a node is both active and in the relevant category.

**Why this is valid:** for binary values, multiplication equals the indicator of logical conjunction. Exact preferred-level membership and the original `fNodeNotInPref` relation are retained, including its binary-domain restriction. Therefore, the support-cost calculation is unchanged.

### 6. Directional-cover cuts

For each axis with nonzero endpoint displacement, the formulation requires at least one leg pointing in the corresponding signed direction.

**Why this is valid:** summing the coordinate-difference equations over the route gives the fixed endpoint displacement. A positive displacement cannot be obtained using only zero or negative movements, and conversely for a negative displacement. These are redundant but potentially strengthening inequalities.

### 7. Removal of inactive components

The reformulation omits inter-pipe separation and flexibility expressions.

**Why this is valid:** all nodes belong to the same pipe, so the original inter-pipe constraint index set is empty. The supplied flexibility coefficient is zero, making the original flexibility constraints tautologies and their associated defined sums zero. No self-intersection restriction or rack-traversal requirement is added.

## Solution interface and expected effect

All original independent decision variables are retained. The mapping script exports only those variables and can restore omitted fixed endpoint coordinates from the unchanged embedded instance data. Missing nonfixed variables are reported rather than guessed.

The reformulation is intended to improve HiGHS performance through more explicit linear geometry, tighter bounds, fewer unnecessary membership equivalences, and valid strengthening cuts. No measured runtime improvement is established here; the changes preserve the original feasible routing decisions, objective values, and minimization direction.

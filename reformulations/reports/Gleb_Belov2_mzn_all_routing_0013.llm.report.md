# Pipe Routing with Obstacles and Support Zones

## Problem background

The model describes routing a pipe through a three-dimensional industrial installation. The pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments, represented by axis-aligned boxes. Its route consists of straight, axis-aligned legs joined by perpendicular bends.

Coordinates are integer multiples of a 200 mm length unit. The supplied instance contains one pipe, ten route nodes, nine possible legs, and 136 boxes. Box types distinguish obstacles, module support zones, a rack, and preferred rack support levels.

The route must respect pipe-radius clearance, prescribed nozzle directions, leg-length limits, and support-zone requirements. Its cost combines pipe length, bends, and bend supports. Although the data include a rack-traversal flag, the corresponding constraint is commented out in the original model; rack traversal is therefore **not mandatory**.

## Original model structure

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates and 24 intermediate coordinates.
- **60 integer leg-bound coordinates**, representing the lower and upper corners of radius-expanded leg boxes.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, with values zero for an absent leg and six signed coordinate directions for an existing leg.
- **20 binary-valued integer flags**, recording leg existence and which leg is the last existing leg.
- An integer objective variable.

Leg arrays have ten entries, although only nine connect consecutive nodes. The unused final entry is constrained to zero. Additional defined arrays describe obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The main constraint groups enforce:

1. **Axis-aligned geometry.** Leg boxes enclose both endpoint nodes, expanded by the pipe radius. Their widths determine component lengths. Direction constraints permit movement along only one coordinate axis.
2. **Route sequencing.** Existing legs form a prefix, exactly one is marked last, and the first three legs exist. Absent legs have zero displacement.
3. **Perpendicular consecutive legs.** Adjacent legs cannot use the same axis, excluding both straight continuation and immediate reversal.
4. **Nozzle connections.** The first and last existing legs have prescribed directions and nozzle-length bounds. The last existing leg reaches the fixed destination.
5. **Obstacle avoidance.** Each applicable leg box must be separated from each obstacle along at least one axis. Explicit exceptions permit connection to the designated nozzle modules.
6. **Support eligibility.** Nodes indexed by non-first possible legs must lie in at least one support zone. This condition applies even when the corresponding leg is absent. Preferred rack-level membership affects support cost.
7. **Optional physical constraints.** The source includes inter-pipe separation and flexibility constraints, but neither imposes an additional restriction in this instance.

### Objective

The model minimizes the original scaled cost, retaining its integer division and “plus one” adjustments:

- **131** per unit of pipe length;
- **1,301** per existing non-first leg;
- **51** per charged support outside preferred levels, or **1** inside a preferred level.

The formulation charges the non-first-leg term according to the original existence flags; it does not reinterpret or change that accounting convention.

## Reformulation and justification

### Linear signed-length formulation

Direction-dependent geometric implications were replaced by positive and negative direction indicators and corresponding nonnegative lengths for each axis. Each leg selects exactly one signed direction when it exists and none when it is absent. Linear equations express:

- endpoint displacement as positive length minus negative length;
- component length as their sum;
- expanded leg bounds from the starting coordinate, signed lengths, and radius.

This is equivalent to the original geometry. Originally, enclosure and the width–length equation imply that each component length is at least the absolute endpoint displacement. For the selected direction, another constraint bounds that length above by the signed displacement, forcing equality. On unselected axes, length is zero, forcing equal endpoint coordinates and tight radius-expanded bounds. The new equations express these same consequences directly.

This extended mixed-integer formulation exposes the geometry to HiGHS without relying on the original chain of direction implications.

### Bound-based strengthening

Each signed-length upper bound is derived from the original endpoint-coordinate domains and the original maximum leg length. For example, positive displacement cannot exceed the destination coordinate’s upper bound minus the starting coordinate’s lower bound.

These bounds cannot exclude a feasible route: they follow directly from the coordinate domains. They strengthen the indicator–length linking inequalities.

### Linearized support costs

The original support-cost expression multiplies a binary existence flag by a membership-dependent cost. The reformulation distributes that product and represents each binary product as a Boolean conjunction.

For binary values, multiplication and conjunction are identical. Support membership definitions and the original zero–one domain of `fNodeNotInPref` are retained, so the replacement preserves costs exactly, including the restriction against simultaneous membership in multiple preferred levels.

### Instance-specific preprocessing

Two inactive constraint families were removed:

- **Inter-pipe separation:** every node belongs to the same pipe. The original constraints are generated only for pairs belonging to different pipes, so there are no applicable pairs.
- **Flexibility:** the sole flexibility coefficient is zero. The original conditional definitions therefore produce zero flexibility sums and impose no flexibility restriction.

These reductions follow from the supplied data, not from additional physical assumptions.

### Valid inequalities

Two strengthening measures were added:

- **Support-envelope bounds.** A node required to belong to a support zone must lie within the coordinate-wise envelope of all support zones. For the vertical coordinate, the bound includes the radius because membership tests the pipe’s bottom rather than its center. These bounds are implied by the original support-membership disjunction.
- **Minimum-leg cut.** Both nozzle legs use the X axis and are distinct because the original sequencing constraints require at least three existing legs. The fixed endpoints differ in both Y and Z. Axis alignment therefore requires at least one Y-directed and one Z-directed leg in addition to the two nozzle legs, giving a lower bound of four existing legs. The implemented cut derives this reasoning from nozzle directions and endpoint bounds.

## Data preservation and solution interface

The final model preserves the original data, independent variables, array indices, objective value, and minimization direction. A transcription error in the box-type array was repaired by restoring the original 136 entries and their correspondence with the box geometry.

The accompanying mapping script returns only original independent variables. It copies retained solution values, restores omitted fixed endpoint coordinates from the original embedded constants, and can recover `obj` from the reported objective. Missing required solution values produce an explicit error rather than a fabricated assignment.

The changes are intended to improve the mixed-integer formulation and its relaxation. No measured solving-time improvement is established by the supplied conversation.

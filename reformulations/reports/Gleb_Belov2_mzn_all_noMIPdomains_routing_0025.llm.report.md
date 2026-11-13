# Reformulation Report: Three-Dimensional Pipe Routing

## Problem background

The model describes routing a pipe through a three-dimensional industrial layout containing equipment modules, existing pipe segments, and support structures. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The supplied instance contains one pipe with fixed endpoints at \((245,43,82)\) and \((293,25,3)\). Eight intermediate nodes provide up to nine axis-aligned pipe legs. The route must respect obstacle clearances, prescribed nozzle directions and connection lengths, and support-zone requirements.

These interpretations follow from the model’s geometry and parameter names. Notably, although the data contain a flag requesting passage through a rack, the corresponding constraint is commented out. Neither the original nor the reformulated model enforces that requirement.

## Original formulation

### Decision variables

The original independent declarations contain **151 integer-valued scalar entries**, before flattening or presolve:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 leg bounding-box coordinates**: lower and upper bounds in three dimensions for ten leg slots.
- **30 nonnegative coordinate-wise leg lengths**.
- **10 direction variables**, encoding inactivity or one of six signed coordinate directions.
- **10 existence flags** and **10 last-leg flags**.
- **One objective variable**.

Only nine slots represent possible legs; the tenth is a dummy slot fixed to zero. Additional arrays define Boolean geometric relations, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraint groups are:

1. **Axis-aligned geometry.**  
   Direction-dependent inequalities connect successive nodes, coordinate-wise lengths, and leg bounding boxes. An active leg changes exactly one coordinate.

2. **Route sequence.**  
   Existence and last-leg flags enforce a contiguous prefix of active legs followed by zero-length legs. Exactly one active leg is last, and the first three legs must exist.

3. **Orthogonality and nozzle connections.**  
   Consecutive active legs use different coordinate axes. The first leg travels in the negative \(Y\) direction, and the last travels in the negative \(Z\) direction. Both nozzle legs have lengths between 2 and 15 coordinate units.

4. **Obstacle avoidance.**  
   Each applicable leg must be separated from each obstacle along at least one axis, including the specified safety distance. The starting module is exempt for the first leg; the destination module has exemptions for the last leg and inactive legs.

5. **Support requirements.**  
   Nodes 2 through 9 must belong to at least one support zone. This requirement applies even to nodes associated with inactive legs. Preferred rack levels affect support costs.

6. **Optional physical constraints.**  
   Inter-pipe separation has no applicable pairs because there is only one pipe. Flexibility constraints are inactive because its flexibility coefficient is zero.

The model does not impose separation between legs of the same pipe.

### Objective

The objective minimizes the sum of pipe-length, bend, and support costs. It retains the original coefficient transformation: integer division by 100, followed by adding one.

For this instance, the resulting charges are:

- **51** per coordinate unit of pipe length;
- **501** per active leg after the first;
- **51** per charged support outside preferred rack levels, or **1** within a preferred level.

## Reformulation and justification

### 1. One-hot direction encoding and signed lengths

The direction implications were replaced with binary selectors for positive and negative travel along each axis, together with nonnegative positive and negative length components.

The selectors sum to the original existence flag. Thus, an active leg selects exactly one signed direction, while an inactive leg selects none. Linear equations recover the original direction, displacement, length, and bounding-box variables.

**Why this is valid:** In the original model, the bounding-box inequalities imply that each coordinate-wise length is at least the absolute endpoint displacement. For the selected direction, another inequality bounds that length above by the signed displacement. These bounds force equality. For every unselected axis, the length is forced to zero, which also forces equal endpoint coordinates. Consequently, the original constraints already imply the exact geometry used by the new equations.

This is an **extended mixed-integer linear formulation**, intended to expose the geometric relationships more directly to HiGHS.

### 2. Domain-derived length bounds

Each signed length component is bounded by its direction selector multiplied by a constant derived from the original endpoint domains and the pipe’s length limit. For example, positive travel cannot exceed the next node’s upper coordinate bound minus the current node’s lower coordinate bound.

**Why this is valid:** No feasible displacement can exceed those endpoint-domain differences. Taking the minimum with the original leg-length upper bound only combines existing restrictions. These are **bound-tightening and indicator-linking inequalities**, not additional routing assumptions.

### 3. Obstacle-pair preprocessing

The reformulation tests whether endpoint coordinate domains already guarantee separation between a leg and an obstacle. Such pairs need no obstacle constraint. Remaining pairs use direct separation disjunctions rather than the original intermediate Boolean relation array.

**Why this is valid:** The leg’s exact bounding box lies within the coordinate envelope of its endpoints, expanded by the modeled pipe radius. If that entire envelope is separated from an obstacle by the required clearance on one axis, every feasible realization of the leg is separated. Removing that pair’s constraint therefore removes only a tautology.

The original nozzle-module exemptions remain unchanged.

### 4. Boolean reformulation of support costs

Products involving the existence flag and support-category indicators were replaced by weighted Boolean conjunctions.

**Why this is valid:** Both the existence flag and the “not in a preferred level” flag are binary, and support membership is Boolean. Their product equals one precisely when both conditions hold. Distributing the original cost expression into these conjunctions preserves its value exactly. The support-membership definitions and the original restriction on preferred-level membership remain in place.

This avoids a general product of decision expressions and exposes standard Boolean linearization structure.

### 5. Removal of inactive model components

Inter-pipe separation and flexibility expressions were omitted.

**Why this is valid:**

- Every node belongs to the same pipe, so the original inter-pipe constraint generator has no qualifying pairs.
- The supplied flexibility coefficient is zero, so the original conditional flexibility constraints evaluate to `true`, and their associated cubed-length sums evaluate to zero.

These are **instance-specific constant-folding reductions**. They would need reconsideration for multiple pipes or positive flexibility coefficients.

## Preservation and expected effect

All original independent decision variables remain available, and the fixed instance data, objective scaling, optimization direction, and active routing requirements are preserved. The mapping script copies retained variables and restores fixed endpoint coordinates from their original singleton domains.

The changes aim to reduce unnecessary reification, remove provably redundant geometry checks, and provide tighter linear relationships for the MIP backend. No solve-time measurements were supplied, so improved performance is an intended benefit rather than an experimentally established result.

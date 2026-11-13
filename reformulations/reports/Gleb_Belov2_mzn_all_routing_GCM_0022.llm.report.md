# Orthogonal Pipe Routing with Support and Flexibility Constraints

## Background

The model represents the routing of a pipe between two fixed nozzles in a three-dimensional industrial layout. Coordinates use discrete units of 200 mm. The pipe must avoid equipment modules and existing pipe segments while respecting safety clearances.

A route consists of axis-aligned straight legs joined at bends. Intermediate nodes must lie in permitted support zones, such as regions around modules, a pipe rack, or preferred rack levels. Additional constraints approximate mechanical flexibility using sums of cubed leg lengths. The engineering interpretation follows from the model’s terminology and equations; it is not a complete mechanical-design specification.

The supplied instance contains one pipe, ten node positions, and nine potential legs. Unused trailing legs have zero length, allowing routes with fewer than nine legs.

## Original Model

### Variables

The original independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-bound coordinates**, representing lower and upper corners of leg bounding boxes.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, with zero denoting an unused leg and six values denoting signed coordinate directions.
- **20 binary integer indicators** for leg existence and identification of the final active leg.
- **One integer objective variable**.

The leg arrays include a tenth, dummy slot fixed to zero. Further arrays define obstacle-separation predicates, support membership, support costs, and cubic-length sums.

### Constraints

The model imposes:

1. **Axis-aligned geometry.** Each active leg moves along exactly one coordinate axis. Consecutive active legs must use different axes.
2. **An active prefix of legs.** Existence and final-leg indicators enforce a contiguous route with at least three active legs.
3. **Nozzle restrictions.** The first and final active legs have prescribed directions and length limits.
4. **Obstacle clearance.** A leg must be separated from each relevant obstacle on at least one axis. Specified exceptions permit connection to the endpoint modules.
5. **Support requirements.** Intermediate node slots must belong to a support zone, including slots corresponding to unused trailing legs. Preferred rack-level membership affects support cost.
6. **Flexibility inequalities.** For each coordinate direction, sums of cubed lengths in the other directions must dominate coefficient-weighted individual lengths.

The source also includes inter-pipe separation constraints, but these generate no restrictions for this single-pipe instance. Rack traversal is not enforced: the corresponding source constraint is commented out.

### Objective

The model minimizes a weighted sum of pipe length, bends, and support costs. The original scaling rule—integer division by 100 followed by addition of one—is preserved exactly. Consequently, pipe length has coefficient 61, each active noninitial leg has bend coefficient 601, and support costs distinguish preferred rack levels from other support locations.

## Reformulation and Its Justification

### Linear signed-movement formulation

Positive and negative movement variables and binary direction indicators replace the original implication-based connection between directions, lengths, and coordinates. Linear equations express:

- endpoint displacement as positive movement minus negative movement;
- component length as their sum;
- leg bounds as the starting coordinate adjusted by movement and pipe radius.

This is exact because the original bounding constraints imply that component length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality, while unselected components have zero length. Thus, the original constraints already force exact component lengths and tight leg bounds. The new equations express those same relationships directly.

### Coordinate-domain preprocessing

Each component receives an upper bound derived from the largest possible endpoint displacement, intersected with the applicable ordinary-leg or nozzle-leg limit. Components forbidden by fixed nozzle directions receive bound zero.

These bounds are valid because the original geometry forces component length to equal absolute endpoint displacement. No movement can exceed what its endpoint coordinate domains permit.

### Exact saturated-cube encoding

Variable cubic expressions are replaced by finite-domain linear encodings suitable for HiGHS. Small lengths are represented individually; lengths above a threshold share a saturated contribution.

Let \(C\) be the largest flexibility coefficient multiplied by the largest permitted leg length. Every flexibility inequality has a left-hand side at most \(C\). Replacing each nonnegative cubic contribution \(x^3\) by \(\min(C,x^3)\) therefore preserves feasibility:

- If no contribution reaches \(C\), the sum is unchanged.
- If any contribution reaches \(C\), the saturated sum is already at least every possible left-hand side.
- Conversely, the unsaturated sum is never smaller than the saturated sum.

This is an exact reformulation of the flexibility **constraints**, not an approximation of their feasible set.

### Linear support-cost expression

The product of leg existence and support cost is rewritten as a weighted sum of Boolean conjunctions: an active leg outside preferred levels, or an active leg inside a particular preferred level.

This follows by distributing the binary existence indicator over the original cost expression. The preferred-level membership and nonpreferred indicator constraints remain in place.

### Valid displacement inequalities

For each axis, total component length is constrained to be at least the absolute displacement between the fixed endpoints. Signed movement totals are also equated to that displacement.

Both follow from summing the leg-displacement equations and applying the triangle inequality. They exclude no feasible route and can strengthen or make explicit information useful to the linear relaxation.

## Interface and Expected Effect

All fixed instance data, original independent variables, and the minimization objective are retained. The mapping script returns only the original independent variables, restores fixed endpoint coordinates from the supplied model when necessary, and preserves array indices.

The reformulation targets a more explicit mixed-integer linear representation, tighter movement bounds, and smaller coefficients in the flexibility encoding. These changes are intended to improve HiGHS performance; no measured runtime improvement is established by the conversation.

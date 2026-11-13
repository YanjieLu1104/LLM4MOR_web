# Orthogonal Pipe Routing with Obstacles and Support Zones

## Problem background

The model represents the routing of a pipe between two fixed equipment connections in a three-dimensional industrial layout. The pipe follows axis-aligned straight segments, with bends joining consecutive segments. Fixed boxes describe equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels.

Coordinates use a discrete grid with a stated unit length of 200 mm. The supplied instance contains one pipe, ten ordered node positions, and nine potential segments. The endpoints are fixed at `(275, 54, 8)` and `(255, 52, 143)`. The model chooses the intermediate nodes and how many segments are used.

Routes must respect obstacle clearances, connection directions, segment-length limits, and support requirements. The objective balances pipe length, bends, and support costs. The model does **not** prohibit intersections between different segments of this same pipe; the reformulation preserves that behavior.

## Original model structure

### Variables

The original independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer segment-bound coordinates**, representing lower and upper corners in three dimensions for ten segment-array positions.
- **30 nonnegative integer component lengths**.
- **10 integer direction variables**, encoded as zero for an absent segment and six signed coordinate directions.
- **20 binary integer flags**, indicating segment existence and the last active segment.
- **One integer objective variable**.

The tenth segment-array position is a dummy position fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The main constraint groups are:

1. **Segment geometry.** Segment bounds enclose their endpoint coordinates. Component lengths equal the differences between these bounds, after subtracting the pipe-radius allowance. Direction constraints force movement along exactly one axis for an active segment and no movement for an absent segment.

2. **Route sequencing.** Active segments form a prefix of the nine possible segments. Exactly one is marked last, and the first three segments must exist. Consecutive active segments must use different axes.

3. **Nozzle connections.** The first segment points in positive Z and has length between 2 and 15. The last active segment points in negative X, also with length between 2 and 15, and ends at the fixed destination.

4. **Obstacle avoidance.** Each relevant segment must lie entirely on one side of an obstacle along at least one coordinate. The model includes specific exceptions for the source module and destination module. In particular, inactive segments are not exempted from every obstacle constraint.

5. **Support requirements.** Nodes 2 through 9 must belong to at least one support zone, including nodes corresponding to an inactive route suffix. Preferred rack-level membership determines support cost.

6. **Inter-pipe clearance and flexibility.** Inter-pipe constraints have no applicable pairs because this instance contains one pipe. Flexibility constraints are inactive because its supplied flexibility coefficient is zero.

The supplied diameter is one grid unit, and the original radius calculation uses integer division. Consequently, the modeled radius is zero; this convention is preserved.

### Objective

The model minimizes its original scaled integer cost:

- **61** per unit of pipe length;
- **601** per active segment after the first, representing bends;
- **51** per active bend outside preferred rack levels, or **1** within a preferred level.

These values follow the original coefficient transformation, `cost div 100 + 1`. The reformulation preserves this objective rather than substituting unscaled monetary costs.

## Reformulation and justification

### 1. Nozzle-based coordinate preprocessing

The domains of nodes adjacent to the endpoints were tightened.

- **Node 2:** The first segment starts at `(275, 54, 8)`, points in positive Z, and has length 2–15. Therefore, node 2 must have X = 275, Y = 54, and Z in 10–23.
- **Node 9:** The ninth possible segment is either absent or is the last segment. An absent segment has zero displacement; an active last segment approaches `(255, 52, 143)` in negative X with length at most 15. Thus node 9 has X in 255–270, Y = 52, and Z = 143.

These are consequences of the original geometry, sequencing, and nozzle constraints, not additional routing assumptions.

### 2. Signed-length disaggregation

Direction-dependent geometry was replaced with binary indicators and nonnegative lengths for positive and negative movement along each axis.

The indicators sum to the segment-existence flag. Each signed length is bounded above by its indicator times a valid movement limit and below by the original minimum length times its indicator. Endpoint displacement is expressed directly as positive length minus negative length.

This is equivalent to the original formulation: enclosure constraints imply that a component length is at least the absolute endpoint displacement, while the selected-direction constraint supplies the reverse inequality. Hence the original component length already equals that absolute displacement, and its segment bounds are already the exact endpoint extrema plus the radius allowance.

The reformulation makes these relationships explicit through linear equations, reducing reliance on reified direction implications.

### 3. Bound tightening and obstacle-separation witnesses

Coordinate domains provide tighter bounds on segment extrema and directional movement. For example, the maximum possible positive movement is bounded by the next node’s upper coordinate bound minus the current node’s lower bound.

Obstacle disjunctions now use binary **separation witnesses** with bound-derived big-M coefficients. A selected witness enforces separation on one side of an obstacle, and each applicable obstacle constraint requires at least one witness, subject to the original module exceptions.

This preserves feasibility in both directions:

- Any selected witness guarantees a valid original separation.
- Any originally separated segment can select a corresponding witness.

Impossible separation sides are fixed to zero; sides guaranteed by bounds are fixed to one. Unlike exact membership indicators, these witnesses need not identify every true separation.

### 4. Support-zone preprocessing and selection

A node–zone pair is excluded from support selection when the node’s coordinate domains cannot intersect that zone’s membership intervals. Otherwise, a binary selection variable can certify membership using bound-derived linear inequalities.

Each required node selects exactly one supporting zone. This does **not** require exclusive geometric membership: a node may lie in several zones and select any one. Therefore, it is equivalent to the original requirement that at least one supporting zone exists.

Exact preferred-level membership is retained separately because it affects costs and the original `fNodeNotInPref` domain restriction.

### 5. Linear support-cost formulation

The original product of segment existence and membership-dependent support cost was replaced by weighted Boolean conjunctions, such as “segment exists and node is outside preferred levels.”

This follows by distributing the original product over its terms. Since the factors are binary, their product equals the indicator of their conjunction. The replacement therefore preserves costs for both active and inactive segments.

### 6. Valid displacement and direction-count cuts

Summing consecutive endpoint-displacement equations gives the fixed endpoint displacement. This yields coordinate-wise lower bounds on total length through the triangle inequality.

Additional direction-count cuts use the nozzle limits:

- The required upward displacement is 135, but the first positive-Z segment is at most 15. At least one additional positive-Z segment is necessary.
- The required negative-X displacement is 20, but the last negative-X segment is at most 15. At least one additional negative-X segment is necessary.
- The negative-Y displacement requires at least one negative-Y segment.

Opposite-direction movement cannot invalidate these arguments: it only increases the movement required in the necessary direction. The cuts strengthen the mixed-integer formulation without excluding feasible original routes.

### 7. Inactive components and solution mapping

The zero flexibility coefficient makes every original flexibility expression zero and every associated constraint vacuous. Inter-pipe separation is likewise vacuous for this single-pipe instance. Their simplification is therefore instance-specific and exact.

All original independent variables remain represented. The supplied mapping script returns only those variables, copies the retained arrays, and reconstructs fixed scalar coordinates from the embedded endpoint data and nozzle implications when they are omitted from solver output.

Overall, the reformulation targets a stronger, more explicit linear mixed-integer representation for HiGHS. No measured speedup is established by the conversation; the changes are motivated by tighter bounds, simpler logical encodings, and stronger relaxation constraints.

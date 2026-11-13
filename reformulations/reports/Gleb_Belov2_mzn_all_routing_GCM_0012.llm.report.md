# Pipe-Routing Model and MILP Reformulation

## 1. Application background

The model represents the routing of a single industrial pipe between two fixed nozzles in a three-dimensional plant layout. Coordinates are integer multiples of **200 mm**. The route must avoid equipment and existing pipework, maintain prescribed clearances, and place intermediate nodes in permitted support regions.

The instance provides **132 boxes**, classified as equipment modules, existing pipe segments, module-support zones, a pipe rack, and preferred rack-support levels. Pipe thickness is represented using the original discrete radius calculation, `diameter div 2`.

The route also satisfies a cubic flexibility criterion, apparently intended to represent thermal-expansion flexibility. The model labels this criterion “GCM”; its engineering interpretation is inferred from the comments and equations rather than independently validated.

## 2. Original formulation

### Variables and route representation

The pipe has **10 nodes** and **nine candidate legs** connecting consecutive nodes.

- There are **30 integer coordinate variables**, including six fixed endpoint coordinates.
- Three arrays describe each leg’s lower bounding-box corner, upper corner, and coordinate-wise lengths.
- Direction variables distinguish an absent leg from movement in the six signed coordinate directions.
- Binary integer flags identify existing legs and the final existing leg.

The leg arrays contain 10 entries: nine candidate legs and one dummy entry fixed to zero. Including the coordinate variables, leg arrays, direction and existence flags, and objective variable, the source declares **151 independent scalar integer variables before compilation**, some fixed by their domains or constraints. Additional defined arrays represent geometric predicates, support costs, and flexibility expressions.

### Constraints

The main constraint families are:

1. **Connected, axis-aligned routing.** Each existing leg moves along exactly one coordinate axis. Consecutive existing legs use different axes, preventing straight continuation and immediate reversal.
2. **Route termination.** Existing legs form a prefix of the candidate sequence. Exactly one is designated final, and subsequent legs have zero length. The first three legs must exist.
3. **Nozzle restrictions.** The first and final legs have specified directions and length limits.
4. **Obstacle clearance.** Each applicable obstacle must be separated from a leg’s thickness-expanded bounding box along at least one axis. The original nozzle-module exceptions are retained.
5. **Support membership.** Intermediate candidate nodes must lie in at least one support region. This requirement also applies to nodes following route termination; it is not conditional on leg existence.
6. **Flexibility.** For each coordinate, the sum of cubed lengths in the other two coordinates must dominate a coefficient times each corresponding individual leg length.

Inter-pipe clearance constraints generate no restrictions in this single-pipe instance. A rack-traversal requirement appears only in commented code and is therefore not active.

### Objective

The model **minimizes** total pipe-length, bend, and support costs. The original integer coefficient transformation—division by 100 followed by addition of one—is preserved. In particular, the reformulation does not replace these coefficients with unscaled engineering costs.

## 3. Reformulation and justification

### Exact finite-domain linearization of cubic lengths

The principal change replaces variable cubic expressions with a mixed-integer linear formulation.

For each leg, binary selectors choose its positive integer length. Their sum equals the leg-existence flag, and their length-weighted sum equals the sum of its three coordinate lengths. This is exact because the original direction constraints allow only one nonzero coordinate length per existing leg, and require that length to be at least the general lower bound.

A constant-weighted sum of the same selectors computes the selected length’s cube. Auxiliary coordinate-cube variables distribute this value to the active axis; inactive axes are forced to zero. Consequently, each auxiliary coordinate cube equals the cube of the corresponding original length, including zero for absent legs.

This removes variable powers without approximating the flexibility constraints.

### Domain-based preprocessing

Impossible length choices are fixed to zero using:

- endpoint coordinate domains;
- general leg-length bounds;
- first- and last-possible-leg nozzle restrictions.

For example, an axis length cannot exceed the largest possible absolute difference between its two endpoint coordinates. This follows from the original bounding-box and direction constraints, which together force length to equal endpoint displacement on the active axis. Nozzle restrictions further reduce the admissible choices.

These bounds also tighten the constants used to deactivate coordinate-cube variables.

### Valid strengthening constraints

The reformulation adds three types of redundant constraints:

- **Exact bounding-box midpoint identities.** The original box inequalities bound both endpoints, while the length and direction constraints force the box span to equal the endpoint separation plus twice the radius. Therefore, the two box boundaries sum to the two endpoint coordinates.
- **Endpoint-displacement lower bounds.** Total route length along each axis must be at least the absolute nozzle displacement on that axis, by the triangle inequality applied to consecutive node displacements.
- **Cubic envelope inequalities.** For a nonnegative length \(x\le U\), \(x^3\le U^2x\). Convexity also gives the tangent inequality \(x^3\ge 3t^2x-2t^3\) for any nonnegative anchor \(t\). Selected inequalities of these forms strengthen the linear relaxation without excluding feasible integer routes.

### Logical and cost simplification

Obstacle separation is expressed directly as a disjunction rather than through a full intermediate Boolean array. The same separation alternatives and nozzle exceptions remain.

Support costs use a conditional expression instead of multiplying an existence variable by a variable cost expression. This is equivalent because existence is binary: an absent leg incurs zero cost, and an existing leg incurs the original support charge.

### Data and solution interface

Array-transcription errors encountered during repair were corrected to restore the original box data and ordering. All original independent decision variables remain in the model. The mapping script returns those variables, restores fixed endpoint coordinates from their original singleton domains, and excludes reformulation-specific auxiliaries.

The intended benefit is an exact formulation compatible with the HiGHS MILP backend, with tighter bounds and additional relaxation-strengthening inequalities. No measured solve-time improvement was established in the conversation.

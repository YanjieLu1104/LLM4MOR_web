## Background and interpretation

The instance models **three-dimensional industrial pipe routing** among fixed equipment modules and existing pipe segments. A new pipe must connect two fixed nozzles, avoid obstacles with prescribed clearance, and place its intermediate nodes in permitted support zones. Rack levels offer cheaper support.

Coordinates are integer-valued, with one coordinate unit representing **200 mm**. The pipe connects \((315,54,73)\) to \((335,53,8)\), using ten node positions and at most nine nonzero, axis-aligned legs. The model also imposes cubic length-based constraints intended to represent pipe flexibility. This engineering interpretation follows from the model’s comments, units, and constraint structure; the reformulation preserves those constraints rather than reassessing their physical accuracy.

## Original formulation

### Variables and route geometry

The original independent decision variables comprise:

- **30 node coordinates**, including six fixed endpoint coordinates;
- **60 leg-envelope coordinates**, giving lower and upper bounds in three dimensions;
- **30 nonnegative directional leg lengths**;
- **10 direction codes**, **10 existence indicators**, and **10 last-leg indicators**;
- one integer objective variable.

The leg arrays contain ten slots, but only the first nine can represent connections between consecutive nodes. The final slot is fixed to zero. Additional defined arrays represent obstacle separation, support membership, support costs, and sums of cubed lengths.

Each active leg moves along exactly one coordinate axis. Consecutive active legs must use different axes, excluding both straight continuation and immediate reversal. Existence and last-leg constraints make active legs a contiguous prefix, with at least three active legs. The first and last active legs have prescribed nozzle directions and length limits. Inactive trailing legs have zero length, so their nodes coincide with the destination.

### Spatial and engineering constraints

The principal constraint families are:

- **Obstacle avoidance:** each leg must lie entirely on one side of an obstacle along at least one axis. Clearances and the model’s integer pipe radius are included. Specified nozzle-module exceptions permit the required connections.
- **Support placement:** every intermediate node must belong to at least one support zone, including nodes associated with inactive trailing legs. Preferred rack levels determine support discounts.
- **Inter-pipe separation:** the general model contains this constraint family, but it generates no constraints here because the instance has only one pipe. The original model does not prohibit self-intersection.
- **Flexibility:** for each coordinate axis, a coefficient times each orthogonal leg length must not exceed the sum of cubes of all leg lengths orthogonal to that axis. Coefficients depend on nozzle separation, unit conversion, and the supplied flexibility parameter.

### Objective

The model **minimizes total scaled routing cost**. Its coefficients are obtained by integer division by 100 followed by addition of one:

- 61 per unit of pipe length;
- 601 per active leg after the first;
- support costs of 51 outside preferred rack levels and 1 inside them.

These are the original model’s objective coefficients, not newly normalized engineering costs.

## Reformulation and justification

### 1. Disaggregated linear leg geometry

Each leg-axis pair now has positive and negative movement variables, controlled by binary direction indicators. Their difference equals the change in node coordinates, and their sum equals the directional length. Across all axes and signs, the number of selected directions equals the original existence indicator.

This is equivalent to the original geometry. Originally, the leg envelope contains both endpoint nodes, so its length is at least their absolute coordinate difference. The selected direction imposes the reverse inequality, forcing equality; unselected axes have zero length. Consequently, the original envelope endpoints are uniquely determined by the node coordinates and movement direction. The new linear equations express exactly those relationships while retaining the original envelope, length, direction, and existence variables.

### 2. Coordinate-derived movement bounds

Positive movement is bounded by the next node’s coordinate upper bound minus the current node’s lower bound; negative movement uses the reverse combination. These bounds are intersected with the original maximum leg length. First-leg and last-possible-leg bounds also incorporate the original nozzle restrictions.

These bounds are valid because movement equals the corresponding endpoint displacement. They therefore exclude no feasible original route. They provide tighter coefficients for the binary-controlled linear formulation.

### 3. Exact saturated-cube formulation

Variable cubing is replaced by a finite-domain binary encoding. Short lengths are represented individually; sufficiently long lengths share a saturated contribution.

Let \(M\) be the largest flexibility coefficient multiplied by the original maximum leg length. Every flexibility inequality has a nonnegative left-hand side \(A\le M\). Its right-hand side is a sum of nonnegative cubes. Thus,

\[
A\le \sum_j \ell_j^3
\quad\Longleftrightarrow\quad
A\le \sum_j \min(\ell_j^3,M).
\]

If no cube exceeds \(M\), the sums are identical. If any cube reaches or exceeds \(M\), its capped contribution alone is sufficient to satisfy the inequality.

The encoding therefore distinguishes lengths only until their cubes reach \(M\). Beyond that threshold, the actual length remains variable within its valid bounds, while its flexibility contribution is fixed at \(M\). This is an **exact feasibility-preserving reformulation**, not a piecewise-linear approximation. Coordinate and nozzle bounds additionally fix impossible encoding choices to false.

### 4. Linear support-cost expression

The original support cost multiplies a binary leg-existence indicator by a sum of binary membership-dependent charges. The reformulation distributes that product and represents each binary product as a logical conjunction.

For binary values \(a\) and \(b\), \(ab\) equals the indicator of \(a\land b\). Accordingly, the replacement preserves support costs exactly, including the original preferred-level membership restrictions.

### 5. Valid prefix and suffix distance inequalities

Additional inequalities require accumulated length along each coordinate to cover the corresponding displacement:

- from the starting nozzle to a node;
- from a node to the destination.

These follow from telescoping coordinate differences and the triangle inequality: the sum of absolute movements cannot be smaller than the absolute net displacement. They are redundant for integer-feasible routes but can strengthen the mixed-integer linear relaxation.

### 6. Removal of unnecessary defined views and solution mapping

Obstacle separation is expressed directly rather than through the original three-dimensional Boolean view. Unused defined arrays are omitted; their underlying requirements are retained. The original uncapped cube-sum view is replaced by the exact capped formulation described above.

All original independent decision variables remain in the model. The mapping script selects those variables from solver output, preserves array encodings, and reconstructs fixed endpoint coordinates from the original embedded constants if necessary. It reports missing nonfixed variables rather than supplying guessed values.

## Expected computational effect

The reformulation targets HiGHS by replacing nonlinear expressions with explicit mixed-integer linear relationships, tightening movement bounds, reducing the number of distinct cube values that must be encoded, and adding valid distance inequalities. These changes preserve the original feasible routes, objective values, and minimization direction. No measured runtime improvement was established in the conversation.

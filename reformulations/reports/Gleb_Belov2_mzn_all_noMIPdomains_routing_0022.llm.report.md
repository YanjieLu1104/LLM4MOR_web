# Pipe-Routing Model and Reformulation

## 1. Application and physical interpretation

The model represents the routing of a pipe through a three-dimensional industrial layout. The fixed geometry describes equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels.

A route connects two fixed nozzles using straight, axis-aligned segments. It must respect obstacle clearances, nozzle connection directions, segment-length limits, and support requirements. The objective balances pipe length, bends, and support costs.

This instance contains one pipe and ten ordered route nodes, allowing at most nine segments. The endpoints are `(315, 54, 73)` and `(335, 53, 8)`. Coordinates use a discretization of 200 mm per unit. The first segment points in the positive X direction; the final active segment points in the negative Z direction. Both nozzle segments have lengths between 2 and 15 units.

The interpretation follows the implemented discretization: pipe radius is calculated using integer division, so the supplied diameter of 1 gives a modeled radius of 0. Obstacle-specific safety distances still apply.

## 2. Original mathematical structure

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer segment-bound variables**, representing lower and upper spatial bounds in three dimensions.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, with values 0–6: zero denotes an inactive segment, and the remaining values denote signed coordinate directions.
- **10 binary existence variables** and **10 binary final-segment variables**.
- An integer objective variable.

The segment arrays include ten positions, although only positions 1–9 connect successive nodes. The tenth position is explicitly fixed to zero.

Computed arrays describe obstacle separation, support-zone membership, preferred-level membership, support costs, and flexibility expressions.

### Constraints

The principal constraint groups are:

1. **Segment geometry.** Segment bounds enclose both endpoints, and their widths determine component lengths. Direction constraints allow movement along exactly one coordinate axis.
2. **Route sequence.** Active segments form a prefix. Exactly one segment is final, and the first three segments must exist.
3. **Orthogonal turns.** Consecutive active segments cannot use the same coordinate axis, ruling out both straight continuation and immediate reversal.
4. **Nozzle connections.** The initial and final active segments obey prescribed directions and length limits. The final active segment ends at the fixed destination.
5. **Obstacle avoidance.** Each applicable segment must be separated from an obstacle on at least one axis. Specific exceptions allow connection to the source and destination modules.
6. **Support requirements.** Nodes 2–9 must belong to a support zone. Importantly, this requirement also applies to repeated destination nodes after the route becomes inactive.
7. **Inter-pipe separation and flexibility.** These are present in the general formulation but inactive here: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes a scaled integer cost comprising:

- **61 per unit of route length**;
- **601 per active segment after the first**, corresponding to a bend;
- support costs at the associated nodes: **51 outside preferred rack levels** and **1 within them**.

These coefficients retain the original transformation, `cost div 100 + 1`. They are not replaced with unscaled monetary costs.

## 3. Reformulation and validity

### Linear signed-displacement formulation

Each segment component now has positive and negative displacement variables, with binary direction indicators. Their difference equals the endpoint displacement, and their sum equals the component length. Exactly one signed direction is selected for an active segment.

This is equivalent to the original geometry constraints. Originally, the enclosing segment bounds imply that a component length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality, while unselected components have length zero. Thus, the original constraints already force exact absolute lengths and exact endpoint-based bounds.

The reformulation expresses these relationships directly through linear equations and bounded indicator–length inequalities. Direction-specific upper bounds are derived from endpoint coordinate domains and the original segment-length limit. This provides tighter links for the MIP relaxation.

### Nozzle-based domain tightening

Two node domains were tightened without excluding feasible routes:

- **Node 2:** The first segment is positive X with length 2–15. Starting from `(315, 54, 73)`, this forces X into `317..330`, with Y = 54 and Z = 73.
- **Node 9:** The ninth segment is either inactive or the final negative-Z nozzle segment. If inactive, its endpoints coincide. If active, it ends at `(335, 53, 8)` and has length at most 15. Consequently, node 9 has X = 335, Y = 53, and Z in `8..23`.

These tighter domains also strengthen subsequent geometric preprocessing.

### Bound-based geometric preprocessing

An obstacle check is omitted only when the entire possible segment envelope is already separated from that obstacle along some axis, including its required safety distance. In that case, one disjunct of the original separation constraint is always true.

Similarly, support-zone membership is fixed to false when a node’s coordinate domain cannot intersect that zone on at least one axis. The test preserves the original convention that vertical membership refers to the pipe’s bottom, while horizontal membership refers to its center.

Neither technique removes a potentially relevant obstacle or a feasible support assignment.

### Linearized support costs

The original support expression multiplies segment existence by a membership-dependent cost. The reformulation distributes this product into Boolean conjunctions: a charge applies precisely when the segment exists and the corresponding membership condition holds.

This preserves the original cost because the existence and membership conditions are binary. The original restriction on the number of preferred-level memberships is also retained through the domain of `fNodeNotInPref`.

### Removal of inactive constraint families

Two instance-specific simplifications are exact:

- **Inter-pipe separation:** The original constraints are generated only for segments belonging to different pipes. With one pipe, there are no such pairs.
- **Flexibility:** The original formulation bypasses its flexibility inequalities whenever the pipe coefficient is nonpositive. The supplied coefficient is zero, so those inequalities impose no restriction and the associated computed sums are zero.

No self-intersection constraints were added; the original model does not impose them.

### Valid strengthening cuts

Two families of redundant inequalities were added:

- **Remaining-distance cuts:** For each node and coordinate, the remaining component lengths must cover the absolute coordinate displacement to the destination. These inequalities follow from the triangle inequality applied to the remaining segment displacements.
- **Axis-count cuts:** A nonzero endpoint displacement requires at least one segment on that axis. Here, the X displacement is 20, exceeding the initial X nozzle segment’s maximum length of 15, so at least two X segments are required. The Z displacement has magnitude 65, exceeding the final Z nozzle segment’s maximum length of 15, so at least two Z segments are required. The Y displacement is nonzero, requiring at least one Y segment.

Because each active segment uses exactly one axis, these facts imply at least five active segments. They strengthen the formulation without imposing an assumed route shape.

## 4. Solution interface and expected benefit

All original independent decision variables retain their names and meanings. The mapping script returns only those variables, copying solver-emitted values and reconstructing omitted fixed coordinates from the embedded instance and the nozzle implications above. Missing nonfixed values are reported as errors.

The reformulation targets faster MIP solution through tighter bounds, direct linear geometry, fewer unnecessary geometric checks, and redundant distance and segment-count inequalities. No runtime measurements were supplied, so these are formulation improvements rather than a demonstrated speedup.

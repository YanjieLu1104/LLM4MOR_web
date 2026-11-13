# Pipe-Routing Model: Structure and Reformulation

## 1. Real-world interpretation

The model represents the routing of an industrial pipe through a three-dimensional plant layout. The pipe connects two fixed equipment nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by right-angle bends.

Coordinates use a discretized spatial grid with a length unit of **200 mm**. The supplied instance contains one pipe, ten ordered route nodes, and nine candidate legs. The endpoint coordinates are fixed at `(246, 52, 200)` and `(309, 96, 80)`; the eight intermediate nodes are movable.

Fixed boxes describe obstacles, module support zones, a large pipe rack, and preferred rack levels. Obstacle clearance accounts for both the modeled pipe radius and box-specific safety distances. Support-zone membership is evaluated at the node center horizontally and at the pipe’s bottom vertically.

Although the input includes a flag suggesting that the pipe should pass through a rack, the corresponding constraint is commented out in the original model. The reformulation therefore does **not** impose a rack-passage requirement.

## 2. Original mathematical structure

### Variables

The original independent declarations contain **151 scalar integer entries**, before compiler-generated variables and removal of fixed entries:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 leg-envelope coordinates**: lower and upper corners in three dimensions for each of ten leg-array positions.
- **30 nonnegative component lengths**.
- **10 direction codes**, encoding inactivity or one of six signed coordinate directions.
- **10 binary-valued existence flags** and **10 binary-valued last-leg flags**.
- **One objective variable**.

Only nine leg positions connect consecutive nodes. The tenth position is a dummy entry whose leg variables are fixed to zero.

Additional defined arrays express obstacle separation, support-zone membership, preferred-level membership, support costs, and flexibility quantities.

### Constraints

The main constraint families are:

1. **Leg geometry.** Each active leg changes exactly one coordinate. Direction constraints, length bounds, and envelope inequalities jointly force its component length to equal the absolute endpoint displacement and its envelope to be the endpoint bounding box expanded by the modeled radius.

2. **Route sequencing.** Active legs form a contiguous prefix. Exactly one leg is marked as last, and the first three legs must exist. Inactive legs have zero length, so subsequent nodes coincide.

3. **Nozzle connections.** The first and last active legs have prescribed directions and length bounds. Both prescribed directions are positive Z in this instance.

4. **Orthogonality.** Consecutive active legs cannot use the same coordinate axis, excluding both immediate reversal and consecutive collinear legs.

5. **Obstacle clearance.** Each applicable leg–obstacle pair must be separated along at least one coordinate axis. Specific exemptions allow connection to the source and destination modules. Importantly, inactive legs are not generally exempt from obstacle checks.

6. **Support zones.** Nodes 2–9 must belong to at least one support zone, even when their corresponding outgoing leg is inactive.

7. **Conditional constraint families.** Inter-pipe separation applies only to different pipes. Flexibility inequalities apply only when the supplied flexibility coefficient is positive.

### Objective

The model minimizes the original scaled sum of pipe length, bends, and support costs. With the supplied data, this is

\[
181\sum_{l,k} L_{lk}
\;+\;
1801\sum_{l=2}^{9} e_l
\;+\;
\sum_{l=2}^{9} C_l,
\]

where \(e_l\) indicates an active leg. An active bend costs **51** in support charges outside the preferred rack levels and **1** within a preferred level.

These coefficients include the original integer division by 100 and subsequent addition of one. The reformulation preserves them exactly.

## 3. Reformulation and validity

### Exact signed-length formulation

The main change replaces direction-conditioned geometric inequalities with positive and negative length components and binary direction indicators.

For each leg and coordinate,

\[
x_{l+1,k}-x_{l,k}=p_{lk}-m_{lk},
\qquad
L_{lk}=p_{lk}+m_{lk}.
\]

The sum of all six direction indicators equals the leg’s existence flag. Consequently, an active leg selects exactly one signed direction, while an inactive leg selects none. Each signed length is bounded below by the original general minimum length when selected and is zero otherwise.

This is equivalent to the original geometry: the original envelope inequalities imply that length is at least the absolute displacement, while the selected-direction implication supplies the matching upper bound. Together they force equality.

The envelope coordinates can therefore be written exactly as

\[
x^{\mathrm{low}}_{lk}=x_{lk}-m_{lk}-r,
\qquad
x^{\mathrm{high}}_{lk}=x_{lk}+p_{lk}+r.
\]

This exposes the geometry directly as linear equations and binary activation bounds, rather than leaving the MIP compiler to derive it from multiple implications.

### Coordinate-derived bounds

Positive and negative lengths receive separate upper bounds derived from endpoint coordinate domains. For example,

\[
p_{lk}\le
\min\!\left(U_l,\,
\max(0,\overline{x}_{l+1,k}-\underline{x}_{l,k})\right).
\]

The corresponding negative-length bound reverses the endpoint roles.

These bounds are valid because no feasible endpoint assignment can produce a displacement larger than the difference between the relevant domain extremes. Intersecting that bound with the original leg-length limit strengthens the formulation without excluding feasible routes. Finite envelope bounds are likewise derived from coordinate bounds and the modeled radius.

### Boolean linearization of support costs

The original support cost multiplies an existence flag by a variable expression describing support location. The reformulation distributes that product and replaces each product of binary conditions with a Boolean conjunction.

This is exact because the existence and preferred-level flags are binary-valued, and support membership is Boolean. The original preferred-level membership equation and its `0..1` domain are retained, so the admissible memberships and resulting costs remain unchanged.

### Instance-specific preprocessing

Two constraint families simplify completely:

- **Inter-pipe separation is vacuous:** every node belongs to the same pipe, so no pair satisfies the original different-pipe condition.
- **Flexibility is inactive:** the supplied coefficient is zero, so the original conditional flexibility constraints impose no restriction and their defined sums are zero.

The reformulation removes unnecessary separation helper arrays and represents the inactive flexibility sums directly as zero. Obstacle and support requirements remain in force.

### Valid routing cuts

Two redundant inequalities strengthen the model.

**At least five active legs.** Both nozzle legs point upward and are distinct because the original sequencing constraints prohibit the first two legs from being last. Meanwhile, the endpoint displacement requires positive X travel, positive Y travel, and net negative Z travel. Since each leg uses only one signed axis, these require three additional legs beyond the two upward nozzle legs.

**Minimum upward travel.** Total positive-Z length must be at least the first leg’s positive-Z length plus the minimum possible last-leg length:

\[
\sum_l p_{lZ}
\ge
p_{\mathrm{first},Z}
+
\max(L_{\min},L_{\mathrm{nozzle\,2},\min}).
\]

This follows because the distinct last leg also points upward and must satisfy both the general and terminal-nozzle lower bounds. Other upward legs can only increase the left-hand side.

### Solution interface and expected effect

All original independent variables retain their names and meanings. The mapping script copies those variables, restores fixed endpoint coordinates from the original singleton domains if omitted from solver output, and excludes reformulation-only auxiliaries.

The changes aim to improve HiGHS performance through explicit linear geometry, tighter activation bounds, simpler support-cost linearization, and valid routing cuts. No solve-time measurements were supplied, so the performance benefit remains an expectation rather than an experimentally established result.

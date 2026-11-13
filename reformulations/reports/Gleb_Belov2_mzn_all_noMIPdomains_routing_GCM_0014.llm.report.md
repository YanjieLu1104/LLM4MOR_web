# Pipe-Routing Model and MILP Reformulation

## 1. Application background

The model represents three-dimensional pipe routing in an industrial facility. A single pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by right-angle bends.

Coordinates are integer multiples of a **200 mm length unit**. The instance contains **10 route nodes** and **140 fixed boxes**, representing equipment, obstacles, support zones, a rack, and preferred rack support levels. The pipe has diameter two coordinate units.

The model also imposes cubic-length flexibility conditions, apparently intended to provide sufficient flexibility for displacement between the connections. These are the specific engineering conditions encoded in the source, rather than a general mechanical stress analysis.

Some declared features are inactive. In particular, the constraint requiring passage through a rack is commented out. The reformulation does not activate it.

## 2. Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-bound coordinates**, describing the lower and upper corners of radius-expanded leg boxes.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, with values zero for an absent leg and one through six for signed coordinate directions.
- **10 binary existence indicators** and **10 binary last-leg indicators**.
- An integer objective variable.

The leg arrays contain nine candidate segments and one dummy entry fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint families enforce:

1. **Axis-aligned geometry.** Each existing leg changes exactly one coordinate. Its component length and expanded bounding box agree with its endpoints.
2. **Route sequencing.** Existing legs form a prefix, at least three legs exist, and exactly one is designated last. Following nodes coincide with the destination.
3. **Nozzle requirements.** The first and last legs have prescribed directions and length restrictions. The general minimum length of four units also applies, despite the nozzle-specific lower bounds being two.
4. **Orthogonal consecutive legs.** Adjacent existing legs cannot use the same coordinate axis.
5. **Obstacle avoidance.** A leg must be separated from each applicable obstacle along at least one axis, including clearance. Specified nozzle-module exceptions permit connection to the equipment.
6. **Support placement.** Intermediate nodes must belong to a support zone, using the pipe bottom for vertical membership. This requirement also applies to intermediate node positions associated with unused trailing legs.
7. **Flexibility.** For each coordinate direction, the sum of cubed leg lengths in the other directions must exceed a coefficient times each relevant component length.

Inter-pipe separation constraints are present in the source, but their index set is empty because this instance contains only one pipe. There is no corresponding requirement to prevent self-intersection.

### Objective

The model **minimizes** pipe-length cost, bend cost, and support cost. It uses integer coefficients obtained by dividing the input costs by 100 and adding one. For this instance, the resulting coefficients are:

- **131** per length unit;
- **1,301** per existing leg after the first;
- **51** per charged support outside preferred rack levels, or **1** within a preferred level.

These coefficients and the minimization direction are preserved.

## 3. Reformulation techniques and their validity

### Signed-length disaggregation

Each component length is split into nonnegative positive- and negative-direction lengths, controlled by binary direction indicators. Their difference gives the endpoint displacement, while their sum gives the original component length.

This is equivalent to the original geometry: the original bounding-box inequalities make a component length at least the absolute endpoint displacement; the selected-direction inequality provides the reverse bound. Inactive-axis constraints force all other components to zero. Consequently, each leg’s expanded box is uniquely determined by its endpoints and radius. The reformulation expresses these relationships directly through linear equalities and binary-controlled bounds.

### Domain-based length bounds

Component upper bounds are derived from the largest possible endpoint difference permitted by the original coordinate domains. They are intersected with the original leg limits and, where applicable, nozzle limits. Components incompatible with a prescribed nozzle axis receive an upper bound of zero.

These bounds exclude no original feasible route: an exact endpoint displacement cannot exceed the endpoint-domain difference, and the original nozzle constraints already impose the additional restrictions.

### Exact MILP representation of cubic lengths

The variable powers are replaced with a binary-expansion formulation. Since each leg has at most one nonzero component, its total length equals that component length.

For a total length \(t=\sum_h 2^h b_h\), the reformulation constructs
\[
t^2=\sum_h 2^h(tb_h),
\qquad
t^3=\sum_h 2^h(t^2b_h).
\]
Each product of a bounded nonnegative variable \(x\) and a binary variable \(b\) is represented exactly by
\[
0\le z\le x,\qquad z\le Ub,\qquad z\ge x-U(1-b),
\]
where \(U\) is a valid upper bound on \(x\).

The resulting cube is assigned to the selected axis; inactive axes receive zero. Thus the original orthogonal sums of cubes and flexibility inequalities are preserved **exactly**, without piecewise approximation. This makes the nonlinear expressions explicitly compatible with the HiGHS MILP backend, although the added variables and coefficient magnitudes can affect performance.

### Boolean support-cost reformulation

Products involving leg existence and binary support-membership conditions are replaced with Boolean conjunctions. For binary quantities, multiplication equals the indicator that both conditions hold. Distributing the original cost expression over these conjunctions therefore preserves its value, including the zero charge for absent legs.

### Valid endpoint-displacement inequalities

For each axis, the sum of component lengths is constrained to be at least the absolute displacement between the fixed endpoints. This follows from summing the leg displacement equalities and applying the triangle inequality. The inequalities are redundant for integer feasible routes but can strengthen the MILP relaxation.

### Vacuous constraints and data repair

Inter-pipe separation was omitted because every node belongs to the same pipe: the original constraint generator selects no pair of different pipes.

During compilation repair, two accidentally duplicated entries in the reformulated box-type list were removed, restoring the **original 140-entry list** and its correspondence with the **420 coordinate and size entries**. This was a transcription correction, not instance preprocessing.

### Solution interface

All original independent variables are retained. The mapping script copies their values and excludes new auxiliary variables. It can restore omitted fixed endpoint coordinates from the original embedded data and obtain the objective variable from the supplied objective value if necessary. Missing nonfixed variables are reported explicitly rather than guessed.

The reformulation is intended to improve MILP tractability; no measured speedup or optimal-solution result was established in the supplied exchange.

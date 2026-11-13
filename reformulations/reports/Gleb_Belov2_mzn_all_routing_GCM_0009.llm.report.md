# Pipe Routing with Clearance, Support, and Flexibility Requirements

## 1. Real-world interpretation

The instance represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, in a three-dimensional plant layout. Coordinates are integer multiples of a 200 mm discretization unit.

The route consists of straight, axis-aligned segments joined by bends. It must avoid equipment and existing pipe segments, respect prescribed nozzle approach directions, and place intermediate nodes in permitted support zones. A cubic length-based condition represents the pipe’s required flexibility, using the supplied material/diameter-dependent coefficient.

The instance contains one pipe, 10 route nodes, and nine potential legs. The endpoints are fixed at `(309, 106, 80)` and `(302, 60, 54)`. There are 120 fixed boxes describing equipment, existing pipe segments, support zones, a rack, and preferred rack levels.

Although the data include a flag requesting routing through a rack, the corresponding constraint is commented out in the original model. The reformulation therefore does **not** impose this additional requirement.

## 2. Original model structure

### Variables

The original model explicitly declares 151 independent scalar integer variables before flattening:

| Variable group | Count | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each of 10 nodes; six endpoint coordinates are fixed |
| Leg bounding-box coordinates | 60 | Lower and upper radius-expanded corners for 10 indexed leg positions |
| Coordinate-wise leg lengths | 30 | Nonnegative lengths along the three coordinate axes |
| Leg directions | 10 | Zero for an absent leg; six signed axis directions otherwise |
| Leg-existence flags | 10 | Binary indicators of active legs |
| Last-leg flags | 10 | Binary indicators identifying the final active leg |
| Objective variable | 1 | Total routing cost |

The tenth indexed leg position is a dummy position fixed to zero. Additional arrays define obstacle-separation indicators, support membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint groups are:

- **Route geometry:** Each active leg travels along exactly one coordinate axis. Its bounding box includes the pipe radius.
- **Route sequencing:** Active legs form a prefix of the potential legs, with at least three active legs and exactly one final leg. Inactive trailing legs have zero length.
- **Nozzle connections:** The initial leg has a prescribed direction and length limits. The final active leg has its own prescribed direction and length limits and ends at the fixed destination.
- **Bend geometry:** Consecutive active legs use different axes, excluding both straight continuation and immediate reversal.
- **Obstacle avoidance:** Each applicable leg–obstacle pair must be separated along at least one axis, allowing non-strict contact at the specified clearance boundary. Special exemptions apply to the associated nozzle equipment boxes.
- **Support membership:** Intermediate indexed nodes must lie in at least one support zone. Vertical membership is checked at the pipe’s bottom, while horizontal membership uses the centerline. These requirements also apply to intermediate nodes belonging to inactive trailing legs.
- **Flexibility:** For each coordinate direction, the sum of cubed leg lengths in the other two directions must dominate a coefficient times each corresponding leg length.

The source also contains inter-pipe clearance constraints, but these generate no pairwise restrictions for this single-pipe instance. It does not impose self-intersection avoidance between legs of the same pipe.

### Objective

The model minimizes the sum of:

1. Total pipe length;
2. A bend-related charge for each active leg after the first;
3. Support charges at intermediate active nodes.

The original scaling is retained: coefficients are integer-divided by 100 and then increased by one. Thus, the length coefficient is 161, the bend coefficient is 1601, and the default support coefficient is 51. Preferred rack levels have a support coefficient of 1.

## 3. Reformulation and its justification

### Signed directional-length formulation

Each leg now has positive and negative direction indicators and associated nonnegative lengths for each axis. Their indicators sum to the original existence flag, so an active leg selects exactly one signed axis. Coordinate differences become linear equations:

\[
x_{i+1,k}-x_{i,k}=L^+_{i,k}-L^-_{i,k}.
\]

The original coordinate-wise length is \(L^+_{i,k}+L^-_{i,k}\), and the original direction code is recovered by a linear weighted sum of the indicators.

**Why this is valid:** In the original formulation, the bounding-box inequalities and length equation imply that a leg’s length is at least the absolute coordinate difference. The selected direction supplies the reverse inequality, forcing equality. Unselected axes have zero length and therefore zero displacement. The new equations express precisely these consequences, rather than relying on multiple implications.

The radius-expanded bounding boxes are consequently expressed directly as

\[
x^{\mathrm{lower}}_{i,k}=x_{i,k}-L^-_{i,k}-r,
\qquad
x^{\mathrm{upper}}_{i,k}=x_{i,k}+L^+_{i,k}+r.
\]

The original geometry variables remain available under their original names.

### Direction-dependent bound tightening

Signed lengths are bounded using both the original leg-length limits and the endpoint coordinate domains. For example, a positive displacement cannot exceed the next node’s coordinate upper bound minus the current node’s coordinate lower bound.

**Why this is valid:** These bounds follow directly from the coordinate-difference equation and the declared coordinate domains. Initial and last-possible legs additionally use their original nozzle-length upper bounds. No restriction is inferred from an unverified incumbent or assumed route shape.

### Exact finite-domain encoding of cubic flexibility

The nonlinear cubic expressions are replaced by a finite-domain MILP encoding of total leg length. Binary selectors identify a length value, and the corresponding cubic contribution is assigned to the selected axis.

**Why this is valid:** The route geometry permits at most one nonzero coordinate-wise length per leg. Therefore, the cube of the total leg length equals the cube on its selected axis, while the other two contributions are zero.

To reduce the number of length states, the encoding uses **saturation preprocessing**. Let \(M\) bound every coefficient-times-length requirement in the flexibility constraints. Each cubic contribution \(c\) can be replaced by \(\min(c,M)\).

For nonnegative contributions and a requirement \(R\le M\),

\[
\sum_j c_j\ge R
\quad\Longleftrightarrow\quad
\sum_j\min(c_j,M)\ge R.
\]

If no contribution exceeds \(M\), nothing changes. If one does, its capped value alone satisfies the requirement. Conversely, capped contributions never exceed the original contributions.

In this instance, the maximum flexibility coefficient is 3008, giving \(M=3008\times380=1{,}143{,}040\). Cubes reach this bound at length 105. Lengths of 105 or more therefore share a saturated state, with an integer excess variable retaining their exact actual length. This is an exact feasibility reformulation, not a piecewise-linear approximation.

### Linearization of support charges

Products involving an existence flag and a support-membership flag are replaced by Boolean conjunctions.

**Why this is valid:** Both factors are binary, so their product equals one exactly when both are one. Distributing the original support-cost expression over these conjunctions preserves every support charge, including zero charges for inactive legs.

### Redundant displacement cuts

For each axis, the model explicitly requires total routed length on that axis to be at least the absolute endpoint displacement.

**Why this is valid:** Summing coordinate differences along the connected route telescopes to the endpoint displacement. The triangle inequality then gives the stated lower bound. These cuts do not remove feasible routes; they expose a necessary aggregate condition to the solver.

### Preservation and mapping

The final model preserves the original fixed data, obstacle exceptions, support requirements, objective coefficients, and minimization direction. Original independent variables are retained. The accompanying mapping script copies those variables, restores fixed endpoint values if omitted from solver output, and excludes reformulation-specific auxiliaries.

The changes are intended to provide HiGHS with explicit linear relationships and a compact exact encoding of flexibility. No measured runtime improvement is claimed here.

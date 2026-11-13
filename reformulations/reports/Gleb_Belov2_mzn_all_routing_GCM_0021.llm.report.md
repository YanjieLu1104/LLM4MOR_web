## Background and application

The model represents **three-dimensional industrial pipe routing** between two fixed nozzle connections. Coordinates are integer multiples of 200 mm. A route must avoid equipment modules and existing pipe segments, respect prescribed nozzle directions and connection lengths, and place its intermediate nodes within permitted support regions.

The instance contains one pipe represented by 10 nodes, giving nine potential connecting legs. Legs are axis-aligned, and consecutive active legs must use different coordinate axes. Shorter routes are represented by an active prefix followed by zero-length legs at the destination.

The model also imposes engineering flexibility conditions involving sums of cubed leg lengths. These appear intended to ensure sufficient flexibility for the displacement between the nozzle connections. The reformulation preserves these conditions algebraically; it does not reinterpret their engineering validity.

## Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-bound coordinates**, representing lower and upper corners of each leg’s bounding box.
- **30 nonnegative directional leg lengths**, bounded above by 380.
- **10 direction variables**, with values identifying inactivity or one of six signed coordinate directions.
- **20 binary-valued integer flags**, recording leg existence and the last active leg.
- An integer objective variable.

The leg arrays include a tenth, non-leg entry that is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint families are:

1. **Geometry and direction:** A leg connects adjacent nodes, moves along at most one axis, and has positive length when active. Its bounding box includes the pipe radius.
2. **Route sequencing:** Exactly one leg is marked last. The first three legs exist, and active legs form a prefix.
3. **Nozzle connections:** The first and last active legs have specified directions and length limits.
4. **Bends:** Consecutive active legs cannot use the same axis, excluding both straight continuation and immediate reversal.
5. **Obstacle avoidance:** Each relevant leg must be separated from each obstacle along at least one coordinate. Specific exceptions permit connections inside the endpoint modules.
6. **Support requirements:** Every intermediate node indexed by a potential leg must belong to a support zone, including nodes belonging to the inactive suffix. Preferred rack levels affect support cost.
7. **Flexibility:** For each coordinate, every leg length along an orthogonal axis is bounded by a coefficient times the sum of cubed orthogonal lengths.

The source also defines inter-pipe separation constraints. They generate no restrictions in this instance because there is only one pipe.

### Objective

The model **minimizes total scaled routing cost**, combining pipe length, bends, and supports. The original scaling is retained: each relevant cost coefficient is divided by 100 using integer division, then increased by one. Consequently, the pipe-length coefficient is 61 and the bend coefficient is 601. Support costs also depend on preferred-level membership.

## Reformulation and validity

### 1. Linear signed-displacement formulation

Each leg and coordinate receives nonnegative positive and negative displacement variables, activated by direction binaries. Node displacement is their difference, and leg length is their sum.

This is equivalent to the original geometry. Originally, the bounding-box constraints imply that a directional length is at least the absolute endpoint displacement. The selected-direction constraint supplies the reverse inequality, while unselected coordinates have zero length. Together, these force the bounding box to coincide with the endpoint extrema, expanded by the radius.

The replacement expresses those equalities directly. Direction-specific upper bounds come from the endpoint coordinate domains and the original maximum leg length. They therefore exclude no feasible movement and provide tighter linear bounds for HiGHS.

### 2. Bound-based obstacle preprocessing

Obstacle disjunctions are simplified using guaranteed coordinate bounds:

- If a leg is separated from an obstacle throughout its entire possible coordinate range, that obstacle constraint is redundant.
- If a particular separation alternative cannot hold anywhere within that range, that alternative is removed.

These tests use conservative bounds on the leg’s lower and upper corners, including radius and safety distance. Thus, preprocessing removes only guaranteed truths or impossible alternatives. The endpoint-module exceptions remain unchanged.

### 3. Exact bounded reformulation of cubic flexibility

For a fixed orthogonal group, the original flexibility constraints have the form

\[
C\ell_j \leq \sum_i \ell_i^3
\qquad\text{for every participating }j.
\]

Let \(C_{\max}\) be the largest derived coefficient and choose

\[
H=\left\lceil\sqrt{C_{\max}}\right\rceil.
\]

For this instance, \(H=22\). The reformulation replaces each participating length **within these constraints only** by

\[
\widehat{\ell}_i=\min(\ell_i,H).
\]

This preserves feasibility:

- If every length is below \(H\), the constraints are unchanged.
- Otherwise, let \(M=\max_i\ell_i\geq H\). Since \(M^2\geq H^2\geq C\),
  \[
  \sum_i\ell_i^3\geq M^3\geq CM\geq C\ell_j.
  \]
  Hence the original constraints automatically hold. The capped constraints also hold because their right-hand side contains at least \(H^3\), while every left-hand side is at most \(CH\leq H^3\).

Threshold binaries \(b_{it}\leftrightarrow(\ell_i\geq t)\), for \(t=1,\ldots,H\), then encode the capped values exactly:

\[
\widehat{\ell}_i=\sum_{t=1}^{H}b_{it},
\qquad
\widehat{\ell}_i^3
=\sum_{t=1}^{H}(3t^2-3t+1)b_{it}.
\]

The second identity follows from \(t^3-(t-1)^3=3t^2-3t+1\). This replaces general variable powers with linear expressions over only 22 thresholds per length. Threshold-ordering inequalities are redundant consequences of their definitions and strengthen the explicit formulation.

### 4. Boolean support-cost linearization

Products between leg-existence flags and support indicators are replaced by Boolean conjunctions.

This is exact because the factors are binary: \(ab=1\) precisely when both indicators are true. Distributing the original support-cost expression over its indicators therefore preserves every cost contribution while avoiding general integer multiplication.

### 5. Endpoint-distance inequalities

For each coordinate, the reformulation adds

\[
\sum_{\text{legs}}\ell_{\text{leg},k}
\geq
\left|x_{\text{destination},k}-x_{\text{source},k}\right|.
\]

These inequalities follow from the triangle inequality applied to consecutive node displacements. They are valid redundant constraints that expose a global route-length bound to the solver.

## Interface and expected effect

All original independent variables remain represented, and the mapping script returns only those variables. It can restore omitted fixed endpoint coordinates from the unchanged embedded instance data. Original indices, objective values, and minimization direction are preserved.

The main expected benefit is a more explicit mixed-integer linear formulation, especially the removal of general cubic expressions. Bound preprocessing and redundant inequalities provide additional opportunities for presolve and stronger relaxations. No measured runtime improvement is established by the supplied conversation.

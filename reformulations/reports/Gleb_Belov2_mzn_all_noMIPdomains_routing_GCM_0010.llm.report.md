# Reformulation Report: Three-Dimensional Industrial Pipe Routing

## 1. Background and interpretation

The model represents the routing of a pipe between two fixed connection points in a three-dimensional industrial installation. This interpretation follows from its nozzle coordinates, pipe diameter, equipment boxes, support zones, rack levels, and flexibility coefficients.

The instance contains one pipe represented by ten ordered nodes, giving nine possible connecting legs. Each nonzero leg follows a coordinate axis. Unused trailing legs have zero length, allowing the model to choose a route with fewer than nine legs.

The route must:
- Connect the fixed endpoints with prescribed nozzle directions and bounded nozzle-leg lengths.
- Avoid equipment and existing pipe obstacles, accounting for the modeled pipe radius and safety clearances.
- Place intermediate nodes in permitted support zones.
- Satisfy a cubic, length-based flexibility criterion.

Preferred rack levels offer cheaper support. Although the data include a flag suggesting required rack traversal, the corresponding constraint is commented out in the original model; the reformulation does not activate it. Likewise, the original model does not prohibit intersections between nonadjacent legs of the same pipe.

## 2. Original mathematical structure

### Variables

The original model declares **151 independent integer variable entries**, before presolve:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each of ten nodes; six endpoint coordinates are fixed |
| Leg bounding-box coordinates | 60 | Lower and upper corners of radius-expanded leg boxes |
| Coordinate-wise leg lengths | 30 | Nonnegative lengths along each axis |
| Leg directions | 10 | Zero for an unused leg; six signed coordinate directions otherwise |
| Leg-existence indicators | 10 | Whether a leg is active |
| Last-leg indicators | 10 | Which active leg terminates the route |
| Objective variable | 1 | Total scaled routing cost |

The leg arrays include a tenth, inactive entry fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint families are:

1. **Geometry and direction.** Leg boxes enclose both endpoint nodes and include the modeled radius. Direction constraints force exactly one coordinate to change on an active leg and enforce a minimum length.

2. **Route sequencing.** Active legs form a prefix, at least three legs exist, and exactly one is the last leg. Consecutive active legs use different axes, excluding straight continuations and immediate reversals.

3. **Nozzle connections.** The first and last active legs have specified directions and length limits. The last active leg ends at the fixed destination.

4. **Obstacle clearance.** Each relevant leg box must be separated from each obstacle along at least one axis. Specific exceptions permit connections through the designated endpoint modules.

5. **Support membership.** Intermediate nodes must lie in at least one support region. Membership uses the node center horizontally and the pipe bottom vertically.

6. **Flexibility.** For each coordinate axis, the sum of cubed leg lengths in the other two axes must exceed a coefficient times each individual length in those axes. Coefficients depend on endpoint displacement, unit conversion, and the supplied flexibility parameter.

Inter-pipe separation constraints are also present structurally, but generate no pairwise restrictions for this single-pipe instance.

### Objective

The model **minimizes** the sum of scaled pipe-length costs, active-leg bend charges, and support costs. The original integer scaling—including division by 100 followed by addition of one—is preserved exactly.

## 3. Reformulation and validity

### Disaggregated signed lengths

Each coordinate-wise leg length is split into nonnegative positive- and negative-direction components, controlled by binary direction indicators. Their difference equals the endpoint displacement, and their sum equals the original length.

This is equivalent to the original geometry. The original bounding-box constraints imply
\[
L\ge |x_{\mathrm{end}}-x_{\mathrm{start}}|.
\]
The selected-direction constraint supplies the reverse inequality with the appropriate sign; unselected axes have zero length. Consequently, the original model already forces equality and exact radius-expanded leg boxes.

The new formulation expresses these relationships directly with linear equations and indicator-scaled bounds, rather than relying on several interacting implications.

### Bound tightening and obstacle preprocessing

Coordinate-domain bounds yield valid upper bounds on endpoint displacement. These are intersected with the original general and nozzle-specific length limits.

An obstacle test is removed only when endpoint bounds prove that **every possible radius-expanded leg box** lies entirely on one side of that obstacle, including its safety distance. Such a disjunction is already true for every feasible assignment. No obstacle is removed merely because it appears unlikely to affect a good route.

### Exact saturation of flexibility lengths

Write one flexibility group as
\[
S=\sum_j L_j^3,\qquad S\ge C L_j\quad\text{for every }j,
\]
where \(j\) ranges over legs and axes orthogonal to the coordinate being tested.

The reformulation chooses
\[
T=\max\!\left(1,\left\lceil\sqrt{C_{\max}}\right\rceil\right),
\]
and replaces lengths **within the flexibility tests only** by \(\widehat L_j=\min(L_j,T)\).

This preserves feasibility:

- If every relevant length is below \(T\), nothing changes.
- Otherwise, let \(M=\max_j L_j\ge T\). The original inequalities hold because
  \[
  \sum_j L_j^3\ge M^3\ge CM\ge CL_j.
  \]
  The capped inequalities also hold because one capped length equals \(T\), so
  \[
  \sum_j\widehat L_j^3\ge T^3\ge CT\ge C\widehat L_j.
  \]

Actual routing lengths, geometry, and costs remain uncapped. This instance-specific algebraic reduction substantially reduces the numeric range needed for the nonlinear terms.

### Exact binary linearization of cubes

Each capped integer length is represented in binary. Its square and cube are constructed using auxiliary products of a binary digit with a bounded integer quantity.

Each product is enforced by standard exact binary–bounded-variable linearization inequalities. Thus the resulting formulation is a mixed-integer linear model suitable for HiGHS, not a piecewise approximation of the flexibility criterion.

### Support-cost linearization and valid cuts

Products involving leg existence and support membership are replaced by Boolean conjunction indicators. This is exact because the factors are binary.

The model also adds coordinate-wise endpoint-distance cuts:
\[
\sum_{\ell}L_{\ell,k}\ge
\left|x_{\mathrm{destination},k}-x_{\mathrm{origin},k}\right|.
\]
These follow from the triangle inequality applied to consecutive node displacements. They cannot exclude a feasible route and may strengthen the linear relaxation.

## 4. Preservation and expected impact

The reformulation retains the original independent variables, endpoint-module exceptions, support requirements, objective values, and minimization direction. The mapping script filters auxiliary outputs and restores fixed endpoint coordinates when omitted by the solver.

The intended benefits are tighter routing relaxations, fewer unnecessary obstacle tests, and an explicit exact linear treatment of flexibility. No solver timing comparison was provided, so these are structural improvements rather than a measured speedup.

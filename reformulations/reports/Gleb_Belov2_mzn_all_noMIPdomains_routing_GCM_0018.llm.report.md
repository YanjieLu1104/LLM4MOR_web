## Background and application

The instance models **three-dimensional industrial pipe routing** between two fixed nozzles. Coordinates are integer-valued, with one unit representing **200 mm**. The route must consist of axis-aligned straight segments and avoid equipment and existing pipework while respecting pipe radius and safety clearance.

The environment also contains support zones and preferred rack levels. Intermediate routing nodes must lie in a support zone, and preferred levels reduce support costs. A flexibility requirement uses sums of cubed segment lengths to represent the ability of perpendicular pipe runs to accommodate displacement. This interpretation follows from the model’s comments and equations; the file does not provide a full engineering derivation.

Although a parameter indicates routing through a rack, the corresponding constraint is commented out in the original model. The reformulation does **not** activate that requirement.

## Original formulation

### Variables and route representation

There is one pipe with ten ordered nodes and nine candidate connecting legs. The independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-boundary entries**, describing radius-expanded lower and upper corners.
- **30 nonnegative integer length entries**, one per coordinate and leg-array position.
- **10 direction variables**, using zero for an absent leg and six codes for signed coordinate directions.
- **20 binary integer flags**, indicating leg existence and the final active leg.
- **One integer objective variable**.

The leg arrays include a tenth, nonconnecting position, which is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and orthogonal sums of cubed lengths.

### Constraints

The formulation enforces:

1. **Axis-aligned geometry:** each active leg moves along exactly one coordinate, with bounds incorporating the pipe radius.
2. **An active prefix of legs:** at least the first three legs exist, exactly one leg is designated last, and subsequent legs have zero length.
3. **Nozzle connections:** the first and final active legs have prescribed directions and nozzle-specific length bounds. The general minimum active-leg length also applies.
4. **Perpendicular consecutive legs:** adjacent active legs cannot use the same coordinate axis.
5. **Obstacle clearance:** each leg must be separated from each applicable obstacle along at least one coordinate. Specified nozzle-module exceptions are retained.
6. **Supported nodes:** intermediate nodes must lie in a support zone, evaluated at the pipe bottom vertically and at its center horizontally. These requirements also apply to the original model’s inactive intermediate-node positions.
7. **Flexibility:** for each relevant coordinate, a constant coefficient times any perpendicular leg length must not exceed the sum of cubes of all perpendicular leg lengths.

The source contains inter-pipe clearance constraints, but they generate no comparisons in this single-pipe instance. It does not impose self-clearance between nonadjacent legs of this pipe.

### Objective

The model **minimizes** a weighted sum of total pipe length, active bends, and support costs. It uses the original integer scaling rule—division by 100 followed by adding one—not unscaled monetary costs. The reformulation preserves these coefficients and the optimization direction.

## Reformulation and validity

### 1. Disaggregated signed-length geometry

Each leg-coordinate pair receives positive and negative direction indicators and corresponding nonnegative lengths. Their difference gives coordinate displacement, while their sum gives the original length. Exactly one signed direction is selected for an active leg.

This is equivalent to the original geometry. Originally, the boundary constraints imply that length is at least the absolute endpoint displacement. The selected-direction constraint supplies the opposite inequality, making them equal. On every unselected axis, length is zero, which forces equal endpoint coordinates. The radius-expanded boundaries are consequently determined exactly.

The new formulation expresses these relationships directly through linear equations and indicator-dependent bounds. Directional upper bounds additionally use endpoint coordinate domains: a positive displacement cannot exceed the next endpoint’s upper bound minus the current endpoint’s lower bound. These bounds strengthen the formulation without excluding feasible routes.

### 2. Exact capped representation of cubic flexibility

Let \(C_k\) be the original flexibility coefficient for coordinate \(k\), let \(C_{\max}=\max_k C_k\), and choose
\[
T=\max\!\left(1,\left\lceil\sqrt{C_{\max}}\right\rceil\right).
\]
The reformulation replaces each length \(l\), **only within the flexibility constraints**, by \(\min(l,T)\), on both sides of those inequalities.

To see why this is exact, consider the perpendicular lengths for one coordinate and let their maximum be \(M\):

- If \(M<T\), every length and cube is unchanged.
- If \(M\ge T\), the original inequalities hold automatically because
  \[
  \sum_j l_j^3\ge M^3\ge C_kM\ge C_kl_i
  \]
  for every perpendicular length \(l_i\). The capped inequalities also hold automatically: one capped cube contributes \(T^3\), while every capped right-hand requirement is at most \(C_kT\le T^3\).

Thus the capped and original flexibility systems accept exactly the same routes. Actual lengths remain unchanged in geometry and the objective.

A one-hot selection represents each active leg’s capped length and its exact cube. One selection vector suffices per leg because the geometry permits only one nonzero coordinate length. Values inconsistent with minimum lengths or nozzle-specific upper bounds are fixed out. This removes variable cubic expressions and bounds the resulting coefficients for a linear mixed-integer backend.

### 3. Direct obstacle disjunctions

Obstacle separation is expressed directly as a disjunction of six linear inequalities: either side of each of the three axes.

The original per-axis separation arrays were defined expressions, not independent choices. Substituting their definitions into the required disjunctions preserves the obstacle conditions and nozzle exceptions while avoiding an unnecessary intermediate Boolean layer.

### 4. Boolean-linear support costs

Products involving leg existence and support classification are replaced by weighted Boolean conjunctions. For binary quantities \(a\) and \(b\), their product equals the indicator of \(a\land b\).

The reformulation retains the original support-zone membership definitions and the bounded “not in a preferred level” variable. Consequently, it preserves both support eligibility and the original restriction implicit in that variable’s domain. No assumption about preferred zones being disjoint is needed.

### 5. Valid total-length inequalities

Two families of redundant inequalities strengthen the formulation:

- **Coordinate displacement bounds:** total length along an axis is at least the absolute difference between fixed endpoint coordinates. This follows from the triangle inequality applied to consecutive displacements.
- **Orthogonal flexibility bounds:** when fixed endpoint displacement guarantees positive total perpendicular length \(S\), the formulation imposes
  \[
  S\ge\left\lceil\sqrt{C_k}\right\rceil.
  \]
  Indeed, with maximum perpendicular length \(M>0\), the original flexibility constraints give
  \[
  C_kM\le\sum_j l_j^3\le M^2S.
  \]
  Hence \(C_k\le MS\le S^2\), proving the bound.

These are valid inequalities, not additional engineering requirements.

## Interface and expected effect

All original independent variables retain their names, index domains, and meanings. The mapping script returns only those variables, restoring omitted singleton endpoint coordinates from the original fixed data and obtaining the objective from the emitted variable or solution objective field.

The changes target a more explicit, bounded linear mixed-integer formulation suitable for HiGHS. They are intended to improve compilation and optimization behavior; no measured speedup or solver benchmark was established in the conversation.

## Background and interpretation

The model represents **three-dimensional pipe routing in an industrial facility**. A pipe must connect two fixed nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by right-angle bends. Coordinates use a discrete length unit of **200 mm**.

The supplied instance contains one pipe, ten ordered route nodes, and therefore nine candidate legs. The endpoints are fixed at \((210,83,52)\) and \((55,114,80)\). Intermediate nodes are bounded integer coordinates. Fixed boxes describe obstacles, support zones around modules, a pipe rack, and preferred rack support levels.

The model allows fewer than nine nonzero legs: unused legs form a trailing suffix of zero-length segments. It does not prohibit intersections between legs of the same pipe. Although the data include a flag requesting passage through a rack, the corresponding constraint is commented out in the original model and was not activated.

## Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two \(10\times3\) integer arrays for the lower and upper corners of leg bounding boxes.
- A \(10\times3\) array of nonnegative coordinate-wise leg lengths.
- Ten direction variables, taking values from 0 to 6: absent, three positive directions, and three negative directions.
- Ten binary leg-existence variables and ten binary last-leg indicators.
- An integer objective variable.

The tenth position in each leg array is a dummy entry, fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The main constraint groups are:

1. **Route geometry.** Each existing leg moves along exactly one coordinate axis. Its bounding box includes the pipe radius. Consecutive existing legs must use different axes.
2. **Leg sequence.** At least three legs exist. Existence indicators form a prefix, with exactly one last existing leg.
3. **Nozzle connections.** The first leg follows the prescribed outgoing direction; the last existing leg follows the prescribed incoming direction and terminates at the destination. Both have additional length restrictions.
4. **Obstacle avoidance.** Each relevant obstacle and leg must be separated along at least one coordinate axis, including safety clearance. Specific exceptions allow connection to the source and destination modules.
5. **Support requirements.** Every intermediate candidate node must belong to a support zone, using the node center horizontally and the pipe bottom vertically. This requirement applies even to intermediate nodes associated with unused trailing legs.
6. **Conditional physical constraints.** The source includes inter-pipe separation and flexibility constraints, but neither is active in this instance.

### Objective

The model minimizes the sum of pipe-length, bend, and support costs. It uses the original coefficient transformation
\[
c'=\left\lfloor c/100\right\rfloor+1.
\]

Thus, pipe length costs **131 per discrete unit**, each existing leg after the first contributes **1,301** in bend cost, and a charged support costs **51 outside preferred rack levels** or **1 within a preferred level**. The reformulation preserves these transformed coefficients exactly.

## Reformulation and validity

### 1. Disaggregated linear representation of leg directions

The direction implications were replaced by positive and negative direction indicators and corresponding nonnegative lengths for each axis. For consecutive node coordinates \(x_i,x_{i+1}\),
\[
x_{i+1}-x_i=\ell^+-\ell^-,
\qquad
L=\ell^++\ell^-.
\]
The sum of the six direction indicators equals the leg-existence indicator. Each directional length is bounded above by its indicator times a valid maximum and below by its indicator times the original minimum length.

**Why this is equivalent:** In the original model, bounding-box containment implies \(L\ge |x_{i+1}-x_i|\). The selected-direction implication supplies the reverse inequality, while unselected axes have zero length. Consequently, each original feasible leg already has exactly the signed displacement and length represented by these equations. The new formulation exposes that structure directly to the MILP solver.

The original direction, length, bounding-box, and sequence variables remain present.

### 2. Exact bounding-box equations and tighter bounds

The leg-box coordinates now satisfy
\[
B_{\min}=x_i-\ell^- -r,
\qquad
B_{\max}=x_i+\ell^+ +r,
\]
where \(r\) is the pipe radius.

**Why this is valid:** Once the original constraints force length to equal absolute displacement, the containing box cannot have any extra width: its width is already constrained to equal the leg length plus twice the radius. Its ends must therefore be the endpoint minimum minus the radius and endpoint maximum plus the radius.

Endpoint coordinate domains also give tighter bounds on these box ends and on each directional displacement. No feasible original leg can exceed those bounds.

### 3. Bound-based obstacle preprocessing

An obstacle–leg constraint is omitted only when the endpoint domains prove separation for every possible position of that leg. For example, if an obstacle’s upper face plus clearance lies below a guaranteed lower bound on the leg box, separation is automatic.

**Why this is valid:** The original avoidance constraint is a disjunction of axis-separation conditions. If one condition is always true from valid coordinate bounds, the entire constraint is redundant. All other obstacle checks and nozzle-module exceptions remain enforced.

### 4. Boolean reformulation of support costs

The original support cost multiplies a leg-existence variable by a sum of support-category charges. This was rewritten as a weighted sum of Boolean conjunctions, such as “leg exists and node is outside preferred levels.”

**Why this is equivalent:** For binary indicators \(a,b\), their product equals the indicator of \(a\land b\). Distributing the existence factor across the original cost expression therefore preserves the cost exactly. The original support-membership definitions and the binary domain of the non-preferred indicator remain in place.

### 5. Removal of inactive constraint machinery

- **Inter-pipe separation:** Every node belongs to the same pipe, so the original constraint generator has no qualifying pair of different pipes.
- **Flexibility:** The sole flexibility coefficient is zero. The original conditional expressions therefore produce zero flexibility sums and impose no flexibility restrictions.

These reductions follow directly from the supplied data; they do not remove active physical restrictions.

### 6. Valid route-length inequality

A redundant lower bound strengthens the formulation:
\[
\sum_{i,k}L_{i,k}
\ge
\|x_{\mathrm{end}}-x_{\mathrm{start}}\|_1
+2L_{\mathrm{first},X}.
\]

**Why this is valid here:** The endpoint Manhattan distance is \(214\). The first leg must move in positive X, although the destination lies in negative X relative to the source. Every unit of that initial movement must subsequently be undone, adding two units to the minimum total travel. Hence the bound is \(214+2L_{\mathrm{first},X}\).

The implementation derives this inequality from endpoint bounds only when those bounds are singleton values. This also avoids the compilation error caused by applying `fix` to an expression not recognized as fixed during evaluation.

## Solution interface and expected effect

The mapping script returns all original independent variables, excludes new auxiliaries, and restores fixed endpoint coordinates from their original singleton domains if they are not emitted by the solver.

The changes aim to improve HiGHS performance through explicit linear geometry, tighter bounds, fewer redundant obstacle disjunctions, and a stronger length relaxation. **No measured runtime improvement is established by the conversation.**

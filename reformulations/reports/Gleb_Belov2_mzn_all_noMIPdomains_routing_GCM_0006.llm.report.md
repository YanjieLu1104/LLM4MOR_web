# Pipe-Routing Model and Reformulation Report

## 1. Real-world background

The model represents the routing of an industrial pipe between two fixed nozzle connections in a three-dimensional plant layout. Coordinates are integer multiples of a **200 mm length unit**.

The route uses axis-aligned straight segments joined by orthogonal bends. Fixed boxes represent equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. The model balances construction cost against geometric and mechanical requirements:

- clearance from equipment and existing pipes;
- prescribed nozzle entry and exit directions;
- minimum and maximum segment lengths;
- support-zone membership at intermediate nodes;
- a flexibility requirement involving sums of cubed segment lengths.

The flexibility coefficients depend on the separation between the nozzles and a supplied pipe-specific mechanical factor. The source describes this as a GCM flexibility condition; the model alone does not establish its applicability as a complete engineering design check.

Although the data contain a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation therefore does **not** introduce a mandatory rack visit.

## 2. Original formulation

### Variables and route structure

The instance contains one pipe, ten nodes, and nine possible connecting legs. The original model declares **151 independent integer variables**:

| Variable group | Count | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each node; six endpoint coordinates are fixed |
| Lower and upper leg-box coordinates | 60 | Radius-expanded spatial bounds for each leg |
| Coordinate-wise leg lengths | 30 | Length along each axis |
| Direction, existence, and last-leg indicators | 30 | Route orientation and termination |
| Objective variable | 1 | Total scaled construction cost |

The leg arrays include a tenth, non-leg position whose variables are fixed to zero. Additional defined arrays describe obstacle separation, support membership, and cost expressions.

Existence and last-leg constraints make the active legs a contiguous prefix, containing at least three legs. After the final active leg, zero-length legs repeat the destination node.

### Constraints

The principal constraint families are:

- **Geometry:** Each active leg moves along exactly one coordinate axis. Its bounding box includes the pipe radius.
- **Route sequence:** Exactly one active leg is marked last, and active legs cannot restart after termination.
- **Bends:** Consecutive active legs use different axes, excluding collinear continuation and immediate reversal.
- **Nozzle connections:** The first and last active legs obey prescribed directions and nozzle-length bounds.
- **Obstacle avoidance:** A leg must be separated from each relevant obstacle along at least one axis, with the original nozzle-module exceptions retained.
- **Support:** Intermediate indexed nodes must lie in a support zone, including repeated nodes after early termination. Membership uses the pipe bottom vertically and its center horizontally.
- **Flexibility:** For each coordinate, the sum of cubed lengths in the other two coordinates must dominate a coefficient times every individual orthogonal length.

The source also includes inter-pipe separation constraints. They generate no restrictions for this single-pipe instance.

### Objective

The model **minimizes** scaled pipe-length, bend, and support costs. Each original cost coefficient is divided by 100 using integer division, then increased by one. These exact coefficients—not an approximation to an unscaled monetary objective—are preserved.

## 3. Reformulation and validity

### Saturated finite-domain formulation of flexibility

The main change removes variable cubic expressions from the optimization model.

Write an original flexibility family as

\[
C_k\,\ell_j \leq \sum_{h\in O_k}\ell_h^3
\qquad(j\in O_k),
\]

where \(O_k\) contains the leg-coordinate lengths orthogonal to coordinate \(k\). Choose an integer threshold \(T\) satisfying

\[
T^2\geq \max_k C_k,
\]

and replace each length in these inequalities by \(\widehat{\ell}_j=\min(\ell_j,T)\).

This preserves feasibility exactly:

- If every relevant length is below \(T\), the inequalities are unchanged.
- Otherwise, let \(M\) be the largest relevant original length. Since \(M\geq T\), the original right-hand side is at least \(M^3\geq C_kM\), so all original inequalities hold.
- In the capped system, the right-hand side is at least \(T^3\geq C_kT\), while every capped left-hand side is at most \(C_kT\). Thus all capped inequalities also hold.

Binary selectors encode each capped integer length and its cube through linear sums. A bounded excess term permits the actual length to exceed \(T\) only when the threshold selector is selected. Actual lengths remain unchanged in geometry and cost calculations.

This produces a mixed-integer linear representation suitable for HiGHS without approximating flexibility feasibility.

### Length-domain preprocessing

Selector values are removed when they exceed valid length bounds or represent an impossible positive length.

The bounds follow directly from the original constraints:

- Coordinate domains bound the maximum possible endpoint difference.
- Direction and bounding-box constraints force a leg’s length to equal that difference on its active axis and to be zero elsewhere.
- Nozzle constraints impose tighter bounds on the first and final possible legs.
- Every positive length must satisfy the original general leg-length lower bound.

Consequently, these eliminations cannot remove a feasible original route.

### Linear support costs

Products involving a leg-existence indicator and support membership are replaced by Boolean conjunctions. Because both factors are binary, their product equals the indicator that both conditions hold. The original preferred-level membership restriction and all cost coefficients remain intact.

### Endpoint-distance strengthening

Additional inequalities require total coordinate-wise length, and each remaining route suffix, to cover the corresponding endpoint displacement. These follow from the triangle inequality applied to the original consecutive node differences. They strengthen the relaxation without excluding feasible routes.

### Compilation and solution interface

Calls to `fix` on indexed coordinate expressions were replaced by endpoint parameters derived from the original singleton coordinate domains. Those domains already prescribe the endpoint values, so this repair introduces no new geometric assumption.

The mapping script returns all original independent variables, excludes reformulation auxiliaries, and reconstructs omitted fixed endpoint coordinates from their original singleton values. Required nonconstant solution fields must be present; missing values are reported rather than guessed.

The changes target a smaller and more solver-compatible formulation. No measured runtime improvement is established by the conversation.

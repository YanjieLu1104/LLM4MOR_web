# Rectilinear Pipe Routing with Obstacles, Supports, and Flexibility Requirements

## 1. Application background

The model represents the routing of an industrial pipe between two fixed nozzles in a three-dimensional plant layout. The pipe follows axis-aligned segments and must avoid equipment modules and existing pipework, subject to specified clearances.

The supplied instance contains one pipe, 10 ordered routing nodes, and 168 fixed boxes. Box types distinguish equipment, existing pipe segments, module support zones, a pipe rack, and preferred rack levels. Coordinates are discretized in units of 200 mm. The endpoint coordinates are fixed at `(302, 54, 20)` and `(282, 54, 8)`.

The routing decisions balance pipe length, bends, and support costs. Additional cubic length inequalities represent an engineering flexibility requirement. Their coefficients depend on the endpoint separation, unit conversion, and a supplied pipe-specific factor. This interpretation follows from the model’s structure and comments; the model does not provide a complete physical derivation.

## 2. Original mathematical model

### Variables and route structure

The original model declares:

- **30 integer node coordinates**, of which six endpoint coordinates are fixed.
- **Two 10 × 3 integer arrays** representing lower and upper leg-box coordinates.
- **One 10 × 3 nonnegative integer array** of leg lengths by coordinate.
- **10 direction variables**, with zero denoting an absent leg and six values denoting signed coordinate directions.
- **10 binary existence flags** and **10 binary last-leg flags**.
- An integer objective variable, together with derived membership, separation, support-cost, and flexibility expressions.

There are nine possible connecting legs. The tenth leg-array position is a dummy entry constrained to zero.

### Constraints

**Rectilinear geometry.** Each existing leg has exactly one nonzero coordinate length. Direction constraints determine its sign. Together with the leg-box containment and length equations, they force the leg box to be the exact endpoint bounding box, expanded by the pipe radius.

**Route sequencing.** At least three legs exist. Existence and last-leg equations enforce a contiguous prefix of active legs with exactly one last leg. Consecutive active legs must use different coordinate axes, excluding both straight continuation and immediate reversal.

**Nozzle connections.** The first leg has a prescribed direction and length interval. The dynamically selected last leg has its own prescribed direction and length interval and terminates at the fixed destination.

**Obstacle avoidance.** Each applicable leg–obstacle pair must be separated along at least one coordinate axis. The model includes specific exemptions for the starting module and for the last or absent legs at the destination module. Inter-pipe separation constraints are also present in the general formulation, but their index set is empty for this one-pipe instance. The original model does not impose self-avoidance between this pipe’s nonadjacent legs.

**Support availability.** Internal node positions must belong to a support zone. This requirement also applies to internal node slots associated with absent trailing legs. Preferred rack-level membership determines support cost.

**Flexibility.** For each coordinate axis, every orthogonal leg length must satisfy an inequality of the form

\[
C_k\,\ell_j \le \sum_{h\perp k}\ell_h^3.
\]

Here, \(C_k\) is computed from the fixed nozzle separation and the supplied engineering factor.

### Objective

The model minimizes the original scaled sum of:

- pipe length, with coefficient **481** per length unit;
- active nonfirst legs, with coefficient **4,801**;
- support costs at active internal nodes.

The coefficients include the original integer division by 100 and subsequent addition of one. These operations are part of the objective definition and were preserved.

## 3. Reformulation and justification

### Linear signed-length decomposition

Each coordinate length is represented by nonnegative positive- and negative-direction components, linked to binary direction indicators. Their sum is the original length, and their difference is the endpoint displacement.

This is equivalent to the original geometry. Originally, containment implies that the leg length is at least the absolute endpoint displacement. The selected direction supplies the matching upper bound, forcing equality. Inactive axes have zero length and therefore equal endpoint coordinates. Consequently, the lower and upper leg-box coordinates can be expressed directly using the signed components and radius.

The reformulation exposes these relationships as linear equations and binary–continuous linking inequalities suitable for HiGHS.

### Coordinate-based length bounds

Each coordinate length receives an upper bound derived from the endpoint coordinate domains:

\[
\ell \le
\max\{U_{\text{next}}-L_{\text{current}},
      U_{\text{current}}-L_{\text{next}}\}.
\]

This follows because the original constraints force length to equal absolute displacement. The bound is intersected with the original general or nozzle-specific length limits. Coordinates excluded by a fixed nozzle direction receive a zero bound. No new geometric assumption is introduced.

### Exact capped encoding of flexibility

Variable powers are replaced by a one-hot representation of capped lengths. Let

\[
T=\left\lceil\sqrt{\max_k C_k}\right\rceil,
\qquad
\widehat{\ell}=\min(\ell,T).
\]

For this instance, the largest coefficient is 262, giving \(T=17\). The encoding represents every capped integer length and its cube exactly.

Replacing the flexibility inequalities by

\[
C_k\,\widehat{\ell}_j
\le \sum_{h\perp k}\widehat{\ell}_h^3
\]

preserves feasibility:

- If every relevant length is below \(T\), nothing changes.
- Otherwise, let \(M\ge T\) be the largest relevant original length. Since \(M^2\ge C_k\), its cube satisfies \(M^3\ge C_kM\ge C_k\ell_j\) for every relevant leg. Thus all original inequalities for that axis hold automatically.
- In the capped system, at least one term contributes \(T^3\), which is at least \(C_kT\), while every capped left-hand length is at most \(T\). Thus all capped inequalities also hold automatically.

This is an exact threshold-based reformulation, not an approximation to the cubic function.

### Bound-based obstacle preprocessing

A leg–obstacle constraint is omitted only when endpoint domains prove separation along an axis for every possible position of that leg.

The endpoint bounds and radius bound the entire exact leg box. If this full possible box is already on one side of the obstacle with the required clearance, one disjunct of the original separation constraint is always true. Removing that constraint therefore cannot admit a collision.

All other obstacle constraints and the original module exemptions remain.

### Conditional support costs

The product of a binary existence flag and a support-cost expression is replaced by a conditional expression: use the support cost when the leg exists, and zero otherwise. This is exact because the original existence flag has domain `{0,1}` and avoids a variable-by-variable multiplication.

### Data repair and solution interface

The final repair removed two accidentally inserted entries from the box-size array, restoring the original **504 values**, corresponding to **168 boxes × 3 coordinates**. No original box dimensions were changed.

The original independent decision-variable names are retained. The mapping script copies their solution values, restores the six fixed endpoint coordinates from the unchanged instance data, and excludes reformulation-specific auxiliary variables.

## 4. Expected computational effect

The principal improvement is replacing cubic variable expressions with a small, exact binary-linear encoding. Explicit geometry equations, tighter length bounds, and removal of provably redundant obstacle disjunctions also aim to improve the mixed-integer formulation.

The minimization direction, objective values, and original feasibility requirements are preserved. No solver timing results were supplied, so the performance benefit remains an expectation rather than a measured result.

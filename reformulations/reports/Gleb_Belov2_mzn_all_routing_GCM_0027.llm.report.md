# Pipe-Routing Model and Reformulation

## Real-world background

The model represents routing a single pipe between two fixed connection points in a three-dimensional industrial layout. The layout contains equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels.

The route consists of axis-aligned straight segments joined by bends. It must avoid obstacles with specified clearances, meet prescribed connection directions and lengths at both ends, and place intermediate nodes in suitable support zones. Additional cubic-length inequalities represent an engineering flexibility requirement.

Coordinates are discretized in units of **200 mm**. The model uses an integer radius computed as `diameter div 2`; for this instance, that radius is zero. The reformulation preserves this convention rather than substituting a different physical interpretation.

Although the data include a flag requesting passage through a rack, the associated constraint is commented out in the original source. Neither formulation imposes that requirement.

## Original formulation

### Variables

The route has **10 nodes**, giving 30 integer coordinate variables. Six coordinates fix the two endpoints; the other 24 describe eight intermediate nodes.

There are **nine candidate legs** between consecutive nodes. The leg arrays also contain a tenth, dummy entry fixed to zero. Their independent variables comprise:

- 60 integers for lower and upper leg-box coordinates;
- 30 nonnegative integers for coordinate-wise leg lengths;
- 10 integer direction codes;
- 10 binary existence flags;
- 10 binary last-leg flags.

An additional integer variable, `obj`, represents the objective. Defined arrays provide coordinate views, geometric predicates, support costs, and sums of cubed lengths.

### Constraints

The main constraint families enforce:

- **Axis-aligned geometry:** each existing leg has one signed direction, positive length along its active axis, and zero length along the others.
- **Route continuity and termination:** existing legs form a prefix of the candidate sequence, with exactly one last leg and at least three existing legs.
- **Orthogonality:** consecutive existing legs cannot use the same coordinate axis.
- **Nozzle connections:** the first and last existing legs obey prescribed directions and length bounds.
- **Obstacle clearance:** each applicable leg–obstacle pair must be separated along at least one coordinate axis, subject to specific endpoint-module exceptions.
- **Support membership:** intermediate node indices must lie in at least one support zone. This requirement is not conditional on leg existence.
- **Flexibility:** for each coordinate axis, the sum of cubes of leg lengths along the other two axes must dominate a coefficient times every individual length in that orthogonal collection.

The source also contains inter-pipe separation constraints. They generate no pairwise restrictions here because the instance contains only one pipe.

### Objective

The model **minimizes pipe-length, bend, and support costs**. It uses the original integer-scaled coefficients, including the added unit in expressions of the form `cost div 100 + 1`.

For this instance, the length coefficient is 51 and the bend coefficient is 501. An existing bend incurs support cost 51 outside preferred rack levels and 1 inside a preferred level. The reformulation preserves these values and the minimization direction.

## Reformulation and justification

### 1. Explicit linear representation of leg geometry

The reformulation introduces six directional binaries per leg and nonnegative positive- and negative-direction lengths for each axis. Linear equations connect these quantities to node displacement, total leg length, and leg-box endpoints.

This is equivalent to the original constraints. Originally, the leg box must contain both endpoint nodes, so its length is at least their absolute coordinate displacement. The selected direction imposes the matching upper bound, forcing equality. Inactive axes have zero length and therefore equal endpoint coordinates. Consequently, the leg-box endpoints are already uniquely determined by the nodes, direction, and radius.

The new equations express those implied equalities directly, while linear cardinality constraints encode existence and consecutive-leg orthogonality.

### 2. Data-derived length bounds

Each coordinate-wise leg length receives an upper bound derived from the two endpoint coordinate domains. First- and final-candidate-leg bounds also incorporate the original nozzle limits and permitted axes.

These bounds are valid because the geometry constraints force length to equal absolute endpoint displacement. That displacement cannot exceed the maximum separation allowed by the endpoint domains. Taking the minimum with an existing pipe or nozzle upper bound therefore removes no feasible route.

### 3. Exact saturation of cubic flexibility constraints

Variable cubes are replaced by a bounded discrete linear formulation.

For one flexibility condition, write its nonnegative coefficient as \(A\), its relevant lengths as \(\ell_j\), and the original inequalities as

\[
A\ell_i \leq \sum_j \ell_j^3
\qquad\text{for every relevant }i.
\]

The reformulation derives a common integer threshold

\[
T=\max\!\left(1,\left\lceil\sqrt{\max A}\right\rceil\right)
\]

and represents each capped length \(c_j=\min(\ell_j,T)\) and its cube using discrete selection binaries. It then imposes

\[
Ac_i \leq \sum_j c_j^3.
\]

This replacement is exact:

- **If every relevant length is below \(T\),** nothing changes.
- **If some relevant length reaches \(T\),** the capped right-hand side is at least \(T^3\), while every capped left-hand side is at most \(AT\leq T^3\).
- In that same case, let \(M\) be the largest original relevant length. Since \(M\geq T\), the original right-hand side is at least \(M^3\geq AM\geq A\ell_i\). Thus the original inequalities are also automatically satisfied.

The resulting formulation uses only a short, data-derived range of discrete length values for flexibility, rather than representing cubes over the full geometric length range. The original uncapped lengths remain available for geometry and cost.

### 4. Linearized support costs

Products involving leg existence and support membership are expressed as weighted Boolean conjunctions. This is exact because the factors are binary: their product equals one precisely when both conditions hold.

The preferred-level membership restriction and the original support-zone requirements remain in place.

### 5. Endpoint-displacement cuts

The reformulation adds lower bounds on total length, positive travel, and negative travel along each axis.

These follow from route continuity: summing signed leg displacements telescopes to the fixed endpoint displacement. Total unsigned travel must therefore be at least its absolute value, and directional travel must cover the corresponding signed displacement. These are redundant valid inequalities intended to strengthen the mixed-integer relaxation.

## Solution correspondence

All original independent decision variables are retained. The mapping script copies those variables, excludes reformulation auxiliaries, and restores fixed endpoint coordinates from the original embedded data if they are absent from solver output. It reports missing nonfixed values rather than inventing them.

The reformulation is intended to improve HiGHS performance by exposing linear structure, tightening bounds, and eliminating variable cubic expressions. No measured runtime improvement is established by the supplied conversation.

# Orthogonal Pipe Routing with Support and Flexibility Constraints

## Background

The model represents the routing of a single industrial pipe between two fixed three-dimensional nozzle locations. Coordinates lie on an integer grid with a unit length of **200 mm**. A route consists of axis-aligned straight legs joined by right-angle bends.

The environment contains **83 fixed boxes**, classified as equipment modules, existing pipe legs, support zones, a rack, and preferred rack-support levels. The route must avoid relevant obstacles with diameter-dependent clearance, and intermediate node slots must lie in permitted support zones. Additional constraints use cubed leg lengths to impose a simplified pipe-flexibility requirement.

The source also contains a rack-traversal flag, but the corresponding constraint is commented out. The reformulation does not activate it or add other routing requirements absent from the original.

## Original Model

### Variables and route representation

There are **10 node slots**, represented by 30 integer coordinate variables. Six coordinates fix the two endpoints, leaving 24 intermediate coordinates with non-singleton domains.

The model provides nine potential legs connecting consecutive nodes. Leg arrays contain an additional, tenth bookkeeping entry that is fixed to zero. For each entry, the model declares:

- Three lower and three upper coordinates of a radius-expanded leg box.
- Three nonnegative coordinate-wise lengths.
- A direction code: zero for an absent leg, or one of six signed coordinate directions.
- Binary existence and last-leg indicators.

The original independent declarations therefore contain **151 scalar integer entries**, including fixed entries and the objective variable. Additional defined arrays represent obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint families are:

1. **Geometry and direction.** Leg boxes contain both endpoints, expanded by the pipe radius. Their widths determine leg lengths. Direction implications force movement along one axis and zero movement along the other two.

2. **Route sequence.** Existing legs form a prefix, with exactly one last leg. At least the first three legs exist. Subsequent absent legs have zero length, so their node slots coincide with the final endpoint.

3. **Bends and nozzle connections.** Consecutive existing legs use different axes, excluding both straight continuation and immediate reversal. The first and last legs obey specified nozzle directions and length limits.

4. **Obstacle clearance.** Each applicable leg–obstacle pair must be separated along at least one axis. The model has specific exemptions for the starting module and for terminal or absent legs at the destination module.

5. **Support membership.** Intermediate node slots must belong to at least one support zone. Membership uses the node centre horizontally and the pipe bottom vertically. This requirement also applies to intermediate slots associated with absent legs.

6. **Flexibility.** For each coordinate axis, the sum of cubed lengths along the other two axes must exceed a coefficient times every individual contributing length. Coefficients depend on endpoint separation, grid scale, and the supplied flexibility factor.

Inter-pipe separation constraints are also present in the source, but generate no applicable pairs because this instance contains only one pipe. They do not impose self-avoidance between legs of that pipe.

### Objective

The model minimizes the original scaled integer cost:
\[
201\sum_{\ell,k}L_{\ell k}
+2001\sum_{\ell\text{ not first}}e_\ell
+\sum_{\ell\text{ not first}}s_\ell.
\]

Here, \(e_\ell\) indicates an existing leg and \(s_\ell\) is its associated node-support cost. For this instance, an existing intermediate node costs 51 outside preferred rack levels and 1 inside a preferred level. The scaling and additive adjustments in these coefficients are preserved exactly.

## Reformulation

### 1. Signed displacement formulation

The direction implications were replaced by positive- and negative-direction indicators and corresponding nonnegative displacements for each leg and axis. Their sum equals the leg-existence indicator, so an existing leg selects exactly one signed axis.

For positive and negative displacements \(p_{\ell k}\) and \(m_{\ell k}\), the formulation imposes
\[
x_{\ell+1,k}-x_{\ell,k}=p_{\ell k}-m_{\ell k},
\qquad
L_{\ell k}=p_{\ell k}+m_{\ell k}.
\]

This is equivalent to the original geometry. Originally, endpoint containment implies
\[
L_{\ell k}\ge |x_{\ell+1,k}-x_{\ell,k}|.
\]
The selected direction supplies the reverse inequality with the appropriate sign. An unselected axis has zero length and therefore equal endpoint coordinates. Consequently, the original constraints already force exact signed displacement and exact radius-expanded leg-box endpoints; the reformulation states those relationships directly.

This exposes linear structure to HiGHS while retaining the original direction, length, box, and existence variables.

### 2. Coordinate- and nozzle-based bound tightening

Each coordinate-wise length receives an upper bound derived from:

- The original maximum leg length.
- The maximum possible endpoint difference under the declared coordinate domains.
- The applicable first-leg or last-possible-leg nozzle limit.
- Zero for axes excluded by a fixed nozzle direction or for the non-leg bookkeeping entry.

These bounds are valid because the original constraints force lengths to equal absolute coordinate differences and already impose the nozzle restrictions. Tighter bounds improve both displacement gating and subsequent product linearizations.

### 3. Exact linearization of cubes

The variable expression \(L^3\) was replaced by an exact binary-expansion formulation. Writing
\[
L=\sum_b 2^{b-1}z_b,
\]
the model constructs
\[
Q=\sum_b2^{b-1}(Lz_b),\qquad
C=\sum_b2^{b-1}(Qz_b).
\]
Thus \(Q=L^2\) and \(C=L^3\).

Each binary–integer product is represented by its standard bounded linear formulation. For \(w=xz\), \(0\le x\le U\), and binary \(z\), the constraints are
\[
0\le w,\quad w\le x,\quad w\le Uz,\quad
w\ge x-U(1-z).
\]
They force \(w=0\) when \(z=0\) and \(w=x\) when \(z=1\).

The flexibility conditions therefore retain their exact integer meaning, rather than using a piecewise approximation. Binary weights exceeding a length’s tightened upper bound are fixed inactive.

### 4. Valid inequalities for the power formulation

Additional inequalities strengthen the continuous relaxation. For \(0\le L\le U\),
\[
L^2\le UL,\qquad L^3\le U^2L,\qquad L^3\le UL^2.
\]

Selected tangent inequalities are also added:
\[
L^2\ge 2tL-t^2,\qquad
L^3\ge 3t^2L-2t^3.
\]
These follow from convexity of the square and cube functions on the nonnegative domain. They cannot exclude any original feasible integer length because the power representation is exact.

### 5. Linear support-cost expression

Products involving leg existence and support membership were replaced by Boolean conjunction indicators. This is exact because the original existence and non-preferred-support variables are binary, while preferred-level membership is Boolean. Distributing the original cost expression over these products preserves every support charge.

## Preservation and Expected Effect

All original independent variables are retained, and the mapping script returns only those variables. Fixed endpoint coordinates can be restored from their original singleton domains if omitted from solver output. A transcription error in the box-size array was also corrected to restore the original 249 entries.

The reformulation preserves the original instance data, minimization direction, objective values, support rules, obstacle exemptions, and flexibility conditions. Its intended benefit is a bounded, explicitly linear mixed-integer formulation suitable for HiGHS. It introduces auxiliary variables in exchange for removing nonlinear expressions and strengthening the relaxation; no measured solve-time improvement is established by the conversation.

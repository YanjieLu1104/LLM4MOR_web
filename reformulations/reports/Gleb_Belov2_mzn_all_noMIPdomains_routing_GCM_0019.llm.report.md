## Background and interpretation

This instance models **three-dimensional industrial pipe routing** between two fixed equipment connections. Coordinates are integer multiples of a 200 mm length unit. The pipe must follow axis-aligned straight segments, avoid equipment and existing pipes with prescribed clearance, and place intermediate nodes in permitted support zones.

The fixed geometry distinguishes equipment modules, existing pipe segments, module support zones, a large pipe rack, and preferred rack levels. The model also includes a cubic-length flexibility criterion, apparently intended to ensure sufficient routing flexibility between the connections. This is an algebraic design criterion encoded by the model, rather than a full mechanical simulation.

There is one pipe, represented by ten ordered nodes and at most nine nonzero segments. Unused trailing segments collapse to the destination.

## Original formulation

### Variables

The original model explicitly declares:

- **30 integer node coordinates**, of which six are fixed endpoint coordinates.
- Two segment-boundary arrays containing **60 integer entries** in total.
- A segment-length array containing **30 nonnegative integer entries**.
- **10 direction entries**, **10 existence flags**, and **10 last-segment flags**.
- An integer objective variable.

These arrays include a dummy segment position associated with the final node; its segment variables are fixed to zero. Additional defined expressions represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths. These source-level counts do not describe the number of variables produced by MiniZinc flattening.

### Constraints

The constraints enforce:

1. **Axis-aligned geometry.** Each existing segment moves in exactly one coordinate direction. Its bounding box includes the pipe radius.
2. **A contiguous segment sequence.** Existing segments precede all unused segments, and exactly one segment is marked as last. At least the first three segments exist.
3. **Orthogonal consecutive segments.** Adjacent existing segments cannot use the same axis, excluding both straight continuation and immediate reversal.
4. **Nozzle restrictions.** The first and last segments have prescribed directions and length bounds.
5. **Obstacle clearance.** Segment boxes must be separated from obstacle boxes along at least one axis. Specific exemptions allow connection to the source and destination modules.
6. **Support coverage.** Intermediate node positions must lie in a support zone, using the pipe bottom for vertical membership. This requirement also applies to intermediate nodes belonging to the collapsed trailing sequence.
7. **Flexibility.** For each coordinate axis, the sum of cubed segment lengths in the other two axes must exceed a prescribed coefficient times each individual perpendicular segment length.

The source also contains inter-pipe separation constraints, but these have no applicable pairs in this single-pipe instance.

### Objective

The model **minimizes the sum of pipe-length, bend, and support costs**. Its coefficients use integer division by 100 followed by an addition of one. Consequently, the implemented objective is not simply the physical cost divided by 100; the reformulation preserves the exact implemented arithmetic.

## Reformulation and validity

### Bounded positive and negative segment flows

Direction-dependent length implications were replaced by positive and negative length variables for each segment and coordinate, with binary direction selectors.

The new equations enforce
\[
x_{i+1,k}-x_{i,k}=\ell^+_{i,k}-\ell^-_{i,k},
\qquad
L_{i,k}=\ell^+_{i,k}+\ell^-_{i,k}.
\]

The selectors sum to the segment-existence flag, so an existing segment has exactly one selected direction and an absent segment has none. Selected lengths satisfy the original minimum-length requirement.

This is equivalent to the original geometry: the original bounding-box inequalities imply \(L_{i,k}\geq |x_{i+1,k}-x_{i,k}|\), while the direction implications supply the reverse inequality on the selected axis and force zero length elsewhere. Thus, the original constraints already make length equal absolute displacement. The reformulation expresses that relationship directly and gives the MIP solver explicit bounded linear constraints.

### Tighter component bounds and exact segment boxes

Each component-length upper bound is derived from the largest possible difference between its endpoint coordinate bounds, intersected with the original segment-length limit. First- and last-possible-segment components also use their original nozzle restrictions.

These bounds cannot exclude a feasible route because segment length equals absolute endpoint displacement. The segment-box boundaries are then expressed by
\[
2B^-_{i,k}=x_{i,k}+x_{i+1,k}-L_{i,k}-2r,
\qquad
2B^+_{i,k}=x_{i,k}+x_{i+1,k}+L_{i,k}+2r.
\]
For \(L_{i,k}=|x_{i+1,k}-x_{i,k}|\), these are precisely the minimum and maximum endpoint coordinates, expanded by the pipe radius.

### Exact finite-domain representation of cubes

Variable cubic expressions were replaced by constant-table lookups over bounded integer length domains.

This is an **exact discrete reformulation**, not a piecewise approximation: every admissible integer length maps to its actual cube. It exposes a finite-domain relation suitable for MiniZinc’s MIP translation and the HiGHS backend.

### Support-zone containment preprocessing

A support zone contained in another support zone is removed **only from the disjunction requiring support coverage**. Membership expressions used to calculate preferred-level costs remain intact.

The reduction is valid because membership in the contained box implies membership in its containing box. The vertical pipe-radius adjustment is identical for both zone tests at a given node, so containment remains valid for the pipe-bottom interpretation. Identical zones are handled with a deterministic index tie-break.

### Linear support-cost expressions

Products of an existence flag and a binary support indicator were replaced by Boolean conjunctions with constant cost coefficients. For binary values, multiplication and conjunction have the same truth table, so this preserves the support costs exactly.

### Valid length cuts

Two families of redundant inequalities were added:

- **Endpoint-distance cuts:** total routed length along each axis is at least the absolute endpoint displacement on that axis. This follows from the triangle inequality applied to the segment displacements.
- **Flexibility-derived cuts:** let \(C\) be a flexibility coefficient and let \(S\) be the total length perpendicular to its axis. If the fixed endpoints have nonzero perpendicular displacement, at least one perpendicular component is positive. Writing \(M\) for the largest such component, the original flexibility constraints imply
  \[
  CM\leq \sum_j \ell_j^3\leq M\sum_j\ell_j^2\leq MS^2.
  \]
  Dividing by \(M>0\) gives \(S\geq\lceil\sqrt C\rceil\). The cut is imposed only where the fixed endpoint displacement guarantees this positivity.

## Preservation and expected benefit

All original independent variables retain their names and meanings, and the embedded instance data, objective values, and minimization direction are preserved. The mapping script returns only the original independent variables, reconstructing omitted fixed endpoint coordinates from their original singleton domains.

The changes aim to improve MIP performance through tighter bounds, explicit linear geometry, smaller support-coverage disjunctions, exact discrete nonlinear representations, and stronger valid inequalities. **No measured solve-time improvement is established by the conversation.**

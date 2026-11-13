# Pipe-Routing Model and Reformulation Report

## 1. Application and physical interpretation

The model describes three-dimensional, orthogonal pipe routing through an industrial installation. A single pipe connects two fixed nozzles, located at **(308, 25, 3)** and **(308, 47, 48)** in discretized coordinates. Each coordinate unit represents **200 mm**.

The route contains ten node positions and up to nine nonzero, axis-aligned legs. Fixed boxes represent equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. A feasible route must:

- Maintain the specified clearance from obstacle boxes, with exceptions for entering and leaving the connected equipment.
- Respect nozzle directions and nozzle-leg length limits.
- Turn orthogonally between consecutive nonzero legs.
- Place intermediate nodes in permitted support zones.
- Satisfy an algebraic flexibility condition based on sums of cubed leg lengths.

The flexibility condition appears intended to represent thermal-expansion accommodation: nozzle separation in one coordinate induces requirements on pipe lengths in the other two coordinates. This is an interpretation of the model, not an independent validation of the underlying engineering approximation.

## 2. Original formulation

### Variables and route representation

The original model declares:

- **30 integer node-coordinate variables**, six of which are fixed endpoint coordinates.
- Two **10 × 3 integer arrays** describing lower and upper leg-box boundaries.
- A **10 × 3 nonnegative integer array** of coordinate-wise leg lengths.
- **10 direction variables**, with values encoding an absent leg or one of six signed coordinate directions.
- Two arrays of **10 binary integer variables**, indicating whether a leg exists and whether it is the last active leg.
- An integer objective variable.

The tenth leg entry is a dummy entry fixed to zero. Additional defined expressions represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

**Geometry and directions.** Leg boxes enclose their endpoint nodes, expanded by the modeled pipe radius. Box widths determine leg lengths. Direction-dependent inequalities then force each active leg to move along exactly one coordinate axis and make its modeled length equal to the endpoint displacement on that axis.

**Route sequencing.** The existence and last-leg equations enforce a contiguous prefix of active legs, with at least three active legs. Exactly one leg is marked last. Subsequent zero-length legs collapse the remaining nodes onto the destination. Consecutive active legs cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.

**Clearance.** Each relevant obstacle–leg pair must be separated along at least one coordinate. The source module is exempted for the first leg; the destination module has exemptions for the last and inactive legs. The generic inter-pipe clearance constraints generate no pairs here because the instance contains only one pipe. The model does not impose general self-intersection avoidance.

**Supports.** Intermediate nodes must belong to at least one support zone, including nodes associated with inactive trailing legs. Preferred rack-level membership determines support charges.

**Flexibility.** For each coordinate, a coefficient derived from nozzle separation and the supplied engineering factor multiplies each orthogonal leg length. Every such product must be bounded by the sum of cubes of all orthogonal leg lengths.

### Objective

The model **minimizes** pipe-length charges, bend charges, and support charges. It uses the original integer scaling rule: divide each input cost by 100 and add one. Thus, length has coefficient **61**, and each active leg after the first receives a bend charge of **601**. Ordinary support costs are **51**, while preferred rack-level support costs are **1** in this instance.

These scaled charges—not the unscaled engineering costs—define the objective preserved by the reformulation.

## 3. Reformulation and validity

### Exact reduction of the cubic lookup domain

The principal change replaces variable cubic expressions with a bounded binary lookup formulation suitable for a mixed-integer linear solver.

Let \(C\) be the largest coefficient in the flexibility inequalities, and choose
\[
H=\max\{1,\lceil\sqrt C\rceil\}.
\]
For this instance, \(H=22\). Introduce the capped length
\[
s_j=\min\{\ell_j,H\},
\]
and replace each flexibility inequality
\[
c\ell_j\leq\sum_{r\in S}\ell_r^3
\]
by
\[
cs_j\leq\sum_{r\in S}s_r^3.
\]
Here \(S\) is the collection of leg-coordinate lengths orthogonal to the coordinate being checked, and \(j\in S\).

This replacement preserves feasibility exactly:

- **If every length in \(S\) is below \(H\),** no value changes.
- **Otherwise,** let \(M\) be the largest original length in \(S\). Since \(M\geq H\) and \(H^2\geq C\geq c\),
  \[
  \sum_{r\in S}\ell_r^3\geq M^3\geq cM\geq c\ell_j.
  \]
  Thus every original inequality for that collection is automatically satisfied. The capped collection contains a value \(H\), so likewise
  \[
  \sum_{r\in S}s_r^3\geq H^3\geq cH\geq cs_j.
  \]
  Every replacement inequality is also satisfied.

Binary selectors encode the capped values \(0,\ldots,22\) and their cubes exactly. Linear linking constraints force the original length to equal the selected value below 22 and allow lengths of at least 22 only when the capped value is 22. **Actual route lengths remain unchanged** in geometry and objective calculations.

This is an instance-specific, exact saturation reduction—not a piecewise-linear approximation.

### Linearization of support costs

The original support cost multiplies a binary leg-existence variable by a membership-dependent charge. The reformulation distributes this product and expresses each binary product as a Boolean conjunction:
\[
ab=\mathbf{1}[a=1\land b=1],\qquad a,b\in\{0,1\}.
\]

The original binary domains and support-membership definitions justify this identity. It preserves support costs, including zero cost for inactive legs, while exposing a standard linearizable Boolean formulation.

### Valid displacement inequalities

The reformulation adds lower bounds stating that accumulated route length in each coordinate must cover the corresponding endpoint displacement. Bounds are included for the whole route and for prefixes and suffixes.

These inequalities follow from the original geometry and direction constraints, which imply
\[
\ell_{i,k}=|x_{i+1,k}-x_{i,k}|.
\]
Applying the triangle inequality along any consecutive sequence of legs gives the added bounds. They therefore remove no feasible routes and can strengthen the linear relaxation.

### Simplification and solution interface

Obstacle-separation expressions are used directly rather than retained as full auxiliary Boolean arrays. Their disjunctions and nozzle exceptions remain unchanged. Boundary tests use conditional expressions to avoid out-of-range neighboring-node references.

All original independent decision variables are retained. The mapping script returns those variables, restores any omitted fixed endpoint coordinates from the original singleton domains, and excludes reformulation auxiliaries. The removed cubic-sum arrays were defined expressions, not independent decisions.

The changes aim to reduce nonlinear compilation overhead and strengthen the mixed-integer formulation. No solve-time measurements were supplied, so a performance improvement has not been empirically established.

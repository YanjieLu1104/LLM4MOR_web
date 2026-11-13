# Industrial Pipe-Routing Model and MILP Reformulation

## 1. Application background

The model represents a three-dimensional pipe-routing problem in an industrial installation. A pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by bends.

Coordinates are integer-valued, with one coordinate unit representing **200 mm**. Fixed boxes describe equipment, existing pipes, support zones, a pipe rack, and preferred rack support levels. The pipe has a diameter of two coordinate units; its radius and specified safety distances determine obstacle clearance.

The instance provides **10 route nodes and nine possible legs**. The endpoints are fixed, while intermediate nodes can move within bounded regions. The route may use fewer than nine legs: unused trailing legs have zero length and coincident endpoints.

The model also imposes cubic flexibility conditions involving leg lengths and nozzle separation. These appear intended to represent pipe flexibility or thermal-expansion requirements. Although the input contains a flag indicating passage through a rack, the corresponding constraint is commented out in the original model; the reformulation does not activate it.

## 2. Original formulation

### Decision variables

The original independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two **10 × 3** integer arrays describing lower and upper leg-box boundaries.
- A **10 × 3** nonnegative integer array of coordinate-wise leg lengths.
- Three arrays of length 10 describing direction, existence, and last-leg status.
- An integer objective variable.

The tenth leg-array position is a dummy entry fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

1. **Route geometry:** Each existing leg moves along exactly one coordinate axis. Consecutive existing legs use different axes, preventing immediate straight continuation or reversal.
2. **Route sequencing:** Existing legs form a prefix, the first three legs exist, and exactly one leg is designated as the last.
3. **Nozzle conditions:** The first and last existing legs have prescribed directions and restricted lengths. The last leg terminates at the fixed destination.
4. **Obstacle clearance:** A leg’s radius-expanded bounding box must be separated from each applicable obstacle along at least one axis. Specified exceptions allow connection to the endpoint modules.
5. **Support requirements:** Nodes indexed by non-first actual-leg positions must belong to a support zone. This requirement is not conditional on leg existence and therefore also applies to relevant trailing coincident nodes.
6. **Flexibility:** For each coordinate direction, a coefficient derived from nozzle separation multiplies individual orthogonal leg lengths and is bounded by the sum of their cubes.

The source also defines separation constraints between different pipes. They generate no cross-pipe restrictions for this single-pipe instance.

### Objective

The model **minimizes** a weighted sum of pipe length, bends, and support costs. The original coefficient transformation—integer division by 100 followed by addition of one—is preserved exactly. Thus, the objective is the supplied scaled cost function, rather than an independently reconstructed monetary cost.

## 3. Reformulation and validity

The changes target **HiGHS**, replacing nonlinear integer expressions with an exact mixed-integer linear formulation.

### Direction indicators and signed displacement

Each leg-axis pair receives binary positive- and negative-direction indicators, together with nonnegative positive and negative displacement variables. Their sum gives the original length; their difference gives the coordinate change. Summing the indicators gives leg existence, and a weighted sum reproduces the original direction code.

This is valid because the original direction constraints permit positive length only on the selected axis. The existence–direction equivalence permits no selected direction for an absent leg, while the minimum-length constraints make a selected direction nonzero.

The leg-box boundaries become linear equalities. Originally, the lower boundary cannot exceed either endpoint minus the radius, and the upper boundary cannot be below either endpoint plus the radius. Consequently, the defined length is at least the absolute endpoint displacement. The direction constraints impose the reverse inequality on the selected axis and zero length on other axes. Together, these force the bounding box to be tight, justifying its explicit linear representation.

### Bound tightening and obstacle preprocessing

Displacement upper bounds are tightened using:

- The original maximum leg length.
- The largest possible endpoint difference allowed by coordinate domains.
- The original first- and last-possible-leg nozzle restrictions.

These are all necessary bounds already implied by the original constraints; they introduce no new routing assumptions.

An obstacle-separation expression is replaced by `true` when endpoint domains prove that the entire leg box must lie on one side of the obstacle, including radius and safety distance. Because the original geometry forces a tight leg box, this test establishes separation for every feasible assignment. All other separation expressions and module exceptions remain enforced.

### Exact linearization of cubes

Each bounded integer length is represented in binary:
\[
L=\sum_j 2^j b_j.
\]

Auxiliary variables represent \(b_jL\), giving
\[
L^2=\sum_j2^j(b_jL).
\]
A second set represents \(b_jL^2\), giving
\[
L^3=\sum_j2^j(b_jL^2).
\]

Each binary–bounded-variable product uses the standard exact linearization. For \(z=bx\), \(b\in\{0,1\}\), and \(0\le x\le U\):
\[
0\le z,\qquad z\le x,\qquad z\le Ub,\qquad
z\ge x-U(1-b).
\]

These inequalities force \(z=0\) when \(b=0\) and \(z=x\) when \(b=1\). The cubic flexibility conditions are therefore retained **exactly**, without piecewise approximation. Binary positions exceeding a length’s tightened upper bound are fixed to zero.

### Support-cost linearization and solution mapping

Products of leg existence with support-status indicators are replaced by Boolean conjunctions. This is exact because the original existence and non-preferred-support variables are binary, and preferred-zone membership is Boolean.

All original independent variables remain in the reformulated model. The mapping script copies those variables, excludes added auxiliaries and originally defined expressions, and restores fixed endpoint coordinates from the original declarations if omitted from solver output.

These changes aim to improve MILP compatibility and reduce unnecessary nonlinear or logical processing. No measured runtime improvement is claimed.

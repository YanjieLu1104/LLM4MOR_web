# Orthogonal Pipe Routing with Support and Flexibility Requirements

## Problem background

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, in a three-dimensional plant layout. The route must avoid equipment and existing pipework while placing intermediate nodes in permitted support regions.

Coordinates use a discretized grid with a length unit of **200 mm**. The instance contains one pipe, represented by 10 ordered nodes and up to nine axis-aligned legs. The endpoint coordinates are fixed; intermediate coordinates are optimized.

The model also imposes flexibility conditions based on sums of cubed leg lengths. These appear intended to ensure sufficient routing flexibility relative to nozzle separation and a supplied pipe-specific engineering coefficient. This interpretation follows the model’s terminology and equations; it is not an independent validation of the engineering criterion.

## Original formulation

### Variables and route geometry

The independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-boundary coordinates**, describing lower and upper corners of leg bounding boxes.
- **30 nonnegative integer coordinate-wise leg lengths**.
- **10 integer direction codes**, distinguishing an absent leg from the six signed coordinate directions.
- **10 binary-valued existence flags** and **10 binary-valued last-leg flags**.
- An integer objective variable.

The leg arrays include a padded tenth slot, fixed to zero because there is no node after the tenth node. Additional defined arrays represent obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint families are:

1. **Axis-aligned geometry.** Each existing leg moves in exactly one signed coordinate direction. Its bounding box contains its endpoints and includes the modeled pipe radius.

2. **Route sequencing.** Existing legs form an initial contiguous sequence, with exactly one designated last leg. At least the first three legs exist. Adjacent existing legs use different coordinate axes.

3. **Nozzle restrictions.** The first leg has a prescribed direction and length interval. The designated last leg has its own prescribed direction and length interval and reaches the fixed destination nozzle.

4. **Obstacle clearance.** A leg must be separated from an obstacle along at least one coordinate axis, accounting for the specified clearance. Explicit exceptions allow the appropriate nozzle legs to connect to their associated equipment.

5. **Support membership.** Intermediate nodes must belong to at least one permitted support zone. Preferred rack levels affect support costs. Importantly, these membership requirements also apply to intermediate nodes associated with unused trailing leg slots.

6. **Flexibility.** For each coordinate axis, the sum of cubed lengths in the other two directions must dominate a coefficient times every individual length in those directions.

There are also constraints for separation between different pipes, but they have no applicable pairs in this one-pipe instance. The source’s proposed requirement to pass through a rack is commented out and therefore is not enforced.

### Objective

The model minimizes the original scaled sum of:

- Pipe length costs.
- Bend costs, charged for existing legs after the first.
- Support costs at the corresponding nodes.

The integer coefficient transformation—division by 100 followed by addition of one—is preserved exactly. The reformulation does not replace this objective with an unscaled engineering-cost interpretation.

## Reformulation and justification

### Exact positive/negative displacement formulation

For each leg and coordinate, the reformulation introduces nonnegative positive and negative displacements, \(p\) and \(m\), and imposes
\[
x_{\mathrm{next}}-x_{\mathrm{current}}=p-m,
\qquad
L=p+m.
\]
Direction indicators allow only the appropriate displacement to be positive. The leg boundaries are then
\[
X_{\min}=x_{\mathrm{current}}-m-r,
\qquad
X_{\max}=x_{\mathrm{current}}+p+r,
\]
where \(r\) is the original integer radius.

**Why this is exact.** In the original model, endpoint containment and the boundary-length equation imply
\[
L\ge |x_{\mathrm{next}}-x_{\mathrm{current}}|.
\]
For an active direction, the direction constraint imposes the reverse inequality using the corresponding signed displacement. Thus equality holds. For an inactive coordinate, the original constraints force \(L=0\), which also forces equal endpoint coordinates. Consequently, the original bounding boxes are already exact endpoint envelopes; the new equations express those same relationships directly.

Displacement upper bounds are tightened using endpoint coordinate domains and the original leg-length upper bound. These bounds are valid because a coordinate difference cannot exceed the upper bound of one endpoint minus the lower bound of the other.

### Direct obstacle-separation constraints

The reformulation expresses the required disjunction of axis-wise separation inequalities directly, rather than defining a full array of intermediate separation equivalences.

**Why this is valid.** The removed array entries were defined expressions, not independent choices. Substituting those expressions into their consuming constraints preserves the same obstacle-separation conditions and nozzle exceptions. The same approach is used for inter-pipe separation, whose constraint family is empty for this instance.

This change aims to avoid unnecessary fully reified intermediate relationships during mixed-integer compilation.

### Exact bounded reformulation of cubic flexibility

For a particular flexibility test, let \(C\) be its nonnegative coefficient and let \(L_j\) denote all leg lengths in the two orthogonal directions. The original condition is
\[
\sum_j L_j^3 \ge C L_i
\quad\text{for every }i.
\]

The reformulation derives a common integer threshold \(T\) satisfying
\[
T^2\ge \max C.
\]
Here, the largest coefficient is 556, giving \(T=24\). It replaces each length **only within the flexibility tests** by
\[
s_j=\min(L_j,T).
\]

**Why this preserves feasibility exactly:**

- If every relevant length is below \(T\), no value changes.
- Otherwise, let \(M=\max_j L_j\). Since \(M\ge T\),
  \[
  \sum_j L_j^3\ge M^3\ge CM\ge CL_i
  \]
  for every \(i\), so the original test is automatically satisfied.
- In that same case, at least one capped length equals \(T\), and
  \[
  \sum_j s_j^3\ge T^3\ge CT\ge Cs_i,
  \]
  so the capped test is also automatically satisfied.

Physical lengths, routing coordinates, and length costs are not capped.

### Threshold-based linearization

Binary-valued threshold variables encode
\[
g_{j,t}=1 \iff L_j\ge t,
\qquad t=1,\ldots,T.
\]
They give the exact identities
\[
s_j=\sum_{t=1}^{T}g_{j,t},
\qquad
s_j^3=\sum_{t=1}^{T}(3t^2-3t+1)g_{j,t}.
\]

The cubic identity follows by telescoping consecutive cube differences:
\[
t^3-(t-1)^3=3t^2-3t+1.
\]
This replaces variable cubic expressions with linear sums over a small threshold range. Added inequalities \(g_{j,t}\ge g_{j,t+1}\) are valid because reaching a higher length threshold necessarily implies reaching every lower threshold.

### Support costs and solution mapping

The product of a leg-existence flag and its support cost is rewritten as a conditional expression: the original support cost when the leg exists, and zero otherwise. This is exact because the existence flag is restricted to zero or one.

All original independent variables are retained. The mapping script copies their solution values and supplies the six fixed endpoint coordinates from the original embedded data, since fixed variables need not appear in solver output. Original arrays defined by expressions need not be mapped separately.

## Expected computational effect

The principal improvement is the replacement of cubic expressions over lengths up to 380 with an exact threshold formulation using only 24 thresholds per coordinate-wise length. Explicit displacement bounds and direct separation constraints also aim to improve mixed-integer compilation and relaxation strength.

These changes preserve the original minimization objective and feasible solutions under the stated mapping. No measured runtime improvement is claimed; performance must be assessed experimentally with the HiGHS backend.

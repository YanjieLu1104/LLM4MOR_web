# Pipe-Routing Model: Structure and Reformulation

## 1. Background and interpretation

The model represents three-dimensional routing of an industrial pipe between two fixed connection points, or *nozzles*. Coordinates use a discretization of **200 mm per unit**. The route consists of straight, axis-aligned segments joined by right-angle bends.

The supplied instance contains one pipe, ten ordered route nodes, and 87 fixed boxes. Boxes represent equipment modules, existing pipe segments, support zones, a pipe rack, and preferred support levels within the rack. Pipe segments must avoid applicable obstacles with sufficient clearance, while intermediate route nodes must lie in allowable support zones.

The model balances pipe length, bends, and support costs. Although the input includes a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. Neither formulation therefore requires rack passage.

## 2. Original formulation

### Variables

The original independent declarations contain **151 integer variable entries**, before propagation and flattening:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 segment-boundary coordinates**, describing the lower and upper corners of each segment’s radius-expanded bounding box.
- **30 coordinatewise segment lengths**.
- **10 direction variables**, with zero indicating no segment and values 1–6 representing signed coordinate directions.
- **10 binary existence flags** and **10 binary last-segment flags**.
- **One objective variable**.

Segment arrays have ten entries, but only the first nine connect consecutive nodes. The final entry is a dummy whose variables are fixed to zero.

Additional defined expressions represent obstacle separation, support-zone membership, support costs, and flexibility quantities. Their Boolean expressions may introduce auxiliary variables when compiled.

### Constraints

The principal constraint groups are:

1. **Segment geometry.** Bounding boxes contain both endpoint cross-sections. Their widths, less the pipe diameter, determine coordinatewise segment lengths. Direction constraints restrict each segment to one axis.
2. **Route sequence.** Existing segments form a prefix, with exactly one designated last segment. At least the first three segments exist.
3. **Nozzle connections.** The first and last active segments obey specified directions and length limits.
4. **Orthogonality.** Consecutive active segments cannot use the same coordinate axis, excluding both straight continuations and immediate reversals.
5. **Obstacle avoidance.** A segment must be separated from each applicable obstacle along at least one axis. Specific exemptions permit connection to the endpoint modules.
6. **Support placement.** Intermediate nodes must belong to at least one support zone. Membership uses the node centre horizontally and the bottom of the pipe vertically.

Two details are important for semantic preservation: most obstacle constraints still apply to nonexistent trailing segments, and support-zone requirements still apply to intermediate nodes after the last active segment.

The source also contains inter-pipe separation and flexibility constraints, but neither is active for this instance.

### Objective

The model minimizes its original scaled cost:

\[
201\sum_{\ell,k} L_{\ell k}
+2001\sum_{\ell\text{ other than the first}} e_\ell
+\sum_{\ell\text{ other than the first}} C_\ell.
\]

Here, \(L_{\ell k}\) is coordinatewise segment length, \(e_\ell\) indicates existence, and \(C_\ell\) is support cost. The coefficients retain the original integer division by 100 and subsequent addition of one. An active chargeable node costs 51 outside preferred rack levels and 1 inside them.

## 3. Reformulation and validity

### Signed-displacement formulation

The reformulation introduces positive and negative direction indicators and corresponding nonnegative lengths for each segment and axis. Their indicator sum equals the segment’s existence flag, so an existing segment selects exactly one signed direction.

Endpoint displacement is expressed directly as

\[
x_{\ell+1,k}-x_{\ell,k}=p_{\ell k}-m_{\ell k},
\qquad
L_{\ell k}=p_{\ell k}+m_{\ell k}.
\]

Selected lengths retain the original minimum and maximum limits.

**Why this is valid:** In the original model, endpoint containment implies that segment length is at least the absolute endpoint displacement. The selected-direction constraint supplies the reverse inequality, while unselected axes have zero length. Thus the original constraints already force these equalities.

The segment boundaries can consequently be written exactly as

\[
B^-_{\ell k}=x_{\ell k}-m_{\ell k}-r,
\qquad
B^+_{\ell k}=x_{\ell k}+p_{\ell k}+r.
\]

These equations replace indirect geometric implications with linear identities.

### Route-sequence simplification

The original last-segment endpoint implications are redundant under the new displacement equations.

**Why this is valid:** The existence recurrence makes every segment after the designated last segment nonexistent. Zero existence forces all signed lengths to zero, making each subsequent pair of nodes coincide. The last active segment therefore ends at the fixed final node. Similarly, the final possible segment is either nonexistent or designated last, so its original direction and nozzle-length restrictions follow from the retained last-segment constraints.

### Bound-based obstacle preprocessing

Exact segment geometry yields bounds on its lower and upper corners from the endpoint coordinate domains. These bounds are used to:

- Remove an obstacle–segment check when separation is guaranteed throughout the domains.
- Eliminate an individual separation direction when it is impossible throughout the domains.
- Derive finite, pair-specific big-M coefficients for the remaining separation inequalities.

**Why this is valid:** A guaranteed separation makes the original disjunction true for every admissible assignment. An impossible separation alternative cannot satisfy that disjunction. Both conclusions follow from coordinate bounds, not from an assumed route or incumbent solution.

The remaining disjunctions use **one-way separation witnesses**: selecting a witness enforces its separation inequality, and at least one witness must be selected unless an original exemption applies. Reverse implications are unnecessary because only the existence of a valid separation matters.

### Support-cost linearization

Products between an existence flag and support-membership terms are replaced by Boolean conjunctions.

**Why this is valid:** For binary values \(a\) and \(b\), their product equals the indicator of \(a\land b\). The original binary “not in a preferred level” expression and support-membership definitions are retained, so this replacement preserves every support charge while avoiding a general variable-product formulation.

### Directional-length cuts

For an axis with endpoint displacement \(\Delta\) satisfying

\[
0<|\Delta|<L_{\min},
\]

the reformulation adds lower bounds on total positive and negative travel:

\[
P\ge L_{\min}+\max(0,\Delta),\qquad
M\ge L_{\min}+\max(0,-\Delta).
\]

**Why this is valid:** Travel in only one direction cannot produce a nonzero displacement smaller than the minimum active segment length. Both directions must therefore occur, giving \(P,M\ge L_{\min}\). Combining these inequalities with the telescoping endpoint identity \(P-M=\Delta\) gives the cuts. In this instance, the endpoint Y-displacement is \(-3\), while the minimum active length is 8.

### Removal of inactive constraint families

- **Inter-pipe separation:** There is only one pipe. The original generator for constraints between distinct pipes is empty.
- **Flexibility:** The sole flexibility coefficient is zero. The original conditional flexibility constraints therefore evaluate to true, and their defined orthogonal cubic-length sums equal zero.

These removals eliminate no active restrictions.

## 4. Interface and expected benefit

All original independent variables, embedded instance data, objective values, and minimization direction are preserved. The supplied mapping script returns only the original independent variables; singleton endpoint coordinates can be restored from the unchanged source data if omitted from solver output.

The reformulation targets the HiGHS mixed-integer backend through more direct linear geometry, simpler disjunctions, bound-derived big-M coefficients, and additional valid inequalities. These changes are intended to improve the relaxation and reduce logical overhead; no measured runtime improvement was established in the conversation.

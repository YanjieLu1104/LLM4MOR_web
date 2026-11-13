# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Application and instance

The model represents the routing of a pipe through an industrial installation containing equipment modules, existing pipe segments, support zones, and pipe racks. The route is rectilinear: each nonzero segment follows one of the three coordinate axes.

The supplied instance contains:

- **One pipe**, represented by 10 ordered nodes and at most nine nonzero segments.
- Fixed connection points at **(212, 58, 115)** and **(245, 43, 113)**.
- **97 fixed boxes**, classified as equipment modules, existing pipe segments, module support zones, a rack, or preferred rack levels.
- A coordinate discretization of **200 mm per unit**.

The pipe must respect obstacle clearances, specified nozzle directions, segment-length limits, and support-zone requirements. Its modeled clearance radius is `nDiam div 2`, which equals one coordinate unit here.

Two distinctions are important when interpreting the instance. Although the data contain a flag requesting passage through a rack, the corresponding constraint is commented out and therefore is **not enforced**. Likewise, the model does not prohibit intersections between different segments of this same pipe.

## 2. Original formulation

### Decision variables

The original model declares **151 independent integer variable entries**, before flattening and elimination:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates per node; six endpoint coordinates are fixed |
| Lower and upper segment-box coordinates | 60 | Radius-expanded bounding boxes |
| Coordinatewise segment lengths | 30 | Nonnegative lengths along each axis |
| Segment directions | 10 | Zero for an absent segment; six signed axis directions otherwise |
| Segment-existence flags | 10 | Binary indicators |
| Last-segment flags | 10 | Binary indicators |
| Objective variable | 1 | Total scaled cost |

The segment arrays contain 10 entries, but only entries 1–9 can represent actual segments. Entry 10 is a dummy entry fixed to zero.

Additional defined arrays represent obstacle separation, inter-pipe separation, support-zone membership, support costs, and flexibility expressions. These are derived expressions rather than additional independent choices.

### Constraints

The principal constraint groups are:

1. **Segment geometry.** Radius-expanded segment boxes enclose both endpoints. Their widths, after subtracting twice the radius, equal the coordinatewise segment lengths. Direction constraints make each active segment move along exactly one signed axis.

2. **Route sequence.** Active segments form a contiguous prefix. The first three segments must exist, and exactly one active segment is designated last. All subsequent segments have zero length.

3. **Nozzle conditions and bends.** The first segment follows the specified positive-Z direction, and the last follows positive Y. Nozzle lengths are bounded above by 15 units. Although their separate lower bounds are three units, the general active-segment lower bound of six also applies. Consecutive active segments must use different axes.

4. **Obstacle avoidance.** A segment’s expanded box must be separated from each relevant obstacle on at least one axis. Exceptions allow the first segment to leave its own module and the last segment to enter its destination module. The destination-module exception also covers absent segments.

5. **Support requirements.** Nodes 2–9 must lie in at least one support zone. Membership uses the node center in X and Y and the pipe bottom in Z. This requirement remains applicable even when a node belongs to the zero-length tail.

6. **Inter-pipe separation and flexibility.** The general source includes both features, but neither imposes an effective restriction in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes the original integer-scaled cost, retaining the source’s division by 100 and subsequent addition of one:

- **181 per unit of segment length**;
- **1,801 per active segment after the first**, representing bend cost;
- **51 per charged support outside preferred rack levels**, or **1 within a preferred level**.

Support charges apply only to active segments after the first. These coefficients are the actual optimization objective, not a conversion back to unscaled monetary costs.

## 3. Reformulation and justification

### Signed-direction and length decomposition

The reformulation introduces binary positive- and negative-direction indicators for each segment and axis, together with nonnegative positive- and negative-length components. Their sum equals segment existence, so an active segment selects exactly one signed direction.

For each axis, endpoint displacement equals positive length minus negative length, while total length equals their sum. Component lengths are bounded by their direction indicators.

**Why this is equivalent:** In the original model, endpoint enclosure and the box-width equation imply that length is at least the absolute endpoint displacement. The selected direction supplies the reverse inequality, making these quantities equal. Unselected axes have zero length and hence equal endpoint coordinates. Consequently, the original bounding boxes are already uniquely determined by the endpoints and radius. The new linear equations express these same relationships directly.

Component upper bounds also use the largest displacement possible between the original endpoint domains. These are valid bounds because no feasible displacement can exceed the corresponding endpoint-domain difference.

### Linear obstacle-separation certificates

Instead of defining fully reified axis-separation expressions, the reformulation introduces binary certificates for the two possible separation sides on each axis. Selecting a certificate enforces its associated inequality. Each non-exempt segment–obstacle pair must select at least one certificate.

**Why this is equivalent:** The original constraint requires only the existence of a separating side. It does not require a unique side or require every satisfied side to be selected. Thus, one-way certificates suffice: any original feasible separation permits a certificate selection, and every selected certificate establishes a valid original separation.

The formulation uses **bound-derived big-M coefficients**, rather than a common arbitrary constant. Each coefficient makes its inequality redundant when its certificate is zero, using valid segment-box bounds derived from the coordinate domains.

### Bound-based obstacle preprocessing

Two preprocessing rules reduce unnecessary separation decisions:

- If the coordinate bounds prove that a segment is always separated from an obstacle on some axis, the pair requires no separation certificates.
- If the bounds prove that a particular separating side is impossible, its certificate is fixed to zero.

Both rules follow directly from valid lower and upper bounds on the segment boxes. They do not assume a particular route or remove a potentially necessary obstacle restriction. The original nozzle-module exceptions are retained.

### Exact support-cost linearization

Every preferred rack level has zero unscaled support cost in the supplied data, giving a scaled cost of one. The original support-cost expression therefore simplifies to

\[
e + 50 e u,
\]

where \(e\) is segment existence and \(u\) indicates that the node is outside all preferred levels.

The product \(eu\) is replaced by a binary variable \(w\) satisfying

\[
w \le e,\qquad w \le u,\qquad w \ge e+u-1.
\]

**Why this is equivalent:** These inequalities enforce the exact product of two binary variables. The original preferred-level membership expressions and the binary domain of \(u\) remain in place, so their restrictions are preserved. The simplification uses the unchanged preferred-level cost data and is explicitly guarded by an assertion.

### Instance-specific removal of inactive features

- **Inter-pipe separation:** Its original constraints apply only to pairs belonging to different pipes. With one pipe, there are no such pairs.
- **Flexibility:** The original conditional expressions return zero, and the corresponding constraints return true, when the flexibility coefficient is nonpositive. The supplied coefficient is zero.

Removing these inactive computations therefore removes no feasible-solution restriction. The reformulation explicitly checks the instance conditions used for this specialization.

### Valid displacement cuts

The reformulation adds two redundant constraint families:

- At least one segment must travel in each signed direction required by the net endpoint displacement.
- Total length along each axis must be at least the absolute endpoint displacement on that axis.

**Why these are valid:** Segment displacements telescope to the fixed endpoint difference. A positive net displacement requires a positive segment, and a negative net displacement requires a negative segment. The length bound follows from the triangle inequality. Here the endpoint difference is \((33,-15,-2)\), so positive X, negative Y, and negative Z must all occur.

## 4. Preservation and expected benefit

The final model retains all original independent variables, their meanings, and the minimization objective. The mapping script copies those variables, restores any omitted singleton endpoint coordinates from their original fixed values, and excludes reformulation-only auxiliaries.

The main expected benefit for HiGHS is a more explicit mixed-integer linear formulation: stronger direction–length coupling, bound-based obstacle disjunctions, fewer unnecessary separation decisions, and an exact linear support-cost expression. **No measured runtime improvement is claimed**; the benefit must be established experimentally.

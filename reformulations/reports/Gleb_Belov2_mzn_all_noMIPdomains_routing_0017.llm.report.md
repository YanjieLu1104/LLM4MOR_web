# Industrial Pipe-Routing Model: Reformulation Report

## 1. Background and interpretation

The model represents the routing of a single pipe through a three-dimensional industrial layout. The pipe connects two fixed nozzle locations using a sequence of straight, axis-aligned segments. Coordinates are integer multiples of a 200 mm discretization unit.

The layout contains equipment modules, existing pipe segments, support zones, a large pipe rack, and preferred support levels within that rack. A feasible route must:

- Maintain the prescribed clearance from obstacles, accounting for pipe radius.
- Follow specified directions and length limits at its two nozzle connections.
- Turn onto a different coordinate axis between consecutive active legs.
- Place intermediate nodes within permitted support zones.

The model allows up to nine legs between ten node positions. Unused trailing legs have zero length, so their nodes coincide with the destination.

These requirements should not be interpreted more broadly than the implemented constraints. In particular, the original rack-traversal constraint is commented out, self-intersection of the pipe is not explicitly prohibited, and support-zone membership is required at nodes rather than along every point of a leg. The reformulation preserves these distinctions.

## 2. Original formulation

### Variables

Before flattening, the original model has **151 independent scalar integer variable entries**:

| Variables | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional positions, including six fixed endpoint coordinates |
| Lower and upper leg-box coordinates | 60 | Radius-expanded bounding boxes for ten leg slots |
| Coordinate-wise leg lengths | 30 | Nonnegative lengths in each axis |
| Leg directions | 10 | Zero for inactive legs; six signed axis directions otherwise |
| Leg-existence flags | 10 | Binary indicators of active legs |
| Last-leg flags | 10 | Binary indicators identifying the final active leg |
| Objective variable | 1 | Total routing cost |

There are nine actual candidate legs; the tenth slot is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions. These definitions can introduce auxiliary variables during flattening.

### Constraints

The main constraint groups are:

1. **Leg geometry.** Bounding boxes contain both endpoint cross-sections. Their dimensions determine the coordinate-wise leg lengths.
2. **Axis-aligned movement.** A direction selects one signed coordinate axis. Lengths in the other axes are zero, and an active leg has length at least four units.
3. **Route sequencing.** Active legs form a prefix, exactly one is marked last, and the first three legs exist.
4. **Nozzle connections.** The first leg travels in the positive \(z\)-direction; the last travels in the negative \(x\)-direction. Nozzle legs have additional length bounds.
5. **Orthogonality.** Consecutive active legs cannot use the same coordinate axis, including opposite directions.
6. **Obstacle clearance.** Each applicable obstacle–leg pair must be separated along at least one axis. Specific exceptions allow connection to the endpoint modules.
7. **Support membership and cost.** Intermediate nodes must belong to at least one support zone. Membership uses the node center horizontally and the pipe’s bottom vertically. Preferred rack levels affect support charges.
8. **Flexibility.** The source includes cubic-length expressions, but the supplied flexibility coefficient is zero, making these constraints inactive.

The source also contains inter-pipe separation constraints. They generate no restrictions for this single-pipe instance.

### Objective

The model minimizes the sum of pipe-length, bend, and support charges. After the original integer coefficient scaling:

- Each unit of total pipe length costs **131**.
- Each active leg after the first incurs a bend charge of **1,301**.
- Each charged support costs **51** outside preferred levels and **1** within a preferred level.

The reformulation retains this objective exactly, including the original coefficient rounding and added unit charges.

## 3. Reformulation and validity

### Disaggregated linear leg geometry

The direction implications were replaced by positive- and negative-direction binary indicators and corresponding nonnegative lengths for each axis.

For each leg and coordinate, the new formulation expresses:

\[
\text{endpoint displacement}
=\text{positive length}-\text{negative length},
\]

\[
\text{original coordinate length}
=\text{positive length}+\text{negative length}.
\]

The sum of the six direction indicators equals the original existence flag. Thus, an active leg selects exactly one signed axis; an inactive leg selects none. Each signed length is bounded below by the original minimum active-leg length times its indicator and above by a coordinate-derived capacity times that indicator.

**Why this is equivalent.** In the original model, endpoint containment and the bounding-box length equation imply that a coordinate length is at least the absolute endpoint displacement. The selected-direction implication supplies the matching upper bound. Consequently, the length equals the displacement magnitude, and the bounding-box ends are forced to the endpoint minimum and maximum, expanded by the radius. On unselected axes, zero length forces equal endpoint coordinates.

The new linear equations encode these same consequences directly, retaining the original leg boxes, lengths, directions, and flags. This is a standard disaggregated mixed-integer formulation intended to strengthen the relaxation and reduce implication handling.

### Coordinate-bound preprocessing

Signed-length capacities are derived from the declared endpoint bounds and capped by the original maximum leg length. For example, positive movement cannot exceed the next endpoint’s upper bound minus the current endpoint’s lower bound.

Obstacle checks are omitted only when those bounds prove permanent separation along some axis.

**Why this is valid.** Every feasible radius-expanded leg box lies within the envelope implied by its endpoint bounds. If that entire envelope is already separated from an obstacle by the required clearance, the corresponding obstacle disjunction is always true. Removing it therefore cannot admit an otherwise infeasible route. All remaining checks retain the original endpoint-module exceptions.

### Linearized support charges

All supplied preferred-level support costs are zero before the original scaling. Let \(e\) be a leg-existence flag and \(q\) the original flag indicating that its node is outside all preferred levels. The original support charge simplifies to

\[
e(1+50q).
\]

A binary auxiliary \(a\) replaces \(eq\), using

\[
a\le e,\qquad a\le q,\qquad a\ge e+q-1.
\]

The charge is then \(e+50a\).

**Why this is valid.** The original definition of \(q\) gives preferred-level membership sum \(1-q\), while its binary domain permits only zero or one such membership. Substituting the supplied costs yields the expression above. The three inequalities enforce the binary product exactly, including zero cost for an inactive leg. Support membership remains enforced even for unused intermediate node slots, as in the original model.

### Inactive flexibility elimination

The flexibility expressions are replaced by zero-valued defined arrays, with an assertion checking that the supplied coefficients are nonpositive.

**Why this is valid.** The original expressions explicitly return zero, and the corresponding constraints return true, when the coefficient is nonpositive. The supplied coefficient is zero, so no active physical restriction is removed.

### Endpoint-displacement cuts

The fixed endpoints imply net displacement

\[
(\Delta x,\Delta y,\Delta z)=(-1,29,40).
\]

The reformulation adds valid lower bounds on directional activity, axis-wise length, and total active-leg count.

- **At least two \(x\)-legs:** every nonzero leg is at least four units long, so a net displacement of \(-1\) cannot be achieved by movement in only one sign. Both positive and negative \(x\)-movement are necessary.
- **At least nine units of \(x\)-length:** if positive and negative totals are \(P\) and \(N\), then \(N-P=1\) and both are at least four. Therefore \(P+N\ge9\).
- **At least one \(y\)-leg and 29 units of \(y\)-length:** these follow directly from the nonzero net \(y\)-displacement.
- **At least two \(z\)-legs and 40 units of \(z\)-length:** the first leg is a positive \(z\)-leg of at most 15 units, so it cannot alone produce the required 40-unit displacement.

Since each active leg uses only one axis, these bounds imply **at least five active legs** and **total length at least 78 units**. They exclude no feasible original route; their purpose is to expose consequences that might otherwise emerge only through branching.

## 4. Solution interface and expected effect

All original independent variables retain their names and meanings. The mapping script copies those variables, excludes reformulation auxiliaries, and can recover the six fixed endpoint coordinates from the original embedded data. Missing required solution fields are reported rather than replaced with guessed values.

The changes target a tighter and more explicitly linear formulation for HiGHS: direct signed-length geometry, bound-based obstacle elimination, exact binary-product linearization, and displacement cuts. They preserve the original minimization problem and objective values. No measured runtime improvement is established by the supplied conversation.

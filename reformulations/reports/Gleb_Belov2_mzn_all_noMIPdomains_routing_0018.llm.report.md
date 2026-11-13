## Background and interpretation

The model represents **three-dimensional industrial pipe routing** between two fixed equipment connections, or nozzles. A route consists of axis-aligned straight segments joined by bends. It must avoid equipment and existing pipework, maintain prescribed clearance, and place intermediate nodes in regions where supports are available.

The supplied instance contains one pipe with 10 node positions and nine candidate segments. The endpoints are fixed at \((245,62,122)\) and \((245,102,100)\); the eight intermediate nodes have bounded integer coordinates. One coordinate unit represents 200 mm. Fixed boxes describe equipment, existing pipe segments, support zones, a rack, and preferred rack-support levels.

Two distinctions matter when interpreting the instance:

- Although a rack-traversal flag is supplied, its associated constraint is commented out. Traversal through the rack is therefore **not required**.
- Flexibility constraints appear in the source, but their coefficient is zero in this instance, so they impose no restrictions.

## Original formulation

### Variables

The original model declares 151 scalar integer decision-variable entries before accounting for aliases and derived expressions:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 segment-bound coordinates**, representing lower and upper corners of radius-expanded segment boxes.
- **30 nonnegative coordinatewise segment lengths**.
- **10 direction variables**, encoding absence or movement in one of six signed coordinate directions.
- **10 binary existence flags** and **10 binary last-segment flags**.
- **One objective variable**.

Segment arrays contain a dummy tenth entry, which is fixed to zero. Additional defined expressions represent obstacle separation, support-zone membership, support costs, and flexibility quantities. These source-level counts are not counts of the flattened MIP variables.

### Constraints

The main constraint groups enforce:

1. **Axis-aligned geometry.** Each existing segment moves along exactly one coordinate axis. Its lengths and expanded bounding box are linked to its endpoints and the pipe radius.
2. **A contiguous active route.** Existing segments form a prefix of the candidate sequence. Exactly one is designated last, and at least the first three exist. Zero-length trailing segments repeat the destination position.
3. **Nozzle requirements.** The first segment has the prescribed outgoing direction. The last active segment has the prescribed incoming direction and nozzle-length bounds. The general minimum segment length also applies to nozzle segments.
4. **Orthogonal consecutive segments.** Adjacent active segments cannot use the same axis, excluding both immediate reversal and consecutive collinear segments.
5. **Obstacle clearance.** A segment’s expanded box must be separated from each applicable obstacle along at least one axis. Specific exceptions permit connection to the start and destination equipment.
6. **Support availability.** Intermediate candidate nodes must lie in at least one support zone. Membership uses the node center horizontally and the pipe bottom vertically. This requirement also applies to intermediate nodes belonging to the inactive tail.
7. **Inter-pipe separation.** The general formulation contains these constraints, but there are no distinct-pipe pairs in this one-pipe instance.

### Objective

The model **minimizes scaled pipe-length, bend, and support costs**. It retains the original integer scaling rule: divide each applicable cost coefficient by 100 and then add one.

For this instance, the length coefficient is 131 per coordinate unit, and each active segment after the first incurs a bend coefficient of 1,301. Support costs are charged only at active intermediate nodes and distinguish ordinary support locations from preferred rack levels. These scaled coefficients—not the unscaled engineering costs—define the optimization objective.

## Reformulation and justification

### Disaggregated signed movements

The direction-dependent length implications were replaced with positive and negative movement variables for each segment and axis, together with binary direction selectors. Their sum equals the segment-existence flag, so an active segment selects exactly one signed direction.

The new linear equations express:

- endpoint displacement as positive movement minus negative movement;
- coordinatewise length as their sum;
- the expanded lower and upper bounds directly from the starting coordinate, movement, and radius.

**Why this is valid:** In the original model, the bounding-box inequalities and length equation imply that a coordinatewise length is at least the absolute endpoint displacement. A selected direction supplies the reverse inequality in that direction, forcing equality. Unselected axes have zero length, which forces equal endpoint coordinates. Consequently, the original bounds already describe the exact radius-expanded segment; the new equations express that same geometry directly.

This is a **disaggregated mixed-integer linear formulation**, intended to strengthen the linear relaxation and reduce reliance on reified direction implications.

### Bound-derived movement limits

Each signed movement receives an upper bound derived from the original coordinate domains and applicable segment-length limits. For example, positive movement cannot exceed the next node’s coordinate upper bound minus the current node’s coordinate lower bound.

**Why this is valid:** Movement equals endpoint displacement, so it cannot exceed these domain-derived limits. Taking the minimum with the original ordinary or nozzle length limit preserves every feasible route. An impossible direction has zero capacity; together with the positive minimum length, this forces its selector to zero.

These bounds provide tighter coefficients in the linear movement-selection constraints.

### Obstacle-disjunction preprocessing

Obstacle separation is expressed directly as a disjunction over possible separating sides, rather than through the original intermediate axis-separation array.

Two domain-based reductions are applied:

- An obstacle–segment constraint is omitted if coordinate bounds guarantee separation along some axis.
- A separating side is excluded if coordinate bounds make that side impossible.

**Why this is valid:** The original segment-bound constraints provide valid lower and upper bounds on each expanded segment box. A separation inequality satisfied throughout those bounds is always true; one that cannot hold anywhere within them is always false. Removing a universally satisfied constraint or a false disjunct leaves the feasible set unchanged.

The nozzle-equipment exceptions are retained. Inactive segments are not given any additional obstacle exemption.

### Exact support-cost linearization

Products between segment existence and support-cost expressions were replaced by weighted Boolean conjunctions, such as “segment exists and node lies in this preferred level.”

**Why this is valid:** For binary indicators, multiplication is exactly logical conjunction. Distributing the existence indicator across the original weighted sum therefore preserves the cost for every assignment, including inactive nodes. The original support-membership conditions and the domain restriction on the nonpreferred-level indicator remain intact.

This removes variable-by-variable integer products from the cost expression.

### Inactive flexibility expressions

The flexibility sums are represented as zero, with an assertion checking that the embedded coefficients are nonpositive.

**Why this is valid:** The original definitions explicitly return zero and impose no flexibility restriction when the coefficient is nonpositive. The supplied coefficient is exactly zero, so this is constant evaluation of the original model, not removal of an active engineering requirement.

## Preservation and expected effect

The reformulation preserves the fixed instance data, minimization direction, scaled objective, and original independent variables. The mapping script copies those variables, excludes new auxiliaries, and restores fixed endpoint coordinates from the embedded data if omitted from solver output. It reports missing nonfixed values rather than inventing them.

The intended performance improvements come from tighter movement bounds, more explicit linear geometry, simpler support-cost expressions, and fewer obstacle-disjunction terms. **No measured speedup is established here**; effectiveness should be assessed through comparative HiGHS runs.

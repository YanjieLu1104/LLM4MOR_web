# Pipe-Routing Model and MILP Reformulation

## 1. Background and interpretation

The model represents three-dimensional industrial pipe routing between two fixed equipment connections, or **nozzles**. Coordinates are integer multiples of a 200 mm length unit. A route consists of axis-aligned straight segments joined by right-angle bends.

The supplied instance contains one pipe, ten ordered node positions, and nine possible connecting legs. The first and last node positions are fixed. Shorter routes are represented by a contiguous prefix of existing legs; the remaining nodes coincide with the destination. A tenth, dummy leg entry is fixed to zero.

Fixed boxes describe equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. The route must avoid obstacles with the specified clearances and place intermediate nodes in support zones. Additional cubic constraints represent a pipe-flexibility criterion based on segment lengths and nozzle separation.

Although the data include a flag suggesting that the pipe should pass through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.

## 2. Original model structure

### Variables

The original model declares **151 independent integer scalar entries**:

| Variables | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional positions, including six fixed endpoint coordinates |
| Lower and upper leg-box coordinates | 60 | Bounding boxes enlarged by the pipe radius |
| Coordinate-wise leg lengths | 30 | Nonnegative lengths along the three axes |
| Leg directions | 10 | Zero for an absent leg; six signed axis directions otherwise |
| Leg-existence indicators | 10 | Binary-valued integers |
| Last-leg indicators | 10 | Binary-valued integers |
| Objective | 1 | Total scaled routing cost |

Defined arrays additionally represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint groups are:

- **Geometry and direction:** Each leg has at most one nonzero coordinate length. Direction implications, together with the leg-box inequalities and length equations, force that length to equal the corresponding endpoint displacement. The leg boxes therefore equal the endpoint bounding boxes enlarged by the radius.
- **Route sequencing:** Existing legs form a contiguous prefix, at least the first three legs exist, and exactly one leg is marked as last.
- **Bends and nozzles:** Consecutive existing legs use different axes. The first and last legs have prescribed directions and nozzle-specific length bounds. The general minimum leg length also applies to these legs.
- **Obstacle avoidance:** Each relevant obstacle and leg must be separated along at least one axis. The original nozzle-module exceptions are retained.
- **Support:** Every intermediate node covered by the original support requirement must lie in a support zone. Preferred rack levels affect support costs.
- **Flexibility:** For each coordinate, the sum of cubes of lengths along the other two coordinates must exceed a coefficient times each individual orthogonal length. Coefficients depend on fixed nozzle separation and the supplied flexibility factor.

Inter-pipe separation constraints are present in the source but impose no restrictions in this single-pipe instance. The original model does not impose self-collision avoidance between nonadjacent legs.

### Objective

The model **minimizes** the sum of pipe-length, bend, and support costs.

The reformulation preserves the original integer scaling, including the added unit in each coefficient. Thus, the length coefficient is 181 and the bend coefficient is 1,801. Support charges are applied only where the original existence indicators activate them.

## 3. Reformulation and validity

### Exact linear representation of cubic lengths

The main change replaces variable cubic expressions with a discrete MILP formulation.

Each leg selects exactly one admissible **total length** through binary selectors. Linear weighted sums determine both the selected length and its cube. Auxiliary coordinate-cube variables then distribute that cube to the active axis.

This representation is exact because the original direction constraints already allow at most one nonzero coordinate length per leg. Consequently:

- an existing leg’s total length equals its active coordinate length;
- an absent leg has zero length in every coordinate;
- only the active coordinate can receive a nonzero cube.

Requiring the coordinate cubes to sum to the selected total cube therefore reproduces every original coordinate-wise cubic term without approximation.

### Preprocessing admissible lengths

The selector domains exclude lengths that the original constraints cannot realize:

- **Positive lengths below the general minimum:** The original direction implications require every active leg to satisfy that minimum.
- **Lengths exceeding coordinate displacement bounds:** Since each coordinate length equals an absolute endpoint displacement, it cannot exceed the maximum displacement permitted by the endpoint domains.
- **Lengths exceeding applicable nozzle limits:** The first leg and the last possible leg already have their respective nozzle-specific upper bounds.
- **Positive lengths for dummy entries:** These entries are explicitly fixed to zero in the original model.

Zero remains available for potentially absent legs. Original existence and nozzle constraints determine whether it can actually be selected.

### Linearized support costs

The original support expression multiplies a binary existence indicator by a membership-dependent charge. The reformulation distributes that multiplication and expresses each product of binary indicators as a Boolean conjunction.

This is exact because an existence indicator multiplied by another binary indicator equals one precisely when both are one. The original preferred-level membership expression and its binary domain are retained, so no additional assumption about support-zone overlap is introduced.

### Endpoint-distance cuts

Redundant linear inequalities bound accumulated and remaining coordinate lengths below by the corresponding signed displacement to an endpoint.

Their validity follows from the original geometric constraints: each coordinate length is the absolute displacement between consecutive nodes. Summing those lengths must dominate the absolute net displacement by the triangle inequality. Writing both signed inequalities avoids introducing another absolute-value expression.

These cuts do not exclude any original feasible route, but can strengthen the MILP relaxation.

### Flexibility lower-bound cuts

For an orthogonal group of lengths, let \(S\) be their sum, \(M\) their maximum, and \(C\) the original flexibility coefficient. The original constraints imply

\[
CM \leq \sum_j \ell_j^3.
\]

For nonnegative lengths,

\[
\sum_j \ell_j^3
\leq M^2S
\leq MS^2.
\]

When fixed nozzle displacement guarantees that this group contains a positive length, \(M>0\). Dividing gives \(C\leq S^2\), hence the valid integer cut

\[
S\geq \lceil\sqrt{C}\rceil.
\]

The reformulation adds this cut only when the required nonzero orthogonal displacement is established from the fixed endpoints.

## 4. Interface preservation and expected effect

All original independent variables, fixed instance data, necessary constraints, and objective semantics are retained. The mapping script copies the retained variables and preserves array index encodings. If fixed endpoint coordinates are omitted from solver output, it restores their explicitly declared values; the original objective can also be recovered from the shared objective field.

The reformulation targets HiGHS by replacing nonlinear expressions with exact linear mixed-integer constructions and adding valid relaxation-strengthening inequalities. It introduces additional binary variables, so a runtime improvement is not guaranteed. No measured solve-time comparison is available in the conversation.

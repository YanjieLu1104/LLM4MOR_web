# Pipe Routing with Clearance, Support, and Flexibility Requirements

## Real-world background

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, through a three-dimensional plant layout. Coordinates are integer multiples of a 200 mm length unit.

The route consists of axis-aligned straight legs connected by right-angle bends. Fixed boxes represent equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. The pipe must avoid obstacles with the specified clearance, while intermediate nodes must lie in suitable support regions.

The model also includes engineering flexibility inequalities involving cubed leg lengths. These appear intended to ensure that the routing provides sufficient flexibility relative to the separation between the nozzles. This interpretation follows from the model’s comments and coefficient definitions; the formulation should not be interpreted as a complete mechanical stress analysis.

Although an input flag indicates a preference or requirement to pass through a rack, its corresponding constraint is commented out in the original model. The reformulation does not activate it.

## Original mathematical structure

### Variables

The instance contains one pipe with **10 nodes and 9 candidate legs**. Its independent decision-variable declarations comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-bound entries**, describing the lower and upper corners of radius-expanded leg boxes.
- **30 nonnegative integer coordinate-wise leg lengths**.
- **10 direction variables**, encoding an absent leg or one of six signed coordinate directions.
- **20 binary-valued integer flags**, indicating leg existence and the last active leg.
- **One integer objective variable**.

The leg arrays include a tenth, non-leg position that is fixed to zero. Additional defined arrays express obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

1. **Route geometry.** Each active leg moves along exactly one coordinate axis. Direction and length constraints connect consecutive node coordinates to the leg’s expanded bounding box.

2. **Route sequence.** At least the first three legs exist. Active legs form a prefix, with exactly one designated last leg. Subsequent zero-length legs repeat the terminal position.

3. **Bends and nozzle connections.** Consecutive active legs use different axes. The first and last active legs satisfy prescribed nozzle directions and length limits.

4. **Obstacle clearance.** A leg must be separated from each applicable obstacle along at least one axis. Explicit exceptions permit connection through the relevant nozzle modules.

5. **Support membership.** Intermediate nodes must belong to at least one support zone. Membership uses the node center horizontally and the pipe bottom vertically. Preferred rack levels affect support costs.

6. **Flexibility.** For each coordinate direction, a coefficient times each orthogonal leg length is bounded by the sum of cubes of all leg lengths orthogonal to that direction.

The original model also contains inter-pipe separation constraints, but these generate no pairwise restrictions for this single-pipe instance.

Importantly, some support and obstacle constraints remain applicable to unused nodes or zero-length candidate legs. These conditions are retained rather than replaced by a blanket “active legs only” rule.

### Objective

The model **minimizes total routing cost**, combining:

- Total pipe length.
- A charge for each active leg after the first.
- Support charges associated with intermediate nodes.

The original integer coefficient transformation—division by 100 followed by addition of one—is preserved exactly. Consequently, the reformulation preserves the model’s objective values, not merely the ordering induced by an approximate cost function.

## Reformulation and justification

### 1. Disaggregated signed leg lengths

Each coordinate-wise length is represented by nonnegative positive- and negative-direction components, activated by binary direction indicators. Linear equations connect these components directly to node displacements and leg bounds.

**Why this is valid:** In the original formulation, the bounding-box inequalities and the equation
\[
L=U-B-2r
\]
imply that \(L\) is at least the absolute displacement between the two nodes. For a selected direction, another constraint bounds \(L\) above by the corresponding signed displacement. These bounds therefore coincide: the length equals the absolute displacement, and the expanded box endpoints are exact. For an unselected axis, the original zero-length condition forces equal node coordinates.

The new equations express these same consequences directly. They replace indirect geometric implications with a disaggregated linear formulation intended to strengthen the mixed-integer relaxation.

### 2. Coordinate-specific length bounds

Upper bounds are derived from the declared domains of consecutive node coordinates, the original pipe-length limit, and the applicable first- or last-candidate nozzle restrictions.

**Why this is valid:** Once length equals absolute coordinate displacement, its maximum cannot exceed the largest displacement permitted by the two endpoint domains. Taking the minimum of this bound and existing length limits cannot exclude an originally feasible route. Axes prohibited by the fixed nozzle direction receive a zero upper bound.

### 3. Bound-based obstacle preprocessing

An obstacle–leg check is omitted only when the coordinate domains prove that the entire possible expanded leg box is separated from the obstacle along some axis.

**Why this is valid:** The original obstacle condition is a disjunction of axis-separation inequalities. If one inequality holds even at the least favorable permitted leg position, that disjunction is always true. Removing it therefore removes only a redundant constraint, not a possible collision restriction.

All remaining obstacle checks retain their original clearance distances and nozzle-module exceptions.

### 4. Exact finite-domain encoding of cubic lengths

Variable powers are replaced by a mixed-integer encoding over admissible integer lengths. Nonnegative continuous weights sum to one and express both the length and its cube. Binary code variables constrain the weighted binary digits of the selected length.

**Why this is valid:** A weighted average of zero–one digits can equal a binary value only if every positively weighted entry has that digit. Enforcing this for all digits leaves exactly one admissible length, because each length has a unique binary representation. Its cube is therefore selected exactly.

The admissible values are zero and the positive lengths permitted by the original minimum-length constraint and the derived upper bound. Thus this is **not a piecewise-linear approximation** of the cubic function. It uses logarithmically many binary code variables per encoded length, while retaining continuous weights for the admissible values.

### 5. Boolean linearization of support costs

Products involving leg existence and support-category indicators are expressed through Boolean conjunctions.

**Why this is valid:** Leg-existence flags, preferred-zone membership indicators, and the nonpreferred indicator are binary-valued in the original model. For binary values, multiplication equals logical conjunction. Distributing the original existence multiplier across the support-cost expression therefore preserves each charge exactly.

### 6. Original-variable solution interface

All original independent variables remain in the reformulated model. The accompanying mapping script exports those variables and excludes reformulation-specific auxiliaries. It restores fixed endpoint coordinates from their original singleton domains if those values are omitted from solver output, and reports missing nonfixed values rather than fabricating them.

## Expected computational effect

The reformulation targets the HiGHS mixed-integer backend through tighter bounds, more explicit linear geometry, removal of provably redundant obstacle checks, and exact linear encodings of nonlinear expressions. These changes are intended to improve relaxation strength and reduce nonlinear translation overhead. No measured solve-time improvement has been established in the supplied conversation.

## Background and purpose

This instance models **three-dimensional industrial pipe routing** between two fixed nozzle locations. The surrounding plant is represented by rectangular boxes describing equipment modules, existing pipe segments, support zones, a rack, and preferred rack-support levels.

The pipe follows an axis-aligned polyline. Its route must respect obstacle clearances, nozzle connection directions, allowable segment lengths, and support availability. Additional cubic-length inequalities represent an engineering flexibility criterion: lengths in directions perpendicular to a nozzle displacement must provide sufficient flexibility. The model therefore balances installation cost against geometric and mechanical requirements.

Coordinates use a discretization unit of **200 mm**. The instance contains one pipe, ten node positions, and nine candidate connecting legs. Unused legs form a trailing sequence of zero-length segments.

## Original formulation

### Variables

The original independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates;
- **60 integer leg-box coordinates**, representing the lower and upper corners of radius-expanded leg bounding boxes;
- **30 nonnegative directional leg lengths**;
- **10 direction variables**, with zero indicating an unused leg and six values representing signed coordinate directions;
- **10 binary existence indicators** and **10 binary last-leg indicators**;
- An integer objective variable.

The leg arrays include a tenth, non-leg row that is fixed to zero. Additional expression-defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The main constraint groups are:

1. **Route geometry.** Each existing leg follows one signed coordinate direction. Its bounding box contains both endpoint nodes, expanded by the pipe radius. Length and direction constraints make the box tight and the leg length equal to the corresponding absolute coordinate difference.

2. **Leg sequence and nozzle connections.** Existing legs form a contiguous prefix, with exactly one designated last leg. At least the first three legs exist. The first and last legs obey prescribed nozzle directions and length limits; the last leg reaches the fixed destination.

3. **Orthogonality.** Consecutive existing legs cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.

4. **Obstacle avoidance.** Each applicable leg must be separated from each obstacle along at least one coordinate axis, accounting for pipe radius and safety distance. Special exemptions permit the nozzle connections to enter their associated modules.

5. **Support availability and cost classification.** Intermediate node positions must lie in a support zone. Membership uses the node center horizontally and the pipe bottom vertically. Preferred rack levels determine discounted support costs. These membership requirements also apply to intermediate positions belonging to the unused trailing portion of the route.

6. **Flexibility.** For each coordinate direction, a coefficient derived from nozzle displacement and the supplied engineering factor multiplies each perpendicular leg length. That quantity must not exceed the sum of cubed perpendicular leg lengths.

The source also contains inter-pipe separation constraints, but they generate no restrictions for this single-pipe instance. A proposed mandatory rack-traversal constraint is commented out and is not part of the problem.

### Objective

The model **minimizes** the sum of:

- Total pipe length cost;
- A bend-related charge for every existing leg after the first;
- Support charges at the corresponding nodes.

The original integer coefficient transformation—division by 100 followed by addition of one—is preserved exactly. Thus the reformulation retains the model’s objective values, rather than substituting unscaled physical costs.

## Reformulation and justification

### Exact finite-domain linearization of cubic lengths

Variable exponentiation was replaced by a binary selection formulation. For each relevant leg and coordinate, binary variables select an admissible positive length. Their weighted sums define both the length and its cube:

\[
L=\sum_{t\in D}t\,y_t,\qquad
C=\sum_{t\in D}t^3y_t.
\]

The number of selected values equals the indicator that the leg uses that coordinate axis. Therefore:

- An active axis selects exactly one length and obtains its exact cube;
- An inactive axis selects no value, giving zero length and zero cube.

This is an **exact discrete reformulation**, not a piecewise approximation. The original lengths are bounded integers, so enumerating all admissible values preserves every feasible length. The original flexibility inequalities remain unchanged except that they use these exact cube expressions. This removes variable powers from the formulation submitted to HiGHS.

### Preprocessing of admissible length values

The selection domains use tighter upper bounds derived from existing constraints:

- The original leg-length upper bound;
- The greatest possible absolute difference between the two endpoint coordinate domains;
- First-nozzle or last-possible-nozzle length limits;
- Zero for coordinates forbidden by those nozzle directions.

The coordinate-difference bound is valid because the original bounding-box constraints imply
\[
L\geq |x_{i+1}-x_i|,
\]
while the selected direction imposes the matching reverse inequality. Hence equality holds.

Positive selection values begin at the original minimum active-leg length. This is valid because the original direction implications impose that lower bound whenever an axis is active. Inactive axes remain represented by zero. These reductions decrease the number of binary choices without excluding any original feasible route.

### Linearization of support-cost products

Products involving leg existence and support classification were replaced by Boolean conjunctions. For binary quantities \(a\) and \(b\),
\[
ab=\operatorname{bool2int}(a=1\land b=1).
\]

The original existence indicators and preferred-level classifications are binary, so distributing the support-cost expression into such conjunctions preserves its value exactly. This avoids variable-by-variable multiplication while retaining the original membership conditions and charges.

### Endpoint-distance cuts

For each coordinate, the reformulation adds
\[
\sum_i L_{i,k}\geq
|x_{\mathrm{destination},k}-x_{\mathrm{origin},k}|.
\]

These inequalities follow from the triangle inequality: the signed coordinate changes telescope to the fixed endpoint displacement, and each leg’s directional length equals the absolute change. They are therefore redundant for integer-feasible routes, but can strengthen the mixed-integer relaxation.

## Implementation and solution interface

All original independent decision variables were retained. The mapping script copies their solution values and restores any omitted fixed endpoint coordinates from the original singleton domains. Auxiliary cube variables are not returned to the original model.

During repair, two accidentally omitted entries in the box-size literal were restored from the supplied source, resolving the array-dimension mismatch without changing instance data.

The reformulation is intended to improve HiGHS compatibility and relaxation strength. **No measured solve-time improvement or optimality result was established in the conversation.**

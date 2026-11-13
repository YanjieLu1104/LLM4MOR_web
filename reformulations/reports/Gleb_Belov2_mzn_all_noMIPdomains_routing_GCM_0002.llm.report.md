# Pipe Routing with Clearance, Support, and Flexibility Requirements

## Real-world background

The model describes the three-dimensional routing of a single industrial pipe between two fixed nozzle connections. Coordinates are integer-valued, with each coordinate unit representing **200 mm**. The pipe follows an axis-aligned route through an environment containing **87 fixed boxes**, representing equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels.

A feasible route must avoid designated obstacles with the specified clearance, respect nozzle directions and leg-length limits, and place intermediate nodes in support zones. Cubic-length constraints represent an engineering flexibility requirement: lengths in directions orthogonal to each coordinate axis must provide sufficient flexibility relative to the nozzle displacement along that axis.

These interpretations follow from the model’s data names and constraints. Two important limitations are explicit in the source: the constraint requiring passage through a rack is commented out, and separation between different legs of the same pipe is not imposed.

## Original formulation

### Variables and route representation

There are **10 nodes**, giving **9 possible connecting legs**. The route can terminate before all nine legs are used; subsequent legs have zero length.

The independently declared integer variables are:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 leg bounding-box coordinates**, representing the lower and upper corners of each leg’s radius-expanded box.
- **30 coordinatewise leg lengths**.
- **10 direction variables**, encoding absence or one of six signed coordinate directions.
- **10 existence flags** and **10 last-leg flags**.
- **One objective variable**.

The leg arrays contain ten entries, although only nine represent possible connections. The final, non-leg entry is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The original formulation enforces:

1. **Route geometry.** Each existing leg follows one coordinate axis. Its length agrees with the endpoint displacement, and its bounding box includes the pipe radius.
2. **Leg sequencing.** Existing legs form a prefix, exactly one is the last leg, and the first three legs must exist.
3. **Orthogonal turns.** Consecutive existing legs cannot use the same axis, excluding both straight continuation and immediate reversal.
4. **Nozzle requirements.** The first and last existing legs obey prescribed directions and nozzle-specific length limits.
5. **Obstacle clearance.** Each relevant leg–obstacle pair must be separated along at least one axis. Specific exceptions allow connection to the endpoint modules.
6. **Support requirements.** Intermediate node positions must belong to at least one support zone. Membership uses the node center horizontally and the pipe bottom vertically. These requirements also apply to intermediate nodes associated with unused trailing legs.
7. **Flexibility.** For each axis, the sum of cubed leg lengths in the other two axes must exceed a coefficient times each relevant orthogonal leg length. The coefficient depends on fixed nozzle displacement and the supplied engineering factor.

### Objective

The model minimizes the sum of scaled pipe-length, bend, and support costs. The original scaling divides monetary coefficients by 100 and adds one. For this instance, the length coefficient is **201**, the bend coefficient is **2,001**, and support costs are **51** outside preferred levels and **1** within them.

The reformulation preserves these coefficients, including the added units, rather than substituting unscaled physical costs.

## Reformulation and justification

### Linear signed-length formulation

Each coordinatewise leg length is split into nonnegative positive- and negative-direction components, controlled by binary direction indicators. Linear equations then express endpoint displacement and the radius-expanded bounding box.

This is exact because the original bounding-box inequalities and length equation imply
\[
L \ge |x_{\mathrm{end}}-x_{\mathrm{start}}|.
\]
The selected direction imposes the reverse inequality for its signed displacement; an unselected axis has zero length. Consequently, every original feasible leg already has an exact axis-aligned displacement and a tight bounding box. The new equations express those same relationships directly.

### Bound preprocessing and exact cubic linearization

For each leg and axis, the reformulation derives an upper length bound from:

- The original general leg-length limit.
- The maximum possible endpoint difference implied by coordinate domains.
- The applicable first-leg or last-possible-leg nozzle bounds.

Axes forbidden by the nozzle direction receive a zero upper bound. These restrictions are valid because the geometry constraints make leg length equal to absolute endpoint displacement.

Positive candidate lengths below the original general minimum of eight units are excluded. Although the nozzle-specific lower bounds are three units, the original direction constraints also impose the general eight-unit minimum on every selected axis, including nozzle legs.

Binary selectors choose a positive integer length from the remaining range; no selected value represents zero length. Both length and its cube are expressed as weighted sums of the same selectors. Thus, the cubic flexibility constraints become **exact linear integer constraints**, not piecewise approximations. This makes the formulation suitable for HiGHS, at the cost of introducing additional binary variables.

### Linear support costs

The original support cost multiplies an existence flag by a membership-dependent expression. The reformulation distributes that product and represents each binary product using a Boolean conjunction.

This is valid because existence flags, preferred-level membership indicators, and the nonpreferred indicator are binary. Their products therefore equal the indicators of the corresponding conjunctions. The original membership definitions and the binary domain of the nonpreferred indicator remain enforced.

### Removal of vacuous inter-pipe separation

The instance contains only one pipe. The original inter-pipe separation constraints apply only to pairs with different pipe identifiers, so their indexing set is empty. The associated separation indicators are consequently unnecessary.

Omitting them does not remove collision protection required by the original model: obstacle avoidance remains, while same-pipe self-separation was never imposed.

### Solution interface

All original independent variables are retained. The mapping script forwards their solution values, restores the fixed endpoint coordinates from the embedded instance, and preserves array index encodings. It obtains the original objective variable from the shared `objective` field, avoiding reliance on an unavailable `variables.obj` field.

## Expected effect

The main improvement is a fully linear mixed-integer representation of geometry, support costs, and cubic flexibility. Bound preprocessing reduces the number of length-selection binaries, while explicit directional equations expose route structure to the solver. These changes preserve the original feasible routes and objective values; no measured runtime improvement is established by the conversation.

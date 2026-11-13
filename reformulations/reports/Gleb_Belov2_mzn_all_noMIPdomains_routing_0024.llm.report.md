# Pipe Routing Around Industrial Obstacles

## 1. Background and interpretation

The model describes the routing of a single pipe between two fixed connection points in a three-dimensional industrial layout. The interpretation follows from the supplied data and constraints: fixed boxes represent equipment modules, existing pipe segments, support zones, and pipe racks.

The route is represented by ten ordered nodes and at most nine straight legs. Each nonzero leg runs parallel to one coordinate axis. Consecutive active legs must use different axes, representing right-angle bends. Coordinates are integer-valued, with one coordinate unit corresponding to 200 mm.

The route must:
- avoid equipment and existing-pipe obstacles, accounting for specified clearance;
- satisfy prescribed directions and length limits at its two connections;
- place intermediate nodes within permitted support regions.

Preferred rack levels offer cheaper support. Although the data contain a rack-traversal flag, the corresponding constraint is commented out in the original model. Thus, passing through a rack is **not** mandatory.

## 2. Original mathematical formulation

### Variables and route structure

The original model declares:
- **30 integer node coordinates**, including six fixed endpoint coordinates;
- **60 integer leg-boundary variables**, describing lower and upper corners of leg bounding boxes;
- **30 nonnegative integer coordinatewise leg lengths**;
- **10 direction variables**, with zero denoting an inactive leg and values 1–6 denoting signed coordinate directions;
- **10 binary existence indicators** and **10 binary last-leg indicators**;
- an integer objective variable.

The leg arrays contain ten indexed positions, but only the first nine represent potential connections between nodes. The final position is fixed to zero.

Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

**Geometry and direction.** Bounding-box inequalities, length equalities, and direction implications jointly ensure that each active leg is an axis-aligned segment between consecutive nodes. Its selected coordinate has positive length; its other coordinate lengths are zero.

**Active-leg sequence.** Existence and last-leg equations create a contiguous prefix of active legs followed by inactive legs. The first three legs must exist, and exactly one active leg is designated last. Inactive legs have zero displacement, so subsequent nodes coincide.

**Connection requirements.** The first leg has a prescribed direction and bounded length. The dynamically selected last leg has its own prescribed incoming direction and length bounds, and ends at the destination.

**Bends.** Consecutive legs cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.

**Obstacle avoidance.** A leg must be separated from each applicable obstacle along at least one axis. The original formulation includes specific exceptions for the first connection’s module and for the destination module. These exceptions are retained.

**Support membership.** Intermediate node positions must lie in at least one support zone. This requirement applies even to intermediate positions associated with inactive legs. Preferred-level membership determines support cost, but only existing bends incur that cost.

The source also contains inter-pipe separation and flexibility machinery. Neither imposes an active restriction in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes a weighted sum of pipe length, bends, and support costs. With the supplied coefficients and the original integer scaling rule, this is:

\[
51\,(\text{total coordinate-unit length})
+501\,(\text{number of active legs after the first})
+\text{support cost}.
\]

Each charged support costs 51 outside preferred rack levels and 1 inside them. The reformulation preserves this scaling and the minimization direction.

## 3. Reformulation and justification

### Linear signed-displacement formulation

The direction-dependent length implications were replaced by positive- and negative-direction binary indicators and corresponding nonnegative displacement variables.

For each leg and coordinate, the new equations express:

\[
\text{endpoint displacement}
=\text{positive displacement}-\text{negative displacement},
\]

\[
\text{length}
=\text{positive displacement}+\text{negative displacement}.
\]

The sum of all six direction indicators equals the leg’s existence indicator. Consequently, an active leg selects exactly one signed direction, while an inactive leg has zero displacement.

**Why this is equivalent:** In the original model, the bounding box encloses both endpoints, so its coordinatewise length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality, forcing equality. Unselected coordinates have zero length and therefore equal endpoint coordinates. The new equations express these same consequences directly, while retaining the original minimum-length requirements and direction codes.

This is a **disaggregated mixed-integer linear formulation**, intended to expose the routing geometry more directly to HiGHS.

### Exact leg boundaries and tighter bounds

Leg boundaries are now linked directly to the starting coordinate and signed displacements. Bounds also exploit both endpoint domains: the lower boundary is the smaller endpoint coordinate minus the radius, and the upper boundary is the larger endpoint coordinate plus the radius.

**Why this is valid:** The original geometry and direction constraints already force those exact boundaries; they do not permit extra bounding-box slack. The tightened bounds therefore exclude no feasible original route and can strengthen subsequent separation constraints.

### Bound-based obstacle preprocessing

Obstacle disjunctions are simplified before solving:
- a leg–obstacle constraint is omitted if endpoint bounds guarantee separation along some axis;
- an individual separation alternative is omitted if endpoint bounds prove it impossible.

**Why this is valid:** Guaranteed separation makes the entire disjunction true for every feasible assignment. An impossible alternative can never satisfy the disjunction. These tests use the exact leg-boundary interpretation established above and retain the original clearance distances and module exceptions.

This is **domain-based disjunctive preprocessing**, rather than an approximation of obstacle geometry.

### Boolean linearization of support costs

The original support-cost expression multiplies leg existence by a membership-dependent cost. The reformulation instead charges each constant cost through a Boolean conjunction of existence and the relevant membership condition.

**Why this is equivalent:** For binary indicators \(a\) and \(b\), their product equals the indicator of \(a\land b\). Distributing the original expression over its terms therefore gives exactly the new expression. Support membership and the original preferred-level restriction remain unchanged.

### Directional leg-count cuts

Additional inequalities bound the number of legs needed in each signed direction. They combine endpoint displacement with the maximum leg length and the smaller maximum lengths of mandatory nozzle legs.

**Why these cuts are valid:** Summing leg displacements telescopes to the fixed endpoint displacement. Positive-direction travel must therefore be at least the positive part of that displacement, and similarly for negative travel. Each selected leg contributes at most the general length limit. When a mandatory first or last leg uses that direction, its smaller nozzle limit reduces the available capacity. Dividing the resulting necessary capacity requirement by the general length limit and rounding upward yields a valid integer leg-count bound.

These are **capacity-based valid inequalities**; they do not assume that the route is monotone.

### Removal of inactive machinery

Inter-pipe separation expressions were removed because all nodes belong to the same pipe. The original constraints apply only to pairs from different pipes, so their index set is empty.

The nonlinear flexibility machinery was reduced to zero-valued quantities because the supplied flexibility coefficient is zero. The original conditional expressions already evaluate to zero, and the corresponding constraints evaluate to true.

These are **instance-specific constant-folding reductions**, justified directly by the unchanged input data.

## 4. Solution interface and scope

All original independent decision variables retain their names, index domains, and meanings. The accompanying mapping script returns only those variables, preserves array encodings, and reconstructs fixed endpoint coordinates if solver output omits them. Missing nonfixed values are reported rather than guessed.

The reformulation targets a clearer linear formulation, tighter bounds, and fewer unnecessary logical expressions. No solve-time measurements were supplied, so improved computational performance remains an intended benefit rather than an experimentally established result.

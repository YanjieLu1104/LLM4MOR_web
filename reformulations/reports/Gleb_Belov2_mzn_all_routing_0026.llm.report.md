# Pipe Routing with Obstacles and Support Zones

## Problem background

The model represents an industrial pipe-routing problem in a three-dimensional installation. A pipe must connect two fixed nozzles using axis-aligned straight segments. Its route must avoid equipment modules and existing pipe segments, respect nozzle connection directions, and place intermediate nodes in designated support regions.

Coordinates are integer multiples of a 200 mm length unit. The supplied instance contains one pipe, 10 route nodes, and 193 fixed boxes. Box types distinguish equipment modules, existing pipe segments, module support zones, a rack region, and preferred rack support levels.

The route may use fewer than its nine available segments. Unused trailing segments have zero length and coincide with the destination nozzle. Consecutive nonzero segments must use different coordinate axes.

Two details distinguish the implemented model from a more general physical routing problem:

- Pipe radius is computed using integer division. The supplied diameter is 1, so the modeled radius is zero; obstacle safety distances still apply.
- Although a “through rack” flag is supplied, its corresponding constraint is commented out. Rack traversal is therefore not mandatory.

## Original formulation

### Variables

The original independent integer variables comprise:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 segment-bound coordinates**, representing lower and upper corners in three dimensions for 10 segment slots.
- **30 nonnegative coordinate-wise segment lengths**.
- **10 direction variables**, with 0 meaning an absent segment and 1–6 representing signed coordinate directions.
- **10 segment-existence flags** and **10 last-segment flags**.
- **One objective variable**.

Thus, there are 151 independently declared scalar integer variables before preprocessing, although many are fixed or determined by constraints. Only nine segment slots connect consecutive nodes; the tenth is a dummy slot fixed to zero.

Additional defined arrays represent obstacle separation, support-zone membership, preferred-level membership, support costs, and flexibility expressions.

### Constraints

The main constraint groups enforce:

1. **Segment geometry:** Segment boxes enclose their endpoint nodes, and their widths determine segment lengths after accounting for radius.
2. **Axis alignment and direction:** An existing segment moves along exactly one signed coordinate axis. Its active length satisfies a positive lower bound; other coordinate lengths are zero.
3. **Route sequencing:** Existing segments form a prefix, exactly one is designated last, and the first three segments must exist.
4. **Nozzle connections:** The first segment has prescribed direction and length bounds. The dynamically selected last segment has its own prescribed direction and length bounds and ends at the destination.
5. **Orthogonal consecutive segments:** Adjacent segments cannot use the same coordinate axis, even with opposite signs.
6. **Obstacle avoidance:** Each relevant segment box must be separated from each obstacle along at least one axis. Explicit exceptions permit connection through the starting and ending modules.
7. **Support feasibility:** Intermediate node slots must lie in at least one support zone. This requirement also applies to unused intermediate slots.
8. **Support costing:** Preferred rack levels receive their specified support costs; other supported locations use the default cost.

The source also contains inter-pipe separation constraints and conditional flexibility constraints. Neither restricts this particular instance, as explained below.

### Objective

The model minimizes the sum of length, bend, and support costs. It uses the original integer scaling rule
\[
\widehat c=\left\lfloor c/100\right\rfloor+1.
\]

For this instance, each unit of pipe length costs 51, each existing segment after the first contributes a bend cost of 501, and each associated support costs either 51 outside preferred rack levels or 1 within them. The reformulation preserves these coefficients and the minimization direction exactly.

## Reformulation and justification

### Disaggregated signed-direction formulation

The direction implications were replaced by positive- and negative-direction binaries and corresponding nonnegative lengths for each segment and coordinate.

Writing these lengths as \(p_{ik}\) and \(m_{ik}\), the formulation imposes
\[
x_{i+1,k}-x_{i,k}=p_{ik}-m_{ik},
\qquad
L_{ik}=p_{ik}+m_{ik}.
\]
The sum of all signed-direction binaries for a segment equals its existence flag, so an existing segment selects exactly one direction.

This is equivalent to the original geometry. In the original model, endpoint enclosure makes the segment length at least the absolute endpoint displacement. The selected direction imposes the reverse inequality, making the length equal to that displacement. Inactive coordinates have zero length and therefore equal endpoint coordinates. These facts also determine the segment-box bounds uniquely.

The new formulation expresses those consequences directly through linear equations rather than recovering them through multiple implications.

### Direction-specific bound tightening

Each signed length receives an upper bound derived from the original coordinate domains and segment-length limit. For example,
\[
p_{ik}\le
\min\!\left(U_i,\max(0,\overline{x}_{i+1,k}-\underline{x}_{i,k})\right)b^+_{ik}.
\]

The corresponding negative-direction bound reverses the endpoints. These bounds are valid because no endpoint displacement can exceed the difference between the relevant domain extremes, and the original segment-length upper bound also remains applicable.

This is domain-based preprocessing and strengthens the mixed-integer relaxation without excluding feasible routes.

### Support-zone selection with geometric preprocessing

For support feasibility, the reformulation introduces binary witnesses that select one containing support zone for each required intermediate node.

A node–zone pair is ruled out in advance if their coordinate ranges do not intersect in any dimension, using the original bottom-of-pipe adjustment in the vertical dimension. For remaining pairs, bounded linear implications enforce containment when the zone is selected.

This preserves the original existential requirement: a node lies in at least one support zone if and only if some containing zone can be selected. Selecting one witness does not prohibit simultaneous membership in other zones. The requirement remains unconditional for the same intermediate node slots as in the original model.

### Exact preferred-level membership and linear support costs

Preferred-level membership remains an exact geometric condition because it affects cost. The original restriction
\[
f^{\text{not-pref}}_i
=1-\sum_{z\in\text{preferred}}b_{iz},
\qquad
f^{\text{not-pref}}_i\in\{0,1\},
\]
is retained.

Products of an existence flag and a membership flag are replaced by Boolean conjunctions. For binary quantities, multiplication equals conjunction, so this is an exact binary-product linearization, not an approximation of the objective.

### Endpoint-displacement cuts

If the destination coordinate is strictly smaller than the starting coordinate, at least one negative-direction segment is required in that dimension; the analogous rule applies to positive displacement.

These cuts follow by summing the segment-displacement equations over the route. The sum telescopes to the fixed endpoint displacement, which cannot be negative if every segment displacement in that dimension is nonnegative. All three endpoint coordinates decrease in this instance, so each dimension requires negative movement.

### Removal of inactive model components

Two source components were omitted on instance-specific grounds:

- **Inter-pipe separation:** Every node belongs to the same pipe. The original constraints are generated only for pairs belonging to different pipes, so their index set is empty.
- **Flexibility:** The supplied flexibility coefficient is zero. The original conditional expressions therefore evaluate to zero, and every corresponding flexibility constraint evaluates to true.

These are constant-folding reductions, not additional modeling assumptions. No self-intersection restriction or mandatory rack-traversal constraint was introduced.

## Data and solution interface

The embedded instance data are preserved. During repair, an accidentally duplicated entry in the reformulated box-size array was removed to restore the original 579 entries: three dimensions for each of 193 boxes.

All original independent decision-variable names and meanings remain available. The mapping script copies the original coordinate, segment, and objective variables, reconstructs the six fixed endpoint coordinates from their original singleton domains, and excludes reformulation-specific auxiliaries.

The changes are intended to give HiGHS a more explicit and tighter linear formulation. No measured solve-time improvement is established by the conversation.

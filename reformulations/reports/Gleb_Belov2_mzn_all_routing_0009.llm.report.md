# Reformulation Report: Three-Dimensional Pipe Routing

## 1. Application background

The model represents the routing of a pipe between two fixed equipment nozzles in a three-dimensional industrial layout. Coordinates are integer multiples of a 200 mm length unit. The route consists of axis-aligned straight legs, with consecutive active legs required to turn onto different coordinate axes.

The layout contains equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. The routed pipe must avoid solid obstacles with the prescribed clearance. Intermediate nodes must lie in permitted support zones, measured at the bottom of the pipe rather than its center in the vertical direction.

The objective balances pipe length, bends, and support costs. The supplied instance contains one pipe, ten node positions, and nine possible connecting legs. Unused trailing legs collapse to the destination nozzle.

Some application features are present only as data or inactive code. In particular, the rack-traversal constraint is commented out, and the flexibility coefficient is zero. Neither feature imposes an additional routing requirement in this instance.

## 2. Original mathematical model

### Variables and route structure

The original independent declarations contain **151 integer scalar entries**, before presolve:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional positions; six endpoint coordinates are fixed |
| Lower and upper leg-box coordinates | 60 | Radius-expanded bounding boxes for the legs |
| Coordinatewise leg lengths | 30 | Nonnegative lengths along each axis |
| Leg directions | 10 | Zero for an unused leg; six signed coordinate directions otherwise |
| Existence and last-leg indicators | 20 | Binary route-sequence decisions |
| Objective variable | 1 | Total scaled routing cost |

The leg arrays include a tenth, dummy entry, whose values are fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and other derived quantities.

### Constraints

The main constraint groups are:

- **Orthogonal geometry:** Each active leg moves along exactly one signed coordinate direction. Its length, endpoint displacement, and radius-expanded bounding box are linked.
- **Route sequence:** Active legs form a prefix. Exactly one leg is designated last, and at least the first three legs exist.
- **Nozzle connections:** The first and last active legs obey prescribed directions and length bounds. The last active leg ends at the fixed destination.
- **Turns:** Consecutive active legs use different axes, excluding both straight continuation and immediate reversal.
- **Obstacle clearance:** A leg must be separated from each applicable solid obstacle along at least one coordinate axis. Specific exceptions apply to the source module and to the destination module.
- **Support feasibility:** Every intermediate node indexed by a nonfirst candidate leg must belong to a support zone. This requirement also applies to nodes associated with unused trailing legs.
- **Support pricing:** Preferred-level membership determines the support charge, which is incurred only when the corresponding leg exists.

The original model does not impose self-separation between legs of the same pipe. Inter-pipe separation has no applicable pairs because the instance contains only one pipe.

### Objective

The model minimizes the original scaled cost, including its integer division and “plus one” convention. For this instance:

- Pipe length costs **161 per discretized length unit**.
- Each active leg after the first costs **1,601**, representing a bend.
- Each corresponding support costs **51 outside preferred levels** or **1 within a preferred level**.

These coefficients and the minimization direction were preserved.

## 3. Reformulation and validity

### Exact linear representation of signed movement

The direction implications were replaced by one-hot positive and negative direction indicators, with separate nonnegative lengths for each sign.

For each leg and axis, the formulation enforces
\[
x_{i+1,k}-x_{i,k}=\ell^+_{i,k}-\ell^-_{i,k},
\qquad
L_{i,k}=\ell^+_{i,k}+\ell^-_{i,k}.
\]
Across all axes and signs, the sum of direction indicators equals the leg-existence indicator.

This is equivalent to the original geometry. Originally, the bounding-box inequalities imply
\[
L_{i,k}\ge |x_{i+1,k}-x_{i,k}|.
\]
For the selected direction, the directional constraint supplies the reverse inequality. For every unselected axis, length is forced to zero. Consequently, the original constraints already require exact endpoint displacement and exact radius-expanded bounding boxes.

The reformulation expresses those consequences directly:
\[
B^-_{i,k}=x_{i,k}-\ell^-_{i,k}-r,
\qquad
B^+_{i,k}=x_{i,k}+\ell^+_{i,k}+r.
\]

This removes several layers of logical implications and exposes a linear mixed-integer structure to HiGHS.

### Bound-based preprocessing

Signed-length upper bounds were derived from the declared endpoint-coordinate bounds, the general leg-length limit, and the applicable first- or final-candidate nozzle limit.

For example, positive displacement cannot exceed
\[
\operatorname{ub}(x_{i+1,k})-\operatorname{lb}(x_{i,k}).
\]
These bounds exclude no feasible movement: they follow directly from the coordinate domains and existing length restrictions.

Obstacle disjunctions were also simplified:

- An entire obstacle test is omitted when coordinate bounds guarantee separation on at least one axis.
- A particular separation alternative is omitted when coordinate bounds make that alternative impossible.

These tests use the exact bounding-box interpretation established above, together with the original pipe radius and safety distances. All remaining obstacle requirements and nozzle-module exceptions are retained.

### Support-zone containment preprocessing

A support zone contained in another support zone was removed **only from the disjunction requiring support feasibility**. Equal zones are handled with a deterministic tie-break.

This is valid because all zones use the same membership convention: horizontal coordinates refer to the node center, while the vertical coordinate refers to the pipe bottom. Membership in a contained box therefore implies membership in its containing box. Removing the smaller box from their union does not change the set of admissible node positions.

Membership definitions used for preferred-level pricing were retained. Thus, removing a redundant feasibility alternative does not alter support costs.

### Linear support-cost formulation

The original support cost multiplies leg existence by a membership-dependent charge. The reformulation distributes this expression into weighted Boolean conjunctions, such as
\[
\text{leg exists}\ \land\ \text{node is in a preferred level}.
\]

For binary quantities, multiplication equals conjunction. The original binary domain and defining equation for the “not in a preferred level” indicator are retained, so the reformulation also preserves the original restriction on simultaneous preferred-level memberships. The resulting cost is exact, not an approximation.

### Instance-specific removal of inactive expressions

Two parts of the original formulation have no effect for the supplied data:

- **Inter-pipe separation:** Every node belongs to the same pipe, so no pair satisfies the original different-pipe filtering condition.
- **Flexibility:** The supplied flexibility coefficient is zero. The original condition therefore makes every flexibility constraint true and every associated orthogonal cubic-length sum zero.

Their removal follows from the fixed instance data; it is not an assumption about pipe-routing problems generally.

### Valid length inequalities

The reformulation adds redundant inequalities to strengthen the linear relaxation:

- Signed movements summed over the route equal the fixed endpoint displacement.
- Total movement along each axis is at least the absolute endpoint displacement.
- Positive and negative movement totals cover the mandatory first- and last-nozzle legs.
- Remaining route length along an axis is at least the absolute displacement from the current node to the destination.

The endpoint identities follow by telescoping the leg-displacement equations. The distance bounds follow from the triangle inequality. The nozzle bounds follow from the prescribed signed directions and the existing minimum lengths; the first and last active legs are distinct because the original sequence constraints require at least three active legs.

These inequalities do not remove feasible routes, but can improve lower bounds during mixed-integer search.

## 4. Solution interface and expected effect

All original independent variables retain their original names and meanings. The supplied mapping script returns only those variables, copies their encoded array domains unchanged, and restores fixed endpoint coordinates if they are absent from solver output. It also obtains the original objective variable from either its emitted value or the unchanged optimization objective.

The intended benefit is a clearer linear formulation, tighter variable bounds, fewer redundant obstacle and support alternatives, and stronger relaxation inequalities. No measured runtime improvement was established in the conversation; the changes are designed to improve solving performance while preserving the original feasible routes and objective values.

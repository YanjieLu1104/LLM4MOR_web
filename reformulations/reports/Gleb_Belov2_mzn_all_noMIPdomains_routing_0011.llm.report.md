# Orthogonal Pipe-Routing Model: Reformulation Report

## 1. Application and instance background

The model represents three-dimensional routing of an industrial pipe between two fixed equipment connections, or **nozzles**. The route must avoid equipment and existing pipework while placing intermediate nodes in regions where supports are available.

Coordinates use a discretization of **200 mm per unit**. This instance contains one pipe, ten ordered nodes, and nine possible connecting legs. The endpoints are fixed at \((79,41,5)\) and \((125,60,163)\); intermediate coordinates are integer decision variables. Each active leg runs parallel to one coordinate axis.

Fixed boxes describe equipment modules, existing pipe legs, support zones, a pipe rack, and preferred rack support levels. Collision checks include the modeled pipe radius and box-specific safety distances. Preferred rack levels offer cheaper support.

Two features present in the source are inactive here:

- Inter-pipe collision constraints have no applicable pairs because there is only one pipe.
- Flexibility constraints are disabled by the pipe’s zero flexibility coefficient.

Although the input contains a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.

## 2. Original mathematical structure

### Decision variables

The original model declares **151 independent scalar integer variables**, counting array entries:

| Group | Count | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional nodes, including six fixed endpoint coordinates |
| Lower and upper leg-box coordinates | 60 | Radius-expanded bounding boxes for legs |
| Coordinate-wise leg lengths | 30 | Nonnegative extent along each axis |
| Leg directions | 10 | Zero for an inactive leg; six signed axis directions otherwise |
| Leg-existence flags | 10 | Binary indicators of active legs |
| Last-leg flags | 10 | Binary indicators identifying the terminal active leg |
| Objective variable | 1 | Total scaled routing cost |

The leg arrays include a tenth, non-leg entry that is fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, and costs.

### Constraints

The main constraint groups are:

- **Route geometry:** Bounding boxes contain both endpoints, expanded by the modeled radius. Length and direction constraints ensure that an active leg moves along exactly one axis.
- **Route sequence:** Active legs form a prefix of the nine possible legs. The first three must exist, and exactly one active leg is terminal.
- **Bends:** Consecutive active legs cannot use the same coordinate axis, excluding both straight continuations and immediate reversals.
- **Nozzle connections:** The first and terminal legs have prescribed directions and restricted lengths. The terminal leg reaches the fixed destination.
- **Obstacle avoidance:** A leg must be separated from each applicable obstacle along at least one axis. Specific exemptions permit connection to the source and destination modules.
- **Support feasibility:** Intermediate node centers must lie within a support zone horizontally, with the pipe bottom inside its vertical interval. This requirement also applies to intermediate nodes belonging to the inactive suffix.
- **Support classification:** Preferred-level membership determines support charges.

Inactive legs have zero displacement, so nodes after the terminal leg coincide with the destination.

### Objective

The model **minimizes** scaled pipe-length, bend, and support costs. With the supplied data, its coefficients are:

- **141** per unit of pipe length;
- **1,401** per active leg after the first, representing a bend;
- **51** for an ordinary supported bend, or **1** at a preferred rack level.

These coefficients preserve the original integer division by 100 followed by addition of one.

## 3. Reformulation and validity

### One-hot directions and signed lengths

The direction implications were replaced with six binary direction indicators per leg and nonnegative positive- and negative-direction lengths for each axis.

Their sum equals the original existence flag. Node displacement is the positive length minus the negative length; total axis length is their sum. Each signed length is bounded by its direction indicator, the original length limit, and the maximum displacement allowed by endpoint coordinate domains.

This is equivalent to the original geometry. Originally, endpoint containment implies that axis length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality, while unselected axes have zero length. Thus length equals absolute displacement and the expanded bounding box is uniquely determined. The new linear equalities express those same relationships directly.

This extended mixed-integer formulation is intended to strengthen the HiGHS relaxation and reduce reliance on reified direction implications.

### Domain-based obstacle preprocessing

An obstacle check is omitted only when coordinate bounds prove that every possible leg position is already separated from that obstacle along some axis.

For example, separation is guaranteed if the obstacle’s upper face plus its safety distance is no greater than the smallest possible radius-expanded lower leg coordinate. The symmetric test applies on the opposite side.

These tests follow directly from the original bounding-box bounds. They remove only constraints that are necessarily satisfied, including for inactive legs; no general inactive-leg collision exemption was introduced.

### Support-zone containment preprocessing

The support-feasibility disjunction now uses only zones not contained in another support zone. Equal boxes are resolved deterministically by index.

This is valid because the original membership test uses the same node-center and pipe-bottom convention for every zone. Membership in a contained box therefore implies membership in its containing box, so removing the contained box from the union does not change feasibility.

Preferred-level membership remains available separately for cost calculations. The preprocessing does not erase distinctions between cheap and ordinary support locations.

### Endpoint-displacement inequalities

Two families of valid inequalities were added:

1. Total length along each axis is at least the absolute endpoint displacement along that axis. This follows by summing leg displacements and applying the triangle inequality.
2. A nonzero endpoint displacement requires at least one leg on that axis. On the prescribed first-leg axis, at least two such legs are required if the endpoint displacement exceeds the first-nozzle length limit.

For this instance, the vertical displacement is 158 units, whereas the first leg can be at most 15 units long. At least one additional vertical leg is therefore necessary. These inequalities expose consequences of the original geometry to the linear relaxation without restricting feasible routes.

### Support-cost linearization

The original support charge multiplies leg existence by a membership-dependent integer cost. It was rewritten as a default charge times existence, plus preferred-level cost adjustments activated by Boolean conjunctions of existence and membership.

This follows algebraically from the original relation
\[
f_{\text{not preferred}}=1-\sum_z b_z.
\]
The original binary domain of this expression is retained, preserving its restriction on simultaneous preferred-level memberships. The rewrite preserves costs while avoiding the general integer product.

### Interface and compilation repairs

All original independent variables retain their names and meanings. The mapping script returns only those variables, preserves array encodings, and reconstructs omitted singleton-domain endpoint coordinates from the unchanged self-contained data.

Compile-time endpoint calculations were changed from `fix` calls to lower-bound queries. This is valid here because every endpoint coordinate has a singleton domain, so its lower bound is its exact fixed value.

The final formulation preserves the original objective and minimization direction. Its performance benefits are motivated by the stronger linear representation and redundant-check removal; no measured speedup is established by the reported compilation repairs alone.

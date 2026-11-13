# Pipe-Routing Model and Reformulation Report

## 1. Real-world background

The model represents an industrial pipe-routing problem in a three-dimensional plant layout. A pipe must connect two fixed equipment nozzles while avoiding rectangular obstacles representing equipment modules and existing pipe segments.

The route uses axis-aligned straight legs joined by bends. Coordinates are integer-valued, with one coordinate unit corresponding to **200 mm**. The supplied instance has one pipe, ten ordered nodes, and up to nine actual legs. The endpoint coordinates are fixed at `(308, 25, 3)` and `(308, 47, 48)`.

The layout also contains support zones, a rack region, and preferred rack levels. Intermediate nodes must belong to a permitted support zone, and bends on preferred levels can have lower support costs. Prescribed nozzle directions and length limits control how the route leaves and enters the equipment.

These interpretations follow from the model’s data names, comments, and geometric constraints; the file does not provide additional engineering documentation.

## 2. Original formulation

### Variables

The original independent declarations contain **151 integer-valued scalar entries**, including fixed entries:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each of ten nodes; six endpoint coordinates are fixed |
| Lower and upper leg bounds | 60 | Bounding-box corners for each leg-array entry |
| Component lengths | 30 | Nonnegative lengths along the three axes |
| Direction codes | 10 | Zero for an inactive leg; six codes for signed axial directions |
| Existence and last-leg flags | 20 | Binary-valued indicators describing the active route prefix |
| Objective | 1 | Total scaled routing cost |

The leg arrays include a tenth, dummy entry, which is fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The main constraint groups are:

- **Route geometry:** Leg bounds enclose consecutive nodes, and their width determines the component length after accounting for the pipe radius. Direction implications permit movement along only one signed axis.
- **Active-leg sequence:** Existing legs form a contiguous prefix. Exactly one leg is marked last, and the first three legs must exist.
- **Bend geometry:** Consecutive existing legs must use different axes, excluding both straight continuation and immediate reversal.
- **Nozzle connections:** The first and last active legs have prescribed directions and bounded lengths. The last active leg ends at the fixed destination.
- **Obstacle avoidance:** Each applicable obstacle and leg must be separated along at least one coordinate axis, including the specified clearance. Explicit exceptions permit the nozzle legs to connect to their associated modules.
- **Support membership:** Intermediate nodes must lie in a support zone. Importantly, this requirement is not conditional on leg existence.
- **Support cost:** Preferred rack-level membership determines the support charge at an existing bend.

The source also contains inter-pipe separation and flexibility constraints. Neither imposes a restriction in this instance: all nodes belong to the same pipe, and its flexibility coefficient is zero.

### Objective

The model **minimizes** pipe-length, bend, and support costs. The original coefficient transformation—integer division by 100 followed by adding one—is preserved.

For this instance:

- Pipe length costs **61 per coordinate unit**.
- Each existing leg after the first incurs a **601 bend charge**.
- Each corresponding support costs **51 outside preferred rack levels**, or **1 on a preferred level**.

These are the model’s scaled optimization coefficients, not unmodified monetary costs.

## 3. Reformulation and justification

### Signed-direction disaggregation

The reformulation introduces positive- and negative-direction indicators and nonnegative signed-length components for each leg and axis. Their indicator sum equals the leg-existence flag, so an existing leg selects exactly one signed direction; an inactive leg selects none.

Node displacement and component length are then expressed by linear equations:

\[
x_{i+1,k}-x_{i,k}=p_{i,k}-m_{i,k},
\qquad
L_{i,k}=p_{i,k}+m_{i,k}.
\]

This replaces the original direction-dependent implications with a disaggregated mixed-integer linear formulation.

**Why it is equivalent:** In the original model, the enclosing leg bounds imply that the component length is at least the absolute endpoint displacement. The selected direction imposes the reverse inequality for its signed displacement, forcing equality. Unselected axes have zero length and therefore zero displacement. The new equations enforce exactly these relationships.

### Exact linear leg-bound equations

The reformulation computes the leg bounds as

\[
a_{i,k}=x_{i,k}-m_{i,k}-r,
\qquad
b_{i,k}=x_{i,k}+p_{i,k}+r.
\]

**Why this is valid:** Once the original component length equals the absolute displacement, the enclosing-bound constraints and the equation \(L=b-a-2r\) leave no extra slack. The lower and upper bounds must therefore be the endpoint minimum minus the radius and endpoint maximum plus the radius. The new equations express those same values without minimum/maximum operators.

### Domain-based directional bounds

Each signed-length component receives an upper bound derived from the endpoint coordinate domains and the original leg-length limit. For example,

\[
p_{i,k}\le
\min\!\left(U,\max(0,\overline{x}_{i+1,k}-\underline{x}_{i,k})\right)u_{i,k}.
\]

**Why this is valid:** A positive displacement cannot exceed the largest possible destination coordinate minus the smallest possible origin coordinate, nor can it exceed the original length limit. These bounds strengthen the linear relaxation and can rule out impossible directions without excluding feasible routes.

### Boolean linearization of support costs

Products involving the existence flag and support membership are replaced by weighted Boolean conjunctions.

**Why this is equivalent:** For binary-valued quantities, their product is one exactly when both are one. The original `fNodeNotInPref` domain and membership equation are retained, so the reformulation also preserves the original restriction on simultaneous preferred-level membership.

### Valid suffix-distance cuts

For each node and coordinate, the remaining component lengths must cover the absolute displacement to the destination. This is expressed as two linear inequalities:

\[
\sum_{j\ge i}L_{j,k}\ge x_{\mathrm{end},k}-x_{i,k},
\qquad
\sum_{j\ge i}L_{j,k}\ge x_{i,k}-x_{\mathrm{end},k}.
\]

**Why these are valid:** Summing consecutive displacements telescopes to the endpoint displacement, and the triangle inequality bounds its magnitude by the sum of component lengths. Inactive legs have zero displacement, so the argument also holds when the route ends before the final candidate leg. These redundant cuts can strengthen the relaxation.

### Instance-specific simplification and solution mapping

- **Inter-pipe separation is vacuous:** Its constraints require two different pipe identifiers, but this instance contains only one.
- **Flexibility constraints are inactive:** The original conditional expressions return zero or `true` when the flexibility coefficient is nonpositive; the supplied coefficient is exactly zero. Removing this inactive block introduces no engineering assumption.
- **Unused defined separation arrays are omitted:** Obstacle separation is imposed directly through the same disjunctions and nozzle exceptions. These arrays were computed expressions, not independent decisions.

All original independent variables remain in the reformulated model. The mapping script copies their solution values, restores the six fixed endpoint coordinates from the unchanged embedded data, and excludes new auxiliary variables.

The changes target a tighter, more explicitly linear formulation for HiGHS. No solve-time measurements were supplied, so a computational speedup has not been established.

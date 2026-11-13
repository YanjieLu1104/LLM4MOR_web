# Pipe-Routing Model and Reformulation Report

## 1. Background and interpretation

The model represents three-dimensional pipe routing through an industrial installation containing equipment modules, existing pipes, and pipe-support structures. It selects a rectilinear route between two fixed connection points while avoiding obstacles and controlling installation costs.

Coordinates are integer multiples of a **200 mm discretization unit**. The supplied instance contains one pipe, represented by ten ordered nodes and therefore at most nine candidate legs. Its endpoints are fixed at `(275, 54, 8)` and `(255, 52, 143)`.

Each nonzero leg runs along one coordinate axis. The first leg must travel in the positive Z direction, and the final active leg must travel in the negative X direction. Both nozzle legs have lengths between 2 and 15 units. Consecutive active legs must use different axes.

Fixed boxes distinguish equipment modules, existing pipe segments, module support zones, a rack, and preferred rack levels. Obstacle clearance and support membership are separate requirements: intermediate nodes must lie in a support zone, but the model does not require every point along a leg to remain within one support zone.

## 2. Original formulation

### Variables

The original independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two arrays of leg-box boundaries, `nXLeg1` and `nXLeg2`, each containing **30 integers**.
- **30 nonnegative component lengths**, `nLLeg`.
- **10 direction variables**, with values zero for an inactive leg and 1–6 for signed axis directions.
- **10 binary existence flags** and **10 binary final-leg flags**.
- An integer objective variable, `obj`.

Leg arrays include a tenth, non-leg position whose entries are fixed to zero. Additional defined arrays describe obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraint groups are:

1. **Leg geometry.**  
   Leg boxes enclose their endpoint coordinates, with the pipe radius added to their boundaries. Component lengths equal box widths minus twice the radius. Direction-dependent constraints force movement along exactly one axis for each active leg.

2. **Route sequence.**  
   Exactly one candidate leg is designated as final. Existence flags form a contiguous active prefix, and the first three legs must exist. Inactive legs have zero length, so subsequent nodes coincide.

3. **Nozzle connections and bends.**  
   The first and final active legs satisfy their prescribed directions and length bounds. Adjacent legs cannot use the same axis, excluding both straight continuation and immediate reversal.

4. **Obstacle clearance.**  
   A leg must be separated from each relevant obstacle along at least one coordinate axis, allowing equality at the clearance boundary. The first leg is exempt from its own starting module. The destination module permits the final leg and inactive legs.

5. **Support membership and costs.**  
   Intermediate node positions must belong to at least one support zone, including positions associated with inactive legs. Membership uses the node center in X and Y and its bottom in Z. Support charges apply only when the corresponding outgoing leg exists.

6. **Inter-pipe separation and flexibility.**  
   These are present in the general source but impose no restrictions in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes the original integer-scaled installation cost:

\[
61\sum_{l,k} L_{lk}
+601\sum_{l\text{ except first}} E_l
+\sum_{l\text{ except first}} C_l^{\mathrm{support}}.
\]

These coefficients come from the source’s rule of dividing costs by 100 and adding one. Ordinary support costs become 51, while the supplied preferred rack levels have cost 1. The reformulation preserves this objective exactly, including its scaling and minimization direction.

## 3. Reformulation and justification

### One-hot directions and signed displacement

The reformulation introduces six binary direction indicators per leg, together with nonnegative positive and negative displacements for each coordinate. Their sum equals the leg-existence flag, so an active leg chooses exactly one direction and an inactive leg chooses none.

For each coordinate, the new equations are

\[
x_{l+1,k}-x_{l,k}=p_{lk}-m_{lk},
\qquad
L_{lk}=p_{lk}+m_{lk}.
\]

Direction indicators activate only the appropriate displacement. Leg-box boundaries are then expressed linearly from the starting coordinate and these displacements.

**Why this is valid:** In the original formulation, enclosure of both endpoints makes the component length at least the absolute endpoint displacement. For the selected direction, a further constraint bounds that length above by the corresponding signed displacement. These bounds force equality. Unselected components are zero. Consequently, the original constraints already force the exact geometry expressed by the new equations.

This extended mixed-integer formulation makes the direction–geometry relationship explicit and avoids relying on multiple reified implications.

### Bound-derived displacement limits

Each displacement receives an upper bound derived from the endpoint coordinate domains and the original maximum leg length. For example,

\[
p_{lk}\le
\min\!\left(U_l,\max(0,\overline{x}_{l+1,k}-\underline{x}_{l,k})\right)
\,y_{l,+k}.
\]

**Why this is valid:** A positive displacement cannot exceed the largest possible difference between its endpoint coordinates or the original leg-length limit. The negative-direction bound follows symmetrically. Finite global bounds are also assigned to leg-box variables using the coordinate bounds and pipe radii.

These are domain-based bound-tightening techniques; they introduce no additional geometric assumptions.

### Direct obstacle disjunctions

The intermediate three-dimensional obstacle-separation Boolean array is replaced by direct disjunctions over the same coordinate inequalities.

**Why this is valid:** Each original array entry was defined as separation along one axis, and the obstacle constraint required at least one such entry to hold. Substituting those definitions preserves the same six possible separating inequalities and the same nozzle-module exemptions.

This removes an intermediate modeling layer and can reduce unnecessary reification during compilation.

### Boolean linearization of support costs

Products involving leg existence and support-category membership are rewritten as weighted Boolean conjunctions.

**Why this is valid:** The existence flag, preferred-level membership indicators, and `fNodeNotInPref` are all binary. For binary quantities, multiplication equals the indicator of their conjunction. Distributing the original cost expression across its categories therefore gives exactly the same support charge.

The support-membership requirements remain unchanged, including those for inactive intermediate positions.

### Instance-specific removal of inactive constraints

Two general-purpose parts of the source are simplified:

- **Inter-pipe separation:** every node belongs to pipe 1. The original separation constraints are generated only for legs belonging to different pipes, so their index set is empty.
- **Flexibility:** the sole `dGCM_Cpp` value is zero. The original conditional definitions therefore set all orthogonal cubic-length sums to zero and make every flexibility constraint true.

Neither simplification removes an effective restriction.

### Valid direction-count and distance cuts

The reformulation adds redundant inequalities to strengthen the relaxation.

**Axis-count cuts.** The endpoints differ by 20 units in X, 2 in Y, and 135 in Z:

- The final X-directed nozzle leg is at most 15 units long, so at least two X-directed legs are necessary.
- The nonzero Y displacement requires at least one Y-directed leg.
- The first Z-directed nozzle leg is at most 15 units long, so at least two Z-directed legs are necessary.

Every active leg uses exactly one axis. Thus at least **five active legs** are required.

**Distance cuts.** Total component length along an axis must be at least the absolute endpoint displacement on that axis. The same inequalities are added for route prefixes and suffixes relative to intermediate nodes.

**Why these are valid:** Signed endpoint displacements telescope along the route, and the triangle inequality bounds their absolute sum by the sum of component lengths. These cuts remain valid even when the route doubles back; no monotonicity assumption is imposed.

## 4. Solution interface and expected benefit

All original independent variables retain their names and meanings. The mapping script returns only those variables, copies the original array encodings, and restores omitted fixed endpoint coordinates from the unchanged embedded data.

The reformulation targets HiGHS by exposing linear geometry, using bounded direction indicators, eliminating variable multiplication from support costs, and adding valid relaxation-strengthening inequalities. These changes are intended to improve mixed-integer solution performance; no measured runtime improvement is established by the supplied conversation.

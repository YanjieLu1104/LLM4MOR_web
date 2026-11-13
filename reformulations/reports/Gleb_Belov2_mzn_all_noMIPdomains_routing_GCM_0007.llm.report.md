# Orthogonal Pipe Routing with Support and Flexibility Constraints

## 1. Application background

The model describes the routing of a pipe through a three-dimensional industrial installation. Its interpretation follows from the coordinate, nozzle, obstacle, support-zone, and flexibility data.

The supplied instance contains one pipe represented by **10 ordered nodes and nine candidate connecting legs**. The first and last nodes are fixed nozzle connections. Coordinates use a discretization of **200 mm per unit**. Each nonzero leg must follow one coordinate axis, and consecutive nonzero legs must be perpendicular.

The installation contains **111 fixed boxes**, representing equipment modules, existing pipe segments, support zones, a rack, and preferred rack support levels. The route must avoid relevant obstacles while placing its intermediate nodes in eligible support regions. Additional constraints, labelled GCM in the source, impose a geometric flexibility requirement based on cubed leg lengths.

The task is to find a minimum-cost feasible route, balancing pipe length, bends, and support placement.

## 2. Original model

### Variables and route structure

The original source declares **151 independent integer variable entries**:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional node positions; six coordinates are fixed |
| Lower and upper leg-box coordinates | 60 | Bounding boxes around pipe legs, including pipe radius |
| Coordinatewise leg lengths | 30 | Nonnegative lengths along the three axes |
| Leg directions | 10 | Zero for an inactive leg; six signed axis directions otherwise |
| Existence and last-leg indicators | 20 | Binary integers describing the active prefix of the route |
| Objective variable | 1 | Total modeled cost |

The leg arrays include a tenth, nonphysical entry that is fixed to zero. Further arrays are defined expressions for obstacle separation, support membership, support costs, and flexibility sums.

### Constraints

The main constraint groups are:

- **Axis-aligned geometry.** Direction flags select one signed coordinate direction. Length and endpoint constraints make the leg-box coordinates equal to the endpoint minima and maxima, expanded by the pipe radius.
- **Active-prefix sequencing.** Existence and last-leg indicators ensure that active legs form a prefix with exactly one last leg. At least the first three legs exist.
- **Nozzle connections.** The first and last active legs obey prescribed directions and nozzle-length limits. The last active leg reaches the fixed terminal nozzle; subsequent nodes coincide with that endpoint.
- **Orthogonality.** Consecutive legs cannot use the same coordinate axis, excluding both straight continuation and immediate reversal.
- **Obstacle clearance.** Each applicable leg–obstacle pair must be separated along at least one axis, with safety distances included. Specific exceptions allow connection through the associated nozzle modules.
- **Support eligibility.** Intermediate node positions must belong to a support zone. Membership uses the node centre horizontally and the bottom of the pipe vertically. These constraints also apply to intermediate nodes associated with inactive legs.
- **Inter-pipe separation.** The source includes this constraint family, but it has no applicable pairs in this single-pipe instance.
- **Flexibility.** For each coordinate axis, a coefficient derived from nozzle separation and `dGCM_Cpp` multiplies each orthogonal leg length. The result must not exceed the sum of cubed lengths in the orthogonal directions.

### Objective

The model minimizes pipe-length, bend, and support costs. It uses integer division by 100 followed by an increment of one; these operations are part of the objective semantics, not merely display scaling.

For this instance, the resulting charges are:

- **161** per discretized unit of pipe length;
- **1,601** per active leg after the first;
- **51** per charged node outside preferred rack levels, or **1** in a preferred level.

## 3. Reformulation and justification

### Exact finite-domain encoding of cubic lengths

The variable-power expressions were replaced by binary choices over admissible positive integer lengths. For each leg and axis, the formulation links:

\[
L=\sum_v v\,y_v,
\qquad
L^3=\sum_v v^3\,y_v.
\]

The sum of the choices equals the axis-activity indicator. Consequently, either exactly one positive length is selected or the length is zero.

This is **exact**, rather than a piecewise-linear approximation: original lengths are bounded integers, and the choices enumerate every admissible positive value. The flexibility inequalities retain their original coefficients and meaning while becoming linear in the new variables.

### Bound-based preprocessing

The admissible length choices are restricted using:

- the original per-pipe maximum length;
- the maximum endpoint displacement allowed by the coordinate domains;
- the original nozzle-axis restrictions and nozzle-length limits.

These restrictions follow directly from the original geometry: a leg’s length equals its absolute endpoint displacement on its active axis. It therefore cannot exceed the largest displacement permitted by the endpoint bounds. The original direction constraints also require every nonzero leg to satisfy the general minimum length, including nozzle legs.

### Signed-movement formulation

Nonnegative positive and negative movement variables replace the implication-based connection between directions, lengths, and endpoints:

\[
x_{i+1,k}-x_{i,k}=m^+_{i,k}-m^-_{i,k},
\qquad
L_{i,k}=m^+_{i,k}+m^-_{i,k}.
\]

Binary direction indicators permit at most one signed axis per active leg. The leg-box endpoints are linked by linear equalities to the node coordinates and lengths.

This preserves the original geometry. In the original model, endpoint enclosure gives \(L\geq|\Delta x|\), while the selected direction gives the reverse inequality; inactive axes have zero length. Together these constraints already force the same exact displacement and bounding-box relationships.

### Linear support-cost calculation

Products of leg-existence indicators and support-membership indicators were rewritten as Boolean conjunctions multiplied by constant costs.

This is valid because the original indicators are binary: their product is one exactly when both conditions hold. The reformulation retains support-membership definitions and the restriction implicit in the original `fNodeNotInPref` domain.

### Valid route-length strengthening

The reformulation adds signed-displacement balance equations. Summing endpoint differences along the route telescopes to the fixed nozzle displacement, so these equations are redundant but valid.

It also adds a lower bound of **five active legs** for this instance:

1. Both nozzle legs are directed along X and are distinct under the original sequencing constraints.
2. The net Y displacement is 1, but every nonzero leg has length at least 5. Thus Y movement requires at least one positive and one negative Y leg.
3. The nonzero Z displacement requires at least one Z leg.

Since each leg uses only one axis, these requirements imply at least two X legs, two Y legs, and one Z leg. No additional routing assumption is needed.

### Data and solution-interface repair

A transcription error had introduced an extra box-type entry. The final model restores the original **111-entry `nBoxType` sequence**, matching the **333 coordinate entries** and **333 size entries** without changing box identities or geometry.

All original independent variables remain in the model. The mapping script returns only those variables, supplies fixed nozzle coordinates from their original singleton domains when necessary, and preserves the original array domains.

## 4. Expected effect

The reformulation targets a mixed-integer linear backend by replacing variable powers with an exact discrete linear representation and exposing routing geometry through explicit linear relationships. Bound preprocessing reduces the length-choice sets, while valid route-count inequalities strengthen the relaxation.

The finite-domain encoding introduces additional binary variables, so the computational benefit remains instance- and solver-dependent. No measured runtime improvement is established by the reported compilation repair.

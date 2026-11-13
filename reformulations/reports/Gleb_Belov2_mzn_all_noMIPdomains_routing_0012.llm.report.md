# Orthogonal Pipe-Routing Model: Reformulation Report

## 1. Application and interpretation

The model represents the routing of an industrial pipe between two fixed connection points through a three-dimensional plant layout. The supplied instance contains one pipe, ten ordered node positions, and nine possible connecting legs. Coordinates are integer-valued, with each coordinate unit representing 200 mm.

Each active leg follows one coordinate axis. Consecutive active legs must use different axes, representing right-angle bends. The route must avoid equipment modules and existing pipe segments, subject to the modeled pipe radius and safety clearances. Intermediate nodes must also lie in permitted support regions, which include module support zones, a rack, and preferred rack levels.

The first and final active legs have prescribed nozzle directions and length restrictions. Unused trailing legs have zero length, so their nodes coincide with the destination. The objective balances pipe length, bends, and support costs.

Two distinctions are important:

- Although the data include a flag requesting passage through a rack, the corresponding constraint is commented out in the original model. The reformulation does not activate it.
- The flexibility coefficient is zero in this instance, so the flexibility constraints impose no restrictions.

## 2. Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates and 24 potentially variable coordinates.
- **60 integer leg-box coordinates**: lower and upper bounds in three dimensions for ten leg-index slots.
- **30 nonnegative integer component lengths**.
- **10 integer direction variables**, with zero denoting an absent leg and values 1–6 denoting signed coordinate directions.
- **20 binary-valued integer flags** identifying existing and final legs.
- An integer objective variable, `obj`.

Only nine leg-index slots represent actual connections; the remaining slot is fixed to zero. Additional defined arrays express obstacle separation, support membership, support costs, and flexibility quantities. These source-level counts are not counts of the final flattened MIP.

### Constraints

The main constraint groups are:

1. **Leg geometry and direction.** Bounding boxes contain both endpoints, expanded by the modeled radius. Component lengths equal box extents minus twice the radius. Direction implications force movement along exactly one axis and impose minimum active-leg lengths.
2. **Route sequence.** Existing legs form a prefix of the available legs, with exactly one final leg. The first three legs must exist.
3. **Nozzle connections.** The first and final active legs obey prescribed directions and length limits. The final active leg ends at the destination.
4. **Orthogonality.** Adjacent active legs cannot use the same coordinate axis.
5. **Obstacle avoidance.** Each relevant leg must be separated from an obstacle along at least one axis. Specific exemptions allow connection to the source and destination modules.
6. **Support membership.** Intermediate nodes must belong to a support zone. Preferred-level membership determines support cost.
7. **Inter-pipe separation and flexibility.** These are present in the general formulation, but inter-pipe separation has no applicable pairs in this one-pipe instance, and flexibility is disabled by the zero coefficient.

### Objective

The model minimizes the original scaled cost, retaining integer division and the added unit in each coefficient:

- **741 per unit of pipe length**;
- **7,401 per existing leg other than the first**;
- support cost at applicable active nodes: **51 outside preferred levels** and **1 within a preferred level** for the supplied data.

These are the model’s objective values, not a newly rescaled physical-cost measure.

## 3. Reformulation and justification

### Signed-length extended formulation

The reformulation introduces positive and negative direction selectors and corresponding nonnegative lengths for each leg and axis. Linear constraints connect these quantities to the original direction, existence, and component-length variables.

The sum of the six selectors equals the existence flag. Therefore, an existing leg selects exactly one signed axis, while an absent leg selects none. Each selected length satisfies the original minimum-length bound and an appropriate upper bound.

This replaces several direction-dependent implications with explicit linear relationships suited to a MIP solver.

**Why it is equivalent:** In the original formulation, endpoint containment implies that each component length is at least the absolute endpoint displacement. For the selected direction, another constraint makes that length no greater than the signed displacement. Together, these force equality. Unselected components are zero. The new formulation expresses precisely these relationships.

### Exact linear bounding-box equations

For each actual leg and coordinate, the reformulation uses
\[
2L=x_i+x_{i+1}-\ell-2r,\qquad
2U=x_i+x_{i+1}+\ell+2r,
\]
where \(L,U\) are the leg-box bounds, \(\ell\) is the component length, and \(r\) is the original modeled radius.

**Why it is valid:** The original constraints already force \(\ell=|x_{i+1}-x_i|\). Endpoint containment and the box-width equality then leave no slack: the lower bound must be the smaller endpoint minus the radius, and the upper bound must be the larger endpoint plus the radius. The equations therefore preserve the original leg boxes rather than imposing a new geometric approximation.

### Bound-based preprocessing

Directional-length upper bounds are tightened using endpoint domains. For example, positive movement cannot exceed the upper bound of the next coordinate minus the lower bound of the current coordinate, or the original leg-length upper bound.

Obstacle constraints are also omitted when endpoint domains prove separation along some axis for every possible position of the leg.

**Why it is valid:** These deductions use declared coordinate bounds and the exact endpoint-based leg boxes. An obstacle test is removed only when its separation disjunction is already guaranteed. The original nozzle-module exemptions remain unchanged.

### Support-cost linearization

The product between an existence flag and a variable support cost is replaced by a default active-node cost plus preferred-level adjustments. Each adjustment uses the indicator of the conjunction “the leg exists and the node belongs to this preferred level.”

**Why it is equivalent:** The original equation
\[
f_{\text{not preferred}}=1-\sum_z b_z
\]
allows the support-cost expression to be expanded algebraically. Multiplying each membership indicator by the binary existence flag is exactly equivalent to their conjunction. The original membership definitions and the domain restriction on the nonpreferred flag are retained, so no additional assumption about zone overlap is needed.

### Valid route-strengthening inequalities

The reformulation adds:

- **Directional-count cuts:** a positive endpoint displacement requires at least one positive leg on that axis, and similarly for negative displacement.
- **Small-displacement cuts:** if a nonzero endpoint displacement is smaller than the minimum active-leg length, both directions must occur on that axis.
- **Length–displacement inequalities:** total, prefix, and suffix component lengths must dominate the corresponding absolute coordinate displacement.

**Why they are valid:** Signed leg displacements telescope to the endpoint displacement. A nonzero displacement smaller than the minimum leg length cannot be achieved using only legs in its direction, so opposing movement is necessary. The length inequalities follow directly from the triangle inequality applied to each route section.

### Solution interface

All original independent decision variables retain their names and meanings. The supplied mapping script copies those variables, restores fixed endpoint coordinates from the unchanged embedded data when necessary, and retrieves the unchanged objective from either `obj` or the solution objective field. Auxiliary reformulation variables are excluded from the mapped solution.

The changes aim to provide a more explicit linear formulation and stronger relaxation for HiGHS. No measured runtime improvement is established by the information available here.

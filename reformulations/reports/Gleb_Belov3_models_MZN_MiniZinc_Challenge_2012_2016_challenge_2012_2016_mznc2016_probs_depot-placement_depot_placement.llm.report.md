## Problem background

The model represents delivery planning for two warehouses, each with its own truck and a disjoint group of customers. A truck may deliver to customers assigned to the other warehouse, but it must first visit a selected depot to collect their goods. The depot is chosen from the warehouse and customer locations.

Each truck follows a fixed-length sequence of stops beginning at its own warehouse and returns there after the final listed stop. Repeating the starting warehouse in the second position permits a tour with fewer distinct stops. There are no timing or synchronization variables: the model concerns route distances and the order of depot visits, not coordinated arrival times.

The objective is to minimize the longer of the two truck routes, balancing their travel burden rather than minimizing total distance.

## Original formulation

Let \(p=\texttt{PSize}\). There are \(2(p+1)\) locations, including the warehouses, and each tour has \(p+2\) listed positions. The distance matrix is externally supplied with the declared index domain `1..14 × 1..14`; the model uses its active location range.

### Variables

The original formulation contains \(4p+12\) integer decision variables:

- **Depot:** one location-valued variable.
- **Tour locations:** two arrays of \(p+2\) location-valued variables.
- **Leg distances:** two arrays of \(p+2\) nonnegative integer variables, including the return legs.
- **Route totals:** `ADist` and `BDist`.
- **Objective:** a variable constrained to equal `max(ADist, BDist)`.

Distance bounds are derived from the supplied matrix. Although the matrix entries are declared as unrestricted integers, every selected leg must have a nonnegative distance because of its variable domain.

### Constraints

The model enforces:

- Every location occurs in at least one tour.
- Positions after the initial warehouse are pairwise distinct within each tour.
- Each truck starts at its own warehouse and never visits the other warehouse.
- Specified later positions cannot repeat the starting warehouse.
- Each leg distance equals the matrix entry for its consecutive locations, with a final leg returning to the first location.
- Each route total equals the sum of its leg distances.
- Visiting a customer belonging to the other warehouse requires an earlier depot visit, unless that customer is itself the depot.

The source has asymmetric final-position restrictions: it excludes warehouse A from the final position of tour A, while its second symmetry-breaking constraint also refers to tour A. The reformulation preserves this literal behavior rather than correcting it based on the comments.

## Reformulation and justification

The reformulation targets the HiGHS mixed-integer linear backend. It retains all original variables and external data declarations while replacing variable-indexed distances and logical conditions with explicit assignment and flow constraints.

### One-hot location assignments

Binary variables indicate whether a particular location occupies a particular tour position. Exactly one location is selected at each position, and the original location variable equals the weighted sum of these indicators. A similar representation is used for the depot.

This is exact: choosing one indicator uniquely determines the corresponding original location value, and every original location value has a corresponding one-hot assignment.

Coverage becomes a lower bound of one on each location’s total number of occurrences. Within-tour distinctness becomes an upper bound of one on each location’s occurrences after the initial position. These are precisely the counting interpretations of the original coverage and `alldifferent` constraints.

### Continuous arc-flow representation of distances

For every tour leg, continuous nonnegative variables represent transitions between possible origin and destination locations. Their row sums equal the origin-position indicators, and their column sums equal the next-position indicators.

These arc variables do not need binary domains. Once the endpoint assignments are integral, exactly one origin and one destination are selected. Nonnegativity forces every other row and column to zero, leaving only the selected origin–destination entry, which must equal one. Consequently, the distance-weighted sum of these variables equals exactly the matrix lookup in the original model.

The same construction handles the closing leg. It makes the distance relationships explicitly linear without introducing additional binary arc variables.

### Valid arc elimination

Two classes of transitions are fixed to zero:

- **Negative-distance arcs.** The original leg variables have nonnegative domains and must equal their selected matrix entries. Selecting a negative entry is therefore impossible.
- **Self-loops at locations other than the truck’s own warehouse.** Consecutive occurrences of such a location would violate distinctness among positions after the first. A self-loop involving the initial or closing position can only be at the starting warehouse, because that position is fixed.

Starting-warehouse self-loops are not eliminated wholesale, preserving the repetition permitted by the original constraints. These reductions require neither symmetric distances nor the triangle inequality.

### Linear depot-prefix constraints

A binary indicator records whether each tour position equals the selected depot. Linear linking constraints make this indicator exact.

At a position occupied by a customer from the other warehouse, the sum of depot indicators through that position must be at least one. This is equivalent to the original rule:

- If the current location is the depot, the prefix condition is satisfied at that position, matching the original exception.
- Otherwise, the current depot indicator is zero, so a depot occurrence must be at an earlier position.

No additional timing or inter-truck synchronization condition is introduced.

### Interface and solution mapping

The original tour, depot, leg-distance, total-distance, and objective variables remain in the model, with their original meanings and domains. The mapping script copies these original variables from the reformulated solution and discards auxiliary variables.

The intended computational benefit is a more explicit linear formulation for HiGHS, with direct assignment constraints and continuous arc variables. This increases formulation size, so a runtime improvement is not guaranteed; no empirical performance claim is made.

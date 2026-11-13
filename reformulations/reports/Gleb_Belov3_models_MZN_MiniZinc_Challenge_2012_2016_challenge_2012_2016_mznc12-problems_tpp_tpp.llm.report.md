# Asymmetric Travelling Purchaser Problem

## Background

The model represents a purchaser who must buy a collection of products while travelling among cities. Each product has a city-dependent price, so the purchaser must balance cheaper purchases against the cost of visiting additional locations.

Travel costs are directed: travelling from one city to another may cost a different amount from travelling back. The source describes a grid network with travel between adjacent locations, but the actual permitted connections are determined by the supplied distance matrix. The last city serves as the mandatory depot and sells no products.

A solution selects purchase locations and a single closed tour through the depot and all cities used for purchases. Other cities may also be visited.

## Original Model

Let \(n=\texttt{numcities}\) and \(m=\texttt{numproducts}\). The model declares \(2n+2m\) independent integer variables:

- **`succ`**: \(n\) successor variables specifying the next city. A self-successor means that the city is excluded from the tour.
- **`travelCost`**: \(n\) variables in `0..maxdist`.
- **`purchaseLoc`**: \(m\) variables choosing a selling city from `1..numcities-1`.
- **`purchaseCost`**: \(m\) variables in `0..maxprice`.

A further variable, **`totalCost`**, is defined as the sum of travel and purchase costs.

The main constraints are:

1. **Travel-cost lookup:** each city’s travel cost equals the distance to its selected successor.
2. **Purchase-cost lookup:** each product’s purchase cost equals its price at the selected city.
3. **Purchase-to-visit implication:** a purchase location cannot have itself as successor.
4. **Subcircuit constraint:** all non-self successor arcs form a single cycle.
5. **Mandatory depot visit:** the last city cannot have itself as successor.

The objective is to **minimize total travel and purchase cost**.

An important detail is that an excluded city still contributes its diagonal distance through the travel-cost lookup. Thus, diagonal distances cannot simply be discarded or assumed to be zero. An invalid diagonal distance can also prevent a city from being excluded.

## Reformulation for HiGHS

The reformulation replaces variable-index lookups and the global subcircuit constraint with an explicit mixed-integer linear formulation. It retains the original parameters and decision variables, connecting them to new auxiliary variables through linear equalities.

### Domain-based preprocessing

A travel assignment is excluded whenever its distance lies outside `0..maxdist`. Similarly, a purchase assignment is excluded whenever its price lies outside `0..maxprice`.

These exclusions follow directly from the original lookup equalities and cost-variable domains: selecting such an entry would force the corresponding cost outside its declared domain. The travel preprocessing applies to diagonal entries as well, preserving the original treatment of excluded cities. No symmetry, grid geometry, or zero-diagonal assumption is introduced.

### Binary assignment formulation

Binary variables indicate the selected successor arc for each city and the selected seller for each product.

- Exactly one outgoing and one incoming successor assignment are required per city.
- Exactly one selling city is selected per product.
- Linear weighted sums recover the original successor, purchase-location, and cost variables.
- A purchase assignment is bounded by one minus the city’s self-loop indicator.

The last inequality is equivalent to the original purchase-to-visit condition: buying at a city forces its self-loop indicator to zero. The weighted-sum cost equations preserve all original costs, including diagonal travel costs.

### Single-commodity flow for connectivity

The degree constraints alone would permit several disconnected cycles. To recover the original subcircuit semantics, continuous auxiliary flow is allowed only along selected non-self arcs. Each visited non-depot city consumes one unit; excluded cities consume none. Flow entering the depot is fixed to zero.

A disconnected cycle cannot satisfy these balances: summing the balances over that cycle cancels all internal flow, yet requires positive total consumption. Therefore, every visited city must belong to the cycle containing the depot.

Conversely, any original feasible tour admits such a flow. The depot sends one unit for each visited non-depot city, and the remaining flow decreases by one at every stop. Consequently, the capacity \(n-1\) is sufficient. The added lower bound of one unit on each selected arc not entering the depot is also valid under this construction.

### Two-city subtour cuts

For every pair of distinct non-depot cities with both directed arcs available, the model adds
\[
x_{ij}+x_{ji}\leq 1.
\]

Selecting both arcs would create an isolated two-city cycle because the degree equations already give each endpoint its unique incoming and outgoing arc. Such a cycle cannot coexist with the required depot-containing tour. These inequalities are therefore valid and strengthen the linear relaxation. Pairs containing the depot are deliberately excluded, since a two-city depot tour may be feasible.

## Preservation and Expected Benefit

The objective direction, cost accounting, external data interface, and original decision-variable meanings are unchanged. The mapping script returns the four original independent variable arrays and excludes reformulation-specific auxiliaries.

The intended benefit is a formulation directly suited to HiGHS: linear assignment equations, explicit connectivity flow, domain-based exclusions, and valid subtour cuts replace higher-level combinatorial constructs. Actual performance remains instance-dependent; no runtime improvement was measured in the supplied conversation.

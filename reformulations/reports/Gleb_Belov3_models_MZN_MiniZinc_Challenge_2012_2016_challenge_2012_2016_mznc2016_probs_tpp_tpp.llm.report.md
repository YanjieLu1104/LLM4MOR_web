# Asymmetric Travelling Purchaser Problem: Reformulation Report

## Problem background

The model represents a purchaser who must buy one unit of each required product while travelling among cities. Each selling city offers every product, potentially at different prices. The last city is a depot with no products for sale; the purchaser must include it in a closed tour.

The decision combines two competing costs: visiting more cities may provide cheaper products but increases travel expenditure. Travel costs are directed, so travelling from one city to another need not cost the same as travelling back. The model description identifies a grid network, but the mathematical formulation uses the supplied distance matrix directly; the reformulation does not assume any additional grid structure.

Cities outside the tour are represented by self-successors. Importantly, the original model charges the corresponding diagonal distance even for an unvisited city. The reformulation preserves this behavior rather than assuming diagonal costs are zero.

## Original model structure

Let \(n\) denote `numcities` and \(p\) denote `numproducts`. The original model declares \(2n+2p+1\) integer decision variables:

| Variable | Count | Meaning |
|---|---:|---|
| `succ` | \(n\) | Successor of each city; a self-successor means the city is not visited |
| `travelCost` | \(n\) | Distance-matrix cost associated with each successor choice |
| `purchaseLoc` | \(p\) | Selling city selected for each product |
| `purchaseCost` | \(p\) | Price paid for each product |
| `objective` | 1 | Total travel and purchase cost |

The constraints comprise:

- \(n\) element equalities linking successor choices to travel costs;
- \(p\) element equalities linking purchase locations to product prices;
- \(p\) constraints requiring each selected purchase city to be visited;
- one global `subcircuit` constraint, allowing one cycle of visited cities and self-loops elsewhere;
- one constraint requiring the depot to be visited; and
- one equality defining the objective.

The objective is to **minimize total travel cost plus total purchase cost**. The declared cost domains also restrict feasible choices: selected distances must lie in `0..maxdist`, and selected prices must lie in `0..maxprice`.

## Reformulation and justification

### Sparse preprocessing of admissible choices

The reformulation creates binary arc variables only for distances within `0..maxdist`. This is exact because the original equality
`travelCost[city] = dist[city,succ[city]]`, together with the domain of `travelCost`, already excludes every other distance.

Likewise, binary purchase variables are created only for city–product pairs whose prices lie in `0..maxprice`. Any excluded pair would violate the original purchase-cost equality and domain.

The depot self-loop is omitted because the original model explicitly requires `succ[numcities] != numcities`. Other self-loops remain available whenever their costs satisfy the original domain. No cost-dominance assumptions or symmetry reductions are used.

### Linear arc-selection and purchase-selection formulation

Exactly one outgoing and one incoming arc is selected for each city. Weighted sums of the outgoing arc variables reconstruct `succ` and `travelCost`. A binary visit indicator records whether the selected outgoing arc is non-self.

For each product, exactly one admissible purchase pair is selected. Weighted sums reconstruct `purchaseLoc` and `purchaseCost`, and each purchase binary is bounded above by the visit indicator of its city.

These equations replace variable-index lookups with linear expressions. Their validity follows from the exactly-one constraints: each weighted sum equals the index or cost of the unique selected choice. The purchase-to-visit inequality is precisely the original requirement that a purchase location have a non-self successor.

### Single-commodity flow for tour connectivity

Degree constraints alone would permit several disconnected cycles. To replace `subcircuit`, the reformulation adds continuous flow:

- the depot supplies one unit for every visited non-depot city;
- each visited non-depot city consumes one unit;
- unvisited cities consume nothing; and
- flow can use only selected non-self arcs, with zero flow on arcs returning to the depot.

A disconnected cycle of visited cities is impossible: summing its flow balances would require positive net inflow, but no selected arc enters that cycle. Combined with the degree constraints and mandatory depot visit, this leaves exactly one nontrivial cycle through the depot, with self-loops elsewhere.

Conversely, every original feasible tour admits such a flow. The depot sends the number of visited non-depot cities along its first arc, and the flow decreases by one after each visited city. Thus, the connectivity reformulation does not exclude any original feasible tour.

### Strengthened flow bounds

The formulation also uses valid, problem-specific flow bounds:

- A selected non-self arc entering a non-depot city carries at least one unit, because that city consumes one unit and has only one selected incoming arc.
- An arc leaving the depot carries at most \(n-1\) units, the maximum number of non-depot cities.
- An arc leaving a non-depot city carries at most \(n-2\) units, because at least one unit has already been consumed.

These bounds strengthen the linear relaxation without changing the feasible integer tours.

## Preservation and expected benefit

All original decision variables, external parameter declarations, objective values, and minimization direction are retained. The mapping script returns only the original decision-variable fields, preserving their values and encoded array indices.

The reformulation targets HiGHS by replacing global and variable-index constructs with explicit sparse linear constraints, binary selections, and continuous connectivity flow. Removing impossible choices before solving reduces the selection space, while the flow bounds improve relaxation strength. The resulting model is intended to solve faster, but no runtime improvement has been established without instance data and computational testing.

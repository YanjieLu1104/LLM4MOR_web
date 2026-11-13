## Problem background

The model describes a **depot-location problem for restaurants along a line**, such as a highway. Each restaurant has a name and an integer kilometre position. A prescribed number of depots must be placed at distinct restaurant positions.

Every restaurant is served by its nearest depot. The goal is to minimize the sum of restaurant-to-depot distances, with each restaurant contributing equally. The model does not include depot capacities, transportation routes, or fixed opening costs.

## Original model

For `nr` restaurants and `number_of_depots` depots, the model declares:

- **One integer location variable `p[d]` per depot**, with domain `0..maxdist`, where `maxdist` is the largest restaurant coordinate.
- **An integer objective variable `obj`**, defined as the total distance to the nearest depot.

The location constraints require:
1. Each depot coordinate to belong to `ks`, the set of restaurant coordinates.
2. Depot coordinates to be strictly increasing. This ensures distinct locations and removes permutations of otherwise interchangeable depots.

The objective is
\[
\min \sum_{r\in Restaurant}\min_{d\in Depot}|p_d-k_r|.
\]

Its declared bounds are calculated from bounds on the original distance expressions. Restaurant names and the set `first`, containing one representative restaurant per distinct coordinate, support the textual output.

Although concise, this formulation contains nested absolute-value and minimum expressions involving decision variables. A mixed-integer linear backend such as HiGHS must translate these expressions into additional variables and constraints.

## Reformulation and its justification

### 1. Preprocess eligible sites and repeated coordinates

The reformulation sorts the distinct restaurant coordinates and retains as eligible depot sites only those in `0..maxdist`.

This filtering follows directly from the original restrictions: a depot must both belong to `ks` and satisfy its declared nonnegative domain. Negative restaurant coordinates, if present, therefore cannot host depots, but their restaurants remain in the distance objective.

Restaurants sharing a coordinate are aggregated into one demand point with a weight equal to their multiplicity. This is exact because their nearest-depot distances are identical for every feasible depot configuration; multiplying that common distance by the number of restaurants reproduces their original contribution.

### 2. Represent depot selection with binary variables

Binary slot variables associate each original depot with exactly one eligible site. Binary opening variables record which sites are selected, and linear equalities link the selections to the retained `p[d]` variables.

The original membership and strict-ordering constraints remain in place. Consequently, this representation preserves the original depot identities and sorted coordinates rather than changing the location problem. Every original feasible location array has a corresponding binary selection, and every feasible reformulated selection yields an original feasible location array.

### 3. Replace nearest-distance expressions with exact threshold coverage

For each distinct demand coordinate, the reformulation sorts its distances to all eligible sites:
\[
0=t_0\le t_1\le\cdots\le t_m.
\]

A binary variable \(u_j\) indicates that **no selected site lies at distance strictly less than \(t_j\)**. The nearest selected-site distance is then exactly
\[
\sum_{j=1}^{m}(t_j-t_{j-1})u_j.
\]

To see why, let the nearest distance be \(D\). Because depots occupy eligible sites, \(D\) occurs in the threshold list. The indicators are one for thresholds at most \(D\), and zero for larger thresholds. The sum therefore telescopes to \(D\). Repeated thresholds cause no problem because their increments are zero.

Both directions of the coverage condition are imposed by linear constraints. Thus, the expression equals the nearest distance for every feasible solution, not merely at an optimum. Multiplicity weights then recover the original total objective.

### 4. Exploit the line geometry with prefix sums

After sites are sorted by coordinate, the sites within a strict distance threshold of a demand point form a contiguous interval. Prefix sums of the opening variables therefore express the number of selected sites in that interval as the difference of two prefix values.

This is an exact consequence of one-dimensional absolute distance. It replaces potentially long coverage sums with two prefix references. The interval’s number of candidate sites also supplies a valid bound in the indicator constraints.

## Preserved semantics and expected benefit

The reformulation preserves the external data interface, original depot variables, objective bounds, minimization direction, and output. Its mapping script returns `p` directly; the original model recomputes its defined objective from those locations.

The main change is an **exact mixed-integer linear reformulation**, supported by duplicate-coordinate aggregation and interval preprocessing—not a relaxation or an assumption about optimal depot placement. It exposes site selection and distance coverage explicitly for HiGHS. This may reduce the cost of linearizing nested distance expressions, although the additional binary variables mean that performance remains instance-dependent; no measured speedup was established here.

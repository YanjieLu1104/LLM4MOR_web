# Grid Path Puzzle: Model and Reformulation

## Problem background

The model describes a grid-routing puzzle. A rectangular board contains two marked cells for each label \(1,\ldots,N\). Cells with the same label should form a route joining their marked endpoints using horizontal or vertical adjacency. Each cell can carry at most one label, so routes cannot share cells. Unused cells remain empty.

This resembles exclusive-use routing on a discrete layout. However, the supplied formulation expresses **local degree conditions**, rather than explicit global connectivity. With distinct, nonconflicting endpoints, these conditions produce a path joining each pair and may also permit disconnected cycles of that label. The reformulation preserves this behavior.

## Original formulation

### Data and variables

The external data specify:

- Grid dimensions \(X\) and \(Y\).
- The number of labels \(N\).
- Start and end coordinates for each label.

The sole independent decision array is
\[
\texttt{board}[0..X+1,\;0..Y+1]\in\{0,\ldots,N\}.
\]
For nonnegative grid dimensions, this contains \((X+2)(Y+2)\) integer variables. Zero means empty; a positive value identifies a route. The extra outer layer is a fixed-zero boundary.

### Constraints

The model imposes four types of restrictions:

1. **Empty boundary:** every cell outside the interior grid is zero.
2. **Fixed endpoints:** both supplied endpoints for label \(n\) contain \(n\).
3. **Endpoint degree:** each endpoint has exactly one orthogonally adjacent cell with the same label.
4. **Interior route degree:** every occupied cell that is not an endpoint has exactly two same-label neighbors.

Empty interior cells have no degree requirement. The original model implements the degree conditions using `count` expressions comparing neighboring board values with the current cell’s value.

### Objective

The objective is
\[
\min \sum_{x,y}\texttt{board}[x,y].
\]

Thus, this is **weighted occupancy minimization**, not simply total route-length minimization: a cell assigned label \(n\) costs \(n\). The fixed-zero boundary contributes nothing.

## Reformulation

### Binary label indicators and linear channeling

The revised model retains `board` and introduces \(NXY\) binary indicators for nonnegative dimensions:
\[
u_{x,y,n}=1
\quad\Longleftrightarrow\quad
\text{interior cell }(x,y)\text{ carries label }n.
\]

The equivalence is enforced by
\[
\sum_{n=1}^{N}u_{x,y,n}\le 1,
\qquad
\texttt{board}[x,y]=\sum_{n=1}^{N}n\,u_{x,y,n}.
\]

These equations are exact: no selected indicator gives board value zero; selecting one gives its label. Conversely, every original board value has a unique indicator representation. The external parameters, endpoint assignments, boundary constraints, and objective remain unchanged.

### Linear replacement of conditional counts

For a cell \(v\) and label \(n\), let:

- \(S_{v,n}\) be the sum of label-\(n\) indicators over its interior neighbors;
- \(d_v\) be its number of interior neighbors;
- \(r_v=1\) at an endpoint and \(r_v=2\) elsewhere.

The original conditional degree requirement is replaced by
\[
S_{v,n}\ge r_vu_{v,n},
\qquad
S_{v,n}\le r_vu_{v,n}+d_v(1-u_{v,n}).
\]

If \(u_{v,n}=1\), both inequalities force \(S_{v,n}=r_v\). If \(u_{v,n}=0\), they reduce to the natural bounds \(0\le S_{v,n}\le d_v\), imposing no additional restriction.

This is a **binary extended formulation with locally bounded big-\(M\) inequalities**. The bound \(d_v\le4\) follows directly from grid adjacency. Boundary neighbors can be omitted because they are fixed to zero and therefore cannot match a positive label. The resulting constraints are directly linear and avoid variable-valued equality counts, which can be expensive to translate for HiGHS.

### Manhattan-distance lower bounds

For each label whose endpoints are distinct, the reformulation adds
\[
\sum_v u_{v,n}
\ge
|x_s-x_t|+|y_s-y_t|+1.
\]

To justify this, consider the graph induced by cells carrying that label in any feasible original solution. Its two distinct endpoints have degree one, and all other vertices have degree two. A finite graph with this degree pattern consists of a path joining those endpoints, possibly accompanied by cycles. The path needs at least the Manhattan distance in edges, and therefore at least that distance plus one in cells. Extra cycles only increase occupancy.

### Checkerboard-balance equalities

Color the grid like a checkerboard, and assign each cell a sign
\[
\sigma_v=
\begin{cases}
+1,&\text{on one color},\\
-1,&\text{on the other}.
\end{cases}
\]

For distinct endpoints, the model adds
\[
2\sum_v \sigma_vu_{v,n}=\sigma_s+\sigma_t.
\]

Every grid edge joins opposite colors. Consequently, a cycle contains equal numbers of the two colors. Along the endpoint path, opposite-colored endpoints give equal color counts; same-colored endpoints give one extra cell of their shared color. The equality therefore follows from the original degree constraints and remains valid even when disconnected cycles are present.

Both strengthening families are restricted to distinct endpoints, avoiding an assumption that the input necessarily provides two different coordinates.

## Scope and expected benefit

The changes use **indicator channeling, linear conditional-degree reformulation, data-derived adjacency bounds, and problem-specific valid inequalities**. They are intended to improve MIP propagation and relaxation strength, although no measured speedup is claimed.

No connectivity constraints, cycle-elimination rules, or objective changes were introduced. The original `board` array remains available, and the mapping script returns it unchanged while excluding auxiliary indicators. Thus, the reformulation preserves the original solution representation and feasible board assignments.

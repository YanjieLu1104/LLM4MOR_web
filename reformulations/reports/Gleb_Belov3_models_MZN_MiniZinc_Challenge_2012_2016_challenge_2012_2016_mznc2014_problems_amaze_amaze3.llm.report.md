# Grid Pair-Routing Model: Structure and Reformulation

## Problem background

The model represents a grid-based pair-routing puzzle, similar to Numberlink. Each numbered pair specifies two endpoint cells. Cells may be left empty or assigned a pair’s label, with orthogonally adjacent cells of the same label forming routes.

This interpretation follows from the constraints rather than an explicit application description. In particular, the model does **not** require every cell to be occupied, and it does not explicitly impose global connectivity. Disconnected same-label cycles are permitted. The reformulation preserves these features rather than imposing stronger puzzle rules.

## Original model

### Inputs and variables

The external inputs are the grid dimensions `X` and `Y`, the number of pairs `N`, and four arrays specifying the two endpoint coordinates for each pair.

The sole independent decision array is `board`, containing one integer variable per cell—\(X Y\) variables for nonnegative grid dimensions. Each variable takes a value in \(0,\ldots,N\):

- **0:** the cell is unused.
- **\(i>0\):** the cell belongs to pair \(i\).

### Constraints

The model imposes four families of constraints:

1. **Endpoint labels.** Both endpoints of pair \(i\) must have label \(i\).
2. **Endpoint degrees.** Each endpoint has exactly one orthogonally adjacent cell with its own label.
3. **Non-endpoint degrees.** Each occupied non-endpoint has exactly two orthogonally adjacent cells with its own label. Empty cells have no degree requirement.
4. **Crossing constraints.** For each pair, every column strictly between its endpoint columns must contain that pair’s label; the analogous condition holds for intervening rows.

The source describes the crossing constraints as redundant. They were retained explicitly, so the reformulation does not depend on proving redundancy, including for unusual endpoint configurations.

### Objective and search

This is a **satisfaction problem**, not an optimization problem: any feasible board is acceptable. The original model supplies an integer-search annotation using input order and domain splitting.

## Reformulation

### Binary label indicators and linear channeling

For each cell \((x,y)\) and positive label \(i\), the reformulation introduces a binary indicator \(b_{xyi}\). It retains `board` and adds

\[
\sum_i b_{xyi}\leq 1,
\qquad
\operatorname{board}_{xy}=\sum_i i\,b_{xyi}.
\]

This adds \(|Xs|\,|Ys|\,|Pairs|\) binary variables.

**Why this is valid:** At most one indicator can be active. If none is active, the channeling equation gives `board = 0`; if indicator \(i\) is active, it gives `board = i`. Conversely, every original board label has exactly this representation. Thus the reformulation preserves the meaning of every cell and keeps the original variable available for external assignments and solution checking.

### Linear endpoint constraints

Endpoint labels are enforced by fixing their corresponding indicators to one. Their same-label neighbor counts become sums of neighboring indicators equal to one.

**Why this is valid:** Channeling makes \(b_{uvi}=1\) exactly when `board[u,v] = i`, so these sums count precisely the neighbors counted by the original constraints. Conflicting endpoint labels remain infeasible because a cell cannot activate two indicators. Repeated endpoints retain their original behavior.

### Degree-aware linearization of conditional counts

For a non-endpoint cell, let \(d_{xy}\) be its number of in-bounds orthogonal neighbors, and let

\[
s_{xyi}=\sum_{(u,v)\text{ adjacent to }(x,y)} b_{uvi}.
\]

The original conditional degree constraint is replaced, for every positive label, by

\[
s_{xyi}\geq 2b_{xyi},
\qquad
s_{xyi}\leq d_{xy}+(2-d_{xy})b_{xyi}.
\]

**Why this is valid:**

- If \(b_{xyi}=1\), the inequalities force \(s_{xyi}=2\), exactly as required for an occupied non-endpoint.
- If \(b_{xyi}=0\), they reduce to \(0\leq s_{xyi}\leq d_{xy}\), which already follows from summing \(d_{xy}\) binary indicators.

The neighbor count \(d_{xy}\) is derived from the grid geometry at model instantiation. This is a **degree-aware conditional linearization**: it uses exact local bounds instead of a generic large constant, including at boundaries and on narrow grids.

### Linear crossing constraints

Each original expression counting cells with `board = i` is replaced by a sum of label indicators, with a lower bound of one.

**Why this is valid:** The indicator–board equivalence makes these sums identical to the original counts. The same intervening rows and columns are constrained; no new connectivity assumption is introduced.

## Solver and solution interface

The reformulation replaces variable-valued counting and logical implications with explicit linear constraints suited to the **HiGHS mixed-integer backend**. The original search annotation is removed, while `solve satisfy` remains unchanged.

All external parameter names, domains, and endpoint meanings are preserved. No instance-specific values are hard-coded, and no connectivity cuts or cycle-elimination constraints are added.

The mapping script returns the original `board` array unchanged, preserving its index-set encoding and excluding auxiliary indicators. It reports a missing board explicitly rather than constructing guessed values.

These changes are intended to improve compilation and solving behavior for HiGHS; no measured speedup is established by the supplied conversation.

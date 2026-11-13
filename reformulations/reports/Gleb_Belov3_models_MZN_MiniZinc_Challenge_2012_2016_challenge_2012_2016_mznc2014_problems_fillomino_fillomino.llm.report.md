# Fillomino: Model and Reformulation Report

## Problem background

The model represents **Fillomino**, a grid-based logic puzzle. Each cell belongs to an orthogonally connected region and contains a number equal to that region’s size. Some numbers are provided as clues; a zero in the input denotes an unspecified cell. Regions of equal size must not share an edge.

The computational task is to complete the numbers and partition the grid into valid regions. This is a feasibility problem, not an optimization problem.

The supplied formulation also imposes particular region-root and time-label restrictions. These are part of the model’s semantics and are preserved by the reformulation.

## Original formulation

Let \(R\) and \(C\) denote the number of rows and columns, and let \(N=RC\). The original model declares \(4N\) integer decision variables:

| Variable | Number | Meaning |
|---|---:|---|
| `size[a]` | \(N\) | Number of cells assigned to region identifier \(a\); zero means unused |
| `area[r,c]` | \(N\) | Region identifier assigned to a cell |
| `when[r,c]` | \(N\) | Connectivity label, between 1 and \(\min(9,R+C)\) |
| `what[r,c]` | \(N\) | Cell value, between 1 and 9 |

Each possible region identifier corresponds to a grid cell through its row-major position.

### Constraints

- **Clue preservation:** Every nonzero input clue fixes the corresponding `what` value.
- **Selected root fixing:** For a clue of value \(s\), `same_in_range` counts later clues of the same value at Manhattan distance below \(s\). If this count is zero, the original model fixes the cell as its region’s root.
- **Value–size consistency:** Each cell’s value equals the size of its assigned region.
- **Region cardinality:** Each region’s size equals the number of cells assigned to it.
- **Rooted connectivity:** A cell either has label 1 and uses its own position as its region identifier, or has a same-region neighbor whose label is exactly one smaller. Repeatedly following these neighbors reaches a root, proving connectivity.
- **Label bound:** A cell’s connectivity label cannot exceed its region’s size.
- **Adjacent-region restriction:** Two edge-adjacent cells have different region identifiers if and only if they have different region sizes.

Strictly speaking, `when` is a rooted path-level certificate, not necessarily a shortest-path distance: the constraints require a descending path but do not require the smallest possible label.

The solve item is `satisfy`, so any feasible assignment is acceptable.

## Reformulation and justification

### 1. Preprocess feasible cell-to-root assignments

The reformulation constructs a candidate-root set for each cell. It removes a candidate only when an original constraint proves that assignment impossible.

**Distance restriction.** Following descending `when` labels from a cell to its root produces a path of length `when - 1`. Manhattan distance cannot exceed this path length. Since the original model bounds `when` by both \(\min(9,R+C)\) and the region size, a cell and its root must have Manhattan distance strictly below both bounds.

**Clue-based distance restriction.** If either endpoint has clue \(s\), value–size consistency forces their shared region to have size \(s\). Their Manhattan distance must therefore be less than \(s\).

**Clue compatibility.** If both endpoints carry nonzero clues, those clues must agree: cells assigned to one region must all equal its size.

**Preservation of forced roots.** A cell already fixed as a root by the original `same_in_range` rule retains only its own identifier as a candidate. This does not introduce a new root-selection assumption.

These tests reduce the assignment representation before solving, particularly when clues eliminate many potential roots.

### 2. Replace dense counting and variable-indexed size access

A Boolean variable is introduced for each surviving cell–root pair. Exactly one candidate is selected for each cell, and a weighted sum of selected identifiers determines its original `area` variable.

For each region, `size` becomes the sum of its selected assignment Booleans. A selected pair also implies that the cell’s `what` value equals that region’s size.

This is equivalent to the original formulation:

- Every original feasible assignment survives preprocessing and selects exactly its assigned root.
- Conversely, exactly-one selection gives each cell one region, the sums count its cells, and the implications enforce value–size consistency.

The number of new Boolean variables is the sum of the candidate-set sizes; it depends on the supplied data. This sparse formulation is intended to reduce the dense equality tests and variable-indexed lookups presented to HiGHS, although no runtime improvement has been measured here.

### 3. Add the valid bound `size <= 9`

An unused region has size zero by the cardinality constraint. A used region contains a cell whose `what` value equals its size, and every `what` lies between 1 and 9. Therefore every region has size at most 9.

Adding this bound explicitly strengthens the formulation without excluding any original solution.

### 4. Add a root-activation inequality

For the identifier associated with cell \((r,c)\), the reformulation adds

\[
\text{size}[(r-1)C+c]
\leq 9\,\mathbf{1}\{\text{when}[r,c]=1\}.
\]

If this region is nonempty, following descending labels from any member reaches a label-1 cell with that same identifier. The original root rule uniquely identifies that cell as \((r,c)\). Hence a positive size requires `when[r,c] = 1`; the preceding size bound supplies the coefficient 9.

This redundant inequality exposes a consequence of connectivity and cardinality directly to the solver.

### 5. Simplify expressions using existing equalities

The reformulation replaces `when <= size[area]` with `when <= what`. It also expresses neighboring size comparisons using neighboring `what` values. Both substitutions are exact because the assignment constraints preserve `what = size[area]`.

The original connectivity constraints and time-label domain remain unchanged. The CP-oriented search annotations are removed for the HiGHS-targeted formulation; this does not change feasibility.

## Interface and solution correspondence

The original external parameters, derived definitions, and four decision-variable arrays retain their names and meanings. No additional instance data are required.

The mapping script copies only `size`, `area`, `when`, and `what`, excluding auxiliary assignment variables. It performs no reconstruction and reports missing required solution fields rather than supplying guessed values.

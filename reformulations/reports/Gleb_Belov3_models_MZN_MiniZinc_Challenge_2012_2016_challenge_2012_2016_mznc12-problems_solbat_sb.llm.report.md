## Problem background

The model represents **Solitaire Battleships**, a grid-based logic puzzle. A fleet of straight ships must be placed on a board so that:

- Given clues specify the contents of selected cells.
- Each row and column contains a prescribed number of occupied cells.
- The fleet contains a prescribed number of ships of each length.
- Ships have the required endpoint and middle-piece geometry and cannot touch diagonally or merge through incompatible adjacent pieces.

Cells are represented as water, a single-cell submarine, one of four directional endpoints, or a middle segment. An extended border supplies neighboring cells for local constraints.

Instance data remain external: board dimensions, clues, row and column totals, and fleet composition are supplied through the original data interface.

## Original model structure

### Variables

The original model declares:

| Variable | Domain and meaning |
|---|---|
| `board` | One integer in `1..7` per extended-grid cell, encoding its piece type |
| `fill` | One binary integer per extended-grid cell, indicating occupancy |
| `npiece` | Seven bounded integer variables counting interior cells of each piece type |

Thus, the source declares \(2|XROWS||XCOLS|+7\) integer decision variables. Numerical counts depend on the external dimensions.

### Constraints

The constraints:

1. Enforce supplied cell clues and designated water-border cells.
2. Channel piece types to occupancy through `fill = bool2int(board != w)`.
3. Prohibit diagonal contact and impose water beside incompatible piece types.
4. Require endpoints to connect to appropriate endpoints or middle segments.
5. Require middle segments to have exactly two opposite occupied neighbors.
6. Count each piece type and relate those counts to the fleet.
7. Detect horizontal and vertical ships of each specified length using endpoint and intervening-middle patterns.
8. Enforce row and column occupancy totals.

The model is a **satisfaction problem**, with no numerical objective. Its original search annotation branches on interior occupancy variables.

## Reformulation and justification

### One-hot piece encoding

The reformulation introduces seven binary indicators per extended-grid cell, exactly one of which is selected. The original variables remain connected through
\[
board_{ij}=\sum_{p=1}^{7}p\,x_{ijp},
\qquad
fill_{ij}=1-x_{ijw}.
\]

This is exact: every original piece value has a unique one-hot representation, and every feasible one-hot vector identifies precisely one original piece. Retaining `board`, `fill`, and `npiece` also preserves their meanings and permits direct solution mapping.

The encoding increases the explicit variable count, but exposes the logical structure as linear constraints suitable for the HiGHS mixed-integer backend.

### Linear local geometry constraints

Logical conditions are replaced by binary linear inequalities:

- Diagonal separation becomes \(fill_a+fill_b\leq1\).
- A piece type requiring an adjacent water cell becomes an inequality between the relevant piece indicators and neighboring occupancy.
- Endpoint continuation becomes an inequality requiring one of the permitted neighboring piece types.
- Middle-piece conditions become conditional linear equalities and bounds.

These transformations are exact because the piece indicators are mutually exclusive and binary. For example, when the middle indicator is one, the reformulation enforces equal occupancy on opposite sides and requires exactly one of the upper and left neighbors to be occupied. When the indicator is zero, the inequalities impose no additional restriction on binary neighboring occupancies. The conditional bounds use constants of one, derived directly from the binary domains rather than an arbitrary large big-\(M\).

### Exact linear ship detection

For each original ship-length test, the reformulation introduces horizontal and vertical binary detection variables. A detection variable is constrained to equal the conjunction of the required endpoint and middle-piece indicators.

For \(s\) binary indicators \(a_1,\ldots,a_s\), the standard linearization
\[
y\leq a_k\quad\text{for every }k,
\qquad
y\geq\sum_{k=1}^{s}a_k-(s-1)
\]
enforces \(y=1\) exactly when all indicators equal one.

The original horizontal-or-vertical detection is replaced by the sum of the two detections. This is valid because both cannot hold at the same starting cell: horizontal detection requires a left endpoint, while vertical detection requires a top endpoint.

### Redundant consistency equalities

Two implied equalities are added to support presolve:

- **Total row occupancy equals total column occupancy.** Both sum the same interior `fill` variables.
- **Total occupancy equals fleet area.** The original piece-count equations imply this directly: submarines contribute one occupied cell each, paired endpoints contribute two per longer ship, and middle pieces contribute \(s-2\) per ship of length \(s\).

These equalities cannot remove an original feasible solution. They can reveal inconsistent data early and provide additional linear relationships. No instance-specific preprocessing was possible because no external instance was supplied.

### Interface and indexing preservation

The original parameter names, fixed constants, variable arrays, and satisfaction direction are retained. The original width/height-dependent boundary and ship-detection tests are preserved rather than silently repaired; explicit guards reject cases that would require an out-of-domain original reference.

The mapping script copies `board`, `fill`, and `npiece`, including their encoded index sets, and excludes all reformulation auxiliaries. No reconstruction assumptions are needed.

## Expected computational effect

The reformulation replaces nested logical expressions and reified piece comparisons with an explicit binary linear formulation. This gives HiGHS direct access to local geometry, ship detection, and counting relationships. The trade-off is additional binary variables; improved solving time is an intended benefit, not an experimentally established result.

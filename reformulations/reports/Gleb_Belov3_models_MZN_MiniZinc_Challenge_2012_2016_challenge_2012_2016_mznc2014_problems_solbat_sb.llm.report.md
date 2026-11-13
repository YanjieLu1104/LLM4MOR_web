## Problem background

The model solves **Solitaire Battleships**, a grid-based logic puzzle. A fleet of straight ships must be placed on a board so that:

- Each row and column contains a prescribed number of occupied cells.
- The number of ships of each length matches the supplied fleet.
- Ships do not touch diagonally, and neighboring ship segments form valid ship shapes.
- Any supplied clues—water, submarines, ship ends, or middle segments—are respected.

The board dimensions, clues, row and column totals, and fleet composition are external inputs. No particular instance was supplied.

## Original formulation

The model uses seven cell labels: water, submarine, left end, right end, top end, bottom end, and middle segment. It declares:

- **`board`**: an integer piece label for each cell of an extended board.
- **`fill`**: a binary occupancy indicator for each extended-board cell.
- **`npiece`**: seven integer variables counting piece labels in the interior.

For nonnegative dimensions, these declarations contain
\[
2(width+2)(height+2)+7
\]
scalar decision variables.

Constraints connect occupancy to piece labels, impose clues and boundary water, prohibit diagonal contact, and enforce local ship geometry. Other constraints count piece types, match the fleet’s number of ships of each length, and enforce row and column occupancy totals. Ship-length counting uses conjunctions of endpoint and intervening-middle tests.

This is a **satisfaction problem**, expressed by `solve satisfy`; there is no objective function. The original search annotations prioritize occupancy variables and then piece labels.

A source-level peculiarity is that some boundary and ship-length tests interchange `width` and `height` relative to the declared row and column domains. The reformulation preserves those tests rather than replacing them with an assumed intended rectangular-board interpretation. It also guards potentially invalid accesses. Equivalence claims concern inputs for which the original expressions are well-defined.

## Reformulation and justification

### One-hot piece representation

The reformulation introduces a binary indicator for every extended-board cell and piece type. Exactly one indicator is selected per cell, and the original `board` variable equals the weighted sum of the selected labels.

This is an exact representation: each original cell has precisely one label in `1..7`, and each feasible indicator assignment identifies precisely one such label. Occupancy becomes
\[
fill_{ij}=1-x_{ij,w},
\]
which is equivalent to the original condition that a cell is occupied exactly when it is not water. Piece counts become sums of these indicators.

The original `board`, `fill`, and `npiece` variables remain available, preserving their meanings and allowing an identity solution mapping.

### Linear local compatibility constraints

The original logical implications are replaced by binary linear inequalities.

For example, a left endpoint requires either a right endpoint or a middle segment immediately to its right:
\[
x_{ij,l}\le x_{i,j+1,r}+x_{i,j+1,m}.
\]
This is equivalent to the original implication because the indicators are binary and exactly one piece label is selected at each cell.

Similarly, diagonal separation becomes
\[
fill_{ij}+fill_{i+1,j\pm1}\le1.
\]
Directional water requirements are grouped into inequalities combining the relevant, mutually exclusive piece indicators with neighboring occupancy.

For a middle segment, conditional equalities between opposite neighbors are expressed using unit-sized bounds. When the middle indicator is one, these constraints enforce the original equalities and require exactly one of the upper and left neighbors to be occupied. When it is zero, the inequalities impose no additional restriction because occupancy is binary.

These changes target HiGHS by exposing the binary linear structure directly rather than relying on nested logical reification.

### Exact linearization of ship-length matches

Binary variables represent horizontal and vertical matches of each counted ship length. For a candidate consisting of \(s\) required piece indicators, the formulation imposes an upper bound by every indicator and a lower bound equal to their sum minus \(s-1\).

Thus, a match variable is one **if and only if** all required endpoints and middle segments are present.

The original count uses a logical OR between horizontal and vertical matches at each starting cell. Replacing that OR by their sum is valid because a horizontal match requires a left endpoint at the starting cell, whereas a vertical match requires a top endpoint. The one-hot representation makes these alternatives mutually exclusive.

### Fleet-area consistency checks

The reformulation adds redundant aggregate constraints that can expose inconsistent input before substantial search.

The original piece-count equations imply:
\[
\text{occupied area}
=ship[1]+\sum_{s=2}^{maxship}s\,ship[s].
\]
Indeed, submarines contribute one cell each; equality of opposite endpoint counts gives two endpoints per non-submarine ship; and the middle-count equation contributes \(s-2\) cells for each ship of length \(s\).

Both the sum of row totals and the sum of column totals count this same occupied area. Consequently, checking their equality and their agreement with fleet area cannot remove an original feasible solution. Likewise, the number of water cells equals total interior area minus occupied area.

## Expected effect

The reformulation trades additional binary variables for explicit linear constraints and shared piece indicators. This is intended to improve the formulation presented to the HiGHS mixed-integer backend, although no solve-time improvement was measured. The logical linearizations preserve feasible assignments, and the aggregate consistency checks follow directly from existing constraints. No optimization objective or instance data were changed.

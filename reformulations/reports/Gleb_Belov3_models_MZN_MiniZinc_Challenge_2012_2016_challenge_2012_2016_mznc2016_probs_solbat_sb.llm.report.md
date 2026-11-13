## Problem background

The model represents **Solitaire Battleships**, a grid-based logic puzzle. A fleet of straight ships must be placed on a board using clues that specify:

- The number of occupied cells in each row and column.
- The number of ships of each length.
- Optional cell hints indicating water, a submarine, a ship endpoint, or a middle segment.

Ships cannot touch diagonally, and orthogonal adjacency must be consistent with their shapes. Unlike adversarial Battleships, this is a reconstruction problem: the task is to find any completed board satisfying all clues.

## Original model

The input includes board dimensions, cell hints, row and column totals, and fleet counts. Despite their names, `width` defines the row index set and `height` defines the column index set.

### Variables

The original model declares:

- **`board`**: an extended grid of seven-valued integer variables representing water, submarines, four endpoint types, and middle segments.
- **`fill`**: a binary variable for every extended-grid cell, indicating whether it contains a ship segment.
- **`npiece`**: seven integer variables counting the occurrences of each piece type in the interior.

For nonnegative dimensions, each extended-grid array has \((width+2)(height+2)\) entries. Thus, the original declarations contain \(2(width+2)(height+2)+7\) scalar decision variables.

### Constraints and objective

The constraints enforce:

1. Agreement with supplied hints and water on the specified boundary cells.
2. Equivalence between occupancy and a non-water board value.
3. Diagonal separation and direction-dependent orthogonal separation.
4. Endpoint continuation and straight-through middle segments.
5. Piece counts consistent with the fleet.
6. Exact counts of ships of each specified length, recognized through endpoint-and-middle patterns.
7. Row and column occupancy totals.

The solve item is **`satisfy`**: there is no numerical objective. The original search annotation prioritizes occupancy variables before piece types.

## Reformulation

The reformulation targets the **HiGHS mixed-integer programming backend** by replacing logical expressions with explicit linear constraints. It retains all original decision-variable arrays and their external names.

### One-hot piece representation

Each extended-grid cell receives seven auxiliary binary indicators, exactly one of which is selected. Linear channeling equations define:

- `board` as the weighted sum of the selected piece code.
- `fill` as one minus the water indicator.

This representation is exact because the original board domain consists of precisely those seven piece codes. Consequently, piece-equality tests become individual binary indicators, and piece counts become linear sums.

### Linear separation and shape constraints

Diagonal water disjunctions become occupancy inequalities of the form
\[
fill_{i,j}+fill_{i+1,j\pm1}\leq 1.
\]

Directional separation constraints use sums of the relevant piece indicators plus the neighboring occupancy. These sums faithfully represent membership in the original piece sets because the one-hot constraint permits only one piece type per cell.

Endpoint continuation becomes an inequality requiring the appropriate endpoint or middle indicator in the neighboring cell. Middle-segment implications become conditional linear equalities and bounds with unit-sized relaxation constants. When the middle indicator is one, they enforce the original opposite-neighbor equalities and occupancy sum; when it is zero, the inequalities impose no additional restriction on binary occupancies.

### Exact ship-pattern indicators

Auxiliary binary variables identify horizontal and vertical ships of each counted length at each interior starting cell. Each indicator is an exact linearization of the original conjunction: the correct starting endpoint, ending endpoint, and all required middle segments must be present.

Horizontal and vertical indicators are summed separately in fleet-count equations. This is equivalent to the original disjunction because a cell cannot simultaneously contain both a left endpoint and a top endpoint. Thus, the two orientations cannot both be counted at the same starting cell.

### Parameter-only filtering and indexing safeguards

Length/orientation tests that cannot pass the original dimension checks are fixed to zero before solving. This is valid because the corresponding original conditional expression evaluates to false regardless of the decision variables.

The source contains width/height-dependent boundary and length tests that are potentially problematic on rectangular boards. The reformulation preserves those tests rather than substituting the usual rectangular-board convention, and guards potentially invalid accesses. This is an indexing safeguard, not a claim that the source supports every rectangular input.

### Solution interface and expected benefit

The original arrays `board`, `fill`, and `npiece` remain available and are explicitly marked for output. The mapping script copies only these arrays, preserving their encoded index sets and reporting missing values rather than reconstructing them from assumptions.

No symmetry breaking, fleet-specific assumptions, or additional cutting planes were introduced. The intended benefit is a direct binary linear formulation with small coefficients, avoiding nested logical reification. The reformulation adds auxiliary variables rather than reducing the declared variable count; any runtime improvement remains instance-dependent and has not been established by benchmark results here.

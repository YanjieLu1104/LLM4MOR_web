## Problem background

The model represents a **nonogram**, a grid-based picture puzzle. Each cell is either blank or marked, and clues restrict the patterns permitted in every row and column. Solving the puzzle means finding a grid consistent with both sets of clues.

Here, clues are encoded as **binary descriptions of finite-state automata**, rather than conventional lists of marked-run lengths. Negative entries in the supplied clue arrays are padding and are removed before constructing each automaton. A clue beginning with zero requires an entirely blank line; otherwise, its entries describe a sequence of marked cells and blank separators, with additional blank cells permitted at selected positions.

## Original model

### Data and variables

- `X` and `Y` specify the grid width and height.
- `maxlen` is the number of available clue entries per line.
- `rows` and `cols` supply the row and column descriptions.
- `nonmul` and `nonadd` are fixed lookup tables used to construct automaton transitions.

The independent decision array is `A[1..Y, 1..X]`. For nonnegative grid dimensions, it contains \(XY\) integer variables, each with domain `1..2`:

- `1`: blank cell;
- `2`: marked cell.

### Constraints and objective

The model imposes one `regular` constraint on each row and each column: \(Y+X\) line constraints in total. Each constraint requires its cell sequence to describe a path from the initial state to the accepting state of the corresponding automaton.

The model is a **satisfaction problem**, with no numerical objective. Its original search annotation visits cells in input order and tries marked cells first.

## Reformulation

### Explicit layered network flows

Each `regular` constraint was replaced by a layered network-flow formulation suitable for the HiGHS mixed-integer backend.

A network layer represents a position between consecutive cells. An arc represents an allowed automaton transition for one cell value. Continuous variables in \([0,1]\) carry one unit of flow from the initial state before the line to the accepting state after it. Flow-conservation equations connect successive layers.

At each cell position, the sum of flow on arcs labelled `2` is constrained to equal `A - 1`. Thus, a blank cell permits flow only on blank-labelled arcs, and a marked cell permits flow only on marked-labelled arcs.

**Why this is equivalent:** an accepted original cell sequence defines a feasible unit-flow path. Conversely, the layered network is acyclic, so any feasible unit flow decomposes into source-to-sink paths. Because `A` remains integral, its channeling equations force every such path to use the selected symbol at every position. Hence the cell sequence must be accepted by the original automaton. No additional integer variables are required.

### Distance-based arc preprocessing

The original lookup tables generate only transitions that either remain in the current state or advance by exactly one state.

This permits two safe arc-removal tests:

- Before processing cell \(t\), a state numbered greater than \(t\) cannot have been reached from state 1.
- After processing cell \(t\), an arc destination must be close enough to the accepting state to reach it within the remaining cells.

**Why these removals are valid:** each consumed cell can advance the automaton by at most one state. Any arc violating either bound cannot belong to an accepting path. Removing it therefore preserves all feasible grids.

### Redundant marked-cell counts

For every line, the reformulation adds an equation fixing the number of marked cells:

- zero when the clue begins with zero;
- otherwise, the sum of the filtered binary clue entries.

**Why this is valid:** in a nonempty-clue automaton, reaching the accepting state requires traversing every forward transition exactly once. Their labels reproduce the binary clue entries, while all permitted self-loops consume blank cells. Consequently, every accepted line contains exactly the stated number of marked cells.

These equations are redundant for integer feasibility but expose useful aggregate information directly to the linear solver.

## Interface and solution preservation

The external parameters, fixed lookup tables, and original decision array `A` were retained. The mapping script copies `A`, including its index sets, and excludes auxiliary flows. The custom display was also corrected to traverse rows and columns within their declared domains.

The reformulation remains a satisfaction model. Its intended benefit is a more explicit linear formulation for HiGHS, with fewer impossible arcs and additional line-level equations; no measured runtime improvement is claimed.

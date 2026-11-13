## Problem background

The file represents a grid-tiling feasibility problem, apparently involving pentominoes—pieces composed of five connected squares. Such puzzles are examples of packing and exact-cover problems, with applications in layout design and discrete resource allocation.

The model represents a rectangular board as a row-major sequence of integer labels. The last column of every row is reserved for the separator label `ntiles+1`, allowing automata to recognize row boundaries. The remaining cells cannot contain that label.

The geometric rules are supplied externally as deterministic finite automata (DFAs), one per tile. Consequently, the source alone does not establish the exact piece shapes, allowed orientations, or required number of occurrences of each piece. These properties are encoded in the supplied transition tables, rather than explicit geometric constraints.

## Original formulation

### Variables and data

The model declares `width*height` integer decision variables in the array `board`, each with domain `filled..ntiles+1`.

External data provide the board dimensions, label bounds, number of tiles, and automata. For each tile, `tiles` specifies its number of states, alphabet size, accepting-state interval, and offset into the flattened transition array `dfa`.

### Constraints

The model imposes:

- **Interior-cell restrictions:** cells before the last column cannot equal `ntiles+1`.
- **Row separators:** the last cell of each row equals `ntiles+1`.
- **Automaton acceptance:** for every tile, a `regular` constraint requires the entire board sequence to be accepted by that tile’s DFA, starting in state 1.

Thus, a feasible board belongs to the intersection of all supplied automata languages and satisfies the separator restrictions.

### Objective and search

This is a **satisfaction problem**, with no numerical objective. The original search annotation selects board variables in input order and tries smaller values first.

## Reformulation and its justification

### Shared binary symbol indicators

The reformulation retains `board` and introduces a binary indicator for each position and candidate label. Exactly one indicator is selected at each position, and a weighted-sum equality links the selected label to the corresponding board value.

This is an exact encoding: every permitted integer board value has a corresponding one-hot assignment, and every one-hot assignment determines that same board value. Sharing these indicators across all automata ensures that every automaton processes the same sequence.

### Common-alphabet preprocessing

When at least one automaton is present, candidate labels are restricted to the intersection of:

- the original domain `filled..ntiles+1`; and
- every automaton’s alphabet `1..s`.

This reduction is valid because each original `regular` constraint must read every board position. A label outside any one automaton’s alphabet cannot occur in an accepted sequence. When there are no automata, the original board-label domain is retained.

The separator constraints also fix incompatible symbol indicators to false: separator positions permit only `ntiles+1`, while interior positions exclude it. This follows directly from the original cell constraints.

### Sparse layered network-flow encoding

Each `regular` constraint is replaced by a layered network:

- Layers correspond to successive board positions.
- Nodes represent DFA states.
- Arcs represent permitted transitions, labelled by the board symbol they consume.
- One unit of flow starts in state 1.
- Flow conservation connects consecutive layers.
- At each position, the flow on arcs carrying a given symbol equals that symbol’s shared binary indicator.

Flow variables are continuous and bounded between zero and one. This is sufficient because the automata are deterministic: once a symbol is selected, each state has at most one outgoing transition with that symbol. Starting from the single initial state, induction over positions forces the unit flow to follow the unique run for the selected board sequence. Conversely, any accepting run supplies a feasible unit-flow assignment.

The formulation therefore preserves the accepted sequences without requiring binary variables for individual transitions.

### Arc filtering and boundary conditions

The network omits arcs that cannot occur in an accepting run:

- **Transitions to state 0:** these are failure transitions under the original `regular` semantics.
- **Position-incompatible symbols:** these violate the original separator or interior-cell constraints.
- **First-position arcs from states other than 1:** the original automata start in state 1.
- **Last-position arcs ending outside the accepting set:** the original automata must finish in an accepting state.

For an empty board sequence, acceptance is checked directly by requiring the initial state to be accepting.

These are local feasibility reductions, not assumptions about pentomino geometry. No additional tile-area, symmetry-breaking, or piece-count constraints were introduced.

## Solver motivation and solution mapping

The reformulation targets **HiGHS**, a mixed-integer linear solver. Sparse linear flow constraints and shared binary symbol indicators provide an explicit MILP representation of automaton acceptance, avoiding reliance on a generic translation of the original global constraints. The continuous transition flows also avoid adding a binary decision for every arc. Actual performance depends on the supplied automata and board dimensions; no speedup is established without benchmarking.

All original external parameter names and meanings are retained. The original `board` variable remains the solution representation, so the mapping script copies its values and index sets directly and excludes auxiliary variables. There is no objective value to reconstruct.

# Nonogram Model Reformulation Report

## Problem background

The model represents a **nonogram**, a grid-based picture puzzle. Each cell is either blank or filled, and each row and column must match a supplied pattern. The intersection of these line requirements determines the picture.

The grid has `Y` rows and `X` columns. Cell value `1` denotes blank and value `2` denotes filled. Unlike conventional nonogram clues expressed as run lengths, this model uses **binary sequences that define finite-state automata**. Negative entries in the input arrays are padding and are removed before constructing each automaton. A filtered sequence beginning with zero specifies an entirely blank line.

The reformulation preserves this particular interpretation rather than substituting a conventional run-length model.

## Original model

### Variables and data

The original decision array is:

- `A[1..Y, 1..X]`, with each entry in `1..2`.

Thus, for nonnegative dimensions, there are `X × Y` integer decision variables. External parameters `X`, `Y`, `maxlen`, `rows`, and `cols` specify the grid and its line patterns. Two fixed binary lookup tables, `nonmul` and `nonadd`, determine the automaton transitions.

### Constraints

Each row and each column is constrained by a `regular` constraint: its cell sequence must be accepted by its corresponding automaton. There are `Y + X` such constraints for nonnegative dimensions.

For a filtered clue sequence beginning with `1` and having length `n`, the automaton:

- starts in state `1`;
- accepts in state `n + 1`;
- advances only from state `q` to state `q + 1`;
- permits blank-symbol self-loops at selected states;
- treats transition value `0` as rejection.

These properties follow directly from the fixed transition tables. In particular, no accepted transition skips a state or moves backward.

### Objective

This is a **satisfaction problem**: there is no numerical objective. The original solve item supplies a cell-by-cell integer search order, trying filled cells first.

## Reformulation and justification

### 1. Replace automaton globals with layered network flows

Each line automaton is expanded into a network whose layers correspond to the number of cells already read. A network node identifies both the layer and automaton state. Arcs represent permitted state advances or blank self-loops.

Flow conservation sends one unit from the initial state before the first cell to the accepting state after the last cell. At each cell position, the total flow on filled-symbol arcs is constrained to equal `A − 1`.

This is equivalent to the original `regular` constraint:

- Any accepted cell sequence yields a unit-flow path through its automaton.
- Conversely, feasible flow decomposes into source-to-sink paths. Because `A − 1` is either zero or one and each layer carries one unit of nonnegative flow, every positive-flow path must use the symbol selected by `A` at that layer. Such a path therefore witnesses acceptance of the cell sequence.

Consequently, the added flow variables may remain **continuous**. The original integer cells provide the necessary discrete symbol choices. This produces explicit linear constraints suitable for HiGHS without requiring binary variables for every network arc.

### 2. Preprocess impossible arcs using state-distance bounds

An accepting path must make exactly `n` state advances. A line shorter than `n` is therefore infeasible.

At layer `t` of a line of length `L`, a reachable state `q` must satisfy:

- `q ≤ t + 1`, because each processed cell permits at most one advance;
- `q ≥ n + 1 − (L − t)`, because the remaining cells must suffice to reach the accepting state.

Arcs inconsistent with these bounds, or absent from the original transition table, are fixed to zero. This is valid because the original automata permit only self-loops and single-state advances; no accepting path can use an excluded arc.

### 3. Add redundant filled-cell counts

Every accepting path crosses each state boundary exactly once. The transition tables give each advance a fixed symbol, and all self-loops consume blank symbols. Therefore, the number of filled cells in a line equals the number of advances labeled with symbol `2`.

The reformulation adds this equality explicitly for every line. It excludes no original solution: it is already implied by acceptance in the original automaton. Its purpose is to expose a useful aggregate relationship directly to linear presolve and propagation.

### 4. Preserve the solution interface

The original array `A`, external parameter declarations, and fixed lookup tables are retained. The mapping script returns `A` unchanged and omits auxiliary flow variables, so no instance-dependent reconstruction is necessary.

The CP-oriented search annotation is removed in favor of HiGHS’s native search. The display traversal is also corrected to follow the declared row and column domains on rectangular grids; this does not change feasibility.

## Expected effect

The reformulation exposes automaton acceptance as linear flow constraints, removes structurally impossible arcs before solving, and adds implied line totals. These changes are intended to improve processing by HiGHS while preserving the original feasible cell assignments. No instance-specific timing results were supplied, so a runtime improvement has not been established empirically.

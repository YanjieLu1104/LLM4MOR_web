## Background and interpretation

The model describes a grid-based connection puzzle, similar to routing labelled paths through a maze. An \(X \times Y\) rectangular grid contains \(N\) labelled start–end pairs. Cells can be unused or assigned to a pair, and successor pointers describe how occupied cells connect.

This interpretation must be distinguished from the precise mathematical formulation: the original constraints do **not** explicitly require each label to form a single connected start-to-end path. Disconnected cycles can also be feasible. The reformulation preserves these possibilities rather than imposing stronger puzzle rules.

## Original model

Let \(M=XY\). The input provides the coordinates of each pair’s start and end. Derived arrays assign cell identifiers and record orthogonal neighbours.

### Decision variables

The model declares \(2M+1\) integer variables:

- `path[0..M]`, with values in \(0..N\): the label assigned to each cell, where zero denotes an unused cell. Index zero is a dummy cell fixed to label zero.
- `next[1..M]`, with values in \(0..M\): each cell’s successor, with zero representing no successor.

### Constraints

For every pair \(k\):

- Its start and end receive label \(k\).
- Its end points to itself.
- No neighbouring cell points into its start.

For every non-end cell, its label equals its successor’s label:
\[
\operatorname{path}[u]=\operatorname{path}[\operatorname{next}[u]].
\]

Every occupied cell that is not a start has exactly one incoming pointer from an orthogonal neighbour. Every unused cell has successor zero.

Although successor variables initially range over all cells, these constraints collectively imply a much smaller set of possible successors.

### Objective

This is a **satisfaction problem**, with no objective function. The original search annotation branches on successors followed by cell labels, using first-fail variable selection and minimum-value branching.

## Reformulation and its justification

### 1. Derive local successors by counting incoming arcs

The main reduction is that every occupied non-end cell must point to an orthogonal neighbour.

To establish this, consider any feasible original solution with \(A\) occupied cells:

1. Endpoint label constraints force the \(N\) starts to be distinct and the \(N\) ends to be distinct. Otherwise, one cell would be assigned two different labels. All endpoints are occupied.
2. An unused cell cannot receive a neighbour pointer. A non-end predecessor pointing to it would have the same zero label and would therefore have successor zero, a contradiction. An end points only to itself and cannot supply such a neighbour pointer.
3. Starts receive no neighbour pointers, while every other occupied cell receives exactly one. Consequently, there are exactly \(A-N\) neighbour pointers.
4. Unused cells supply none, and ends supply none because their self-pointers are not grid-neighbour pointers. Only the \(A-N\) occupied non-end cells can supply them, each supplying at most one.

Thus all occupied non-end cells must supply exactly one neighbour pointer. This is a problem-specific counting argument, not an additional routing assumption.

### 2. Preprocess the eligible directed arcs

The reformulation constructs a sparse list of directed orthogonal-neighbour arcs, excluding:

- Arcs leaving ends, since their successors are fixed to themselves.
- Arcs entering starts, since the original constraints forbid them.

The counting result proves that these arcs cover every possible successor of an occupied non-end cell. Endpoint coordinates, labels, and cell identifiers remain unchanged.

### 3. Replace variable-index lookup with a linear arc formulation

The reformulation adds:

- One binary occupancy variable per cell.
- One binary selection variable per eligible directed arc.

For occupancy \(z_u\) and label \(p_u\), the bounds
\[
z_u \le p_u \le Nz_u
\]
make occupancy equivalent to having a positive label.

Outgoing selected-arc counts equal occupancy for non-end cells. Incoming selected-arc counts equal occupancy for non-start cells. The latter strengthens the original conditional incoming constraint to an equality; it is valid because, as proved above, unused cells cannot receive neighbour pointers.

Each original successor variable is retained and linked to the selected arc’s destination. Ends retain their self-successors.

For an eligible arc \(u\to v\) with selection variable \(b_{uv}\), label propagation becomes
\[
p_u-p_v\le N(1-b_{uv}),\qquad
p_v-p_u\le N(1-b_{uv}).
\]
When selected, the arc forces equal labels. When unselected, these inequalities impose no restriction beyond the original label bounds \(0..N\).

This replaces variable-index label access and repeated successor-equality tests with a sparse mixed-integer linear formulation suited to HiGHS. Its benefit is structural; no runtime improvement was established from supplied instance data.

### 4. Preserve solutions and the external interface

The original `path` and `next` arrays remain independent top-level declarations, preserving their meanings and external binding interface. The mapping script copies these arrays, including their index sets, and omits auxiliary variables.

Every original feasible solution induces valid occupancy and arc selections by the counting argument. Conversely, the new constraints enforce the original endpoint rules, incoming counts, zero-successor rule, and successor-label equality. No connectivity constraints or cycle-elimination cuts were introduced.

The custom output width was also made well-defined when \(N=0\); this affects presentation only, not feasibility.

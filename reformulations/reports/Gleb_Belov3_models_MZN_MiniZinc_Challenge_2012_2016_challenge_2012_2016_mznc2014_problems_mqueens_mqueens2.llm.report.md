## Problem background

The model describes a **minimum independent dominating placement of queens** on an \(n \times n\) chessboard. A queen attacks all other squares in its row, column, and two diagonals. The goal is to place as few queens as possible such that:

- no two queens attack one another; and
- every square without a queen is attacked by at least one queen.

Thus, the placement is *maximal*—another queen cannot be added without creating a conflict—but its cardinality is minimized among such placements.

Although the supplied model is a chessboard benchmark rather than a documented application, its structure represents a general coverage-with-conflicts problem: selecting mutually compatible sites that collectively cover every location.

## Original formulation

The only external parameter is the board size, `n`. The model declares:

| Symbol | Size | Meaning |
|---|---:|---|
| `filled` | \(n^2\) Boolean variables | Whether each square contains a queen |
| `f` | \(n^2\) binary views | Integer representation of `filled` |
| `q` | \(n\) integer variables in \(0..n\) | Queen column in each row, or zero for an empty row |
| `objective` | One integer variable in \(0..n\) | Number of occupied rows |

For every square, the original model equates its occupancy with the negation of the existence of an attacking queen. This equivalence has two consequences:

1. An occupied square cannot have an attacking queen, enforcing nonattacking placements.
2. An unoccupied square must have an attacking queen, enforcing domination.

The row-position equations are
\[
q_i=\sum_{j=1}^{n}j f_{ij}.
\]
Because nonattacking placements contain at most one queen per row, this weighted sum correctly identifies that queen’s column.

The objective minimizes
\[
\sum_{i=1}^{n}[q_i>0],
\]
which equals the total number of queens.

The model also imposes symmetry constraints through a custom permutation predicate. It generates 12 ordered-pair lexicographic comparisons from four square permutations. The original search annotation branches on the binary board entries in row-major order, trying occupancy first.

## Reformulation and justification

### Binary occupancy variables for attack lines

The reformulation introduces binary occupancy variables for every row, column, and diagonal. Each is constrained to equal the sum of `f` over that line. For example,
\[
R_i=\sum_j f_{ij}, \qquad R_i\in\{0,1\}.
\]

These equations enforce at most one queen per attack line. This is equivalent to the original nonattacking requirement: two queens attack one another exactly when they share a row, column, or diagonal. Conversely, every original feasible placement has line sums of zero or one and therefore admits these auxiliary variables.

The diagonal index sets are derived from the board’s actual index domains using \(i-j\) and \(i+j\). Diagonal sums reference only in-bounds squares, avoiding the original formulation’s explicit off-board attack expressions.

### Linear domination inequalities

For each square \((i,j)\), the reformulation imposes
\[
R_i+C_j+D_{i-j}+S_{i+j}-3f_{ij}\ge 1.
\]

Here, \(D\) and \(S\) denote occupancy of the two diagonal families.

This inequality is valid because the four attack lines through a square intersect only at that square:

- If \(f_{ij}=0\), the inequality requires at least one queen on an attacking line.
- If \(f_{ij}=1\), its queen contributes to all four line occupancies. Subtracting \(3f_{ij}\) counts it once, so the inequality is satisfied.

Together with the line-capacity equations, these inequalities reproduce both directions of the original occupancy equivalence. They also strengthen the linear relaxation relative to the uncorrected inequality \(R_i+C_j+D_{i-j}+S_{i+j}\ge1\), which counts fractional occupancy at the square four times.

### Linear objective

The objective is rewritten as
\[
\texttt{objective}=\sum_i R_i.
\]

This preserves its value because each row contains at most one queen, and the retained definition of `q` implies \(q_i>0\) exactly when \(R_i=1\). The rewrite avoids a separate positivity test for each row.

### Preserved interface and symmetry

The reformulation retains `filled`, `f`, `q`, and `objective`, including their original meanings and domains. It also retains the exact original symmetry constraints rather than substituting a different symmetry-breaking scheme.

The mapping script returns the original independent variables—`filled`, `q`, and `objective`—directly from the solution and excludes auxiliary variables. The original definition reconstructs `f`.

## Expected computational effect

The main technique is an **extended mixed-integer linear formulation**, not instance-specific preprocessing. Shared attack-line sums replace repeated Boolean attack disjunctions, and linear domination inequalities expose coverage directly to HiGHS. The CP-style search annotation is omitted.

These changes aim to reduce repeated attack logic and improve linear-relaxation reasoning while preserving feasible placements and objective values. No runtime improvement is claimed without solver measurements.

## Problem background

The model represents **Black Hole Patience**, a solitaire card game. A standard 52-card deck is represented by integers from 1 to 52. Card 1, the Ace of Spades, starts the central “black hole”; the remaining cards are normally arranged in 17 piles of three cards.

The task is to find an order in which every card can be played. Two rules govern this order:

- Consecutive cards must have adjacent ranks, regardless of suit, with Ace and King also considered adjacent.
- Within each pile, a card must be played before the card beneath it.

The external array `layout` specifies pile order. A fixed table, `neighbours`, lists the 416 permitted ordered pairs of consecutive cards. The reformulation does not assume that an externally supplied layout is a partition of the remaining cards; it preserves the precedence conditions actually expressed by the original model.

## Original formulation

The original model contains **104 integer decision variables**, each with domain `1..52`:

- `x[p]`: the card played at position `p`.
- `y[c]`: the position at which card `c` is played.

Its constraints are:

| Component | Count | Meaning |
|---|---:|---|
| Starting-card equality | 1 | `x[1] = 1` |
| Adjacency tables | 51 | Every consecutive pair belongs to `neighbours` |
| Inverse global constraint | 1 | `x` and `y` describe mutually inverse permutations |
| Pile-precedence inequalities | 34 | Each card precedes the next card beneath it |

The inverse constraint ensures that every card occurs exactly once. The model is a **satisfaction problem**, not an optimization problem: any complete legal play sequence is acceptable. Its original search annotation branches on `x` in position order, trying smaller card numbers first.

## Reformulation

### Binary assignment representation

The inverse constraint was replaced by a **binary assignment formulation** with 2,704 variables:

\[
z_{p,c}=1 \iff \text{card }c\text{ is played at position }p.
\]

Each position receives exactly one card, and each card receives exactly one position. The original arrays remain connected through linear equations:

\[
x_p=\sum_c c\,z_{p,c},
\qquad
y_c=\sum_p p\,z_{p,c}.
\]

This is equivalent to the original inverse constraint. Any original permutation defines exactly one binary assignment matrix; conversely, the row and column equalities make an integral assignment matrix a permutation, and the channeling equations recover its mutually inverse `x` and `y`.

This change exposes the permutation structure directly as linear constraints suitable for the **HiGHS mixed-integer backend**.

### Rank-based adjacency aggregation

The fixed neighbour table has a useful structure: define a card’s zero-based rank as

\[
r(c)=(c-1)\bmod 13.
\]

A pair is allowed exactly when its rank difference has absolute value 1 or 12. Thus, adjacency depends on rank, not suit.

The reformulation reconstructs `neighbours` with the same entries and row order, but replaces the 51 table constraints with linear rank-support inequalities. If position \(p\) contains rank \(r\), position \(p+1\) must contain one of its two neighbouring ranks. Reverse support inequalities are also included.

These inequalities are exact for integral assignment solutions: each position contains exactly one card, so the selected rank must have an allowed successor. Every pair accepted by the original table satisfies the same condition. The reverse inequalities are redundant for integer feasibility but can strengthen the linear relaxation.

### Cumulative precedence cuts

All 34 original pile-precedence inequalities are retained. Additional **cumulative precedence cuts** are imposed for every precedence pair \(a\prec b\) and every position threshold \(t\):

\[
\sum_{p\le t}z_{p,b}
\;\le\;
\sum_{p<t}z_{p,a}.
\]

Their validity follows directly from the original strict inequality \(y_a<y_b\). If card \(b\) has appeared by position \(t\), card \(a\) must have appeared before \(t\). Otherwise, the left-hand side is zero and the inequality is automatically satisfied.

These cuts provide more information about partial assignments than position inequalities alone. They do not require distinct cards within the input layout or any additional deck-partition assumption.

## Interface and expected effect

The external `layout` declaration, fixed neighbour data, original variable meanings, and satisfaction objective are preserved. Both `x` and `y` are retained, and the accompanying mapping script copies only these original arrays from the solution, excluding auxiliary assignment variables.

The reformulation trades a compact global-constraint model for an explicit mixed-integer formulation. Assignment equations, rank aggregation, and cumulative precedence cuts are intended to improve HiGHS processing and relaxation strength. No measured runtime improvement was established in the conversation.

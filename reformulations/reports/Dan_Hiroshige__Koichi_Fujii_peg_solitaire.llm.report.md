# Peg Solitaire: Model and Reformulation Report

## Problem background

The model represents a time-indexed peg-solitaire puzzle. In standard peg solitaire, a move jumps a peg over an adjacent peg into an empty hole; the jumping peg changes location and the jumped peg is removed. The goal is to leave as few pegs as possible.

Here, `H` identifies board holes, `I` identifies candidate moves, and `T` describes each move using an identifier and three holes: departure, jumped-over, and destination. The sets `ON` and `OFF` specify initially occupied and initially empty holes. The indexed sets `P1`, `P2`, and `P3` determine how selecting a move changes each hole’s occupancy.

The model evaluates the remaining occupancy at time 35. Although this suggests a conventional horizon from 0 through 35, the time set `M` is supplied externally. No particular board geometry, number of holes, or complete initial configuration is specified in the model file.

## Original formulation

### Variables

The model contains two families of binary variables:

- \(x_{m,h}\): whether hole \(h\) is occupied at time \(m\).
- \(y_{m,i}\): whether move \(i\) is selected at time \(m\).

Their respective counts are \(|M||H|\) and \(|M||I|\). Exact numerical counts require external data. Move variables at times not below 35 are declared but do not participate in the original constraints.

### Constraints

The formulation imposes:

1. **Initial occupancy.** Holes in `ON` have \(x_{0,h}=1\), and holes in `OFF` have \(x_{0,h}=0\). Holes in neither set are not explicitly initialized.

2. **Move prerequisites.** For each applicable tuple \((i,a,b,c)\in T\) and time \(m<35\),
   \[
   x_{m,a}+x_{m,b}+1-x_{m,c}\ge 3y_{m,i}.
   \]
   When \(y_{m,i}=1\), binary occupancy forces both departure and jumped-over holes to be occupied and the destination to be empty.

3. **Exactly one move.**
   \[
   \sum_{i\in I}y_{m,i}=1
   \qquad(m\in M,\ m<35).
   \]
   The model therefore does not permit stopping early at a constrained time.

4. **Occupancy transitions.**
   \[
   x_{m+1,h}
   =
   x_{m,h}
   -\sum_{i\in P1[h]}y_{m,i}
   -\sum_{i\in P2[h]}y_{m,i}
   +\sum_{i\in P3[h]}y_{m,i}.
   \]

### Objective

The model minimizes
\[
\sum_{h\in H}x_{35,h},
\]
the number of occupied holes at time 35.

For a conventional, consistently encoded puzzle with a fully fixed initial state, each legal move removes one peg, so a fixed move count can make the final peg count predetermined. The reformulation does **not** assume those additional data properties or replace the objective with a constant.

## Reformulation and justification

The reformulation preserves all original decision variables, their binary domains, the external data interface, the objective, initialization, and transition equations. It replaces the original move-prerequisite inequalities with stronger aggregated inequalities and adds logically implied move exclusions.

### 1. Aggregate prerequisites by hole

For each hole \(h\), the reformulation collects moves that require it occupied into a set \(A_h\), and moves that require it empty into a set \(B_h\). It imposes
\[
\sum_{i\in A_h}y_{m,i}\le x_{m,h},
\qquad
\sum_{i\in B_h}y_{m,i}\le 1-x_{m,h}.
\]

**Why this is valid.** The original prerequisite inequality forces the required occupancies whenever a move is selected. The exactly-one-move constraint ensures that each sum above is either zero or one in an integer solution. If it is one, the selected move requires precisely the occupancy asserted by the corresponding bound. Conversely, these inequalities enforce every original tuple’s prerequisites when its move is selected; when that move is not selected, its original prerequisite inequality is automatically satisfied by the occupancy bounds.

This is a **disaggregated logical-implication and mutually exclusive move aggregation** reformulation. It strengthens the LP relaxation: fractional move selections must share the available occupancy or vacancy capacity, rather than satisfying only separate three-term prerequisite inequalities.

### 2. Derive prerequisites from transition coefficients

For each hole and move, the reformulation computes
\[
d_{h,i}
=
\mathbf{1}_{i\in P3[h]}
-\mathbf{1}_{i\in P1[h]}
-\mathbf{1}_{i\in P2[h]}.
\]

Because exactly one move is selected, selecting move \(i\) makes the transition at hole \(h\)
\[
x_{m+1,h}=x_{m,h}+d_{h,i}.
\]

**Why this is valid.** Both occupancy variables are binary:

- If \(d_{h,i}=-1\), feasibility requires \(x_{m,h}=1\).
- If \(d_{h,i}=1\), feasibility requires \(x_{m,h}=0\).
- If \(d_{h,i}=-2\), no binary pair can satisfy the transition.

The first two implications are incorporated into the aggregated prerequisite sets. This is **transition-based bound propagation**. Importantly, it uses the actual `P1`, `P2`, and `P3` memberships rather than assuming they agree with `T`.

### 3. Disable provably impossible moves

A move is fixed to zero at every constrained time if:

- it has a transition coefficient of \(-2\) at any hole; or
- its combined prerequisites require the same hole to be both occupied and empty.

**Why this is valid.** The first case contradicts binary occupancy across the transition. In the second case, selecting the move would force both \(x_{m,h}=1\) and \(x_{m,h}=0\), using implications derived from the original prerequisite and transition constraints. Such a move cannot occur in any original integer feasible solution.

This is **infeasible-move preprocessing**, implemented through explicit zero-fixing constraints. It relies on model implications, not assumed board geometry or instance-specific puzzle knowledge.

## Expected effect and preservation

The changes aim to improve solution time by strengthening the LP relaxation and exposing impossible moves before search. They do not reduce the declared variable count, and their computational benefit remains instance-dependent.

The original and reformulated models have the same integer feasible assignments to the original variables and the same minimization objective. Consequently, solution reconstruction is an identity mapping. No symmetry assumptions, hard-coded instance data, or fixed peg-count assumptions are introduced.

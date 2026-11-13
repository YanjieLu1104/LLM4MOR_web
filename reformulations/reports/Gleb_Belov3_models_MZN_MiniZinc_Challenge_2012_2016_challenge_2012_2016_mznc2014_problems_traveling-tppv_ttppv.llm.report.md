# Traveling Tournament Scheduling with Predefined Venues

## Problem background

The model schedules a single round-robin tournament for \(n\) teams over \(n-1\) rounds. Each team plays exactly one opponent per round and meets every other team once. The input `pv[i,j]` specifies whether team \(i\) plays at home or away against team \(j\).

Teams are located at equally spaced positions on a circle. The distance between teams \(i\) and \(j\) is
\[
d(i,j)=\min\{|i-j|,\ n-|i-j|\}.
\]
Each team starts at home, travels between successive match locations, and returns home after its final match. The objective is to minimize total travel while preventing runs of more than three consecutive home games or three consecutive away games.

Although conventional tournament data would specify complementary home/away statuses for opposing teams, the original model does not require this consistency. The reformulation likewise does not assume it.

## Original formulation

### Variables

The original model declares:

- **Opponent variables:** \(n(n-1)\) integers, where `opponent[i,k]` identifies team \(i\)’s opponent in round \(k\).
- **Venue variables:** \(n(n-1)\) integers in \(\{1,2\}\), determined by the opponent and `pv`.
- **Travel variables:** \(n^2\) integers between zero and \(\lfloor n/2\rfloor\). These represent the initial journey, journeys between rounds, and final return home.
- **Objective variable:** the sum of all travel variables.

### Constraints and objective

The scheduling constraints exclude self-matches, require reciprocal opponents within each round, and make each team’s opponents distinct across rounds. An additional, implied all-different constraint makes the opponents within each round distinct.

A seven-state automaton limits consecutive home or away games to three. Conditional constraints determine travel from the home/away statuses and opponents in adjacent rounds. A round-reversal symmetry-breaking inequality requires the first opponent of team 1 to have a smaller index than its final opponent.

The model minimizes total travel distance. Its variable-index lookups, global constraints, and conditional travel expressions can require substantial decomposition when compiled for a mixed-integer solver such as HiGHS.

## Reformulation and justification

### 1. Linear game-assignment formulation

The reformulation introduces binary variables \(x_{ijk}\), indicating whether team \(i\) plays team \(j\) in round \(k\). Linear constraints enforce:

- \(x_{iik}=0\): no self-matches;
- \(x_{ijk}=x_{jik}\): reciprocal matches;
- \(\sum_j x_{ijk}=1\): one opponent per team and round;
- \(\sum_k x_{ijk}=1\) for \(i<j\): each unordered pair meets once.

These constraints encode the original scheduling requirements exactly. Reciprocity and one opponent per team also imply that each round’s opponent assignment is a permutation, making the original round-wise all-different constraint unnecessary.

The original opponent and venue variables remain explicitly linked to the assignments:
\[
\operatorname{opponent}_{ik}=\sum_j jx_{ijk},
\qquad
\operatorname{venue}_{ik}=\sum_j pv_{ij}x_{ijk}.
\]
Since exactly one assignment is active, these equations preserve their original meanings without variable-index lookups.

### 2. Parity preprocessing and round-cardinality constraints

A round is a collection of disjoint two-team matches: self-matches are forbidden, opponents are reciprocal, and every team participates. Therefore, a feasible instance must have an even number of teams. The reformulation explicitly rejects odd team counts.

For the same reason, each round contains exactly \(n/2\) unordered matches. This redundant linear equality is added to expose that consequence directly to the MIP solver.

### 3. Sliding-window replacement of the automaton

For every four consecutive rounds, the reformulation requires
\[
5\leq \sum_{h=k}^{k+3}\operatorname{venue}_{ih}\leq 7.
\]

Because venue values are 1 and 2, four home games would sum to 4, while four away games would sum to 8. Every mixed four-round window satisfies the inequalities.

Thus, these constraints exclude exactly the forbidden runs of four or more identical statuses. This is equivalent to the original automaton, whose states track runs of up to three games and whose nonfailure states are all accepting. If fewer than four rounds exist, neither formulation imposes a run-length restriction.

### 4. Exact circular-distance representation

The reformulation replaces conditional distance lookups with a **cut representation of the circular metric**.

For even \(n\), consider the \(n/2\) sets of consecutive \(n/2\) circular positions beginning at positions \(1,\ldots,n/2\). For any two positions \(u,v\), exactly \(d(u,v)\) of these sets contain one position but not the other. Consequently,
\[
d(u,v)=\sum_c
\left|\mathbf{1}[u\in C_c]-\mathbf{1}[v\in C_c]\right|.
\]

Binary location-membership variables identify whether each team’s match location belongs to each set. Game assignments determine that location: it is the team’s own position for a home game and its opponent’s position for an away game.

Four linear inequalities encode the absolute difference between successive binary memberships exactly. Initial and final memberships use the team’s home position. Summing these differences therefore reproduces every original travel variable—not merely a lower bound on total travel.

Using only \(n/2\) sets is sufficient because the other semicircular sets are their complements, and a set and its complement separate exactly the same pairs of positions.

### 5. Metric travel lower bounds

For each team, the reformulation adds
\[
\sum_k \operatorname{travel}_{ik}
\geq
2\max_{\substack{j\ne i\\pv_{ij}=2}}d(i,j),
\]
with a zero bound when there are no away opponents.

Every other opponent must be played once, so each location designated as away must be visited. The journey begins and ends at home. By the triangle inequality, the portion reaching any required away location has length at least its distance from home, and the remaining portion returning home has at least the same length. The inequality follows and cannot remove an originally feasible solution.

## Preservation and intended benefit

The external data interface, original decision-variable meanings, travel objective, and round-reversal constraint are retained. The mapping script copies `opponent`, `venue`, and `travel` directly; the original objective is derived from travel and needs no reconstruction.

The changes target HiGHS by replacing indirect indexing and automaton constraints with explicit linear assignment, window, and binary-difference constraints. They introduce auxiliary variables, but provide a more structured MIP formulation. The additional parity and metric deductions expose necessary conditions early; actual runtime improvements remain instance-dependent.

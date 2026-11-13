## Problem background

The model partitions players into leagues for a game or competition. Each player has a numerical ranking and a country code. The intended goals are to place similarly ranked players together while encouraging country diversity within each league.

For \(n\) players and a maximum league size \(K=\texttt{n_persons_in_league}\), the model fixes the number of leagues to
\[
L=\left\lceil n/K\right\rceil.
\]
Each league must contain between \(K-1\) and \(K\) players. This is stricter than a capacity-only rule and can make some instances infeasible.

## Original formulation

### Variables

Writing \(C=\max(\texttt{country})\), the original declarations contain:

- \(n\) integer variables `assign_to`, identifying each player’s league.
- Five arrays of \(L\) integer variables:
  - `n_persons`: league sizes;
  - `max_rank` and `min_rank`: upper and lower ranking endpoints;
  - `rank_diff`: the difference between these endpoints;
  - `card_of_league`: the number of represented positive country codes.
- A binary integer array `card_of_league_tmp`, declared over `1..L*(C+1)`.
- A bounded, derived objective variable `obj`.

When \(C\geq 0\), only the first \(LC\) entries of the country-indicator array participate in the country-count constraints. Its remaining \(L\) entries are unconstrained.

### Constraints

The original model:

1. Counts players assigned to each league and enforces the size interval \([K-1,K]\).
2. Requires each assigned player’s ranking to lie between that league’s `min_rank` and `max_rank`.
3. Defines `rank_diff = max_rank - min_rank`.
4. Makes each used country indicator true exactly when at least one player with that country code belongs to the league.
5. Sums these indicators to obtain `card_of_league`.
6. Orders leagues by nondecreasing `max_rank`.

Country counting considers only codes \(1,\ldots,C\); nonpositive codes do not contribute. Because `card_of_league` has lower bound one, every feasible league must contain at least one player with a counted country code.

The ranking endpoints are bounds, **not explicitly the actual minimum and maximum rankings**. In addition, `rank_diff` has the unusual domain
\[
\min(\texttt{ranking})\ldots\max(\texttt{ranking}),
\]
rather than a conventional nonnegative range-width domain. These details affect feasibility and were preserved.

### Objective

The model minimizes
\[
10000\sum_{\ell=1}^{L}\texttt{rank_diff}_{\ell}
-\sum_{\ell=1}^{L}\texttt{card_of_league}_{\ell},
\]
with `obj` additionally restricted to \(1,\ldots,10{,}000{,}000\).

This is a weighted trade-off favoring small ranking intervals and greater country diversity. Without further bounds on instance size, it should not be described as a strictly lexicographic objective.

## Reformulation and justification

The reformulation targets the HiGHS mixed-integer linear programming backend. It retains every original independent variable, its domain, the objective, and the external data interface.

### Explicit binary assignment formulation

A binary variable \(x_{p\ell}\) now indicates whether player \(p\) belongs to league \(\ell\). The constraints
\[
\sum_{\ell}x_{p\ell}=1,
\qquad
\texttt{assign_to}_p=\sum_{\ell}\ell x_{p\ell}
\]
provide an exact channel to the original assignment variable. League sizes become linear sums:
\[
\texttt{n_persons}_{\ell}=\sum_p x_{p\ell}.
\]

Exactly one selected league makes this representation equivalent to the original assignments and counting constraints. The redundant equality \(\sum_\ell\texttt{n_persons}_\ell=n\) follows by summing the player-assignment equations.

### Domain-based linearization of ranking implications

Let \(a=\min(\texttt{ranking})\), \(b=\max(\texttt{ranking})\), and \(r_p=\texttt{ranking}_p\). The original implications are replaced by
\[
\texttt{max_rank}_{\ell}\geq a+(r_p-a)x_{p\ell},
\]
\[
\texttt{min_rank}_{\ell}\leq b-(b-r_p)x_{p\ell}.
\]

For \(x_{p\ell}=1\), these enforce the original ranking bounds. For \(x_{p\ell}=0\), they reduce to the already declared endpoint bounds. This is an exact, domain-based big-\(M\) linearization with player-specific coefficients.

### Capacity-scaled ranking cuts

The reformulation adds
\[
\sum_p(r_p-a)x_{p\ell}
\leq K(\texttt{max_rank}_{\ell}-a),
\]
\[
\sum_p(b-r_p)x_{p\ell}
\leq K(b-\texttt{min_rank}_{\ell}).
\]

Each selected player’s term is bounded by the corresponding league-endpoint expression, and at most \(K\) players are selected. Both endpoint expressions are nonnegative by their original domains. Therefore these inequalities are valid for every original feasible assignment and can strengthen the linear relaxation.

### Incompatible-player pair cuts

If
\[
|r_p-r_q|>b,
\]
the reformulation prohibits players \(p\) and \(q\) from sharing a league:
\[
x_{p\ell}+x_{q\ell}\leq1.
\]

If both players were assigned together, the original endpoint inequalities would imply
\[
\texttt{rank_diff}_{\ell}\geq |r_p-r_q|.
\]
But the original domain imposes `rank_diff` \(\leq b\). Thus the pair is incompatible. These cuts are derived from the supplied rankings and the original width bound, not from an added ranking-distance assumption.

### Country-indicator linearization and preprocessing

For each positive country code, let \(s_{\ell c}\) count its assigned players and let \(y_{\ell c}\) be the original country indicator. The reformulation uses
\[
y_{\ell c}\leq s_{\ell c},
\qquad
s_{\ell c}\leq \min(K,f_c)y_{\ell c},
\]
together with \(x_{p\ell}\leq y_{\ell c}\) for players from country \(c\), where \(f_c\) is that country’s total player count.

These constraints enforce exactly the original existence condition: the indicator is one if and only if at least one corresponding player is assigned. The upper bound follows from both league capacity and country availability. If \(f_c=0\), preprocessing fixes the indicator to zero, as required by the original existence expression.

The additional inequality
\[
\texttt{card_of_league}_{\ell}\leq\texttt{n_persons}_{\ell}
\]
is valid because each distinct represented country requires a distinct player.

Finally, `rank_diff >= 0` is valid because the original positive country-count requirement makes every feasible league nonempty, and any assigned player implies `min_rank <= max_rank`.

## Preservation and solution mapping

The reformulation preserves the original league ordering, nonstandard ranking-width domain, objective bounds, treatment of country codes, and unconstrained indicator entries. It introduces no additional symmetry-breaking restrictions and does not force ranking endpoints to equal observed extrema.

The mapping script copies the seven original independent variable arrays unchanged and excludes auxiliary variables and the derived objective. The changes are intended to expose a stronger linear formulation to HiGHS; no measured speedup was established in the conversation.

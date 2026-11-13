# Tournament League Grouping: Model and Reformulation

## 1. Problem background

The model partitions tournament participants into groups. Each participant has an integer ranking and a country identifier. The intended goals are to form groups with similar rankings while encouraging representation from different countries.

For \(n\) participants and a nominal group capacity \(K=\texttt{n_persons_in_group}\), the model creates
\[
G=\left\lceil \frac{n}{K}\right\rceil
\]
groups. Each participant belongs to exactly one group, and every group must contain between \(K-1\) and \(K\) participants. These requirements are retained even when their combination makes an instance infeasible.

No particular instance data were supplied.

## 2. Original model structure

### Variables

The original model declares:

- \(n\) integer variables `assign_to`, identifying each participant’s group.
- Five integer summary variables per group: `n_persons`, `max_rank`, `min_rank`, `rank_diff`, and `countries_in_group`.
- Binary variables `countries_in_group_tmp` for every group and every integer country label in `1..max(country)`.
- An objective variable constrained to `1..100000`.

Only country identifiers in the declared positive-label range contribute to country diversity. The reformulation preserves this behavior rather than assuming all supplied identifiers are positive.

### Constraints

The constraints count group membership, enforce group sizes, calculate ranking statistics and country presence, and order groups by both ranking extrema:
\[
\texttt{max\_rank}[g]\leq\texttt{max\_rank}[g+1],
\qquad
\texttt{min\_rank}[g]\leq\texttt{min\_rank}[g+1].
\]
Both ordering constraints are retained; neither is assumed redundant.

The ranking expressions have important implementation-specific semantics. Writing \(x_{pg}=1\) when participant \(p\) belongs to group \(g\), the original definitions are
\[
M_g=\max_p(r_p x_{pg}),\qquad
m_g=\min_p\bigl(r_p+10000(1-x_{pg})\bigr).
\]
Consequently, nonmembers contribute **zero** to the maximum and **their ranking plus 10000** to the minimum. These expressions are not universally equivalent to ordinary extrema over group members. The reformulation preserves them exactly, without assumptions about ranking signs or ranges.

### Objective

The model minimizes
\[
100\sum_g(M_g-m_g)-\sum_g C_g,
\]
where \(C_g\) is the number of represented, counted country labels.

This is a weighted objective, not an explicitly lexicographic one. Its declared domain, `1..100000`, also restricts feasibility and is retained.

## 3. Reformulation and justification

### Binary assignment formulation

An explicit binary matrix \(x_{pg}\) replaces the internal membership tests used throughout the model:
\[
\sum_g x_{pg}=1,\qquad
\texttt{assign\_to}[p]=\sum_g g\,x_{pg}.
\]
Group sizes become column sums.

This is equivalent because every original assignment selects exactly one group. Conversely, a binary row summing to one uniquely determines the original assignment variable. Keeping `assign_to` and the other original arrays preserves their interface and allows identity solution mapping.

### Exact ranking witnesses aggregated by distinct value

Participants are grouped internally by their fixed ranking value. For each group and distinct ranking, a linear sum counts assigned participants having that ranking.

Binary witness variables then select an attained candidate for each extremum:

- The maximum selects either a ranking represented among group members or zero when at least one participant is outside the group.
- The minimum selects either a member’s ranking or a nonmember’s ranking plus 10000.

For every participant, the model also imposes
\[
M_g\geq r_p x_{pg},\qquad
m_g\leq r_p+10000(1-x_{pg}).
\]
These inequalities, together with selection of an attained candidate, force the exact original maximum and minimum.

Aggregation is valid because participants with identical rankings contribute identical candidate values. Their identities matter only for whether a member or nonmember with that ranking exists, which the aggregate counts determine. Thus, repeated rankings reduce the number of witness choices relative to participant-level witnesses.

### Domain-based witness preprocessing

Two types of impossible witnesses are fixed to zero:

- A zero maximum witness is excluded when zero lies outside the original domain `min(ranking)..max(ranking)`.
- A shifted minimum witness \(r+10000\) is excluded when it exceeds `max(ranking)`, the original upper bound on `min_rank`.

Neither exclusion removes a feasible original solution: the selected witness value must equal the corresponding extremum, whose original domain already forbids those values.

### Linear country-presence constraints

For each counted country \(c\) and group \(g\), let \(y_{gc}\) denote presence and let
\[
S_{gc}=\sum_{p:\,\texttt{country}[p]=c}x_{pg}.
\]
The formulation imposes \(x_{pg}\leq y_{gc}\) for each relevant participant and \(y_{gc}\leq S_{gc}\). With binary variables, these constraints express exactly that presence is equivalent to at least one assigned participant.

It also adds
\[
S_{gc}\leq \min(K,N_c)y_{gc},
\]
where \(N_c\) is the total number of participants from country \(c\). This is valid because a group holds at most \(K\) participants and cannot contain more than the available \(N_c\). The inequality strengthens the linear relaxation. Countries absent from the data are automatically fixed absent by \(y_{gc}\leq S_{gc}=0\).

### Valid group-level bounds

The reformulation adds
\[
C_g\leq \texttt{n\_persons}[g],
\qquad
\texttt{n\_persons}[g]\geq1.
\]
Every represented country requires a distinct participant, proving the first bound. The original domain already requires \(C_g\geq1\); together with the country-presence definitions, this proves that each group must be nonempty.

## 4. Expected computational effect and preservation

The reformulation exposes a mixed-integer linear structure suited to HiGHS, shares assignment indicators across constraints, aggregates repeated ranking values, and adds valid relaxation-strengthening inequalities. The original CP-oriented search annotation is omitted; it does not change feasibility or the objective.

All original independent decision-variable arrays remain, and the mapping script copies their values without reconstructing or renumbering entities. External data, ranking offsets, group ordering, variable domains, and objective direction are preserved. These changes aim to improve solution time, but no measured speedup is claimed without instance-level benchmarking.

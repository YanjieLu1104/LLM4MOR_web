## Background and interpretation

The model describes a multiweek staffing roster with five possible daily assignments: **Rest, Morning, Day, Evening, and Joker**. The Joker is treated as a distinct assignment category; the model gives it no special substitution rules.

For each weekday and assignment type, the input specifies how many weeks must receive that assignment. The model therefore allocates shifts across a repeating weekly structure while imposing rest requirements and penalizing undesirable shift patterns. This resembles a cyclic workforce-roster design problem, although no individual employees are explicitly represented.

An important implementation detail limits this interpretation: the original model does **not** connect the main portion of its extended sequence, `longflatroster`, to the roster. The reformulation preserves this behavior rather than correcting it to match the apparent scheduling intent.

## Original model structure

Let \(N=7\,\texttt{weeks}\). For well-defined instances, the model declares \(3N+9\) scalar integer variables before flattening:

- `roster`: \(N\) assignments arranged by week and weekday, each in \(1,\ldots,5\).
- `flatroster`: \(N\) assignments representing the same roster in chronological order.
- `longflatroster`: \(N+6\) assignments used in sliding windows and penalty expressions.
- `evemorn` and `isolated`: penalty counts, each between zero and \(N\).
- `objective`: their sum, with domain `minobj..2*N`.

### Constraints

The original formulation contains:

- **\(N\) roster-linking equalities:** each `flatroster` entry equals its corresponding `roster` entry.
- **Six extension equalities:** the last six entries of `longflatroster` equal the first six entries of `flatroster`.
- **35 exact staffing constraints:** for each of five assignment types and seven weekdays, the count across weeks equals `reqt`.
- **\(N\) minimum-rest constraints:** every seven-entry window in `longflatroster` contains at least one Rest.
- **\(N\) maximum-rest constraints:** every four-entry window in `longflatroster` contains at most three Rests.
- **Two penalty-defining equalities**, plus the objective definition.

Despite a comment describing a prohibition on three consecutive rest days, the actual maximum-rest constraint prohibits **four consecutive rest days**.

The penalty expressions also mix the two sequences:

- `evemorn` counts positions with an Evening in `flatroster` followed by a Morning in `longflatroster`.
- `isolated` counts positions where `longflatroster[d+1]` is Rest, while `flatroster[d]` and `longflatroster[d+2]` are not Rest.

Because `longflatroster[1..N]` is otherwise independent of `flatroster`, these are not necessarily conventional consecutive-day penalties on the displayed roster.

### Objective

The model minimizes
\[
\texttt{objective}=\texttt{evemorn}+\texttt{isolated}.
\]

The supplied parameter `minobj` is a hard lower bound on this sum, not merely a solver hint.

## Reformulation and justification

### One-hot assignment representation

The reformulation introduces five binary indicators for each position in both `flatroster` and `longflatroster`. At each position:

1. Exactly one indicator must equal one.
2. The original integer assignment equals the weighted sum of the indicators, using shift codes \(1,\ldots,5\).

This is an exact encoding: every original assignment selects one unique indicator, and every feasible indicator vector determines one original assignment. The original variables remain available, preserving their meanings and compatibility with external assignments and solution checking.

The six extension equalities are expressed through equality of the corresponding indicator vectors. This is equivalent to equality of their original shift values because the one-hot encoding is unique.

### Linear staffing and rest constraints

Exact staffing counts become sums of assignment indicators. Likewise, each rest-window constraint becomes a sum of Rest indicators.

These replacements are valid because each indicator is exactly one when its associated assignment has the specified shift value. Consequently, the linear sums equal the counts computed by the original `exactly`, `at_least`, and `at_most` constraints.

This exposes a direct mixed-integer linear formulation to HiGHS rather than relying on generic translation of counting predicates.

### Demand-based preprocessing

Two necessary staffing checks are made explicit:

\[
0\leq \texttt{reqt}[s,d]\leq \texttt{weeks},
\qquad
\sum_{s=1}^{5}\texttt{reqt}[s,d]=\texttt{weeks}.
\]

For a fixed weekday, there are exactly `weeks` roster entries, and each entry belongs to exactly one of the five shift categories. The original exact-count constraints therefore imply both the bounds and the total-demand equality.

The reformulation also fixes indicators in two cases:

- If demand for a shift on a weekday is zero, every corresponding indicator is zero.
- If demand equals `weeks`, every corresponding indicator is one.

These fixings follow directly from an exact sum of `weeks` binary variables. They can expose infeasibility or eliminate assignment choices before search without excluding any original feasible solution.

### Exact linear penalty indicators

Each penalty occurrence receives a binary indicator with both upper and lower linear bounds enforcing the original conjunction.

For example, if \(a\) indicates Evening and \(b\) indicates the relevant following Morning, the occurrence indicator \(z\) satisfies
\[
z\leq a,\qquad z\leq b,\qquad z\geq a+b-1.
\]
Thus \(z=1\) exactly when both conditions hold. The isolated-rest indicator uses the analogous formulation for one positive and two negated conditions.

Exactness matters here. Using only lower bounds and relying on minimization could allow artificial penalty inflation to satisfy `minobj` or externally fixed penalty values. The full formulations preserve the original penalty counts for every feasible assignment.

## Preservation and expected effect

The reformulation retains the external data interface, all original independent variables, the objective value and direction, and the original model’s unusual sequence relationships. It adds neither a missing full-sequence link nor a stricter rest rule. The mapping script copies only the original independent variables from the solver output; the defined objective is recomputed by the original model.

The intended benefit is a transparent binary linear formulation with explicit demand fixings and exact local logical formulations suitable for HiGHS. No runtime measurements were supplied, so improved solve time remains an expectation rather than an established result.

# Closed Itemset Mining for Binary Classification

## Background

This model learns a rule that distinguishes positive examples from negative examples. Each example is represented as a transaction: a set of items or features present in that example.

The learned rule is a conjunction of selected items. A transaction satisfies the rule exactly when it contains every selected item. Although the original formulation uses notation for a set of patterns, the supplied model fixes the number of patterns to `K = 1`, so it learns a single conjunction rather than a general disjunctive normal form.

The rule must also be **closed on positive examples**: it includes every item shared by all positive transactions that it covers. This is a standard closed-itemset condition and is explicitly required by the original model.

## Original Model Structure

The external data specify the number of items, the numbers of positive and negative transactions, and the item sets of those transactions.

With `K = 1`, the model declares the following Boolean variables:

- `Items`: one variable per item, indicating whether the rule requires it.
- `TransP` and `TransN`: one variable per positive or negative transaction, indicating whether the pattern covers it.
- `Trans_pos` and `Trans_neg`: another coverage variable per transaction, representing coverage by any pattern.

For nonnegative instance sizes, this gives `NrI + 2(NrT_pos + NrT_neg)` declared Boolean variables, before flattening or solver preprocessing.

The constraints impose three relationships:

1. **Exact coverage.** A transaction is covered if and only if none of its missing items is selected.
2. **Positive closure.** An item is selected if and only if no covered positive transaction lacks it.
3. **Joint coverage.** A transaction is jointly covered if and only if at least one pattern covers it.

The source also contains lexicographic ordering constraints between successive patterns. Their index range is empty when `K = 1`, so they impose no restrictions.

The objective maximizes

\[
\text{covered positive transactions}
-
\text{covered negative transactions}.
\]

This is equivalent to maximizing the number of correctly classified transactions, up to the constant number of negative transactions.

## Reformulation and Its Justification

### Missing-item preprocessing

For each transaction, the reformulation precomputes the set of modeled items absent from it. Only item indices in the original `Items` domain are considered, matching the original sums exactly.

This replaces repeated membership tests and zero-coefficient terms with sparse incidence sets. It does not alter the supplied transactions or assume anything about their contents.

### Exact linear coverage constraints

Let \(x_i\) indicate selection of item \(i\), \(y_t\) indicate coverage of transaction \(t\), and \(M_t\) be its precomputed missing-item set. The original coverage equivalence is replaced by

\[
x_i+y_t\leq 1 \qquad (i\in M_t),
\]

\[
y_t+\sum_{i\in M_t}x_i\geq 1.
\]

The first inequalities prevent coverage whenever a missing item is selected. The second forces coverage whenever no missing item is selected. Together, they are equivalent to the original Boolean condition.

If \(M_t\) is empty, the second inequality forces \(y_t=1\), as required: a transaction containing every modeled item covers any selected itemset.

These explicit linear constraints are suitable for HiGHS. In particular, the disaggregated conflict inequalities provide a stronger linear relaxation than an aggregate big-M implication, although the actual benefit depends on how the original model would otherwise be flattened.

### Closure using shared conflict inequalities

For each item \(i\), let \(A_i\) be the positive transactions that lack it. Positive closure requires

\[
x_i=1
\quad\Longleftrightarrow\quad
\sum_{t\in A_i}y_t=0.
\]

The positive-coverage conflict inequalities already enforce that selecting \(i\) excludes every transaction in \(A_i\) from coverage. Therefore, closure needs only the additional converse inequality

\[
x_i+\sum_{t\in A_i}y_t\geq 1.
\]

If no covered positive transaction lacks the item, this forces its selection. If a covered positive transaction does lack it, the shared conflict inequality forces its exclusion. Thus both directions of the original closure condition remain enforced without duplicating their common implications.

An empty \(A_i\) correctly forces \(x_i=1\), preserving the original empty-sum semantics.

### Single-pattern simplification and solution compatibility

Because `K` is fixed to one, each joint-coverage disjunction is replaced by equality with the corresponding pattern-coverage variable. The vacuous pattern-ordering constraints are omitted. These simplifications follow directly from the fixed value of `K`; they are not assumptions about future data.

All five original decision arrays remain independently declared, preserving their meanings and external binding interface. The accompanying mapping script copies only those original arrays from the solution.

The maximization objective is unchanged. The reformulation preserves the complete feasible set over the original variables, not merely an optimal objective value. Its intended performance advantage comes from sparse preprocessing, shared implications, and an explicit linear formulation; no empirical speedup was established in this interaction.

## Background and problem meaning

This model learns a binary classifier from transactions labeled positive or negative. Each transaction is a set of items or attributes. The classifier consists of **two itemsets**: a transaction is predicted positive if it contains every item in at least one of them. Equivalently, the classifier is a disjunction of two conjunctions of attributes.

The goal is to cover as many positive transactions as possible while covering as few negative transactions as possible. Each itemset must also be **closed on the positive transactions**: it contains exactly the items shared by every positive transaction it covers. This is a standard connection between closed-itemset mining and concept learning.

## Original model structure

Let \(I\) be the number of items, \(P\) the number of positive transactions, and \(N\) the number of negative transactions. With \(K=2\), the model declares \(2I+3P+3N\) Boolean decision variables:

- `Items[d,i]`: whether item \(i\) belongs to pattern \(d\).
- `TransP[d,t]` and `TransN[d,t]`: whether pattern \(d\) covers positive or negative transaction \(t\).
- `Trans_pos[t]` and `Trans_neg[t]`: whether at least one pattern covers transaction \(t\).

The constraints enforce:

1. **Exact pattern coverage.** A pattern covers a transaction if and only if it selects no item absent from that transaction.
2. **Positive closure.** An item belongs to a pattern if and only if no covered positive transaction lacks it.
3. **Strict lexicographic ordering.** Pattern 1’s positive coverage vector must precede pattern 2’s, and its negative coverage vector must also precede pattern 2’s. These are two simultaneous strict restrictions, not merely a single interchangeable-pattern ordering.
4. **Joint coverage.** Each joint coverage variable is the logical OR of the corresponding two pattern-level coverage variables.

The maximized objective is
\[
\sum_{t=1}^{P}\mathrm{Trans\_pos}[t]
-
\sum_{t=1}^{N}\mathrm{Trans\_neg}[t].
\]
Adding the constant \(N\) gives the number of correctly classified transactions, so the objective is equivalent to maximizing training accuracy.

## Reformulation and its justification

### Sparse preprocessing of absent items

For each transaction \(t\), the reformulation computes
\[
A_t=\{i\in 1..I : i\notin TDB[t]\}.
\]

The original coverage sums multiply each item variable by a fixed indicator of absence. Terms for present items are therefore always zero and can be omitted. Restricting \(A_t\) to the declared item domain preserves the original treatment of any transaction entries outside that domain.

This preprocessing changes only the internal representation; it neither modifies the data nor removes transactions or items.

### Exact linear coverage constraints

Writing \(x_{di}\) for item selection and \(y_{dt}\) for pattern coverage, the original coverage equivalence becomes
\[
x_{di}+y_{dt}\leq 1 \qquad(i\in A_t),
\]
\[
y_{dt}+\sum_{i\in A_t}x_{di}\geq 1.
\]

These inequalities are exact for Boolean variables:

- Selecting any absent item forces \(y_{dt}=0\).
- Selecting no absent item forces \(y_{dt}=1\).

If \(A_t\) is empty, the second inequality forces coverage, exactly as the original zero-sum condition does. The replacement avoids generic reification of integer sums and gives HiGHS a direct linear formulation without big-M coefficients.

### Closure using shared incompatibility inequalities

For each pattern and item, positive closure is completed by
\[
x_{di}+
\sum_{\substack{t\text{ positive}\\i\in A_t}}y_{dt}
\geq 1.
\]

The coverage inequalities already impose \(x_{di}+y_{dt}\leq1\) whenever positive transaction \(t\) lacks item \(i\). Thus:

- A covered positive transaction lacking \(i\) forces \(x_{di}=0\).
- If no such transaction is covered, the new inequality forces \(x_{di}=1\).

Together, these reproduce the original closure equivalence. Sharing the incompatibility inequalities avoids separately encoding the same implication for coverage and closure. Empty sums retain the original vacuous-closure behavior.

### Linear joint coverage

Each joint variable \(z_t\) is constrained by
\[
z_t\geq y_{dt}\quad\text{for each pattern }d,
\qquad
z_t\leq\sum_d y_{dt}.
\]
For Boolean variables, these inequalities are exactly the original OR relation.

## Preserved semantics and expected effect

Both strict lexicographic constraints, the maximization objective, the external data interface, and all five original decision-variable arrays are retained. No additional symmetry assumptions or heuristic restrictions are introduced. The CP-oriented Boolean search annotation is omitted for the HiGHS formulation; this changes search guidance, not feasibility or objective values.

The supplied mapping script copies the original variable arrays unchanged, including their encoded index domains, and reports missing values rather than inventing them.

The intended benefit is a sparse, explicit linear formulation with shared constraints and strong local Boolean relaxations. Actual runtime improvement remains instance- and solver-dependent; no benchmark results are available here.

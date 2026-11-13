## Problem background

This model learns a binary classifier from positive and negative examples represented as sets of items. An item may represent a feature present in an example. Each of the \(K\) learned patterns is a conjunction of selected items; an example matches a pattern when it contains every selected item. The classifier predicts positive when at least one pattern matches, giving a formula in **disjunctive normal form (DNF)**.

The goal is to cover as many positive examples and as few negative examples as possible. Patterns must also be **closed on the positive examples**: each pattern contains exactly the items shared by all positive examples it covers. This connects the learning problem to closed-itemset mining.

## Original model structure

Let \(k,i,p,n\) denote the cardinalities of the pattern, item, positive-example, and negative-example index sets. The model declares \(k(i+p+n)+p+n\) Boolean variables:

- `Items[d,i]`: whether pattern \(d\) selects item \(i\).
- `TransP[d,t]` and `TransN[d,t]`: whether positive or negative example \(t\) matches pattern \(d\).
- `Trans_pos[t]` and `Trans_neg[t]`: whether example \(t\) matches any pattern.

A defined integer variable, `objective`, measures
\[
\text{covered positive examples}-\text{covered negative examples}.
\]
The model maximizes this quantity. Adding the fixed number of negative examples gives the number of correctly classified examples, so the objective is equivalent to maximizing training accuracy.

The constraints enforce four properties:

1. **Exact pattern coverage.** An example matches a pattern if and only if none of the pattern’s selected items is absent from the example.
2. **Positive closure.** An item is selected if and only if no covered positive example lacks that item. If a pattern covers no positive examples, this condition forces every item to be selected.
3. **Strict ordering.** Adjacent patterns must have strictly increasing coverage vectors under lexicographic order, separately for positive and negative examples. Both conditions are retained: although described as symmetry breaking in the source, their simultaneous imposition is part of the supplied feasible-set definition.
4. **Joint coverage.** An example is covered by the classifier if and only if at least one pattern covers it.

## Reformulation and justification

### Sparse incidence preprocessing

For each example, the reformulation computes the set of modeled items absent from it. It also computes, for each item, the positive examples lacking that item.

These sets depend only on the supplied transaction data and the original item domain. They replace sums containing constant zero coefficients with sums over actual missing-item incidences. This is exact because terms associated with present items contribute zero in the original constraints. Items outside the modeled item domain remain irrelevant, as in the original model.

### Explicit linear formulation of coverage

Write \(x_{di}\) for the binary value of `Items[d,i]`, \(y_{dt}\) for a pattern-coverage variable, and \(M_t\) for the items absent from example \(t\). The original coverage equivalence becomes
\[
y_{dt}+x_{di}\le 1 \qquad(i\in M_t),
\]
\[
y_{dt}+\sum_{i\in M_t}x_{di}\ge 1.
\]

If an absent item is selected, the first inequalities force \(y_{dt}=0\). If none is selected, the second inequality forces \(y_{dt}=1\). Thus the formulation preserves both directions of the original equivalence. If \(M_t\) is empty, it correctly forces coverage.

These inequalities give the local convex hull of the Boolean relation “coverage equals the conjunction of all missing items being unselected.” They avoid generic reified zero-sum constraints and provide a strong linear relaxation for HiGHS.

### Positive closure with shared inequalities

For item \(i\), let \(A_i\) be the positive examples lacking it. Closure requires
\[
x_{di}=1 \quad\Longleftrightarrow\quad
y_{dt}=0\text{ for every }t\in A_i.
\]

Its linear formulation consists of
\[
x_{di}+y_{dt}\le 1 \qquad(t\in A_i),
\]
\[
x_{di}+\sum_{t\in A_i}y_{dt}\ge 1.
\]

The first inequalities are identical to those already imposed for positive coverage, so they are generated only once. This removes duplication, not a logical requirement. The remaining inequality forces selection precisely when no covered positive example lacks the item. Empty incidence sets are handled correctly by forcing the item to be selected.

### Explicit linear formulation of joint coverage

For a joint-coverage variable \(z_t\), the original disjunction is replaced by
\[
y_{dt}\le z_t \qquad\text{for every pattern }d,
\]
\[
z_t\le\sum_d y_{dt}.
\]

The first inequalities force joint coverage whenever any pattern matches; the second prevents coverage when none matches. With no patterns, the empty sum correctly forces \(z_t=0\). This is the local convex-hull formulation of a Boolean OR.

## Preserved semantics and expected effect

All original decision arrays, external parameter declarations, objective values, optimization direction, and both strict lexicographic ordering constraints are preserved. No patterns or examples are discarded, and no additional assumptions are introduced. The CP-specific Boolean search annotation is removed so that HiGHS can use its native MIP search.

The supplied mapping script copies the five original independent Boolean arrays unchanged; the objective remains determined by their original definition.

The intended benefits are sparse constraint generation, elimination of duplicated incompatibility inequalities, and explicit strong linear formulations in place of reified expressions. These changes target MIP solving efficiency, but no instance-specific runtime improvement has been measured.

## Problem background

The model seeks a **magic sequence**, a self-describing integer sequence of length \(n\). Its entry \(s_i\) specifies how many entries of the sequence equal \(i-1\). For example, \([1,2,1,0]\) is a magic sequence: it contains one zero, two ones, one two, and no threes.

This is a combinatorial feasibility problem, commonly useful as a constraint-solver benchmark. No specific operational application is identified in the source; its central feature is a frequency distribution that must equal the sequence describing it.

## Original model

The external input is the integer sequence length `n`. For a nonempty sequence, the model has:

- **Variables:** \(n\) integer variables \(s_i\in\{0,\ldots,n-1\}\).
- **Constraints:** one frequency equation for each position:
  \[
  s_i=\sum_{j=1}^{n}[s_j=i-1],
  \qquad i=1,\ldots,n,
  \]
  where brackets denote a Boolean condition converted to 0 or 1. The source therefore contains \(n^2\) equality tests across \(n\) counting equations.
- **Objective:** none; the solve item requests any satisfying sequence.
- **Search annotation:** assign sequence entries in index order, trying smaller values first.

The original model includes no explicit implied constraints.

## Reformulation

### Linear assignment formulation

The reformulated model retains `s` and introduces \(n^2\) binary variables \(a_{j,i}\). The intended meaning is that \(a_{j,i}=1\) exactly when \(s_j=i-1\). It imposes:
\[
\sum_{i=1}^{n}a_{j,i}=1,\qquad
s_j=\sum_{i=1}^{n}(i-1)a_{j,i},
\]
and
\[
s_i=\sum_{j=1}^{n}a_{j,i}.
\]

The first two equations select exactly one value for each sequence entry. Because the selected labels \(0,\ldots,n-1\) are distinct, they enforce the intended indicator meaning. The third equation then reproduces the original frequency constraint.

Conversely, every original solution extends to this formulation by setting \(a_{j,i}=[s_j=i-1]\). Thus the reformulation preserves all original solutions, rather than merely one representative. Its purpose is to expose the counting structure directly as linear constraints for the HiGHS mixed-integer backend.

### Problem-specific valid equations and cuts

The following consequences of the original constraints strengthen the formulation.

1. **Total frequency**
   \[
   \sum_{i=1}^{n}s_i=n.
   \]
   Every sequence entry belongs to exactly one of the permitted value categories. Summing the original frequency equations therefore counts each of the \(n\) entries once.

2. **Weighted frequency**
   \[
   \sum_{i=1}^{n}(i-1)s_i=n.
   \]
   Since \(s_i\) is the frequency of value \(i-1\), the left-hand side equals the sum of the sequence entries. The preceding identity makes that sum \(n\).

3. **Individual upper bounds**
   \[
   s_i\leq\left\lfloor\frac{n}{i-1}\right\rfloor,
   \qquad i\geq2.
   \]
   Every term in the weighted-frequency equation is nonnegative, so \((i-1)s_i\leq n\). As a preprocessing step, assignment variables selecting values above this bound are fixed to zero. These assignments cannot occur in any original solution.

4. **At least one zero in a nonempty solution**
   \[
   s_1\geq1.
   \]
   The original constraint for \(s_1\) makes it the number of zero entries. If \(s_1=0\), that entry itself is zero, contradicting a zero count of zero.

5. **Positive-value frequency bounds**
   \[
   s_i+s_1\leq n,\qquad i\geq2.
   \]
   There are exactly \(n-s_1\) nonzero entries. Occurrences of any particular positive value form a subset of these entries, so their count \(s_i\) cannot exceed \(n-s_1\).

Constraints that require a nonempty sequence are guarded accordingly. The reformulation therefore does not impose nonempty-sequence conclusions on an empty index domain.

## Interface and expected effect

The external parameter `n`, the original variable `s`, its indexing and domain, and the satisfaction objective are unchanged. The solution-mapping script copies `s` without modification and excludes the auxiliary assignment matrix.

The techniques used are **binary assignment reformulation, implied linear equations, bound tightening, and fixing impossible assignments**. They aim to improve the linear relaxation and avoid reified integer equalities in the HiGHS formulation. The assignment matrix remains quadratic in size, so this is a structural strengthening rather than an asymptotic size reduction. No measured runtime improvement was established in the conversation.

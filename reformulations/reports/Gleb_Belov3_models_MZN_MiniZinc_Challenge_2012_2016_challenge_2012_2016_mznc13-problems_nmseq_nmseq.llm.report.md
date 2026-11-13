# Magic Sequence: Model and Reformulation

## Problem background

The model seeks a **magic sequence**, also called a self-descriptive sequence. For a supplied length \(n\), the entry at position \(i\) must equal the number of entries whose value is \(i-1\).

Thus, the sequence is also its own frequency table: the first entry counts zeros, the second counts ones, and so forth. This is an abstract combinatorial consistency problem rather than a model of a specific industrial application. It serves as a benchmark for handling interconnected counting constraints.

## Original formulation

The external input is the integer parameter `n`. For positive \(n\), the model contains:

- **Variables:** \(n\) integers \(s[i]\), indexed by \(1,\ldots,n\), each in \(0,\ldots,n-1\).
- **Constraints:** \(n\) frequency equations,
  \[
  s[i]=\sum_{j=1}^{n}[s[j]=i-1],
  \qquad i=1,\ldots,n,
  \]
  where brackets denote a Boolean condition interpreted as zero or one. These equations contain \(n^2\) equality tests.
- **Objective:** None; the task is to find any satisfying sequence. The original search annotation requests input-order branching with smallest values first.

## Reformulation and its justification

### 1. Add two valid counting identities

The reformulation explicitly imposes
\[
\sum_{i=1}^{n}s[i]=n,
\qquad
\sum_{i=1}^{n}(i-1)s[i]=n.
\]

Both follow from the original constraints:

- Every sequence entry belongs to exactly one value category in \(0,\ldots,n-1\). Summing the frequency equations therefore counts all \(n\) entries exactly once, giving the first identity.
- Weighting each frequency equation by its category value gives
  \[
  \sum_i(i-1)s[i]
  =\sum_j s[j]
  =n.
  \]
  The first equality expresses the sum of the sequence through its frequency table; the second uses the first identity.

These redundant linear equalities expose global information directly to the mixed-integer solver. The implementation uses `length(s)` on the right-hand sides, preserving the original behavior when the sequence index set is empty.

### 2. Preprocess variable bounds

All terms in the weighted identity are nonnegative. Consequently, for every \(i\ge2\),
\[
(i-1)s[i]\le n,
\]
so
\[
s[i]\le U_i
=\min\!\left(n-1,\left\lfloor\frac{n}{i-1}\right\rfloor\right).
\]
For the first entry, the reformulation retains \(U_1=n-1\), since its coefficient in the weighted identity is zero.

This is problem-specific bound propagation: values above \(U_i\) cannot occur in any original solution and can safely be excluded before solving.

### 3. Replace reified equalities with sparse binary assignments

For each remaining candidate value \(v\in0,\ldots,U_i\), the reformulation introduces a binary variable \(y_{i,v}\) and imposes
\[
\sum_{v=0}^{U_i}y_{i,v}=1,
\qquad
s[i]=\sum_{v=0}^{U_i}v\,y_{i,v}.
\]

Together, these constraints ensure that exactly one value is selected and that it equals \(s[i]\). The original frequency equations become
\[
s[k]
=\sum_{\substack{i=1,\ldots,n\\k-1\le U_i}}y_{i,k-1}.
\]

This replacement is exact: each selected binary represents precisely the equality tested in the original model. Omitted assignments are impossible by the proven upper bounds, so excluding them does not alter any frequency count.

The formulation adds
\[
\sum_{i=1}^{n}(U_i+1)
\]
binary variables, which is \(O(n\log n)\), instead of representing all \(n^2\) equality tests individually. It retains the original \(n\) sequence variables and has \(3n+2\) explicit scalar linear constraints for positive \(n\), excluding variable bounds.

### 4. Preserve the interface and solution meaning

The external parameter `n`, the index domain and meaning of `s`, and the satisfaction objective remain unchanged. The CP-style search annotation is removed because the reformulation targets HiGHS with an explicit linear mixed-integer formulation.

The mapping script returns only the original sequence `s`, excluding auxiliary assignment variables. It also handles an omitted empty sequence using the original instance information.

The expected benefit is a smaller assignment encoding and stronger explicit linear structure for HiGHS. This is a formulation-based expectation, not a measured runtime result.

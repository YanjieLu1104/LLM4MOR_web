## Problem background

This model addresses **minimal-disagreement parity learning**: learning a Boolean rule from potentially noisy observations. Each observation contains a Boolean input vector and a Boolean output. The unknown rule selects a subset of input features and returns true precisely when an odd number of those selected features are true.

Such a model represents learning an XOR-based relationship in the presence of mislabeled examples. The goal is to find the feature subset that disagrees with as few observed outputs as possible, while respecting a supplied maximum number of errors. The source identifies this as an optimization variant of the minimal-disagreement parity problem studied by Crawford, Kearns, and Schapire (1994).

## Original formulation

Let \(n=\texttt{num_vars}\) and \(m=\texttt{num_samples}\). The externally supplied data consist of an \(m\times n\) Boolean input matrix, \(m\) Boolean observed outputs, and an error limit.

The model declares:

- **\(n\) Boolean selection variables**, `parity_bits`, identifying the features included in the learned rule.
- **\(m\) Boolean prediction variables**, `computed_parities`, giving the rule’s output on each sample.
- **One integer objective variable**, `num_errors`, with domain `0..max_errors`.

For each sample, an XOR constraint equates its prediction to the parity of the selected features whose input values are true. The error variable is defined as the number of predictions that differ from the observed outputs.

The objective is to **minimize `num_errors`**. Its domain also imposes the hard error limit. Four assertions check positive feature and sample counts and require the error limit to lie between zero and the number of samples. The original solve annotation specifies a Boolean search over the selection variables.

## Reformulation and justification

### Sparse linear parity equations

The reformulation replaces each XOR expression with an integer linear equation suitable for the HiGHS mixed-integer backend.

For sample \(s\), define
\[
A_s=\{v:\texttt{sample\_inputs}[s,v]=\text{true}\},
\qquad d_s=|A_s|.
\]
Writing the Boolean selection and prediction variables as binary numbers \(x_v\) and \(p_s\), respectively, the new equation is
\[
\sum_{v\in A_s}x_v=2q_s+p_s,
\qquad
0\le q_s\le\left\lfloor d_s/2\right\rfloor,
\quad q_s\in\mathbb Z.
\]

This is exactly equivalent to the original parity constraint: \(p_s\) must be the remainder of the selected-feature count modulo two. Conversely, every original feasible assignment defines an integer quotient \(q_s\) satisfying the stated bounds.

The preprocessing removes constant-false input terms because the original expression `parity_bits[v] /\ false` is always false and cannot affect an XOR. The row sizes \(d_s\) are computed solely from the supplied input matrix. An empty row correctly forces its prediction and quotient to zero.

This introduces \(m\) integer quotient variables, some of which are fixed by their bounds, while retaining all original decision variables.

### Valid parity inequalities

The reformulation adds inequalities intended to strengthen the linear relaxation without removing any feasible integer solution.

For every active feature \(v\in A_s\),
\[
x_v\le q_s+p_s.
\]
If \(x_v=1\), the selected-feature count is positive. Its decomposition as \(2q_s+p_s\) therefore implies \(q_s+p_s\ge1\). If \(x_v=0\), the inequality follows from nonnegativity.

For even \(d_s\), it adds
\[
q_s+p_s\le d_s/2.
\]
When \(p_s=0\), this follows from the quotient bound. When \(p_s=1\), the selected-feature count is odd and cannot equal the even maximum \(d_s\), so it is at most \(d_s-1\), yielding the same inequality.

For odd \(d_s\), each active feature receives
\[
q_s+p_s-x_v\le\left\lfloor d_s/2\right\rfloor.
\]
If \(x_v=1\), this follows from the quotient bound and \(p_s\le1\). If \(x_v=0\), at most \(d_s-1\) features can be selected; applying the preceding even-capacity argument gives the inequality.

These are elementary parity-valid cuts. They preserve all integer solutions but can exclude fractional assignments admitted by the basic linear equations.

### Linear disagreement objective

For an observed output of false, the disagreement indicator is \(p_s\); for an observed output of true, it is \(1-p_s\). The reformulation uses these affine expressions directly in the objective definition.

This preserves the exact error count, its upper bound, and the minimization direction while avoiding Boolean disequality expressions.

## Interface and expected effect

The external data interface, original variables, validation assertions, and output meaning remain unchanged. The original Boolean search annotation is omitted, leaving branching to the MIP backend. The mapping script copies the original independent arrays, `parity_bits` and `computed_parities`, and excludes auxiliary quotients; the original model recomputes its defined `num_errors` variable.

The intended performance benefit comes from sparse linear parity constraints, tight quotient bounds, and valid inequalities that strengthen the relaxation. No instance-specific assumptions or symmetry restrictions are introduced, and no runtime improvement is claimed without benchmarking.

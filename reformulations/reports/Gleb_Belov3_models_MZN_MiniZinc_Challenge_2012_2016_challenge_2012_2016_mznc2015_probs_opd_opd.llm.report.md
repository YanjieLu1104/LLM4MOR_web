## Background and interpretation

The model represents an **Overlap Minimization Design (OPD)** problem, motivated by the design of collateralised debt obligations squared (CDO²). In this interpretation, rows represent portfolios or structured products, columns represent available underlying assets, and a binary entry indicates whether a product includes an asset.

Each of the \(v\) products must contain exactly \(r\) of the \(b\) assets. The goal is to minimize the largest number of shared assets between any two products. Reducing this worst-case overlap promotes diversification, although the model does not explicitly represent asset returns, default probabilities, or financial losses.

The source cites Flener, Pearson, Reyna, and Sivertsson, *Design of Financial CDO Squared Transactions Using Constraint Programming*, Constraints 12(2), 2007.

## Original model

### Variables and objective

The model contains:

- \(vb\) binary variables \(m_{ij}\), indicating asset membership.
- One integer variable, `objective`, representing an upper bound on every pairwise overlap.

It minimizes `objective`, whose original domain is `lb_lambda..b`.

### Constraints

Each row has exactly \(r\) selected entries:
\[
\sum_{j=1}^{b}m_{ij}=r \qquad (i=1,\ldots,v).
\]

For each of the \(\binom{v}{2}\) distinct row pairs, the shared-asset count is bounded by the objective:
\[
\sum_{j=1}^{b}m_{ij}m_{kj}\le \texttt{objective}
\qquad (i<k).
\]

The original model also imposes nonincreasing lexicographic order on adjacent rows and adjacent columns. These constraints reduce equivalent representations arising from row and column permutations.

### Existing objective lower bound

Let \(s_j=\sum_i m_{ij}\) be the number of products containing asset \(j\). The row-sum constraints imply
\[
\sum_j s_j=rv.
\]
The sum of all pairwise overlaps is
\[
\sum_j \binom{s_j}{2}.
\]

For a fixed total \(rv\), this expression is minimized when the column counts differ by at most one. Indeed, moving one unit from a count \(a\) to a count \(c\), where \(a\ge c+2\), decreases the expression by \(a-c-1>0\).

Writing \(q=\lfloor rv/b\rfloor\) and \(t=rv\bmod b\), the resulting minimum is
\[
L=(b-t)\binom q2+t\binom{q+1}{2}.
\]
Consequently, the largest pairwise overlap is at least
\[
\left\lceil\frac{L}{\binom v2}\right\rceil.
\]
This is the original model’s `lb_lambda`, with `num` equal to \(2L\).

## Reformulation and justification

### Exact linearization of binary products

For the HiGHS mixed-integer linear backend, each product \(m_{ij}m_{kj}\) was replaced by a continuous variable \(y_{ikj}\in[0,1]\), with
\[
y_{ikj}\ge m_{ij}+m_{kj}-1,\qquad
y_{ikj}\le m_{ij},\qquad
y_{ikj}\le m_{kj}.
\]

These inequalities are exact because the original matrix entries are binary: either entry being zero forces \(y_{ikj}=0\), while both being one forces \(y_{ikj}=1\). Thus the original overlap constraint becomes the linear inequality
\[
\sum_j y_{ikj}\le \texttt{objective}.
\]

This introduces \(b\binom v2\) continuous variables and three linking inequalities per variable, without introducing additional integer overlap variables. It provides an explicit MILP formulation; actual performance gains remain instance-dependent.

### Column-wise convexity cuts

For every column and every integer \(h=1,\ldots,v-1\), the reformulation adds
\[
\sum_{i<k}y_{ikj}
\ge
h\sum_i m_{ij}-\frac{h(h+1)}2.
\]

To see validity, let \(s=\sum_i m_{ij}\). Exact linearization gives
\[
\sum_{i<k}y_{ikj}=\binom s2.
\]
The difference between this quantity and the cut’s right-hand side is
\[
\frac{(s-h)(s-h-1)}2\ge0
\]
for every integer \(s\). These inequalities therefore preserve every original feasible integer solution while potentially excluding fractional solutions in the linear relaxation.

### Aggregate counting cut

The reformulation also adds
\[
\sum_{i<k}\sum_j y_{ikj}\ge L.
\]

This follows directly from the fixed row sums and the balanced-column counting argument used for the original lower bound. It does **not** require column counts to be balanced; it only enforces the minimum total overlap that any feasible matrix must have.

Although the original objective domain already uses this argument, explicitly constraining the auxiliary overlap variables can strengthen the relaxation.

## Preservation and solution interface

All original external parameters, derived constants, matrix variables, objective bounds, and lexicographic constraints were retained. No instance-specific preprocessing or additional data assumptions were introduced.

The original CP search annotations were omitted in favor of HiGHS’s native search; this does not change feasibility or the objective. The mapping script copies only `m` and `objective` from the solver output, preserving their original encodings and excluding auxiliary variables. No reconstruction of eliminated original variables is necessary.

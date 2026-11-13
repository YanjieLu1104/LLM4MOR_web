# Radiation Treatment Planning: Model and Reformulation

## 1. Background and interpretation

The model represents a radiation-delivery decomposition problem. A prescribed integer intensity matrix specifies how much radiation each cell of a rectangular treatment grid should receive. The aim is to reproduce this matrix using a collection of beam shapes, each applied for a positive integer duration.

The row constraints indicate that each shape may expose a contiguous interval within each row, possibly leaving a row empty. This is consistent with a simplified multileaf-collimator model. No additional physical restrictions, such as interactions between adjacent rows, appear in the supplied formulation.

The optimization prioritizes minimizing total beam-on time and, secondarily, minimizing the number of shapes.

## 2. Original formulation

Let \(m\) and \(n\) be the numbers of rows and columns, and let \(B=|BTimes|\). The candidate durations are the positive integers through the largest prescribed intensity.

### Variables

The independent variables are:

- **`Beamtime`**: total beam-on time, bounded by the sum of prescribed intensities.
- **`K`**: total number of shapes, bounded by \(mn\).
- **`N[b]`**: number of shapes with duration \(b\), bounded by \(mn\).
- **`Q[i,j,b]`**: number of duration-\(b\) shapes exposing cell \((i,j)\), also bounded by \(mn\).

There are \(2+B+mnB\) independent integer variables, plus the derived objective variable.

### Constraints

Two equations define total beam time and shape count:
\[
\mathrm{Beamtime}=\sum_b bN_b,
\qquad
K=\sum_b N_b.
\]

There are \(mn\) intensity-matching equations:
\[
I_{ij}=\sum_b bQ_{ijb}.
\]

For every row and duration, the model imposes:
\[
N_b\ge Q_{i1b}
+\sum_{j=2}^{n}\max(Q_{ijb}-Q_{i,j-1,b},0).
\]

The right-hand side counts the interval starts needed to realize the row’s exposure multiplicities. The first cell requires \(Q_{i1b}\) intervals; each subsequent increase requires additional intervals to start. Thus, these \(mB\) constraints ensure that each row can be represented using at most \(N_b\) duration-\(b\) intervals. Intervals from different rows can be assigned to the same shapes because the model imposes no further coupling between rows.

### Objective

The model minimizes
\[
(mn+1)\,\mathrm{Beamtime}+K.
\]

Since both quantities are integers and \(0\le K\le mn\), one unit of beam-time improvement outweighs every possible change in shape count. This is exactly lexicographic minimization of \((\mathrm{Beamtime},K)\).

## 3. Reformulation and justification

### Exact linearization of positive increments

The variable-dependent `max` expressions were replaced with continuous auxiliary variables \(s_{ijb}\), for \(j>1\), satisfying:
\[
s_{ijb}\ge0,\qquad
s_{ijb}\ge Q_{ijb}-Q_{i,j-1,b},
\qquad
s_{ijb}\le Q_{ijb}.
\]

The row constraint becomes:
\[
N_b\ge Q_{i1b}+\sum_{j=2}^{n}s_{ijb}.
\]

This is an **exact extended linear formulation**, not a relaxation:

- Any feasible reformulated solution satisfies
  \(s_{ijb}\ge\max(Q_{ijb}-Q_{i,j-1,b},0)\), so it satisfies the original row constraint.
- Conversely, any original feasible solution extends to the reformulation by setting each auxiliary to that positive increment. The upper bound \(s_{ijb}\le Q_{ijb}\) holds because the preceding exposure count is nonnegative.

The auxiliaries need not be integer. Their purpose is to represent an upper-bound epigraph, and the exact positive increments provide a feasible extension of every original solution. This removes the need for binary variables associated with a generic exact-`max` encoding.

### Intensity-derived exposure bounds

The reformulation adds:
\[
Q_{ijb}\le\left\lfloor\frac{I_{ij}}{b}\right\rfloor.
\]

Each intensity equation is a sum of nonnegative terms, so \(bQ_{ijb}\le I_{ij}\). Since \(b>0\) and \(Q_{ijb}\) is integer, the bound follows directly. In particular, it fixes \(Q_{ijb}=0\) whenever a cell’s intensity is less than \(b\).

These are **data-derived bound tightenings** that can support solver presolve without changing the input data.

### Exposure-to-shape linking inequalities

The model also adds:
\[
Q_{ijb}\le N_b.
\]

To justify this, any value in a nonnegative row sequence is at most its initial value plus all positive increments. The original row constraint bounds that latter quantity by \(N_b\). Thus, these inequalities are redundant but valid, and expose useful links directly to the linear solver.

### Row-variation lower bounds

For each row, the reformulation precomputes:
\[
R_i=I_{i1}+\sum_{j=2}^{n}\max(I_{ij}-I_{i,j-1},0)
\]
and adds:
\[
\mathrm{Beamtime}\ge R_i.
\]

This follows from intensity matching and the inequality
\[
\max\!\left(\sum_b b\,d_b,0\right)
\le\sum_b b\max(d_b,0),
\]
valid for positive \(b\). Applying it to adjacent exposure differences yields:
\[
R_i
\le
\sum_b b\left(
Q_{i1b}+\sum_{j=2}^{n}\max(Q_{ijb}-Q_{i,j-1,b},0)
\right)
\le\sum_b bN_b.
\]

When `Bt_max` is positive, the formulation additionally imposes:
\[
K\ge\left\lceil\frac{R_i}{\mathrm{Bt\_max}}\right\rceil.
\]
This follows because
\[
R_i\le\mathrm{Beamtime}\le\mathrm{Bt\_max}\,K.
\]
The division is guarded when the maximum intensity is zero.

These are **problem-specific valid inequalities**, computed from prescribed row variation.

## 4. Interface and expected effect

All original external parameters, independent decision variables, bounds, and objective semantics are retained. The supplied mapping copies `Beamtime`, `K`, `N`, and `Q` unchanged, including their encoded array indices, and excludes the new auxiliaries.

The CP-style search annotation was removed to leave search decisions to the HiGHS MIP backend. The principal expected benefit is a direct linear formulation without unnecessary discrete machinery for `max`, supplemented by explicit bounds and valid inequalities. No instance-specific runtime measurements were supplied, so a speedup is intended rather than empirically established.

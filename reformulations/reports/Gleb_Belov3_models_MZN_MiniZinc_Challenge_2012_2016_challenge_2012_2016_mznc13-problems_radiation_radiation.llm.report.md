# Radiation Treatment Planning: Model and Reformulation

## Background

The model represents a radiation-intensity decomposition problem, consistent with delivering an intensity-modulated radiotherapy plan. The input is an \(m\times n\) matrix `Intensity`, describing the prescribed exposure at each cell.

The intended delivery uses aperture shapes with contiguous exposed intervals within each row. Each shape is applied for a positive integer beam-on duration. The model groups shapes by duration rather than representing every shape individually, and seeks to minimize total delivery time, then the number of shapes.

## Original Model

Let \(B=\texttt{BTimes}=\{1,\ldots,\texttt{Bt_max}\}\), where `Bt_max` is the largest prescribed intensity. The independent decision variables are:

- **`N[b]`**: number of shapes delivered for duration \(b\).
- **`Q[i,j,b]`**: number of those shapes exposing cell \((i,j)\).
- **`Beamtime`**: total beam-on time.
- **`K`**: total number of shapes.

There are \(mn|B|+|B|+2\) independent integer variables, plus a defined objective variable. Both `N` and `Q`, and the aggregate `K`, have upper bound \(mn\). `Beamtime` is bounded by the sum of prescribed intensities.

The constraints enforce:

1. **Aggregate delivery quantities**
   \[
   \texttt{Beamtime}=\sum_{b\in B}bN_b,
   \qquad
   K=\sum_{b\in B}N_b.
   \]

2. **Exact intensity delivery**
   \[
   I_{ij}=\sum_{b\in B}bQ_{ijb}
   \qquad\text{for every cell }(i,j).
   \]

3. **Row-contiguous shape compatibility**
   \[
   N_b\ge Q_{i1b}
   +\sum_{j=2}^{n}\max(Q_{ijb}-Q_{i,j-1,b},0).
   \]
   The right-hand side counts the interval starts needed to realize a row’s exposure-count profile. The initial count requires that many intervals at the first column, and each subsequent increase requires additional intervals to begin. Bounding this quantity by \(N_b\) makes the row compatible with the available shapes of duration \(b\).

The model minimizes
\[
(mn+1)\,\texttt{Beamtime}+K.
\]
Since \(0\le K\le mn\) and beam-on time is integral, this is exactly lexicographic minimization of beam-on time followed by shape count.

## Reformulation and Validity

### Exact linear formulation of positive increments

For every row and duration, each positive-part term is replaced by a continuous auxiliary \(S_{ijb}\), for \(j\ge2\), satisfying
\[
S_{ijb}\ge0,\qquad
S_{ijb}\ge Q_{ijb}-Q_{i,j-1,b}.
\]
The row constraint becomes
\[
N_b\ge Q_{i1b}+\sum_{j=2}^{n}S_{ijb}.
\]

This replacement is exact when projected onto the original variables:

- Every reformulated solution satisfies the original constraint because each auxiliary is at least the corresponding positive part.
- Every original feasible solution extends to the reformulation by setting
  \[
  S_{ijb}=\max(Q_{ijb}-Q_{i,j-1,b},0).
  \]

The auxiliary upper bound \(mn\) is valid because both exposure counts lie between \(0\) and \(mn\). Continuous auxiliaries suffice; no integrality condition is needed for this equivalence. This gives HiGHS a direct linear formulation and avoids the binary variables that a generic exact representation of `max` may introduce.

### Redundant exposure bounds

Two valid bounds are added:
\[
Q_{ijb}\le N_b,
\qquad
Q_{ijb}\le\left\lfloor\frac{I_{ij}}{b}\right\rfloor.
\]

The first follows from the original row constraint: the initial exposure count plus all positive increases is at least the exposure count at any column.

The second follows from the intensity equation. All terms \(bQ_{ijb}\) are nonnegative, so no individual term can exceed \(I_{ij}\); division by positive \(b\), followed by integrality, gives the bound.

These inequalities expose implied restrictions directly to the solver. In particular, the second fixes an exposure variable to zero whenever a nonnegative prescribed intensity is smaller than its associated duration.

### Precomputed row-variation lower bounds

For each row, the reformulation adds
\[
\texttt{Beamtime}\ge
I_{i1}+\sum_{j=2}^{n}\max(I_{ij}-I_{i,j-1},0).
\]

To derive this, multiply each original row constraint by its duration \(b\), then sum over durations. The initial terms sum to \(I_{i1}\). For each subsequent column, the intensity equations imply
\[
I_{ij}-I_{i,j-1}
=\sum_b b(Q_{ijb}-Q_{i,j-1,b}).
\]
Since the positive part of a sum is no greater than the sum of its positive parts, the weighted exposure increases dominate the positive intensity increase. The aggregate beam-time equation then gives the stated inequality.

Its right-hand side depends only on the input matrix, so it is computed during model instantiation. These redundant lower bounds can strengthen the linear relaxation.

### Solver interface and solution mapping

The finite-domain search annotation was removed so that HiGHS can use its native mixed-integer optimization strategy. This does not change feasibility or the objective.

All original data declarations, independent decision variables, and objective semantics were retained. The supplied mapping script therefore copies `Beamtime`, `K`, `N`, and `Q`, including their array index encodings, and excludes reformulation auxiliaries. No reconstruction or instance-specific assumptions are required.

Overall, the changes target a smaller and more explicit linear formulation with stronger bounds. Their runtime benefit remains instance-dependent; no benchmark results were supplied.

## Background and interpretation

The model represents a radiation-treatment delivery problem. An integer matrix `Intensity[i,j]` specifies the required radiation exposure at each cell of an \(m\times n\) grid. Treatment is delivered through aperture shapes, each applied for a positive integer beam-on duration.

The row constraints indicate that a shape exposes a contiguous interval in each row, possibly empty. The model does not explicitly construct these shapes. Instead, it counts how many shapes of each duration expose each cell and imposes conditions ensuring that these counts can be decomposed into row intervals. No additional compatibility constraints between different rows are represented.

The goal is to minimize total beam-on time, with the number of shapes as a secondary criterion.

## Original formulation

Let \(B=\{1,\ldots,\texttt{Bt\_max}\}\), where `Bt_max` is the maximum required cell intensity.

### Variables

The independent integer decision variables are:

- `Beamtime`: total beam-on time, bounded by the sum of all intensities.
- `K`: total number of shapes, bounded by \(mn\).
- `N[b]`: number of shapes delivered for duration \(b\), bounded by \(mn\).
- `Q[i,j,b]`: number of duration-\(b\) shapes exposing cell \((i,j)\), bounded by \(mn\).

There are \(2+|B|+mn|B|\) independent scalar variables, plus a defined objective variable.

### Constraints

Two equalities link the aggregate quantities:
\[
\texttt{Beamtime}=\sum_{b\in B}bN_b,
\qquad
K=\sum_{b\in B}N_b.
\]

Each of the \(mn\) cells must receive exactly its prescribed intensity:
\[
I_{ij}=\sum_{b\in B}bQ_{ijb}.
\]

For each row \(i\) and duration \(b\), the model requires
\[
Q_{i1b}+\sum_{j=2}^{n}\max(Q_{ijb}-Q_{i,j-1,b},0)\le N_b.
\]
The left-hand side counts the minimum number of intervals needed to realize that row’s exposure counts: intervals must start at the first column and wherever the count increases. Thus, the available \(N_b\) shapes must accommodate all required interval starts.

### Objective

The model minimizes
\[
(mn+1)\,\texttt{Beamtime}+K.
\]
Since \(0\le K\le mn\) and beam time is integer, reducing beam time by one outweighs every possible increase in \(K\). The objective therefore implements lexicographic minimization of beam time, then shape count.

## Reformulation and justification

### Exact linear extended formulation

Each decision-dependent positive-part expression was replaced by a nonnegative continuous variable \(r_{ijb}\), for \(j\ge2\), with
\[
r_{ijb}\ge Q_{ijb}-Q_{i,j-1,b},
\qquad
Q_{i1b}+\sum_{j=2}^{n}r_{ijb}\le N_b.
\]

This replacement is exact when projected onto the original variables:

- Any feasible original solution extends to the new model by choosing
  \[
  r_{ijb}=\max(Q_{ijb}-Q_{i,j-1,b},0).
  \]
- Conversely, nonnegativity and the difference inequality force each \(r_{ijb}\) to be at least that positive part. The new budget constraint therefore implies the original row constraint.

The reformulation also imposes \(r_{ijb}\le Q_{ijb}\). This does not exclude original solutions because nonnegative exposure counts imply
\[
\max(Q_{ijb}-Q_{i,j-1,b},0)\le Q_{ijb}.
\]

Continuous auxiliary variables suffice: their exact values need not be integer to establish these implications. This formulation avoids requiring binary variables to represent equality with a `max` expression and is suitable for the HiGHS mixed-integer linear backend.

### Explicit implied bounds

Three families of redundant inequalities were added:

- **Exposure count bounded by available shapes:** \(Q_{ijb}\le N_b\).  
  Any entry in a nonnegative row is bounded by its first entry plus all preceding positive increments. The original row constraint bounds that quantity by \(N_b\).

- **Cell-based count bounds:**  
  \[
  Q_{ijb}\le\left\lfloor I_{ij}/b\right\rfloor.
  \]
  The cell-intensity equality is a sum of nonnegative terms, so \(bQ_{ijb}\le I_{ij}\).

- **Duration-based shape-count bounds:**  
  \[
  N_b\le\left\lfloor\texttt{Ints\_sum}/b\right\rfloor.
  \]
  The beam-time equality gives \(bN_b\le\texttt{Beamtime}\), and the original beam-time domain supplies the upper bound `Ints_sum`.

These bounds expose consequences of the original constraints directly to presolve and relaxation processing.

### Row-complexity lower bounds

For every row, the following valid inequality was added:
\[
\texttt{Beamtime}\ge
I_{i1}+\sum_{j=2}^{n}\max(I_{ij}-I_{i,j-1},0).
\]

To derive it, multiply each duration-specific row constraint by \(b\) and sum over durations. The cell equalities identify the weighted initial counts with \(I_{i1}\). For successive differences, use
\[
\max\!\left(\sum_b b\,d_b,0\right)
\le \sum_b b\max(d_b,0),
\]
which holds because all durations are positive. The resulting row complexity cannot exceed total beam time.

These problem-specific cuts depend only on the supplied intensity matrix. They make a useful lower bound explicit, although they are already implied by the extended formulation and need not improve its theoretical LP bound.

## Preservation and expected effect

All original data declarations, independent decision variables, objective values, and optimization direction were retained. No instance-specific assumptions or hard-coded data were introduced. The solution-mapping script copies the four original independent variables and excludes the auxiliary increments.

The main computational change is replacing piecewise-linear decision expressions with a direct linear formulation. The additional bounds and row cuts may assist presolve and bound propagation. Actual speed improvements remain instance-dependent; no runtime comparison was established here.

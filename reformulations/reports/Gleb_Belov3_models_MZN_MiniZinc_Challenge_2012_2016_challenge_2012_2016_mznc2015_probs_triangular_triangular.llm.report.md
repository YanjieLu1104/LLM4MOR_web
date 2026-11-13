## Problem background

This model represents a geometric placement puzzle on an equilateral triangular lattice with \(n\) nodes along each side. A “heart” is a marker placed on a lattice node. The aim is to place as many markers as possible without selecting all three corners of any equilateral triangle, regardless of its size or orientation.

The problem is therefore a maximum-cardinality selection problem with forbidden triples, rather than a model of a physical heart-placement application.

## Original model

### Variables and grid representation

The model declares an \(n\times n\) array of binary variables, `heart[i,j]`. A value of 1 indicates that the corresponding node is selected.

Only positions satisfying \(1\le j\le i\le n\) belong to the triangular grid. For positive \(n\):

- There are \(n(n+1)/2\) usable grid positions.
- The remaining \(n(n-1)/2\) array entries are explicitly fixed to zero.

The variable `objective` is defined as the sum of the binary variables over the usable positions. Its declared domain is `1..n*n`, so the original formulation also requires at least one selected node.

### Constraints and objective

For every permitted combination of \(i,j,k,m\), the model imposes
\[
h_{i+m,j}+h_{i+k,j+m}+h_{i+k-m,j+k-m}\le 2.
\]
These three positions form an equilateral triangle. The parameter ranges enumerate triangles at different locations, scales, and orientations. For positive \(n\), this generates \(\binom{n+2}{4}\) triangle inequalities.

The objective is to **maximize the total number of selected nodes**. The model also supplies a search annotation that considers usable positions in input order and tries value 1 first.

## Reformulation and its justification

### Seven-node hexagon cuts

The reformulation retains every original variable and constraint and adds valid inequalities for regular hexagons contained in the grid. Each inequality covers a hexagon’s six vertices and its center:
\[
h_{\mathrm{center}}+\sum_{v\in\mathrm{vertices}}h_v\le 4.
\]

This bound follows directly from the original triangle constraints and binary variable domains:

- **If the center is selected**, the center and any two adjacent hexagon vertices form an equilateral triangle. Consequently, adjacent vertices cannot both be selected. At most three vertices can be selected around the six-vertex cycle, giving at most four selected nodes including the center.
- **If the center is not selected**, the alternating vertices form two disjoint equilateral triangles. Each triangle permits at most two selected vertices, again giving at most four selected nodes.

Thus, the new inequalities exclude no feasible integer solution. They can nevertheless strengthen the linear relaxation: assigning \(2/3\) to every usable grid variable satisfies all original triangle inequalities, but gives \(14/3>4\) on any included seven-node configuration. This illustrates information that the cuts make available before integrality is enforced.

### Geometry-based cut generation

The added constraints enumerate scaled and rotated lattice hexagons. For a center at `(row,col)`, the radius is bounded by
\[
\min\{\mathrm{col}-1,\ \mathrm{row}-\mathrm{col},\ n-\mathrm{row}\}.
\]
These bounds ensure that all six generated vertices remain inside the triangular grid and all array references are valid. The construction uses only the original instance parameter; it requires no additional input data.

This is **problem-specific valid-inequality strengthening**, not variable elimination or symmetry breaking. No original constraints are dropped, and no instance-specific assumptions are introduced. The intended benefit for HiGHS is a tighter mixed-integer linear relaxation, although additional constraints also increase model size and do not guarantee faster solving on every instance.

### Interface and solution mapping

The original data interface, objective definition, maximization direction, and search annotation are preserved. The mapping script copies `heart` unchanged, retaining its array indices and node correspondences. It does not reconstruct `objective`, because the original model already defines that quantity as the sum of the usable `heart` entries.

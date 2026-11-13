## Problem background

The supplied **Ghoulomb** model is a deliberately challenging variant of the Golomb ruler problem. A Golomb ruler places integer marks along a line so that every pair of marks has a different separation. Such constructions are relevant to applications requiring unambiguous pairwise spacings, including antenna placement and experimental design.

This instance constructs three independent rulers with externally supplied numbers of marks, `m1`, `m2`, and `m3`. Only the length of the second ruler is minimized; the other two must merely be feasible. The model comments identify these extra rulers and the indirect encoding of distinct distances as intentional sources of computational difficulty.

## Original formulation

For each ruler with \(m\) marks, the model declares:

- \(m\) independent integer mark variables in \(0,\ldots,m^2\);
- \(\binom{m}{2}\) derived distance expressions, one for each pair of marks.

Thus, across the three rulers, there are \(m_1+m_2+m_3\) independent mark variables and \(\sum_{r=1}^{3}\binom{m_r}{2}\) derived distances.

The constraints require:

1. **A fixed origin:** the first mark is zero.
2. **Increasing marks:** consecutive marks are strictly increasing.
3. **Distinct distances:** all pairwise separations differ.
4. **An orientation restriction:** the first consecutive gap is smaller than the final consecutive gap. This is the original reflection-symmetry constraint and is retained unchanged.

Distance distinctness is originally expressed through a cumulative scheduling constraint. Each distance becomes the start time of a unit-duration task using 11 units of a resource with capacity 15. Two tasks cannot overlap because \(11+11>15\). Since start times are integers and durations are one, non-overlap is exactly equivalent to distinct start times.

The objective is to **minimize `mark2[m2]`**, the second ruler’s length. The original search annotation visits the first ruler’s marks, then the second’s, then the third’s.

## Reformulation and justification

### Replace scheduling with selected distance disequalities

The reformulation removes the cumulative encoding from the ruler constraints and directly requires unequal lengths for pairs of disjoint mark intervals, including intervals sharing an endpoint. This is a structural reformulation intended to avoid unnecessary scheduling machinery in the HiGHS backend.

These selected comparisons suffice to enforce distinctness of **all** distances:

- If one interval properly contains another, its length is strictly greater because the marks are strictly increasing.
- For crossing intervals with endpoints \(a<c<b<d\), equality
  \[
  x_b-x_a=x_d-x_c
  \]
  is equivalent to
  \[
  x_c-x_a=x_d-x_b.
  \]
  The latter compares the two disjoint outer intervals, whose equality is explicitly prohibited.
- Disjoint intervals are compared directly.

Consequently, no necessary distance-distinctness restriction is dropped. For a ruler with \(m\) marks, the selected formulation contains \(\binom{m}{3}+\binom{m}{4}\) explicit disequalities.

### Add consecutive-block counting cuts

Consider a consecutive block of \(k+1\) marks. Its
\[
q=\frac{k(k+1)}{2}
\]
pairwise distances are distinct positive integers, by the original increasing-mark and distance-distinctness constraints.

Two valid consequences are added:

- **Span bound:** the block’s span is at least \(q\), because all \(q\) distinct positive distances lie between one and that span.
- **Distance-sum bound:** the sum of the block’s distances is at least
  \[
  1+2+\cdots+q=\frac{q(q+1)}{2}.
  \]

The distance sum is expressed directly as a weighted linear sum of the marks. These are problem-specific counting cuts: they strengthen the formulation without introducing additional decision variables or excluding feasible rulers.

### Tighten individual distance bounds

The span argument gives a lower bound for every distance \(x_b-x_a\):
\[
x_b-x_a\geq \frac{(b-a)(b-a+1)}{2}.
\]

An upper bound follows by applying the same argument to the prefix ending at \(a\) and the suffix beginning at \(b\). Their minimum spans must fit alongside \(x_b-x_a\) within the original maximum ruler length \(m^2\). Hence,
\[
x_b-x_a\leq
m^2-\frac{(a-1)a}{2}
-\frac{(m-b)(m-b+1)}{2}.
\]

These are analytical bounds derived from the original constraints, not assumptions about particular instance data.

### Preserve the interface and solution correspondence

All three original mark arrays, their domains, the external parameters, and the objective direction are retained. Neither auxiliary ruler is fixed or removed. The original sequential search annotation is omitted, leaving HiGHS to control its search.

The supplied mapping script copies `mark1`, `mark2`, and `mark3` unchanged, preserving their index encodings. Distances and the objective need no reconstruction because they are already defined from those marks in the original model.

No external instance data were available, so the reformulation uses no instance-specific preprocessing, and its performance benefit has not been measured.

## Problem background

This model represents the **CELAR radio-link frequency assignment problem**. Each communication link must receive a frequency from a specified, potentially nonconsecutive set of integers.

Pairs of links have two kinds of requirements:

- **Hard separation requirements:** their frequencies must differ by exactly a specified amount.
- **Soft interference requirements:** their frequencies should differ by more than a specified threshold. Assignments within that threshold incur a weighted penalty.

The objective is to minimize the total weighted violation cost while satisfying all hard requirements. Mobility costs are not included. Although the application describes penalties, the model accepts arbitrary integer weights; the reformulation therefore also preserves negative-weight behavior.

## Original formulation

Let \(n\), \(H\), and \(S\) denote `num_variables`, `num_hardconstraints`, and `num_softconstraints`.

### Variables and domains

The model declares:

- \(n\) integer frequency variables \(f_i\), each bounded by `min_freq` and `max_freq`;
- one integer variable, `objective`, representing the total cost.

Each \(f_i\) must additionally belong to `categories[domains[i]]`. Thus its effective domain is the intersection of its category set with the global frequency bounds.

### Constraints and objective

There are \(n\) domain-membership conditions and \(H\) hard equalities:
\[
|f_{x_h}-f_{y_h}|=k_h.
\]

The objective is defined by
\[
\text{objective}
=
\sum_{s=1}^{S}
c_s\,\mathbf{1}\!\left[|f_{x_s}-f_{y_s}|\le k_s\right],
\qquad
c_s=\text{costs}[\text{softctrw}[s]],
\]
and is minimized.

Its declared bounds are the sum of the negative weight contributions and the sum of the positive weight contributions, respectively. These are valid because every violation indicator is either zero or one.

The original search annotation prioritizes frequency assignments before the objective. No concrete instance sizes or numerical domains were supplied.

## Reformulation and justification

### 1. Domain intersection and hard-constraint support filtering

The reformulation first computes each link’s effective domain:
\[
D_i=\text{categories}[\text{domains}[i]]
\cap[\text{min\_freq},\text{max\_freq}].
\]

It then performs **one simultaneous pass of support filtering** over the hard equalities. For a candidate frequency \(v\in D_i\), an incident equality \(|f_i-f_j|=k\), with \(k\ge0\), requires the other endpoint to take either \(v-k\) or \(v+k\). If neither value belongs to \(D_j\), then \(v\) cannot occur in any feasible assignment and is removed.

This removal is valid because every original feasible solution must provide such a supporting endpoint value. Filtering uses the original effective domains, rather than repeatedly updated domains; it is therefore a single safe pruning pass, not full arc-consistency enforcement. Negative hard thresholds remain infeasible, since an absolute value cannot be negative.

The minimum and maximum of each filtered domain provide tighter frequency bounds. Domain membership is retained, so gaps in the frequency sets are not relaxed.

### 2. Linear binary formulation of hard equalities

For each positive hard threshold \(k_h\), the absolute-value equality is replaced by
\[
f_{x_h}-f_{y_h}=k_h(2b_h-1),
\qquad b_h\in\{0,1\}.
\]

The binary variable selects exactly the two permitted differences, \(-k_h\) and \(+k_h\). Hence this equation is equivalent to the original equality. A zero threshold is handled directly by equating the frequencies; a negative threshold explicitly makes the model infeasible.

This replaces a generic absolute-value expression with a simple mixed-integer linear equation.

### 3. Three-interval formulation of soft violations

For each nonnegative soft threshold \(k\), the integer difference \(d=f_x-f_y\) lies in exactly one of three regions:
\[
d\le-k-1,\qquad -k\le d\le k,\qquad d\ge k+1.
\]

Two binary variables select the lower or upper region; when both are zero, the middle region is selected. The violation indicator is therefore exactly
\[
1-b_{\mathrm{below}}-b_{\mathrm{above}}.
\]

Each region is intersected with bounds on \(d\) derived from the filtered endpoint domains. Empty regions are disabled. Linear lower- and upper-bound inequalities then enforce the selected interval.

This is a **convex-hull formulation of the bounded scalar interval disjunction**. It preserves the original condition because the three regions partition all integer differences, and only the middle region satisfies \(|d|\le k\). For negative soft thresholds, the violation indicator is identically zero, since \(|d|\ge0\).

Exact indicators are enforced regardless of objective coefficients, so negative weights do not invalidate the formulation.

### 4. Solver interface and solution mapping

The reformulation retains all original external parameters, the frequency variables `f`, the variable `objective`, and the minimization direction. It removes the CP-oriented search annotation and presents the difference constraints explicitly in mixed-integer linear form for HiGHS.

The mapping script copies `f` and `objective` unchanged and excludes auxiliary variables. No reconstruction of frequencies is needed.

Overall, the intended benefits are smaller domains, tighter difference bounds, and explicit linear formulations instead of generic absolute-value reification. These are formulation improvements; no runtime improvement was measured in the supplied conversation.

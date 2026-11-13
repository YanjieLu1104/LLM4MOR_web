# CELAR Radio-Link Frequency Assignment: Reformulation Report

## Background

The model assigns radio frequencies to communication links. Each link must receive a frequency from a specified category, represented by a finite set of integers that need not be consecutive.

Two types of pairwise requirements describe frequency relationships:

- **Hard separation requirements:** two links must have an absolute frequency difference equal to a specified value.
- **Soft interference requirements:** two links should have an absolute frequency difference strictly greater than a specified threshold. A separation at or below that threshold incurs a weighted penalty.

The objective is to minimize the total weighted violation cost while satisfying all hard requirements. The source explicitly excludes mobility costs. Although interference penalties would ordinarily be nonnegative, the model permits negative weights; the reformulation therefore preserves the exact violation indicators rather than relying on positive-cost assumptions.

## Original Model

Let \(n=\texttt{num\_variables}\), \(H=\texttt{num\_hardconstraints}\), and \(S=\texttt{num\_softconstraints}\). No external instance data were supplied, so numerical model sizes cannot be reported.

### Variables and domains

The model declares:

- \(n\) integer frequency variables \(f_i\), each initially bounded by `min_freq` and `max_freq`;
- one integer variable, `objective`, representing the total weighted violation cost.

Each frequency also satisfies
\[
f_i\in \texttt{categories}[\texttt{domains}[i]].
\]

Thus its effective domain is the intersection of its category set with the declared frequency interval.

### Constraints and objective

There are \(H\) hard constraints of the form
\[
|f_x-f_y|=k.
\]

For each of the \(S\) soft constraints, the violation indicator is
\[
v_s=\mathbf{1}\{|f_{x_s}-f_{y_s}|\le k_s\}.
\]

The objective-defining equality is
\[
\texttt{objective}
=\sum_{s=1}^{S}\texttt{costs}[\texttt{softctrw}[s]]\,v_s,
\]
and the solve direction is **minimization**.

The original source therefore contains \(n\) domain-membership constraints, \(H\) hard equalities, and one objective-defining equality containing \(S\) reified tests. Compilation may introduce additional variables and constraints for absolute values and reification.

## Reformulation

The reformulation targets the HiGHS mixed-integer linear programming backend. It retains the original external data interface, frequency variables, and objective variable.

### 1. Domain intersection and one-pass support filtering

First, each effective domain is computed as
\[
D_i=\texttt{categories}[\texttt{domains}[i]]
\cap[\texttt{min\_freq},\texttt{max\_freq}].
\]

This is exact because both restrictions already apply in the original model.

Next, for every hard constraint \(|f_i-f_j|=k\), a candidate value \(a\in D_i\) is retained only if \(k\ge0\) and the neighboring domain contains at least one of
\[
a-k,\qquad a+k.
\]

The same test is applied at the other endpoint and across all incident hard constraints. This is valid because any feasible assignment using \(f_i=a\) must provide one of those supporting values for every such constraint. A negative \(k\) cannot satisfy an absolute-difference equality.

This is **one-pass support filtering**, using the initial intersected domains for all support tests. It is not an iterative arc-consistency procedure. Unsupported values are removed safely, but further removable values may remain. The hard constraints are retained, so filtering does not replace necessary feasibility checks. An empty filtered domain correctly makes the model infeasible.

### 2. Linear encoding of hard absolute differences

For a positive hard separation \(k\), the reformulation introduces a binary orientation variable \(b\) and imposes
\[
f_x-f_y=k(2b-1).
\]

The two binary values give precisely the two possibilities \(f_x-f_y=-k\) and \(f_x-f_y=k\), making this equation equivalent to the original absolute-value equality.

For \(k=0\), the constraint becomes \(f_x=f_y\). For \(k<0\), it becomes an explicit contradiction. These cases preserve the semantics for all permitted integer input values.

### 3. Bound-based preprocessing of soft tests

Minimum and maximum values of the filtered domains provide valid bounds
\[
L\le d=f_x-f_y\le U.
\]

These bounds determine some soft indicators without additional decision-making:

- If \(k<0\), \(|d|\le k\) is always false.
- If both endpoints are the same variable and \(k\ge0\), it is always true.
- If \(L>k\) or \(U<-k\), it is always false.
- If \(L\ge-k\) and \(U\le k\), it is always true.

These deductions follow directly from the original frequency domains and hard constraints. Holes in a frequency domain do not invalidate the deductions: its minimum and maximum still bound every feasible value.

### 4. Exact three-region linearization of remaining soft tests

For each unresolved test, two binary variables identify the regions
\[
d\le-k-1
\quad\text{and}\quad
d\ge k+1.
\]

They cannot both be active. Linear constraints enforce both the selected outside region and, when neither is selected, the middle region
\[
-k\le d\le k.
\]

Consequently, the violation indicator is exactly
\[
v=1-b_{\mathrm{lower}}-b_{\mathrm{upper}}.
\]

The unit offsets are valid because frequencies and thresholds are integers. The big-M coefficients are calculated separately from \(L\), \(U\), and \(k\), rather than using a single generic large constant. This can strengthen the linear relaxation and improve numerical behavior.

Importantly, this is an **exact encoding**, not a one-way implication justified by minimization. It therefore preserves the objective even when weights are negative or zero.

### 5. Solution correspondence and search

The original variables `f` and `objective` remain in the model. The mapping script returns these original values and excludes the auxiliary binary variables; no reconstruction of frequencies is needed.

The CP-oriented sequential search annotation was removed, leaving search to HiGHS. This changes neither feasibility nor the minimization objective.

## Expected Effect and Validity

The changes combine domain preprocessing, constant evaluation, and explicit mixed-integer linear formulations. They aim to reduce domain sizes and avoid generic absolute-value and reification encodings. No symmetry-breaking assumptions or additional problem-specific cuts were introduced.

Every original feasible assignment survives the support filtering and admits the corresponding binary encoding. Conversely, every reformulated feasible assignment satisfies the original domain restrictions and hard constraints and has the same weighted violation cost. Thus the reformulation preserves feasible frequency assignments, objective values, and optimal solutions. Actual runtime improvements remain instance-dependent; no empirical speedup is established here.

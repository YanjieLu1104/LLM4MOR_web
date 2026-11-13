# Maximum Directed Acyclic Subgraph: Reformulation Report

## Problem background

The intended problem is to retain as many edges as possible from a directed graph while eliminating directed cycles. Such problems arise when extracting a consistent precedence structure from conflicting dependencies—for example, in scheduling, ranking, or dependency management.

The input supplies vertex and edge counts, incidence arrays, and edge endpoints. Each edge has a Boolean selection decision. Integer vertex distances represent levels in the retained dependency structure.

**The implemented semantics have an important qualification:** vertex 1 is a distinguished root whose distance is fixed to zero, and its incoming edges are not subject to a distance recurrence. Thus, the formulation excludes selected cycles among non-root vertices but does not necessarily exclude cycles passing through the root. The reformulation preserves this behavior rather than imposing a stronger, conventional DAG definition. It also uses `incident` and `tails` as the original constraints do, without assuming that `heads` or `outgoing` are consistent with them.

## Original model structure

The original model declares:

- `nbE` Boolean variables, `chosen[e]`, indicating selected edges.
- `nbV` integer variables, `distance[a]`, each with domain `0..nbE`.
- One integer variable, `objective`, also with domain `0..nbE`.

The root distance is fixed to zero. For each non-root vertex \(a\), the model imposes
\[
d_a=\max_{e:\,\mathrm{incident}[a,e]}
\bigl((d_{\mathrm{tails}[e]}+1)x_e\bigr),
\]
where \(x_e\) is the numeric interpretation of `chosen[e]`.

An unselected edge contributes zero. A selected edge contributes its tail’s distance plus one. Consequently, every selected incidence entering a non-root vertex requires a strict distance increase. The equality also requires the vertex distance to equal the largest contribution, rather than merely exceed it.

Finally,
\[
\mathrm{objective}=\sum_e x_e,
\]
and the objective is maximized. The model supplies a search annotation prioritizing edge selections before distances.

For an instance containing the root, the source has one root equality, `nbV - 1` maximum equalities, and one objective equality, before solver-specific flattening. Products of Boolean and integer variables, together with maximum equalities, require reformulation for a mixed-integer linear solver such as HiGHS.

## Reformulation and justification

### 1. Tightened distance bounds

The reformulation adds
\[
0\le d_a\le U,\qquad U=\min(\mathrm{nbE},\mathrm{nbV}-1).
\]

The `nbE` bound is inherited from the original domain. To justify the vertex-count bound, consider a non-root vertex with positive distance. Its maximum equality must have a selected maximizing predecessor with distance exactly one less. Repeating this argument produces a chain of strictly decreasing nonnegative integer distances. No vertex can repeat, because its distance is fixed within a solution. The chain therefore has at most `nbV - 1` steps.

This bound holds without assuming a simple graph or consistency between the redundant input representations. It reduces both the integer search domains and the constants needed in the linearization.

### 2. Self-loop preprocessing

For any non-root incidence whose tail is the same vertex, selection would force
\[
d_a\ge d_a+1,
\]
which is impossible. The reformulation therefore fixes that edge’s selection variable to false.

This preprocessing is applied only where the original non-root recurrence establishes the contradiction. It does not impose an analogous restriction on root incidences.

### 3. Explicit linearization of maximum equalities

For every remaining non-root incidence, the reformulation introduces one Boolean **witness** variable. A witness identifies a selected contribution that attains the vertex’s maximum.

For an incidence from tail \(t\) to vertex \(a\), the lower inequality is
\[
d_a\ge d_t+1-(U+1)(1-x_e).
\]
When the edge is selected, this enforces the required distance increase. When it is unselected, the right-hand side is at most zero, so it imposes no additional restriction.

The witness \(w_{a,e}\) satisfies
\[
w_{a,e}\le x_e,
\qquad
d_a\le d_t+1+U(1-w_{a,e}).
\]
An active witness therefore makes the corresponding contribution equal to \(d_a\). An inactive witness leaves the upper inequality redundant under the tightened distance bounds.

For each non-root vertex, at most one witness is allowed, and
\[
d_a\le U\sum_e w_{a,e}.
\]
Thus, a positive distance requires an attaining selected predecessor. If no witness is active, the distance is zero; the lower inequalities then prevent any contributing edge from being selected.

Together, these constraints reproduce the original maximum equality exactly. Conversely, every original feasible solution can be extended with witnesses by choosing a maximizing selected incidence at each positive-distance vertex.

### 4. Empty-incidence handling

The original expression does not define a zero-valued maximum for an empty incoming list. The reformulation explicitly requires every non-root vertex to have at least one incident edge, preserving the infeasibility associated with an undefined empty maximum rather than silently substituting zero.

### 5. Interface and solution preservation

All original parameters, index domains, and decision variables remain in place. The objective and optimization direction are unchanged. The mapping script copies `chosen`, `distance`, and `objective` directly from the reformulated solution, preserving their encoded array indices; auxiliary witnesses are not returned.

The resulting optimization constraints are linear. The intended computational benefit is tighter bounds, elimination of impossible self-loop selections, and an explicit bounded linearization suited to HiGHS. No instance-specific runtime improvement was measured in the supplied conversation.

## Problem background

The model describes a **diameter-constrained minimum spanning tree** problem. Given an undirected graph with edge costs, it seeks a low-cost network connecting all vertices while limiting the number of edges along routes through the network. Such models arise in communication and distribution network design, where construction cost must be balanced against routing depth or latency.

The diameter restriction is represented through rooted heights:

- For an even diameter, the tree is rooted at a vertex.
- For an odd diameter, it is rooted at an edge, with both endpoints assigned height zero.

Other vertices have positive heights bounded by the externally supplied `radius`. Under the intended tree interpretation, these bounds imply diameters of at most `2*radius` and `2*radius + 1`, respectively. Importantly, the model does **not** enforce `radius = floor(diameter/2)`; the reformulation preserves that external-data convention rather than adding it as an assumption.

## Original formulation

### Variables and objective

The original model declares:

| Variable | Count | Meaning |
|---|---:|---|
| `es` | `nbE` Boolean variables | Selected edges |
| `h` | `nbV` integer variables | Vertex heights in `0..radius` |
| `p` | `nbV` integer variables | Parent vertex identifiers |
| `root` | One integer variable | Root vertex or root edge identifier |
| `objective` | One integer variable | Total selected-edge cost |

Thus, there are `nbE` Boolean and `2*nbV + 2` integer decision variables.

The objective is to minimize
\[
\sum_{e\in E} w_e\,\mathrm{es}_e,
\]
with exactly `nbV - 1` selected edges. The original domain restriction `0..sum(ws)` on `objective` is also retained.

### Constraints

The structural constraints establish the root, heights, parents, and selected-edge relationships:

- Root vertices have height zero and are their own parents.
- Every other vertex has positive height and satisfies
  \[
  h_v=h_{p_v}+1.
  \]
- A selected noncentral edge must connect a vertex to its parent, with a height difference of one.
- For an odd diameter, edges joining the chosen root endpoints are selected. The original symmetry-breaking condition requires the first endpoint of the chosen root edge to have the smaller identifier.

The model additionally contains three families of cost/height dominance constraints and two families of parent-to-edge implications. The dominance constraints prohibit certain parent choices when a cheaper incident alternative has a sufficiently small height. All these constraints were preserved, rather than assuming that their “redundant” labels justify removing them.

The supplied `adj` and `endnodes` arrays are unused by the original constraints and remain part of the external data interface.

## Reformulation and justification

The reformulation replaces variable-indexed expressions and logical disjunctions with an explicit mixed-integer linear representation, targeting the HiGHS backend. It retains all original decision variables.

### 1. Binary root and parent encodings

One binary selector is introduced for every possible root identifier, with exactly one selector active. The original `root` variable is linked to their identifier-weighted sum.

Similarly, binary variables \(x_{vk}\) encode parent choices:
\[
\sum_k x_{vk}=1,\qquad p_v=\sum_k kx_{vk}.
\]

These are exact encodings: selecting exactly one identifier produces the corresponding original integer value, and every admissible original value has a matching selector assignment. Keeping `root` and `p` also preserves compatibility with data files that bind these variables.

The formulation introduces `nbV²` parent-choice binaries, `nbV` centre indicators, and either `nbV` or `nbE` root-choice binaries.

### 2. Linear centre and height constraints

Centre indicators are derived from the selected root: one centre for an even diameter, or the endpoint set of the chosen root edge for an odd diameter.

For each vertex, the bounds
\[
h_v\ge 1-c_v,\qquad h_v\le R(1-c_v)
\]
enforce height zero precisely at centres and positive height elsewhere, where \(R=\texttt{radius}\). Setting \(x_{vv}=c_v\) reproduces the self-parent requirement at centres and excludes self-parenthood elsewhere.

For distinct vertices, the parent-height relation becomes
\[
h_v-h_k\ge 1-(R+1)(1-x_{vk}),
\]
\[
h_v-h_k\le 1+(R-1)(1-x_{vk}).
\]

If \(x_{vk}=1\), these force \(h_v-h_k=1\). Otherwise, they reduce to the already valid bounds \(-R\le h_v-h_k\le R\). Thus, the big-M coefficients follow directly from the original height domains, without arbitrary large constants.

### 3. Linear selected-edge relationships

For distinct endpoints \(u,v\), the original parent/height disjunction is represented by the two possible parent-choice binaries.

In the even-diameter case:
\[
\mathrm{es}_e\le x_{uv}+x_{vu}.
\]

For an odd diameter, two inequalities allow the additional case where both endpoints are centres:
\[
\mathrm{es}_e\le x_{uv}+x_{vu}+c_u,\qquad
\mathrm{es}_e\le x_{uv}+x_{vu}+c_v.
\]
The lower bound
\[
\mathrm{es}_e\ge c_u+c_v-1
\]
forces edges between distinct root endpoints to be selected, as required originally.

Separate self-loop handling preserves the original behavior. Parallel edges are not merged or removed: each retains its own selection variable and constraints. This matters because the original parent-to-edge implications apply to every matching edge.

### 4. Linearized dominance constraints

Each original dominance implication can be expressed as
\[
h_s\le h_t\ \Longrightarrow\ p_v\ne k.
\]
Using the parent encoding and integer heights, this is equivalent to
\[
h_s-h_t\ge 1-(R+1)(1-x_{vk}).
\]

When the prohibited parent is chosen, the height difference must be at least one. Otherwise, the inequality is inactive within the original height bounds. This preserves all three original dominance families without requiring a new proof of their optimality-preserving status.

## Scope and expected effect

The changes are **extended-formulation and bound-based linearization techniques**, not graph reduction or edge-dominance preprocessing. Endpoint incidence is derived from `en`; no edges are deleted, and no new graph assumptions or cutting-plane families are introduced.

The intended benefit is a more explicit linear model for HiGHS, avoiding variable-indexed height expressions and nested logical disjunctions. The trade-off is the quadratic number of parent-choice binaries, so improved runtime is not guaranteed and has not been established by benchmark results here.

The final mapping script preserves the original variables `es`, `objective`, `root`, `h`, and `p`, while excluding auxiliary variables. No reconstruction of a different tree representation is required.

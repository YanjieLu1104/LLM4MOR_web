# Network Spine Design: Model and Reformulation Report

## 1. Background and interpretation

The model represents a **reliability-oriented telecommunications network design problem** on the supplied Polska network. The instance contains **12 nodes, 18 undirected links, and 7 available improvement methods per link**. Each physical link is represented by two directed arcs.

For every pair of distinct terminals, the model chooses a working route and a backup route. Working routes must use arcs designated as belonging to a network “spine.” A budget limits the total cost of the selected link-improvement methods. Each method determines a link-availability value, and route unavailability is approximated by the **sum of link-unavailability contributions**, rather than by an exact probabilistic failure calculation.

Two details are important when interpreting the formulation:

- Working and backup routes are required to be **directed-arc-disjoint**. The original constraints do not prohibit their using opposite directions of the same physical link.
- The constraint named `SpaningTree` fixes the number of selected spine arcs to \(2(n-1)\). The reformulation preserves this equation and the original routing implications; it does not replace them with a conventional undirected spanning-tree formulation.

Some improvement costs are negative. These choices can release budget while reducing availability, so they cannot simply be discarded as inferior methods.

## 2. Original model structure

### Variables

The original model declares **83,232 binary variables and 2 nonnegative continuous variables**:

| Variables | Meaning |
|---|---|
| `x[i,j,s,t]`, `y[i,j,s,t]` | Directed-arc use by working and backup routes |
| `xs[i,j]` | Membership of an arc in the spine |
| `Inc[i,j,k]` | Selection of improvement method \(k\) |
| `Incx[i,j,s,t,k]`, `Incy[i,j,s,t,k]` | Products of route-use and method-selection decisions |
| `Mwp`, `Mbp` | Upper bounds on maximum working- and backup-route unavailability |

Routing and product variables are declared for all ordered terminal pairs, including diagonal pairs with identical source and destination. Those diagonal variables do not appear in the original constraints or objective.

### Constraints

The formulation combines:

- **Flow conservation** for working and backup routes, explicitly imposed for terminal pairs \(s<t\).
- **Reverse-terminal symmetry**, relating a route from \(s\) to \(t\) to reversed arc use for the pair \(t,s\).
- **Spine membership implications**, requiring every working-route arc to be selected in the spine.
- **Directed-arc disjointness** between working and backup routes.
- **Spine cardinality**, selecting exactly \(2(n-1)\) directed arcs.
- **Exactly-one method selection** on every arc, with equal selections in opposite directions.
- **A budget inequality** over all directed arcs, with right-hand side \(2C\).
- **Binary-product linearizations** for route use times method selection.
- **Unavailability bounds** for every ordered pair of distinct terminals.

### Objective

The objective is
\[
\min\;\alpha_{\mathrm{WP}}M_{\mathrm{wp}}
       +\alpha_{\mathrm{BP}}M_{\mathrm{bp}}.
\]

For this instance, \(\alpha_{\mathrm{WP}}=1\) and \(\alpha_{\mathrm{BP}}=0\). Thus, only maximum working-route unavailability is minimized. Backup routing, disjointness, and unavailability constraints remain part of feasibility.

## 3. Reformulation and validity

### A. Elimination of reverse-terminal copies

Routing and product variables are retained only for the **66 terminal pairs satisfying \(s<t\)**.

This is an exact symmetry-based substitution, not a restriction to a preferred class of solutions. The original equations impose
\[
x[i,j,s,t]=x[j,i,t,s],
\qquad
y[i,j,s,t]=y[j,i,t,s].
\]
Therefore, every omitted reverse-terminal routing variable is uniquely determined by a retained variable.

The product variables have the same correspondence because the original product constraints enforce
\[
\mathrm{Incx}[i,j,s,t,k]
=x[i,j,s,t]\mathrm{Inc}[i,j,k],
\]
and the original method-symmetry equations equate `Inc[i,j,k]` with `Inc[j,i,k]`. The same reasoning applies to `Incy`.

Both directional spine implications and both directional unavailability bounds are retained after substitution. In particular, the reverse bound uses the reversed arc’s availability coefficient, so this reduction does **not** depend on assuming symmetric availability data.

### B. Removal of unused diagonal-terminal variables

Variables indexed by \(s=t\) are removed.

This is valid because the original routing equations use \(s<t\), while all other constraints involving terminal-indexed variables use \(s\ne t\). The objective also contains no diagonal-terminal variable. Consequently, setting all omitted diagonal variables to zero preserves feasibility and the objective value. The mapping script performs this reconstruction.

### C. Continuous disaggregated product formulation

The binary product variables are replaced by continuous variables with bounds \([0,1]\). For each retained arc and terminal pair, the reformulation imposes
\[
\sum_k \mathrm{Incx}_k=x,
\qquad
\sum_k \mathrm{Incy}_k=y,
\]
and
\[
\mathrm{Incx}_k+\mathrm{Incy}_k\le \mathrm{Inc}_k
\quad\text{for every method }k.
\]

This uses **exactly-one disaggregation** and a **joint route–method capacity inequality**. Its validity follows directly from the original constraints:

1. Exactly one binary method variable equals one.
2. Nonnegativity and the joint inequality force both product variables to zero for every unselected method.
3. The two sum equations force the selected method’s product variables to equal \(x\) and \(y\).
4. Original arc disjointness, \(x+y\le1\), makes the selected method’s joint inequality valid.

Thus, the continuous variables automatically take the required binary product values whenever routing and method decisions are integral. Conversely, every original feasible solution satisfies these new equations and inequalities.

The formulation also strengthens the local LP relaxation: the sum equations and joint method inequalities imply the original individual product-linearization inequalities, while additionally linking the working and backup products.

### D. Removal of duplicate method equations

Method-symmetry equations are retained only once per pair of opposite arcs. Exactly-one method selection is likewise imposed on one orientation.

The omitted equations follow from the retained ones: equality of corresponding method variables in opposite directions makes their method sums identical. No physical link loses its method-selection requirement.

## 4. Result and expected computational effect

The reformulated model declares **5,040 binary variables and 33,266 continuous variables**. Its main computational advantages are fewer duplicated terminal-pair decisions, removal of irrelevant variables, substantially fewer binary declarations, and a tighter product formulation.

All supplied costs, availability values, budget data, and objective weights are preserved. The mapping reconstructs reverse-terminal variables from symmetry and restores unused diagonal variables as zero. The reformulation preserves the original objective direction and values without introducing stronger physical-link disjointness or additional spine assumptions.

These changes are intended to reduce solution time; no solver benchmark was provided to establish the realized speedup.

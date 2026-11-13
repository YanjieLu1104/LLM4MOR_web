# Vehicle-Routing Model and Reformulation

## 1. Problem background

The model represents a capacitated vehicle-routing problem. Node \(0\) is a depot, and nodes \(1,\ldots,N\) are customers. Vehicles travel along selected directed arcs, with travel costs given by `Distance`. Customer demands are given by `Demand`, and `Capacity` bounds the load associated with each customer visit. The model minimizes total travel cost.

This is the intended interpretation, but the precise mathematical semantics are broader than a conventional vehicle-routing model:

- Demands and distances are declared as unrestricted integer parameters.
- Self-loops are included among the arc variables.
- The depot self-loop is not explicitly forbidden.
- The MTZ constraints eliminate customer-only cycles with positive total demand, but do not necessarily eliminate cycles with zero or negative total demand.

The reformulation preserves these features rather than imposing additional routing assumptions.

## 2. Original formulation

### Variables

For \(N\geq 0\), the original model contains:

- \((N+1)^2\) binary variables \(x_{ij}\), indicating whether arc \(i\to j\) is selected, including self-loops.
- \(N\) integer load variables \(u_i\), with \(0\leq u_i\leq C\), where \(C=\texttt{Capacity}\).
- A defined integer variable `objective`, equal to the selected arcs’ total cost.

### Constraints

Each customer has exactly one incoming and one outgoing selected arc:
\[
\sum_{i=0}^{N}x_{ij}=1,\qquad
\sum_{j=0}^{N}x_{ij}=1.
\]

The depot has separate incoming and outgoing degree upper bounds of \(K=N\). Both sums include \(x_{00}\).

The load constraints are
\[
u_i\geq d_i
\]
and the \(N^2\) Miller–Tucker–Zemlin inequalities
\[
u_i-u_j+Cx_{ij}\leq C-d_j,
\qquad i,j=1,\ldots,N,
\]
where \(d_j=\texttt{Demand}[j]\).

For a selected customer-to-customer arc, the MTZ inequality becomes
\[
u_j\geq u_i+d_j.
\]
Summing this relation around a customer-only cycle rules out that cycle whenever its total demand is positive.

### Objective

The model minimizes
\[
\sum_{i=0}^{N}\sum_{j=0}^{N}
\texttt{Distance}[i+1,j+1]\,x_{ij}.
\]

The original objective domain is also part of the formulation: its lower bound is zero and its upper bound is the sum of all entries of `Distance`. These bounds were retained, including their possible feasibility implications when distances are negative.

## 3. Reformulation and preprocessing

### Disaggregated load-flow formulation

The \(N^2\) MTZ inequalities were replaced by a load-flow formulation with \(N(N+1)\) continuous auxiliary variables \(f_{ij}\), one for every customer \(i\) and destination \(j\), including the depot.

Let
\[
L_i=\max(0,d_i).
\]
The new constraints are
\[
L_i x_{ij}\leq f_{ij}\leq Cx_{ij},
\]
\[
\sum_{j=0}^{N}f_{ij}=u_i,
\]
and
\[
\sum_{i=1}^{N}f_{ij}\leq u_j-d_j
\qquad j=1,\ldots,N.
\]

The original degree constraints, load domains, and demand lower bounds remain in place.

**Why this is equivalent for integer solutions.** Each customer has exactly one selected outgoing arc. The flow bounds force all unselected outgoing arcs to carry zero flow, so the selected outgoing arc carries exactly \(u_i\).

If customer \(j\) has a customer predecessor \(i\), its unique incoming selected arc therefore carries \(u_i\). The incoming-flow inequality becomes
\[
u_i\leq u_j-d_j,
\]
which is precisely the selected-arc MTZ condition.

If its predecessor is the depot, incoming flow from customers is zero. The inequality then reduces to the retained bound \(u_j\geq d_j\).

For an unselected arc, the original MTZ condition is already implied by
\[
u_i\leq C,\qquad u_j\geq d_j.
\]
Conversely, every original feasible integer solution extends to the new formulation by assigning \(f_{ij}=u_i\) on the selected outgoing arc and zero elsewhere. Thus the original feasible assignments and objective values are preserved.

**Why it may improve solving.** The formulation strengthens the linear relaxation through aggregate incoming-load restrictions. In particular, outgoing flow conservation and capacity bounds imply
\[
f_{ij}\geq u_i-C(1-x_{ij}),
\]
while the incoming-flow inequality implies \(f_{ij}\leq u_j-d_j\). Together, these recover every original MTZ inequality even for fractional arcs. The additional structure may improve bounds, although the extra continuous variables mean that runtime improvement is instance-dependent.

### Positive-demand self-loop elimination

The reformulation fixes
\[
x_{ii}=0\qquad\text{when }d_i>0.
\]

This follows directly from the original diagonal MTZ inequality:
\[
Cx_{ii}\leq C-d_i.
\]
Setting \(x_{ii}=1\) would require \(d_i\leq0\). Self-loops at customers with nonpositive demand are not removed, and the depot self-loop remains unchanged.

### Capacity-incompatible arc elimination

For distinct customers, the reformulation fixes \(x_{ij}=0\) whenever
\[
\max(0,d_i)+d_j>C.
\]

The original bounds imply \(u_i\geq\max(0,d_i)\). Selecting \(i\to j\) would additionally require
\[
u_j\geq u_i+d_j,
\]
contradicting \(u_j\leq C\) under the stated condition. This preprocessing is therefore valid even when some demands are negative.

### Interface and solution mapping

All original data declarations, array index domains, decision variables, and objective semantics were retained. The CP-style search annotation was removed because the specified backend is HiGHS, a mixed-integer programming solver.

The mapping script returns the original independent variables `x` and `u` unchanged and excludes the auxiliary flows. The original `objective` is defined from `x` and does not require reconstruction. No runtime improvement has been established from instance-specific experiments in this conversation.

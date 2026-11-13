# Vehicle-Routing Model: Structure and Reformulation

## 1. Application and interpretation

The model represents a capacitated vehicle-routing problem. A fleet serves \(N\) customer nodes from a common depot, indexed by \(0\). Customer \(i\) has demand `Demand[i]`, each vehicle has capacity `Capacity`, and `Distance[i+1,j+1]` gives the cost of traveling from node \(i\) to node \(j\). The objective is to minimize total selected-arc cost.

The number of permitted vehicles is represented by depot degree bounds, with `K = N`. There is no explicit vehicle index: routes are represented collectively by selected arcs.

Importantly, the source does not require strictly positive demands, nonnegative distances, or the exclusion of self-loops. Thus, its feasible solutions need not always coincide with the usual textbook interpretation of vehicle routing. The reformulation preserves these details rather than imposing additional routing assumptions.

## 2. Original mathematical structure

### Variables

- **Arc selection:** \((N+1)^2\) binary variables \(x_{ij}\), including customer and depot self-loops.
- **Load potentials:** \(N\) integer variables \(u_i\), each with domain \(0\le u_i\le C\), where \(C=\texttt{Capacity}\).
- **Objective:** a defined integer variable equal to total selected-arc cost.

### Constraints

The original model contains:

- \(N\) customer indegree equations:
  \[
  \sum_{i=0}^{N}x_{ij}=1.
  \]
- \(N\) customer outdegree equations:
  \[
  \sum_{j=0}^{N}x_{ij}=1.
  \]
- Two depot degree inequalities, each bounded by \(K\).
- \(N^2\) Miller–Tucker–Zemlin (MTZ) inequalities:
  \[
  u_i-u_j+Cx_{ij}\le C-d_j,
  \]
  where \(d_j=\texttt{Demand[j]}\).
- \(N\) demand lower bounds:
  \[
  u_i\ge d_i.
  \]

For a selected customer-to-customer arc, the MTZ inequality requires
\[
u_j\ge u_i+d_j.
\]
With strictly positive demands, this rules out customer-only cycles. With zero or negative demands, some such cycles can remain feasible.

### Objective

The optimization direction is minimization:
\[
\min \sum_{i=0}^{N}\sum_{j=0}^{N}
\texttt{Distance}[i+1,j+1]\,x_{ij}.
\]

## 3. Reformulation and validity

The reformulation retains all original decision variables, data declarations, index domains, and objective coefficients. It uses bound strengthening, arc preprocessing, and valid inequalities.

### Bound-based MTZ coefficient tightening

Define the implied lower bound
\[
L_i=\max(0,d_i).
\]
This follows directly from the original variable domain and demand lower bound.

The MTZ inequalities are replaced by
\[
u_i-u_j+(C+d_j-L_j)x_{ij}\le C-L_j.
\]

This replacement is equivalent for binary arcs:

- If \(x_{ij}=1\), both formulations give \(u_j\ge u_i+d_j\).
- If \(x_{ij}=0\), the new inequality follows from \(u_i\le C\) and \(u_j\ge L_j\). The original inactive inequality is also automatic because \(L_j\ge d_j\).

For nonnegative demands, the coefficient on \(x_{ij}\) becomes \(C-d_j\), strengthening the continuous relaxation without removing original feasible assignments.

### Infeasible-arc preprocessing

Two types of arcs are explicitly fixed to zero:

- **Positive-demand customer self-loops:** Setting \(i=j\) in the original MTZ constraint shows that \(x_{ii}=1\) requires \(d_i\le0\). Therefore, \(d_i>0\) implies \(x_{ii}=0\).
- **Load-incompatible customer arcs:** If \(x_{ij}=1\), then
  \[
  u_j\ge u_i+d_j\ge L_i+d_j.
  \]
  Since \(u_j\le C\), an arc is impossible whenever \(L_i+d_j>C\).

These are deductions from the original load constraints, not additional routing assumptions.

### Two-cycle cuts

For distinct customers with \(d_i+d_j>0\), the reformulation adds
\[
x_{ij}+x_{ji}\le1.
\]

If both arcs were selected, their active MTZ inequalities would imply
\[
u_j\ge u_i+d_j,\qquad u_i\ge u_j+d_i.
\]
Adding them gives \(0\ge d_i+d_j\), a contradiction. The demand-sum condition is essential: excluding all two-cycles would not preserve the original model.

### Degree-aggregated load bounds

Using each customer’s unique incoming arc, the model adds
\[
u_j\ge L_j+
\sum_{i=1}^{N}\max(0,L_i+d_j-L_j)x_{ij}.
\]

At most one term is selected. A customer predecessor implies \(u_j\ge L_i+d_j\); a depot predecessor leaves the original bound \(u_j\ge L_j\).

Similarly, the unique outgoing arc yields
\[
u_i\le C-\sum_{j=1}^{N}\max(0,d_j)x_{ij}.
\]

A selected customer successor implies \(u_i\le C-d_j\); otherwise, the original upper bound \(C\) applies. These inequalities expose consequences of the degree and MTZ constraints directly to the linear relaxation.

### Conditional rounded fleet-capacity cut

Only when \(C>0\) and all demands are nonnegative, the model adds
\[
\sum_{j=1}^{N}x_{0j}
\ge
\left\lceil\frac{\sum_i d_i}{C}\right\rceil.
\]

The degree equations decompose selected arcs into depot-based routes and customer-only cycles. Summing MTZ inequalities around a customer-only cycle shows its total demand is nonpositive; under nonnegative demands, it must therefore be zero. Along a depot-based route, the load bounds and active MTZ inequalities imply total demand at most \(C\). Consequently, all demand requires at least the stated number of depot departures.

## 4. Implementation and solution compatibility

The CP-style search annotation was removed because the target backend is HiGHS; this does not change feasibility or the objective. No auxiliary decision variables were introduced.

The mapping script copies the unchanged `x` and `u` arrays, preserving their encoded index sets, and explicitly reports missing fields. The defined objective is recomputed by the original model.

These changes aim to improve mixed-integer solving through tighter relaxations and earlier arc elimination. No instance-specific runtime improvement was established in the supplied conversation.

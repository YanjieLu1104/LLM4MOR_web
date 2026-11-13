# Reformulation Report: Capacitated Routing with Time Windows and Sequential Trips

## 1. Problem background

The model represents a **capacitated vehicle-routing problem with service time windows**, together with sequencing requirements between trips.

The instance contains 34 customers and two depot representations: node **0** is the departure depot, and node **35** is the return depot. Each customer has a demand, a service duration, and an allowable interval for starting service. Routes must serve every customer exactly once, respect capacity, and satisfy travel and service timing requirements.

There are ten indexed vehicles or trip slots:
- Indices 1–5 have capacity 15 and travel-time cost coefficient 16,483.8.
- Indices 6–10 have capacity 84 and travel-time cost coefficient 21,412.2.

Within each group, a later slot may operate only if its predecessor operates, and its departure cannot precede the predecessor’s return. This suggests successive trips by two physical vehicles or resources, although that interpretation is inferred rather than explicitly documented.

## 2. Original mathematical structure

### Variables and objective

The original model declares:
- **12,960 binary arc variables** \(X_{ijk}\), indicating whether slot \(k\) uses arc \(i\to j\). These are declared for all node pairs, including pairs outside the routing network.
- **10 binary activation variables** \(Y_k\).
- **360 nonnegative continuous variables** \(W_{ik}\), representing service-start times.

The objective minimizes
\[
\sum_{i,j,k} c_k t_{ij}X_{ijk}.
\]
Thus, the modeled cost is proportional to travel time. Despite the description of \(c_k\) as an operating cost, there is no separate fixed activation charge.

### Constraints

The original formulation has **13,050 explicitly indexed constraints**, excluding variable-domain restrictions:

- **Customer assignment:** each customer has exactly one outgoing routing arc across all slots.
- **Departure and return:** each active slot leaves node 0 once and enters node 35 once.
- **Flow conservation:** each customer’s incoming and outgoing flows balance separately for every slot.
- **Time propagation:** 11,900 big-\(M\) inequalities enforce travel and service time on selected arcs.
- **Time windows:** 720 inequalities bound all service-start variables, including those for customers not visited by a particular slot.
- **Capacity:** total demand assigned to a slot cannot exceed its capacity.
- **Activation:** the total number of selected routing arcs is bounded by \(1000Y_k\).
- **Trip sequencing:** activation and depot-time ordering apply within the two groups of five slots.

Positive customer service times make selected customer cycles impossible: summing the active time-propagation inequalities around a cycle would require a time variable to exceed itself by a positive amount.

## 3. Reformulation and validity

### Fixing nonrouting arcs to zero

Arc variables outside `DESTINO[i]` appear only in the objective for this instance. The supplied `ORIGEN` sets describe the same routing network, so these variables do not participate in flow constraints either.

Because all objective coefficients are nonnegative, setting these variables to zero cannot worsen a minimization solution or affect feasibility. This is **objective-based variable fixing**: it preserves at least one optimum, although it removes alternative solutions involving irrelevant zero-cost arcs.

### Eliminating infeasible routing arcs

Two forms of **arc preprocessing** were applied:

- **Time-window incompatibility:** if
  \[
  a_i+s_i+t_{ij}>b_j,
  \]
  selecting \(i\to j\) would contradict time propagation together with \(W_{ik}\ge a_i\) and \(W_{jk}\le b_j\). Its arc variable is therefore fixed to zero.

- **Capacity incompatibility:** if \(d_i+d_j>Q_k\), the arc is fixed to zero for slot \(k\). For two customer endpoints, selecting the arc assigns both customers to that slot: the tail has an outgoing arc, and flow conservation forces an outgoing arc at the head. Both demands therefore enter the original capacity inequality. Depot demands are zero, so the same test also covers depot-adjacent arcs.

### Tightening time propagation safely

The reformulation replaces each propagation coefficient by
\[
\widehat M_{ij}
=\min\!\left\{M_{ij},\,
\max\!\left(0,b_i+s_i+t_{ij}-a_j\right)\right\}.
\]

When \(X_{ijk}=1\), the inequality is unchanged. When \(X_{ijk}=0\), the time-window expression is an upper bound on its left-hand side, so reducing an unnecessarily large coefficient is valid.

Crucially, the supplied \(M_{ij}\) is **never increased**. Some supplied values are rounded below the usual time-window bound and therefore impose genuine restrictions even on unselected arcs. Those restrictions are preserved. Explicit time-window constraints are also moved into equivalent bounds on \(W\).

### Strengthening activation and capacity

The reformulation adds
\[
\sum_{j\in DESTINO[i]}X_{ijk}\le Y_k
\]
for every customer and slot. This follows from the original activation constraint when \(Y_k=0\), and from customer assignment when \(Y_k=1\).

Capacity is strengthened to
\[
\sum_{i,j\in DESTINO[i]}d_iX_{ijk}\le Q_kY_k.
\]
For active slots this is the original capacity limit; inactive slots already have no selected routing arcs. Both changes strengthen the linear relaxation without excluding integer-feasible solutions.

### Tightening the route-cardinality bound

Summing customer assignment bounds limits a slot to 34 customer departures. The depot departure equation adds exactly \(Y_k\) arcs. Moreover, every customer demand is at least one, so capacity limits the number of customers on a small-capacity slot to 15.

Consequently, the coefficient 1000 is replaced by **16 for slots 1–5** and **35 for slots 6–10**. These bounds follow directly from assignment, departure, and capacity constraints.

### Adding valid inequalities

- **Capacity-conflict cuts:** two customers whose combined demand exceeds a slot’s capacity cannot both be assigned to it. Their combined visit indicators are therefore bounded by \(Y_k\).
- **Two-cycle cuts:** opposite customer arcs cannot both be selected. Assignment and flow conservation would force them onto the same slot, and the original timing inequalities prohibit that positive-duration cycle.

These cuts strengthen fractional relaxations of restrictions already implied for integer solutions.

## 4. Representation and expected effect

The fixed adjacency sets are expressed algebraically with exactly the original memberships. All original decision variables remain, including variables fixed to zero, so solution mapping is the identity.

The reformulation targets fewer effective binary choices, tighter activation bounds, and stronger linear relaxations. These changes are intended to reduce branch-and-bound effort; no measured runtime improvement is established here.

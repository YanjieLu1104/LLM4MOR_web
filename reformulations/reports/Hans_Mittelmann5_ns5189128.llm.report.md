# Reformulation Report: Time-Dependent Fruit Delivery

## 1. Real-world background

The model describes a fruit-distribution problem in which a fleet delivers six fruit categories from a depot to 54 customers. The instance contains 55 nodes, including depot `0`, and 12 vehicle indices with different capacities and operating costs.

The formulation combines vehicle routing with a linear approximation of time-dependent fruit losses. Customers have fruit-specific demands and service times. Travel time is calculated from the supplied directed distance matrix and vehicle speeds. Later visits generate greater spoilage-related costs and increase the inventory required to support deliveries.

Although `K` is described in the source as vehicle types, each index is allowed at most one departure from the depot. Operationally, the formulation therefore treats these indices as individually available vehicles or route resources.

The supplied distances are preserved exactly, including their substantial variation in magnitude. No distance-unit corrections are assumed.

## 2. Original mathematical formulation

### Decision variables

The original model contains **36,025 variables**:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `x[i,j,k]` | Whether vehicle `k` travels directly from node `i` to distinct node `j` | Binary | 35,640 |
| `y[i,h]` | Inventory quantity associated with node `i` and fruit `h` | Nonnegative continuous | 330 |
| `t[i]` | Time associated with visiting node `i` | Nonnegative continuous | 55 |

Inventory and time variables are shared across vehicles rather than indexed by vehicle.

### Objective

The model **minimizes** the sum of:

1. **Travel costs:** distance multiplied by the selected vehicle’s variable operating cost.
2. **Vehicle-use costs:** a fixed charge for each selected depot departure.
3. **Spoilage costs:** customer demand multiplied by its fruit-specific loss rate, visit time, and unit loss cost.

All objective terms are linear.

### Constraints

The original formulation contains **213,702 constraints**, excluding variable bounds.

| Family | Function | Count |
|---|---|---:|
| `E2` | Exactly one outgoing arc from each customer, across all vehicles | 54 |
| `E3` | Vehicle-specific flow conservation at every node | 660 |
| `E4` | Inventory propagation and time-dependent loss requirements | 209,952 |
| `E5` | Customer inventory limited by the capacity of the incoming vehicle | 54 |
| `E6` | Time propagation from customers, with big-\(M\) deactivation | 2,916 |
| `E7` | Time requirements for depot-to-customer travel | 54 |
| `E8` | At most one depot departure per vehicle index | 12 |

For a selected arc \(i\to j\), `E4` requires
\[
y_{ih}\ge y_{jh}+d_{ih}+d_{ih}ph_h\,t_i.
\]
Thus the inventory at a customer must cover its demand, its modeled time-dependent losses, and the inventory required at the successor.

The parameter `HL = 8` is used as a big-\(M\) coefficient in the time constraints. The source does **not** explicitly impose \(t_i\le HL\), and the reformulation does not introduce that additional restriction. Likewise, the depot time is not fixed to zero.

## 3. Reformulation and validity

### 3.1 Aggregate vehicle-specific inventory constraints

**Technique:** Constraint aggregation using mutually exclusive binary choices.

For each customer \(i\), destination \(j\ne i\), and fruit \(h\), define the expression
\[
z_{ij}=\sum_{k\in K}x_{ijk}.
\]
No additional decision variable is required.

Constraint `E2`, together with binary nonnegative arc variables, implies \(z_{ij}\in\{0,1\}\): at most one vehicle can select any particular customer-originating arc.

The 12 original `E4` inequalities for a fixed \((i,j,h)\) can be written as
\[
y_{ih}-y_{jh}-d_{ih}ph_h\,t_i
\ge (qK+d_{ih})x_{ijk}-qK
\qquad \forall k.
\]
They are replaced by the single inequality
\[
y_{ih}-y_{jh}-d_{ih}ph_h\,t_i
\ge (qK+d_{ih})z_{ij}-qK.
\]

**Why this is valid:**

- If \(z_{ij}=0\), every corresponding arc variable is zero. All original inequalities have the same right-hand side, \(-qK\), exactly as in the replacement.
- If \(z_{ij}=1\), exactly one vehicle selects the arc. Its original inequality has right-hand side \(d_{ih}\), which dominates the remaining inequalities because \(qK,d_{ih}\ge0\). The replacement imposes precisely this strongest inequality.

The replacement therefore preserves the integer feasible set. It also strengthens the LP relaxation because \(\sum_k x_{ijk}\ge x_{ijk}\) for every vehicle and \(qK+d_{ih}\ge0\).

**Reduction:** `E4` decreases from **209,952 to 17,496 constraints**, removing **192,456 rows**.

### 3.2 Fix time-incompatible customer-to-customer arcs

**Technique:** Pairwise time-constraint preprocessing and binary-variable fixing.

For distinct customers \(i,j\), adding the original `E6` inequalities for \(i\to j\) and \(j\to i\) eliminates both time variables:
\[
s_i+s_j+
\sum_k\frac{a_{ij}}{v_k}x_{ijk}
+\sum_k\frac{a_{ji}}{v_k}x_{jik}
\le
2HL-HL(z_{ij}+z_{ji}).
\]

If \(x_{ijk}=1\), `E2` gives \(z_{ij}=1\). Since reverse-arc variables and travel times are nonnegative, the displayed inequality necessarily implies
\[
s_i+\frac{a_{ij}}{v_k}+s_j\le HL.
\]

Consequently, every customer-to-customer arc violating this condition is fixed to zero through its variable upper bound.

**Why this is valid:** The fixing follows directly from two original time constraints; it does not rely on an assumed upper bound on visit times. The test is applied only when both endpoints are customers, so both required `E6` inequalities and both service-time parameters exist. All supplied vehicle speeds are positive.

The original arc-variable indices are retained, simplifying solution correspondence.

### 3.3 Add inventory lower-bound cuts

**Technique:** Valid inequalities obtained from the mandatory selected successor.

For every customer and fruit, the reformulation adds
\[
y_{ih}\ge d_{ih}(1+ph_h\,t_i).
\]

**Why this is valid:** `E2` ensures that every customer has exactly one selected outgoing arc. Applying the original `E4` inequality to that selected arc yields
\[
y_{ih}\ge d_{ih}+d_{ih}ph_h\,t_i+y_{jh}.
\]
The original bound \(y_{jh}\ge0\) gives the proposed inequality immediately.

These **324 cuts** explicitly enforce an inventory requirement already implied at integer solutions, strengthening the fractional relaxation.

## 4. Result and expected benefit

The reformulated model retains the original variables, instance data, minimization direction, and objective expression. Its declared constraint count is **21,570**, including the new inventory cuts and excluding variable bounds.

The principal expected benefits are:

- substantially fewer inventory-propagation rows;
- a stronger LP relaxation;
- fewer available binary arc choices after preprocessing.

All changes preserve the original integer feasible solutions and their objective values. The solution-mapping script therefore copies the original variable assignments unchanged. These are structural improvements; no measured solve-time improvement is claimed.

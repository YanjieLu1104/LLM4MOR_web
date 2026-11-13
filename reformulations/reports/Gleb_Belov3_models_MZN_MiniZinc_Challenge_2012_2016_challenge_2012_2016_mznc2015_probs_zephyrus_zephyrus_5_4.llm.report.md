## Background and interpretation

This instance comes from **Zephyrus**, a deployment-synthesis tool for cloud applications described using the Aeolus component model. It represents a Fredhopper Cloud Services application, which provides search and targeting functionality for e-commerce systems.

The optimization problem decides how many components of six types to place at each of **26 named locations**:

- Platform services
- Load balancers
- Deployment services
- Service providers
- Query services
- Infrastructure services

The location names suggest several Amazon machine classes and an internal infrastructure location. However, **the supplied model contains no location-specific capacity, cost, or eligibility constraints**. Its actual decisions concern component counts, co-location requirements, and separation requirements—not resource sizing.

## Original model

### Variables

The model declares **163 integer variables**, each initially bounded by \(0\) and \(100{,}000\):

- \(26 \times 6 = 156\) local component counts;
- Six global component totals;
- One objective variable.

Write \(p_i,l_i,d_i,s_i,q_i,h_i\) for the local counts at location \(i\), and \(P,L,D,S,Q,H\) for their global totals.

### Constraints

Six aggregation equalities define the global totals as sums of the corresponding local counts. The application specification requires:

- Exactly four query components: \(Q=4\).
- At least one platform, load balancer, and service provider: \(P,L,S\ge1\).
- At most one query per location.
- A query must share its location with at least one deployment component.
- A service provider must share its location with at least one platform component.
- Queries cannot share a location with platforms, load balancers, service providers, or infrastructure components.
- Load balancers and infrastructure components must each be separated from every other component type.
- Platforms cannot share a location with deployment components, queries, load balancers, or infrastructure components.

Many of these requirements are expressed as **sums of Boolean violation indicators equal to zero**. Because each indicator is nonnegative, this is equivalent to forbidding every individual violation.

### Objective

The model minimizes the sum of all local component counts, plus the global platform, load-balancer, service-provider, and query counts. Using the aggregation equalities, this becomes

\[
\min\; 2(P+L+S+Q)+D+H.
\]

Thus, platform, load-balancer, service-provider, and query components effectively have weight two, while deployment and infrastructure components have weight one. This is a weighted component-count objective, not a machine-rental-cost objective.

## Reformulation and justification

### 1. Establish the optimal objective value analytically

The original constraints imply \(Q=4\) and \(q_i\le1\), so four distinct locations must contain queries. Each requires a deployment component, giving \(D\ge4\). Together with \(P,L,S\ge1\) and \(H\ge0\),

\[
2(P+L+S+Q)+D+H
\ge 2(1+1+1+4)+4
=18.
\]

This lower bound is attainable:

- Place one query and one deployment component at each of locations 0–3.
- Place one platform and one service provider together at location 4.
- Place one load balancer at location 5.
- Leave all remaining counts zero.

This satisfies every co-location and separation rule. It is permitted because the supplied model has no additional location restrictions. Therefore, the optimal objective value is **18**.

### 2. Restrict the formulation to the optimal solution set

Every term in the objective has a positive coefficient. Equality with the lower bound therefore forces

\[
P=L=S=1,\qquad Q=D=4,\qquad H=0.
\]

These are **optimality-based reductions**, not properties of every feasible deployment. They remove nonoptimal solutions but preserve every original optimum and the minimization direction.

The corresponding local reductions follow directly:

- **Infrastructure counts are zero:** nonnegative local counts sum to \(H=0\).
- **Deployment counts equal query counts:** every query location requires at least one deployment, and the four required query locations already exhaust \(D=4\). Hence \(d_i=q_i\).
- **Platform counts equal service-provider counts:** the unique service provider requires a colocated platform, and there is exactly one platform globally. Hence \(p_i=s_i\).
- **All remaining local counts are binary:** platform, load-balancer, and service-provider totals are one; queries were already limited to one per location; deployments equal queries.

### 3. Replace reified constraints with linear constraints

After these reductions, every occupied location has one of three forms:

1. A platform/service-provider pair;
2. A load balancer;
3. A query/deployment pair.

The original incompatibilities prohibit these forms from overlapping. Their local restrictions are therefore represented exactly, within the optimal solution set, by

\[
p_i+l_i+q_i\le1,\qquad
s_i=p_i,\qquad
d_i=q_i,\qquad
h_i=0.
\]

Together with the required component totals, these linear constraints replace the large Boolean-indicator expressions. This removes the need for their reification and associated MIP linearizations, while reducing the original large integer domains to binary domains.

### 4. Compact representation and explicit solution mapping

The final model stores local counts in a **26-by-6 binary array**, with explicit location and component labels preserving the original entity correspondences.

The accompanying Python mapping script:

- Maps each array entry to its original local-variable name;
- Reconstructs all six global totals by summation;
- Recomputes the original objective expression.

It restores all **163 original variables** and validates the array dimensions and index domains. The fixed label lists come directly from the self-contained source instance.

## Expected computational effect

The reformulation combines **analytical lower bounding, a matching feasible construction, optimality-based domain reduction, and linear replacement of logical constraints**. Instead of optimizing over large component multiplicities and reified incompatibilities, HiGHS receives a small binary placement formulation whose feasible solutions all attain the proven optimum of 18.

No runtime measurements were supplied, so the improvement is structural rather than experimentally quantified.

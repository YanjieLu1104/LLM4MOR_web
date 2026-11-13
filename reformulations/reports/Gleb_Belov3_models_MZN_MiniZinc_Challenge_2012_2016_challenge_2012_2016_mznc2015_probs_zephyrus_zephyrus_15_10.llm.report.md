# Deployment Configuration Model: Background and Reformulation

## 1. Real-world background

This instance comes from **Zephyrus**, a tool for synthesizing cloud application deployments from abstract component specifications. The application is Fredhopper Cloud Services, which provides search and targeting services for e-commerce product databases.

The model decides how many instances of six component types to place at each of **76 candidate locations**:

- Platform service
- Load balancer
- Deployment service
- Service provider
- Query service
- Infrastructure service

The location names describe five virtual-machine classes, with 15 locations each, and one Amazon-internals location. However, **the supplied model contains no machine-specific capacities, prices, or placement restrictions**. All locations have identical mathematical roles. The optimization concerns component counts and compatibility, rather than resource-aware provisioning.

## 2. Original model

### Variables

The model declares **463 integer variables**, each initially bounded by `0..100000`:

- **456 local counts:** six component types at each of 76 locations.
- **Six global totals:** one per component type.
- **One objective variable.**

### Constraints

There are eight top-level constraint statements: six global-total equalities, one large conjunction containing the deployment specification, and one objective equality.

The specification requires:

- Exactly **ten query instances** overall.
- At least one platform, load balancer, and service provider.
- At most one query instance per location.
- A query to have at least one deployment instance at the same location.
- A service provider to have at least one platform instance at the same location.

The remaining requirements prohibit incompatible colocations:

- Queries cannot share a location with platforms, load balancers, service providers, or infrastructure.
- Load balancers cannot share a location with any other component type.
- Infrastructure cannot share a location with any other component type.
- Platforms cannot share a location with load balancers, deployments, infrastructure, or queries.

These local rules are expressed indirectly: the model sums Boolean indicators of violations over all locations and requires each sum to equal zero. Since every indicator is nonnegative, this means that **every individual violation must be absent**.

### Objective

Writing \(P,L,D,S,Q,I\) for the six global component totals, the original objective simplifies to

\[
\min \; 2(P+L+S+Q)+D+I.
\]

This follows because the objective includes every local component count once, plus the global platform, load-balancer, provider, and query totals once more. The six total-defining equalities justify replacing the local sums by their corresponding global totals.

The objective variable’s upper bound of 100,000 also acts as a feasibility restriction.

## 3. Reformulation and justification

### Indexed representation and reconstruction

The reformulation replaces the individually named local variables with a **76-by-6 integer array**, preserving the original location and component ordering. Global totals are computed as column sums rather than represented by separate decision variables.

Each column sum remains bounded by 100,000, preserving the original global-variable domains. The mapping script reconstructs all original local variables, global totals, and the objective from the array.

### Direct linear encoding of local compatibility

The zero-sum violation constraints imply four mutually exclusive categories for a nonempty location:

| Category | Permitted components |
|---|---|
| Platform/provider | Platform, optionally with service providers |
| Load balancer | Load balancers only |
| Deployment/query | Deployment, optionally with one query |
| Infrastructure | Infrastructure only |

This classification is exhaustive. A provider requires a platform, and a query requires a deployment. The original incompatibility constraints prohibit sharing between the four categories. Deployment without a query and platform without a provider remain permitted.

Four binary category indicators are introduced per location, with their sum at most one. For each category, its defining component count \(x\) and indicator \(a\) satisfy

\[
a \le x \le 100000a.
\]

Thus the indicator is one exactly when that defining component is present. Providers are allowed only in the platform category; queries only in the deployment category. Empty locations remain possible with all indicators zero.

This is an **extended mixed-integer linear formulation** of the original logical constraints. It avoids the large nested Boolean expressions and their associated reification machinery.

### Query-domain tightening

The original requirement that no location have more than one query, together with nonnegative integer domains, gives

\[
Q_\ell \in \{0,1\}.
\]

Consequently, “a query requires a deployment” is exactly equivalent to

\[
Q_\ell \le D_\ell.
\]

The reformulation uses these linear inequalities directly, while retaining the total-query equality.

### Valid lower bounds and strengthening inequalities

Summing \(Q_\ell \le D_\ell\) and using the requirement of ten queries gives \(D\ge10\). Together with \(P,L,S\ge1\), \(Q=10\), and \(I\ge0\), this proves

\[
\text{objective}
=2(P+L+S+Q)+D+I
\ge 2(1+1+1+10)+10
=\boxed{36}.
\]

The reformulation adds this objective lower bound and the aggregate deployment bound explicitly.

It also requires at least one active platform category, at least one active load-balancer category, and at least **12 occupied locations**. The latter follows because the ten queries occupy ten distinct locations, while the required platform and load balancer must occupy two additional, mutually incompatible locations.

These are redundant valid inequalities: they strengthen the formulation without excluding feasible original deployments.

### Location-symmetry breaking

Although their names differ, all 76 locations have the same domains, local constraints, and objective coefficients in this supplied instance. Permuting complete location assignments therefore preserves feasibility and objective value.

The reformulation orders location categories and places query-bearing locations first. These orderings are compatible: every query belongs to the deployment/query category, which receives the highest category rank. Any feasible assignment can first be sorted by category and then have query-bearing locations placed first within that category.

The ordering removes equivalent permutations, not distinct objective possibilities. In particular, at least one representative of every optimal deployment remains.

## 4. Expected computational effect

The changes replace bulky logical expressions with explicit linear constraints, expose useful aggregate bounds, and reduce location-permutation symmetry. These features are intended to improve compilation and mixed-integer solving with **HiGHS**. No measured runtime improvement was established in the conversation.

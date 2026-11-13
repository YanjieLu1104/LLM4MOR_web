# Zephyrus Cloud-Deployment Model: Reformulation Report

## Background and purpose

This instance comes from **Zephyrus**, a tool that synthesizes cloud-application deployments from abstract architectural requirements. The application is Fredhopper Cloud Services, which provides search and targeting functionality for e-commerce systems.

The model decides how many instances of six component types to place at each of **101 candidate locations**:

- Platform service
- Load-balancer service
- Deployment service
- Service provider
- Query service
- Infrastructure service

The location names identify five groups of 20 virtual-machine locations and one Amazon-internal location. However, **the supplied model contains no machine-capacity, resource-consumption, location-eligibility, or location-dependent cost constraints**. Its decisions are governed by component counts and architectural colocation rules, rather than hardware sizing.

## Original formulation

### Variables

The model declares **613 integer variables**, all initially bounded by `0..100000`:

- **606 local counts:** six component types at each of 101 locations.
- **Six global counts:** total instances of each component type.
- **One objective variable.**

### Constraints

Six aggregation equalities link the global counts to their corresponding local counts.

The architectural specification requires:

- Exactly **20 query-service instances**, with at most one query at any location.
- At least one platform, load balancer, and service provider.
- A deployment service wherever a query is present.
- A platform service wherever a service provider is present.
- Queries may share a location with deployment services, but not with platforms, load balancers, service providers, or infrastructure services.
- Load balancers and infrastructure services must each be isolated from all other component types.
- Platforms may share a location with service providers, but not with deployment services, queries, load balancers, or infrastructure services.

The generated source encodes the local rules as sums of Boolean violation indicators constrained to zero. Because each indicator is nonnegative, such an equality requires every individual violation to be absent.

### Objective

Let \(P,L,D,S,Q,I\) denote the global counts of platforms, load balancers, deployments, service providers, queries, and infrastructure services. The objective adds all local counts, then adds the global platform, load-balancer, provider, and query counts once more. Using the aggregation equalities, it is therefore

\[
\min \; 2(P+L+S+Q)+D+I.
\]

Thus, this instance minimizes a **weighted component count**, not monetary machine-rental cost. The original source also supplies a first-fail, minimum-value integer search annotation.

## Reformulation and justification

### 1. Prove an exact objective bound

The original specification fixes \(Q=20\) and permits at most one query per location. Consequently, queries occupy 20 distinct locations.

Every query location must contain at least one deployment service. Since local counts are nonnegative integers, this implies

\[
D\ge20.
\]

The specification also requires \(P,L,S\ge1\), while the variable domains give \(I\ge0\). Substituting these bounds into the objective yields

\[
2(P+L+S+Q)+D+I
\ge 2(1+1+1+20)+20=66.
\]

This lower bound is attainable in the supplied model:

- Locations 0–19 each contain one query and one deployment.
- Location 20 contains one platform and one service provider.
- Location 21 contains one load balancer.
- Every other count is zero.

This assignment satisfies all colocation and exclusion rules. No location-specific constraints prohibit it. Hence, **the optimal objective value is exactly 66**.

### 2. Restrict the search to the proven optimal face

For every feasible assignment, the objective can be written as

\[
66+2(P-1)+2(L-1)+2(S-1)+(D-20)+I.
\]

Every term following 66 is nonnegative. Therefore, an assignment is optimal only if

\[
P=L=S=1,\qquad D=Q=20,\qquad I=0.
\]

The reformulation enforces these consequences. This is **optimality-based preprocessing**: it removes nonoptimal feasible assignments, but preserves every original optimal assignment and its objective value.

### 3. Tighten local domains and substitute equal counts

The global optimality conditions imply stronger local properties:

- **All local counts are binary.** Queries were already limited to one per location. Global totals of one make platform, load-balancer, and provider counts binary. Infrastructure counts are zero. The 20 required query locations consume the entire deployment total of 20, leaving exactly one deployment at each query location and none elsewhere.
- **Local deployment equals local query.** This follows from the query-to-deployment requirement and the now-exact deployment total.
- **Local provider equals local platform.** There is exactly one instance of each globally, and the provider must be colocated with a platform.

These deductions replace the original loose integer domains and several logical relationships with binary domains and linear equalities.

### 4. Replace incompatibility expressions with a linear inequality

After the substitutions, each location can contain only one of three nonempty configurations:

1. A platform/provider pair
2. A load balancer
3. A query/deployment pair

The original exclusion rules prohibit every pairwise combination of these configurations. Therefore, they are represented exactly on the optimal face by

\[
p_\ell+l_\ell+q_\ell\le1
\]

at each location \(\ell\).

This is a **clique inequality** for mutually incompatible configurations. Together with the binary domains and substitution equalities, it replaces the large Boolean violation expressions with a compact linear formulation suitable for HiGHS.

### 5. Preserve entity correspondence through solution mapping

The reformulation stores local counts in an array whose rows retain the original location order and whose columns retain the six component meanings. A mapping script reconstructs:

- Every original local scalar variable
- Each global total by summation
- The original weighted-count objective

No locations are merged or relabeled semantically. The mapping restores all **613 original variables**.

## Expected computational effect and scope

The reformulation eliminates loose bounds, removes complex reified logical expressions, and eliminates objective trade-offs by proving the optimal component totals in advance. The remaining task is to select compatible locations for the required binary configurations.

These changes are expected to reduce compilation and optimization effort, although no measured runtime improvement is reported here. The reductions rely specifically on the supplied model’s constraints and objective; additional capacity, eligibility, or location-cost constraints could invalidate the attaining construction and would require a new proof.

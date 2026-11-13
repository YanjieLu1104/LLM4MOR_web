# Report: Fredhopper Cloud Services Deployment Reformulation

## Background and problem meaning

This instance comes from **Zephyrus**, a tool for synthesizing cloud application deployments from component requirements. The application is Fredhopper Cloud Services, which provides search and targeting services for e-commerce product databases.

The model decides how many instances of six component types to deploy and where to place them:

- Platform services
- Load balancers
- Deployment services
- Service providers
- Query services
- Infrastructure services

There are **76 candidate locations**, with names representing five virtual-machine classes and one Amazon-internal location. Although the names suggest different hardware or hosting environments, **the supplied model imposes no location-specific capacities, costs, or eligibility restrictions**. This absence is essential to the reformulation.

## Original formulation

### Variables

The model declares **463 integer variables**, each initially bounded by `0..100000`:

- **456 local counts:** six component counts at each of 76 locations.
- **Six global counts:** total instances of each component type.
- **One objective variable.**

### Constraints

Six aggregation equations equate each global count to the sum of its local counts.

A large conjunctive specification imposes the deployment requirements:

- Exactly **two query services**, with at most one query per location.
- At least one platform service, load balancer, and service provider.
- Every location containing a query must also contain a deployment service.
- Every location containing a service provider must also contain a platform service.
- Queries may share a location only with deployment services.
- Load balancers and infrastructure services must each be isolated from all other component types.
- Platform services may share a location only with service providers.

The original specification expresses local violations through sums of Boolean indicators constrained to zero. Since every indicator is nonnegative, these equations prohibit each violation individually.

### Objective

Writing the global totals as \(P,B,D,S,Q,I\), respectively, the objective is

\[
\min\; 2(P+B+S+Q)+D+I.
\]

This follows from the original expression, which adds all local counts and then adds the platform, load-balancer, service-provider, and query totals again. Consequently, those four types have weight two; deployment and infrastructure services have weight one. The objective retains its original upper bound of \(100000\).

## Reformulation and justification

### 1. Exact aggregation of location decisions

The reformulated model retains the six global counts and the objective, eliminating the **456 local decision variables** from optimization.

The necessary aggregate requirements are

\[
Q=2,\qquad P\ge1,\qquad B\ge1,\qquad S\ge1,\qquad D\ge2,\qquad I\ge0.
\]

The first four requirements appear directly in the original specification. The deployment lower bound follows from three original conditions:

1. There are exactly two queries.
2. Each location contains at most one query.
3. Each query location contains at least one deployment service.

Thus the queries occupy two distinct locations, requiring at least two deployment instances.

These aggregate conditions are also **sufficient**, not merely a relaxation. Any tuple satisfying them and the retained variable and objective bounds can be realized as follows:

| Original location | Assigned components |
|---|---|
| 0 | One query and \(D-1\) deployment services |
| 1 | One query and one deployment service |
| 2 | All \(P\) platform services and all \(S\) service providers |
| 3 | All \(B\) load balancers |
| 4 | All \(I\) infrastructure services |
| Remaining locations | No components |

This construction satisfies every co-location and isolation rule. Each local count remains within its original domain because it is no larger than its corresponding bounded global total. It is valid to use these locations regardless of their names because the supplied model contains no restrictions distinguishing their capabilities.

The reduction is therefore an **exact projection onto global component totals**, supported by a constructive solution-lifting rule. It preserves every feasible aggregate tuple and its objective value, although it does not enumerate every original placement.

### 2. Objective simplification

The long sum over local variables is replaced by the equivalent weighted expression over global totals. The six original aggregation equations justify this substitution exactly; neither the objective value nor the minimization direction changes.

### 3. Valid objective lower bound

The reformulation adds

\[
\text{objective}\ge12,
\]

because

\[
2(P+B+S+Q)+D+I
\ge 2(1+1+1+2)+2+0=12.
\]

The tuple \(P=B=S=1,\ Q=D=2,\ I=0\) attains this bound using the construction above, so **12 is the optimal objective value**.

### 4. Solution reconstruction

A Python mapping script restores all original local counts using the stated placement construction, restores the global variables, and computes the original objective. The fixed query total is reconstructed directly from the original requirement \(Q=2\), rather than relying on its presence in solver output.

## Expected computational effect

The resulting formulation has **seven bounded integer variables** and only linear aggregate constraints. It removes the location-level logical encoding and the many equivalent placement choices, leaving a small integer linear optimization problem suitable for HiGHS.

The improvement comes from **problem-specific aggregation, implied-bound preprocessing, algebraic objective simplification, and constructive reconstruction**. No additional assumptions about cloud hardware or service compatibility are introduced.

## Background and interpretation

This instance comes from **Zephyrus**, a tool for synthesizing cloud-application deployments. It represents a Fredhopper Cloud Services application using six component types: platform, load balancer, deployment, service provider, query, and infrastructure services.

The task is to choose component counts at **26 named locations**, satisfying requirements about which services must exist and which may share a location. Although location names refer to different virtual-machine types, this supplied model contains **no machine-capacity constraints or location-dependent costs**. Those properties therefore cannot be inferred from the names.

## Original model

The original formulation declares **163 integer variables**, all initially bounded between 0 and 100000:

- 156 local component counts: six types at each of 26 locations;
- six global component totals;
- one objective variable.

Six aggregation equalities connect each global total to its local counts. A large conjunction expresses the application requirements through sums of Boolean violation indicators, each required to equal zero. These requirements imply:

- Exactly **20 query services**, with at most one per location.
- At least one platform, load-balancer, and service-provider component globally.
- A query requires at least one deployment component at its location.
- A service provider requires at least one platform component at its location.
- Queries may share locations only with deployment components.
- Platforms may share locations only with service providers.
- Load balancers and infrastructure components must each be isolated from every other component type.

There is no requirement to install an infrastructure component.

Writing the global totals as \(P,L,D,S,Q,I\), the objective is

\[
\min\; 2(P+L+S+Q)+D+I.
\]

This follows because the original objective adds all local counts and then adds the global platform, load-balancer, service-provider, and query counts again. Its declared upper bound of 100000 is also a feasibility restriction.

## Reformulation and justification

### Indexed representation and solution mapping

The scalar local counts were reorganized into a **location-by-component array**, with an explicit correspondence to every original location and component name. Global totals remain constrained to equal column sums.

The accompanying Python mapping reconstructs every original local variable from its array entry, computes the six original global totals, and reconstructs the original objective. This changes the representation, not the deployment decisions or their meanings.

### Replacing violation indicators with linear constraints

A sum of nonnegative Boolean indicators equals zero precisely when every indicated violation is false. This permits replacing the original nested expressions with direct local restrictions.

In particular:

- The prohibition on query counts greater than one gives \(0\le q_i\le1\).
- Since \(q_i\) is binary and deployment counts are nonnegative integers, “a query requires deployment” becomes \(d_i\ge q_i\).
- The incompatibilities partition occupied locations into four mutually exclusive groups:
  1. platform, optionally with service provider;
  2. load balancer;
  3. deployment, optionally with query;
  4. infrastructure.

The reformulation introduces **104 binary presence variables**, four per location. Lower and upper linking inequalities make each indicator equivalent to positive presence of its group’s principal component. Their sum is at most one at each location. Additional links allow service providers only in the platform group and queries only in the deployment group.

This formulation preserves the original compatibility rules while avoiding the large collection of nested reified expressions.

### Valid lower bounds and counting inequalities

Exactly 20 queries, together with the one-query-per-location restriction, require **20 distinct query locations**. Each needs a deployment component, so

\[
D\ge20.
\]

The required platform, load-balancer, and service-provider totals satisfy \(P,L,S\ge1\), while \(Q=20\) and \(I\ge0\). Substitution into the objective yields the valid bound

\[
2(P+L+S+Q)+D+I
\ge 2(1+1+1+20)+20
=66.
\]

The reformulation also explicitly requires at least 20 deployment-group locations, one platform-group location, and one load-balancer-group location. These are consequences of the original requirements, not additional assumptions.

### Objective-based upper-bound tightening

The original objective limit of 100000 and the mandatory component costs provide valid bounds for presence linking:

| Component count | Valid upper bound | Mandatory objective contribution from other components |
|---|---:|---:|
| Platform, load balancer, or service provider | 49968 | 64 |
| Deployment | 99954 | 46 |
| Infrastructure | 99934 | 66 |

For example, components other than platforms contribute at least \(40+20+2+2=64\): 20 queries counted twice, 20 deployments, one load balancer counted twice, and one service provider counted twice. Hence \(2P+64\le100000\), giving \(P\le49968\). The other bounds follow in the same way. Every local count is no larger than its global total, so these bounds are valid locally as well.

These tighter linking constants and the explicit counting inequalities strengthen the mixed-integer formulation for HiGHS. **No feasible original deployment is intentionally removed, no location symmetry is imposed, and no optimal component counts are fixed in advance.**

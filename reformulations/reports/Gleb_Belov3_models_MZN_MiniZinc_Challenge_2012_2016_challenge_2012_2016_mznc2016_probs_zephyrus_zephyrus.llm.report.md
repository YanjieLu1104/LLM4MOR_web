# Zephyrus Component Deployment Model: Reformulation Report

## 1. Problem background

The model represents a **component deployment and connection problem**, such as placing software services on physical or virtual machines.

Each component type can have multiple deployed instances. Components require connections through named ports, while other components supply connections through *multi-provide ports*. A multi-provide port can support several port types and has either a finite capacity or an unlimited capacity, represented by the value `-1`.

Component instances must also be assigned to locations. Locations have resource capacities and activation costs; components consume resources when placed there. Conflicts prohibit certain combinations of component types. The objective is to find a feasible deployment with **minimum total cost of activated locations**.

This interpretation is inferred from the model structure. No particular application, resource units, or instance sizes are supplied.

## 2. Original formulation

Let \(C\), \(M\), \(P\), and \(L\) be the numbers of component types, multi-provide ports, ports, and locations.

### Decision variables

The original model declares:

| Variable | Meaning | Number |
|---|---|---:|
| `bindings` | Connection counts by multi-provide port, required port, provider type, and requiring type | \(MPC^2\) |
| `comps_num` | Number of instances of each component type | \(C\) |
| `comp_locations` | Instances of each component type assigned to each location | \(LC\) |
| `used_locations` | Binary indicators of location activation | \(L\) |
| `sum_comp` | Total number of component instances | 1 |
| `objective` | Total activated-location cost | 1 |

Thus, there are \(MPC^2+C+LC+L+2\) original integer variables before flattening. Counts are bounded by `MAX_INT = 4096`; importantly, this bound also applies to the **total** component count.

### Constraints

The main constraint groups are:

- **Connection compatibility:** bindings are zero when a multi-provide port does not support the required port.
- **Provider capacity:** finite providers limit outgoing bindings; unlimited providers can supply bindings only when present.
- **Requirement balance:** each component type receives exactly its instance count multiplied by its per-instance port requirements.
- **Conflicts:** specified provider–consumer combinations cannot coexist.
- **Binding uniqueness:** aggregate connections between component types are restricted according to provider counts and requirements, with special treatment of connections within the same component type.
- **Placement consistency:** location assignments sum to each component type’s total count.
- **Location activation and resources:** a location is active exactly when nonempty, and resource consumption cannot exceed its capacity.
- **Location ordering:** locations with identical resource capacities are lexicographically ordered, with cost-dependent precedence.
- **Instance-specific requirements:** at least one instance of component 1 or 2 must be deployed, and each location may contain at most one instance each of components 3 and 4.

The objective minimizes
\[
\sum_{\ell\in\mathrm{locations}}
\mathrm{costs}_{\ell}\,\mathrm{used\_locations}_{\ell}.
\]
The original objective bounds accommodate negative as well as positive location costs.

## 3. Reformulation and justification

### Explicit component-presence indicators

The reformulation adds one binary variable \(z_c\) per component type and imposes
\[
z_c\le n_c\le4096z_c,
\]
where \(n_c=\texttt{comps\_num}[c]\).

Because \(n_c\) is a nonnegative integer bounded by 4096, these inequalities give exactly \(z_c=1\) if and only if \(n_c>0\).

For an unlimited provider, the original implication “provider absent implies binding zero” becomes
\[
b\le4096z_c.
\]
This is equivalent: when the provider is absent, the binding must be zero; when present, the inequality reproduces the binding’s original upper bound.

### Consolidation and linearization of conflicts

All ports establishing the same ordered component conflict are combined into one binary inequality:
\[
z_p+z_r\le1.
\]

The original conflict implication forbids simultaneous presence, so this inequality is equivalent. Duplicate port-level constraints therefore need not be generated separately.

The original formulation includes diagonal conflicts, where provider and conflicting component are the same type. In that case, its implication forces the component count to zero. The new inequality becomes \(2z_c\le1\), with the same effect. Consequently, the original additional self-conflict bound \(n_c\le1\) is redundant and is removed.

### Stronger binding-uniqueness formulation

Let \(q\) be the sum of a requiring component’s requirements over ports supported by a particular multi-provide port, and let \(B\) be the corresponding aggregate binding count.

For different component types, the reformulation adds the unconditional bound
\[
B\le qn_r.
\]
When \(n_p\ge q\), this is already an original constraint. When \(n_p<q\), the original enumerated case gives \(B\le n_pn_r\), which implies the new bound because \(n_r\ge0\).

For the same component type, the reformulation uses
\[
B\le q(n_c-z_c).
\]
For positive counts, this matches the original large-count branch or is implied by its small-count bound \(B\le n_c(n_c-1)\). At zero count, all outgoing bindings are already zero: this follows from the original provider-capacity or provider-activation constraints.

The remaining enumerated cases are reduced as follows:

- Counts above 4096 are unreachable under the original domains.
- Cases at or above \(q\) are covered by the unconditional bounds.
- The zero-provider case already has zero outgoing bindings.
- The same-type count-one case is enforced by the new bound.
- Enumeration is unnecessary when provider capacity is zero or no port is supported, because the original constraints already fix all relevant bindings to zero.

These reductions do not require an additional assumption that input requirements are nonnegative.

### Linear location activation

The original nonempty-location equivalence is replaced by
\[
u_\ell\le\sum_c x_{\ell c}\le4096u_\ell.
\]

The upper bound is valid because placement consistency and nonnegativity imply that every location’s component count is at most `sum_comp`, which is bounded by 4096. With integral nonnegative assignments and binary \(u_\ell\), the inequalities enforce exactly the original equivalence.

### Preserved structure and solution interface

Resource constraints, requirement balances, placement requirements, objective values, optimization direction, and the original location-ordering constraints are retained. The CP-oriented search annotation is removed, leaving search to HiGHS.

All original decision variables remain available. The supplied mapping script copies their encoded values unchanged and excludes the auxiliary presence variables.

Overall, the reformulation uses **explicit binary activation, duplicate-constraint elimination, implied linear inequalities, and domain-based pruning of enumerated implications**. These changes aim to reduce logical reformulation overhead and improve the mixed-integer formulation; no instance-specific runtime improvement has been established.

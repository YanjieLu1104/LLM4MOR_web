# SPOT5 Satellite Observation Scheduling: Reformulation Report

## Background and interpretation

The model represents a SPOT5 Earth-observation satellite planning problem. The operational goal is to select photographs and their acquisition configurations while respecting restrictions such as instrument conflicts, transition times, and telemetry limitations.

These operational restrictions are supplied as **allowed-assignment tables**, rather than explicit timing or resource equations. Each photograph has an integer assignment variable whose permitted values are given by the instance. Value `0` receives special treatment in the objective; in the intended application, it represents a photograph not selected. Other values represent acquisition choices, although their precise instrument meanings are not specified in the model.

The source explicitly states that memory consumption is not included in the objective. The reformulation does not introduce any additional operational assumptions or resource constraints.

## Original mathematical model

Let \(n=\texttt{num_variables}\).

### Variables and domains

The original model declares:

- \(n\) integer variables \(p_j\), each initially bounded by `min_domain..max_domain`;
- one integer variable `objective`.

Each assignment also satisfies
\[
p_j\in \texttt{domains}[j].
\]
Consequently, its effective domain is the intersection of its declared integer bounds and its instance-specific domain.

### Compatibility constraints

The model contains:

- `num_constraints2` binary allowed-tuple constraints;
- `num_constraints3` ternary allowed-tuple constraints.

Each constraint identifies two or three assignment variables through scope arrays and requires their joint values to appear in its supplied table. Tables are stored in flattened arrays, with tuple counts and offsets identifying the rows belonging to each constraint.

The source does not provide instance data, so numerical domain sizes and table sizes cannot be reported.

### Objective

The optimization direction is minimization:
\[
\min\ \texttt{objective}
=
\sum_{j=1}^{n}\texttt{costs}[j]\,[p_j=0].
\]

For nonnegative costs, this penalizes omitted photographs and is equivalent to maximizing the total weight of selected photographs. However, the model permits negative costs as well. The reformulation therefore preserves the stated objective exactly rather than assuming all weights are positive.

The objective bounds are the sum of negative costs and the sum of positive costs, respectively. These are valid because every cost is multiplied by a binary indicator.

## Reformulation and justification

The revised model replaces generic table constraints with an explicit mixed-integer linear formulation suitable for HiGHS. It retains the original `p` and `objective` variables and the external data interface.

### 1. Effective-domain preprocessing

For each variable, the reformulation computes
\[
D_j=\texttt{domains}[j]\cap
[\texttt{min_domain},\texttt{max_domain}].
\]

This is exact: the original variable declaration imposes the interval bounds, while the original membership constraint imposes `domains[j]`. A value outside their intersection cannot occur in any original feasible solution.

### 2. Removal of impossible table rows

A table row is discarded if:

- any entry lies outside the effective domain of its scoped variable; or
- two positions refer to the same variable but assign it different values.

The first rule follows directly from the original domain constraints. The second follows from the fact that a single variable cannot simultaneously take two distinct values. Thus, neither rule removes a row that could support an original feasible assignment.

If no rows remain in a required table, the reformulation is infeasible, as the original model must also be.

### 3. Sparse binary value encoding

For every \(v\in D_j\), the formulation introduces a binary variable \(x_{jv}\), with
\[
\sum_{v\in D_j}x_{jv}=1,
\qquad
p_j=\sum_{v\in D_j}v\,x_{jv}.
\]

These equations select exactly one permissible value and retain its original integer meaning. Conversely, any original feasible value of \(p_j\) determines such an indicator assignment.

The objective becomes
\[
\texttt{objective}
=
\sum_{j:\,0\in D_j}\texttt{costs}[j]\,x_{j0}.
\]
This is identical to the original expression: when zero is absent from a domain, the corresponding original indicator is necessarily zero.

### 4. Continuous table-row weights and marginal equalities

For every retained row \(t\) of a table, the reformulation introduces a continuous weight \(\lambda_t\in[0,1]\). It requires
\[
\sum_t\lambda_t=1.
\]

For each scoped variable and each of its effective-domain values, a marginal equality links the row weights to the corresponding value indicator:
\[
\sum_{t:\,t\text{ assigns }v\text{ to }j}\lambda_t=x_{jv}.
\]

**Why continuous weights are sufficient:** when the value indicators are integral, each scoped variable selects exactly one value. Every unselected value has marginal zero. Since row weights are nonnegative, a row containing any unselected value must therefore have zero weight. The normalization equation forces positive weight on at least one row matching all selected values, proving that the assignment belongs to the original table.

Conversely, an assignment satisfying the original table can give weight one to a matching row and zero to all other rows. Hence the formulation preserves all original feasible assignments and objective values.

These marginal equalities form a local convex-hull representation of each table in value-indicator space. They provide stronger information than linking table weights only to numerical averages of assignment values. They do not imply that the relaxation of the complete interconnected model is integral.

## Expected effect and solution correspondence

The reformulation aims to improve HiGHS performance through:

- elimination of impossible table rows before solving;
- explicit linear objective and assignment equations;
- strong value-level links between compatibility tables;
- continuous, rather than integer, auxiliary table-row variables.

It introduces one binary indicator per effective variable-value pair and one continuous weight per retained table row. Whether this improves runtime depends on the supplied domains and table sizes; no computational speedup has been established here.

The original assignment and objective variables remain available in the solution output. The supplied mapping script copies only `p` and `objective`, preserving their encoded values and array indices, and reports missing fields instead of fabricating a solution.

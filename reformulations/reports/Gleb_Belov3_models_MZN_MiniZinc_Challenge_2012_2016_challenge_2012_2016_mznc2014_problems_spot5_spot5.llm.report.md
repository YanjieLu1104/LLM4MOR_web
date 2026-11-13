# SPOT5 Satellite Observation Scheduling: Reformulation Report

## Background

The model represents a satellite observation-selection problem inspired by SPOT5 earth-observation scheduling. Candidate photographs have associated priorities, and their acquisition choices must respect operational compatibility restrictions, such as instrument conflicts, transition times, and instantaneous data-flow limits.

Each photograph is represented by an integer assignment. Value `0` denotes non-selection, while other admissible values encode acquisition choices. The precise meaning of each nonzero value is supplied implicitly through the instance domains and compatibility tables.

The model does not explicitly represent observation times, instrument trajectories, or recording-capacity consumption. Instead, operational restrictions are encoded as allowed combinations of two or three assignments. The source explicitly notes that memory consumption is not included in the objective.

## Original Formulation

### Variables and data

The model declares:

- `num_variables` integer assignment variables, `p[j]`, initially bounded by `min_domain..max_domain`.
- One integer variable, `objective`.
- An individual allowed-value set, `domains[j]`, and an integer cost, `costs[j]`, for each assignment.
- Binary and ternary compatibility tables, stored as flattened arrays with scope indices, tuple counts, and offsets.

No instance data were provided, so numerical variable-domain sizes and table sizes cannot be reported.

### Constraints

The original formulation contains:

1. **Individual domain restrictions:**  
   Each `p[j]` must belong to `domains[j]`, in addition to its declared bounds.

2. **Binary table constraints:**  
   Each of the `num_constraints2` constraints requires a pair of scoped assignments to match an allowed row.

3. **Ternary table constraints:**  
   Each of the `num_constraints3` constraints similarly requires three scoped assignments to match an allowed row.

4. **Objective definition:**
   \[
   \text{objective}
   =\sum_j \text{costs}[j]\,[p[j]=0].
   \]

The objective bounds are the sum of negative costs and the sum of positive costs, respectively. These bounds are valid because each cost contributes either its full value or zero.

### Optimization direction

The model **minimizes** the cost of assignments equal to zero. When costs are nonnegative observation priorities, this minimizes lost priority and is equivalent to maximizing the priority of selected observations. The formulation also permits negative costs; the reformulation preserves their original meaning without assuming positivity.

## Reformulation and Preprocessing

The reformulation replaces generic table constraints with an explicit mixed-integer linear formulation intended for the HiGHS backend.

### 1. Intersect individual domains with declared bounds

For each assignment, the effective domain is
\[
D_j=\text{domains}[j]\cap
\{\text{min_domain},\ldots,\text{max_domain}\}.
\]

This is exact: the original model already requires both membership in `domains[j]` and satisfaction of the declared bounds. Values outside their intersection cannot occur in any original feasible solution.

### 2. Introduce binary assignment indicators

For every \(v\in D_j\), a binary variable \(x_{jv}\) indicates whether `p[j]` equals \(v\). The reformulation imposes
\[
\sum_{v\in D_j}x_{jv}=1,
\qquad
p[j]=\sum_{v\in D_j}v\,x_{jv}.
\]

Exactly one admissible value is therefore selected, and the original assignment variable retains that value. Conversely, every original feasible assignment has a corresponding indicator assignment.

An empty effective domain makes the first equality infeasible, correctly preserving the infeasibility of the original domain restrictions.

### 3. Remove impossible table rows

Before encoding each table, the reformulation removes rows that:

- Contain a value outside the effective domain of its scoped variable.
- Assign different values to repeated occurrences of the same variable within the table scope.

Both removals preserve every feasible solution. The first follows directly from the original variable-domain restrictions. The second follows because a single original variable cannot simultaneously take two different values.

No row is removed because of costs or an assumed preference for particular acquisition choices.

### 4. Replace tables with continuous tuple weights and marginal equalities

For each surviving table row \(r\), the model introduces a continuous weight
\[
0\leq \lambda_r\leq 1,
\qquad
\sum_r\lambda_r=1.
\]

For every scope position and admissible value \(v\), a marginal equality links the table weights to the corresponding assignment indicator:
\[
\sum_{r:\,r\text{ uses }v\text{ at that position}}\lambda_r=x_{jv}.
\]

**Why continuous weights are sufficient:** once the assignment indicators are integral, every unselected value has indicator zero. Nonnegativity then forces every row containing an unselected value to have zero weight. Because the remaining weights must sum to one, at least one allowed row must match the selected assignment at every position.

Conversely, any assignment satisfying the original table can place weight one on a matching row and zero on all other rows. Thus the encoding is exact without making tuple weights binary.

If preprocessing removes every row, the weight-normalization constraint becomes infeasible, as required for an impossible original table.

### 5. Express the objective directly through indicators

The objective becomes
\[
\text{objective}
=\sum_{j:\,0\in D_j}\text{costs}[j]\,x_{j0}.
\]

This equals the original objective because \(x_{j0}=1\) exactly when `p[j]=0`. If zero is absent from \(D_j\), the original equality test is necessarily false and its contribution is zero.

## Expected Benefits and Preservation

The formulation exposes assignment choices and table consistency directly as linear constraints. Its marginal equalities describe convex combinations of allowed rows and link those combinations across tables through shared assignment indicators. Tuple weights remain continuous, avoiding a requirement for one binary variable per table row. Preprocessing also reduces the number of rows that need encoding.

Actual performance depends on domain sizes, table sizes, and the backend’s original table decomposition; no runtime improvement was measured here.

The reformulation preserves the external data interface, original assignment and objective variables, objective bounds, and minimization direction. The mapping script returns the original `p` and `objective` values and excludes auxiliary variables. No additional problem-specific cuts or assumptions were introduced.

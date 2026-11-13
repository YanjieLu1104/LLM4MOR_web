# Liner-Shipping Fleet Repositioning: Model and Reformulation

## Background

The model represents a **liner-shipping fleet repositioning problem**. Nine vessels leave existing services at selected phase-out opportunities and join a new service at a common phase-in port. Each vessel chooses its own joining week.

The embedded data specify 13 candidate phase-in ports and an 11-week planning horizon. Each vessel has its own phase-out opportunities, with departure times and sailing costs indexed by departure opportunity, destination port, and joining week. Negative sailing-cost entries indicate prohibited combinations.

The joining schedule must use nine distinct, consecutive weeks, consistent with establishing a weekly service. The objective combines sailing expenditure with a time-dependent “hotel” cost between phase-out and phase-in. Although the comments mention more precise hotel rates, the actual model uses integer rates of **88 for the first three vessels and 66 for the other six**; the reformulation preserves those coefficients.

Despite its parameter declarations, this particular model is self-contained: dimensions, schedules, and cost tables are assigned within the source.

## Original Formulation

### Variables

The original model has **37 independent integer variables**:

| Variables | Number | Meaning |
|---|---:|---|
| `poAct0`–`poAct8` | 9 | Selected phase-out opportunity for each vessel |
| `piPort` | 1 | Common phase-in port |
| `piWeek` | 9 | Phase-in week of each vessel |
| `reposType` | 9 | Repositioning method |
| `directCost` | 9 | Sailing cost of each vessel |

A further integer variable, `objective`, is defined by the total-cost expression.

### Constraints

- **Repositioning method:** Each method variable has domain `1..3`, but constraints exclude methods 2 and 3. Therefore, every vessel must use method 1.
- **Sailing feasibility and cost:** Nine variable-indexed table lookups link each vessel’s departure opportunity, common destination, and joining week to its sailing cost. The nonnegative cost domains exclude negative table entries.
- **Weekly service:** An `alldifferent` constraint makes joining weeks distinct. The additional equality  
  \[
  \max_v w_v-\min_v w_v=8
  \]
  makes the nine distinct integer weeks consecutive.
- **Objective domain:** The defined objective is constrained to be nonnegative and bounded above by the original bound expression.

### Objective

The model minimizes
\[
\sum_{v=1}^{9}
\left[
c_v(a_v,p,w_v)
+h_v\bigl(T^{\mathrm{in}}_{p,w_v}-T^{\mathrm{out}}_{v,a_v}\bigr)
\right],
\]
where \(a_v\) is the selected departure opportunity, \(p\) is the common destination, \(w_v\) is the joining week, and \(h_v\) is the vessel’s hotel-cost coefficient.

## Reformulation

The reformulation targets **HiGHS**, a mixed-integer linear optimization solver. It replaces variable-indexed cost constraints and the consecutive-week condition with an explicit binary assignment formulation.

### 1. Fixing the repositioning methods

The two exclusions on each `reposType` variable are replaced by equality to 1.

This follows directly from the original domain: removing 2 and 3 from `1..3` leaves only 1. The original variables remain declared, preserving their names and meaning.

### 2. Removing prohibited assignment tuples

For each vessel, the formulation creates binary selectors only for tuples
\[
(\text{phase-out opportunity},\text{phase-in port},\text{week})
\]
whose sailing cost is nonnegative.

This is exact preprocessing, not a cost-based heuristic. In the original formulation, selecting a negative-cost tuple would force a nonnegative `directCost` variable to equal a negative number, which is impossible.

### 3. Filtering ports with insufficient available weeks

The supplied tables prohibit every tuple whose phase-in schedule entry is zero. Consequently, a feasible destination must have at least nine nonzero schedule entries: nine vessels require nine different joining weeks at that same port.

The reformulation excludes ports failing this necessary condition. For these embedded data, this retains ports 1–4. The test does **not** assert that all retained ports are feasible; the assignment and scheduling constraints still enforce vessel-specific feasibility.

### 4. Sparse binary assignment and channeling

Exactly one admissible tuple is selected for each vessel. Weighted sums of its binary selectors recover the original departure choice, joining week, sailing cost, and hotel-cost contribution.

Additional marginal equalities link:

- each vessel’s selected destination to a shared one-hot port indicator;
- each vessel’s selected week to its vessel–week indicator.

Thus, every integer assignment selects one original table entry, and every original feasible choice has a corresponding assignment. The formulation exposes these relationships as linear equalities rather than relying on the backend’s translation of multidimensional element constraints.

### 5. Selecting a consecutive nine-week window

The formulation selects exactly one nine-week window within the 11-week horizon. For each week, total vessel occupancy equals 1 if the selected window covers that week and 0 otherwise.

This is equivalent to the original scheduling constraints. Nine distinct integers with maximum-minus-minimum equal to eight must occupy every integer in that interval. Conversely, placing one vessel in each week of a nine-week window gives distinct weeks with that same range.

The replacement avoids explicit minimum, maximum, and pairwise distinctness machinery in the MIP formulation.

### 6. Compact representation of fixed tables

The cost data are represented through weekly profiles and vessel-specific shifts, expanding back into arrays with the original names and index domains. This exploits repeated data patterns; it is intended as lossless storage compression, not a replacement of costs by estimates or minimum-cost representatives.

No phase-out opportunity is removed merely because it appears expensive or duplicates another opportunity. Such removal could interfere with externally fixed original decision variables.

## Solution Interface and Expected Benefit

All original independent variables remain in the model. The mapping script copies their solver-emitted values, except for `reposType`, which it reconstructs as nine ones from the original method restrictions. This reconstruction also handles compiler removal of that fixed array. Auxiliary assignment variables are not required by the mapping.

The expected benefit is a more direct, sparse MIP formulation with explicit assignment and occupancy equations. It introduces binary variables, but removes prohibited alternatives before optimization and avoids less transparent translations of table lookups and scheduling globals. **No runtime improvement has been established by benchmarking in this conversation.**

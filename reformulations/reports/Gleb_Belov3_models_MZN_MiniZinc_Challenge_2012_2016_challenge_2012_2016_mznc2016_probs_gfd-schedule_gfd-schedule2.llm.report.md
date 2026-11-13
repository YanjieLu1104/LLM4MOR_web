## Problem background

The model describes batch scheduling for items that require processing or testing at shared facilities. Each item has a kind, a production day, a preferred deadline, and a set of eligible facilities.

Items can share a processing group only if they have the same kind. Each used group occupies one facility for one day, and that facility must be eligible for every item in the group. A facility can process at most one group on a given day. A separate daily capacity limits the total number of processed **items**, regardless of how they are grouped.

Processing must occur strictly after an item’s production day. Deadlines are soft: processing after a deadline incurs a penalty proportional to the number of late days. The scheduling objective balances this tardiness against the number of groups, which represents facility uses.

## Original formulation

### Decision variables

The model declares \(4N+3\) top-level integer decision variables:

- `assignedGroup[i]`: the group assigned to item \(i\).
- `groupFacility[g]`: the facility assigned to group \(g\), with zero indicating an unused group.
- `groupProcessDay[g]`: the processing day of group \(g\), also zero for an unused group.
- `itemProcessDay[i]`: the processing day of item \(i\).
- `nGroups`: the number of distinct groups used.
- `deadLinePenalty`: total item tardiness.
- `objective`: the weighted objective value.

These counts exclude local variables and auxiliaries introduced during compilation.

### Constraints

The original formulation uses variable-indexed array expressions to connect each item to its group’s day and facility. Its remaining constraints enforce:

- **Kind compatibility:** items of different kinds cannot share a group. Each kind also receives a disjoint block of group labels.
- **Unused-group encoding:** a group is unused exactly when both its facility and day are zero.
- **Group-label symmetry restrictions:** within each kind’s block, item assignments are bounded by their position among same-kind items, and used groups precede unused groups.
- **Facility eligibility:** an item’s assigned group must use one of that item’s eligible facilities.
- **Facility exclusivity:** unit-duration `cumulative` constraints prevent two groups from occupying the same facility on the same day.
- **Release dates:** processing occurs strictly after production.
- **Daily item capacity:** `at_most` constraints limit the number of items processed each day.
- **Accounting:** `nvalue` counts used groups, and piecewise expressions calculate tardiness.

### Objective

The model minimizes
\[
100\sum_{i=1}^{N}\max(0,\;itemProcessDay_i-deadLineDay_i)
+nGroups.
\]

This is a **weighted sum**, not necessarily a lexicographic objective. The original bound
\[
0\le deadLinePenalty\le
dlp\_max=\sum_i(MaxDay-deadLineDay_i)
\]
is retained exactly, together with the original objective bounds.

## Reformulation and justification

The reformulation targets the HiGHS mixed-integer linear solver. It replaces scheduling globals and variable-indexed relationships with sparse binary selectors and linear constraints, while retaining all original decision variables and external parameter declarations.

### 1. Kind-block preprocessing

An item–group selector is created only when the group belongs to the item’s original kind-specific block.

This is valid because the original model already restricts every item to that block. Blocks for different kinds are disjoint, so items of different kinds cannot select the same group. Consequently, the explicit cross-kind pairwise inequalities become redundant.

The reformulation computes these blocks directly from comparisons among the supplied kind values, avoiding iteration over absent integer kind values.

### 2. Release-date and tardiness-bound preprocessing

Candidate processing days for item \(i\) are restricted to
\[
\max(1,\;producedDay_i+1)
\le d\le
\min(MaxDay,\;deadLineDay_i+dlp\_max).
\]

The lower bound follows from the original day domain and strict production-date constraint. The upper bound follows because each item’s tardiness is nonnegative and cannot exceed their total, which the original model bounds by `dlp_max`. Thus
\[
\max(0,d-deadLineDay_i)\le dlp\_max.
\]

An empty candidate interval correctly makes the reformulated model infeasible; no feasible original schedule is removed.

### 3. Sparse group–facility–day choices

Binary selectors represent a group choosing a particular facility and day. A candidate choice is retained only if at least one item in the group’s kind block could use that facility on that day.

This pruning is valid because every used group must contain an item. Any occupied facility–day choice must therefore be compatible with at least one potential member. Additional assignment constraints require the selected choice to be compatible with **every item actually assigned** to the group.

The original group facility and day variables are recovered through weighted sums of these selectors. An unused group selects no choice and therefore has facility and day zero.

### 4. Linear assignment and day channeling

Each item selects exactly one admissible group and exactly one admissible processing day. Weighted sums connect these selectors to the original item variables.

Bound-derived big-\(M\) inequalities equate an item’s day with its selected group’s day. When an assignment selector is one, both inequalities force equality. When it is zero, the constants are sufficient to cover the full difference between the applicable item-day bounds and the group-day domain, so they impose no additional restriction.

### 5. Linear resource capacities

For each facility and day, the sum of selected group choices is at most one. This is equivalent to the original facility-specific `cumulative` constraints because group durations are exactly one day and start times are integers.

For each day, the sum of item-day selectors is at most `MaxItemsPerDay`. This directly expresses the original `at_most` item-capacity constraint.

### 6. Used-group indicators and strengthening inequalities

A binary indicator records whether each group is used. Assignment and occupancy constraints ensure that the indicator is one exactly when the group contains an item. Summing these indicators therefore replaces `nvalue` without changing `nGroups`.

The formulation also includes
\[
\text{items assigned to group }g
\le
\min(MaxItemsPerDay,\;\text{number of items in its kind})
\,\text{used}_g.
\]

This is valid because all members of a group are processed on the same day, so the group cannot exceed the daily item capacity. It also cannot contain more items than exist in its kind. These inequalities strengthen the linear relaxation.

### 7. Exact tardiness and preserved symmetry restrictions

Tardiness is computed as a weighted sum of item-day selectors, using the constant coefficient
\[
\max(0,d-deadLineDay_i).
\]
Exactly one day is selected per item, so this reproduces the original penalty exactly rather than merely bounding it.

The original item-position symmetry restrictions are retained. The pairwise used-before-unused restrictions are replaced by adjacent monotonicity inequalities within each kind block. This is equivalent because adjacent inequalities imply all pairwise inequalities by transitivity, and the original pairwise system includes the adjacent cases.

## Interface preservation and expected effect

All original decision variables remain available. The mapping script copies those seven original variable fields—including the four arrays—and excludes reformulation auxiliaries. No instance-specific reconstruction is required.

The main computational trade-off is additional time-indexed binary variables in exchange for an explicit linear formulation of assignment, occupancy, capacity, and tardiness. Sparse preprocessing reduces their number, and group-size inequalities strengthen the relaxation. These changes are intended to improve HiGHS performance; no solve-time improvement has been established from the conversation, and long scheduling horizons may make time indexing expensive.

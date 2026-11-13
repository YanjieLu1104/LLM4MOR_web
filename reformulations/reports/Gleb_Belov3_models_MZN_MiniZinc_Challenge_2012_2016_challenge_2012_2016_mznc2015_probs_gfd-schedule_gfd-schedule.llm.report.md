# Grouped Facility Scheduling: Model and Reformulation

## 1. Background and interpretation

The model describes batch processing or testing of items at a collection of facilities. Each item has a kind, a production day, a deadline, and a set of eligible facilities.

Items are partitioned into groups. All items in a group must have the same kind, and the group is processed at one facility on one day. Its facility must be eligible for every member. Processing must occur strictly after each member’s production day.

Two resource restrictions apply:

- A facility can process at most one group on a given day.
- The total number of items processed on a day cannot exceed `MaxItemsPerDay`.

Deadlines are soft: processing after a deadline contributes tardiness rather than automatically making the schedule infeasible. The comments suggest an intention to discourage both tardiness and excessive facility use through fewer groups. However, the executable objective does not implement that intention.

## 2. Original formulation

### Variables

The original model declares **\(4N+3\) scalar integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `assignedGroup` | \(N\) | Group assigned to each item |
| `groupFacility` | \(N\) | Facility assigned to each potential group; zero denotes an unused group |
| `groupProcessDay` | \(N\) | Processing day of each potential group; zero denotes an unused group |
| `itemProcessDay` | \(N\) | Processing day of each item |
| `nGroups` | 1 | Number of distinct assigned groups |
| `deadLinePenalty` | 1 | Total item tardiness |
| `objective` | 1 | Independent bounded variable being minimized |

There are up to \(N\) potential groups. Group identifiers are partitioned into contiguous blocks according to item kind.

### Constraints

The main constraint families are:

1. **Assignment–schedule linking:** each item’s processing day equals that of its assigned group.
2. **Kind compatibility:** different kinds cannot share a group. Additional constraints restrict every item to its kind’s group-number block.
3. **Unused-group encoding:** a group has no members if and only if both its facility and day are zero.
4. **Group-label symmetry breaking:** an item’s position within its kind limits its group identifier, and used group labels precede unused labels within each kind.
5. **Facility eligibility:** each item’s assigned group uses a facility from that item’s eligibility set.
6. **Facility exclusivity:** two used groups at the same facility must have different processing days.
7. **Production-date feasibility:** an item is processed strictly after its production day.
8. **Daily item capacity:** each day processes at most `MaxItemsPerDay` items.
9. **Exact tardiness and group counting:**
   \[
   \texttt{deadLinePenalty}
   =\sum_{i=1}^{N}\max(0,\texttt{itemProcessDay}[i]-\texttt{deadLineDay}[i]),
   \]
   while `nvalue` counts distinct values in `assignedGroup`.

The original formulation contains several quadratic pairwise constraint families, together with variable-indexed array accesses and global counting constraints.

### Actual objective semantics

The model minimizes `objective`, whose bounds are derived from the bounds of `deadLinePenalty` and `nGroups`. **There is no constraint linking its value to either quantity.**

Consequently, absent additional external bindings, any feasible schedule can attain the same minimum by setting `objective` to its lower bound. The reformulation deliberately preserves this behavior.

The original bound
\[
\texttt{dlp\_max}=\sum_i(\texttt{MaxDay}-\texttt{deadLineDay}[i])
\]
is also retained exactly. It can restrict feasibility for some input data; replacing it with a different tardiness bound would therefore change the model.

## 3. Reformulation and validity

### Iterate only over kinds present in the data

The reformulation constructs the set of observed kinds instead of iterating over every integer between the smallest and largest kind values.

This is valid because an absent kind has no items and a zero-sized group block. Its original loops impose no constraints. Skipping these values avoids unnecessary preprocessing, particularly when kind identifiers are sparse.

### Remove redundant cross-kind inequalities

The original model separately states that items of different kinds must have different group identifiers.

These inequalities are redundant: the original block restrictions already assign each kind a disjoint interval of group labels. Items belonging to different kinds therefore cannot select the same group. The reformulation retains the block restrictions and removes the redundant pairwise family.

### Introduce explicit group-use indicators

The reformulation adds \(N\) Boolean variables indicating whether each potential group is used. Within each kind’s block, group occupancy satisfies
\[
u_g\leq \sum_i [\texttt{assignedGroup}[i]=g]\leq s_k u_g,
\]
where \(s_k\) is the number of items of that kind.

Thus, \(u_g=1\) holds exactly when the group has at least one member. The indicator also controls facility and day activation:

- An unused group has facility and day zero.
- A used group has positive facility and day.

This is equivalent to the original constraints. Originally, a used group must have a positive facility because its members’ eligibility sets contain only facilities \(1,\ldots,F\). It must also have a positive day because its members’ processing days lie in \(1,\ldots,\texttt{MaxDay}\). An unused group is explicitly required to have both values zero.

Because each used group contributes one distinct assigned label,
\[
\texttt{nGroups}=\sum_g u_g
\]
exactly replaces `nvalue`. This exposes group counting through Boolean indicators and linear occupancy bounds, a formulation suitable for mixed-integer optimization.

### Replace all-pairs group ordering with adjacent ordering

Within a kind, the original symmetry-breaking constraints require every group after an unused group to be unused.

The reformulation enforces only
\[
u_{g+1}\Rightarrow u_g
\]
for adjacent labels. Repeated application implies the original ordering for every pair. Conversely, the original all-pairs ordering includes every adjacent pair. The two formulations are therefore equivalent, while adjacent ordering requires only linearly many constraints per kind.

### Add facility-support preprocessing

Each group’s facility is restricted to zero or the union of eligibility sets of items of its kind.

A used group contains at least one such item, and the original eligibility constraint requires its facility to belong to that member’s eligibility set. It must therefore lie in the union. Zero remains available for unused groups.

This restriction removes unsupported facility values without assuming which items will ultimately share a group.

### Add conflicts for disjoint eligibility sets

Two same-kind items with disjoint facility eligibility sets are explicitly prohibited from sharing a group.

If they shared a group, its single facility would have to belong to both eligibility sets, contradicting their empty intersection. These inequalities make an existing incompatibility explicit and can strengthen propagation and mixed-integer relaxations.

### Add a per-kind group-count lower bound

When `MaxItemsPerDay` is positive, a kind containing \(s_k\) items requires at least
\[
\left\lceil\frac{s_k}{\texttt{MaxItemsPerDay}}\right\rceil
\]
used groups.

Every group is processed on one day, and all its members count toward that day’s item capacity. Hence no group can contain more than `MaxItemsPerDay` items. The bound follows by summing group occupancies. It is added only for positive capacity, avoiding division by zero and making no assumption about nonpositive-capacity instances.

### Simplify production-date and tardiness expressions

The production constraint is expressed directly using `itemProcessDay`. This is equivalent because the assignment–schedule linking equality remains in place.

Tardiness is simplified using the original item-day domain:

- A deadline at or beyond `MaxDay` implies zero tardiness.
- A deadline below day 1 implies tardiness equal to processing day minus deadline.
- Otherwise, tardiness remains the positive part of their difference.

These are exact domain-based simplifications.

## 4. Interface and solution preservation

All original input parameters, decision-variable meanings, bounds, and optimization direction are retained. Facility exclusivity, daily capacity, exact tardiness, and the original group-label symmetry restrictions remain enforced.

The mapping script copies the seven original decision-variable fields and excludes the auxiliary group-use indicators. It requires their values from solver output rather than inventing missing values.

The changes aim to reduce redundant constraints and expose useful counting structure to HiGHS. No instance-specific performance improvement is claimed without benchmarking.

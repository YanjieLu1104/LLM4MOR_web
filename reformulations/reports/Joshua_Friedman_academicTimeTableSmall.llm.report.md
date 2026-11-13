# Academic Timetabling Model: Structure and Reformulation

## 1. Application and interpretation

The model constructs an academic timetable while assigning student groups to required course sections. Each section has attributes such as instructor, room type, meeting-period requirement, laboratory status, and potentially fixed meeting days or times. Student groups have required courses, group sizes, and prescribed total attendance periods.

The timetable must respect room occupancy, instructor conflicts, section enrollment capacities, and student-group conflicts. Laboratories receive additional restrictions governing their meeting day, room, and allowed period combinations. Linked sections can be required to meet simultaneously, while lecture–laboratory relationships constrain enrollment and attendance.

The objective balances scheduling preferences rather than maximizing enrollment or minimizing the number of rooms. It penalizes undesirable instructor times, selected patterns of consecutive teaching days, teaching both the first and seventh periods, and insufficient instructor days off.

Some declared data are unused by the active formulation. In particular, room-capacity limits, minimum section enrollment, office hours, and final-examination scheduling appear only as inactive code or unused declarations. The reformulation does not activate them.

## 2. Original mathematical structure

### Decision variables

The original model is a **binary mixed-integer linear program**: all active decision variables are binary.

| Variables | Meaning |
|---|---|
| `z[s,d,t,r]` | Section `s` meets on day `d`, at time `t`, in room `r`. |
| `x[g,s]` | Student group `g` enrolls in section `s`. |
| `u[g,d,t,s]` | Group `g` attends section `s` at a particular day and time. |
| `w[p,d,t]` | Professor `p` teaches as the primary instructor at a particular day and time. |
| `gapday[s,d]` | A qualifying non-laboratory section meets on a given day. |
| `y1`, `y2` | Laboratory day and day–room activation indicators. |
| `y3` | Professor teaching-day indicator. |
| `tg2`, `tg3`, `y4`, `y5`, `tues` | Indicators allowing penalized timetable patterns. |
| `ptv`, `ptvDoc`, `ptvAdj` | Instructor time-preference violation indicators. |

The assignment domain `Y` includes only section–room combinations with matching room types. The enrollment domain `W` includes only group–section combinations whose course number appears in the group’s course list.

Numerical variable and constraint counts depend on external data. Structurally, `z` has \(|Y|\) entries, `x` has \(|W|\), and `u` has \(|W||days||times|\).

### Constraints

The principal constraint families enforce:

- **Section meeting requirements:** each section receives its prescribed number of periods; specified days and times are honored.
- **Synchronization:** sections sharing a nonzero `double` identifier have equal room-summed schedules.
- **Room occupancy:** at most one section occupies a room in each time slot.
- **Non-laboratory scheduling:** at most one meeting per day.
- **Laboratory scheduling:** all periods occur on one day and in one room when the period requirement is positive, with additional restrictions for two-, three-, and four-period laboratories.
- **Professor schedules:** primary teaching assignments determine `w`, preventing simultaneous primary assignments. Teaching-day and preference indicators are linked to these schedules.
- **Co-instructor restrictions:** a listed co-instructor cannot simultaneously have a primary teaching assignment. Preference violations are also charged for the linked section. These restrictions do **not** make co-instructor activity part of `w`.
- **Group enrollment:** each nonzero required course is assigned exactly one eligible section, subject to section capacities and lecture–laboratory implications.
- **Group attendance:** attendance is linked to enrollment and section meetings, totals match prescribed periods, and groups cannot attend overlapping classes. Additional restrictions govern sections sharing a laboratory tie.

### Objective

The model **minimizes a weighted sum of penalties**. The principal weights are:

- 5, 20, or 300 for the three penalized instructor availability categories;
- an additional 1,000 for the specified adjunct preference violations;
- 200 for the indicator relaxing the professor teaching-day limit;
- unit penalties for first-and-seventh-period teaching, selected adjacent-day section patterns, and Tuesday absence for qualifying professors.

The reformulation preserves these coefficients and the minimization direction.

## 3. Reformulation and validity

### A. Remove implied integrality

The reformulation retains the original variable names and indices but makes `w`, `gapday`, and `u` continuous on \([0,1]\).

- **Professor schedule `w`:** original constraint `c10` equates each entry to a sum of binary `z` variables. This sum is integral; the retained upper bound of one makes `w` binary automatically.
- **Section-day indicator `gapday`:** `cgapday1` equates it to a sum of binary meeting assignments. Its bounds, also consistent with the daily restriction `c2`, force a value of zero or one.
- **Group attendance `u`:** fix binary `x` and `z`. If `x[g,s]=0`, `c13d` and nonnegativity force all corresponding attendance variables to zero. If `x[g,s]=1`, `c13b` requires attendance to be at least the room-summed section schedule. By `c1`, that schedule totals the section’s prescribed periods; by `c13d`, attendance has exactly the same total. Hence every lower bound is tight, and attendance equals the integral section schedule.

Thus these variables need not be declared binary. This reduces explicit integer-variable declarations without changing the feasible schedules or objective values.

### B. Strengthen attendance linking

Two valid inequalities are added:
\[
u_{gdts}\le x_{gs},
\qquad
u_{gdts}\le \sum_r z_{sdtr}.
\]

Their validity follows directly from the attendance argument above: an unenrolled group has zero attendance, and an enrolled group’s attendance equals the section schedule. These bounds can exclude fractional LP solutions permitted by the original aggregate linking equations, strengthening the relaxation.

### C. Replace laboratory inequality pairs with equalities

For each laboratory day, `c3a` and `c3b` respectively impose
\[
\text{daily meetings}\le P_s y1_{sd},
\qquad
\text{daily meetings}\ge P_s y1_{sd}.
\]
They are therefore replaced by one equality. The same algebra applies to `c4a` and `c4b` for each laboratory day–room combination.

This is an exact row reduction, not an approximation or a change to the laboratory requirements.

For laboratories with **strictly positive** period requirement \(P_s\), the reformulation also adds:

- exactly one active day;
- the sum of active rooms on a day equals that day’s activation;
- each meeting assignment is bounded by its day–room activation.

The first two follow by summing the laboratory equalities and using `c1`, then dividing by \(P_s>0\). The third follows because an inactive binary room indicator forces its nonnegative meeting sum to zero, while an active indicator permits each binary assignment to be at most one.

The positivity condition is essential: zero-period laboratories do not have to select a unique day or room in the original model.

### D. Strengthen professor-day activation

The reformulation adds
\[
w_{pdt}\le y3_{pd}.
\]

In the original model, `c6a` forces all nonnegative `w` entries to zero when binary `y3` is zero. When `y3` is one, the inequality follows from the upper bound on `w`. The cut is therefore valid and strengthens fractional day-activation decisions.

The coefficient seven in `c6a` is also tightened to
\[
\min(7,|times|).
\]
A professor can occupy at most \(|times|\) slots because each `w` is bounded by one. This preserves the original seven-slot limit while exploiting smaller time sets.

### E. Compress synchronization equalities

The original double-section constraints equate every pair of schedules within each nonzero `double` class. The reformulation derives one representative per class and equates every other member to that representative.

Equality is transitive, so these representative-based equations imply every original pairwise equation. Conversely, the original equations imply every representative-based equation. This removes self-equalities and redundant pairwise comparisons.

### F. Consolidate repeated constraint generation

A derived set records each distinct professor–section co-instructor pair. It replaces the six separately written conflict families and their preference counterparts. If a professor appears in multiple co-instructor fields for the same section, the original rows are identical; retaining one copy preserves their effect.

The four fixed-day and fixed-time families are also expressed through a derived field-pair set. This is a structural consolidation, not an additional restriction.

## 4. Preservation and expected effect

All external data declarations, defaults, original variable indices, and objective terms are preserved. No assumption is added that group sizes are positive, that every section has a valid primary professor, or that the time set is exactly the usual seven periods.

The techniques used are **implied-integrality relaxation, algebraic row reduction, valid activation and linking inequalities, coefficient tightening, transitive-equality compression, and duplicate-row elimination**. They aim to reduce redundant rows and explicit integrality requirements while strengthening the LP relaxation. Actual runtime improvements require instance-level testing; none are claimed here.

Because no original variable is eliminated or reindexed, the solution-mapping script copies their values directly.

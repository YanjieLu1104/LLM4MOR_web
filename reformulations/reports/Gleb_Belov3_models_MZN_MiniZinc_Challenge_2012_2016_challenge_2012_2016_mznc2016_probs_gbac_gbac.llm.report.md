# Generalised Balanced Academic Curriculum: Reformulation Report

## 1. Problem background

The model schedules courses into academic periods while balancing students’ workloads. Courses may belong to multiple curricula, so a course’s assigned period affects every curriculum containing it.

A feasible schedule must:
- Place every course in one period.
- Respect prerequisite relationships, with each prerequisite taught strictly before its successor.
- Keep the number of courses in each curriculum and period between specified minimum and maximum limits.

The objective combines workload imbalance with penalties for assigning particular courses to undesirable periods. Course loads, curriculum memberships, prerequisites, undesirable assignments, and objective weights are supplied externally; no particular instance sizes or numerical values are assumed.

## 2. Original model

### Variables

The original model declares:
- `period_of`: one integer period assignment per course.
- `load_of`: one integer workload per curriculum–period pair.
- `delta`: one integer workload deviation per curriculum–period pair.
- Three scalar variables: `undesirable_violation`, `norm`, and `objective`.

Both `load_of` and `delta` have domains from zero to `max_load`, where `max_load` is the sum of all course loads. The violation count and squared-deviation total are defined expressions.

### Constraints

A global cardinality constraint enforces curriculum-specific course-count bounds in every period. Strict inequalities impose prerequisites. Bin-packing load constraints calculate each curriculum’s period workload from the loads of its assigned courses.

For curriculum \(c\), let
\[
a_c=\left\lfloor T_c/P\right\rfloor,\qquad
b_c=\left\lceil T_c/P\right\rceil,
\]
where \(T_c\) is its total load and \(P\) is the number of periods. The deviation is
\[
d_{cp}=\max(L_{cp}-b_c,\;a_c-L_{cp}).
\]

For integer workloads, this is the distance from the ideal interval \([a_c,b_c]\). Since its endpoints coincide or differ by one, an integer workload inside that interval has zero deviation.

### Objective

The model minimizes
\[
w_1\sum_{c,p}d_{cp}^{2}
+
w_2\sum_{i\in\text{undesirables}}
\mathbf{1}\{\text{course }i\text{ is assigned its listed undesirable period}\}.
\]

The squared term penalizes large workload deviations more heavily than small ones. The formulation does not impose sign restrictions on the supplied weights; an equivalent reformulation must therefore preserve the objective exactly, rather than rely on positive weights.

## 3. Reformulation and justification

### Shared binary course–period assignments

The reformulation introduces binary variables \(x_{ip}\), with
\[
\sum_p x_{ip}=1,\qquad
\texttt{period\_of}[i]=\sum_p p\,x_{ip}.
\]

Exactly one binary is selected per course, so these equations represent precisely the original period choice. The original `period_of` variables remain available.

The binaries are shared across curricula and replace the cardinality and bin-packing constraints with linear equations and inequalities:
\[
\texttt{min\_courses}
\leq \sum_{i\in C_c}x_{ip}
\leq \texttt{max\_courses},
\qquad
L_{cp}=\sum_{i\in C_c}\texttt{course\_load}[i]x_{ip}.
\]

These expressions count and sum exactly the courses assigned to each period. They provide an explicit assignment formulation suitable for HiGHS and avoid separate assignment representations for overlapping curricula.

### Cumulative prerequisite cuts

The original strict prerequisite inequalities are retained. For each prerequisite \(u\) of \(v\), the reformulation also adds, for every period \(p\),
\[
\sum_{q\leq p}x_{vq}
\leq
\sum_{q<p}x_{uq}.
\]

These inequalities are valid because whenever \(v\) occurs by period \(p\), its prerequisite must occur strictly before \(p\). Otherwise, the left-hand side is zero. They remove no feasible integer schedule and can strengthen the linear relaxation.

### Curriculum-specific bound preprocessing

For each curriculum, the reformulation computes
\[
U_c=\max\!\left(0,\min\!\left(
\texttt{max\_load},
\sum_{i\in C_c}\max(0,\texttt{course\_load}[i])
\right)\right).
\]

Every period load is a subset sum of that curriculum’s course loads, so it cannot exceed the sum of their positive parts. Combining this fact with the original load domain gives a safe upper bound for every feasible original solution.

From \(0\leq L_{cp}\leq U_c\) and the original deviation equation,
\[
d_{cp}\leq \max(U_c-b_c,a_c).
\]
Intersecting this bound with the original deviation domain yields a curriculum-specific deviation bound. This preprocessing reduces the number of auxiliary variables required to represent squared deviations.

### Exact linear representation of squares

For each deviation with upper bound \(D_c\), ordered binary thresholds \(z_{cpk}\) satisfy
\[
d_{cp}=\sum_{k=1}^{D_c}z_{cpk},
\qquad
z_{cpk}\geq z_{cp,k+1}.
\]

The ordering forces the first \(d_{cp}\) thresholds to equal one and all remaining thresholds to equal zero. The identity
\[
d_{cp}^{2}=\sum_{k=1}^{D_c}(2k-1)z_{cpk}
\]
then replaces variable multiplication exactly.

The original maximum equation defining each deviation is retained. Consequently, neither deviations nor their squares can be inflated or understated to exploit an objective weight. The construction remains exact for positive, zero, or negative weights.

### Load-conservation equations

The reformulation adds
\[
\sum_p L_{cp}=T_c.
\]

These equations follow directly from the load definitions and the requirement that every course is assigned exactly once. They are redundant for integer feasibility but make conservation explicit for the solver.

## 4. Interface and solution preservation

All original external parameters and original independent decision variables—`period_of`, `load_of`, `delta`, and `objective`—are retained. The mapping script copies those variables with their original index encodings and omits reformulation auxiliaries.

The changes preserve the minimization direction, feasible original schedules, and objective values. They target a stronger, explicitly linear mixed-integer representation for HiGHS; no measured runtime improvement is claimed without instance-level benchmarking.

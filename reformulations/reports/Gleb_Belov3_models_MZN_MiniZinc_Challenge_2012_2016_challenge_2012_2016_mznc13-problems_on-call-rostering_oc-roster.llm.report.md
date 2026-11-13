## On-call staff rostering

### Real-world background

The model schedules one on-call staff member for each period in a planning horizon. Monday through Thursday each count as one period, while Friday through Sunday form a single weekend period.

Staff have individual workload percentages, unavailable dates, and possibly assignments fixed in advance. The roster aims to distribute weekday and weekend duties fairly relative to workload, while limiting undesirable sequences of duties. Fixed assignments can exempt certain sequences from otherwise mandatory spacing rules.

### Original formulation

Let \(N=\texttt{num_staff}\), \(D=\texttt{num_days}\), and \(W=|\texttt{weekend_days}|\). The independent decision variables are:

- \(D\) integer roster variables identifying the assigned staff member for each period.
- \(2N\) integer counts recording each staff member’s weekday and weekend duties.
- Two integer balance variables measuring permitted workload imbalance.
- \(D-1\) adjacency-penalty variables and \(W\) Wednesday-before-weekend penalty variables.

The weekday and weekend roster arrays are views of the main roster. The objective variable is defined by the other variables.

The constraints enforce:

- **Availability and fixed duties:** unavailable staff cannot be assigned, and fixed assignments must be respected.
- **Duty counting:** each staff member’s weekday and weekend counts equal their occurrences in the corresponding roster.
- **Workload balance:** for each staff pair \(i,j\), the weekday counts satisfy
  \[
  |w_i c_j-w_j c_i|\leq 100\,b_{\mathrm{weekday}},
  \]
  with an analogous constraint for weekends. Here \(w_i\) is the workload percentage and \(c_i\) is the relevant duty count.
- **Spacing:** three consecutive assignments to the same person are prohibited unless all three periods are fixed. Weekend duties cannot normally coincide with duties on neighboring periods or on the next weekend.
- **Soft preferences:** specified repeated assignments force their corresponding penalty variables to their maximum values.

The model also checks input consistency, including conflicting fixed assignments and conflicts between fixed duties and unavailability.

The objective minimizes
\[
\sum \text{adjacency penalties}
+\sum \text{Wednesday-before-weekend penalties}
+b_{\mathrm{weekday}}+b_{\mathrm{weekend}}.
\]
Its declared domain additionally imposes an upper bound of \(4D\), which is part of the model’s feasibility conditions.

Several implementation details matter for equivalence. Adjacency implications cover only periods \(1,\ldots,D-2\), leaving the final adjacency-penalty entry without such an implication. Penalties are not defined as exact violation indicators: the original constraints only force them upward when a violation occurs. Weekend-spacing exemptions also depend on the precise combinations of fixed periods checked by the source.

### Reformulation and justification

The revised formulation targets the HiGHS mixed-integer linear solver. It retains all original independent variables and introduces \(DN\) binary assignment variables \(x_{d,s}\).

#### Binary assignment representation

For every period \(d\),
\[
\sum_s x_{d,s}=1,
\qquad
\texttt{roster}[d]=\sum_s s\,x_{d,s}.
\]

Because the assignment variables are binary and exactly one is selected, these equations identify exactly the same staff member as the original roster variable. Conversely, every original roster determines a unique assignment vector. Retaining the roster variables also preserves compatibility with externally supplied assignments to them.

#### Availability and fixed-assignment preprocessing

Unavailable staff-period combinations are fixed to zero. Fixed duties set the corresponding binary to one, and other staff binaries for that period are fixed to zero.

These fixings follow directly from the original availability and fixed-duty constraints together with the requirement to assign exactly one person per period. They expose forced assignments to solver presolve without changing the input data.

#### Linear duty counts and redundant constraints

Occurrence-count constraints are replaced by sums of assignment binaries over weekday or weekend periods. This is exact because \(x_{d,s}=1\) precisely when staff member \(s\) is assigned to period \(d\).

The reformulation also adds:

- Bounds limiting an individual’s count to the number of periods of that type.
- Equalities making total weekday and weekend counts equal their respective calendar totals.

These are valid redundant constraints: each relevant period contributes exactly one assignment, and no person can receive more assignments than the number of such periods. They can help presolve and relaxation processing.

#### Linear workload balance

Each constraint \(|a|\leq b\) becomes
\[
a\leq b,\qquad -a\leq b.
\]

This is an exact algebraic reformulation of the original pairwise balance constraints, with unchanged coefficients and balance-variable domains.

#### Linear spacing constraints

For every non-exempt three-period window and staff member \(s\), the formulation imposes
\[
x_{d,s}+x_{d+1,s}+x_{d+2,s}\leq 2.
\]

The original implication forbids exactly the case in which all three roster entries are the same. The binary inequality forbids that same case.

A prohibited repeated assignment on periods \(a,b\) becomes
\[
x_{a,s}+x_{b,s}\leq 1
\]
for every staff member. This is equivalent to requiring different roster values. The original endpoint handling and fixed-period exemption tests are preserved.

#### Linear soft-penalty implications

For a penalized pair \(a,b\), penalty \(p\), and strength \(q\), the formulation uses
\[
p\geq q(x_{a,s}+x_{b,s}-1)
\]
for every staff member \(s\).

If the same person covers both periods, one inequality requires \(p\geq q\); the original upper bound \(p\leq q\) then forces equality. If different people cover the periods, all right-hand sides are nonpositive, so no additional restriction is imposed beyond the original nonnegative domain. Negative strengths already make the original penalty domains empty.

Thus the inequalities preserve the original implication-only semantics rather than replacing them with exact indicators. The final adjacency-penalty entry, all exemptions, and the objective upper bound remain unchanged.

### Solution interface and expected benefit

The mapping script copies the seven original independent variable declarations from the reformulated solution and omits auxiliary assignments and derived quantities. No reconstruction or instance-specific assumptions are needed.

The principal benefit is a fully linear assignment formulation that exposes fixed binaries, conflict inequalities, and explicit counting equations to HiGHS. It introduces more variables but avoids generic translations of roster equalities, implications, and counting constraints. No runtime improvement has been established from the supplied source alone; performance remains instance-dependent.

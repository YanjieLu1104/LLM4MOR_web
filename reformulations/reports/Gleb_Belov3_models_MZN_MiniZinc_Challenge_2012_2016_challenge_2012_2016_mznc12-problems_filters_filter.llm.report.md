## Background and interpretation

The model schedules operations in a computational filter, plausibly a digital signal-processing implementation. Operations are classified as additions or multiplications, with a fixed execution duration for each type. Each operation must be assigned a start time and a numbered hardware resource of its type.

Dependencies determine when an operation may start: if operation \(j\) belongs to `dependencies[i]`, operation \(i\) must finish before \(j\) begins. Operations assigned to the same resource cannot overlap in time. Addition and multiplication resources are modeled separately, so their resource numbers may coincide without causing a conflict.

The objective is to minimize the latest completion time among the operations explicitly listed in `Last`. The model does not require `Last` to contain every terminal operation; consequently, its objective should not be interpreted as the completion time of all operations without additional instance information.

## Original model

### Variables and data

For \(n\) operations, the independent decision variables are:

- \(n\) integer start times, `t[i]`, in \(0,\ldots,100\);
- \(n\) integer resource assignments, `r[i]`, in \(1,\ldots,10\);
- one integer objective variable, `end`, in \(0,\ldots,1000\).

Thus, the source declares \(2n+1\) independent integer decision variables. The duration array `d` is determined by the operation types and duration parameters. Its declared domain also requires each used duration to lie in \(1,\ldots,10\). The arrays `t_add` and `t_mul` are views of the start-time variables, not additional independent decisions.

### Constraints and objective

The original formulation contains:

- **Type consistency:** `add` and `mul` are disjoint, and their cardinalities sum to \(n\).
- **Precedence:** one inequality
  \[
  t_i+d_i\le t_j
  \]
  for each supplied dependency \(i\to j\).
- **Resource limits:** each resource assignment is bounded by the available number of resources of its operation type, as well as its original upper bound of 10.
- **Non-overlap:** two `diffn` constraints, one per operation type. Each operation is represented by a rectangle with horizontal extent \(d_i\) and vertical extent 1, positioned at \((t_i,r_i)\).
- **Objective definition:**
  \[
  \texttt{end}=\max_{i\in\texttt{Last}}(t_i+d_i).
  \]

The solve item minimizes `end`. The original search annotations prioritize start times and then resource assignments.

## Reformulation and justification

The revised formulation retains the original data interface, decision variables, precedence constraints, resource limits, and exact objective definition. It replaces the geometric non-overlap constraints with a mixed-integer linear formulation tailored to HiGHS.

### 1. Precedence-based time-window preprocessing

Parameter-only longest-path relaxations compute lower bounds on start times and upper bounds implied by the original horizon.

Initially, every operation has lower bound zero. A precedence edge \(i\to j\) implies
\[
L_j\ge L_i+d_i.
\]
Repeated propagation therefore produces valid earliest-start bounds.

In the reverse direction, a path from operation \(i\) to a later operation requires the intervening processing time to fit before that later operation’s start. Since every start time is at most 100, reverse propagation gives a valid upper bound
\[
t_i\le U_i=100-H_i,
\]
where \(H_i\) is a lower bound on the time from \(i\)'s start to a downstream operation’s start.

These computations are capped at 101: any required path length exceeding 100 already contradicts the original start-time horizon. The duration values used internally are clipped to \(1,\ldots,10\), but the original duration declarations are retained. Consequently, clipping changes nothing for feasible instances and does not make out-of-domain durations feasible.

### 2. Removal of redundant pairwise non-overlap conditions

A same-type pair does not need a separate non-overlap disjunction when:

- a direct precedence edge already forces one operation to finish before the other starts; or
- the derived time windows guarantee separation, for example
  \[
  U_i+d_i\le L_j.
  \]

The second condition is sufficient because every feasible assignment then satisfies
\[
t_i+d_i\le U_i+d_i\le L_j\le t_j.
\]
These omissions remove only conditions already implied by retained constraints and valid bounds.

### 3. Explicit linear non-overlap disjunctions

For each remaining same-type pair, rectangle non-overlap is equivalent to at least one of:
\[
t_i+d_i\le t_j,\qquad
t_j+d_j\le t_i,\qquad
r_i+1\le r_j,\qquad
r_j+1\le r_i.
\]

Because resource assignments are integers and each rectangle has height 1, the last two alternatives express different resource assignments. Binary indicators activate these alternatives through big-M inequalities.

The time coefficients use the derived bounds, such as
\[
M_{ij}=\max(0,U_i+d_i-L_j).
\]
This is sufficient to deactivate the corresponding inequality throughout the valid time windows, while avoiding unnecessarily large coefficients. Resource coefficients similarly use the effective resource limit, incorporating the original upper bound of 10. Temporal alternatives that are impossible even at their most favorable bounds are disabled.

### 4. Single-resource simplification

When a type has exactly one usable resource, its operations must all have resource assignment 1. The two resource-separation alternatives are therefore impossible. Each remaining pair requires only one binary variable to select which operation executes first.

A nonpositive resource count for a used type remains infeasible under the retained original resource constraints; the internal coefficient calculations do not relax that requirement.

### 5. Solver interface and solution mapping

The CP-oriented search annotations were removed so that HiGHS can use its native mixed-integer search. No resource-label symmetry breaking was added, preserving compatibility with externally fixed resource assignments.

The mapping script copies `t`, `r`, and `end` directly from the reformulated solution. No reconstruction is necessary because their indices, values, and meanings are unchanged.

Overall, the reformulation aims to improve solving through tighter time windows, fewer non-overlap disjunctions, and explicitly bounded linear constraints. The performance benefit remains instance-dependent; no runtime improvement was established in the conversation.

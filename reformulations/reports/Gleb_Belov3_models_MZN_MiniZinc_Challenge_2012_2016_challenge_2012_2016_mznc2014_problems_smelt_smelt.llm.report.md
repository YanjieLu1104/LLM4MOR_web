## Problem background

The model describes a production-scheduling problem consistent with a smelting plant. Orders require particular recipes, each of which consumes minerals at specified rates. Production takes place on a limited number of parallel lines, while mineral supplies impose plant-wide capacity limits.

Each order has a processing time equal to `h[i] * w[i]`. Orders using the same recipe form one uninterrupted production block: they run consecutively, in their original index order, on a common line. Consequently, the scheduling decisions concern recipe blocks rather than independently sequenced orders.

Production rules express preferred timing relationships between recipes. These rules are soft: the model may decline to enforce a rule by paying a penalty.

## Original model structure

### Variables

For \(n\) orders, \(r\) recipes, and \(p\) production rules, the original model declares:

- Order start times `s` and line assignments `l`: \(2n\) independent integer variables.
- Recipe start times `start` and line assignments `line`: \(2r\) independent integer variables.
- One independent integer variable `makespan`.
- \(p\) Boolean variables `followed`, indicating which production rules must hold.

Thus, there are \(2n+2r+1\) independent integer variables and \(p\) independent Boolean variables. Order completion times `e`, recipe completion times `end`, the violation count, and the objective are defined expressions with declared bounds.

Time variables lie between 0 and the fixed horizon of 1000. Line assignments lie between 1 and `nl`.

### Constraints

The model contains:

1. **Order–recipe linking constraints.** Each order starts at its recipe’s start time plus the processing times of preceding orders with that recipe. Its line equals the recipe’s line.
2. **Recipe durations.** Each recipe’s duration is the sum of its orders’ processing times.
3. **Production-line capacity constraints.** One cumulative constraint limits simultaneous recipes to `nl`; a further cumulative constraint for each line prevents overlapping recipe blocks on that line.
4. **Mineral-flow constraints.** One cumulative constraint per mineral limits the total consumption rate of active recipes to the mineral’s available flow.
5. **Soft production rules.** Each `followed[i]` implies one of four temporal inequalities involving recipe starts, completions, and a supplied offset.
6. **Makespan bounds.** `makespan` is at least every recipe’s completion time.

Importantly, `followed[i]` is an implication, not an equivalence: a rule may hold even when its Boolean is false.

### Objective

The model minimizes
\[
1000\sum_{i=1}^{p}\bigl(1-\operatorname{bool2int}(\texttt{followed}[i])\bigr)
+\texttt{makespan}.
\]

This is a weighted objective, not an explicitly lexicographic objective. The reformulation preserves its exact value and minimization direction.

## Reformulation and justification

The changes target a mixed-integer backend, HiGHS. All original independent variables, order-linking equations, time bounds, production rules, and objective definitions remain intact.

### Conditional event-based resource formulation

The model first checks whether recipe durations, mineral demands, mineral capacities, and the number of lines are nonnegative. Under these conditions, it replaces the cumulative constraints with an event-based formulation. Otherwise, it retains the original cumulative constraints, avoiding new assumptions about externally supplied data.

For each pair of positive-duration recipes \(i,j\), an auxiliary Boolean records whether recipe \(j\) is active when recipe \(i\) starts:
\[
A_{ij}\iff
\texttt{start}[j]\le\texttt{start}[i]<\texttt{end}[j].
\]

Capacity is checked at every positive-duration recipe start:
\[
\sum_j A_{ij}\le\texttt{nl},
\qquad
\sum_j c[j,k]A_{ij}\le f[k].
\]

These checks are sufficient because, with nonnegative demands, resource usage can increase only when a recipe starts. Between starts, completions can only reduce usage. The half-open activity interval also correctly permits one recipe to start exactly when another finishes. Zero-duration recipes occupy no time and contribute no resource usage.

The same activity indicators are shared across all minerals and the aggregate line-capacity constraint.

### Pairwise line exclusivity

For each pair of positive-duration recipes, per-line cumulative constraints are replaced by
\[
\texttt{line}[i]\ne\texttt{line}[j]
\;\lor\;
\texttt{end}[i]\le\texttt{start}[j]
\;\lor\;
\texttt{end}[j]\le\texttt{start}[i].
\]

This is equivalent to the original unit-capacity line constraints: two positive-duration intervals assigned to the same line must not overlap. No line-label symmetry restrictions are introduced, so original line identities and externally fixed assignments remain compatible.

### Resource preprocessing

Two tests use only the supplied data:

- **Redundant mineral checks are omitted.** If the sum of demands over all positive-duration recipes is at most a mineral’s capacity, every active subset also fits. This follows from demand nonnegativity.
- **Mineral-incompatible pairs are identified.** If two positive-duration recipes together require more than some mineral’s capacity, they cannot overlap. An explicit precedence disjunction is added for each such pair. It is implied by the original mineral cumulative constraint but can make the conflict easier for the solver to exploit.

### Energy inequalities

The reformulation adds
\[
\sum_i \texttt{duration}[i]\le\texttt{nl}\cdot\texttt{makespan}
\]
and, for every mineral \(k\),
\[
\sum_i \texttt{duration}[i]\,c[i,k]
\le f[k]\cdot\texttt{makespan}.
\]

These inequalities follow by integrating the original capacity limits over the interval from zero to `makespan`. Original start-time bounds ensure that recipes start no earlier than zero, and the makespan constraints ensure that they finish within this interval. These are valid strengthening inequalities, not replacements for instantaneous capacity checks.

### Solution mapping and expected effect

No original independent variable is eliminated. The mapping script therefore copies `s`, `l`, `makespan`, `start`, `line`, and `followed`, preserving their encoded indices and excluding auxiliary variables. Missing required values produce an explicit error.

The reformulation exposes shared event indicators, pairwise conflicts, and aggregate capacity bounds directly to the mixed-integer solver. Its event representation introduces \(r^2\) Boolean entries, including entries fixed false for zero-duration recipes. This may improve solving performance, but no instance-specific speedup is established without benchmark data.

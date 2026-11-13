# Weighted Constraint Satisfaction for Protein Design

## Background and interpretation

The model represents a **weighted constraint satisfaction problem (WCSP)** with unary and binary costs. Its filename suggests a protein-design application: each variable could represent a protein position, and each domain value a candidate residue or conformation. Unary costs would then describe individual choices, while binary costs describe interactions between choices at two positions. This interpretation is inferred from the filename and mathematical structure; the model itself contains no explicit biochemical definitions.

More generally, the task is to choose one discrete value for every variable, satisfy all supplied cost tables, and minimize the sum of the selected costs. The parameter `top` imposes a strict total-cost cutoff: a solution is feasible only when its total cost is less than `top`.

## Original formulation

The original model declares:

- `num_variables` integer assignment variables, `p[i]`, with declared domain `0..max_domain` and the additional constraint `p[i] < domains[i]`.
- `num_constraints1` unary-cost variables, `ocosts1[j]`, bounded by `0..max_costs1`.
- `num_constraints2` binary-cost variables, `ocosts2[j]`, bounded by `0..max_costs2`.
- One objective variable, `objective`, bounded by `0..(top-1)`.

Thus, there are
\[
\texttt{num\_variables}+\texttt{num\_constraints1}
+\texttt{num\_constraints2}+1
\]
original integer decision variables.

Each unary table constrains the pair
\[
(\texttt{ocosts1[j]},\,\texttt{p[func1x[j]]}),
\]
and each binary table constrains the triple
\[
(\texttt{ocosts2[j]},\,\texttt{p[func2x[j]]},\,\texttt{p[func2y[j]]}).
\]
A pair or triple must equal a row of its supplied table. Consequently, missing assignments are prohibited. Although the model comments describe fully specified cost functions, the reformulation does not rely on table completeness or on each assignment having a unique cost.

The objective is
\[
\min\ \texttt{objective}
=
\sum_j \texttt{ocosts1[j]}
+
\sum_j \texttt{ocosts2[j]}.
\]

## Reformulation and its justification

### 1. Remove individually infeasible table rows

The reformulation filters each table before introducing tuple-selection variables:

- **Out-of-domain assignment values:** The original bounds and domain constraint imply
  \[
  0\le p[i]\le \min(\texttt{max\_domain},\,\texttt{domains[i]}-1).
  \]
  Any row containing an assignment outside this interval cannot satisfy the original table constraint and is removed.

- **Out-of-domain costs:** A row with a cost outside the corresponding `ocosts1` or `ocosts2` domain cannot match that original cost variable and is removed.

- **Costs at least `top`:** Every original cost variable is nonnegative, and their sum equals an objective strictly below `top`. Therefore, no selected individual cost can be at least `top`.

- **Inconsistent repeated arguments:** If a binary constraint references the same assignment variable twice, its two assignment columns must be equal. Rows with unequal values in those columns cannot satisfy the original constraint and are removed.

These are feasibility-preserving reductions, not heuristic pruning. If filtering leaves a table empty, the reformulated model is infeasible, as the original model must also be. Duplicate rows and alternative admissible costs for the same assignment are retained.

### 2. Introduce shared one-hot assignment variables

For each original variable and each value in its effective domain, the reformulation introduces a binary assignment indicator. Exactly one indicator is selected, and `p[i]` is linked to the weighted sum of its value indicators.

This is an exact representation of the original domain: every allowed integer value has one corresponding one-hot assignment, and every feasible one-hot assignment produces an allowed value of `p[i]`.

### 3. Replace tables with tuple selection and marginal consistency

Each surviving unary or binary table row receives a binary selector. Exactly one row is selected per table, and the original cost variable equals the selected row’s cost.

For every argument and possible value, an additional equation equates:

- the sum of selected rows containing that value in the relevant argument column; and
- the shared assignment indicator for that variable and value.

These **marginal-consistency equations** ensure that all tables agree on each shared assignment. The reformulation is exact: any original feasible solution permits selection of a matching row in each table, and any reformulated integer solution selects rows matching its original assignment and cost variables.

For HiGHS, this exposes a linear mixed-integer formulation. Value-specific consistency can strengthen the linear relaxation relative to linking tuple selectors only through numerical assignment values, where different fractional mixtures can have the same average. The benefit is instance-dependent: the formulation adds binary variables and equations, so no universal runtime improvement is claimed.

## Interface and solution preservation

All original external parameters, decision variables, cost meanings, and the minimization direction remain unchanged. The CP-oriented search annotations were removed for the MIP formulation. The original variables are explicitly requested in solver output, and the accompanying mapping script copies only `p`, `ocosts1`, `ocosts2`, and `objective`, reporting missing fields rather than fabricating values.

The reformulation therefore preserves the original feasible assignments and objective values, including optimal solutions, without requiring instance-specific reconstruction.

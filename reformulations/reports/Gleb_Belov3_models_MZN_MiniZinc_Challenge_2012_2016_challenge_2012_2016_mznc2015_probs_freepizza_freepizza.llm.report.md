## Background

The model represents a pizza order paid for using promotional vouchers. Each pizza has a given price. Voucher \(v\) requires buying `buy[v]` pizzas and permits receiving up to `free[v]` additional pizzas at no charge. Every free pizza assigned to a voucher must cost no more than every purchased pizza assigned to that voucher. Pizzas not assigned to any voucher are paid for normally.

The aim is to minimize the total amount paid. Vouchers cannot share pizzas, and using a voucher does not require taking its full allowance of free pizzas.

## Original model

The model contains:

- **\(n\) integer assignment variables**, `how[p]`, with values in `-m..m`. A value of \(-v\) identifies a purchased pizza for voucher \(v\), \(+v\) identifies a free pizza for that voucher, and zero means no voucher.
- **\(m\) Boolean variables**, `used[v]`, indicating whether each voucher is used.
- **One integer objective variable**, bounded by zero and the sum of all pizza prices.

For each voucher, two constraints link its purchased-pizza count to its use indicator. Together, they require exactly `buy[v]` purchased pizzas when the voucher is used and none otherwise. A third constraint limits its free-pizza count to `free[v]` when used and zero otherwise.

The price condition is expressed through \(n^2\) ordered-pair implications. Whenever one pizza is purchased and another is free under the same voucher, the free pizza cannot be more expensive.

The objective minimizes the sum of prices of pizzas with `how[p] <= 0`: both ordinary purchases and voucher-associated purchases are charged. The symmetry-breaking constraints in the source are commented out and therefore inactive.

## Reformulation

### Binary assignments and linear voucher constraints

The reformulation introduces binary variables `rf_paid[p,v]` and `rf_gift[p,v]` for purchased and free assignments. Each pizza may have at most one such assignment. The original assignment variable is retained and linked by

\[
\texttt{how}[p]
=\sum_v v\bigl(\texttt{rf\_gift}[p,v]-\texttt{rf\_paid}[p,v]\bigr).
\]

This is an exact representation: at most one binary variable can be one, so the expression yields precisely the original negative, positive, or zero assignment code.

Purchased-pizza counts are enforced by the linear equality

\[
\sum_p \texttt{rf\_paid}[p,v]
=\texttt{buy}[v]\,\texttt{used}[v].
\]

For positive purchase requirements, this equality is equivalent to the original pair of constraints. For nonpositive requirements, the original equivalence forces `used[v]` to be true because a nonnegative count is always at least `buy[v]`. The reformulation explicitly retains that consequence. Negative purchase requirements therefore remain infeasible, just as in the original model. The free-pizza capacity inequality is retained in linear form, without assuming its input is positive.

### Price-level preprocessing and monotone markers

The distinct pizza prices are collected into ascending levels. For each pizza, preprocessing computes the number of levels strictly below its price. Equal-price pizzas remain distinct entities; only their price-level information is shared.

For every voucher, continuous markers in \([0,1]\) are introduced across these levels and constrained to be nondecreasing. A purchased pizza at level \(k\) forces the marker at \(k\) to one. A free pizza at level \(j\) forces the marker immediately below \(j\) to zero.

This replaces the original pairwise implications exactly:

- If a cheaper pizza is purchased and a more expensive pizza is free under the same voucher, monotonicity would require a marker to be both one and zero. The prohibited assignment is therefore excluded.
- Conversely, for any assignment satisfying the original price rule, markers can be set to zero below the cheapest purchased price and one from that price onward. If nothing is purchased, all markers can be zero.
- Purchased and free pizzas at the same price remain compatible, as required by the original non-strict price comparison.

The markers need not be binary: binary assignment decisions force the relevant marker values to their endpoints. With \(L\leq n\) distinct prices, the new price-ordering formulation uses \(O(m(n+L))\) constraints rather than \(n^2\) variable-dependent implications.

### Objective and solution interface

The cost is rewritten as

\[
\sum_p \texttt{price}[p]
\left(1-\sum_v \texttt{rf\_gift}[p,v]\right).
\]

Because each pizza has at most one assignment, the parenthesized term is zero exactly for free pizzas and one otherwise. This preserves the original objective, minimization direction, and objective bounds, including for input prices that are not positive.

The original data interface and the variables `how` and `used` are retained. The mapping script returns those original variables and can reconstruct `used` from `how` and the original purchase requirements if necessary.

Overall, the changes are an **extended linear formulation** with **price-level preprocessing**, not a heuristic restriction of the solution space. They are intended to give HiGHS a more direct mixed-integer linear model; actual performance gains depend on the instance dimensions and price distribution.

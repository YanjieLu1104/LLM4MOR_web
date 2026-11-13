# Grid Colouring: Model and Reformulation Report

## Problem background

The model colours the cells of an \(n \times m\) grid while forbidding any **monochromatic axis-aligned rectangle**: choosing any two distinct rows and two distinct columns must not yield four corners of the same colour. Rectangles need not consist of adjacent cells.

This is a combinatorial design problem related to extremal and Ramsey-type questions: how many colours are needed to avoid a prescribed repeated pattern? A possible interpretation is assigning categories or resources to pairs of entities while avoiding a uniform \(2 \times 2\) interaction pattern. The supplied source does not identify a particular application.

## Original formulation

Let \(C=\min(n,m)\). For positive grid dimensions, the model declares:

- \(nm\) integer variables \(x_{ik}\in\{1,\ldots,C\}\), specifying cell colours.
- One integer variable `objective` in the same domain.

It imposes:

1. **Colour-label bounds:** \(x_{ik}\leq\texttt{objective}\) for every cell, giving \(nm\) constraints.
2. **Rectangle restrictions:** for each pair of rows and pair of columns, a disjunction requires at least one inequality among the four corner colours. This gives
   \[
   \binom n2\binom m2
   \]
   constraints and excludes exactly the monochromatic rectangles.

The objective is to **minimize `objective`**. Strictly, this variable bounds the largest colour label, rather than counting distinct labels. With unrestricted cell assignments, unused labels can be removed by relabelling, so the optimal value equals the minimum number of colours required. The reformulation preserves the original label-based meaning, including when external data fixes variable values.

The original search annotation branches on cell colours and then on the objective.

## Reformulation

The new model retains the original external parameters, `x`, and `objective`, but replaces the disjunctive formulation with a mixed-integer linear formulation suited to HiGHS.

### Binary cell-colour indicators

For every cell and colour, a binary indicator \(y_{ikc}\) specifies whether \(x_{ik}=c\). The constraints
\[
\sum_{c=1}^{C}y_{ikc}=1,
\qquad
x_{ik}=\sum_{c=1}^{C}c\,y_{ikc}
\]
give an exact representation of the original colour variable.

This introduces \(nmC\) binary indicators without changing any cell’s possible values or its correspondence to the input grid.

### Prefix indicators for the objective

Binary variables \(a_c\) satisfy
\[
a_{c+1}\leq a_c,\qquad
\texttt{objective}=\sum_{c=1}^{C}a_c,\qquad
y_{ikc}\leq a_c.
\]

The monotonicity constraints make the available labels exactly the prefix \(1,\ldots,\texttt{objective}\). Consequently, the last inequality is equivalent to the original requirement \(x_{ik}\leq\texttt{objective}\).

Conversely, any original feasible assignment extends to these variables by setting \(a_c=1\) precisely when \(c\leq\texttt{objective}\). Available colours need not actually be used, matching the original semantics.

### Aggregated rectangle exclusion

Write \(s=\min(n,m)\) and \(L=\max(n,m)\). The reformulation enumerates pairs of positions on the shorter axis. For each pair \((a,b)\), position \(t\) on the other axis, and colour \(c\), it introduces a continuous variable \(z_{abtc}\in[0,1]\) satisfying
\[
z_{abtc}\geq y_{atc}+y_{btc}-1.
\]
Indices are transposed when necessary to retain the original grid orientation.

It then imposes
\[
\sum_t z_{abtc}\leq 1
\]
for every pair and colour.

**Why this is exact:** if both cells at position \(t\) have colour \(c\), the lower bound forces \(z_{abtc}=1\). Two such positions would violate the sum constraint, and those two positions together with \((a,b)\) are exactly a monochromatic rectangle. Conversely, any rectangle-free colouring permits setting \(z\) to one exactly at simultaneous occurrences and zero elsewhere.

Thus, continuous auxiliaries suffice; they need not be binary or include additional upper bounds linking them to individual indicators. The formulation uses \(\binom{s}{2}LC\) continuous auxiliaries. Pairing along the shorter axis minimizes this count between the two possible orientations.

### Pigeonhole preprocessing

For each candidate colour limit \(q\in\{1,\ldots,C\}\), the model computes the minimum number of equal-colour unordered pairs in a line of length \(d\):
\[
P(d,q)=q\binom{a}{2}+ra,
\qquad
a=\left\lfloor d/q\right\rfloor,\quad r=d\bmod q.
\]

This minimum follows by balancing colour-class sizes: moving one item from a class at least two larger than another decreases the total number of equal-colour pairs.

If `objective` is at most \(q\), all cells use at most \(q\) labels. Summing within columns therefore produces at least \(mP(n,q)\) equal-colour row-pair occurrences. The rectangle rule allows each row pair to occur at most once per colour, giving capacity \(q\binom n2\). Hence,
\[
mP(n,q)>q\binom n2
\]
proves that `objective` must exceed \(q\). The same argument with rows and columns exchanged yields the second test,
\[
nP(m,q)>q\binom m2.
\]

Whenever either test fails, the reformulation adds the valid bound `objective ≥ q + 1`. These are necessary-condition bounds derived solely from the original constraints; they require no assumptions about symmetry or particular instance values.

## Compatibility and expected benefit

The reformulation preserves the original data interface, grid indices, colour labels, objective values, and minimization direction. It imposes no symmetry-breaking restrictions, so externally fixed cells remain compatible. The accompanying mapping script copies only the retained original variables, `x` and `objective`.

The intended benefit is to replace many reified disequality disjunctions with explicit linear constraints and aggregated pair capacities, while rejecting impossible colour limits before search. Actual performance depends on instance dimensions and the larger indicator formulation; no measured speedup was established in the conversation.

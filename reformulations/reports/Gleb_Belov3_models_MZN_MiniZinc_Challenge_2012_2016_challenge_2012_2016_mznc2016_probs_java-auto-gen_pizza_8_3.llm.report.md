# Pizza Selection and Pricing: Reformulation Report

## Problem background

The model represents a small pizza-ordering problem generated from an imperative program. Its structure suggests that **15 individual slice requests** must each be assigned to an acceptable pizza type. There are eight type identifiers: 23, 29, 35, 41, 47, 53, 59, and 65. These are entity identifiers, not prices.

The requests have three different admissibility patterns:

- The first five accept every type except 59.
- The next seven accept only types 47, 59, and 65.
- The last three accept every type except 23.

Slices assigned to the same type are accumulated. Every eight slices form a whole pizza, and any remaining slices are charged either individually or at the whole-pizza price, whichever is cheaper.

| Type identifier | Price per slice | Price per whole pizza |
|---|---:|---:|
| 23 | 4 | 11 |
| 29 | 5 | 10 |
| 35 | 4 | 14 |
| 41 | 5 | 16 |
| 47 | 3 | 10 |
| 53 | 4 | 15 |
| 59 | 3 | 11 |
| 65 | 5 | 16 |

The objective is to minimize the total order price while respecting every request’s acceptable types.

## Original model structure

### Variables

The original model contains:

- **15 primary choice variables**, named `chooseobj_*`, with the admissible domains described above.
- Corresponding `pizza_*` variables and singleton-domain lookup indices linking them to the choices.
- Bounded integer variables for intermediate slice counts, completed-pizza counts, prices, and running totals.
- Integer lookup indices selecting entries in generated arrays.
- **24 defined Boolean variables**: eight tests for reaching eight slices and sixteen tests used in conditional pricing.
- Defined arithmetic variables for increments, multiplication by prices, and accumulation of costs.

Many variables encode intermediate program states rather than independent ordering decisions.

### Constraints

The generated constraints implement a sequence of updates through array-element lookups. A typical lookup requires:

1. The selected entry to have the requested pizza identifier.
2. The entry’s activation condition to hold.
3. The selected index to be at least every applicable update index.

Together, these conditions select the **latest applicable update**. Some lookups also contain a final fallback entry, whose availability depends on the surrounding conditional computation.

The slice-update sequence increments the selected type’s count. From the eighth request onward, a count reaching eight triggers a reset to zero and an increment of the completed-pizza count. Earlier resets are unnecessary because fewer than eight requests have been processed.

The pricing constraints then calculate each type’s whole-pizza charge and, when a remainder is positive, the cheaper of its individual-slice charge and whole-pizza price.

### Objective

The model minimizes `objective`, which is linked through return-value and running-total variables to the sum of the eight type-specific prices. Its lengthy search annotation reflects the generated program structure; it is not a compact mixed-integer formulation.

## Reformulation and validity

### 1. Consolidation of generated lookups

Repeated lookup blocks were replaced by a common predicate. For each possible selected index, it enforces the same key match, activation condition, and returned value. It also retains the lower-bound implications that enforce update precedence.

This replacement is valid because it expresses the original element constraints and index implications directly. Where the original includes a fallback entry, that entry remains exempt from the precedence requirement, as in the source. Entries beyond an index variable’s declared upper bound are omitted because they could never be selected.

The reformulation retains all original independent scalar variables, including conditionally unused values and lookup indices. Thus, it does not assume that every generated auxiliary is uniquely determined by the primary choices.

### 2. Binary assignment representation

A binary variable is introduced for each request–type pair. Each request selects exactly one type, and its original choice variable equals the identifier-weighted sum of its assignment variables. Assignments outside the original choice domain are fixed to zero.

These constraints preserve the original choices exactly: a one-hot row identifies one admissible type, and every original admissible choice has a corresponding one-hot row. The additional representation exposes assignment structure directly to HiGHS.

### 3. Count-based pricing

For each type, a second one-hot representation selects its total assigned slice count, from zero through 15. This count equals the sum of its assignment variables.

If type \(k\) receives \(n\) slices, its price is represented by the precomputed expression

\[
C_k(n)
=
P_k\left\lfloor \frac{n}{8}\right\rfloor
+
\min\!\left(s_k(n\bmod 8),\,P_k\right),
\]

where \(s_k\) and \(P_k\) are its slice and whole-pizza prices.

This is justified by the original update sequence: each assignment adds one slice; reaching eight resets the remainder and records a completed pizza. Consequently, the final completed-pizza count and remainder are \(\lfloor n/8\rfloor\) and \(n\bmod 8\). The original pricing branches implement the minimum in the formula.

The count-based equations supplement, rather than replace, the retained lookup relationships. They provide direct linear links between assignments, final counts, and prices, avoiding reliance solely on a long chain of conditional lookups.

### 4. Eligibility-based count preprocessing

A type cannot receive more slices than the number of requests whose original domains contain it. Count-selector variables above this bound are fixed to zero.

For example, type 23 appears only in the first five request domains, so it cannot receive more than five slices. This also explains why no completed-pizza variable is needed for that type. The preprocessing follows directly from the original choice domains and the requirement that each request makes exactly one choice.

### 5. Certified objective bounds

The reformulation derives matching lower and upper bounds of **20**.

For the lower bound, relax every whole-pizza price to the minimum price, 10, and every individual-slice price to the minimum slice price, 3. If \(p\) whole pizzas are purchased, they can cover at most \(8p\) of the 15 requested slices. Any remaining demand requires at least \(\max(0,15-8p)\) individually charged slices. Therefore,

\[
\text{cost}
\ge
\min_{p\ge 0}
\left[10p+3\max(0,15-8p)\right]
=20.
\]

This relaxation can only reduce cost: it ignores type restrictions, uses the cheapest prices, and permits unused whole-pizza capacity.

For the upper bound, type 47 belongs to every request’s original domain. Assigning all 15 requests to it costs

\[
10+\min(7\cdot3,10)=20.
\]

Thus, the upper-bound constraint excludes no optimal solution. Together, the bounds establish the optimal objective without fixing a particular optimal assignment.

### 6. Arithmetic simplification and solution mapping

Generated arithmetic aliases were substituted by their defining expressions. Large enumerated domains for prices and totals were replaced by interval bounds where the retained arithmetic already implies membership in the original sparse domains. For example, a whole-pizza charge remains a multiple of its price because the multiplication relationship is retained.

The mapping script returns only original independent variables. Nonfixed scalars are copied from the default DZN solution; singleton-domain indices are reconstructed as 1 from their original declarations. Variables defined by expressions in the original model need not be returned, and reformulation-specific auxiliaries are excluded.

## Expected computational effect

The revised model exposes assignment, counting, and pricing structure to the mixed-integer solver while preserving the generated lookup behavior needed for reconstruction. Eligibility preprocessing removes impossible count selections, and the matching objective bounds eliminate the need to search for a better objective value. The remaining task is to find a feasible assignment and consistent original auxiliary values at cost 20.

These are structural reasons to expect faster solving; no measured runtime comparison was provided.

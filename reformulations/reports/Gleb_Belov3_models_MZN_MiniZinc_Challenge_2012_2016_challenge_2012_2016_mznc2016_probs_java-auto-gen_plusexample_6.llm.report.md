# Reformulation Report

## 1. Problem background and interpretation

This automatically generated model represents a small **integer allocation problem with overlapping capacity limits**. It selects 13 ordered quantities, each between 0 and 5, and seeks to maximize their total. Groups of six consecutive quantities are subject to a common limit of 19.

A possible application is allocating production, workload, or resource use across consecutive periods, where both individual quantities and rolling-window totals are bounded. However, the source contains no application-specific labels or units, so this interpretation is inferred rather than established.

The original model obscures this structure through numerous intermediate variables, fixed-index array lookups, and a permutation that conditionally activates the capacity limits.

## 2. Original model structure

### Variables and arithmetic

The main allocation variables are the 13 integers named `chooseint_239` through `chooseint_587`, each with domain `0..5`.

Additional variables represent:

- Copies of the allocation variables, named `unnamed_*` and `i_*`.
- Prefix sums of all allocations, represented by `Add_*` and `total_*`.
- Partial sums within eight overlapping six-position windows, represented by `Add_*` and `grouptotal_*`.
- Lookup indices, all declared with the singleton domain `1..1`.
- Eight derived Booleans, `Greater_*`, indicating whether the corresponding window total exceeds 19.
- A nine-element integer array, `prev`, whose entries lie in `1..9`.

Every lookup index is fixed to 1. Thus, expressions such as `[chooseint_239, 5][iunnamed_242]` necessarily select the first entry; the second entry does not affect the feasible assignments.

### Permutation and conditional constraints

The array `prev` satisfies an all-different constraint, `prev[1] = 2`, and the following restricted domains:

| Entry | Allowed values |
|---|---|
| `prev[2]` | `{2,6}` |
| `prev[3]` | `{1,3}` |
| `prev[4]` | `{4,9}` |
| `prev[5]` | `{3,5}` |
| `prev[6]` | `{6,8}` |
| `prev[7]` | `{5,7}` |
| `prev[8]` | `{4,8}` |
| `prev[9]` | `{7,9}` |

Eight implications connect selected values of `prev` to the negations of the `Greater_*` variables. When an implication is active, its corresponding six-position total must be at most 19.

### Objective

The variable `obj_max` equals the sum of all 13 allocations. The model defines

\[
\text{objective}=-\text{obj\_max}
\]

and **minimizes** `objective`. This is equivalent to maximizing total allocation, but the reformulation retains the original objective sign and minimization direction.

## 3. Reformulation and justification

### Forced-permutation preprocessing

The permutation has no actual freedom. Starting from `prev[1] = 2`, all-different propagation forces the following sequence:

1. `prev[2] = 6`, because 2 is already used.
2. `prev[6] = 8`, because 6 is already used.
3. `prev[8] = 4`, because 8 is already used.
4. `prev[4] = 9`, because 4 is already used.
5. `prev[9] = 7`, because 9 is already used.
6. `prev[7] = 5`, because 7 is already used.
7. `prev[5] = 3`, because 5 is already used.
8. `prev[3] = 1`, because 3 is already used.

Consequently,

\[
\text{prev}=[2,6,1,9,3,8,5,4,7].
\]

This is a logical consequence of the original constraints, not a symmetry-breaking choice or an additional assumption.

### Replacement of conditional constraints by linear inequalities

Every antecedent of the original eight implications is true under the forced permutation. Therefore, every `Greater_*` variable must be false.

Writing the allocation variables in their original order as \(x_1,\ldots,x_{13}\), their Boolean definitions imply exactly

\[
\sum_{j=s}^{s+5}x_j\leq19,
\qquad s=1,\ldots,8.
\]

The final model imposes these eight inequalities directly. Conversely, these inequalities make all eight original Boolean tests false, so the forced permutation satisfies every original implication. The replacement is therefore exact.

### Elimination of deterministic auxiliary variables

The final model retains the original 13 allocation variables but eliminates their copies, fixed lookup indices, intermediate sums, Boolean tests, and the forced permutation from the optimization formulation.

This uses **constant propagation and substitution of defining equalities**:

- Every lookup index is necessarily 1.
- Every copied value equals its corresponding allocation.
- Every intermediate total is uniquely determined by the allocations.
- Every Boolean test is false under the window constraints.
- The permutation is uniquely determined as shown above.

The original sum domains do not impose hidden additional restrictions: a partial sum of \(k\) variables in `0..5` automatically lies in `0..5k`.

The accompanying mapping script reconstructs every eliminated original independent variable from the 13 emitted allocation values and the fixed information embedded in the original self-contained instance. Variables originally defined by expressions can be recomputed from their original definitions.

### Valid aggregate bound

The reformulation adds the redundant inequality

\[
\text{obj\_max}\leq43.
\]

The first window bounds \(x_1+\cdots+x_6\) by 19, and the seventh bounds \(x_7+\cdots+x_{12}\) by 19. Adding these inequalities and the original bound \(x_{13}\leq5\) gives

\[
\sum_{j=1}^{13}x_j\leq19+19+5=43.
\]

This is an **aggregation-based valid inequality**. It excludes no feasible solution and explicitly supplies an objective bound already implied by the linear constraints.

## 4. Expected computational effect

The resulting formulation is a small, purely linear integer model with 13 allocation decisions and eight rolling-window capacity inequalities. It avoids encoding the all-different constraint, conditional implications, and Boolean comparisons for the HiGHS backend, while also removing unnecessary generated arithmetic structure and search annotations.

The reformulation preserves the full feasible allocation set, reconstructs the original variables, and retains objective values and optimization direction. Its computational benefit is expected from the simpler formulation; no measured runtime improvement is claimed.

# Grid-Based Placement with Limited Horizontal Wire Displacement

## Problem background

The model represents a discrete placement problem, plausibly motivated by electronic layout or another application involving components connected to fixed entry points along the bottom of a container. This interpretation is inferred from the variable names and constraints rather than from an explicit application description.

The instance contains a **25-column by 13-row grid** and **325 unit-sized blocks**, divided into **five levels of 65 blocks each**. Block \(j\) in every level has the same horizontal wire-entry coordinate,
\[
o_j=\frac{25j}{66}.
\]
A block placed in column \(n\) has horizontal center \(n-\tfrac12\). The objective minimizes the largest absolute horizontal displacement between a block and its entry point. Despite the terminology “wire length,” the model does **not** include vertical distance or explicit wire routing.

Blocks in the same level must have row coordinates differing by at most three. A block in level \(i\) may occupy only rows at or below \(3i\), subject to the container height. The commented-out constraints imposing additional ordering between levels are inactive.

## Original formulation

### Variables and objective

The original model contains:

- **105,625 binary placement variables**, one for each combination of level, block, row, and column.
- **One independent continuous variable**, `maximumWireLength`, which is minimized.
- **325 defined variables**, `wireLength`, representing signed horizontal displacement. These are expressions determined by the placement variables, not independent decisions.

### Constraints

The original formulation has **338,651 explicit constraints**:

| Constraint family | Count | Purpose |
|---|---:|---|
| `foundPlace` | 325 | Place each block at most once |
| `usedOnce` | 325 | Allow at most one block in each grid cell |
| `allPlaced` | 1 | Require 325 placements overall |
| `absoluteLength1`, `absoluteLength2` | 211,250 | Bound both signs of each selected placement’s horizontal displacement |
| `notFar` | 325 | Bound each block’s signed displacement by 1 |
| `levelClose1`, `levelClose2` | 20,800 | Limit pairwise row differences within each level to 3 |
| `levelLocation1` | 105,625 | Restrict level \(i\) to rows no higher than \(3i\) |

The parameter `objectiveBound` is somewhat misleadingly named: its value of 1 bounds **signed** displacement through `notFar`. It does not impose an upper bound of 1 on the objective or on absolute displacement.

## Reformulation and its justification

### 1. Replace aggregate placement requirements with exact assignment

The 325 `foundPlace` constraints each limit a block’s total placement to at most one. Meanwhile, `allPlaced` requires the sum of those totals to equal 325. Consequently, every block’s total must equal one.

The reformulation therefore uses one exact-assignment equality per block and removes `allPlaced`. This is an equivalent replacement and supports the subsequent preprocessing.

### 2. Remove placements prohibited by existing constraints

Two original restrictions directly eliminate candidate cells:

- **Height restriction:** If \(m>3i\), the original inequality
  \[
  m\,\text{placement}_{ijmn}\le 3i
  \]
  forces that binary variable to zero.
- **Signed-displacement restriction:** Exact assignment means that `wireLength` equals the signed displacement of the selected cell. Therefore, any cell satisfying
  \[
  o_j-(n-\tfrac12)>1
  \]
  cannot be selected without violating `notFar`.

The reformulated placement domain excludes these cells. Once every retained cell individually satisfies the signed-displacement bound, exact assignment makes `notFar` redundant. Importantly, this filtering preserves the original **one-sided** bound rather than replacing it with an absolute-distance restriction.

### 3. Derive stronger row bounds from capacity

The first \(i\) levels contain \(65i\) blocks. Exact assignment and `usedOnce` imply that they occupy \(65i\) distinct cells. Because each row contains only 25 cells, some block among these levels must reach at least row
\[
r_i=\left\lceil\frac{65i}{25}\right\rceil.
\]

For this instance, \(r_i>3(i-1)\). Every block in an earlier level is restricted by `levelLocation1` to rows no higher than \(3(i-1)\), so the block reaching row \(r_i\) or higher must belong to level \(i\). The original within-level separation constraints then require every block of level \(i\) to lie at or above \(r_i-3\).

Combining these implications gives the retained row ranges:

| Level | Retained rows |
|---|---|
| 1 | 1–3 |
| 2 | 3–6 |
| 3 | 5–9 |
| 4 | 8–12 |
| 5 | 10–13 |

This is **capacity-based bound propagation**, using assignment, cell capacity, level-specific height limits, and within-level separation.

### 4. Strengthen the displacement formulation

For each block, the reformulation replaces all cellwise displacement inequalities with
\[
\text{maximumWireLength}\ge
\sum_{m,n}|o_j-(n-\tfrac12)|\,\text{placement}_{ijmn}.
\]

For an integral exact assignment, only one term is selected, so the inequality bounds precisely the same absolute displacement as the original constraints.

For fractional assignments, the weighted sum is at least each individual nonnegative term. Thus, the replacement **strengthens the LP relaxation** while substantially reducing the constraint count. An explicit nonnegative bound on `maximumWireLength` is also valid because the original paired inequalities already imply nonnegativity.

### 5. Replace pairwise separation with a shared interval

The reformulation introduces one continuous lower endpoint per level. Every block’s row coordinate must lie between that endpoint and the endpoint plus three.

This is equivalent to the original pairwise restrictions:

- A common interval of length three guarantees that every pair of row coordinates differs by at most three.
- Conversely, if all pairwise differences are at most three, choosing the minimum row coordinate as the endpoint produces such an interval.

The endpoint bounds follow from the row bounds established above. This **extended formulation** replaces the quadratic number of pairwise constraints with two inequalities per block.

## Resulting model and solution recovery

The reformulated instance has **18,417 binary variables**, **six independent continuous variables**, and **1,625 explicit constraints**, while retaining the 325 defined displacement expressions.

The intended computational benefits are fewer binary decisions, far fewer constraints, and a stronger displacement relaxation. These are structural improvements; no measured solve-time reduction is claimed.

The mapping script restores every eliminated original placement variable to zero, as justified by the preprocessing, and copies retained placements and `maximumWireLength`. Auxiliary interval variables are omitted, and the original defined variables are evaluated from the reconstructed placements. The minimization direction, feasible original placements, and objective values are preserved.

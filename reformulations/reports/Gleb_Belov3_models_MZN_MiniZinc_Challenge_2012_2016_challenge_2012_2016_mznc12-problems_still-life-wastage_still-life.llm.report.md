## Background and problem meaning

The model concerns **still-life patterns in Conway’s Game of Life** on an \(n\times n\) board. Each cell is either live or dead. A still life remains unchanged under the Game of Life update rule:

- A live cell must have exactly two or three live neighbors among its eight surrounding cells.
- A dead cell must not have exactly three live neighbors.

The board is surrounded by a fixed dead border. Additional constraints prohibit three consecutive live cells along each outer edge, preventing births immediately outside the board.

This is a discrete pattern-optimization problem rather than a direct physical application. The formulation uses local **wastage** measures to assess pattern quality. Although related to dense still-life optimization, the supplied model does **not** explicitly equate its objective with the number of live cells; that equality appears only as a commented-out constraint.

## Original model structure

For nonnegative \(n\), the model declares \(2(n+2)^2+(n+2)+1\) top-level integer variables:

| Variable | Domain and role |
|---|---|
| `x` | \((n+2)^2\) binary variables representing the board and its dead border |
| `w` | \((n+2)^2\) variables in \(0..2\), representing local wastage |
| `wastage_sum` | \(n+2\) bounded integer variables accumulating wastage row by row |
| `OBJECTIVE` | One integer variable in \(0..n^2\) |

Each interior cell has a local constraint involving three quantities:

- \(S_1\): the number of live neighbors;
- \(S_2\): the number of live orthogonal neighbors plus four products of adjacent diagonal-neighbor pairs;
- \(S_3\): the number of live orthogonal neighbors.

The local constraints enforce Life stability and conditional lower bounds on wastage. These bounds do not generally fix wastage to its minimum.

Boundary wastage is linked to the adjacent interior cell through equations of the form \(w+x=1\). Corner wastage remains subject to its original domain and aggregate constraints.

The objective is defined by
\[
4\,\texttt{OBJECTIVE}
=2n^2+4n-\texttt{wastage\_sum}[n+1].
\]
Thus, maximizing `OBJECTIVE` minimizes total wastage, subject also to the objective’s integer domain and this exact equality. The model includes additional cumulative-wastage inequalities attributed in its comments to Chu et al. (2012). These inequalities were retained unchanged.

## Reformulation and justification

The reformulation replaces nonlinear products and conditional local rules with an explicit mixed-integer linear formulation suitable for **HiGHS**. All original decision variables and the external parameter `n` are retained.

### 1. Linearize and share binary products

Each diagonal-pair product used in \(S_2\) is represented by a shared binary variable. For binary operands \(a,b\), the constraints
\[
p\le a,\qquad p\le b,\qquad p\ge a+b-1
\]
enforce exactly \(p=ab\).

These products involve cells two positions apart horizontally or vertically. A shared representation avoids separately modeling the same product wherever neighboring local constraints use it.

**Boundary preprocessing:** If either operand lies on the fixed dead border, the product is fixed to zero. This follows directly from the original border equations and does not impose any new restriction on the interior pattern.

### 2. Encode Life stability with one binary selector per interior cell

Let \(c\) be the center-cell value, \(S_1\) its neighbor count, and \(h\) a new binary selector. The reformulation imposes
\[
h+c\le1,\qquad
S_1\ge2c+4h,\qquad
S_1\le2+c+6h.
\]

These inequalities reproduce the original stability rules exactly:

- If \(c=1\), then \(h=0\), giving \(2\le S_1\le3\).
- If \(c=0\), then \(h=0\) permits \(S_1\le2\), while \(h=1\) permits \(S_1\ge4\).

Because \(S_1\) is an integer between zero and eight, the dead-cell case excludes exactly \(S_1=3\).

### 3. Replace conditional wastage bounds with linear inequalities

The original wastage implications are equivalent to
\[
w\ge2c-S_2,\qquad
w\ge2-S_3-2c,\qquad
w\ge2S_3-6-2c.
\]

Their validity follows from the original domains and thresholds:

- For a live cell, the first inequality requires \(w\ge2\) when \(S_2=0\), \(w\ge1\) when \(S_2=1\), and no additional restriction when \(S_2\ge2\).
- For a dead cell, the second inequality gives the required lower bounds at \(S_3=0\) and \(S_3=1\).
- For a dead cell, the third inequality requires \(w\ge2\) exactly when \(S_3=4\).

In the other cases, these inequalities are redundant with \(w\ge0\). Crucially, they preserve the original freedom to choose wastage above its local minimum.

### 4. Preserve aggregate constraints and solution correspondence

The reformulation retains the boundary constraints, cumulative-wastage equations, original wastage cuts, objective equality, and maximization direction. It adds no new literature-based cuts and does not activate the commented-out live-cell-count equality.

The solution-mapping script is an identity mapping for `x`, `w`, `wastage_sum`, and `OBJECTIVE`; auxiliary variables are omitted. Consequently, no reconstruction of the original board or wastage variables is needed.

These changes aim to expose a compact linear formulation directly to HiGHS and reduce reliance on generic implication and product translations. No measured runtime improvement was established in the conversation.

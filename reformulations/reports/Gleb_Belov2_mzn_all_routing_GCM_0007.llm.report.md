## Overview

The model describes **three-dimensional pipe routing in an industrial installation**. A pipe must connect two fixed nozzles while avoiding equipment and existing pipework. Its route consists of axis-aligned straight legs joined by bends. The model also requires intermediate nodes to lie in designated support regions and imposes a length-based flexibility condition, apparently intended to represent mechanical flexibility requirements.

The supplied instance contains one pipe, 10 ordered nodes, and nine possible connecting legs. Coordinates use a discretization of 200 mm per unit. The environment contains 112 boxes representing equipment, existing pipe segments, support zones, a rack, and preferred rack support levels.

## Original formulation

### Variables and route representation

The original independent decision variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates and 24 unfixed coordinates.
- **Two arrays of leg-box boundaries**, each containing 30 integer entries. These describe the pipe leg’s spatial extent, including its radius.
- **30 nonnegative directional length entries**, one for each node-indexed leg slot and coordinate axis.
- **10 direction variables**, encoding an absent leg or one of six signed coordinate directions.
- **10 existence flags and 10 last-leg flags**.
- An integer objective variable.

The arrays include a dummy final leg slot whose entries are fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and sums of cubed lengths.

### Constraints

The principal constraint groups are:

1. **Axis-aligned geometry.** Direction variables select the only axis on which a leg may have positive length. Boundary, coordinate, and length constraints together make that length equal to the absolute displacement between its endpoints and make its bounding box tight.

2. **Route continuity and termination.** Existing legs form a prefix of the available sequence. Exactly one is marked as the last leg, and at least the first three legs exist. Zero-length trailing legs repeat the terminal position.

3. **Nozzle and bend restrictions.** The first and last existing legs have prescribed directions and nozzle-specific length bounds. Consecutive existing legs must use different axes. The general minimum positive leg length also applies to nozzle legs.

4. **Obstacle clearance.** Each relevant leg must be separated from each obstacle along at least one coordinate axis, including the specified safety distance. Special exemptions permit connection through the endpoint equipment boxes.

5. **Support requirements.** Intermediate nodes must belong to a support region, with vertical membership measured at the bottom of the pipe. These requirements are retained even for intermediate nodes corresponding to unused trailing legs.

6. **Flexibility.** For each coordinate axis, the model compares every orthogonal leg length against the sum of cubes of all orthogonal leg lengths. The coefficient depends on endpoint separation, the physical length unit, and the supplied flexibility parameter.

The source also contains inter-pipe separation constraints, but these generate no active restrictions in this single-pipe instance. A rack-traversal requirement appears only as commented-out code and is not enforced.

### Objective

The model minimizes scaled pipe-length, bend, and support costs. For this instance, the effective coefficients are:

- **161 per unit of pipe length**;
- **1601 per existing leg after the first**, representing bend cost;
- **51 per supported bend outside preferred rack levels**, or **1 inside a preferred level**.

These coefficients include the original integer division and subsequent addition of one; the reformulation preserves them exactly.

## Reformulation and validity

### 1. Exact clipping of the cubic flexibility expressions

The main change replaces variable cubic powers with a bounded linear lookup formulation suitable for HiGHS.

For one flexibility constraint group, write the relevant nonnegative lengths as \(x_j\). The original inequalities are

\[
C x_j \leq \sum_i x_i^3
\qquad\text{for every }j.
\]

Let \(M=\max_i x_i\). If \(M^2\geq C\), then

\[
\sum_i x_i^3 \geq M^3 \geq CM \geq Cx_j,
\]

so the entire group is automatically satisfied.

The reformulation derives a common integer threshold \(H\) satisfying \(H^2\geq\max C\), and replaces each flexibility-expression length by

\[
y_j=\min(x_j,H).
\]

This replacement is exact:

- If all relevant lengths are below \(H\), nothing changes.
- If any relevant length reaches \(H\), both formulations are automatically feasible for that group. In the clipped formulation, one term contributes \(H^3\), while every left-hand side is at most \(CH\leq H^3\).

For the supplied instance, **\(H=65\)**, compared with the original general length bound of 380. Actual geometric lengths and their objective contributions remain unchanged; only the flexibility calculations use clipped lengths.

### 2. Linear lookup encoding and domain preprocessing

Binary selectors choose each clipped integer length. Linear weighted sums then define both its clipped value and its cube. The final lookup entry represents every actual length at least \(H\), with linear linking constraints enforcing this interpretation.

Impossible entries are fixed to zero using consequences of the original constraints:

- Tight leg geometry bounds length by the largest possible endpoint-coordinate difference.
- Existing pipe-length upper bounds remain applicable.
- First and last possible legs inherit their nozzle-axis restrictions and nozzle-length upper bounds.
- Nonzero lengths below the general minimum are impossible because the original direction implications require every active axis to meet that minimum.
- Dummy leg entries must be zero.

Additional linking equalities connect positive lookup selections to direction and existence flags. They are valid because the original model permits positive length exactly on an existing leg’s selected axis.

### 3. Linear support-cost reformulation

The original support-cost expression multiplies an existence flag by a membership-dependent cost. The reformulation distributes that product and replaces products of binary quantities by Boolean conjunctions:

\[
ab=\mathbf{1}[a=1\land b=1].
\]

This preserves support costs exactly while avoiding a general integer-product expression. The original support-membership definitions and the domain of the “not in preferred level” flag are retained.

### 4. Data and solution-interface preservation

An accidentally duplicated triplet in the intermediate size-array transcription was removed, restoring the **original box dimensions and entity ordering**.

All original independent decision variables remain in the final model. The mapping script copies these variables, excludes new auxiliary variables, and supplies the six fixed endpoint coordinates from the original embedded data if the solver omits them. It reports missing nonfixed variables rather than guessing values.

## Expected computational effect

The reformulation replaces nonlinear powers with an exact finite mixed-integer linear representation, limits that representation to a small threshold, and removes impossible selector values before solving. These changes are intended to improve compatibility and solution efficiency with HiGHS. No measured runtime improvement or optimality result was established in the conversation.

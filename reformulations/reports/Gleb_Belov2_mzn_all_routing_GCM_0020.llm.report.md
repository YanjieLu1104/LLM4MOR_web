# Industrial Pipe Routing with Flexibility Constraints

## Background

The model represents the routing of a pipe through a three-dimensional industrial installation. Its fixed geometry comprises equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack-support levels. Coordinates use a discretization of **200 mm per unit**.

The pipe connects two fixed nozzles through axis-aligned segments. A feasible route must avoid obstacles with prescribed clearances, respect nozzle approach directions and lengths, and place intermediate nodes in support zones. Additional cubic-length constraints model pipe flexibility: sufficiently long segments perpendicular to a nozzle-displacement direction provide flexibility in that direction.

The objective balances material length, bends, and support costs.

## Original Model Structure

### Variables and route representation

The instance contains one pipe with **10 nodes and nine possible segments**. Its original independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates;
- **60 integer segment-box coordinates**, representing lower and upper bounds in three dimensions;
- **30 nonnegative directional segment lengths**;
- **10 direction variables**, taking values from zero through six;
- **20 binary-valued integer flags**, recording segment existence and the final active segment;
- One integer objective variable.

The segment arrays have ten entries to match the node indexing. The tenth entry does not represent an actual segment and is fixed to zero. Direction zero represents an inactive segment; the other six values represent positive or negative movement along a coordinate axis.

Derived expressions describe obstacle separation, support-zone membership, support charges, and sums of cubed segment lengths.

### Constraints

The main constraint groups are:

1. **Geometry and directions.** Segment boxes contain their endpoints. Their widths, after subtracting pipe diameter contributions, equal directional lengths. Direction constraints force each active segment to follow exactly one axis and make its length equal to the corresponding endpoint displacement.

2. **Route continuity and termination.** Active segments form a contiguous prefix, with at least three active segments and exactly one final segment. Inactive segments have zero lengths, so subsequent nodes coincide.

3. **Bends and nozzles.** Consecutive active segments use different axes, preventing straight continuations and immediate reversals. The first segment points in the negative \(x\)-direction; the final active segment points in the negative \(z\)-direction. Both nozzle segments have lengths between two and fifteen coordinate units.

4. **Obstacle clearance.** Each applicable segment must be separated from each obstacle along at least one coordinate axis. Specific exceptions allow connection to the starting and ending equipment modules.

5. **Support placement.** Intermediate nodes must belong to a support zone, including nodes associated with inactive route positions. Preferred rack levels affect support costs.

6. **Flexibility.** For each coordinate direction, a coefficient based on nozzle displacement multiplies every perpendicular segment length. Each resulting quantity must not exceed the sum of cubes of all perpendicular segment lengths.

The source also contains inter-pipe separation constraints. They have no applicable pairs in this single-pipe instance.

### Objective

The model minimizes its original scaled integer cost. For this instance, the coefficients are:

- **481** per unit of pipe length;
- **4,801** per active segment after the first;
- **51** per chargeable support outside preferred rack levels, or **1** within a preferred level.

The reformulation preserves these coefficients, including the original integer division and subsequent addition of one.

## Reformulation and Validity

### Exact truncation of flexibility lengths

The main change replaces variable cubes over the full length range with small, constant-table lookups.

Let \(C\) be the largest nonnegative flexibility coefficient, and choose the smallest nonnegative integer \(H\) satisfying \(H^2 \ge C\). Each flexibility calculation uses
\[
t_j=\min(l_j,H)
\]
instead of the original length \(l_j\), on **both sides** of the flexibility inequalities. For this instance, \(C=262\) and \(H=17\), so the cube table needs only values for lengths zero through seventeen.

This transformation is exact. Consider one group of perpendicular lengths and its coefficient \(c\le C\):

- If every length is below \(H\), truncation changes nothing.
- Otherwise, let \(M\ge H\) be the largest original length. Its cube satisfies
  \[
  M^3\ge cM\ge cl_j
  \]
  for every length in the group. Thus all original inequalities hold.
- In the truncated group, at least one length equals \(H\), and every truncated length is at most \(H\). Consequently,
  \[
  \sum_j t_j^3\ge H^3\ge cH\ge ct_j,
  \]
  so all transformed inequalities also hold.

Therefore the original and transformed flexibility requirements accept exactly the same routes. Actual lengths remain unchanged in geometry and cost calculations. The table formulation removes variable exponentiation and substantially reduces the range needed to represent its nonlinear effect.

### Geometric bound tightening

Each directional length receives an explicit upper bound derived from its two endpoint-coordinate domains.

This is valid because the original box-width and direction constraints jointly force a directional length to equal the absolute endpoint difference on the selected axis, and zero on other axes. It cannot exceed the largest difference permitted by those endpoint domains.

The reformulation also adds the valid inequalities
\[
\sum_{\text{segments }j} l_{j,k}
\ge
\left|x_{\text{end},k}-x_{\text{start},k}\right|
\]
for each axis \(k\). These follow from route continuity and the triangle inequality: accumulated absolute movement cannot be smaller than net endpoint displacement. They strengthen the relaxation without excluding any feasible route.

### Simpler separation and support-cost expressions

Obstacle-separation expressions are written directly in the required disjunctions rather than through a separate three-dimensional Boolean array. This is substitution of the original Boolean definitions, with all clearance conditions and nozzle exceptions retained.

Support costs use a conditional expression instead of multiplying a binary existence flag by a variable cost. Since the flag is constrained to zero or one, the conditional is exactly equivalent: an inactive segment incurs zero cost, while an active segment incurs the original support charge.

The final model retains the general inter-pipe separation constraint. Its index filter generates no constraints here because all nodes belong to the same pipe.

### Indexing, data, and solution interface

Boundary tests use explicit conditional guards to avoid referencing nodes outside their declared domains. A transcription error in the box-size literal was corrected by restoring the original supplied data, not by changing the geometry.

All original independent decision variables retain their names and meanings. The accompanying mapping script copies those variables, restores fixed endpoint coordinates from the original embedded constants when necessary, and excludes reformulation-specific auxiliaries.

These changes target a smaller and more tractable HiGHS formulation. No measured runtime improvement is established by the supplied feedback.

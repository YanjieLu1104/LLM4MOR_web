# Reformulation Report: Hans_Mittelmann4_ns3084303

## 1. Inferred application and modeling scope

The model represents a **single-vehicle routing and visit-sequencing problem with load changes and precedence requirements**. A vehicle visits 25 locations, placing exactly one location in each of 25 successive visit positions. Each location has a signed load change, and the cumulative load must not exceed a capacity of 10. Four location pairs impose visit-order requirements.

The instance data are generated within the model: load changes are rounded random values between −3.5 and 3.5, and distances between distinct locations are symmetric, rounded random values between 1 and 10. Diagonal distances evaluate to zero.

Two details distinguish this formulation from a conventional capacitated vehicle-routing model:

- **Loads may be negative.** The model imposes an upper capacity limit but no lower bound on cumulative load.
- **The declared starting location does not anchor the route.** The constraint `y[s,0] = 1` fixes one day-zero indicator, but day zero is not linked to the subsequent visit sequence or selected arcs. Other day-zero indicators are also unconstrained beyond being binary.

The reformulation preserves these features rather than adding conventional routing assumptions.

## 2. Original formulation

### Variables

The original model contains:

| Variable | Meaning | Type | Count |
|---|---|---|---:|
| `x[i,j]` | Whether the directed arc from location \(i\) to location \(j\) is selected | Binary | 625 |
| `y[i,t]` | Whether location \(i\) is assigned to position \(t\), including position zero | Binary | 650 |
| `f[t]` | Cumulative load after position \(t\) | Unrestricted continuous | 26 |

Thus, there are **1,275 binary variables and 26 continuous variables**.

### Constraints and objective

The original model has **15,156 constraints**:

- 50 constraints requiring at least one incoming and outgoing arc per location;
- 50 assignment constraints making positions 1 through 25 a permutation of the locations;
- one day-zero starting-location constraint;
- 15,000 arc–sequence implications;
- four precedence constraints;
- one initial-load equation;
- 25 load-balance equations; and
- 25 upper-capacity constraints.

The arc–sequence constraints imply that, if a location occupies a nonfinal position and an outgoing arc is selected from it, the destination must occupy the next position.

The objective **minimizes the total distance of all selected arcs**. Load evolves from `f[0] = 0` by adding the signed load change at each visited location.

## 3. Reformulation and justification

### 3.1 Optimality-preserving restriction to a directed cycle

The incoming and outgoing degree inequalities were replaced by equalities, and all self-arcs were fixed to zero.

This restriction follows from the original constraints:

1. The assignment equations define an ordering \(v_1,\ldots,v_{25}\) of all locations.
2. For each nonfinal location \(v_k\), the arc–sequence implications prohibit every outgoing arc except \(v_k\to v_{k+1}\).
3. The outgoing-degree requirement therefore forces that consecutive arc to be selected.
4. These 24 forced arcs supply an incoming arc to every location except \(v_1\). Since the outgoing arcs of all nonfinal locations are already determined, the incoming-degree requirement for \(v_1\) forces \(v_{25}\to v_1\).

Consequently, every original feasible solution already contains the directed cycle defined by its ordering. Any additional selected arcs can only leave the final location. Deleting those extra arcs preserves all original constraints and cannot increase the objective because every distance is nonnegative.

The restriction therefore **preserves the optimal objective and at least one optimal solution**, although it deliberately excludes some original feasible solutions containing unnecessary arcs.

### 3.2 Compact position-based arc linking

The 15,000 time-indexed implications were replaced by **1,200 bounded big-M inequalities**, supported by 25 new continuous position variables:

\[
p_i=\sum_{t=1}^{25}t\,y_{i,t}.
\]

For each selected non-self arc \(i\to j\), the new constraints impose

\[
p_j=p_i+1-25y_{i,25}.
\]

This advances one position when \(i\) is nonfinal and returns to position 1 when \(i\) is final. Together with the assignment and degree equations, it describes exactly the cycle justified above.

The big-M constant is \(M=24=T-1\). It is valid because both the destination position and the required successor position lie between 1 and 25; their difference therefore has magnitude at most 24. No distance- or load-specific assumption is needed.

### 3.3 Cumulative precedence cuts

The four original precedence inequalities were retained, and **100 cumulative precedence inequalities** were added.

For every required pair \(i\) before \(j\), and every position \(t\), these inequalities require:

\[
\sum_{k\le t}y_{j,k}\le \sum_{k<t}y_{i,k}.
\]

They are valid because the assignment equations place distinct locations in distinct positions. Thus, the original non-strict position inequality actually requires \(i\) to occur strictly before \(j\). If \(j\) has appeared by position \(t\), then \(i\) must have appeared before position \(t\).

These cuts exclude fractional assignments that can satisfy an average-position inequality without adequately respecting precedence.

## 4. Result and expected computational effect

The reformulated model retains every original variable and adds **25 continuous position variables**. Its constraint count falls from **15,156 to 1,581**, a reduction of approximately **89.6%**.

The intended benefits are a smaller linking formulation, removal of unnecessary arc choices, and a stronger precedence relaxation. Actual runtime improvement remains solver- and instance-dependent; no computational speedup was established here.

All original parameter definitions, load equations, and day-zero behavior remain unchanged. Solution mapping simply removes the auxiliary position variables and returns the original `x`, `y`, and `f` values.

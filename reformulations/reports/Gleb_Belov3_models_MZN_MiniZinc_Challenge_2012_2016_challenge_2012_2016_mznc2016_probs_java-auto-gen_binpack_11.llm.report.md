# Bin-Packing Model Reformulation

## Problem background

The model represents a small **one-dimensional bin-packing problem**: assign items to identical containers without exceeding their capacities, while minimizing the number of containers used. Applications include allocating storage, consolidating shipments, and grouping jobs into fixed-capacity batches.

The instance contains 11 items, with sizes in their original order:

\[
(4,1,8,8,10,1,5,3,8,6,1).
\]

There are 11 available bins, each with capacity 20. The original bin identifiers are \(4,7,10,\ldots,34\); these are object references rather than capacities. The model does not establish a particular physical application or unit of measurement.

## Original model structure

The source is an automatically generated, procedural encoding rather than a conventional bin-packing formulation.

- **Placement variables:** Eleven `chooseobj_*` integer variables select bin object identifiers. Associated `items_*` and `iitems_*` variables identify the corresponding item collection and lookup position.
- **Capacity bookkeeping:** `spaceLeft_*` variables describe remaining capacity before successive placements and after all placements. Their selector variables implement “most recent matching update” lookups. The initial capacity is 20, and successive updates subtract the item sizes listed above.
- **Occupancy and counting:** Boolean variables identify empty bins. The `numUsed_*` variables and their selectors encode successive updates to the number of occupied bins.
- **Control flow:** The array `prev[1..34]`, constrained by restricted domains and `alldifferent`, represents a permutation of procedural control-flow nodes. Conditional constraints connect its arcs to capacity and occupancy checks.
- **Objective:** The model minimizes `objective`, which is linked to the final occupied-bin counter.

Much of the formulation therefore describes how a program computes bin loads and counts, rather than expressing those quantities directly.

## Reformulation and justification

### Direct binary assignment formulation

The new model introduces \(x_{ib}\in\{0,1\}\), indicating whether item \(i\) is assigned to bin \(b\), with

\[
\sum_b x_{ib}=1.
\]

Bin loads are expressed directly as

\[
L_b=\sum_i w_i x_{ib},
\qquad L_b\le 20u_b,
\]

where \(u_b\) is a binary occupancy variable. The constraints \(x_{ib}\le u_b\) and \(u_b\le\sum_i x_{ib}\) make occupancy exact.

This replaces the original state-update lookups. In the original model, the selected lookup must match the requested bin, while selector lower bounds exclude every matching update except the most recent one. Inductively, these lookups compute 20 minus the sum of item sizes assigned to that bin. The linear load equations compute the same quantity without reconstructing update histories during optimization.

### Elimination of procedural control flow

The capacity checks are mandatory consequences of the original permutation constraints, not optional restrictions.

For example, `prev[1] = 25` prevents `prev[25]` from taking its self-loop value 25. Its remaining choices force the preceding occupancy branch to connect to node 20. Because predecessor values cannot repeat, this forces `prev[20] = 10`. The same argument propagates backward through the restricted domains and forces all capacity-check arcs.

Within each occupancy branch, the permutation permits either passage through the increment node or bypassing it. The associated Boolean implications select precisely the branch matching whether the bin is occupied. Thus, once occupancy is known, the control-flow permutation can be reconstructed. It need not remain part of the optimization problem.

### Direct occupied-bin objective

The objective becomes

\[
\min \sum_b u_b.
\]

This preserves the original objective. When a bin is occupied, the original counter constraints prohibit its fallback lookup and select the latest earlier occupied-bin update, adding one. The final lookup has no accessible fallback entry, so it returns the total number of occupied bins. Counter values associated with unused intermediate updates may have additional freedom; the mapping chooses a valid, deterministic prefix-count representation.

### Volume lower bound

The total item size is 55. Summing the capacity inequalities gives

\[
55\le20\sum_bu_b,
\]

and integrality therefore implies

\[
\sum_bu_b\ge\left\lceil55/20\right\rceil=3.
\]

This valid inequality strengthens the model without excluding any feasible packing.

### Bin-symmetry breaking

The reformulation orders loads nonincreasingly:

\[
L_b\ge L_{b+1}.
\]

All bins have identical capacities and no bin-specific placement restrictions. Any packing can therefore be relabeled into this order without changing item groupings or the objective. This removes equivalent labeled solutions while retaining at least one representative of every packing, including an optimum. Original object identifiers are restored consistently by the mapping.

## Solution reconstruction and expected benefit

The Python mapping script reads the independently declared assignment array from the default solver output. Using fixed data from the original source, it reconstructs every original independent variable: object references, lookup positions, intermediate and final remaining capacities, occupancy flags, counters, and `prev`.

The resulting optimization model replaces variable-index lookups, procedural Boolean logic, and a permutation constraint with a compact mixed-integer linear formulation suited to HiGHS. The volume bound and symmetry breaking further strengthen the formulation and reduce redundant search. These are structural improvements; no measured runtime improvement is claimed here.

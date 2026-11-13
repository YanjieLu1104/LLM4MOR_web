# Reformulation Report: Mapping a Streaming Encoder onto a Network-on-Chip

## Background

The model describes a simplified mapping of an H.263 video encoder onto a multiprocessor network-on-chip (NoC). Its source cites Mirza, Gruian, and Kuchcinski, *“Mapping streaming applications on multiprocessors with time-division-multiplexed network-on-chip,”* Computers & Electrical Engineering, 40(8), 2014.

The hardware has \(k=\texttt{row}\times\texttt{col}\) processors. Application communication streams must have their source and destination endpoints assigned to processors, and integer flows must be routed through a supplied network. Endpoint assignments determine processor workload, while routing determines communication costs.

The implemented objective balances computational workload and attributed routing cost across processors. It does **not** minimize the aggregate communication-cost variable directly.

## Original Model Structure

### Decision variables

All original decision variables are bounded integers. They represent:

- **Placement:** `flow_processor` contains two processor assignments per communication stream. A separate `actor_processor` array is declared but is not linked to these assignments.
- **Routing:** `flows` contains one flow value per stream and network arc. Each stream has an associated `cost`.
- **Processor quantities:** `cpu_loads`, `cc`, and `flow_from_processor` record computational loads, attributed routing costs, and outgoing communication volume.
- **Link utilization:** `comm_full` sums per-stream traffic on each interprocessor link and imposes the link-bandwidth limit through its domain.
- **Aggregate network:** `total_flow` and `communication_cost` describe a second network-flow problem.
- **Other quantities:** `inFlow` and `outFlow` have zero-or-stream-size restrictions, while `commFlow` has only domain restrictions.
- **Objective:** `objective` is a bounded integer representing the maximum combined processor cost.

Dimensions depend on external data, so no numerical instance size can be established from the source alone.

### Constraints

The main constraints are:

1. **Unsplittable endpoint selection.** Each stream has exactly one nonzero entry among its first \(k\) arcs and exactly one among its last \(k\) arcs. Equivalences connect those nonzero entries to its source and destination processor assignments.
2. **Per-stream network feasibility.** A `network_flow_cost` constraint imposes flow conservation using the supplied balances and computes each stream’s routing cost.
3. **Aggregate network feasibility.** Another `network_flow_cost` constraint governs `total_flow` and `communication_cost`.
4. **Shared link capacity.** `comm_full` equals summed per-stream traffic on each interprocessor link and is bounded by `link_bandwidth`.
5. **Processor workload.** `bin_packing_load` assigns the supplied endpoint weights to the processors selected by `flow_processor`.
6. **Placement consistency.** Endpoints with equal source/destination actor identifiers must select the same processor.
7. **Cost attribution and outgoing traffic.** Additional equations calculate `cc` and `flow_from_processor`.

An important distinction is that the aggregate network is **not explicitly linked to the per-stream routing variables**. Likewise, the declared actor placements and several auxiliary flow arrays are not connected to the main placement/routing formulation. The reformulation preserves these relationships exactly rather than adding intended-but-absent constraints.

### Objective

The model minimizes
\[
\max_{p=1,\ldots,k}\left(\texttt{cpu\_loads}[p]+\texttt{cc}[p]\right).
\]

The original attribution rule is retained literally: stream \(f\)'s cost is assigned using `flow_processor[source_destination_actor[f,1]]`. This is not replaced by an inferred actor-placement interpretation.

## Reformulation and Its Justification

### Shared binary placement indicators

The reformulation introduces a binary indicator \(x_{e,p}\) for endpoint \(e\) being placed on processor \(p\), with exactly one selected processor per endpoint. Each indicator is channeled to the original `flow_processor` variable.

For an endpoint arc with flow \(q_{e,p}\), the original zero-count and nonzero-equivalence constraints are replaced by
\[
x_{e,p}\le q_{e,p}\le Ux_{e,p},
\]
where \(U\) is the original flow-domain upper bound.

**Validity:** Original flows are nonnegative integers. These inequalities force an unselected arc to zero and a selected arc to at least one. Together with exactly one selected processor, they enforce precisely the original requirement of one nonzero endpoint arc. Conversely, every original feasible endpoint assignment satisfies these bounds.

This exposes linear activation constraints suitable for HiGHS and shares placement indicators across other parts of the formulation.

### Preprocessing equal-actor endpoint groups

Using the supplied actor identifiers, each endpoint is assigned the smallest-index endpoint having the same identifier as its representative. Indicator equalities connect every other endpoint in the group to that representative.

**Validity:** The original source–source, source–destination, and destination–destination equalities require every endpoint with the same actor identifier to share its placement. Representative equalities enforce exactly this equivalence relation; endpoints with different identifiers are not merged.

This replaces quadratic pairwise consistency constraints with representative-based constraints. The resulting number of indicator equalities also depends on the number of processors, so a smaller total constraint count is not guaranteed for every instance.

### Exact linear allocation of routing costs

The original cost-attribution expression multiplies a placement condition by a variable routing cost. The reformulation introduces nonnegative allocations \(a_{f,p}\) satisfying
\[
\sum_p a_{f,p}=\texttt{cost}[f],
\qquad
a_{f,p}\le 10000\,x_{s(f),p},
\]
where \(s(f)=\texttt{source\_destination\_actor}[f,1]\), preserving the original indexing rule. Processor cost is then \(\texttt{cc}[p]=\sum_f a_{f,p}\).

**Validity:** Each endpoint selects exactly one processor, and the original stream cost lies between zero and 10,000. Every unselected allocation must therefore be zero, while the selected allocation must equal the entire stream cost. This is an exact linear reformulation of the original products.

### Valid objective inequalities

Two redundant bounds strengthen the formulation:
\[
\texttt{cost}[f]\le\texttt{objective}
\quad\text{for every stream }f,
\]
and
\[
\sum_p\texttt{cpu\_loads}[p]+\sum_f\texttt{cost}[f]
\le k\,\texttt{objective}.
\]

**Validity:** Each nonnegative stream cost is attributed entirely to one processor. That processor’s combined cost is at least the stream cost and cannot exceed the exact maximum objective. Also, each processor’s combined cost is at most the objective; summing these inequalities gives the second bound because every stream cost is attributed exactly once.

The original exact `maximum` constraint remains in place.

## Preservation and Solution Mapping

All original decision variables, domains, external parameters, network constraints, and optimization direction are retained. The CP-oriented search annotations are removed because the reformulation targets HiGHS; this does not change feasibility or objective values.

The accompanying Python script performs an identity mapping of the original decision variables, excludes reformulation auxiliaries, and reports missing solution fields rather than inventing values. The changes aim to improve the mixed-integer formulation, but no measured runtime improvement is established here.

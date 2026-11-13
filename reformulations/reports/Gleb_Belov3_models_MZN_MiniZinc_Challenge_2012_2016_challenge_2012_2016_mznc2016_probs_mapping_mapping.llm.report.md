# Network-on-Chip Application Mapping

## Background and interpretation

The model describes mapping a streaming application, identified in the source as an H.263 encoder, onto processors connected by a mesh network-on-chip. Application communication streams must be assigned sending and receiving processors and routed through the network, subject to processor-load and communication-capacity restrictions.

The source cites the application model of Mirza, Gruian, and Kuchcinski, “Mapping streaming applications on multiprocessors with time-division-multiplexed network-on-chip,” *Computers & Electrical Engineering* 40(8), 2014.

The mathematical formulation is preserved as written, including relationships that differ from what the application description might suggest. In particular, the declared actor-placement array is not connected to endpoint assignments, and the aggregate network-flow variables are not explicitly linked to the individual stream-routing variables.

## Original mathematical structure

Let \(K=\texttt{row}\times\texttt{col}\), \(F=\texttt{no\_flows}\), and \(L=\texttt{no\_links}\). Each individual stream uses a network with \(K+2\) nodes and \(L+2K\) arcs. All original decision variables are bounded integers.

### Variables

The main variable groups are:

- **Endpoint placement:** `flow_processor` contains \(2F\) processor assignments, one source and one destination assignment per stream.
- **Individual routing:** `flows` contains \(F(L+2K)\) nonnegative arc-flow variables. Each stream also has a bounded routing cost, `cost`.
- **Processor accounting:** `cpu_loads`, `cc`, and `flow_from_processor` each contain \(K\) variables for processor workload, allocated communication cost, and outgoing communication volume.
- **Shared link usage:** `comm_full` contains \(L\) variables bounded by link bandwidth.
- **Aggregate network:** `total_flow` contains \(2KF+L\) arc-flow variables, with its own flow balances and scalar `communication_cost`.
- **Other retained variables:** `inFlow`, `outFlow`, `commFlow`, and `actor_processor`. The first two have discrete allowed values but are not connected to `flows`; the latter two have only their declared domain restrictions.
- **Objective:** the bounded scalar `objective`.

No numerical instance sizes were supplied, so only symbolic dimensions can be reported.

### Constraints and objective

For each stream, a network-flow constraint enforces conservation and defines routing cost. Exactly one of the first \(K\) arcs and exactly one of the last \(K\) arcs must carry positive flow. Equivalences connect those active arcs to the corresponding endpoint assignments.

A bin-packing constraint computes processor workloads from assigned endpoints and their supplied loads. Additional equalities force endpoints with the same actor identifier to use the same processor.

Shared link usage equals the sum of individual stream flows on each internal link. Its domain enforces bandwidth capacity. Outgoing traffic is also summed by processor and bounded through `flow_from_processor`.

A separate network-flow constraint governs `total_flow` and `communication_cost`. Despite the application-level interpretation, the source does not equate `total_flow` with the individual routing flows.

The objective minimizes
\[
\max_{p=1,\ldots,K}\bigl(\texttt{cpu\_loads}[p]+\texttt{cc}[p]\bigr).
\]
The allocation defining `cc` uses the original expression
`flow_processor[source_destination_actor[f,1]]`. This indexing is retained exactly; it is not replaced by an inferred actor-placement relationship. The separate scalar `communication_cost` is constrained but is not directly minimized.

## Reformulation and justification

### Shared binary endpoint assignments

The reformulation introduces binary indicators \(x_{s,p}\) for endpoint \(s\) being assigned to processor \(p\), with
\[
\sum_p x_{s,p}=1,
\qquad
\texttt{flow\_processor}[s]=\sum_p p\,x_{s,p}.
\]

For each endpoint arc, its flow \(q\) is constrained by
\[
x_{s,p}\le q\le Ux_{s,p},
\]
where \(U\) is the original upper bound on `flows`.

These inequalities are equivalent to the original nonzero-flow equivalence: an unselected arc has zero flow, while a selected arc has positive integer flow. Since exactly one processor is selected, exactly one endpoint arc is nonzero. The original zero-count constraints therefore become redundant and are removed.

The same indicators compute processor loads by weighted sums. This preserves the bin-packing load equation while sharing the assignment representation with the routing constraints.

### Actor-identifier preprocessing

Endpoint actor identifiers are derived from `source_destination_actor`. For each identifier, the first matching endpoint is selected as a representative, and all other matching endpoints receive the same assignment indicators.

This replaces the original pairwise consistency constraints. Those constraints equate every source–source, source–destination, and destination–destination pair with matching identifiers. Consequently, they already require a common processor within each identifier group. Equating every member to one representative imposes exactly the same requirement, without constructing every pairwise equality.

No relationship is added to `actor_processor`, which remains independent as in the source.

### Linear communication-cost allocation

The original `cc` equations multiply a placement condition by a variable stream cost. The reformulation introduces nonnegative allocations \(z_{f,p}\), satisfying
\[
\sum_p z_{f,p}=\texttt{cost}[f],
\qquad
z_{f,p}\le 10000\,x_{a_f,p},
\]
where \(a_f=\texttt{source\_destination\_actor}[f,1]\), preserving the original assignment lookup.

Exactly one indicator in this row is one. All other allocations must therefore be zero, and the remaining allocation must equal the stream cost. The upper bound is valid because the original cost domain is \(0\ldots10000\). Summing these allocations by processor reproduces `cc` exactly.

This is a disaggregated linear formulation of the assignment-dependent cost products, suited to HiGHS.

### Valid objective inequalities

The exact maximum constraint is retained. Additional inequalities expose consequences of the model:

- Every processor’s combined load is at most `objective`.
- Every stream cost is at most `objective`, because it is allocated entirely to one processor and all other contributions to that processor’s combined load are nonnegative.
- Summing processor inequalities gives
  \[
  \sum_{r,f}\texttt{load}[r,f]+\sum_f\texttt{cost}[f]
  \le K\,\texttt{objective}.
  \]
  This follows because each endpoint load and each stream cost is assigned exactly once.

These inequalities exclude no original feasible solutions and may strengthen propagation or the linear relaxation.

## Interface and solution preservation

All original parameters, decision variables, domains, and external-data bindings are retained. No inferred links are added between otherwise independent arrays. CP-specific search annotations are removed in favor of the MIP backend’s search strategy.

The accompanying mapping script copies only original decision variables, preserving their encoded array indices and values. It reports missing values rather than inventing replacements. The changes aim to reduce redundant constraints and provide a more direct linear formulation; no runtime improvement was measured in this exchange.

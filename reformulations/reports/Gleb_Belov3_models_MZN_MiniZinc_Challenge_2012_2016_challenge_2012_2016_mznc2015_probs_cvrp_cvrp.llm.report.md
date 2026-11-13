# Capacitated Vehicle Routing: Model and Reformulation

## Background and interpretation

The model represents a capacitated vehicle-routing problem: vehicles leave a depot, visit customers, and return to the depot while respecting a load limit. The input supplies \(N\) customers, customer demands, a distance matrix, and a common vehicle capacity. Up to \(N\) vehicles are represented.

Rather than modeling each route separately, the formulation uses a **giant tour** containing:
- \(N\) customer nodes;
- \(N\) vehicle-start depot copies;
- \(N\) vehicle-end depot copies.

Each end-depot copy connects to the next start-depot copy, with the last connecting to the first. These artificial connections assemble the vehicle routes into one circuit.

The exact mathematical semantics require care. The input declarations do not require nonnegative distances or demands, and the depot-distance conversion is retained exactly as written. Load is accumulated after visiting a customer: the successor’s load equals the customer’s arrival load plus that customer’s demand. Start-depot loads are zero. Timing constraints permit waiting, so arrival times need not equal accumulated travel times.

## Original formulation

### Variables

There are **\(15N+1\) integer decision variables**:
- `successor` and `predecessor`: the outgoing and incoming neighbor of each of the \(3N\) nodes;
- `vehicle`: a vehicle label for each node;
- `load`: each node’s arrival load, bounded by zero and `Capacity`;
- `arrivalTime`: each node’s arrival time, bounded by zero and `timeBudget`;
- `objective`: an integer bounded by zero and `timeBudget`.

The time budget is computed from the supplied distance matrix using the original row-maximum expression.

### Constraints

The original constraints:
1. Fix the artificial end-to-start depot connections and the depot vehicle labels.
2. Set start-depot arrival times and loads to zero.
3. Enforce a single circuit through all nodes, together with redundant inverse and predecessor-circuit constraints.
4. Require matching vehicle labels across arcs incident to customers.
5. Propagate time along arcs leaving customers and start depots.
6. Propagate load by adding customer demand, or preserving zero load when leaving a start depot.

Time and load do not propagate across the artificial connections leaving end depots.

### Objective

The model minimizes
\[
\sum_{e\in\text{END\_DEPOT\_NODES}}\operatorname{arrivalTime}_e.
\]

This is the sum of route completion times, not an explicit sum of arc distances. The reformulation preserves that distinction, including waiting and the original objective bound.

## Reformulation and its justification

### Sparse binary-arc formulation

A binary variable is introduced for each retained candidate arc. Each node must have exactly one selected outgoing arc and one selected incoming arc.

The original successor and predecessor variables remain explicit and are linked to the selected arc endpoints by weighted sums. Because the corresponding arc sum is exactly one, these equalities identify the unique successor and predecessor and make them inverses. This replaces variable-index inverse constraints with linear equations suitable for HiGHS.

All original decision variables and external parameter declarations are retained.

### Valid arc preprocessing

Candidate arcs are removed only when the original constraints already exclude them:

- **Incorrect arcs leaving end depots:** each end depot has a fixed successor in the original model.
- **Other arcs entering start depots:** the fixed end-to-start connections already provide every start depot’s incoming arc. The circuit’s one-predecessor property excludes another incoming arc.
- **Self-loops:** a single circuit through all \(3N\) nodes cannot contain a self-loop for a valid nonempty instance.
- **Time-infeasible arcs:** for an arc subject to time propagation, both endpoint times lie in \([0,T]\), where \(T=\texttt{timeBudget}\). Thus
  \[
  t_i+d_{ij}\le t_j
  \]
  cannot hold when \(d_{ij}>T\).
- **Load-infeasible customer departures:** the equation
  \[
  \ell_j-\ell_i=\operatorname{demand}_i
  \]
  and bounds \(0\le\ell_i,\ell_j\le C\) require demand to lie in \([-C,C]\).

These tests do not assume nonnegative data. Direct start-to-end depot arcs remain available where allowed by the original constraints; no additional vehicle-label restriction is imposed on such arcs.

### Ordering-based connectivity

One auxiliary order variable is introduced per node. Node 1 is anchored at order zero, and selected arcs not entering node 1 must strictly increase the order.

The degree equations alone would allow several disjoint cycles. Any cycle not containing node 1 is impossible under strict order increases: summing its inequalities yields a contradiction. Therefore, all nodes belong to one cycle.

Conversely, any original circuit can be assigned successive positions starting from node 1. The ordering constraints consequently preserve every original circuit while replacing the global circuit constraints with a standard mixed-integer ordering formulation.

### Bound-derived linear propagation

Vehicle-label equalities, time inequalities, and load equations are imposed conditionally on selected arcs using linear big-M constraints.

The constants are derived from the original variable domains:
- vehicle-label differences are at most \(N-1\);
- arrival-time differences are bounded by `timeBudget`;
- load differences are bounded by `Capacity`.

The load constants also account for the signed customer demand, and timing constants account for the signed arc distance and the fixed zero start time. Thus unselected arcs impose no unintended restriction, while selected arcs enforce the original relations exactly.

### Aggregate strengthening constraints

Two valid aggregate inequalities/equalities are added:

- **Load conservation**
  \[
  \sum_{e\in\text{END\_DEPOT\_NODES}}\ell_e
  =
  \sum_{i\in\text{CUSTOMER}}\operatorname{demand}_i.
  \]
  Summing load propagation over selected arcs leaving customers and starts cancels customer loads. Start loads are zero, leaving only end loads and total demand.

- **Travel-time lower bound**
  \[
  \texttt{objective}
  \ge
  \sum_{\substack{(i,j)\text{ selected}\\i\text{ not an end depot}}}d_{ij}.
  \]
  Summing the corresponding timing inequalities cancels customer arrival times. Start times are zero, and the remaining end times equal the objective.

Both results hold even with signed demands or distances. They expose implications of the original constraints directly to the MIP relaxation.

## Interface and expected benefit

The final mapping script copies the six original variable fields unchanged, preserving their array indices and excluding auxiliary variables. It reports missing fields rather than inventing values.

The reformulation targets HiGHS by replacing global and variable-index constraints with sparse linear arc constraints, explicit connectivity, and bound-derived propagation. Preprocessing reduces candidate arcs, while the aggregate constraints can strengthen the relaxation. These are structural improvements intended to reduce solving time; no runtime improvement has been measured on supplied instance data.

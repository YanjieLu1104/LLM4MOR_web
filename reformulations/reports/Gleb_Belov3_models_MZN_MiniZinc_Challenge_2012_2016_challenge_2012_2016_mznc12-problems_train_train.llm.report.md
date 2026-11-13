# Train Rescheduling After a Disruption

## Background

The model reschedules \(n\) trains travelling along a single track through \(m\) stations after one train experiences a known delay. Passenger arrivals at each station are represented by a constant flow over time. Trains collect passengers and carry them to the final station, subject to capacity and boarding-time limits.

The schedule must respect departures already made, the disruption, minimum travel times, and station-separation requirements. Subsequent departures cannot occur earlier than originally scheduled. A train can collect no passengers at a station or dwell longer to board passengers.

Although the motivating description concerns passengers boarding at intermediate stations, the formulation declares passenger flows at every station. The reformulation preserves this interface rather than assuming zero endpoint flows or positive flow values.

## Original Model

### Variables

The model declares seven independent integer arrays, each indexed by train and station, giving \(7nm\) independent integer variables:

- **`arrival` and `departure`:** train arrival and departure times.
- **`sigmaLower` and `sigmaUpper`:** endpoints of passenger-arrival intervals assigned to each train.
- **`collect`:** passengers collected at a station.
- **`load`:** cumulative passengers aboard after that station.
- **`dwell`:** departure time minus arrival time.

Times and interval endpoints lie between zero and `maxTime`; collection and load variables lie between zero and `capacity`. `finalArrival` is a view of terminal arrival times, and `cost` is a defined objective variable.

### Constraints

The constraints fall into four main groups:

1. **Schedule and disruption constraints.** Trains arrive at the first station at time zero and depart the final station immediately upon arrival. Departures scheduled at or before the disruption time are fixed. The affected train receives additional delay constraints.

2. **Movement and separation constraints.** Departures follow arrivals, travel between consecutive stations takes at least the specified duration, and nonterminal departures cannot precede the original schedule. Trains depart the first station in strict order; at intermediate stations, a train must depart at least two time units before the next train arrives.

3. **Passenger allocation and capacity constraints.** Passenger intervals have nonnegative length and join between successive trains. At intermediate stations, their overall endpoints are fixed by passenger start times and the last scheduled departure. Collection equals interval length times passenger flow, while loads accumulate along the route. A train assigning itself a nonempty interval must collect up to its departure, the passenger cutoff, or a capacity-related stopping condition.

4. **Boarding constraints.** Collection is bounded by dwell time. The boarding rate is at most 50 passengers per time unit, reduced to 20 when fewer than 100 spaces remain before boarding.

### Objective

The model minimizes
\[
\sum_{i=1}^{n}\operatorname{load}_{i,m}\operatorname{arrival}_{i,m}.
\]

This is a passenger-weighted sum of terminal arrival times. The original expression contains \(n\) products of integer decision variables; the remaining constraints are linear or logical combinations of linear conditions. The expression should not be interpreted as an explicitly normalized average travel time.

## Reformulation and Its Justification

### Exact MILP representation of the objective

To suit HiGHS, each terminal load–arrival product is replaced by an exact binary-expansion formulation. The factor with the smaller declared upper bound—`capacity` or `maxTime`—is expanded:
\[
x_i=\sum_k 2^k b_{ik},\qquad b_{ik}\in\{0,1\}.
\]

For the other factor \(y_i\), bounded by \(0\le y_i\le U\), an auxiliary variable \(z_{ik}\) satisfies
\[
0\le z_{ik}\le Ub_{ik},\qquad
z_{ik}\le y_i,\qquad
z_{ik}\ge y_i-U(1-b_{ik}).
\]
These constraints force \(z_{ik}=0\) when the bit is zero and \(z_{ik}=y_i\) when it is one. Consequently,
\[
x_i y_i=\sum_k2^kz_{ik}
\]
holds exactly, without approximation or a change of objective value. Choosing the smaller factor reduces the number of binary digits required.

### Schedule-derived time bounds

The reformulation computes remaining minimum travel distance from each station and adds two families of valid bounds:

- An arrival at station \(j\) cannot precede a scheduled departure from any earlier station plus the intervening minimum travel time. This follows by chaining the original scheduled-departure lower bounds, travel-time inequalities, and departure-after-arrival constraints.
- A departure from station \(j\) cannot exceed `maxTime` minus the remaining minimum travel time. Otherwise, the terminal arrival would exceed its original upper bound.

These bounds expose consequences of the original timing constraints directly to the solver. Terminal-arrival lower bounds also strengthen the binary-product formulation.

### Simplified pickup logic

The original capacity-related pickup condition is
\[
\operatorname{load}
+\mathbf{1}_{\sigmaUpper<\text{cutoff}}\operatorname{passengerFlow}
>\operatorname{capacity}.
\]

Because load is already bounded above by capacity, this condition can hold only if the indicator is one and passenger flow is positive. For positive integer flow, it is equivalent to
\[
\sigmaUpper<\text{cutoff},
\qquad
\operatorname{load}\ge
\operatorname{capacity}-\operatorname{passengerFlow}+1.
\]

The reformulation uses this equivalent condition explicitly. For nonpositive flow, that branch is false. Thus, the simplification does not rely on an unstated positivity assumption.

### Simplified boarding logic

The original model already imposes the 50-passenger boarding bound everywhere. Therefore, its additional implication imposing that same bound when at least 100 spaces remain is redundant.

Only the implication imposing the 20-passenger rate when fewer than 100 spaces remain is retained. If capacity itself is below 100, nonnegative incoming load makes that condition unconditional. Otherwise, it is expressed as an equivalent disjunction.

### Passenger-conservation equations

At an intermediate station, adjacent passenger intervals share endpoints. Summing collection over trains therefore telescopes to
\[
\sum_i\operatorname{collect}_{i,j}
=
\bigl(\operatorname{scheduledDeparture}_{n,j}
-\operatorname{passengerStart}_j\bigr)
\operatorname{passengerFlow}_j.
\]

These redundant conservation equations are added explicitly. A corresponding total terminal-load equation is also added: load accumulates collections, while terminal collection is zero because terminal departure equals arrival and collection is bounded by 50 times dwell. These equations strengthen the linear formulation without changing the feasible set.

## Interface and Solution Preservation

All original independent variable arrays and external data declarations are retained. The mapping script copies the seven original arrays, including their index encodings, and excludes reformulation auxiliaries and originally defined aliases.

The original CP-oriented search annotation is removed so that HiGHS can use its MILP search machinery. Minimization direction, objective values, and necessary constraints are preserved. The changes are intended to improve linear relaxation strength and avoid generic nonlinear-product handling; no runtime improvement is claimed without instance-level benchmarking.

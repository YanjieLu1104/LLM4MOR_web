## Background and purpose

The model reschedules trains after a known delay on a single track with multiple stations. Trains can wait at stations or skip passenger collection, subject to departure schedules, travel times, station separation, and passenger capacity.

Passenger arrivals are represented by station-specific time intervals and constant flow rates. Each train collects passengers associated with its assigned interval at each station. The model decides both the revised timetable and the allocation of these intervals to trains.

Its objective is to minimize the sum of each train’s final arrival time multiplied by its final passenger load. This is a passenger-weighted destination-arrival measure. When total demand and passenger arrival times are fixed, minimizing it also minimizes aggregate passenger journey time up to a constant. The formulation preserves the actual objective without assuming that endpoint passenger flows are zero.

## Original model structure

### Variables

For \(n\) trains and \(m\) stations, the model declares seven independent integer arrays, totaling \(7nm\) scalar variables:

- **`arrival` and `departure`:** revised station arrival and departure times.
- **`sigmaLower` and `sigmaUpper`:** endpoints of each train’s passenger-arrival interval.
- **`collect`:** passengers collected at a station.
- **`load`:** cumulative onboard passengers.
- **`dwell`:** departure time minus arrival time.

Time and interval variables lie in \(0,\ldots,\texttt{maxTime}\); collection and load variables lie in \(0,\ldots,\texttt{capacity}\). The `finalArrival` array aliases destination arrival times, and `objective` is defined from loads and arrival times.

### Constraints

The constraints fall into four groups:

1. **Timetable and disruption constraints**
   - Every train arrives at the first station at time zero.
   - Departure from the final station equals arrival there.
   - Departures scheduled before the disruption remain fixed.
   - The delayed train satisfies additional arrival or departure lower bounds.
   - Trains cannot depart before arrival or before their scheduled departure at nonterminal stations.
   - Consecutive stations require minimum travel time.

2. **Train separation**
   - First-station departures are strictly ordered.
   - At intermediate stations, one train must depart at least two time units before the following train arrives.

3. **Passenger allocation and capacity**
   - Passenger intervals are nonnegative in length and join consecutively between trains.
   - At intermediate stations, the first and last interval endpoints are fixed to the passenger-start time and final scheduled departure.
   - Collection equals interval length multiplied by passenger flow.
   - Loads accumulate collection and cannot exceed capacity.
   - A positive-length collection interval must end at departure, at the demand cutoff, or because insufficient capacity remains for another unit of passenger flow.

4. **Boarding**
   - Collection is bounded by 50 passengers per unit of dwell time.
   - When fewer than 100 spaces remain before boarding, the tighter rate is 20 passengers per unit of dwell time.

Most expressions are linear. The pickup and boarding rules contain logical conditions, while the objective contains products of integer variables:

\[
\min \sum_{i=1}^{n} load_{i,m}\,arrival_{i,m}.
\]

These products are the main obstacle to a direct mixed-integer linear formulation for HiGHS.

## Reformulation and justification

### 1. Exact binary linearization of the objective

For each train, the reformulation expands whichever objective factor has the smaller declared upper bound—load or final arrival—into binary digits:

\[
x_i=\sum_k 2^k b_{ik}.
\]

For the other factor \(y_i\), bounded by \(0\le y_i\le U\), it introduces \(z_{ik}=b_{ik}y_i\) through

\[
0\le z_{ik},\qquad
z_{ik}\le Ub_{ik},\qquad
z_{ik}\le y_i,\qquad
z_{ik}\ge y_i-U(1-b_{ik}).
\]

If the binary digit is zero, these constraints force \(z_{ik}=0\); if it is one, they force \(z_{ik}=y_i\). Consequently,

\[
x_i y_i=\sum_k 2^k z_{ik}
\]

holds exactly. This is an exact reformulation, not an approximation. It requires logarithmically many binary digits in the smaller factor’s upper bound and preserves the objective value and minimization direction.

### 2. Timetable-derived lower bounds and product cuts

For any nonterminal station \(j\), the original constraints imply

\[
arrival_{i,m}\ge
scheduledDeparture_{i,j}
+\sum_{s=j}^{m-1}distance_s.
\]

This follows by chaining the minimum travel-time constraints and the rule that departure cannot precede arrival, starting from the scheduled-departure lower bound. Taking the maximum over these bounds and zero gives a valid train-specific lower bound \(L_i\).

The reformulation adds this bound explicitly and strengthens each linearized product \(P_i=load_{i,m}arrival_{i,m}\) with the four McCormick inequalities for

\[
0\le load_{i,m}\le C,\qquad L_i\le arrival_{i,m}\le T,
\]

where \(C=\texttt{capacity}\) and \(T=\texttt{maxTime}\):

\[
\begin{aligned}
P_i&\ge L_i\,load_{i,m},\\
P_i&\le T\,load_{i,m},\\
P_i&\ge C\,arrival_{i,m}+T\,load_{i,m}-CT,\\
P_i&\le C\,arrival_{i,m}+L_i\,load_{i,m}-CL_i.
\end{aligned}
\]

These inequalities are valid for every original product value and can tighten the mixed-integer model’s continuous relaxation.

### 3. Passenger-interval and conservation cuts

At each intermediate station, interval ordering and the joining equalities form a nondecreasing chain from `passengerStart` to the final scheduled departure. Therefore every interval satisfies

\[
sigmaLower_{i,j}\ge passengerStart_j,\qquad
sigmaUpper_{i,j}\le scheduledDeparture_{n,j}.
\]

Summing the original collection equations over trains makes the joined interval endpoints telescope:

\[
\sum_i collect_{i,j}
=
\bigl(scheduledDeparture_{n,j}-passengerStart_j\bigr)
passengerFlow_j.
\]

The reformulation adds these implied bounds and conservation equations explicitly. They expose aggregate demand information without changing feasible solutions. They are applied only at intermediate stations, where the original model fixes both extreme endpoints.

### 4. Implied zero-collection constraints

Two deductions are added explicitly:

- **Final station:** arrival equals departure, so dwell is zero. The universal boarding bound and nonnegative collection therefore force `collect[i,m] = 0`.
- **Nonpositive passenger flow:** interval length is nonnegative. Multiplying it by a nonpositive flow gives nonpositive collection, while the collection domain requires nonnegativity. Thus collection must be zero.

The original collection equations remain in place, preserving any further implications for interval lengths when flow is negative.

### 5. Simplification of logical constraints

The original capacity-based pickup alternative is

\[
load+\mathbf{1}_{\{sigmaUpper<cutoff\}}\,flow>capacity.
\]

Because the load domain already imposes `load <= capacity`, this alternative is impossible when the indicator is zero. It is therefore equivalent to

\[
sigmaUpper<cutoff
\quad\land\quad
load+flow>capacity.
\]

This removes the indicator arithmetic without assuming positive flow.

The conditional 50-passenger boarding rule is also removed because the original universal boarding bound already enforces the same inequality at every station. The conditional 20-passenger rule is retained.

### 6. Search and solution interface

The CP-style search annotation is replaced by a plain minimization solve item, leaving search decisions to HiGHS.

All original independent variable arrays and external data declarations are retained. The mapping script copies exactly those seven arrays, preserving their encoded index sets, and excludes reformulation auxiliaries and defined aliases. Missing required arrays produce an explicit error rather than fabricated values.

These changes target a stronger, explicitly linear mixed-integer formulation. No instance data or timing results were supplied, so the expected computational benefits have not been established empirically.

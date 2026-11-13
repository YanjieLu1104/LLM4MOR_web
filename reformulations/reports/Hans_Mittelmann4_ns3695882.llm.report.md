# Reformulation Report: Capacitated Vehicle Routing with Time Windows

## 1. Problem background

The model represents a fleet-routing and service-scheduling problem. Five vehicles leave a common entrance node, serve 34 customers, and finish at a common exit node. Each customer has a demand, a service duration, and an allowable service window. Each vehicle has capacity 25.

This interpretation follows from the network-flow constraints, customer demands, vehicle capacities, and arrival-time restrictions. The source does not identify a particular application; deliveries or on-site service visits are plausible examples.

The objective minimizes **total elapsed route time**, not simply total driving time. It sums each vehicle’s exit time minus its entrance time, thereby accounting for travel, service, and any waiting between departure and completion. Departure times are decision variables.

## 2. Original formulation

### Variables and data

The instance contains 36 nodes: 34 customers, one entrance, and one exit. Its road set contains all 1,225 permitted origin–destination pairs, including customer self-arcs.

The original model declares:

- **6,125 binary variables** `Use[a,i,j]`, indicating whether vehicle \(a\) uses arc \((i,j)\).
- **180 nonnegative continuous variables** `Y[a,i]`, representing vehicle-specific arrival times.

### Constraints

The formulation includes:

- **Departure:** Each vehicle selects exactly one arc leaving the entrance.
- **Customer assignment:** Exactly one selected incoming arc reaches each customer across the fleet.
- **Flow conservation:** For each vehicle and customer, selected incoming and outgoing arc counts agree.
- **Capacity:** Each vehicle’s served demand cannot exceed 25.
- **Timing:** Selected arcs require sufficient time for service at the origin and travel to the destination. Unselected arcs use a big-M constant of 30,000.
- **Time windows:** A visited customer’s arrival must be at least its opening time, and service must finish by its closing time. An unvisited customer’s vehicle-specific arrival time is forced to zero.
- **Short-cycle restrictions:** Separate families prohibit self-arcs, two-customer cycles, and three-customer cycles.

Before presolve, the original model generates **214,759 constraint rows**. This includes 196,520 three-cycle rows and substantial duplication in the self-arc and two-cycle families.

## 3. Reformulation and justification

### Self-arc fixing

Customer self-arcs are fixed to zero through bounds on the existing binary variables.

This directly replaces `N01`, which requires every customer self-arc to be zero. Its additional customer index merely repeats the same restriction. No original variable is removed, so solution correspondence remains unchanged.

### Removal of redundant short-cycle constraints

The two- and three-cycle families are removed using **positive-duration cycle elimination implied by the timing constraints**.

Every customer in this instance has strictly positive service time, and all travel times are nonnegative. If a vehicle selected a directed customer cycle, summing its selected-arc timing inequalities would give

\[
0 \geq \sum_{\text{cycle arcs }(i,j)} \bigl(S[i]+T[i,j]\bigr)>0,
\]

a contradiction. Thus, the original timing constraints already prohibit customer cycles of every length. Repeated-node cases in the short-cycle families are also covered by self-arc fixing and the absence of directed cycles.

The reformulation explicitly checks the positive-service-time condition used in this instance-specific reduction.

### Bound-based big-M tightening

For each customer \(i\), the assignment and flow constraints imply that each vehicle’s selected outgoing arc count is either zero or one. Together with the closing-window constraint, this gives the valid upper bound

\[
Y[a,i]\leq U_i=\max\{0,L[i]-S[i]\}.
\]

Since every destination arrival time is nonnegative, an unselected customer-origin arc needs no more than \(U_i+S[i]+T[i,j]\) as its deactivation constant. The reformulation therefore uses

\[
M_{ij}=\min\{30000,\ U_i+S[i]+T[i,j]\}.
\]

Selected-arc timing requirements remain identical. For unselected arcs, the smaller constant follows from existing bounds; whenever 30,000 is smaller, the original restriction is retained. Entrance-origin constants remain unchanged.

This is **bound-based big-M strengthening**, intended to improve the linear relaxation and numerical scaling.

### Route-duration valid inequalities

For each vehicle, the reformulation adds

\[
Y[a,\mathrm{exit}]-Y[a,\mathrm{entr}]
\geq
\sum_{(i,j)\in ROADS}(S[i]+T[i,j])\,Use[a,i,j].
\]

Customer assignment and vehicle flow balance prevent branching. Together with one departure and the exclusion of customer cycles, they imply that each vehicle’s selected arcs form one entrance-to-exit path. Summing the timing inequalities along that path proves the added inequality.

These **route-duration cuts** make an integer-feasibility implication explicit in the linear relaxation.

## 4. Result

The reformulated model retains all original variables, instance data, and the minimization objective, with an identity solution mapping. It has **6,684 constraint rows**, excluding check statements and variable bounds. The changes target model-generation overhead and relaxation strength; no measured runtime improvement was established in the conversation.

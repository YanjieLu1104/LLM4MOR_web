# Cargo Stockpile Scheduling: Model and Reformulation

## Real-world interpretation

The model appears to describe operations at a bulk-cargo export terminal. Cargo is assembled into stockpiles on a storage pad, then reclaimed for loading onto vessels. Each stockpile belongs to a vessel and occupies both pad space and a time interval.

The terminal must coordinate three limited resources:

- **Storage-pad space**, represented by each pile’s position and length.
- **Stacking capacity**, consumed while cargo is assembled.
- **Reclaiming equipment**, limiting simultaneous reclaim operations.

Vessel arrival times restrict reclaiming and how early stacking may begin. Time and pad position are discretized, with potentially different resolutions. The input determines stacking durations, reclaiming durations, pile lengths, and stacking resource demands.

## Original formulation

### Variables

For \(nS\) stockpiles, the model declares four independent integer variables per pile:

| Variable | Meaning |
|---|---|
| `tS__` | Stacking start in coarse time units |
| `h__` | Position on the discretized storage pad |
| `tR` | Reclaim start in the base time units |
| `dT__` | Pad-occupancy duration in coarse time units |

Two additional independent integer variables, `sum_delay` and `objective`, are constrained to equal delay expressions. Thus, the source contains **\(4nS+2\) independent integer decision variables**, before any external bindings or solver preprocessing.

Derived variables express stacking starts and occupancy durations in base time units, and vessel completion times. A vessel’s completion time is defined using its highest-indexed pile. The original `comb` array is a search view, not a set of additional independent decisions.

### Constraints

The model enforces:

- **Occupancy coverage:** each pile remains on the pad at least until reclaiming finishes.
- **Arrival restrictions:** reclaiming cannot start before the associated vessel’s arrival; stacking cannot start earlier than a specified allowance before arrival.
- **Stacking completion:** stacking must finish before reclaiming begins.
- **Pad containment:** each pile’s position plus its length must fit within the pad.
- **Reclaim sequencing:** consecutive pile indices belonging to the same vessel must be reclaimed in order, with a bounded gap.
- **Vessel completion and delay limits:** completion times lie within the declared horizon, individual vessel delays are bounded, and total delay is bounded.
- **Space–time non-overlap:** `diffn` prevents pile occupancy rectangles from overlapping.
- **Three cumulative resource limits:** pad occupancy, stacking demand, and simultaneous reclaiming.

Importantly, reclaim sequencing applies only to **adjacent indices with the same vessel identifier**. The source does not impose a single continuous reclaim chain across all piles belonging to a vessel if their indices are interrupted by other vessels.

### Objective

The model minimizes

\[
\sum_{v\in 5..nV-5}
\left(tReady_v-\eta_v-dRtotal_v\right).
\]

This measures vessel completion time beyond arrival plus total reclaiming duration, but only for the indexed vessel subset `5..nV-5`. All vessels still participate in the total-delay constraint. The reformulation preserves both this subset and the minimization direction.

## Reformulation and validity

The reformulation retains the original data interface, independent variables, global constraints, and objective. Its principal changes strengthen bounds and expose useful linear or disjunctive implications to the HiGHS backend.

### 1. Linearizing the stacking-completion restriction

Let \(q=\texttt{discrStackStart}\). For \(q>0\), the original constraint

\[
tS_i^{c}+dS_i^{c}\le tR_i\operatorname{div}q
\]

is equivalent to

\[
q\,tS_i^{c}+q\,dS_i^{c}\le tR_i.
\]

This follows because the left-hand side of the first inequality is integral and `tR` is nonnegative. The latter expression is exactly `tS[i] + dS[i] <= tR[i]` under the original definitions.

The replacement removes variable integer division from this constraint. It is conditional on a positive divisor; otherwise, the original expression is retained.

### 2. Static reclaim-time bounds

The reformulation computes an earliest reclaim bound for each pile from:

- The nonnegative reclaim-time domain.
- The vessel-arrival restriction.
- The earliest permitted stacking start, rounded upward to the stacking grid.
- The requirement that stacking finish before reclaiming.

It also computes a latest reclaim bound. Every pile inherits the original horizon bound. A vessel’s highest-indexed pile additionally inherits bounds from its completion-time domain and individual delay limit.

These bounds are propagated along the original adjacent same-vessel chains. For any such chain from pile \(a\) to pile \(b\), summing the original precedence inequalities gives

\[
tR_b\ge tR_a+\sum_{j=a}^{b-1}dR_j.
\]

Consequently, a lower bound at \(a\) yields a lower bound at \(b\), and an upper bound at \(b\) yields an upper bound at \(a\). Prefix sums calculate the intervening durations.

This is **precedence-based bound preprocessing**. It does not assume that all piles of a vessel are contiguous.

### 3. Minimum pad-residence bounds

For positive \(q\), stacking completion and occupancy coverage imply

\[
tR_i-tS_i\ge q\,dS_i^{c},
\qquad
q\,dT_i^{c}\ge tR_i+dR_i-tS_i.
\]

Combining them gives

\[
dT_i^{c}\ge dS_i^{c}+
\left\lceil\frac{dR_i}{q}\right\rceil.
\]

The reformulation adds this implied bound when the reclaim duration is nonnegative, using an integer expression for the ceiling. This strengthens the occupancy-duration bounds without forcing occupancy to its minimum: longer durations remain permitted.

### 4. Pairwise pad-conflict cuts

For two piles whose discretized lengths sum to more than the pad width, spatial separation is impossible. For example, placing pile \(a\) entirely before pile \(b\), together with pad containment and nonnegative positions, would imply

\[
len_a^{c}+len_b^{c}\le H^{c},
\]

contradicting the pair’s combined length.

The original `diffn` constraint must therefore separate these piles in time:

\[
tS_a^{c}+dT_a^{c}\le tS_b^{c}
\quad\lor\quad
tS_b^{c}+dT_b^{c}\le tS_a^{c}.
\]

The reformulation adds this disjunction explicitly for pairs satisfying the stated length conditions. It is a **pairwise incompatibility cut**, not an additional operational assumption.

### 5. Pairwise stacking-conflict cuts

If two positive-duration stacking tasks have combined demand greater than `stCap`, they cannot overlap when all stacking demands are nonnegative. Otherwise, those two tasks alone would violate the original stacking cumulative constraint.

The reformulation therefore adds an explicit ordering disjunction for each qualifying pair. Guards check nonnegative task durations and demands, and require both selected tasks to have positive duration. These conditions avoid applying the argument where zero-duration tasks or negative demands would invalidate it.

### 6. Solver setup and solution mapping

The original CP-oriented search annotations are removed in favor of a plain minimization solve item. This changes search guidance, not the feasible set or objective.

The accompanying mapping script copies the six original independent variable declarations directly from the reformulated solution, preserving array index encodings and excluding auxiliary data. No reconstruction is needed because these variables were retained.

## Expected effect

The changes aim to reduce solving time through tighter static bounds, fewer division expressions, and explicit resource conflicts. They preserve the original global constraints rather than replacing them with weaker approximations. Actual performance benefits remain instance-dependent; no benchmark results were provided.

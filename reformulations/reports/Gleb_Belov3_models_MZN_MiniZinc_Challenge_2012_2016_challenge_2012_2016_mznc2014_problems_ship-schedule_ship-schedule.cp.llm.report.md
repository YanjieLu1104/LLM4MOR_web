# Ship Scheduling with Tide-Dependent Draft and Tug Availability

## Real-world background

The model schedules ship movements through a port over a discrete planning horizon. Each ship may either sail or remain unscheduled. Its departure time determines its maximum permitted draft, reflecting predicted tides, waves, and port safety rules. Greater draft can accommodate more cargo, with a ship-specific conversion from centimetres of draft to tonnes.

The schedule must respect loading readiness, separation between ship movements, shared-berth timing requirements, and tug availability. Tug requirements are divided into sets with potentially different turnaround times. Additional restrictions represent the transfer of tugs from incoming to outgoing movements.

Several details of the mathematical model are important: even ships that do not sail retain a transit-time variable; berth constraints and extra-tug conditions apply regardless of sailing status; and incoming and outgoing ship sets are supplied independently. The reformulation preserves these details rather than imposing additional operational assumptions.

## Original model structure

Let \(S\) denote the number of ships, \(T\) the number of time slots, and \(K\) the maximum number of tug sets per ship.

### Variables

The original model declares six independent decision-variable arrays:

| Array | Number of entries | Meaning |
|---|---:|---|
| `TransitStartTimeSlot` | \(S\) | Selected transit time, whether or not the ship sails |
| `ShipSails` | \(S\) | Binary sailing decision |
| `Draft_cm` | \(S\) | Maximum allowable draft at the selected time |
| `TugsBusy` | \(STK\) | Tug usage by ship, time slot, and tug set |
| `TugsBusyExtra` | \(S\) | Extra tug allowance associated with a ship |
| `TugsBusyPerTimeSlot` | \(T\) | Total ordinary tug usage at each time |

It also defines \(S\) per-ship objective contributions and one aggregate objective variable. Actual instance dimensions were not supplied.

### Constraints

- **Draft selection:** Each ship’s draft equals the table entry at its selected transit time.
- **Sailing eligibility:** A zero draft prohibits sailing. A sailing ship cannot depart before its earliest permissible time.
- **Berth coordination:** Each supplied berth-swap pair imposes an upper bound on the outgoing ship’s start time relative to the incoming ship’s start time.
- **Movement separation:** For each unordered pair of sailing ships, at least one of two directed separation inequalities must hold.
- **Ordinary tug occupancy:** A sailing ship occupies each tug set from its start time until that set’s turnaround interval ends, restricted to time slots in the planning horizon. Otherwise, its occupancy is zero.
- **Tug capacity:** Incoming ordinary tug usage is bounded by the available fleet. A separate outgoing capacity constraint includes ordinary usage and extra allowance at each outgoing ship’s selected start time.
- **Extra tug conditions:** Incoming–outgoing timing implications force specified extra allowances or zero. These implications do not depend on whether the ships sail.
- **Aggregation and validation:** Total ordinary tug usage is calculated, and assertions check positive dimensions and valid earliest-start times.

The extra-tug implications are not a general summation of overlapping incoming requirements. Multiple implications may constrain the same allowance simultaneously. This behavior is retained exactly.

### Objective

The model maximizes

\[
\sum_{s=1}^{S}
\text{ShipSails}_s\,
\text{Draft}_{s}\,
\text{TonnesPerCmDraft}_{s}.
\]

This is a draft-based cargo-value measure. The original formulation combines variable-index table lookups, logical implications, scheduling disjunctions, and products of decision variables.

## Reformulation and justification

### 1. Binary time assignment and active sailing

Two binary arrays were introduced:

- \(x_{s,t}\): ship \(s\) selects time \(t\);
- \(y_{s,t}\): ship \(s\) sails at time \(t\).

The linking equations are

\[
\sum_t x_{s,t}=1,\qquad
\text{TransitStartTimeSlot}_s=\sum_t t x_{s,t},
\]

\[
\sum_t y_{s,t}=\text{ShipSails}_s,\qquad
y_{s,t}\le x_{s,t}.
\]

Exactly one time is selected for every ship. If the ship sails, its unique active assignment must coincide with that time; otherwise all active assignments are zero. Thus this representation preserves both sailing and non-sailing schedules, including transit times needed by unconditional constraints.

### 2. Eligibility preprocessing

Active assignments are fixed to zero when either:

- the time precedes the ship’s earliest start; or
- the corresponding draft-table entry is zero.

These fixings follow directly from the original readiness implication and zero-draft prohibition. They do **not** eliminate the underlying time assignments: a non-sailing ship can still select such a time. No positivity assumption is introduced for other draft values.

### 3. Linear draft selection and cargo value

The variable-index draft lookup is replaced by

\[
\text{Draft}_s=\sum_t D_{t,s}x_{s,t}.
\]

Because \(x\) selects exactly one time, this equals the original table lookup.

Each cargo contribution becomes

\[
\sum_t D_{t,s}C_s y_{s,t},
\]

where \(C_s\) is the ship’s tonnes-per-centimetre coefficient. This is zero for a non-sailing ship and equals the selected draft times \(C_s\) for a sailing ship. It therefore replaces the original decision-variable product without changing objective values.

### 4. Forbidden-time-window separation inequalities

For ship pair \(i<j\), fixing ship \(i\)'s active departure to time \(t\) makes a time \(u\) incompatible for ship \(j\) precisely when both original separation alternatives fail:

\[
u-t<\Delta_{i,j},
\qquad
t-u<\Delta_{j,i}.
\]

For this set of incompatible times \(F_{i,j,t}\), the reformulation imposes

\[
y_{i,t}+\sum_{u\in F_{i,j,t}}y_{j,u}\le 1.
\]

This is valid because ship \(j\) has at most one active departure. When \(y_{i,t}=1\), every incompatible departure is prohibited; when it is zero, the inequality follows from that at-most-one property. Conversely, any active pair violating the original separation disjunction violates one of these inequalities.

This conflict-window formulation avoids explicit ordering disjunctions and remains correct for zero or negative separation parameters.

### 5. Linear ordinary tug occupancy

Each original tug-usage variable is retained and linked by

\[
\text{TugsBusy}_{s,t,k}
=
R_{s,k}
\sum_{\substack{u\le t\\t<u+L_{s,k}}}y_{s,u},
\]

where \(R_{s,k}\) is the tug requirement and \(L_{s,k}\) its turnaround time.

The sum is one exactly when the ship sails and the selected start places time \(t\) inside the original occupancy interval; otherwise it is zero. This replaces the original pair of complementary implications with a linear equality. Original variable bounds, all tug-set indices, and planning-horizon truncation are retained.

### 6. Linear extra allowance at the selected start

Auxiliary nonnegative variables distribute each outgoing ship’s extra allowance across time. They sum to its original allowance and are bounded above by \(M x_{s,t}\), where \(M\) is the original allowance upper bound.

Since exactly one \(x_{s,t}\) equals one, the full allowance must appear at the selected time and nowhere else. This exactly replaces the product of the extra allowance and the start-time indicator in outgoing capacity constraints. The original conditions determining that allowance remain unchanged.

## Expected effect and solution correspondence

The reformulation targets HiGHS by replacing several CP-oriented constructs with explicit linear mixed-integer relationships. It adds time-indexed binary variables, trading formulation size for more direct linear structure; no runtime improvement has been measured on supplied instances.

All six original independent variable arrays remain present. The mapping script copies their values unchanged and excludes reformulation auxiliaries. It reports missing solution fields rather than fabricating values. External data names and domains, original variable meanings, and the maximization direction are preserved.

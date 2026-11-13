# Ship Scheduling with Tide-Dependent Draft and Tug Constraints

## Real-world background

The model schedules ship transits through a port over a discrete planning horizon. Each ship may sail or remain unscheduled. Its allowable draft depends on the chosen departure slot, reflecting predicted tides, waves, and port safety rules. The objective rewards sailing at a larger allowable draft, weighted by a ship-specific tonnes-per-centimetre coefficient.

Scheduling is restricted by loading-completion times, directional separation requirements between ships, berth-sharing relationships, and tug availability. Tug requirements are specified in sets with potentially different turnaround times. An additional rule accounts for the transition from an incoming transit to an outgoing transit.

The mathematical model contains some important details that must not be replaced by more intuitive operational assumptions:

- Every ship has a departure time, even when it does not sail.
- Berth-swap constraints and extra-tug implications apply regardless of sailing decisions.
- Incoming and outgoing tug capacities are checked separately.
- Every tug-set column participates; `NTugSetsPerShip` does not restrict the original constraints.
- The incoming and outgoing ship sets are not explicitly required to be disjoint or exhaustive.

## Original model structure

Let \(N\) denote the number of ships, \(T\) the number of time slots, and \(K\) the maximum number of tug sets.

### Variables

The original model declares six independent integer-variable arrays:

| Variable | Entries | Meaning |
|---|---:|---|
| `TransitStartTimeSlot` | \(N\) | Assigned departure slot |
| `ShipSails` | \(N\) | Binary sailing decision |
| `Draft_cm` | \(N\) | Allowable draft at the assigned slot |
| `TugsBusy` | \(NTK\) | Tug usage by ship, slot, and tug set |
| `TugsBusyExtra` | \(N\) | Additional tug allowance |
| `TugsBusyPerTimeSlot` | \(T\) | Total ordinary tug usage |

Thus, there are \(4N+NTK+T\) independent variable entries, plus \(N\) defined objective-contribution entries. Some independent arrays are nevertheless uniquely determined by other decisions through constraints.

### Constraints

The main constraint groups are:

- **Draft lookup:** each ship’s draft equals the input draft limit at its assigned departure slot.
- **Sailing eligibility:** zero draft prohibits sailing; a sailing ship cannot depart before its earliest permitted slot.
- **Berth relationships:** each specified outgoing departure must occur no later than the corresponding incoming departure plus an allowed time difference.
- **Pairwise separation:** for each unordered pair of sailing ships, at least one directional separation inequality must hold.
- **Ordinary tug occupancy:** a tug set is busy exactly when its ship sails and the current slot lies in its turnaround interval.
- **Capacity:** incoming ordinary tug usage and outgoing ordinary-plus-extra usage are separately bounded by the available tug count.
- **Extra-tug implications:** incoming/outgoing departure-time relationships impose specified values on the outgoing ship’s extra allowance. Incoming ships have zero extra allowance.

The extra-tug implications are pairwise equalities, not a sum or maximum over incoming ships. Multiple applicable implications can therefore conflict. Equal departure times can also leave an allowance unrestricted by a particular pair. Both behaviors are part of the original formulation.

### Objective

The model maximizes
\[
\sum_{s=1}^{N}
ShipSails_s\,Draft\_cm_s\,TonnesPerCmDraft_s.
\]

This is a draft-based cargo-value measure, with zero contribution from non-sailing ships. The original expression contains a product of decision variables.

## Reformulation and justification

The reformulation targets the HiGHS mixed-integer backend by making the principal scheduling, cargo, and occupancy relationships explicitly linear. All original independent variables are retained.

### 1. Time-indexed departure and sailing selection

Two binary arrays were introduced:

- \(x_{s,t}=1\) when ship \(s\) is assigned departure slot \(t\);
- \(y_{s,t}=1\) when ship \(s\) sails at slot \(t\).

The linking constraints are
\[
\sum_t x_{s,t}=1,\qquad
TransitStartTimeSlot_s=\sum_t t\,x_{s,t},
\]
\[
y_{s,t}\le x_{s,t},\qquad
\sum_t y_{s,t}=ShipSails_s.
\]

**Why this is valid:** exactly one departure slot is selected. If the ship sails, exactly one sailing selection must occur at that same slot; otherwise all sailing selections are zero. Non-sailing ships retain their departure-time choices, which remain necessary for the unconditional berth and extra-tug rules.

### 2. Eligibility preprocessing

Sailing selections are fixed to zero whenever the slot precedes the ship’s earliest start or its input draft limit is zero.

**Why this is valid:** these are direct consequences of the original earliest-start implication, draft lookup, and zero-draft prohibition. Only sailing selections are removed; departure selections remain available for non-sailing ships. No assumption that all nonzero drafts are positive is introduced.

### 3. Linear draft and cargo expressions

The draft lookup becomes
\[
Draft\_cm_s=\sum_t MaxSailingDraft_{t,s}x_{s,t},
\]
and the objective contribution becomes
\[
\sum_t MaxSailingDraft_{t,s}\,TonnesPerCmDraft_s\,y_{s,t}.
\]

**Why this is valid:** the unique departure selection reproduces the original lookup. If the ship sails, the sailing selection identifies the same slot; if not, its contribution is zero. These expressions therefore reproduce the original values without a variable-index lookup or decision-variable product, including when input coefficients are negative.

### 4. Forbidden-window separation inequalities

For each ship pair \(s<r\) and eligible departure slot \(t\) of ship \(s\), the reformulation adds
\[
y_{s,t}+\sum_{u\in F_{s,r,t}}y_{r,u}\le1,
\]
where \(F_{s,r,t}\) contains eligible slots \(u\) for which both original separation alternatives fail:
\[
u-t<MinSeparation_{s,r},
\qquad
t-u<MinSeparation_{r,s}.
\]

**Why this is valid:** selecting \(s\) at \(t\) must exclude every such conflicting selection for \(r\). Conversely, a pair satisfying either original separation inequality is not excluded. Since ship \(r\) has at most one sailing selection, combining all conflicting slots into one inequality does not remove any valid integer schedule.

This replaces the conditional separation disjunction with linear conflict constraints.

### 5. Linear tug occupancy

Ordinary tug usage is expressed as
\[
TugsBusy_{s,t,k}
=
TugSets_{s,k}
\sum_{\substack{u\le t\\t<u+Turnaround_{s,k}}}y_{s,u}.
\]

**Why this is valid:** the sum is one exactly when the sailing ship’s selected departure activates that tug set at slot \(t\), and zero otherwise. This reproduces the original complementary occupancy implications. Nonpositive turnaround times yield empty occupancy intervals, and intervals remain restricted to the original planning horizon.

### 6. Linear extra-tug allocation

A nonnegative integer auxiliary array distributes each outgoing ship’s extra allowance over departure slots. Each entry is bounded by the original allowance upper bound times \(x_{s,t}\), and the entries sum to `TugsBusyExtra`.

**Why this is valid:** every unselected slot must receive zero. Consequently, the selected departure slot receives the entire extra allowance, exactly reproducing
\[
TugsBusyExtra_s\,[t=TransitStartTimeSlot_s].
\]
This removes another decision-variable product without changing the extra-tug implications themselves.

## Preservation and expected computational effect

The reformulation preserves the original objective direction, external data interface, original variable domains, and unconditional scheduling rules. The supplied mapping copies only the six original independent variable arrays; auxiliary arrays are not exported as original decisions.

The intended benefit is a more explicit mixed-integer linear formulation, avoiding several generic lookup, product, and reification decompositions. The trade-off is additional time-indexed variables and potentially substantial conflict-constraint generation. No runtime improvement has been measured here, so the performance benefit remains instance-dependent.

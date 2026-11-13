# Pipe-Routing Model: Structure and Reformulation

## 1. Real-world interpretation

This instance represents **three-dimensional pipe routing in an industrial installation**. A pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by right-angle bends.

The data describe 124 boxes: equipment modules, fixed pipe obstacles, support zones, a rack, and preferred rack support levels. Coordinates use a discretized length unit of 200 mm. Pipe clearance is represented by expanding each leg’s bounding box by the modeled radius and applying obstacle-specific safety distances.

The instance contains one pipe with ten node positions, including two fixed endpoints. Nine candidate legs allow routes of different lengths: an active prefix describes the actual route, and subsequent legs collapse to the destination.

The objective balances pipe length, bends, and bend-support costs. Although the input contains a “through rack” flag, its corresponding constraint is commented out in the original model; the reformulation therefore does not impose mandatory rack passage.

## 2. Original mathematical structure

### Decision variables

The original independent declarations contain 151 scalar integer entries before presolve:

- **30 node coordinates**, including six fixed endpoint coordinates;
- **60 leg-bound coordinates**, describing the lower and upper corners of expanded leg boxes;
- **30 coordinate-wise leg lengths**;
- **10 direction codes**, identifying inactivity or one of six signed coordinate directions;
- **10 existence flags** and **10 last-leg flags**, each restricted to zero or one;
- **One objective variable**.

The leg arrays include a tenth, dummy entry, which is constrained to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The main constraint groups are:

1. **Leg geometry.** Bounding boxes contain both endpoint nodes, expanded by the pipe radius. Their widths determine coordinate-wise leg lengths. Direction constraints force movement along exactly one coordinate axis for an active leg.

2. **Route sequence.** Existence and last-leg flags enforce a contiguous active prefix with exactly one final leg. At least three legs are active.

3. **Nozzle connections.** The first leg has a prescribed direction and length range. The dynamically selected final leg has another prescribed direction and length range and ends at the fixed destination.

4. **Orthogonality.** Consecutive active legs cannot use the same coordinate axis, preventing both straight continuation and immediate reversal.

5. **Obstacle clearance.** A leg must be separated from each relevant obstacle along at least one axis. Specific exceptions permit the first leg to leave its source module and the final leg to enter its destination module. Inactive legs receive the destination-module exception but are not generally exempt from obstacle checks.

6. **Support membership.** Nodes associated with non-first candidate legs must belong to a support zone. These requirements also apply to nodes of inactive candidate legs. Membership uses the node center horizontally and the pipe bottom vertically.

7. **Inter-pipe clearance and flexibility.** These are present in the general formulation but impose no restrictions in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes the original scaled cost expression. For this instance, the effective coefficients are:

- **141 per unit of pipe length**;
- **1,401 per active non-first leg**, representing a bend;
- **51 per supported bend outside preferred rack levels**, or **1 within a preferred level**.

These coefficients follow the original integer division by 100 followed by addition of one. The reformulation preserves that arithmetic rather than replacing it with an approximation to the unscaled costs.

## 3. Reformulation and validity

### Linear signed-length formulation

The direction implications were replaced by positive- and negative-direction indicators and corresponding nonnegative lengths for each leg and axis.

The indicators sum to the leg-existence flag, so an active leg selects exactly one signed direction. Each signed length is bounded above by its indicator times a valid maximum and below by its indicator times the original minimum leg length. Node displacement is the positive length minus the negative length.

This is equivalent to the original geometry. In the original model, endpoint containment makes each coordinate-wise length at least the absolute endpoint displacement. The selected-direction constraint supplies the reverse inequality, forcing equality; unselected axes have zero length. Thus the bounding box is exactly the endpoint span expanded by the radius. The reformulation writes these relationships directly as linear equations, retaining the original bounding-box and length variables.

This gives HiGHS a more explicit mixed-integer linear representation.

### Bound-derived length limits and obstacle preprocessing

Signed-length upper bounds use both the original maximum leg length and the maximum displacement allowed by the endpoint coordinate domains.

These bounds are valid because a positive displacement cannot exceed the next node’s upper bound minus the current node’s lower bound; the analogous expression bounds negative displacement.

An obstacle check is omitted only when coordinate bounds establish separation for **every possible position of the entire leg** along at least one axis. Specifically, either the obstacle lies below the smallest possible lower leg boundary or above the largest possible upper boundary, including radius and safety distance. Such a disjunction is already always true, so removing it cannot change feasibility.

### Boolean linearization of support costs

The original support cost multiplies a leg-existence flag by a membership-dependent cost. The reformulation distributes that product into weighted Boolean conjunctions.

This is exact because existence, preferred-level membership, and the “not in a preferred level” flag are Boolean-valued. Their products equal the indicators of their conjunctions. The original restriction on preferred-level membership is retained through the zero–one domain of `fNodeNotInPref`.

### Valid lower bounds on total travel

Additional inequalities bound total length separately on each axis.

Let \(P\) and \(N\) denote total positive and negative travel, and let \(\Delta\) be the fixed endpoint displacement. The node-displacement equations imply

\[
P-N=\Delta,\qquad L=P+N.
\]

Consequently, \(L\geq|\Delta|\). If the mandatory nozzle legs require at least \(P_{\min}\) positive travel and \(N_{\min}\) negative travel, then also

\[
L\geq 2P_{\min}-\Delta,
\qquad
L\geq \Delta+2N_{\min}.
\]

The nozzle directions, nozzle length bounds, and general active-leg minimum lengths establish those mandatory amounts. The first and final legs are distinct because the original sequence constraints require at least three active legs. These inequalities therefore strengthen the relaxation without excluding feasible routes.

### Removal of instance-vacuous expressions

Two general-model components were omitted:

- **Inter-pipe separation:** every node belongs to the same pipe, so there are no qualifying pairs of different pipes.
- **Flexibility:** the supplied coefficient is zero, so the original conditional flexibility constraints evaluate to true and their defined length-cube sums evaluate to zero.

Neither removal changes the feasible set for the supplied instance.

### Data and solution-interface repairs

A missing entry introduced during transcription of `nBoxType` was restored. Its original 124 entries now match the 372 coordinate and size entries; no instance data were intentionally changed.

The final mapping script returns only the original independent variables. It copies retained coordinate and routing variables, reconstructs the six fixed endpoint coordinates from the original embedded constants, and obtains the objective from the solution. Missing required fields produce an error rather than fabricated values.

## 4. Expected computational effect

The reformulation is intended to improve HiGHS performance through more explicit linear geometry, tighter signed-length bounds, fewer redundant obstacle checks, and additional travel lower bounds. All original routing exceptions, inactive-node support requirements, and objective coefficients are preserved. No measured runtime improvement was established in the conversation.

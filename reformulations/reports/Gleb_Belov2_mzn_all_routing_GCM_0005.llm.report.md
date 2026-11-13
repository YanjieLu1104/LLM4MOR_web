# Industrial Pipe-Routing Model and Reformulation

## 1. Background and interpretation

The model represents the routing of one pipe through a three-dimensional industrial layout. It connects two fixed nozzle locations using axis-aligned straight segments and right-angle bends. Coordinates are integer-valued, with each coordinate unit representing **200 mm**.

The supplied instance contains **10 ordered nodes**, allowing at most **9 pipe segments**, and **102 fixed boxes**. Box types distinguish equipment modules, existing pipe segments, support zones, a large pipe rack, and preferred rack levels.

A feasible route must:
- Respect nozzle connection directions and segment-length limits.
- Avoid relevant obstacles, accounting for pipe radius and safety clearance.
- Place intermediate nodes within permitted support zones.
- Satisfy a cubic-length flexibility condition, apparently intended to represent a simplified engineering flexibility requirement.

The objective balances pipe length, bends, and support costs. Although the data include a rack-traversal flag, its associated constraint is commented out. The original model also does not prohibit intersections between nonadjacent segments of this same pipe. Neither restriction was added.

## 2. Original mathematical structure

### Variables

The original independent declarations contain **151 integer-variable entries**, including fixed entries:

| Variables | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Three coordinates for each of 10 nodes; six endpoint coordinates are fixed |
| Lower and upper segment-box corners | 60 | Radius-expanded bounding boxes |
| Coordinatewise segment lengths | 30 | Nonnegative lengths along the three axes |
| Segment directions | 10 | Zero for an inactive segment; six signed coordinate directions otherwise |
| Segment-existence indicators | 10 | Whether each segment position is active |
| Last-segment indicators | 10 | Which segment terminates the route |
| Objective variable | 1 | Total scaled cost |

The segment arrays include a terminal dummy position, fixed to zero. Additional defined arrays represent obstacle separation, support membership, support costs, and sums of cubed lengths.

### Constraints

**Route geometry.** Endpoint containment, bounding-box widths, and direction implications force each active segment to follow exactly one coordinate axis. Consecutive active segments cannot use the same axis, preventing both straight continuation and immediate reversal.

**Segment sequence.** Existence and last-segment indicators enforce a contiguous active prefix. At least the first three segments exist, and exactly one segment is last. Inactive segments have zero length, so subsequent nodes coincide with the final endpoint.

**Nozzle connections.** The first and last active segments obey prescribed directions and length bounds. The general active-segment minimum also applies: here, the nozzle-specific minimum is 3 units, but the general minimum of 6 units makes the effective minimum 6.

**Obstacle clearance.** A segment must be separated from each relevant obstacle along at least one coordinate axis. Exceptions permit the first segment to connect to its source module and the last segment to connect to its destination module. Importantly, most obstacle constraints also apply to inactive segment positions.

**Support requirements.** Intermediate nodes must belong to at least one support zone, even when their outgoing segment is inactive. Horizontal membership uses the node center; vertical membership uses the pipe bottom. Preferred rack levels affect support cost.

**Flexibility.** For each coordinate axis, the model sums cubed segment lengths in the other two axes. This sum must dominate a coefficient times each contributing segment length. The coefficient depends on fixed nozzle separation, unit conversion, and the supplied engineering factor.

### Objective

The model minimizes the original scaled integer cost:
- **181 per unit of pipe length**;
- **1,801 per active segment after the first**, representing bends;
- **51 per charged support outside preferred levels**, or **1 inside a preferred level**.

These coefficients follow the original rule of integer division by 100 followed by addition of 1. The reformulation preserves this objective exactly.

## 3. Reformulation and validity

### Exact signed-length formulation

Direction implications were replaced by binary signed-direction indicators and nonnegative positive and negative lengths for each axis.

This is valid because the original constraints already force exact segment geometry. Endpoint containment implies that the coordinatewise length is at least the absolute endpoint displacement. The selected direction imposes the opposite upper bound, while unselected axes have zero length. Together, these conditions force equality.

Consequently, the reformulation can express endpoint displacement as positive length minus negative length, and total coordinatewise length as their sum. It also computes the lower and upper bounding-box corners directly. Exactly one signed direction is selected for an active segment and none for an inactive segment.

### Coordinate-specific bound preprocessing

Length upper bounds were tightened using:
1. The original maximum segment length.
2. The largest possible endpoint difference permitted by coordinate domains.
3. First- and last-possible-segment nozzle restrictions.

These bounds cannot exclude an original feasible route because segment lengths equal absolute endpoint differences, and the nozzle restrictions already hold in the original model. Length-table entries outside these bounds, or below the original active-segment minimum, are fixed to zero.

### Exact finite-domain representation of cubes

Variable powers were replaced by a finite-domain formulation using continuous nonnegative weights and binary encoding bits.

For each segment, the weights sum to its existence indicator. Weighted candidate lengths determine total segment length, and weighted cubes determine total cubed length. For each binary digit, the total weight on candidates having that digit equal to one is constrained to equal a binary variable.

The representation is exact:
- For an inactive segment, all weights are zero.
- For an active segment, weights sum to one.
- Each binary digit excludes candidates inconsistent with its selected value.
- Distinct candidate lengths have distinct binary encodings, leaving exactly one selected length.

Because only one coordinate axis can be active, direction-dependent bounds assign the selected cube to that axis and force the other coordinate cubes to zero. Thus, the original flexibility constraints are preserved without approximating the cubic function.

### Linear support-cost reformulation

Products involving segment existence and support classification were rewritten as Boolean conjunctions.

For binary indicators, multiplication equals the indicator of conjunction. Distributing the original existence factor across the support-cost expression therefore gives the same cost. Exact support membership and the original restriction implicit in the domain of `fNodeNotInPref` remain enforced.

### Valid route-length cuts

Additional lower bounds strengthen the formulation using fixed endpoint displacement and prescribed nozzle directions.

For each axis, let \(P\) and \(N\) be total positive and negative travel. The route geometry gives
\[
P-N=\Delta,\qquad L=P+N.
\]
Hence \(L\geq|\Delta|\). If a mandatory nozzle segment travels opposite to the net displacement, every unit of that travel requires an additional compensating unit in the other direction, increasing the bound by twice its minimum length.

The first and last active segments are distinct because the original sequence constraints require at least three active segments. Their mandatory opposing travel can therefore be added without double-counting.

### Data and solution interface

A transcription error that had introduced an extra box-size entry was corrected by restoring the original **306 entries**, corresponding to 102 three-dimensional boxes.

All original independent variables remain in the model. The mapping script copies their solution values, excludes reformulation auxiliaries, and supplies fixed endpoint coordinates from the original embedded data if omitted from solver output. Missing nonfixed variables produce an explicit error rather than guessed values.

These changes target a stronger, explicitly linear mixed-integer formulation suitable for HiGHS. No measured solve-time improvement is established by the conversation.

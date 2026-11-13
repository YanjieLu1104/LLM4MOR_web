# Reformulation of the Elitserien Handball Scheduling Model

## 1. Background and scheduling problem

The model constructs a season schedule for a **14-team handball league**, divided into two seven-team divisions.

The season consists of:
- A seven-round single round-robin tournament within each division. Each team plays its six divisional opponents and has one bye.
- A 13-round single round-robin tournament involving all 14 teams.
- A final 13-round tournament obtained by reversing the order of the preceding tournament and swapping home and away venues.

Only the first **20 rounds** are represented explicitly. The remaining rounds are reconstructed through the mirror relationship: round \(p\), for \(21 \leq p \leq 33\), corresponds to round \(41-p\) with venues reversed.

The model distinguishes between **template rows** and actual teams. Template rows have structural scheduling properties, including fixed bye rounds. A permutation assigns actual teams to those rows. External data specify division membership requirements, venue unavailability, derby groups, and pairs of teams requiring complementary schedules.

The objective is to **minimize games scheduled at unavailable home venues**. Such conflicts are penalized rather than prohibited. Although breaks—consecutive home games or consecutive away games—are central to the scheduling rules, the active objective does not minimize their number; their distribution is constrained explicitly.

## 2. Original mathematical structure

### Decision variables

The original model declares **603 top-level integer decision variables**:

| Variable | Count | Meaning |
|---|---:|---|
| `hap` | 280 | Home, away, or bye status for each template row and explicit round |
| `contestant` | 280 | Opponent template row; a self-opponent denotes a bye |
| `break` | 14 | Break position, with zero representing no break |
| `row` | 14 | Template row assigned to each actual team |
| `team` | 14 | Inverse of the team-to-row assignment |
| `objective` | 1 | Total venue-unavailability penalty |

A local array of 13 Boolean variables expresses adjacency-based complementary-schedule conditions.

### Constraints

The principal constraint families are:

- **Team assignment:** `row` and `team` are inverse permutations. Specified actual teams must occupy rows in the required division.
- **Home/away sequences:** a deterministic finite automaton restricts each row’s sequence. Together with the fixed bye positions, it determines the permitted alternation and break behavior.
- **Round-robin coverage:** opponent values are distinct within each tournament. During the divisional tournament, opponents must belong to the same division.
- **Reciprocal matches:** the opponent mapping in each round is its own inverse.
- **Venue compatibility:** opponents have opposite home/away statuses. A self-opponent is equivalent to a bye.
- **Alternating venues between meetings:** an `alldifferent` constraint on the values \(3\,\text{contestant}+\text{hap}\) prevents a row from meeting the same opponent twice with the same home/away status.
- **Break distribution:** each division has six rows with nonzero breaks. Across the league, each value in \(\{0,9,11,13,15,17,19\}\) occurs exactly twice.
- **Additional requirements:** derby matches, complementary schedules, fixed bye positions, and structural restrictions on adjacent rows.

### Objective

The model minimizes the number of home games conflicting with the supplied `nohome` data. For the final 13 rounds, it evaluates the corresponding explicit round with home and away exchanged.

## 3. Reformulation and justification

### 3.1 Precomputed home/away patterns

The reformulation replaces the DFA and break-position calculation with **binary selection from a precomputed pattern set**.

There are exactly **14 admissible patterns per template row**: two home/away orientations for each break value in
\[
\{0,9,11,13,15,17,19\}.
\]

This reduction follows from the original constraints:

1. The fixed-bye constraints prescribe each row’s bye round within rounds 1–7.
2. Before and around that bye, the DFA forces played games to alternate between home and away.
3. The DFA reaches one of two orientation states after round 8.
4. Its subsequent transitions permit either continued alternation or a single equal-status pair beginning at round 9, 11, 13, 15, 17, or 19.
5. After that pair, the DFA forces alternation for the rest of the explicit schedule.

Consequently, a row’s bye position, initial orientation, and break value determine its entire sequence. Conversely, every generated pattern follows those DFA transitions and reaches an accepting state.

One binary pattern is selected for each row. Linear equations recover the original `hap` and `break` variables. The original break-cardinality restrictions remain in place.

This is **problem-specific pattern enumeration**, intended to give HiGHS a more direct binary formulation than a general automaton decomposition.

### 3.2 Directed match variables

The reformulation introduces a binary variable for each ordered pair of rows and each explicit round. It indicates that the first row hosts the second.

For every row and round:
- The number of outgoing matches equals its selected home indicator.
- The number of incoming matches equals its selected away indicator.
- Self-match variables are fixed to zero.

A bye therefore has no incident match, while every other row participates in exactly one match with a compatible venue assignment. The original opponent variable is recovered as the opposing row, or as the row itself during its bye.

These equations replace the original per-round opponent inverse and variable-indexed venue-compatibility constraints. Their equivalence follows because each selected directed match simultaneously supplies both teams’ reciprocal opponent relationships and opposite venue statuses.

### 3.3 Explicit round-robin coverage equations

For each unordered pair of distinct rows, the reformulation requires:
- One meeting in the first tournament if both rows belong to the same division, and none otherwise.
- Exactly one meeting in the second tournament.

These equations are equivalent to the original opponent-domain and distinctness constraints when combined with the permitted home/away patterns:

- In the first tournament, seven distinct opponent values must come from the row’s seven-team division. The prescribed bye accounts for the self-opponent, leaving exactly one meeting with each of the other six rows.
- In the second tournament, the DFA permits no byes. Thirteen distinct opponents must therefore be precisely the other thirteen rows.

This replaces indirect opponent coverage with explicit **pair-coverage equations**.

### 3.4 Directed-pair inequalities for alternating venues

For every ordered pair of distinct rows, the reformulation imposes
\[
\sum_{p=1}^{20} x_{t,u,p}\leq 1.
\]

Thus, one row cannot host the same opponent twice in the explicit schedule.

This replaces the original encoded `alldifferent` constraint. Values \(3u+\text{hap}\) belonging to different opponents cannot coincide, so that constraint prohibits precisely repeated opponent/status combinations. Once match compatibility is enforced, the directed-pair inequalities express the same restriction: repeat meetings must use opposite venues.

### 3.5 Preserved interface and solution mapping

The reformulation retains:
- All original top-level decision variables and their meanings.
- The external data declarations.
- The minimization objective and mirrored-season penalty calculation.
- Derby, complementary-schedule, break-distribution, and active structural restrictions.

The supplied mapping script copies the six original decision-variable fields and excludes auxiliary variables. It performs no schedule reconstruction because the original variables remain explicitly represented in the reformulated model.

## 4. Expected computational effect

The changes replace several generic constraint decompositions with binary pattern selection, match-degree equations, pair-coverage equations, and directed-pair inequalities. These structures are designed for the HiGHS mixed-integer backend and may improve relaxation quality and reduce decomposition overhead.

The reformulation adds binary variables rather than simply reducing the variable count. Its intended benefit is a more explicit mathematical formulation; no measured runtime improvement has been established in the conversation.

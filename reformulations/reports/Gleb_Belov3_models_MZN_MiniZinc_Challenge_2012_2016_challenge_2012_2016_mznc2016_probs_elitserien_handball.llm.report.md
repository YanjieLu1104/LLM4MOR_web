## Background

The model schedules a season for a 14-team handball league. Seven template rows belong to a northern division and seven to a southern division. Actual teams are assigned to these rows, subject to externally supplied division requirements.

The season comprises:
- A seven-round single round-robin within each division, with one bye per team.
- A 13-round single round-robin involving all 14 teams.
- A further 13 rounds obtained by reversing the preceding tournament’s round order and exchanging home and away venues.

Only the first 20 rounds are decision variables; the final 13 are implicit. Additional requirements concern derby matches, complementary home/away schedules, break placement, and alternating venues between repeated opponents.

Venue unavailability is **soft**, rather than a prohibition: the objective minimizes the number of home games assigned to unavailable dates.

## Original formulation

### Variables

The original model declares **603 top-level integer decision variables**, excluding local variables and auxiliaries introduced during compilation:

| Variables | Number | Meaning |
|---|---:|---|
| `hap` | 280 | Away, bye, or home status for each template row and explicit round |
| `contestant` | 280 | Opponent template row; self-reference denotes a bye |
| `break` | 14 | Designated home/home or away/away break position, or zero |
| `row`, `team` | 28 | Mutually inverse actual-team/template-row assignments |
| `objective` | 1 | Total venue-unavailability penalty |

Instance data supply unavailable dates, division memberships, derby sets and periods, and complementary team groups.

### Constraints

The formulation combines several constraint families:

- **Home/away sequences:** A 32-state deterministic finite automaton restricts each row’s 20-round sequence. Bye rounds are fixed by template position.
- **Opponent consistency:** Each round’s opponent array is its own inverse, enforcing reciprocal matches.
- **Round-robin coverage:** Separate `alldifferent` constraints cover each team’s opponents in the divisional and league-wide tournaments.
- **Status channeling:** Opponents have complementary home/away statuses; a team faces itself exactly when its status is bye.
- **Alternating venues:** An `alldifferent` constraint on encoded opponent/status pairs prevents a team from facing the same opponent twice with the same home/away status.
- **Break distribution:** Exactly two rows have each break value in `{0,9,11,13,15,17,19}`, and exactly six rows per division have a nonzero break.
- **Assignment and instance restrictions:** Inverse team assignments, division restrictions, derbies, complementary schedules, and additional template restrictions link the schedule to actual teams.

### Objective

The model minimizes home games conflicting with `nohome`. For rounds 21–33, it evaluates the corresponding explicit round `41-p` with home and away exchanged. Thus the objective accounts for all 33 rounds without explicitly scheduling the final tournament.

## Reformulation and justification

### 1. Enumerate feasible home/away patterns

The automaton was replaced by binary selection among **14 patterns per template row**.

This reduction follows directly from the original automaton and fixed-bye constraints:

1. Each row’s bye occurs at its prescribed divisional round.
2. Before any permitted break, played games alternate between home and away, including across the bye.
3. After the bye, the automaton permits a single transition to its final alternating-state pair. This transition repeats the preceding status and can occur only across rounds `9–10`, `11–12`, …, `19–20`.
4. Once that transition occurs, subsequent statuses alternate; another break is impossible. The automaton also accepts a sequence with no break.

Consequently, a row is determined by two choices: its first played-game orientation and either no break or one of six break positions. Selecting exactly one of these 14 patterns reproduces both `hap` and `break` through linear equalities.

This is an **exact finite-pattern formulation**. Its continuous relaxation describes the convex hull of the individual row patterns, although coupling constraints still require integer decisions for the full schedule. Break-count requirements become linear sums of pattern-selection binaries.

### 2. Use sparse directed-game variables

Binary variables now indicate that one template row hosts another in a particular round. Home and away degree equations connect these variables to the selected patterns.

This replaces the opponent inverse and tournament `alldifferent` constraints without losing their meaning:

- A home row has exactly one outgoing game and no incoming game.
- An away row has exactly one incoming game and no outgoing game.
- A bye row has neither.
- Each selected directed game therefore assigns reciprocal opponents with opposite statuses.

The original `contestant` variables remain and are recovered through linear equalities, including self-reference on bye dates.

For distinct teams within a division, the model requires exactly one meeting in the first tournament. This matches the original seven distinct opponents drawn from seven division rows, one of which must be the team itself on its bye. In the second tournament, exactly one meeting is required for every unordered pair: the original automaton excludes byes there, so 13 distinct opponents must be precisely the other 13 teams.

### 3. Remove impossible game variables before solving

Game binaries are generated only for structurally possible matches:

- No self-games are generated; byes are represented separately.
- Cross-division games are excluded from the first tournament.
- Games involving a row on its fixed bye date are excluded.

These are **problem-specific preprocessing reductions** justified by existing division-domain restrictions, fixed bye positions, and bye/opponent channeling. They introduce no assumptions about the external instance.

### 4. Express alternating venues as directed-pair capacities

For each ordered pair of distinct rows, at most one directed game is allowed across the explicit 20 rounds.

The original encoded `alldifferent` constraint forbids repeating an opponent with the same home/away status. A repeated directed game would do exactly that for both participants. Conversely, with bye handling and home/away consistency already enforced, these capacities exclude every such repetition. Together with tournament coverage, they force repeated intra-division meetings to use opposite venues.

### 5. Preserve the interface and remaining restrictions

The reformulation retains all original top-level decision variables, external parameter declarations, objective direction, and instance-dependent restrictions. Existing complementary-schedule and template conditions are also preserved; no new symmetry breaking is imposed.

The accompanying mapping script copies only the six original decision-variable entities from the default DZN solution and rejects missing fields rather than inventing values.

## Expected computational effect

The changes target the HiGHS mixed-integer backend by replacing automata and several global scheduling constraints with explicit binary selections, linear degree equations, pair-coverage equations, and capacity inequalities. The intended benefits are more direct linear relaxations and fewer generic constraint decompositions.

These are structural improvements, not measured performance results: no instance-specific runtime comparison was established in the conversation.

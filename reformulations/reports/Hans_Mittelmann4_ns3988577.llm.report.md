# Workforce Scheduling Reformulation Report

## 1. Application and interpretation

The instance appears to represent **workforce scheduling over six days**, each divided into **11 periods**, for a pool of **130 agents**. Period-specific demand must be covered while respecting daily and weekly working-time limits.

Agents fall into two capacity groups:

- **95 agents:** at most 10 working periods per day and 47 per week.
- **35 agents:** at most 6 working periods per day and 24 per week.

Every scheduled daily shift must contain at least **four working periods**. The objective is to minimize the number of agents selected for the schedule.

The model also requires a daily amount of excess staffing proportional to the number of shifts. Although this might represent relief or another staffing allowance, its operational interpretation is not specified. Mathematically, excess staffing must total at least **one quarter of the number of daily shifts**. The declared parameter `Descanso_diario`, whose name suggests daily rest, is unused; the model therefore imposes no rest requirement through that parameter.

## 2. Original formulation

### Variables and objective

The original formulation declares **34,450 binary variables**:

| Variable | Count | Mathematical role |
|---|---:|---|
| `X[a,d,t]` | 8,580 | Agent \(a\) works in period \(t\) on day \(d\). |
| `XE[a,d,t]` | 8,580 | Indicates a daily shift start. |
| `Y[a]` | 130 | Agent \(a\) is selected. |
| `Q[a,d,t]` | 8,580 | Marks a working assignment as excess staffing. |
| `B[a,d,t]` | 8,580 | Unused in the objective and constraints. |

The minimization objective is
\[
\min \sum_a Y_a.
\]

### Constraints

The original model contains **44,662 constraint instances**, excluding variable bounds and integrality declarations.

- **Weekly capacity (`R1`):** total work by each agent is bounded by weekly capacity times selection.
- **Daily shift length (`R2`, `R3`):** daily work is bounded above by daily capacity and below by four periods whenever a shift starts.
- **Demand and excess staffing (`R4`):** working agents equal demand plus agents marked by `Q`.
- **Shift timing (`R5`, `R6`):** prefix-capacity inequalities require a start before work can occur, and every transition from nonwork to work requires a start.
- **Excess-staffing eligibility (`R7`, `R8`):** a `Q` assignment requires both work in that period and a daily start.
- **Selection and start limits (`R9`, `R10`):** each selected agent has at most one start per day, and unselected agents cannot work.
- **Daily excess requirement (`R11`):** total daily `Q` assignments must be at least one quarter of the daily starts.

Together, these constraints force every nonempty daily schedule to be a **single contiguous shift**. Specifically, `R9` permits at most one start; `R5` requires a start by the first working period; and `R6` requires a new start whenever work resumes after a gap. A gap followed by further work is therefore impossible.

## 3. Reformulation and justification

The reformulated model retains **17,290 binary variables**: `X`, `XE`, and `Y`. All supplied instance data and the minimization objective are unchanged.

### Elimination of unused variables

All `B` variables were removed because they occur in neither constraints nor the objective. Their values cannot affect feasibility or cost. The mapping script restores them to zero, which satisfies their original binary domains.

### Exact projection of excess-staffing variables

The `Q` variables were eliminated using `R4`, `R7`, and `R11`.

For each day and period, `R4` fixes their total:
\[
\sum_a Q_{adt}=\sum_a X_{adt}-D_{dt}.
\]
Because `Q` is nonnegative, this implies the coverage inequality
\[
\sum_a X_{adt}\ge D_{dt}.
\]

Substituting this identity into `R11` gives
\[
4\left(\sum_{a,t}X_{adt}-\sum_tD_{dt}\right)
\ge \sum_{a,t}XE_{adt}.
\]

These two conditions are also sufficient to reconstruct `Q` for this instance. Demand is nonnegative and integer, so each period’s surplus is an integer between zero and the number of working agents. Assigning `Q=1` to exactly that many working agents satisfies `R4` and `R7`. Every working agent has a daily start, so `R8` also holds. The substituted daily inequality ensures `R11`.

Thus, this is an **exact variable projection**, not a relaxation. The mapping script makes the reconstruction deterministic by assigning surplus indicators in agent-index order.

### Replacement of prefix big-M constraints

The original prefix inequalities `R5` were replaced by
\[
X_{adt}\le \sum_{s\le t}XE_{ads}.
\]

These stronger links are valid because any working period belongs to a shift whose start occurs no later than that period. This follows from the first-work argument using `R5` and `R6`, together with the one-start limit `R9`.

Conversely, the replacement links and retained daily-capacity constraint `R2` imply every original `R5` inequality:

- With no start in a prefix, all work in that prefix is zero.
- With a start in the prefix, prefix work cannot exceed total daily work, which `R2` bounds by daily capacity.

The replacement therefore preserves integer feasibility while tightening the linear relaxation. Original `R10` is redundant because the new links and `R9` imply \(X_{adt}\le Y_a\).

### Contiguity-based preprocessing and minimum-duration cuts

The reformulation fixes to zero any start that leaves fewer than four periods before the end of the day. This is valid because `R3` requires four working periods, while the original start and transition constraints force all daily work into a contiguous block beginning at that start.

It also adds
\[
X_{adt}\ge
\sum_{\substack{s\le t\\t<s+4}}XE_{ads}.
\]

These inequalities require work during the first four periods following a start. They follow from the same contiguity property and `R3`: ending earlier would violate the minimum duration, and restarting later would require a prohibited second start. They make this implied structure explicit in the relaxation.

### Rounded daily shift-count cuts

Let \(S_d\) denote the number of starts on day \(d\), \(W_d\) total daily work, and \(D_d\) total daily demand. Summing `R2` and using the largest daily capacity, 10, yields
\[
W_d\le 10S_d.
\]
Meanwhile, `R4` and `R11` imply
\[
W_d\ge D_d+\tfrac14 S_d.
\]
Combining these bounds and using the integrality of \(S_d\) gives the valid inequality
\[
S_d\ge \left\lceil\frac{4D_d}{39}\right\rceil.
\]

This is an **aggregation-and-integer-rounding cut**. It strengthens the relaxation without excluding any original feasible integer schedule.

### Symmetry breaking among interchangeable agents

Selection and total weekly workload are ordered between consecutive agents with identical daily capacity, weekly capacity, and minimum shift length.

These agents have identical coefficients in all relevant constraints and the objective. Their complete schedules can therefore be permuted without changing feasibility or cost. Within each identical-capacity group, agents can be sorted first by selection and then by decreasing workload. Unselected agents have zero workload by `R1`, so both orders can hold simultaneously.

These constraints remove equivalent labeled schedules while preserving at least one representative of every feasible objective value, including an optimum.

## 4. Expected computational effect

The reformulation removes half of the declared binary variables, eliminates explicit surplus-allocation decisions, replaces weak prefix big-M inequalities with direct logical links, and exposes minimum-duration and aggregate staffing implications. Symmetry breaking additionally reduces equivalent choices among identical agents.

These changes are intended to improve relaxation strength and reduce branch-and-bound search. No solver timings were provided, so a numerical speedup has not been established.

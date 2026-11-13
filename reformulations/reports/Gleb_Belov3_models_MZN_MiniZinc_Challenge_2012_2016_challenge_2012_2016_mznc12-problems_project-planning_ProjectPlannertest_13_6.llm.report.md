## Project Planning with Limited Internal Capacity and Outsourcing

### Problem background

The model represents a small project-planning problem with **13 tasks scheduled over 13 calendar days, numbered 17–29**. Each task receives a day and a Boolean choice that, judging from the capacity and cost expressions, indicates whether it is outsourced.

Task durations are `[3,1,2,2,1,1,2,3,4,3,1,1,4]`, totaling **28 hours**. Internal capacity varies by day according to `[2,4,0,1,2,0,0,2,4,0,1,2,0]`, totaling **18 hours**. Internally performed tasks consume this capacity; outsourced tasks do not. The model imposes no corresponding capacity limit on outsourcing.

Six precedence requirements constrain task dates, regardless of whether the tasks are outsourced. Using task numbers in their original order, these are:

- Task 3 is at least two days after task 1.
- Task 5 is at least two days after task 2.
- Task 9 is no earlier than task 3.
- Task 13 is at least one day after each of tasks 6 and 10, and no earlier than task 3.

Durations act as daily resource requirements, rather than as multi-day execution intervals.

### Original model structure

The source declares **824 scalar variables: 284 Booleans and 540 bounded integers**. Of these, 272 have defining expressions in their declarations. The effective planning decisions are only **13 day choices and 13 outsourcing choices**; the other variables are determined by those decisions.

The generated formulation expresses the problem procedurally:

- **Day lookup:** Element constraints translate each calendar date into a position in the daily-capacity array.
- **Internal resource accounting:** Conditional array updates add each task’s duration to its chosen day only when its outsourcing Boolean is false. A capacity check follows each internal assignment.
- **Task ordering:** Integer counters and conditional rank updates maintain a stable partition with outsourced tasks first.
- **Inverse lookup and cost accumulation:** Nested conditional expressions invert those ranks, retrieve task durations, and accumulate outsourcing costs.
- **Distinct-day counting:** Nested Boolean expressions identify the first outsourced task on each date, so that the daily charge is paid once.
- **Precedence:** Date-position comparisons enforce the six requirements listed above.

Several arithmetic constraints are duplicated, including equivalent expressions with and without multiplication by one. The solve item minimizes `ite551`; its search annotations specify a Boolean-first, then date-search strategy.

Although encoded indirectly, the objective is

\[
\min\quad
5\,\bigl|\{\text{dates containing an outsourced task}\}\bigr|
+2\sum_{\text{outsourced tasks }t}p_t,
\]

where \(p_t\) is task \(t\)’s duration. The rank-update rules put outsourced tasks in the first positions, and the final cost chain charges exactly those positions. Thus, the duration component is simply twice the total outsourced hours.

### Reformulation and justification

The replacement is a **time-indexed binary mixed-integer formulation**, intended for HiGHS. It introduces internal and external assignment indicators for every task–day pair, plus an outsourcing-activation indicator for each day. Each task has exactly one assignment across both modes. The original day and outsourcing variables are retained and linked to these indicators.

#### 1. Aggregate daily capacity replaces sequential updates

For each day, the new model directly limits the sum of internally assigned task durations by that day’s capacity.

This is equivalent to the original prefix checks because every update adds a **positive duration** and never removes load. Consequently:

- A feasible final daily load implies every earlier prefix load is feasible.
- The original check after the last internal task assigned to a day bounds that day’s final load.

The intermediate load arrays therefore need not participate in optimization.

#### 2. Direct outsourcing costs replace ranking and inverse lookup

The stable-partition counters and inverse lookups are removed from the optimization formulation. Their cost contribution is replaced by a weighted sum of outsourcing Booleans.

This is valid because each outsourced task is inserted at the end of the outsourced prefix, while later insertions shift only tasks outside that prefix. The first positions therefore contain exactly the outsourced tasks, each once. Summing their retrieved durations gives the same result as summing task durations directly.

Daily activation indicators replace the nested first-occurrence expressions. An outsourced assignment forces its day’s indicator to one, and each active day must contain an outsourced assignment. These two directions preserve the distinct-day charge exactly, even for nonoptimal feasible solutions.

#### 3. Capacity-based preprocessing

An internal assignment is fixed to zero whenever its task duration exceeds the chosen day’s capacity.

The original conditional update would add at least that duration to a nonnegative load, immediately violating the subsequent capacity check. Hence these assignments were already infeasible. In particular, no task can be performed internally on a zero-capacity day.

#### 4. Valid inequalities strengthen the relaxation

The reformulation adds three types of redundant inequalities:

- **Capacity conflicts:** Two tasks whose combined duration exceeds a day’s capacity cannot both be internal on that day. Similarly, at most one task requiring more than half the capacity can be internal there. Both follow directly from the daily capacity constraint and nonnegative resource use.
- **Cumulative precedence inequalities:** For every precedence arc and date threshold, the successor’s assignment up to that threshold is bounded by the predecessor’s assignment up to the threshold minus the required lag. With exactly one date per task, these inequalities follow from the original date precedence and provide a stronger fractional relaxation.
- **Aggregate outsourcing bound:** At least \(28-18=10\) hours must be outsourced. Summing daily internal-capacity constraints bounds internal work by 18 hours; every task is assigned either internally or externally, so the remaining work must be external.

### Solution correspondence and expected benefit

The accompanying mapping script reconstructs all **552 original variables declared without initializers**, including intermediate loads, ranks, lookups, and accumulated costs, from the retained day and outsourcing choices. Variables originally defined by declaration expressions can be recomputed by the original model.

The reformulation preserves task identities, dates, durations, capacities, precedence requirements, objective values, and minimization direction. Its expected advantage is a more direct linear formulation with fewer procedural dependencies and stronger relaxation constraints. No measured runtime improvement was established in the conversation.

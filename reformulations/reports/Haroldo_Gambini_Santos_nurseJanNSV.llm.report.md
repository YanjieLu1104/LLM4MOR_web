# Nurse Rostering Model: Structure and Reformulation

## 1. Real-world background

The model assigns nurses to shifts over a planning horizon. Each day–shift combination has an exact staffing requirement, and a nurse can work at most one shift per day. Nurses belong to contracts that specify preferred workload levels, lengths of working and resting periods, and weekend arrangements.

Rather than enforcing every contractual preference as a hard requirement, the model penalizes violations. It therefore seeks a roster that meets staffing requirements while balancing workload, rest, weekend consistency, and individual assignment preferences.

The source cites Santos, Toffolo, and Gomes, *Integer programming techniques for the nurse rostering problem*, **Annals of Operations Research**, 239, 225–251 (2016). No external instance data were supplied, so the number of nurses, shifts, days, and contracts is unknown.

## 2. Original mathematical formulation

### Variables

The original formulation is a mixed-integer linear minimization model with:

- **Assignment binaries** `x[n,s,d]`: whether nurse `n` works shift `s` on day `d`. There are \(|N||S||D|\) such variables.
- **Weekend binaries** `y[n,i]`: whether a nurse works during weekend `i`, including a dummy weekend zero fixed to zero.
- **Weekend-interval binaries** `z[n,il,ill]`: selected intervals of consecutive working weekends.
- **Daily interval binaries** `ww[n,d1,d2]` and `rw[n,d1,d2]`: selected working and resting intervals.
- **Violation variables**: bounded integer slacks and binary indicators for workload, weekend, night-shift, shift-consistency, and undesirable-pattern penalties.

The daily and weekend interval families grow quadratically with their respective horizon lengths. The declared `vnwec_Max` and `vnwec_Min` variables are not used in the active objective or constraints.

### Constraints

The main constraint groups enforce:

1. **Exact coverage:** assignments equal the required staffing for every day and shift.
2. **Daily exclusivity:** each nurse works at most one shift per day.
3. **Weekend identification:** a weekend is marked as working if and only if the nurse works on at least one of its days.
4. **Daily interval consistency:** working intervals cover precisely the working days, and resting intervals cover precisely the nonworking days. Additional inequalities restrict adjacent interval configurations.
5. **Weekend interval consistency:** selected weekend intervals cover precisely the working weekends, without overlap or adjacent separately selected working intervals.
6. **Soft-rule accounting:** violation variables accommodate workload deviations, excessive work within four-weekend windows, post-night-shift arrangements, inconsistent weekend shifts, night work before free weekends, and undesirable patterns.

Shift compatibility is **soft**, not hard: assignments outside a nurse’s compatible-shift set remain possible at a penalty.

### Objective

The objective minimizes assignment costs and weighted violations. Interval lengths determine penalties for excessively long or short working, resting, and working-weekend sequences. Other terms penalize incomplete weekends, alternative-skill assignments, and undesirable patterns.

Some coefficients, including pattern weights, may be negative under the original declarations. The reformulation preserves this possibility rather than assuming that every objective term is nonnegative.

## 3. Reformulation and justification

### Conditional daily interval-flow strengthening

A derived calendar indicator detects whether `D` is exactly `1..card(D)`. Only in that case, two **alternating-interval flow equalities** replace the original same-type adjacency inequalities:

- Working intervals ending on day \(d\) equal resting intervals starting on day \(d+1\).
- Resting intervals ending on day \(d\) equal working intervals starting on day \(d+1\).

**Why valid:** The original `workWindX` and `restWindX` equations, binary interval variables, and daily exclusivity imply that exactly one working or resting interval covers each day. The original `joinWW` and `joinRW` inequalities prohibit ending one interval and immediately starting another of the same type. Consequently, whenever an interval ends before the horizon ends, an interval of the opposite type must begin the next day.

Conversely, the new equalities and daily coverage equations imply the original same-type adjacency inequalities: the relevant ending and starting intervals cannot together exceed the unit interval coverage on the next day.

These equalities strengthen fractional solutions without excluding original integer rosters. Other daily adjacency inequalities remain unchanged.

### Removal of redundant daily partition equations

For the detected consecutive calendar, `windowsDay` is omitted.

**Why valid:** Adding the working-interval and resting-interval linking equations gives total interval coverage equal to one on each day. On this calendar, their interval index sets coincide with those in `windowsDay`.

For other day sets, the original daily constraints are retained. The calendar test therefore introduces no new assumption about external data.

### Weekend endpoint inequalities

The original weekend adjacency inequalities are replaced by inequalities requiring:

- Any interval starting at weekend \(i>1\) to follow a nonworking weekend.
- Any interval ending before the final weekend to precede a nonworking weekend.

**Why valid:** In an original integer solution, the weekend linking equations prohibit overlapping selected intervals. If a selected interval starts immediately after a working weekend, the preceding weekend must belong to another interval ending there; the original adjacency inequality forbids this. The endpoint argument is symmetric.

Conversely, the new endpoint inequalities imply the original adjacency inequalities because interval endings and starts are bounded by the corresponding weekend coverage variables. They are stronger for fractional solutions.

The separate `selectWeekendWindow` inequalities are also removed: `weekendWindowZAndX` equates their left-hand sides to `y[n,i]`, whose binary upper bound is already one.

## 4. Preservation and expected effect

All original decision-variable families, bounds, objective terms, and external data declarations are retained. Solution mapping is therefore the identity, with no reconstruction required.

The techniques used are **data-derived conditional reformulation, interval-flow strengthening, valid endpoint inequalities, and redundancy elimination**. Their purpose is to tighten the LP relaxation and reduce redundant rows. Actual runtime improvements remain instance-dependent; no execution-based validation or computational benchmark was performed.

## Problem background

The model appears to describe **instruction selection and block layout in a compiler**. A function contains operations, data values, and control-flow blocks. Candidate *matches* represent target-machine instruction patterns, each covering operations, defining and using data, and potentially spanning or consuming blocks.

The optimization chooses instruction patterns, assigns them to blocks, assigns data locations, and orders the blocks. Definition placement must respect control-flow dominance: a datum must be defined in a block that dominates the blocks where it is used, except for explicitly exempted patterns such as generic phi patterns.

The objective estimates execution cost using instruction latency multiplied by block execution frequency. Although code-size data are supplied, they are not used in this objective.

## Original model

Let \(M\), \(D\), and \(B\) denote the numbers of candidate matches, data values, and real blocks.

### Variables

The original model declares:

- \(M\) Boolean variables `sel`, indicating selected matches.
- \(D\) integer variables `def`, specifying each datum’s defining block.
- \(D\) integer variables `loc`, specifying data locations, including a distinguished null location.
- \(M\) integer variables `place`, specifying match placements, including a null block for unselected matches.
- \(B+1\) integer variables `succ`, describing a circuit through the real blocks and the null block.
- One bounded integer variable `objective`.

Thus, it has \(M\) Boolean variables and \(2D+M+B+2\) integer variables before flattening.

### Constraints

The main constraint families enforce:

1. **Exact coverage:** every operation is covered, and every datum is defined, by exactly one selected non-dominated match.
2. **Selection and placement:** a match is selected exactly when its placement is not the null block. Entry-block and parameterized constraints further restrict placement.
3. **Definition placement:** a selected match defines its data in its placement block, or in its specified spanned blocks.
4. **Consumed-block exclusion:** no match may be placed in a block consumed by a selected match.
5. **Definition dominance:** the defining block of a used datum must dominate the consuming match’s placement, where required.
6. **Block ordering:** `succ` forms a circuit, with the null block’s successor fixed to the function entry block. Cutting the circuit at that arc yields the intended linear layout.
7. **Location compatibility:** conditional equalities, location intervals, function-level intervals, and fixed null locations for state data.
8. **Additional restrictions:** conflict inequalities, the original location-value restriction, and preprocessing that disables matches classified as dominated.

Constraint counts depend on the externally supplied sets and arrays and cannot be given numerically from the source alone.

### Objective

The model minimizes

\[
\sum_{m\notin\mathrm{Dominated}}
\mathrm{latencyOfMatch}[m]\,
\mathrm{execFrequencyOfBlocksPlusNull}[\mathrm{place}[m]].
\]

The null block has frequency zero, so unselected matches contribute zero. The reformulation preserves the original objective bounds as well as this expression’s value and minimization direction.

## Reformulation and its justification

### Binary assignment formulation

The reformulation adds binary indicators for:

- each match being placed in each real or null block;
- each datum being defined in each real block.

Exactly-one constraints select one block per match or datum. Weighted sums channel these indicators to the retained `place` and `def` variables. Selection is equated to the sum of a match’s real-block placement indicators.

This is an exact representation: each original integer assignment determines a unique indicator vector, and each feasible exactly-one vector reconstructs the corresponding original integer value.

The indicators allow the objective to become a linear weighted sum with constant coefficients, avoiding variable-indexed frequency lookup.

### Static placement preprocessing

For each match, the reformulation computes an allowed placement set by intersecting restrictions already present in the original model:

- disabled matches must occupy the null block;
- applicable entry-block restrictions permit only the specified block or null;
- `inBlock` and `inBlockSucc` rows likewise permit only their specified block or null.

Indicators outside this set are fixed to zero. This does not introduce a new placement assumption: it combines existing restrictions before solving, including contradictory restrictions that leave only the null block available.

### Linear definition and dominance constraints

For a selected match without spanned blocks, each real-block placement indicator is bounded by the corresponding definition indicator for every datum it defines. Thus, selecting placement block \(b\) forces the datum’s definition to \(b\).

For a match with spanned blocks, selection requires the datum’s definition indicator to lie within those blocks. This reproduces the original conditional set membership.

Definition-dominance tables are replaced by inequalities of the form

\[
x_{m,b}\leq
\sum_{d\in\mathrm{Dom}(b)} y_{e,d}.
\]

Here \(x_{m,b}\) indicates placement of match \(m\) in block \(b\), and \(y_{e,d}\) indicates definition of datum \(e\) in block \(d\). Because definition indicators sum to one, this inequality enforces exactly the required dominance relation whenever that placement is selected. No null-block inequality is needed: the original null-block dominance set contains every valid real definition block.

### Shared consumed-block indicators

The original consumption constraints enumerate consuming matches, other matches, and consumed blocks. The reformulation introduces one indicator per block, equal to the logical OR of selections of matches consuming that block.

Each placement indicator is then incompatible with the corresponding consumption indicator. This is equivalent to the original family:

- selecting a consuming match activates the block indicator and forbids every placement there;
- if no consuming match is selected, the indicator is zero and imposes no exclusion.

Consumed values outside the placement domain need no indicator, since an original placement cannot equal them. The transformation reduces repeated match-pair constraints, although its performance benefit depends on instance structure.

### Removal of an implied block-support constraint

The original model additionally requires every datum’s definition block to be supported by a selected match placed in, or spanning, that block.

This follows from two retained constraint families:

1. Exact datum coverage provides a selected non-dominated match defining the datum.
2. Its definition-placement constraint places that datum either in the match’s placement block or in one of its spanned blocks.

That defining match is therefore already a witness for the support requirement. Removing the separate existential constraint preserves feasibility.

### Preserved preprocessing and solution interface

The original match-dominance test and `Dominated` assignment are retained unchanged, rather than extended using additional assumptions. The original conflict constraints, location-value restriction, circuit constraint, and objective domain are also preserved.

All original independent variables remain available. The mapping script copies their values, excludes reformulation-specific auxiliaries, and obtains the original objective from its emitted value or the shared objective field.

Overall, the changes aim to give **HiGHS a more explicit linear mixed-integer formulation**, with reusable binary assignments and fewer repeated logical constraints. No measured speedup is established by the conversation; the additional indicator arrays create a size-versus-strength trade-off that requires instance-level benchmarking.

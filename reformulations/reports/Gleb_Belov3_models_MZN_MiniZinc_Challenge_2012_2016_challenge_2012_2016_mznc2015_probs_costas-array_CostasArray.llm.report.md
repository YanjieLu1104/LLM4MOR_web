## Problem background

The model constructs a **Costas array of order \(n\)**: a permutation of \(1,\ldots,n\) whose displacement vectors between pairs of points are all distinct. Representing the permutation as points \((j,\texttt{costas}[j])\), each column and each row contains exactly one point.

For any fixed horizontal separation, all vertical displacements must differ. Such patterns are associated with radar and sonar waveform design, where distinct displacements help distinguish time and frequency shifts. The supplied model captures the combinatorial construction rather than a specific physical application.

## Original formulation

The external parameter `n` specifies the array order. For \(n\ge1\), the model declares \(n+n^2\) integer variables:

- `costas[1..n]`, with values in \(1,\ldots,n\), represents the permutation.
- `differences[1..n,1..n]`, with values in \(1-n,\ldots,n-1\), represents a triangular difference table within a square array.

The constraints are:

1. **Permutation:** all `costas` entries are distinct.
2. **Difference definitions:** for \(i<j\),
   \[
   \texttt{differences}[i,j]
   =\texttt{costas}[j]-\texttt{costas}[j-i].
   \]
   Entries with \(i\ge j\) are fixed to zero.
3. **Costas property:** within each active difference row \(i\), all entries with \(j>i\) are distinct.
4. **Reflection symmetry restriction:** when \(n>1\), the model requires `costas[1] < costas[n]`. This original restriction is retained.
5. **Redundant constraints:** active differences are nonzero, and selected groups of four difference entries satisfy parallelogram identities.

The solve item requests **satisfaction**, not optimization. There is no numerical objective.

## Reformulation and justification

The reformulation replaces all-different constraints with **binary assignment formulations** targeted at the HiGHS mixed-integer backend. It retains both original integer arrays, their domains, and their defining meanings.

### Permutation assignment formulation

A binary variable records whether position \(j\) receives value \(v\). Each position selects exactly one value, each value is selected exactly once, and a weighted-sum equation links these choices to `costas[j]`.

This is equivalent to the original permutation constraint: \(n\) distinct integer variables drawn from the \(n\)-element set \(1,\ldots,n\) must use every value exactly once. Conversely, the binary assignment constraints guarantee precisely that property. The assignment formulation supplies a strong linear relaxation for this part of the model.

### Nonzero difference assignment formulation

For each active difference entry, binary variables select exactly one value from
\[
\{1-n,\ldots,-1,1,\ldots,n-1\}.
\]
Within each difference row, each candidate value may be selected at most once. Weighted-sum equations connect the selections to the retained `differences` variables.

Excluding zero is valid because an active difference subtracts two permutation entries at distinct positions. The original all-different constraint on `costas` therefore makes those entries unequal. The at-most-once constraints enforce exactly the original row-wise distinctness requirement.

This is problem-specific **domain tightening combined with a value-assignment reformulation**, not an additional assumption about the instance. It replaces disequality handling with explicit linear assignment and packing constraints.

### Removal of implied equations

The explicit nonzero constraints are unnecessary once active difference values are selected only from nonzero candidates.

The redundant parallelogram equations are also omitted. Substituting the retained difference definitions into either side of
\[
d_{k-2,l-1}+d_{k,l}
=
d_{k-1,l-1}+d_{k-1,l}
\]
gives the same expression:
\[
c_{l-1}+c_l-c_{l-k+1}-c_{l-k}.
\]
Thus, these equations cannot exclude any solution already satisfying the difference definitions. Their removal reduces explicit constraint generation without changing feasibility.

## Interface and computational implications

The external parameter `n`, both original decision arrays, the zero-filled inactive triangle, and the original symmetry restriction are preserved. The mapping script returns only `costas` and `differences` from the solver solution, preserving their encoded index sets.

For \(n\ge1\), the reformulation adds \(n^2+n(n-1)^2\) binary variables before presolve. It trades a larger formulation for explicit assignment structure and useful LP relaxations. No instance-specific preprocessing or additional symmetry breaking is applied. Faster solving is the intended benefit, but no runtime improvement has been established by the supplied conversation.

# AES Chosen-Key Differential Cryptanalysis: Reformulation Report

## Background and interpretation

The model searches for activity patterns in **chosen-key differential cryptanalysis of AES**. This setting studies how differences between related encryption keys and plaintexts propagate through the cipher. Such patterns help assess resistance to differential attacks.

Rather than representing complete byte values, the model uses binary indicators: zero denotes an inactive byte difference, and one denotes an active difference. Constraints describe propagation through AddRoundKey, ShiftRows, MixColumns, and the key schedule. Additional key-component and equality variables capture relationships that an activity-only model would otherwise miss.

The source attributes this formulation to David Gerault, Marine Minier, and Christine Solnon, *Constraint Programming Models for Chosen Key Differential Cryptanalysis*, CP 2016. It is an abstraction of differential behavior, not an implementation of AES encryption or, by itself, a complete attack.

## Original model structure

### Inputs and variables

The external inputs are the number of rounds `n`, key length `KEY_BITS`, and prescribed activity total `objective`. The block size is fixed at 128 bits, giving four byte-columns per state.

The decision variables are:

| Variables | Meaning |
|---|---|
| `deltaX`, `deltaSR`, `deltaY` | Binary byte activity after AddRoundKey, after ShiftRows, and before the following AddRoundKey |
| `deltaK` | Binary round-key byte activity |
| `Kcomp` | Binary key-component indicators used to track key-schedule dependencies |
| `eqK` | Binary indicators of modeled equality between key bytes in the same byte row |
| `colX`, `colSRX`, `colK` | Integer column activity counts in `0..4` |

For positive round counts and well-defined derived dimensions, the declarations contain \(16(n-1)\) `deltaY` variables, \(16n\) variables in each of `deltaX`, `deltaSR`, and `deltaK`, \(16n\,NBK\) key-component variables, \(64n^2\) equality variables, and \(12n\) column-count variables. These are source-level counts, before compiler elimination or aliasing.

### Constraints

The main constraint groups are:

- **Column counts:** sums of the four corresponding byte-activity indicators.
- **AddRoundKey:** three participating activity indicators may not sum to one. This reflects that two inactive byte differences cannot produce one active difference.
- **ShiftRows:** a fixed permutation of byte positions.
- **MixColumns:** the combined input and output column activity belongs to \(\{0,5,6,7,8\}\), expressing the branch-number-five property.
- **Key schedule:** initialization and propagation of component indicators, activity XOR relations, and links to key-byte equality indicators.
- **Equality relationships:** symmetry, compatibility with activity, equality forced by identical component vectors, equality of two inactive bytes, and transitivity-like restrictions.
- **Pairwise MixColumns strengthening:** detected differences between two columns restrict the number of byte positions that can be known equal.

### Objective and search

Despite its name and comments, `objective` is **a fixed input parameter**, not a decision variable being minimized. The model requires

\[
\sum_{r,j} colSRX[r,j]
+
\sum_{\substack{0\le J<BCn\\J\bmod KC=KC-1}}
colK[J\operatorname{div}BC,J\bmod BC]
=
objective
\]

and uses `solve satisfy`.

Thus, each invocation tests feasibility at a prescribed activity total. The original model also supplies a multi-stage finite-domain search annotation.

## Reformulation and validity

The reformulation preserves all original top-level decision variables, their index domains, the external data interface, and the exact activity target. It primarily replaces logical and nonlinear expressions with mixed-integer linear formulations suited to HiGHS.

### 1. Linear activity XOR constraints

The original relation for binary variables is
\[
a+b+c\ne1.
\]

It is replaced by
\[
a\le b+c,\qquad b\le a+c,\qquad c\le a+b.
\]

Each inequality excludes the assignment in which its left-hand variable is the only active one. All assignments with zero, two, or three active variables satisfy the inequalities. Therefore, this replacement is exact.

### 2. Linearization of component products and binary XOR

The key schedule contains products of binary component and activity variables. Each product \(g=uv\) is represented by
\[
g\le u,\qquad g\le v,\qquad g\ge u+v-1,
\]
with binary \(g\). These constraints force \(g=1\) exactly when both factors are one.

The inequality between the two resulting binary products is represented as binary XOR:
\[
c\ge a-b,\quad c\ge b-a,\quad
c\le a+b,\quad c\le2-a-b.
\]

Together, these formulations reproduce the original component update without multiplication or reified disequality.

### 3. Linear exclusion of singleton component activity

For each applicable key-schedule position, the original model requires the sum \(S\) of its component indicators and key-activity indicator to differ from one.

The replacement imposes \(2v\le S\) for every binary term \(v\) in that sum. If \(S=1\), the unique active term violates its inequality. If \(S=0\) or \(S\ge2\), every inequality holds. This is therefore another exact replacement of a disequality.

### 4. Linear MixColumns activity disjunction

The original allowed totals are \(\{0,5,6,7,8\}\). Introducing a binary auxiliary \(z\), the reformulation uses
\[
5z\le S\le8z.
\]

When \(z=0\), the total is zero; when \(z=1\), its integer value lies between five and eight. This precisely represents the original set membership.

### 5. Equality propagation and removal of repeated triple constraints

The original equality constraints are reformulated as follows:

- Equality implies matching activity through linear difference bounds.
- Two inactive key bytes force equality through \(a+b+e\ge1\).
- Identical component vectors force equality using auxiliary mismatch witnesses. A witness can be one only where two component bits differ; requiring a witness whenever \(e=0\) prevents identical vectors from being marked unequal.

For distinct key positions, the original transitivity restriction excludes a sum of two among three binary equality indicators. Three triangle inequalities exclude exactly those assignments. Because symmetry is retained, these inequalities need be generated only once per unordered triple.

Repeated-index cases are handled separately: an off-diagonal equality implies both corresponding diagonal entries. This follows directly from the original restriction \(d+2e\ne2\), which is equivalent to \(e\le d\). **Diagonal entries are not universally fixed to one**, since the original constraints do not justify that assumption.

### 6. Linear pairwise MixColumns strengthening

The original strengthening has the form
\[
DIFF\_SX\ \Longrightarrow\ EQ\_SRX+EQ\_Y\le3.
\]

The reformulation introduces binary witnesses with lower bounds that force them on whenever the corresponding original difference or known-equality condition holds. The final bound is
\[
E\le8-5d.
\]

If a difference is detected, \(d=1\), so at most three equalities are permitted. Otherwise, choosing \(d=0\) leaves the natural upper bound of eight.

Only one-sided witness constraints are needed: every original feasible assignment can extend the witnesses to their exact logical values, while every reformulated feasible assignment satisfies the original implication because the witnesses cannot understate a required difference or equality. This preserves feasibility after projecting out the auxiliaries.

## Interface and implementation effects

The formulation directly indexes the original arrays, avoiding the inconsistent formal array dimensions in some original predicates. It also removes the finite-domain search annotation, leaving search to HiGHS; this does not alter the feasible set.

No instance-specific preprocessing, hard-coded data, or additional cryptanalytic assumptions were introduced. The supplied mapping script is an identity mapping over the original decision variables and reports missing solution fields rather than inventing values.

The intended benefit is fewer reified expressions, explicit linear relaxations, and less duplicated equality-transitivity work. These changes are motivated by the target MIP backend; no measured speedup is established by the conversation.

## Problem background

The model appears to describe a **grid-based layout problem for rectangular entities**, such as blocks in a diagram or components in a spatial arrangement. Each entity has a prescribed size along the row and column axes. Its integer coordinates must place it within the grid, with boundary clearance determined by `padding`.

Pairs selected by the ordinal ordering must be separated along at least one axis. Edges in `E` identify connected entities whose Manhattan distances should be small. A secondary objective contribution encourages entities to lie near the grid center.

The supplied center offsets, `e_centerAxis`, determine the points used to measure distances. The model does not require these offsets to equal half the entity dimensions, so that geometric interpretation is not assumed in the reformulation.

## Original mathematical formulation

Let \(n=|V|\), \(m=|E|\), and \(p=|V2\_vw|\), where
\[
V2\_vw=\{(v,w):\operatorname{ordinal}[v]<\operatorname{ordinal}[w]\}.
\]
No numerical instance data were supplied, and ordinal values are not required to be distinct; therefore, \(p\) need not equal \(\binom n2\).

### Variables

The model contains:

- **\(2n\) integer position variables** `x`, one per entity and axis.
- **\(4p\) binary separation variables** `zV`, selecting one of four relative-position alternatives for each ordered pair.
- **\(2n\) continuous center-distance variables** `center_dist`.
- **\(2m\) nonnegative continuous edge-distance variables** `dist`, with supplied upper bounds.

### Constraints

The main constraints are:

- **Grid bounds:** each coordinate satisfies
  \[
  \frac{padding}{2}\le x[a,v]\le
  axis\_size[a]-1-dim[a,v]-\frac{padding}{2}.
  \]
- **Separation selection:** exactly one of the four separation binaries is active for each pair in `V2_vw`.
- **Conditional separation:** big-M inequalities enforce the appropriate entity dimension plus padding when a direction is selected.
- **Absolute-distance inequalities:** two inequalities per axis and entity or edge provide lower bounds on distances to the grid center and between connected entities.
- **Additional supplied inequalities:** aggregate edge-distance bounds, an aggregate center-distance bound, axis-specific distance bounds linked to separation binaries, and triangle inequalities excluding certain cyclic direction selections.

All supplied inequalities were retained. In particular, distance variables can exceed their absolute-coordinate differences when required by the additional inequalities; they were not replaced by exact absolute-value expressions.

The original edge-based constraints reference separation variables for the ordinal-ordered endpoints. Consequently, an instance must provide an existing pair in `V2_vw` for every such reference for the original model to instantiate.

### Objective

The model minimizes
\[
(axis\_size['r']+axis\_size['c'])
\sum_{a,(v,w)\in E}dist[a,v,w]
+\sum_{a,v\in V}center\_dist[a,v].
\]

This is a **weighted sum**, not an explicitly lexicographic objective: it penalizes edge distances more heavily while also encouraging central placement.

## Reformulation and validity

The reformulation retains all original decision variables, objective coefficients, external data declarations, and constraint families. Its main changes strengthen the continuous relaxation and expose implications of the existing coordinate bounds.

### 1. Integer-bound preprocessing

Define
\[
L=\left\lceil\frac{padding}{2}\right\rceil,
\qquad
U_{a,v}=axis\_size[a]-1-dim[a,v]-L.
\]

The position bounds are replaced by \(L\le x[a,v]\le U_{a,v}\).

**Why valid:** `x` is integer, so its original lower bound can be rounded upward and its upper bound downward. Since grid sizes and dimensions are integers,
\[
\left\lfloor axis\_size[a]-1-dim[a,v]-padding/2\right\rfloor
=U_{a,v}.
\]
Thus, the feasible integer positions are unchanged.

### 2. Bound-derived big-M tightening

For the separation inequality
\[
x[a,w]-x[a,v]\ge padding+dim[a,v]-M(1-z),
\]
the reformulation uses
\[
M_a=axis\_size[a]-1+padding-2L.
\]

**Why valid:** when \(z=0\), the coordinate bounds imply
\[
x[a,w]-x[a,v]\ge L-U_{a,v}.
\]
Choosing
\[
M_a=padding+dim[a,v]+U_{a,v}-L
\]
makes the inactive inequality exactly redundant with these bounds. Substitution gives the stated coefficient. The reverse-direction inequality follows by exchanging \(v\) and \(w\). When \(z=1\), the original separation requirement remains unchanged.

This is **bound-based big-M tightening**. It reduces the original oversized coefficients and generally strengthens the relaxation and improves numerical conditioning.

### 3. Fixing impossible separation directions

Both separation binaries on axis \(a\) are fixed to zero when
\[
dim[a,v]+dim[a,w]+padding
>axis\_size[a]-1-2L.
\]

**Why valid:** selecting the direction placing \(w\) after \(v\) requires
\[
x[a,w]-x[a,v]\ge padding+dim[a,v].
\]
But the largest possible difference allowed by the coordinate bounds is \(U_{a,w}-L\). Comparing these expressions yields the stated necessary fitting condition. The reverse direction gives the same condition.

This is **domain propagation and binary-variable fixing**. It rules out only directions already impossible under the original constraints. If neither axis permits separation, the retained exactly-one constraint correctly makes the pair infeasible.

### 4. Explicit nonnegativity of center distances

The reformulated `center_dist` variables have lower bound zero.

**Why valid:** the two original inequalities require each variable to be at least both \(t\) and \(-t\), where
\[
t=x[a,v]+e\_centerAxis[a,v]-center\_axis[a].
\]
Hence it is already at least \(|t|\ge0\). The explicit bound merely exposes this implication.

### 5. Equivalent triangle-constraint indexing

Triangle constraints are generated directly from pairs in `V2_vw`, rather than filtering all vertex triples.

**Why valid:** the generated triples satisfy exactly the original two ordinal-order conditions. Transitivity of strict ordering also guarantees that the referenced pair \((a,c)\) exists. This changes enumeration, not the inequalities, and may reduce model-generation overhead.

## Expected effect and solution correspondence

The improvements target tighter relaxations, earlier elimination of impossible binary choices, and more efficient constraint generation. No original variable or constraint family was removed, and no new problem-specific cutting-plane family was added.

The solution mapping is the identity: all original variable names, indices, and meanings remain unchanged. Feasible integer solutions and objective values are preserved. Actual runtime improvements depend on the supplied instance and solver; no computational speedup was measured.

# Linear-to-Program Synthesis: Model and Reformulation

## Background and purpose

The model synthesizes a short arithmetic program that computes a specified linear combination of input values using only **binary addition** and **unary negation**. This represents a restricted compiler-optimization or program-synthesis problem: multiplications by integer coefficients must be implemented through repeated additions and sign changes.

The candidate program is checked against supplied input–output examples. For example \(s\), the required output is
\[
x_O[s]=\sum_{p\in P}\mathrm{coef}[p]\,RP[s,p].
\]
Agreement with these examples does not, by itself, establish correctness on every possible input. The original model is intended for a counterexample-guided synthesis loop, in which a separate verification process can supply further examples.

## Original formulation

### Data and decision variables

The data specify \(M\) inputs, \(N\) available operation components, the addition-component count `Np`, coefficients, and `Smax` examples. Inputs occupy positions \(0,\ldots,M-1\); operation positions occupy \(M,\ldots,M+N-1\).

The original decision variables are:

- `line_o[r]`: the program position assigned to component \(r\).
- `line_i[j]`: the input or operation position referenced by operand slot \(j\).
- `objective`: the position returned by the program.
- `x_o[s,r]`: component \(r\)'s value on example \(s\).
- `x_i[s,j]`: operand slot \(j\)'s value on example \(s\).

There are
\[
|R|+|I|+1+|S|(|R|+|I|)
\]
original scalar integer decision variables. Numerical counts depend on the external instance.

### Constraints

The constraints establish both program structure and example evaluation:

1. **Unique component positions.** An all-different constraint on `line_o` makes the components a permutation of the available operation positions.
2. **Acyclic references.** Each operand must refer to a position strictly earlier than its owning component.
3. **Symmetry restrictions.** Addition components appear in index order, as do negation components. Addition operands are ordered because addition is commutative.
4. **Arithmetic evaluation.** Each component adds its operands or negates its operand on every example.
5. **Value routing.** An operand referencing an input receives the corresponding example value; an operand referencing a component receives that component’s output.
6. **Return-value agreement.** The component at `objective` must produce the required output on every example.
7. **Unused suffix restriction.** Components positioned after the return position must reference position zero, as specified by the original example-indexed constraints.

All example-evaluation variables retain the original bounded integer domain.

### Objective

The model **minimizes the return position**, not the number of declared components. Since operation positions are contiguous and fully occupied, minimizing this position minimizes the program prefix through the returned operation. Components after that position remain part of the formulation.

## Reformulation and validity

The reformulation retains every original decision variable, its domain, the external data interface, and the minimization objective. Its main purpose is to expose discrete assignments and shared routing explicitly for the HiGHS mixed-integer backend.

### Binary assignment formulation for component positions

The all-different constraint is replaced by a binary component-to-position matrix. Every component selects exactly one position, every position receives exactly one component, and `line_o` equals the selected position.

This is equivalent because the original model has exactly \(|R|\) components, each with the same \(|R|\)-element position domain. All-different therefore already requires a bijection; the binary matrix represents that same bijection explicitly.

### Shared operand-routing selectors

Each operand receives a one-hot choice among original inputs and operation components. These selectors are shared across all examples because the program’s wiring does not depend on the example.

For an input selection, linear weighted sums fix both the referenced input position and its example value. For a component selection, implications equate the referenced position and example value with that component’s position and output.

This preserves the original routing semantics: every operation position has exactly one component, so each valid operand position identifies exactly one source. Conversely, every selected source fixes the operand to that source’s position and value. The linear bounds used when a component is selected are the existing position and value bounds, rather than additional restrictions.

### Preprocessing of impossible component references

Routing selectors are fixed to false when an operand would reference its own component or a later-indexed component of the same operator type.

This follows directly from two original restrictions:

- same-type components are positioned in strictly increasing index order;
- an operand’s source position must be strictly earlier than its owner’s position.

A same-type component with an equal or larger index cannot satisfy that strict precedence condition. Removing these choices therefore removes no original feasible program. Cross-type references are not eliminated by this rule.

### Explicit return-component selection

A one-hot selector identifies the returned component. Its position is equated to `objective`, and its values must match all required example outputs.

This is equivalent to the original return implications because the component positions form a permutation and `objective` belongs to that position domain. Exactly one component occupies the return position.

### Removal of repeated constraints

The restriction on operand references after the return position is posted once per operand rather than once per example. It is guarded by `card(S) > 0`, preserving the original quantifier behavior: when there are examples, the repetitions are identical; with no examples, that original constraint family contributes no restrictions.

### Solution mapping and expected effect

The supplied mapping script copies only the five original decision-variable entities and preserves their encoded array index domains. No reconstruction or renumbering is needed; auxiliary binary variables are excluded.

The reformulation trades additional explicit binary variables for assignment constraints and routing choices shared across examples. This is intended to improve the MIP representation and avoid repeated implicit selection machinery. No measured runtime improvement was established in the conversation.

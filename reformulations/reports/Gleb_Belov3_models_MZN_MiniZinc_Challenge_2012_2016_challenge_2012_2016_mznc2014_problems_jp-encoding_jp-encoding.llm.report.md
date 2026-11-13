# Japanese Character-Encoding Recovery

## Background

The model labels a byte stream that may contain text written in different Japanese character encodings: EUC-JP, Shift-JIS, and UTF-8. Mixing these encodings can make text unreadable because the same byte may have different meanings under different encodings.

For each byte, the model identifies its encoding and its position within a character. ASCII bytes and unrecognized bytes receive separate labels. The goal is to find a valid interpretation with a low statistical cost, while strongly penalizing bytes that cannot be assigned a recognized interpretation.

The external instance consists of the stream length, `len`, and the integer array `stream`. Three fixed score tables encode approximate negative log-probabilities of byte occurrence.

## Original Model

### Variables

For a stream of length \(n=\texttt{len}\), the model declares:

- **`byte_status`**: \(n\) integer variables with 16 possible labels, identifying ASCII, unknown bytes, or positions within supported multibyte characters.
- **`encoding`**: \(n\) integer variables with five labels: ASCII, EUC-JP, Shift-JIS, UTF-8, and unknown.
- **`char_start`**: \(n\) binary integer variables indicating whether a character starts at each byte.
- **`n_unknown`**: one integer variable counting unknown bytes.
- **`objective`**: one defined integer variable representing the total cost.

Thus, there are \(3n+1\) independent scalar decision variables, plus the defined objective.

### Constraints

The constraints have four main roles:

1. **Encoding consistency.** Each byte-status label must belong to the selected encoding. Although some constraints are written as one-way implications, the encoding domain and disjoint status groups collectively determine the encoding uniquely from the byte status.
2. **Byte-pattern validity.** Character-start labels require the corresponding byte ranges. Supported characters occupy one to four bytes.
3. **Character continuity.** Equivalences link continuation labels to preceding start labels. For example, a two-byte UTF-8 continuation occurs exactly when the previous byte starts a two-byte UTF-8 character.
4. **Derived labels and counts.** Start statuses force `char_start = 1`, continuation statuses force it to zero, and a counting constraint determines `n_unknown`.

These rules describe a partition of the stream into nonoverlapping, complete characters, with unknown bytes acting as single-byte fallback characters.

### Objective

The model minimizes
\[
\sum_{i=1}^{n} c(\texttt{encoding}[i],\texttt{stream}[i])
+1000\,\texttt{n\_unknown}.
\]

The cost \(c\) comes from the appropriate encoding-specific score table. ASCII contributes zero; unknown bytes incur the separate penalty. There is no penalty for switching encodings between characters.

## Reformulation

### Candidate-character preprocessing

The reformulation introduces eight candidate character types at each possible start position:

- ASCII;
- two-byte EUC-JP;
- one-byte and two-byte Shift-JIS;
- two-, three-, and four-byte UTF-8;
- one-byte unknown.

Each candidate has a fixed length, encoding, and starting byte-status label. Its validity is evaluated directly from the input stream. Candidates with an incompatible byte pattern or insufficient remaining bytes are fixed to zero.

This preprocessing is valid because the original character-start implications require precisely these byte patterns, while the continuation equivalences require the complete associated sequence of statuses. No feasible character interpretation is removed. The reformulation preserves the model’s particular encoding rules, including its permissive UTF-8 ranges, rather than substituting stricter modern validation rules.

### Binary interval exact cover

A binary variable selects each candidate character. Before preprocessing, this introduces \(8n\) binary variables.

For every byte position, one linear equation requires **exactly one selected candidate interval to cover it**. This replaces the reified start/continuation logic with an interval exact-cover formulation.

The equivalence follows in both directions:

- In an original feasible solution, every continuation status is linked to its corresponding start. Those starts therefore define complete character intervals. Since each byte has exactly one status, these intervals cannot overlap and must cover the stream.
- In an exact-cover solution, every selected interval supplies its prescribed start and continuation statuses. Exact coverage prevents overlap and gaps, so the reconstructed labels satisfy the original continuity requirements.

### Linear reconstruction and cost

The original variables are retained and connected to the candidate selections by linear equations:

- `byte_status` is the status prescribed by the unique covering character.
- `encoding` is that character’s encoding.
- `char_start` is the sum of candidates selected at the position.
- `n_unknown` is the number of selected unknown-byte candidates.

These equations preserve the original meanings because exact coverage selects precisely one contributor at each byte. The objective is rewritten as a linear sum of the same per-byte scores, plus the unchanged unknown-byte penalty. Its value and minimization direction are therefore preserved.

### Expected computational benefit

The formulation removes reified logical constraints and exposes a linear interval-cover structure to HiGHS. The core coverage matrix has consecutive ones in each column, a standard totally unimodular structure that gives the standalone interval-cover problem an integral linear relaxation. This is a stronger foundation than a generic linearization of the original implications.

No separate cutting planes, heuristic candidate pruning, or encoding-switch assumptions were added. The final repair supplied an identity mapping script that copies the four original independent variables and excludes reformulation-specific auxiliaries. External data and original variable-binding interfaces remain unchanged.

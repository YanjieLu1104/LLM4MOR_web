## Problem background

The model appears to represent **cyclic workforce scheduling**. A repeating planning horizon is divided into `n_periods` periods, with required staffing levels given by `worker_count`. Workers cover shifts of length `shift_periods`, with coverage wrapping around the end of the horizon.

The integer variable `w[t]` represents staffing coverage in period \(t\). The variable `f[t]` counts shifts using the model’s indexing convention: a shift indexed by \(t\) covers the preceding `shift_periods` periods cyclically. Thus, interpreting `f[t]` as a shift-end count is consistent with the coverage equations.

The objective minimizes total staffing coverage across the horizon—not directly the number of workers. For a positive fixed shift length, however, total coverage equals shift length times the number of shifts, so these minimization criteria are proportional.

## Original formulation

Let \(n=\texttt{n_periods}\), \(s=\texttt{shift_periods}\), and \(M=\max_t\texttt{worker_count}[t]\). The model declares **\(2n+1\) integer decision variables**:

- \(w_t\in[0,M]\): staffing coverage;
- \(f_t\in[0,M]\): shift counts;
- `objective` \(\in[0,nM]\): total coverage.

Its constraints comprise:

1. **Demand satisfaction:** \(w_t\geq\texttt{worker_count}[t]\) for each period.
2. **A minimum-cost circulation structure:** the network has \(n\) period nodes and \(2n\) arcs. Coverage arcs run from \(t\) to \(t+1\), carry flow \(w_t\), and have unit cost. Shift arcs run from \(t\) to \(t-s\), carry flow \(f_t\), and have zero cost. All node balances are zero.
3. **Explicit coverage equations:**
   \[
   w_t=\sum_{i=1}^{s}f_{(t+i)\bmod n}.
   \]
   When \(s>n\), this sum intentionally counts repeated cyclic visits. When \(s<0\), its index range is empty.
4. **The network cost equation:** `objective` equals \(\sum_t w_t\).

The solve item minimizes `objective`. The original model also supplies a sequential integer-search annotation.

## Reformulation and validity

### Replace the network global with linear equations

The network-flow global was replaced by its explicit conservation and cost equations:
\[
w_t+f_t=w_{t-1}+f_{t+s},
\qquad
\texttt{objective}=\sum_t w_t,
\]
where subscripts are cyclic.

This is an exact expansion of the original network: the outgoing flows at node \(t\) are \(w_t\) and \(f_t\), while its incoming flows are \(w_{t-1}\) and \(f_{t+s}\). Only coverage arcs have nonzero cost. The original variable bounds remain unchanged.

### Replace rolling coverage sums with one aggregate identity

For \(s\geq0\), define the original coverage expression
\[
C_t=\sum_{i=1}^{s}f_{t+i}.
\]
Consecutive expressions satisfy
\[
C_t-C_{t-1}=f_{t+s}-f_t.
\]
The retained conservation equations impose exactly the same difference on \(w\):
\[
w_t-w_{t-1}=f_{t+s}-f_t.
\]
Consequently, \(w_t-C_t\) is constant around the entire cycle.

Summing the original coverage expressions over all periods gives
\[
\sum_t C_t=s\sum_t f_t,
\]
because each cyclic offset visits every period once. The reformulation therefore imposes
\[
\texttt{objective}=s\sum_t f_t.
\]
Together with `objective` \(=\sum_t w_t\), this makes the sum of the constant differences zero. Hence every difference is zero, recovering every original coverage equation.

This argument also covers zero-length shifts and shifts longer than the horizon. For **negative shift lengths**, the reformulation instead imposes \(w_t=0\), exactly matching the original empty coverage sums, while retaining network conservation.

### Implementation and expected benefit

The techniques used are **explicit linearization of a network global** and **algebraic elimination of redundant rolling-sum equations**. No instance-specific preprocessing, additional cutting planes, or assumptions about staffing data were introduced.

The resulting formulation uses short conservation equations and an aggregate coverage identity rather than repeatedly expanding shift-length coverage sums. This may reduce model-generation work and matrix size, particularly for long shifts; an actual runtime improvement has not been established here. The solver-specific integer-search annotation was also removed so that HiGHS can use its native MIP search.

All original variables, bounds, external parameter names, and period indices are preserved. The supplied mapping script returns `w`, `f`, and `objective` unchanged, so no mathematical reconstruction is required.

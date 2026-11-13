# Orthogonal Pipe Routing with Support and Flexibility Requirements

## Real-world interpretation

The model represents routing a single industrial pipe between two fixed nozzle connections in a three-dimensional plant layout. The pipe is assembled from straight, axis-aligned legs joined by bends. Coordinates use a discretization of **200 mm per unit**.

Fixed boxes describe equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack support levels. The route must avoid obstacles with the specified pipe radius and safety clearance, while its intermediate nodes must lie in suitable support regions. Additional cubic-length constraints represent a flexibility requirement, apparently intended to ensure that the pipe can accommodate displacement or thermal expansion.

The supplied instance provides ten route nodes, including two fixed endpoints, and therefore nine potential legs. Unused trailing legs collapse to zero length. Although a parameter indicates a preference or requirement to traverse the rack, the corresponding constraint is commented out in the original model and is not enforced.

## Original formulation

### Variables

The original model contains **151 independent scalar integer variables before presolve**:

- **30 node coordinates**, including six fixed endpoint coordinates.
- **60 leg-envelope coordinates**, describing lower and upper corners of radius-expanded leg boxes.
- **30 coordinate-wise leg lengths**.
- **10 direction codes**, where zero denotes an unused leg and the other six values identify signed coordinate directions.
- **10 leg-existence flags** and **10 last-leg flags**.
- **One objective variable**.

The leg arrays include a tenth, non-leg entry fixed to zero. Defined arrays additionally represent obstacle separation, support membership, support costs, and sums of cubed lengths. These are expressions of other variables rather than additional independent decisions.

### Constraints

The main constraint groups are:

- **Route geometry:** Each existing leg follows exactly one coordinate axis. Consecutive existing legs use different axes, preventing straight continuation or immediate reversal.
- **Leg sequence:** Existing legs form a prefix, at least three legs exist, and exactly one is the last leg.
- **Nozzle connections:** The first and last existing legs have prescribed directions and nozzle-specific length bounds.
- **Obstacle clearance:** Radius-expanded leg boxes must be separated from obstacle boxes along at least one axis. Explicit exceptions permit connection to the endpoint modules.
- **Support membership:** Intermediate node positions must belong to at least one support zone. This requirement also applies to intermediate nodes associated with unused trailing legs, as in the original model.
- **Flexibility:** For each coordinate axis, a sum of cubed lengths in the other two axes must exceed a coefficient times every individual leg length in those axes.

The general formulation also contains inter-pipe clearance constraints, but these generate no restrictions for this single-pipe instance.

### Objective

The model minimizes scaled pipe-length, bend, and support costs. After the original integer scaling and `+1` adjustments, the costs are:

- **741 per unit of route length**;
- **7,401 per existing leg after the first**, representing bend cost;
- **51 per supported bend outside preferred rack levels**, or **1 on a preferred level**.

The reformulation preserves this objective exactly, including its scaling and minimization direction.

## Reformulation and justification

### 1. Exact linear representation of cubed lengths

Variable expressions of the form \(L^3\) were replaced by binary selections over admissible positive integer lengths. For each leg and axis,

\[
L=\sum_v v\,y_v,
\qquad
L^3=\sum_v v^3\,y_v.
\]

The selection sum equals the indicator that the leg uses that axis. Thus exactly one length is selected on the active axis, and no length is selected on an inactive axis.

This is exact because the original lengths are bounded integers, every active direction imposes the minimum leg length, and inactive dimensions have zero length. It replaces nonlinear variable powers with linear expressions that HiGHS can handle directly. The trade-off is additional binary variables.

### 2. Preprocessing of admissible lengths

Length selections are restricted using:

- Original leg-length upper bounds;
- The maximum possible endpoint difference implied by coordinate domains;
- Nozzle-specific upper bounds;
- The prescribed axis of the first and last possible legs.

These exclusions are valid because the original geometry and direction constraints force each coordinate-wise length to equal the absolute endpoint difference. A length exceeding either the coordinate-derived maximum or an applicable original upper bound cannot occur. Likewise, a prescribed nozzle direction excludes movement along the other axes.

### 3. Exact leg-envelope equalities

The original envelope inequalities and length equations were replaced by direct equalities. For endpoint coordinates \(x,x'\), radius \(r\), and coordinate-wise length \(L\),

\[
2b_{\min}=x+x'-L-2r,
\qquad
2b_{\max}=x+x'+L+2r.
\]

To see why this preserves the original envelope, its inequalities imply

\[
L=b_{\max}-b_{\min}-2r\ge |x'-x|.
\]

The original direction constraints give the reverse inequality on the active axis and force zero length on inactive axes. Hence \(L=|x'-x|\), leaving no envelope slack: the bounds must be \(\min(x,x')-r\) and \(\max(x,x')+r\). The new equalities express these same values directly.

### 4. Bound-based obstacle-check elimination

An obstacle–leg check is omitted only if the coordinate domains guarantee separation along at least one axis.

For example, if the obstacle’s upper face plus safety clearance is no greater than the smallest possible lower face of the leg envelope, that pair is separated for every feasible endpoint assignment. The analogous test applies on the opposite side. These are compile-time proofs of redundant constraints, not assumptions about the eventual route. All other obstacle checks and endpoint-module exceptions remain enforced.

### 5. Linearized support costs

Products involving leg existence and support status were rewritten as weighted Boolean conjunctions. This is exact because the existence flag, non-preferred-support flag, and zone-membership indicators are all binary. For binary values \(a,b\), their product equals the indicator of \(a\land b\).

The original support-membership definitions and the restriction encoded by the non-preferred-support flag remain unchanged.

### 6. Endpoint-displacement cuts

Additional lower bounds strengthen the formulation using fixed endpoint displacement. Total movement along an axis must be at least the absolute endpoint displacement.

A stronger bound applies when the displacement \(d\) satisfies \(0<d<m\), where \(m\) is the minimum positive leg length. Movement in only one sign cannot produce such a small nonzero displacement: any nonzero leg already contributes at least \(m\). Both signs must therefore occur. If their total movements are \(P\) and \(N\), then \(|P-N|=d\) and both are at least \(m\), giving

\[
P+N\ge 2m+d.
\]

For this instance, the X displacement is one unit and the minimum leg length is five, so total X movement is at least eleven units. The reformulation also explicitly requires at least one positive and one negative X leg.

## Solution interface and scope

All original independent variables retain their names and meanings. The mapping script returns only those variables, restores fixed endpoint coordinates from their original singleton domains when needed, and excludes reformulation auxiliaries. Original arrays defined by expressions need not be mapped.

The formulation is intended to improve compatibility with, and propagation in, a mixed-integer linear solver. No solve-time improvement or optimal solution was established in the conversation.

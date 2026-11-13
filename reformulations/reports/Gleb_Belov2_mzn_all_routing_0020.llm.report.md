# Pipe-Routing Model and Reformulation

## 1. Application background

The model represents the routing of a single industrial pipe through a three-dimensional installation containing equipment modules, existing pipe segments, and pipe racks. The pipe connects fixed endpoints at **(302, 54, 20)** and **(282, 54, 8)**. Coordinates are integer multiples of a **200 mm discretization unit**.

A route consists of axis-aligned segments. It must respect obstacle clearances, prescribed nozzle directions and lengths, and support-zone requirements. Equipment support zones, the main rack, and preferred rack levels provide different support options. The objective balances pipe length, changes of direction, and support costs.

Some features belong to a more general routing formulation but are inactive here: there is only one pipe, the rack-traversal requirement is commented out in the original model, and the flexibility coefficient is zero.

## 2. Original mathematical structure

### Variables

The original model declares **151 independent integer scalar entries**, before presolve:

| Variable group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional nodes; six endpoint coordinates are fixed |
| Lower and upper leg-box coordinates | 60 | Bounding boxes of pipe segments |
| Coordinate-wise leg lengths | 30 | Nonnegative segment lengths |
| Leg directions | 10 | Zero for an absent leg; six signed coordinate directions otherwise |
| Leg-existence and last-leg indicators | 20 | Binary integers describing the active route prefix |
| Objective | 1 | Total scaled routing cost |

The leg arrays have ten slots, but only nine connect consecutive nodes. The remaining slot is fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraint families are:

- **Segment geometry:** Each active segment changes exactly one coordinate. Its bounding box and length agree with its endpoints.
- **Route sequencing:** Active legs form a prefix, exactly one is marked last, and at least the first three legs exist. Absent legs have zero length, so trailing nodes coincide with the destination.
- **Nozzle requirements:** The first leg travels in negative X and has length between 2 and 15. The last active leg travels in negative Z and has the same length bounds.
- **Orthogonality:** Consecutive active legs use different coordinate axes, excluding both straight continuation and immediate reversal.
- **Obstacle avoidance:** A leg must be separated from each applicable obstacle along at least one axis. Specific exemptions allow connection to the source and destination modules. Importantly, the original model does not generally exempt absent legs from obstacle checks.
- **Support requirements:** Every intermediate node must belong to at least one support zone, including nodes associated with an unused trailing portion of the route.
- **Preferred-level accounting:** Preferred rack membership determines support cost. The declared domain of the nonpreferred indicator also prevents membership in more than one preferred level.
- **Flexibility:** The general formulation contains cubic-length expressions, but these evaluate to zero and impose no restriction in this instance because `dGCM_Cpp = 0`.

Inter-pipe separation generates no effective constraints because all nodes belong to the same pipe. The original model does not impose self-intersection avoidance between this pipe’s nonadjacent legs.

### Objective

The model **minimizes** scaled pipe-length, bend, and support costs. After the original integer division and “+1” adjustment, the coefficients are:

- **481** per unit of pipe length;
- **4,801** per active leg after the first;
- **51** per charged support outside preferred rack levels;
- **1** per charged support within a preferred level.

The reformulation preserves these coefficients and the minimization direction.

## 3. Reformulation and validity

### Linear signed-flow formulation

Each leg and coordinate receives positive- and negative-direction binary indicators and corresponding nonnegative lengths. Their sum equals leg existence, so an active leg selects exactly one signed axis. Coordinate displacement is expressed as positive length minus negative length.

This replaces the original direction-dependent implications with linear equations and binary-activated bounds. It is equivalent because the original bounding-box constraints imply that coordinate-wise length is at least the absolute endpoint displacement, while the direction constraints force equality on the selected axis and zero displacement elsewhere.

The leg-box endpoints are then linked by
\[
2L_{ik}=x_{ik}+x_{i+1,k}-\ell_{ik}-2r,
\qquad
U_{ik}=L_{ik}+\ell_{ik}+2r.
\]
Since \(\ell_{ik}=|x_{i+1,k}-x_{ik}|\), these equations give exactly the original minimum and maximum endpoint coordinates, expanded by the pipe radius. Direction-specific length bounds also use the maximum displacement permitted by the endpoint domains.

### Linearized support costs

Let \(e_i\) denote leg existence, \(b_{iz}\) preferred-level membership, \(c_0\) default support cost, and \(c_z\) preferred-level cost. Substituting the original definition of the nonpreferred indicator gives
\[
e_i\left[c_0\left(1-\sum_z b_{iz}\right)+\sum_z c_zb_{iz}\right]
=
c_0e_i+\sum_z(c_z-c_0)(e_i\land b_{iz}).
\]

The reformulation uses the right-hand expression. This is an exact Boolean-product linearization, not an approximation. It retains exact membership tests and the original nonpreferred-indicator domain, including its restriction on overlapping preferred memberships.

### Instance-specific lower bounds

Two valid inequalities strengthen the formulation:

1. **Total length is at least 32.**  
   Summing coordinate displacements over the route gives the fixed endpoint displacement. The triangle inequality therefore yields
   \[
   L\ge |302-282|+|54-54|+|20-8|=32.
   \]

2. **At least four legs must exist.**  
   The original sequence constraints already require three. With exactly three, the first leg uses X and the last uses Z. Orthogonality forces the middle leg to use Y, leaving the first leg to provide the entire 20-unit X displacement. Its 15-unit upper bound makes that impossible.

Neither bound assumes a monotone route or introduces a new routing restriction.

### Constructive incumbent preprocessing

The model constructs the candidate route
\[
(302,54,20)\rightarrow(287,54,20)\rightarrow
(287,54,10)\rightarrow(282,54,10)\rightarrow(282,54,8),
\]
followed by repeated destination nodes.

Before using it, parameter-only checks verify coordinate domains, segment and nozzle lengths, directions, orthogonality, support membership, preferred-level accounting, and applicable obstacle separation—including checks on trailing zero-length legs.

**Only if these checks succeed** does the model impose an objective upper bound equal to the candidate’s cost. This is an incumbent-based optimization reduction: it can remove inferior feasible routes, but it cannot remove every optimal solution, because the checked candidate itself is feasible.

### Cost-derived length, leg-count, and coordinate bounds

When the candidate is valid, its objective bound supports further deductions:

- At least four active legs imply at least three bend charges and three charged supports. Subtracting their minimum possible cost from the incumbent value bounds total length.
- The 32-unit length lower bound leaves a bounded budget for bends and supports, producing an upper bound on the number of active legs.
- If total length is bounded by \(L_{\max}\), every route node lies within
  \[
  \left\lfloor\frac{L_{\max}-32}{2}\right\rfloor
  \]
  coordinate units of the endpoint bounding box.

The last result follows because reaching a point outside an endpoint coordinate interval and returning requires twice that coordinate excursion in additional travel. Every node is on the route, or is a repeated destination node after the last active leg. Thus the bound applies to all nodes.

These reductions tighten the variable domains used by the mixed-integer formulation and can simplify geometric disjunctions. They are conditional on the verified incumbent; no unverified route is used to restrict the search.

### Output compatibility

All original independent decision variables remain in the model. The supplied mapping script copies their solution values, restores the six fixed endpoint coordinates from the unchanged instance data, and excludes reformulation-only auxiliaries.

The changes target a stronger, more explicitly linear formulation for HiGHS. No measured runtime improvement was established in the conversation.

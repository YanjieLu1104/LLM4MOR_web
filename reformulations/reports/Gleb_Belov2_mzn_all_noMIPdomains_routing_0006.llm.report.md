# Orthogonal Pipe-Routing Model: Reformulation Report

## 1. Application and instance

The model represents the routing of a pipe through a three-dimensional industrial layout. Its geometry suggests a plant containing equipment modules, existing pipe segments, a pipe rack, and designated support zones.

The supplied instance contains:
- **One pipe**, represented by **10 ordered nodes** and up to **nine axis-aligned legs**.
- Fixed endpoints at **(245, 108, 115)** and **(245, 62, 113)**.
- **107 fixed boxes**, classified as equipment modules, existing pipe legs, support zones, a rack, or preferred rack levels.
- A coordinate unit of **200 mm**.

The route must avoid equipment and existing pipes, subject to clearance rules and exceptions for entering or leaving the endpoint modules. Intermediate nodes must lie in designated support regions. Preferred rack levels offer cheaper support.

Some features described in the source are not active constraints. In particular, the requirement to pass through a rack is commented out, despite its input flag being set. The flexibility coefficient is zero, so flexibility imposes no restriction in this instance. The model also does not prohibit intersections between legs of the same pipe.

## 2. Original mathematical structure

### Variables

The original model declares:
- **30 integer node-coordinate variables**, including six fixed endpoint coordinates.
- Two **10 × 3 integer arrays** for lower and upper leg bounding-box coordinates.
- One **10 × 3 nonnegative integer array** for coordinate-wise leg lengths.
- **10 direction variables**, with zero denoting an absent leg and six nonzero values denoting signed coordinate directions.
- **10 binary existence flags** and **10 binary last-leg flags**.
- An integer objective variable.

The tenth leg-array position is a dummy entry fixed to zero. Additional defined arrays represent obstacle separation, support-zone membership, support costs, and flexibility expressions.

### Constraints

The principal constraint families are:

1. **Axis-aligned geometry.** Each existing leg moves along exactly one coordinate axis. Its bounding box includes the pipe radius.
2. **Route sequencing.** Existing legs form a prefix of the candidate sequence, with exactly one last leg. At least the first three legs exist.
3. **Nozzle conditions.** The first and last legs obey prescribed directions and length bounds.
4. **Orthogonality.** Consecutive existing legs use different axes, excluding both straight continuation and immediate reversal.
5. **Obstacle avoidance.** A leg must be separated from each relevant obstacle along at least one axis. Specific exceptions permit connection to the endpoint modules.
6. **Support membership.** Nodes 2–9 must belong to at least one support zone, including nodes associated with a collapsed route suffix.
7. **Inter-pipe clearance and flexibility.** These families have no effective restrictions in this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model minimizes total scaled pipe-length, bend, and support costs. Its coefficients use integer division by 100 followed by addition of one:

- **181** per coordinate unit of pipe length.
- **1,801** per existing leg after the first, representing a bend.
- **51** per charged support outside preferred rack levels, or **1** within a preferred level.

These are the model’s actual objective coefficients, rather than an unmodified monetary total.

## 3. Reformulation and validity

### Linear signed-displacement formulation

The direction-dependent geometry was replaced by positive and negative displacement variables for each leg and axis, together with binary direction indicators. Their sum equals the leg-existence flag, so an existing leg selects exactly one signed axis and an absent leg selects none.

Each displacement is bounded above by its direction indicator times a valid length limit, and below by the original minimum length times that indicator. Node differences equal positive displacement minus negative displacement; leg lengths equal their sum.

**Why valid:** In the original model, the bounding-box constraints imply that each coordinate-wise length is at least the absolute endpoint difference. The selected direction imposes the reverse inequality in that direction, while unselected axes have zero length. Consequently, length equals absolute displacement, and the bounding box is exact. The new linear equations express these same consequences directly, without changing feasible routes.

### Endpoint-domain tightening

Signed-displacement upper bounds were derived from the endpoint coordinate domains and intersected with the original maximum leg length.

Bounding-box bounds were also tightened. For example, a lower box coordinate is the minimum of the two endpoint coordinates minus the radius; its upper bound can therefore use the minimum of the endpoint upper bounds.

**Why valid:** These bounds follow directly from the exact geometry established above and the original coordinate domains. They exclude no feasible leg and provide tighter bounds for the mixed-integer formulation.

### Obstacle-disjunction preprocessing

For each relevant obstacle–leg pair, the reformulation:
- Removes the entire separation constraint when coordinate bounds guarantee separation along some axis.
- Removes an individual separation alternative when coordinate bounds make it impossible.
- Retains the original endpoint-module exceptions.

**Why valid:** Guaranteed separation makes the original disjunction true for every feasible assignment. An impossible alternative can never satisfy that disjunction. Both conclusions are obtained from valid leg-box bounds and the unchanged obstacle coordinates and safety distances.

Importantly, obstacle checks were **not** generally disabled for absent legs: the original model still applies most of them to the collapsed suffix.

### Direction-occurrence cuts

The reformulation adds a necessary direction-occurrence inequality whenever endpoint bounds establish a strictly positive or negative net displacement along an axis.

**Why valid:** Summing the leg-displacement equations telescopes to the endpoint difference. A strictly negative difference requires at least one negative-direction leg; a strictly positive difference requires at least one positive-direction leg. For this instance, the endpoint displacement requires negative-Y and negative-Z movement. These cuts make existing implications explicit.

### Support-cost linearization

The product of a leg-existence flag and its support cost was rewritten as a default support charge plus preferred-level adjustments activated by Boolean conjunctions.

**Why valid:** The original definition
\[
f_{\text{not preferred}}=1-\sum_z b_z,
\]
together with its binary domain, permits at most one preferred-level membership. Substituting this definition into the original support-cost expression gives exactly the reformulated expression. Conjunctions encode the products of existence and membership indicators.

### Inactive families and solution interface

The final model retains the general inter-pipe and flexibility constraint families. They simplify away for the embedded data because there are no distinct pipe pairs and the flexibility coefficient is zero. No rack-traversal requirement was introduced.

All original independent decision variables remain present. The mapping script returns those variables, reconstructs omitted fixed endpoint coordinates from their original singleton domains, and uses the reported objective if the objective variable is absent. It reports missing nonfixed variables rather than inventing values.

Finally, a transcription error in the box-size array was corrected, restoring the original **321 entries: three dimensions for each of 107 boxes**.

## 4. Expected computational effect

The reformulation targets HiGHS through explicit linear geometry, tighter variable bounds, simplified obstacle disjunctions, and linearized support costs. These changes are intended to reduce unnecessary logical structure and strengthen the mixed-integer formulation while preserving the original objective and feasible routes. No measured solve-time improvement was established in the conversation.

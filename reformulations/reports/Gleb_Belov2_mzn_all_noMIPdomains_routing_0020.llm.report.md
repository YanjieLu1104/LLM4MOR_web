# Orthogonal Industrial Pipe Routing: Model and Reformulation

## 1. Background and interpretation

The model represents the routing of an industrial pipe between two fixed equipment connections, or **nozzles**, through a three-dimensional installation. Coordinates are integer-valued, with one coordinate unit representing **200 mm**.

The installation contains axis-aligned boxes describing equipment modules, existing pipe segments, support zones, a pipe rack, and preferred rack levels. The new pipe must avoid relevant obstacles, respect clearance distances, and place its intermediate nodes within suitable support zones.

This instance has one pipe and ten ordered nodes. The endpoints are fixed at \((302,54,20)\) and \((282,54,8)\); the eight intermediate nodes are variable. Nine candidate legs connect consecutive nodes. Unused trailing legs have zero length, permitting routes with fewer than nine active legs.

The model does not enforce self-intersection avoidance for this pipe. Its inter-pipe separation constraints apply only to different pipes, so they impose no restrictions in this single-pipe instance.

## 2. Original formulation

### Variables

The original model declares:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- Two arrays of leg bounding-box coordinates, `nXLeg1` and `nXLeg2`, with **30 entries each**.
- **30 nonnegative coordinate-wise leg lengths**, `nLLeg`.
- **10 direction variables**, `nDirLeg`, with values from 0 to 6: zero denotes an inactive leg; the remaining values denote positive or negative movement along one of the three axes.
- **10 binary existence flags** and **10 binary last-leg flags**.
- An integer objective variable, `obj`.

The leg arrays include a tenth, non-leg entry that is fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, support costs, and flexibility quantities.

### Constraints

The principal constraint families are:

1. **Axis-aligned geometry.**  
   Each active leg moves along exactly one coordinate axis. Bounding-box inequalities, length equations, and direction implications jointly make each leg’s length equal to the absolute displacement along its selected axis.

2. **Route sequencing.**  
   Active legs form a prefix of the candidate sequence. Exactly one leg is designated last, and the first three legs must exist. Consecutive active legs must use different axes.

3. **Nozzle restrictions.**  
   The first leg points in the negative \(X\) direction; the last active leg points in the negative \(Z\) direction. Both nozzle legs have length bounds of 2–15 units. The last active leg terminates at the fixed destination.

4. **Obstacle clearance.**  
   A leg must be separated from each applicable obstacle along at least one axis, accounting for safety distance. The starting module is exempted for the first leg. The destination module has exemptions for the last active leg and inactive legs.

5. **Support requirements.**  
   Nodes indexed by candidate legs other than the first must belong to at least one support zone. Importantly, this requirement is not conditional on leg existence. Preferred rack levels determine support charges.

6. **Inter-pipe separation and flexibility.**  
   The source includes constraints for distinct pipes and optional cubic-length flexibility constraints. Neither family restricts this instance: there is only one pipe, and its flexibility coefficient is zero.

### Objective

The model **minimizes** pipe-length, bend, and support costs, using the original integer scaling rule: divide each cost coefficient by 100 and add 1.

For this instance:

- Length costs **481 per coordinate unit**.
- Each active leg after the first incurs a **4,801 bend charge**.
- Each corresponding support charge is **51 outside preferred levels** or **1 within a preferred level**.

The reformulation preserves these scaled values and the minimization direction.

## 3. Reformulation and validity

### One-hot signed-displacement formulation

The reified direction/length relations were replaced by positive- and negative-direction binary indicators and nonnegative signed-length components.

For each candidate leg, the sum of its six direction indicators equals its existence flag. Thus an active leg selects exactly one signed axis, while an inactive leg selects none. For each axis, endpoint displacement equals positive length minus negative length, and total length equals their sum.

This is equivalent to the original geometry. In the original model, the bounding-box inequalities imply that length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality. On unselected axes, length is zero, forcing equal endpoint coordinates. The new formulation states these consequences directly.

### Exact linear leg bounding boxes

Leg bounds are now expressed directly from the starting node and signed lengths:

- Lower bound = starting coordinate − negative length − radius.
- Upper bound = starting coordinate + positive length + radius.

These equations do not assume tighter geometry than the original model. The original endpoint-enclosure inequalities and exact length relation already force the same bounds. The new expressions therefore remove indirect reasoning while preserving obstacle-clearance semantics.

### Direction-specific bound strengthening

Each signed length receives an upper bound derived from:

- The original maximum leg length; and
- The largest possible displacement in that direction, computed from endpoint coordinate domains.

For example, positive displacement cannot exceed the next node’s coordinate upper bound minus the current node’s lower bound. Linking this bound to the corresponding direction binary gives a tighter linear relaxation without excluding any originally feasible route.

### Static obstacle-constraint preprocessing

An obstacle–leg constraint is omitted when coordinate-domain bounds prove separation along at least one axis for every possible placement of that leg.

This is valid because the original clearance condition is a disjunction of axis-separation tests. If one test is guaranteed by existing bounds, the entire disjunction is already true. All other obstacle constraints and nozzle-module exemptions are retained.

### Support-cost linearization

The original support cost multiplies a leg-existence variable by a variable support charge. The reformulation writes it as a base charge for existence plus preferred-level adjustments activated by Boolean conjunctions of existence and membership.

This is an exact algebraic transformation. The original definition of `fNodeNotInPref` gives
\[
f_{\mathrm{not\ preferred}}=1-\sum_z b_z.
\]
Its binary domain ensures that at most one preferred-level membership is true at each relevant node. Substitution into the original cost expression yields the reformulated expression, with each binary product represented by conjunction. The membership requirements and this domain restriction remain in the model.

### Removal of vacuous constraint families

- **Inter-pipe separation:** the original constraints are generated only for legs belonging to different pipes. With one pipe, their indexing condition is never satisfied.
- **Flexibility:** the original source explicitly substitutes zero for flexibility sums and disables the associated inequalities when the pipe’s flexibility coefficient is nonpositive. The supplied coefficient is zero.

Removing these inactive calculations therefore changes neither feasibility nor objective values. An assertion records the instance conditions supporting this specialization.

### Solution interface

All original independent decision variables remain in the reformulated model. The mapping script copies their returned values, excludes newly introduced auxiliaries, and reconstructs fixed endpoint coordinates from their original singleton domains if they are not emitted.

The reformulation targets a stronger, more explicit mixed-integer linear formulation for HiGHS. No runtime improvement is claimed without comparative solver measurements.

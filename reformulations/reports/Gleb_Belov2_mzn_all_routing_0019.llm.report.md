# Pipe-Routing Model and Reformulation Report

## 1. Application and instance

The model represents **three-dimensional industrial pipe routing** between two fixed equipment connection points, or nozzles. A route consists of axis-aligned straight segments joined by right-angle bends. It must avoid equipment and existing pipes while placing its intermediate nodes in permitted support regions.

The supplied instance contains:

- **One pipe**, represented by 10 ordered nodes and at most nine connecting legs.
- Fixed endpoints at **(245, 86, 100)** and **(245, 62, 58)**.
- **166 boxes**, describing equipment modules, existing pipe segments, module support zones, a rack, and preferred rack levels.
- A coordinate unit of **200 mm** and a pipe diameter of two coordinate units.

The first leg must travel in the negative Z direction, and the final active leg in the negative Y direction. A route may use fewer than nine legs: unused trailing legs have zero length, leaving their nodes coincident with the destination.

## 2. Original mathematical structure

### Variables

The original model declares **151 independent scalar decision-variable entries** before flattening:

| Group | Entries | Meaning |
|---|---:|---|
| Node coordinates | 30 | Ten three-dimensional nodes; six coordinates are fixed |
| Leg lower and upper bounds | 60 | Radius-expanded bounding boxes for ten leg slots |
| Coordinate-wise leg lengths | 30 | Nonnegative length in each coordinate |
| Leg directions | 10 | Zero for inactive; six signed coordinate directions otherwise |
| Existence and final-leg flags | 20 | Binary route-sequence indicators |
| Objective | 1 | Total scaled cost |

Only nine leg slots connect consecutive nodes; the tenth slot is fixed to zero. Additional defined arrays represent geometric relations, support membership, support costs, and flexibility expressions.

### Constraints

The main constraint families are:

- **Leg geometry:** Expanded leg boxes contain both endpoint cross-sections. Their widths equal the corresponding leg lengths plus twice the pipe radius.
- **Direction and length:** An active leg has positive length along exactly one coordinate. All other coordinate lengths are zero. General and nozzle-specific length restrictions apply together.
- **Route sequence:** Active legs form a prefix, exactly one is marked final, and at least three legs exist.
- **Orthogonality:** Consecutive active legs use different coordinate axes, excluding both straight continuation and immediate reversal.
- **Destination connection:** The final active leg has the prescribed incoming direction and ends at the fixed destination.
- **Obstacle clearance:** Each relevant leg box must be separated from each obstacle along at least one axis, including its safety distance. Specific exemptions permit connections to the source and destination modules.
- **Support membership:** Every intermediate node indexed by a non-first candidate leg must belong to a support zone. This requirement also applies to nodes associated with inactive trailing legs.
- **Optional physical restrictions:** The source includes inter-pipe clearance and flexibility constraints, although neither is active in this instance.

The rack-traversal requirement appears only as commented-out code and is therefore not an enforced constraint.

### Objective

The model **minimizes pipe-length, bend, and support costs**. It uses the original integer scaling rule: divide each cost coefficient by 100 and add one.

For this instance, the effective costs are:

- **131** per coordinate unit of pipe length;
- **1,301** per active leg after the first, representing a bend;
- **51** per active bend outside preferred rack levels;
- **1** per active bend in a preferred rack level.

The reformulation preserves these coefficients and the minimization direction.

## 3. Reformulation and justification

### Exact signed-length formulation

The original direction-dependent geometric implications were replaced by positive and negative direction selectors and corresponding nonnegative lengths.

For each leg and coordinate, the reformulation imposes:

- endpoint displacement = positive length − negative length;
- original coordinate length = positive length + negative length;
- lower expanded bound = starting coordinate − negative length − radius;
- upper expanded bound = starting coordinate + positive length + radius.

The sum of all six direction selectors equals the leg-existence flag, so an active leg selects exactly one signed direction.

**Why this is equivalent:** In the original model, endpoint containment and the box-width equation imply that each coordinate length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality. Hence the length equals that displacement, and the expanded bounds are tight. For every unselected coordinate, the original length is zero, forcing equal endpoint coordinates. The signed-length equations express exactly these consequences.

This formulation exposes linear structure directly to HiGHS and replaces several conditional geometric relationships with equalities and binary-controlled bounds.

### Direction-specific bound strengthening

Each signed length receives an upper bound derived from the endpoint domains. For example, a positive displacement cannot exceed

**upper bound of the ending coordinate − lower bound of the starting coordinate**,

and it also cannot exceed the original pipe-leg length limit. The analogous bound applies to negative displacement.

These bounds are valid because they follow directly from the original coordinate domains and length limits. Linking them to the direction selectors strengthens the mixed-integer relaxation without removing feasible routes.

### Direct obstacle-separation constraints

The intermediate three-dimensional array of coordinate-wise obstacle-disjointness expressions was removed. The model instead states each required separation disjunction directly.

This is substitution of the original array definition into its consuming constraint, not a relaxation. Safety distances and nozzle-module exemptions remain unchanged. In particular, inactive legs are **not** generally exempted from obstacle checks: the original model grants that exemption only for the destination-module case.

### Linearized support costs

The product between a leg-existence flag and a variable support cost was rewritten as:

- the default support cost multiplied by existence;
- plus a preferred-level cost adjustment multiplied by the Boolean conjunction of existence and membership.

**Why this is equivalent:** The original definition gives the non-preferred flag as one minus the sum of preferred-level membership indicators. Substituting this identity into the original cost expression and distributing the existence flag produces the reformulated expression exactly. Boolean conjunction represents the product of two binary indicators.

The original membership equations and the non-preferred flag’s binary domain remain enforced, including their restriction against simultaneous membership in multiple preferred levels.

### Instance-specific preprocessing

Two inactive components were omitted:

- **Inter-pipe collision constraints:** Their generating condition requires legs from different pipes. Every node belongs to pipe 1, so no such pair exists.
- **Flexibility expressions and constraints:** The supplied flexibility coefficient is zero. The original conditional definitions therefore evaluate the associated expressions to zero and the constraints to true; no cubic restriction remains active.

These reductions follow from the embedded data and the original conditional definitions, rather than from additional physical assumptions.

### Data repair and solution mapping

A transcription error in the box-size array was repaired by restoring the two omitted original entries. The resulting **498 entries** match 166 boxes × three coordinates; no instance values were intentionally changed.

All original independent variables remain in the reformulated model. The mapping script copies their returned values, excludes auxiliary variables, and restores omitted fixed endpoint coordinates from the original embedded constants. If `obj` is not emitted separately, it uses the unchanged reported objective.

## 4. Expected computational effect

The reformulation targets a stronger and more explicit linear mixed-integer representation: signed-length equalities, tighter selector bounds, fewer intermediate logical expressions, and Boolean linearization of support costs. These changes are intended to reduce solving time, but no measured speedup or optimality result was established in the conversation.

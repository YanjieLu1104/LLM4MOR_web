# Pipe-Routing Model: Structure and Reformulation

## 1. Application background

The model represents three-dimensional pipe routing in an industrial facility. A single pipe connects two fixed nozzles while avoiding equipment modules and existing pipe segments. Its route consists of axis-aligned straight legs joined by right-angle bends.

Fixed boxes describe obstacles, support zones around equipment, a pipe rack, and preferred support levels within the rack. Obstacle clearance incorporates the specified safety distances and an integer pipe radius. Bend locations must lie in eligible support zones, and preferred rack levels receive lower support costs.

The supplied instance has ten node positions and nine possible connecting legs. The endpoints are fixed at `(185, 53, 58)` and `(288, 25, 3)`. Coordinates use a discretization unit of 200 mm. Although the input contains a flag requesting passage through a rack, the corresponding constraint is commented out in the original model; the reformulation therefore does not impose it.

## 2. Original formulation

### Variables

The original independent variables comprise:

- **30 integer node coordinates**, including six fixed endpoint coordinates.
- **60 integer leg-envelope coordinates**, giving lower and upper bounds along three axes for ten indexed leg slots.
- **30 nonnegative integer component lengths**.
- **10 direction variables**, encoding inactivity or one of six signed coordinate directions.
- **20 binary-valued integer flags**, indicating leg existence and the final existing leg.
- **One integer objective variable**.

The tenth leg slot is a dummy slot fixed to zero. Additional defined arrays express obstacle separation, support-zone membership, and costs.

### Constraints

The principal constraint families are:

1. **Leg geometry:** Each existing leg moves along exactly one coordinate axis. Its envelope contains both endpoint positions, expanded by the integer pipe radius, and its component length agrees with that envelope.
2. **Route sequence:** Existing legs form a prefix of the possible legs. At least the first three exist, and exactly one existing leg is designated as the last.
3. **Bends and nozzles:** Consecutive existing legs use different axes. The first and final legs obey prescribed nozzle directions and length limits. The last leg ends at the fixed destination.
4. **Obstacle avoidance:** A leg must be separated from each relevant obstacle along at least one axis. Specific exemptions permit connection to the source and destination modules.
5. **Support eligibility:** Every intermediate indexed node must lie in a support zone. This requirement also applies to nodes associated with inactive trailing legs.
6. **Optional general-model machinery:** The source includes inter-pipe separation and flexibility constraints, but neither contributes an active restriction in this instance.

### Objective

The model minimizes the sum of pipe-length, bend, and node-support costs. It uses the original coefficient transformation

\[
c_{\text{model}}=\left\lfloor c_{\text{input}}/100\right\rfloor+1.
\]

Consequently, the supplied length coefficient is 51, the bend coefficient is 501, and the support coefficient is either 51 or 1, depending on support location. These transformed costs—not unscaled monetary costs—define the optimization objective and are preserved exactly.

## 3. Reformulation and justification

### Signed-length linear formulation

The reformulation introduces positive and negative direction indicators and corresponding nonnegative lengths for each leg and axis. It enforces

\[
x_{i+1,k}-x_{i,k}=\ell^+_{i,k}-\ell^-_{i,k},
\qquad
L_{i,k}=\ell^+_{i,k}+\ell^-_{i,k}.
\]

Exactly one signed direction is selected for an existing leg, and none is selected for an inactive leg. Linear bounds link each signed length to its indicator. Consecutive-leg orthogonality becomes a linear inequality over these indicators.

**Why this is equivalent:** In the original model, the envelope constraints imply that a component length is at least the absolute endpoint displacement. The selected-direction implication supplies the reverse inequality with the appropriate sign. Thus, the component length equals the absolute displacement. Unselected components have zero length and therefore zero displacement. The new formulation expresses these same relationships directly.

The envelope variables are retained and linked by linear equalities to the signed lengths. Their original meanings are therefore unchanged.

### Coordinate-domain and nozzle-bound preprocessing

Each component receives an upper bound derived from the maximum possible endpoint displacement and the applicable original length limit. First-leg and final-possible-leg components also use their nozzle-axis restrictions and nozzle upper bounds.

**Why this is valid:** A component length equals its absolute endpoint displacement, so it cannot exceed the largest displacement permitted by the endpoint coordinate domains. The nozzle bounds and zero off-axis components already follow from the original nozzle constraints. Taking the minimum of these bounds removes no feasible route.

These tighter bounds strengthen the indicator–length links used by the mixed-integer formulation.

### Direct obstacle-separation disjunctions

Obstacle avoidance is expressed directly as a disjunction of the six possible separating inequalities, rather than through the intermediate fully reified `bDisjLegBox_K` array.

**Why this is equivalent:** Each original array entry merely defines separation along one axis. Substituting its definition into the required disjunction preserves the condition exactly. The original module exemptions and treatment of inactive legs are retained.

This removes an intermediate logical layer and allows the compiler to formulate the required disjunction directly.

### Boolean support-cost linearization

Products of leg-existence flags and binary support indicators are replaced by Boolean conjunctions converted to integers.

**Why this is equivalent:** For binary values \(a\) and \(b\),

\[
ab=\operatorname{bool2int}(a=1\land b=1).
\]

Distributing the existence flag over the original support-cost expression therefore gives the same cost for every feasible solution. The support-membership definitions and the domain restriction on `fNodeNotInPref` remain in place.

### Removal of inactive machinery

- **Inter-pipe separation:** Every node belongs to the same pipe. The original constraints quantify only over legs belonging to different pipes, so there are no applicable leg pairs.
- **Flexibility:** The supplied flexibility coefficient is zero. The original conditional expressions therefore make the cubic-length sums zero and the associated constraints true.

Removing these inactive definitions and constraints changes neither feasibility nor objective values.

## 4. Interface and expected effect

All original independent decision variables and fixed instance data are retained. The mapping script copies the retained variables and can restore omitted fixed endpoint coordinates from the original embedded constants. It excludes reformulation-specific auxiliary variables.

The changes target HiGHS by replacing implication-heavy geometry and variable products with explicit linear relationships and tighter bounds. They are intended to improve the mixed-integer formulation; no measured runtime improvement or optimal solution was established in the conversation.

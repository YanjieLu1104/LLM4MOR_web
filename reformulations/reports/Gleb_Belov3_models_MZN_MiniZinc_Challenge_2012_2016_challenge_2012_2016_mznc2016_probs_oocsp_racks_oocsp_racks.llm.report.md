## Background and purpose

The model represents a configurable equipment installation using an object-oriented encoding. A configuration contains **elements** and **racks**; racks contain **frames**, and frames contain **modules**. Elements appear to represent functional requirements that must be served by compatible hardware modules.

The configuration rules are:

- Each ElementA requires one ModuleI.
- Each ElementB requires two ModuleII units.
- Each ElementC requires three ModuleIII units.
- Each ElementD requires four ModuleIV units.
- All modules serving one element must occupy the same frame.
- Every frame containing ModuleII must also contain at least one ModuleV.
- ModuleV serves no element.
- A frame holds at most six modules.
- A RackSingle contains exactly four frames; a RackDouble contains exactly eight.

External data supply the overall object limit and lower and upper bounds on the population of each class. The task is to find a configuration satisfying these requirements.

## Original model structure

### Variables and object representation

Let \(N=\texttt{MAXNROFOBJECTS}\). The model assigns object identifiers from \(1\) through \(N\), with zero reserved for absent links.

There are 16 named classes and one additional class for unused object slots. Class populations occupy contiguous identifier intervals. The arrays `start`, `leafclass_min`, `leafclass_max`, and `nrofobjects` describe these intervals and the class hierarchy.

The source declares **\(68+11N\) integer variable entries**, before flattening or presolve:

- Four arrays of 17 entries describing the hierarchy and class populations. The 34 entries in the two leaf-class arrays are fixed by explicit assignments.
- One configuration-attribute array.
- Five association-link arrays.
- Five arrays counting incoming association links.

### Constraints

The main constraint groups are:

1. **Class hierarchy and population bounds:** ordered interval starts, population equations, externally supplied class bounds, and exactly one configuration object.
2. **Attributes:** configuration objects have a configuration-type value between 1 and 100; other objects have zero.
3. **Associations:** source and target class restrictions, mandatory or optional links, and incoming-link counts implemented with `global_cardinality`.
4. **Equipment compatibility:** element-specific module types and quantities, exact rack frame counts, ModuleV support for ModuleII, and frame capacity.
5. **Co-location:** pairwise constraints require modules serving the same element to share a frame.
6. **Optional redundant inequalities:** aggregate class-population relations enabled by `USECARDINALITYCONSTRAINTS`.

The original formulation also uses existential searches for ModuleV witnesses and repeated counts over object pairs.

### Objective

The solve item is `satisfy`: **there is no optimization objective**. The original search annotation specifies an integer-variable search order, but does not change the feasible configurations.

## Reformulation and justification

### 1. Exploit the unique configuration object

The configuration class starts at object identifier 1, and its population is constrained to exactly one. Therefore, its sole instance is object 1.

Every element and rack must link to a configuration. Their configuration links are consequently determined: active elements and racks link to object 1, while objects outside the corresponding source class have zero links. The incoming configuration counts equal the total element and rack populations at object 1 and are zero elsewhere.

The reformulation expresses these facts directly, eliminating two global-cardinality constraints. It retains the original upper limits of 100 elements and 100 racks.

**Technique:** structural propagation and elimination of redundant counting constraints.

### 2. Reuse existing incoming-link counts

The original association constraints ensure that only modules can have nonzero `Module_element` links. Thus, the incoming count already stored in `Element_modules_count` is exactly the module count required by each element-specific rule. It can be set directly to 1, 2, 3, or 4 according to element class, and to zero outside the element classes.

Similarly, only frames can have nonzero `Frame_rack` links. Therefore, `Rack_frames_count` can directly express the required eight frames for RackDouble and four for RackSingle.

**Technique:** reuse of existing counting variables instead of repeated class-filtered sums.

### 3. Express compatibility from the module side

Originally, each element restricts the types of all modules pointing to it. In addition, every ModuleI–IV must have an element, whereas ModuleV cannot serve one.

Together, these rules imply the equivalent module-side restrictions: ModuleI must link to ElementA, ModuleII to ElementB, ModuleIII to ElementC, and ModuleIV to ElementD. All remaining objects have zero element links.

Combined with the incoming-count equations, these restrictions preserve both compatibility and required quantities.

**Technique:** association-constraint reorientation.

### 4. Replace pairwise co-location with an element-to-frame channel

An auxiliary array records the frame serving each element. Every module with a nonzero element link must have the frame recorded for that element.

This is equivalent to the original pairwise constraints:

- If the channel holds, any two modules serving the same element have equal frame values.
- Conversely, the original pairwise constraints make all modules serving an element share one frame, which supplies a consistent auxiliary value. Every element has at least one required module.

A zero-index entry explicitly accommodates absent links without an out-of-bounds array reference.

**Technique:** auxiliary-variable channeling, replacing a quadratic family of pairwise co-location conditions with one indexed channel per module. Other parts of the formulation still involve object-pair counting.

### 5. Replace ModuleV witnesses with per-frame counts

The reformulation counts ModuleII and ModuleV units in each frame.

Each ElementB contributes exactly two ModuleII units, and those units must be co-located. Consequently, the number of ModuleII units in any frame is even. If positive, the original support rule requires at least one ModuleV. With a six-module frame capacity, there can therefore be at most four ModuleII units in such a frame.

Writing these counts as \(I_f\) and \(V_f\), the reformulation uses
\[
0\le I_f\le4,\qquad I_f\le4V_f.
\]
A positive \(I_f\) forces \(V_f\ge1\). Conversely, every originally feasible frame satisfies these inequalities by the pairing, support, and capacity rules above.

**Technique:** aggregation of existential witnesses and a problem-specific capacity strengthening.

### 6. Add implied population equalities and capacity cuts

The following relations are made explicit:

- ModuleI–IV populations equal the corresponding element populations multiplied by 1, 2, 3, and 4. This follows because every such module serves exactly one compatible element, and every element requires exactly that many modules.
- The frame population equals four times the RackSingle population plus eight times the RackDouble population. Every frame belongs to exactly one rack, and rack frame counts are exact.
- Parent-class populations equal the sums of their leaf-class populations. The hierarchy intervals partition these classes.
- Configuration, element, frame, module, rack, and unused populations sum to \(N\). These disjoint groups cover the object scope.
- Total modules are at most six times total frames, by summing frame capacities.
- ElementB population is at most twice the ModuleV population and at most twice the frame population. Each supporting frame holds at most two ElementB module pairs and needs at least one ModuleV.
- ElementD population is at most the frame population. Its four co-located modules prevent two ElementD instances from sharing a six-slot frame.

These implied relations also subsume the original optional aggregate inequalities. The parameter `USECARDINALITYCONSTRAINTS` remains accepted, but no longer controls whether those redundant consequences are available.

**Technique:** conservation equations and valid aggregate capacity cuts.

## Interface, mapping, and expected effect

The reformulation retains the original external data interface and original independent decision-variable names. Auxiliary variables are internal. The mapping script copies original variable values and excludes auxiliaries; it reports missing values rather than inventing a reconstruction.

The changes aim to simplify counting and logical structure and expose stronger linear relations to the HiGHS backend. They preserve feasible original configurations under projection onto the original variables. **No runtime improvement has been measured in the supplied conversation**, so the performance benefit remains an empirical question.

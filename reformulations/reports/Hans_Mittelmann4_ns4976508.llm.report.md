# Reformulation Report: Protected Network Routing and Physical Mapping

## 1. Problem background

The model represents a telecommunications network-design problem in which traffic is routed over a logical network, and each selected logical link is mapped onto physical infrastructure.

Every unordered pair of the 12 nodes has one unit of traffic demand. Each demand receives two logical routings:

- A **working routing**, whose logical links must be mapped onto a designated physical backbone, called the *spine*.
- A **backup routing**, whose logical links may be mapped anywhere in the physical network.

The working and backup subnetworks cannot use the same **directed logical link**. Additional binary indicators prevent a commodity’s working and backup traffic from using the same **directed physical spine arc**. These restrictions are directional: the model does not explicitly require disjointness of the corresponding undirected links.

The objective minimizes total physical traffic carried, counting traffic separately on every physical arc and logical-link mapping. Thus, it favors resource-efficient physical realizations of the protected traffic.

Although the file declares a second demand class and physical and logical capacity parameters, none of these parameters appears in the active optimization constraints. The implemented problem therefore does **not** impose the declared link capacities or route the second demand class.

## 2. Original model structure

### Instance and variables

The supplied instance contains:

- 12 nodes and 66 unordered demand pairs;
- 48 directed logical links;
- 36 directed physical links;
- 22 directed spine arcs, representing an undirected spanning tree with 11 edges.

Before presolve, the model declares **190,080 continuous variables** and **11,892 binary variables**.

| Variables | Type | Meaning |
|---|---|---|
| `ZxI`, `ZyI` | Nonnegative continuous | Commodity traffic on working and backup logical links |
| `X`, `Y` | Binary | Physical arcs selected to realize each logical link |
| `x`, `y` | Binary | Working and backup logical-link activation |
| `ZX1`, `ZY1` | Nonnegative continuous | Commodity traffic on physical arcs, distinguished by logical-link mapping |
| `ZX11`, `ZY11` | Binary | Physical-arc indicators used to enforce working/backup diversity |
| `ci` | Binary | Unused variables; 5,184 are declared |

### Constraints

The formulation combines several layers of constraints:

1. **Logical flow conservation.** Each commodity’s working and backup traffic must separately satisfy its source-to-destination demand.
2. **Logical-link activation and separation.** Aggregate logical traffic is bounded above by total demand times an activation binary and below by that binary. An activated link therefore carries at least one unit of aggregate traffic. The constraint `x + y <= 1` separates the two logical subnetworks.
3. **Physical mapping conservation.** Selected physical arcs realize each activated logical link between its endpoints.
4. **Mapping degree restrictions.** Opposite orientations of a physical edge cannot both be selected for the same logical link, and each node has selected incident degree at most two.
5. **Physical traffic wrappers.** Commodity-level physical flows satisfy conservation, are individually bounded by the associated mapping binary, and collectively carry at least one unit on every selected mapping arc.
6. **Diversity activation.** Aggregate physical commodity traffic is linked to binary usage indicators with a coefficient of 100. Working and backup indicators cannot both be active on the same directed spine arc for the same commodity.

Despite their names, the original “loopless” constraints do not eliminate all cycles in the general physical network. In particular, disconnected directed backup cycles can remain feasible.

### Objective

The linear minimization objective is

\[
\min \sum ZX1+\sum ZY1.
\]

It measures aggregate physical traffic usage, rather than the number of activated links or reserved capacity.

## 3. Reformulation and justification

### 3.1 Exact elimination opportunities from the spine tree

The principal preprocessing step recognizes that the supplied undirected spine is a **spanning tree**. The reformulated file checks connectivity, absence of self-loops, and the required edge count, and derives the unique directed spine path between each logical link’s endpoints.

For a logical link \((s,t)\), let \(P_{ij,st}\) indicate whether directed spine arc \((i,j)\) belongs to its unique \(s\)-to-\(t\) path. The reformulation imposes

\[
X_{ij,st}=P_{ij,st}x_{st},
\qquad
ZX1_{ij,st,mn}=P_{ij,st}ZxI_{st,mn}.
\]

These are exact identities for the original feasible solutions:

- Original mapping conservation requires an \(s\)-to-\(t\) unit flow when `x = 1`, and a circulation when `x = 0`.
- A tree has only one path between distinct endpoints. The original opposite-direction restriction prevents selecting both orientations of an edge, so no nonzero selected circulation is possible on the tree.
- Consequently, `X` must select exactly that path when active and no arcs otherwise.
- The original bounds `ZX1 <= X` restrict physical commodity traffic to the selected path. Its conservation equations then force the same value, `ZxI`, on every path arc.

The original wrapper bounds consequently imply `ZxI <= x`. Conversely, the path identities, this bound, and the retained logical aggregate bounds imply the removed spine mapping and wrapper constraints. In particular, the aggregate lower wrapper bound on each selected path arc is exactly the retained requirement that aggregate logical working traffic be at least `x`.

This is **tree-based structural substitution**, not an assumption that arbitrary mappings are shortest paths. All original variables remain declared, but the identities expose **1,056 `X` variables and 69,696 `ZX1` variables** for elimination by solver presolve.

### 3.2 Valid logical-flow activation cuts

The reformulation explicitly imposes

\[
ZxI_{st,mn}\le x_{st},
\qquad
ZyI_{st,mn}\le y_{st}.
\]

The working inequality follows from the tree argument above.

For the backup inequality:

- If `y = 0`, the original aggregate logical upper bound and nonnegativity force every associated `ZyI` to zero.
- If `y = 1`, mapping conservation at the logical source requires selected outgoing degree minus incoming degree to equal one. Binary mapping variables and the incident-degree bound of two force exactly one selected outgoing arc and no selected incoming arc.
- Physical wrapper conservation and `ZY1 <= Y` therefore bound each commodity’s logical backup flow by one.

These are valid inequalities for the original integer-feasible set and can strengthen its continuous relaxation. They do not require eliminating backup cycles elsewhere.

### 3.3 Tighter big-\(M\) coefficients

The original activation coefficient of 100 is replaced by bounds derived from the summands:

- **Backup activation:** Each `ZY1` summand is at most one because `ZY1 <= Y` and `Y` is binary. There are 48 directed logical links, so their sum is at most 48. Replacing 100 by 48 preserves integer feasibility.
- **Spine activation:** After tree substitution, only logical links whose unique paths contain a given directed spine arc can contribute. Each contribution is at most one. The coefficient becomes the smaller of 100 and the number of such logical links.

This is **bound-based big-\(M\) tightening**, intended to reduce unnecessary slack in the LP relaxation.

### 3.4 Disaggregated spine activation cuts

For every logical path containing a directed spine arc, the model adds

\[
ZxI_{st,mn}\le ZX11_{ij,mn}.
\]

If the original binary indicator is zero, its aggregate activation constraint forces every nonnegative contributing flow to zero. If it is one, the inequality follows from the unit bound on logical working flow. The cuts are therefore valid and strengthen the fractional relaxation beyond the aggregate activation constraint alone.

### 3.5 Duplicate removal and data compatibility

The backup opposite-direction constraint originally appears once for each orientation of an edge, producing identical inequalities. Keeping one representative preserves its meaning. The corresponding spine restrictions are superseded by the exact tree identities.

The unused capacity parameters are declared over all node pairs so that the supplied full matrix tables can be loaded without out-of-domain entries. Their numerical data are unchanged, and no capacity constraints are introduced.

## 4. Preservation and expected effect

The reformulation retains the minimization direction, objective expression, original decision-variable names, and supplied numerical data. Solution mapping is the identity. It also preserves backup circulations allowed by the original model rather than imposing an unjustified global acyclicity restriction.

The expected benefits are a smaller presolved spine formulation and a stronger relaxation from tighter activation constraints. These are structural improvements; no measured solve-time reduction was established in the conversation.

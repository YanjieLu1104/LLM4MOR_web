int: nbE;
int: nbV;
set of int: edges = 1..nbE;
set of int: nodes = 1..nbV;

array[nodes,edges] of bool: incident;
array[nodes,edges] of bool: outgoing;
array[edges] of int: tails;
array[edges] of int: heads;
array[1..2,edges] of int: endpairs = array2d(1..2,edges,tails++heads);

var 0..nbE: objective;
array[edges] of var bool: chosen;
array[nodes] of var 0..nbE: distance;
int: root = 1;

int: mdgr_distance_bound = min(nbE, max(0, card(nodes) - 1));

array[int] of int: mdgr_arc_edges = [
    b
    | a in nodes, b in edges
    where a != root /\ incident[a,b] /\ tails[b] != a
];

array[int] of int: mdgr_arc_nodes = [
    a
    | a in nodes, b in edges
    where a != root /\ incident[a,b] /\ tails[b] != a
];

array[index_set(mdgr_arc_edges)] of var bool: mdgr_witness;

constraint distance[root] = 0;

constraint forall(a in nodes)(
    distance[a] <= mdgr_distance_bound
);

constraint forall(a in nodes where a != root)(
    exists(b in edges)(incident[a,b])
);

constraint forall(
    a in nodes, b in edges
    where a != root /\ incident[a,b] /\ tails[b] = a
)(
    chosen[b] = false
);

constraint forall(mdgr_k in index_set(mdgr_arc_edges))(
    distance[mdgr_arc_nodes[mdgr_k]]
    >= distance[tails[mdgr_arc_edges[mdgr_k]]] + 1
       - (mdgr_distance_bound + 1)
         * (1 - bool2int(chosen[mdgr_arc_edges[mdgr_k]]))
);

constraint forall(mdgr_k in index_set(mdgr_arc_edges))(
    bool2int(mdgr_witness[mdgr_k])
    <= bool2int(chosen[mdgr_arc_edges[mdgr_k]])
);

constraint forall(mdgr_k in index_set(mdgr_arc_edges))(
    distance[mdgr_arc_nodes[mdgr_k]]
    <= distance[tails[mdgr_arc_edges[mdgr_k]]] + 1
       + mdgr_distance_bound
         * (1 - bool2int(mdgr_witness[mdgr_k]))
);

constraint forall(a in nodes where a != root)(
    sum(
        mdgr_k in index_set(mdgr_arc_edges)
        where mdgr_arc_nodes[mdgr_k] = a
    )(
        bool2int(mdgr_witness[mdgr_k])
    ) <= 1
);

constraint forall(a in nodes where a != root)(
    distance[a]
    <= mdgr_distance_bound
       * sum(
           mdgr_k in index_set(mdgr_arc_edges)
           where mdgr_arc_nodes[mdgr_k] = a
       )(
           bool2int(mdgr_witness[mdgr_k])
       )
);

constraint objective = sum(e in edges)(bool2int(chosen[e]));

solve
    :: seq_search([
        bool_search(chosen, input_order, indomain_max, complete),
        int_search(distance, input_order, indomain_min, complete)
    ])
    maximize objective;

output [
    "chosen = ", show(chosen), ";\n",
    "distance = ", show(distance), ";\n",
    "objective = ", show(objective), ";\n"
];
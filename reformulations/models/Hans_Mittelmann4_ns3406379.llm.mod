param num_comp;
param num_node;
param DSM {i in 1..num_comp, j in 1..num_comp} binary;
param dist;

set rf3406379_arcs dimen 2 :=
    {u in 1..num_node, v in 1..num_node: 0 < v-u <= dist};

set rf3406379_pairs dimen 2 :=
    {i in 1..num_comp, j in 1..num_comp: i < j};

var c {u in 1..num_node, i in 1..num_comp} >= 0, <= 1;
var x {(u,v) in rf3406379_arcs} binary;
var y {u in 1..num_node, i in 1..num_comp} binary;

var cc {u in 1..num_node, (i,j) in rf3406379_pairs}
    >= 0, <= 1;

var cx {
    u in 1..num_node,
    i in 1..num_comp,
    v in 1..num_node:
    (u,v) in rf3406379_arcs
} >= 0, <= 1;

minimize Modularity_Index:
    sum {u in 1..num_node, (i,j) in rf3406379_pairs}
        2*(1-DSM[i,j])*cc[u,i,j]
    +
    sum {u in 1..num_node, (i,j) in rf3406379_pairs}
        2*DSM[i,j]*(c[u,i]-cc[u,i,j]);

subject to c_0_1 {
    u in 1..num_node, (i,j) in rf3406379_pairs
}:
    cc[u,i,j] <= c[u,i];

subject to c_0_2 {
    u in 1..num_node, (i,j) in rf3406379_pairs
}:
    cc[u,i,j] <= c[u,j];

subject to c_0_3 {
    u in 1..num_node, (i,j) in rf3406379_pairs
}:
    cc[u,i,j] >= c[u,i] + c[u,j] - 1;

subject to c_1 {u in 1..num_node, i in 1..num_comp}:
    c[u,i] =
        sum {v in 1..num_node: (u,v) in rf3406379_arcs}
            cx[u,i,v]
        + y[u,i];

subject to c_1_2 {
    u in 1..num_node,
    i in 1..num_comp,
    v in 1..num_node:
    (u,v) in rf3406379_arcs
}:
    cx[u,i,v] <= x[u,v];

subject to rf3406379_incoming_flow {
    v in 1..num_node, i in 1..num_comp: v > 1
}:
    sum {u in 1..num_node: (u,v) in rf3406379_arcs}
        cx[u,i,v]
    = c[v,i];

subject to c_2 {u in 1..num_node}:
    sum {v in 1..num_node: (u,v) in rf3406379_arcs}
        x[u,v]
    + sum {i in 1..num_comp} y[u,i]
    = 2;

subject to c_3 {i in 1..num_comp}:
    sum {u in 1..num_node} y[u,i] = 1;

subject to c_4 {v in 1..num_node: v > 1}:
    sum {u in 1..num_node: (u,v) in rf3406379_arcs}
        x[u,v]
    = 1;

subject to c_5 {i in 1..num_comp}:
    c[1,i] = 1;

subject to rf3406379_subtree_lower {u in 1..num_node}:
    sum {i in 1..num_comp} c[u,i]
    >= 2
       + sum {v in 1..num_node: (u,v) in rf3406379_arcs}
           x[u,v];

subject to rf3406379_subtree_upper {u in 1..num_node}:
    sum {i in 1..num_comp} c[u,i] <= num_node-u+2;

subject to rf3406379_pair_membership {
    u in 1..num_node, i in 1..num_comp
}:
    sum {j in 1..num_comp: j < i} cc[u,j,i]
    + sum {j in 1..num_comp: i < j} cc[u,i,j]
    >= c[u,i];

data;

param num_comp := 20;
param num_node := 19;
param dist := 8;

param DSM :=

[*,*]: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 :=
1  1 0 1 1 0 0 0 0 0 1 0 1 0 0 0 0 1 0 0 1
2  0 1 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0
3  0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0
4  1 0 0 1 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 1
5  0 1 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0
6  0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1
7  0 0 0 0 0 0 1 0 0 1 0 1 0 0 0 0 0 1 0 0
8  1 0 1 0 0 0 0 1 0 0 0 0 1 0 1 0 0 0 0 0
9  0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 0
10 0 1 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0
11 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0
12 0 0 1 0 0 0 0 1 0 0 0 1 0 1 0 0 0 1 0 0
13 0 1 0 0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 0 0
14 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0
15 0 0 1 0 0 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0
16 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1
17 0 1 0 0 0 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0
18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
19 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0
20 1 1 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 1;
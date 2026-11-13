param num_comp;
param num_node;
param DSM {i in 1..num_comp,j in 1..num_comp} binary;
param dist;

set rf_arcs := {u in 1..num_node, v in 1..num_node:
    0 < v-u <= dist};
set rf_pairs := {i in 1..num_comp, j in 1..num_comp: i < j};

var c {u in 1..num_node,i in 1..num_comp} >= 0, <= 1;
var x {(u,v) in rf_arcs} binary;
var y {u in 1..num_node,i in 1..num_comp} binary;
var cc {u in 1..num_node,(i,j) in rf_pairs} >= 0, <= 1;
var cx {(u,v) in rf_arcs,i in 1..num_comp} >= 0, <= 1;

minimize Modularity_Index:
    sum {u in 1..num_node,(i,j) in rf_pairs}
        2*(1-DSM[i,j])*cc[u,i,j]
  + sum {u in 1..num_node,(i,j) in rf_pairs}
        2*DSM[i,j]*(c[u,i]-cc[u,i,j]);

subject to c_0_1 {u in 1..num_node,(i,j) in rf_pairs}:
    cc[u,i,j] <= c[u,i];

subject to c_0_2 {u in 1..num_node,(i,j) in rf_pairs}:
    cc[u,i,j] <= c[u,j];

subject to c_0_3 {u in 1..num_node,(i,j) in rf_pairs}:
    cc[u,i,j] >= c[u,i] + c[u,j] - 1;

subject to c_1 {u in 1..num_node,i in 1..num_comp}:
    c[u,i] =
        sum {v in 1..num_node: (u,v) in rf_arcs} cx[u,v,i]
        + y[u,i];

subject to c_1_1 {(u,v) in rf_arcs,i in 1..num_comp}:
    cx[u,v,i] <= c[v,i];

subject to c_1_2 {(u,v) in rf_arcs,i in 1..num_comp}:
    cx[u,v,i] <= x[u,v];

subject to c_1_3 {(u,v) in rf_arcs,i in 1..num_comp}:
    cx[u,v,i] >= x[u,v] + c[v,i] - 1;

subject to c_2 {u in 1..num_node}:
    sum {v in 1..num_node: (u,v) in rf_arcs} x[u,v]
    + sum {i in 1..num_comp} y[u,i] = 2;

subject to c_3 {i in 1..num_comp}:
    sum {u in 1..num_node} y[u,i] = 1;

subject to c_4 {v in 1..num_node: v > 1}:
    sum {u in 1..num_node: (u,v) in rf_arcs} x[u,v] = 1;

subject to c_5 {i in 1..num_comp}:
    c[1,i] = 1;

subject to rf_incoming_flow {v in 1..num_node,i in 1..num_comp: v > 1}:
    sum {u in 1..num_node: (u,v) in rf_arcs} cx[u,v,i]
    = c[v,i];

subject to rf_subtree_lower {u in 1..num_node}:
    sum {i in 1..num_comp} c[u,i] >= 2;

subject to rf_subtree_upper {u in 1..num_node}:
    sum {i in 1..num_comp} c[u,i] <= num_node-u+2;

subject to rf_arc_subtree_lower {(u,v) in rf_arcs}:
    sum {i in 1..num_comp} cx[u,v,i] >= 2*x[u,v];

subject to rf_arc_subtree_upper {(u,v) in rf_arcs}:
    sum {i in 1..num_comp} cx[u,v,i] <= (num_node-v+2)*x[u,v];

data;

param num_comp:= 38;
param num_node:= 37;
param dist:= 19;

param DSM:=

[*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38:=
1	1	0	1	1	0	0	0	1	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	1	0	0
2	0	1	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
3	1	0	1	0	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	1	0	0
4	1	0	0	1	0	0	0	1	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	1	0	0
5	0	0	0	0	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	1	0
6	0	0	0	0	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
7	0	0	0	0	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0
8	1	1	0	1	0	0	0	1	1	0	0	0	0	0	1	0	0	0	0	0	0	0	1	1	0	0	0	0	1	1	1	1	1	1	1	0	0	0
9	0	1	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0
10	0	0	0	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0
11	1	0	1	0	0	0	0	0	0	0	1	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0
12	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	1	0
13	0	0	0	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
14	0	0	1	1	0	0	0	0	0	1	1	0	1	1	1	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
15	0	0	1	0	0	0	0	1	0	0	0	0	0	1	1	0	1	0	1	0	0	0	0	0	0	0	1	1	0	1	0	0	0	0	0	0	0	0
16	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0	0
17	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	1	1	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0
18	0	0	0	0	0	0	0	0	0	0	1	0	0	1	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0
19	0	0	0	0	0	0	0	0	0	1	0	0	0	0	1	0	0	0	1	1	0	0	0	0	1	0	0	1	1	1	0	0	0	0	0	0	0	0
20	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	1	0	0	1	0	0	0	0	0	0	0	0	1	0
21	0	0	0	0	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	1	0	1	0	0	0	0	0	0	0	0	1	1
22	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0
23	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	1	1	1	0	0	0	0	0	0	0	1
24	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	1	0	0	0	0	0	1
25	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	0	0	0	1	1	0	1	1	1	0	0	0	0	0	0	0	1
26	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	1	0	1	0	0	0	0	0	0	0	0	1	1
27	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	1	0	0	0	0	0	0	0	0	0	1	1	0	1	0	0	0	0	0	0	0	0
28	0	0	0	0	0	0	0	0	0	0	0	1	0	0	1	0	0	0	1	1	1	0	1	0	1	1	1	1	1	1	0	0	0	0	0	0	0	1
29	0	0	0	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	1	0	0	1	1	1	0	0	0	0	0	0	0	1
30	0	0	1	1	0	0	0	1	1	0	0	0	0	0	1	0	0	0	1	0	0	0	1	0	1	0	1	1	1	1	0	0	0	1	1	0	0	0
31	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	0	0	0	0	0
32	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	1	0	0	0	0	0	1	0	1	0	0	0	0	0	0	1	1	1	0	0	0	0	0
33	1	1	0	0	0	0	0	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	0	0	0	0	0
34	0	0	0	0	0	0	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0
35	0	0	0	0	0	0	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	1	0	0	0
36	1	0	1	1	0	0	0	0	0	0	1	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0
37	0	0	0	0	1	0	0	0	0	0	0	1	0	0	0	0	0	0	0	1	1	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	1	0
38	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	1	1	1	1	0	1	1	0	0	0	0	0	0	0	0	1;
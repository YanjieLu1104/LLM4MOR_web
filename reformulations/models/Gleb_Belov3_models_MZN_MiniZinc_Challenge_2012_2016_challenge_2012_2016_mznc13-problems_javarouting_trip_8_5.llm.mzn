array[int] of int: rf_depot = [8,13,5,15,12,11,6,16,7,19,13,14,14,12,10,14];
set of int: rf_nodes = index_set(rf_depot);
int: rf_n = length(rf_depot);
set of int: rf_vertices = 0..rf_n;
set of int: rf_steps = (min(rf_nodes)+1)..max(rf_nodes);

array[rf_nodes,rf_nodes] of int: rf_distance =
array2d(rf_nodes,rf_nodes,[
0,15,7,12,4,19,9,1,4,13,20,18,20,1,4,5,
15,0,6,3,8,16,17,10,10,3,1,5,6,2,11,5,
7,6,0,2,1,18,2,13,14,14,8,19,14,1,5,11,
12,3,2,0,9,18,3,18,5,16,12,10,5,6,20,19,
4,8,1,9,0,9,1,10,12,6,20,17,4,8,7,19,
19,16,18,18,9,0,8,8,11,6,12,19,17,10,16,4,
9,17,2,3,1,8,0,11,18,13,8,11,12,15,4,12,
1,10,13,18,10,8,11,0,2,18,7,16,9,1,9,12,
4,10,14,5,12,11,18,2,0,4,19,18,7,16,19,13,
13,3,14,16,6,6,13,18,4,0,6,10,12,14,5,17,
20,1,8,12,20,12,8,7,19,6,0,1,18,1,9,1,
18,5,19,10,17,19,11,16,18,10,1,0,4,9,12,6,
20,6,14,5,4,17,12,9,7,12,18,4,0,5,4,8,
1,2,1,6,8,10,15,1,16,14,1,9,5,0,1,9,
4,11,5,20,7,16,4,9,19,5,9,12,4,1,0,6,
5,5,11,19,19,4,12,12,13,17,1,6,8,9,6,0
]);

var 0..15: chooseOrder258;
var 0..15: chooseOrder296;
var 0..15: chooseOrder336;
var 0..15: chooseOrder378;
var 0..15: chooseOrder422;
var 0..15: chooseOrder468;
var 0..15: chooseOrder516;
var 0..15: chooseOrder566;
var 0..15: chooseOrder618;
var 0..15: chooseOrder672;
var 0..15: chooseOrder728;
var 0..15: chooseOrder786;
var 0..15: chooseOrder846;
var 0..15: chooseOrder908;
var 0..15: chooseOrder972;
var 0..15: chooseOrder1038;

var 6..21: listget1151;
var 0..15: chosenIndex1224;
var 1..16: initialFieldValueslocationID1226;
var 5..19: mapget1316;
var 6..21: listget1388;
var 0..15: chosenIndex1445;
var 1..16: initialFieldValueslocationID1447;
var 33..48: mapget1464;
var 0..20: mapget2057;
var 5..39: binop2827 = mapget1316 + mapget2057;
var 6..21: listget2850;
var 0..15: chosenIndex2907;
var 1..16: initialFieldValueslocationID2909;
var 33..48: mapget2926;
var 0..20: mapget2959;
var 5..59: binop3729 = binop2827 + mapget2959;
var 6..21: listget3752;
var 0..15: chosenIndex3809;
var 1..16: initialFieldValueslocationID3811;
var 33..48: mapget3828;
var 0..20: mapget3861;
var 5..79: binop4631 = binop3729 + mapget3861;
var 6..21: listget4654;
var 0..15: chosenIndex4711;
var 1..16: initialFieldValueslocationID4713;
var 33..48: mapget4730;
var 0..20: mapget4763;
var 5..99: binop5533 = binop4631 + mapget4763;
var 6..21: listget5556;
var 0..15: chosenIndex5613;
var 1..16: initialFieldValueslocationID5615;
var 33..48: mapget5632;
var 0..20: mapget5665;
var 5..119: binop6435 = binop5533 + mapget5665;
var 6..21: listget6458;
var 0..15: chosenIndex6515;
var 1..16: initialFieldValueslocationID6517;
var 33..48: mapget6534;
var 0..20: mapget6567;
var 5..139: binop7337 = binop6435 + mapget6567;
var 6..21: listget7360;
var 0..15: chosenIndex7417;
var 1..16: initialFieldValueslocationID7419;
var 33..48: mapget7436;
var 0..20: mapget7469;
var 5..159: binop8239 = binop7337 + mapget7469;
var 6..21: listget8262;
var 0..15: chosenIndex8319;
var 1..16: initialFieldValueslocationID8321;
var 33..48: mapget8338;
var 0..20: mapget8371;
var 5..179: binop9141 = binop8239 + mapget8371;
var 6..21: listget9164;
var 0..15: chosenIndex9221;
var 1..16: initialFieldValueslocationID9223;
var 33..48: mapget9240;
var 0..20: mapget9273;
var 5..199: binop10043 = binop9141 + mapget9273;
var 6..21: listget10066;
var 0..15: chosenIndex10123;
var 1..16: initialFieldValueslocationID10125;
var 33..48: mapget10142;
var 0..20: mapget10175;
var 5..219: binop10945 = binop10043 + mapget10175;
var 6..21: listget10968;
var 0..15: chosenIndex11025;
var 1..16: initialFieldValueslocationID11027;
var 33..48: mapget11044;
var 0..20: mapget11077;
var 5..239: binop11847 = binop10945 + mapget11077;
var 6..21: listget11870;
var 0..15: chosenIndex11927;
var 1..16: initialFieldValueslocationID11929;
var 33..48: mapget11946;
var 0..20: mapget11979;
var 5..259: binop12749 = binop11847 + mapget11979;
var 6..21: listget12772;
var 0..15: chosenIndex12829;
var 1..16: initialFieldValueslocationID12831;
var 33..48: mapget12848;
var 0..20: mapget12881;
var 5..279: binop13651 = binop12749 + mapget12881;
var 6..21: listget13674;
var 0..15: chosenIndex13731;
var 1..16: initialFieldValueslocationID13733;
var 33..48: mapget13750;
var 0..20: mapget13783;
var 5..299: binop14553 = binop13651 + mapget13783;
var 6..21: listget14576;
var 0..15: chosenIndex14633;
var 1..16: initialFieldValueslocationID14635;
var 33..48: mapget14652;
var 0..20: mapget14685;
var 5..319: binop15455 = binop14553 + mapget14685;
var 33..48: mapget15488;
var 5..19: mapget15521;
var 10..338: objective = binop15455 + mapget15521;

var 0..319: expectedArrivalTime15784;
var 0..319: expectedArrivalTime15787;
var 0..319: expectedArrivalTime15798;
var 0..319: expectedArrivalTime15801;
var 0..319: expectedArrivalTime15812;
var 0..319: expectedArrivalTime15815;
var 0..319: expectedArrivalTime15826;
var 0..319: expectedArrivalTime15829;
var 0..319: expectedArrivalTime15840;
var 0..319: expectedArrivalTime15843;
var 0..319: expectedArrivalTime15854;
var 0..319: expectedArrivalTime15857;
var 0..319: expectedArrivalTime15868;
var 0..319: expectedArrivalTime15871;
var 0..319: expectedArrivalTime15882;
var 0..319: expectedArrivalTime15885;

var 1..17: expectedArrivalTimeX16;
var 1..17: expectedArrivalTimeX17;
var 1..17: expectedArrivalTimeX18;
var 1..17: expectedArrivalTimeX19;
var 1..17: expectedArrivalTimeX20;
var 1..17: expectedArrivalTimeX21;
var 1..17: expectedArrivalTimeX22;
var 1..17: expectedArrivalTimeX23;
var 1..17: expectedArrivalTimeX24;
var 1..17: expectedArrivalTimeX25;
var 1..17: expectedArrivalTimeX26;
var 1..17: expectedArrivalTimeX27;
var 1..17: expectedArrivalTimeX28;
var 1..17: expectedArrivalTimeX29;
var 1..17: expectedArrivalTimeX30;
var 1..17: expectedArrivalTimeX31;

var 1..17: listget1151X;
var 1..17: listget1388X;
var 1..17: listget2850X;
var 1..17: listget3752X;
var 1..17: listget4654X;
var 1..17: listget5556X;
var 1..17: listget6458X;
var 1..17: listget7360X;
var 1..17: listget8262X;
var 1..17: listget9164X;
var 1..17: listget10066X;
var 1..17: listget10968X;
var 1..17: listget11870X;
var 1..17: listget12772X;
var 1..17: listget13674X;
var 1..17: listget14576X;

var 1..16: mapget1316X;
var 1..16: mapget1464X;
var 1..256: mapget2057X;
var 1..16: mapget2926X;
var 1..256: mapget2959X;
var 1..16: mapget3828X;
var 1..256: mapget3861X;
var 1..16: mapget4730X;
var 1..256: mapget4763X;
var 1..16: mapget5632X;
var 1..256: mapget5665X;
var 1..16: mapget6534X;
var 1..256: mapget6567X;
var 1..16: mapget7436X;
var 1..256: mapget7469X;
var 1..16: mapget8338X;
var 1..256: mapget8371X;
var 1..16: mapget9240X;
var 1..256: mapget9273X;
var 1..16: mapget10142X;
var 1..256: mapget10175X;
var 1..16: mapget11044X;
var 1..256: mapget11077X;
var 1..16: mapget11946X;
var 1..256: mapget11979X;
var 1..16: mapget12848X;
var 1..256: mapget12881X;
var 1..16: mapget13750X;
var 1..256: mapget13783X;
var 1..16: mapget14652X;
var 1..256: mapget14685X;
var 1..16: mapget15488X;
var 1..16: mapget15521X;

array[rf_nodes] of var int: rf_order = [
chooseOrder258,chooseOrder296,chooseOrder336,chooseOrder378,
chooseOrder422,chooseOrder468,chooseOrder516,chooseOrder566,
chooseOrder618,chooseOrder672,chooseOrder728,chooseOrder786,
chooseOrder846,chooseOrder908,chooseOrder972,chooseOrder1038
];

array[rf_nodes] of var int: rf_location = [
initialFieldValueslocationID1226,initialFieldValueslocationID1447,
initialFieldValueslocationID2909,initialFieldValueslocationID3811,
initialFieldValueslocationID4713,initialFieldValueslocationID5615,
initialFieldValueslocationID6517,initialFieldValueslocationID7419,
initialFieldValueslocationID8321,initialFieldValueslocationID9223,
initialFieldValueslocationID10125,initialFieldValueslocationID11027,
initialFieldValueslocationID11929,initialFieldValueslocationID12831,
initialFieldValueslocationID13733,initialFieldValueslocationID14635
];

array[rf_nodes] of var int: rf_chosen = [
chosenIndex1224,chosenIndex1445,chosenIndex2907,chosenIndex3809,
chosenIndex4711,chosenIndex5613,chosenIndex6515,chosenIndex7417,
chosenIndex8319,chosenIndex9221,chosenIndex10123,chosenIndex11025,
chosenIndex11927,chosenIndex12829,chosenIndex13731,chosenIndex14633
];

array[rf_nodes] of var int: rf_list = [
listget1151,listget1388,listget2850,listget3752,
listget4654,listget5556,listget6458,listget7360,
listget8262,listget9164,listget10066,listget10968,
listget11870,listget12772,listget13674,listget14576
];

array[rf_nodes] of var int: rf_list_index = [
listget1151X,listget1388X,listget2850X,listget3752X,
listget4654X,listget5556X,listget6458X,listget7360X,
listget8262X,listget9164X,listget10066X,listget10968X,
listget11870X,listget12772X,listget13674X,listget14576X
];

array[rf_nodes] of var int: rf_row = [
mapget1464,mapget2926,mapget3828,mapget4730,
mapget5632,mapget6534,mapget7436,mapget8338,
mapget9240,mapget10142,mapget11044,mapget11946,
mapget12848,mapget13750,mapget14652,mapget15488
];

array[rf_nodes] of var int: rf_row_index = [
mapget1464X,mapget2926X,mapget3828X,mapget4730X,
mapget5632X,mapget6534X,mapget7436X,mapget8338X,
mapget9240X,mapget10142X,mapget11044X,mapget11946X,
mapget12848X,mapget13750X,mapget14652X,mapget15488X
];

array[rf_steps] of var int: rf_leg = array1d(rf_steps,[
mapget2057,mapget2959,mapget3861,mapget4763,mapget5665,
mapget6567,mapget7469,mapget8371,mapget9273,mapget10175,
mapget11077,mapget11979,mapget12881,mapget13783,mapget14685
]);

array[rf_steps] of var int: rf_leg_index = array1d(rf_steps,[
mapget2057X,mapget2959X,mapget3861X,mapget4763X,mapget5665X,
mapget6567X,mapget7469X,mapget8371X,mapget9273X,mapget10175X,
mapget11077X,mapget11979X,mapget12881X,mapget13783X,mapget14685X
]);

array[rf_nodes] of var int: rf_prefix = [
mapget1316,binop2827,binop3729,binop4631,
binop5533,binop6435,binop7337,binop8239,
binop9141,binop10043,binop10945,binop11847,
binop12749,binop13651,binop14553,binop15455
];

array[rf_nodes] of var int: rf_arrival = [
expectedArrivalTime15784,expectedArrivalTime15787,
expectedArrivalTime15798,expectedArrivalTime15801,
expectedArrivalTime15812,expectedArrivalTime15815,
expectedArrivalTime15826,expectedArrivalTime15829,
expectedArrivalTime15840,expectedArrivalTime15843,
expectedArrivalTime15854,expectedArrivalTime15857,
expectedArrivalTime15868,expectedArrivalTime15871,
expectedArrivalTime15882,expectedArrivalTime15885
];

array[rf_nodes] of var int: rf_arrival_index = [
expectedArrivalTimeX16,expectedArrivalTimeX17,
expectedArrivalTimeX18,expectedArrivalTimeX19,
expectedArrivalTimeX20,expectedArrivalTimeX21,
expectedArrivalTimeX22,expectedArrivalTimeX23,
expectedArrivalTimeX24,expectedArrivalTimeX25,
expectedArrivalTimeX26,expectedArrivalTimeX27,
expectedArrivalTimeX28,expectedArrivalTimeX29,
expectedArrivalTimeX30,expectedArrivalTimeX31
];

array[rf_nodes,rf_nodes] of var 0..1: rf_assignment;
array[rf_vertices,rf_vertices] of var 0..1: rf_arc;

constraint forall(rf_p in rf_nodes)(
    sum(rf_i in rf_nodes)(rf_assignment[rf_p,rf_i]) = 1
);
constraint forall(rf_i in rf_nodes)(
    sum(rf_p in rf_nodes)(rf_assignment[rf_p,rf_i]) = 1
);

constraint forall(rf_i in rf_nodes)(
    rf_order[rf_i] =
        sum(rf_p in rf_nodes)((rf_p-1)*rf_assignment[rf_p,rf_i])
);
constraint forall(rf_p in rf_nodes)(
    rf_location[rf_p] =
        sum(rf_i in rf_nodes)(rf_i*rf_assignment[rf_p,rf_i])
);

constraint forall(rf_p in rf_nodes)(
    rf_chosen[rf_p] = rf_location[rf_p]-1 /\
    rf_list[rf_p] = rf_location[rf_p]+5 /\
    rf_list_index[rf_p] = rf_location[rf_p]+1 /\
    rf_row[rf_p] = rf_location[rf_p]+32 /\
    rf_row_index[rf_p] = rf_location[rf_p]
);
constraint forall(rf_i in rf_nodes)(
    rf_arrival_index[rf_i] = rf_order[rf_i]+2
);
constraint forall(rf_p in rf_steps)(
    rf_leg_index[rf_p] =
        rf_n*(rf_location[rf_p-1]-1)+rf_location[rf_p] /\
    rf_leg[rf_p] >= 1
);
constraint mapget1316X = rf_location[min(rf_nodes)];
constraint mapget15521X = rf_location[max(rf_nodes)];

constraint forall(rf_i in rf_vertices)(
    rf_arc[rf_i,rf_i] = 0 /\
    sum(rf_j in rf_vertices)(rf_arc[rf_i,rf_j]) = 1 /\
    sum(rf_j in rf_vertices)(rf_arc[rf_j,rf_i]) = 1
);

constraint forall(rf_i in rf_nodes where rf_i mod 2 = 0)(
    rf_arc[0,rf_i] = 0 /\
    rf_arc[rf_i-1,0] = 0 /\
    rf_arc[rf_i,rf_i-1] = 0 /\
    rf_order[rf_i-1]+1 <= rf_order[rf_i] /\
    rf_arrival[rf_i-1]+1 <= rf_arrival[rf_i]
);

constraint forall(rf_i in rf_nodes)(
    rf_order[rf_i] <= (rf_n-1)*(1-rf_arc[0,rf_i]) /\
    rf_order[rf_i] >= (rf_n-1)*rf_arc[rf_i,0]
);

constraint forall(rf_i,rf_j in rf_nodes
                  where rf_i != rf_j /\
                  not (rf_i mod 2 = 0 /\ rf_j = rf_i-1))(
    rf_order[rf_j] >=
        rf_order[rf_i]+1-rf_n*(1-rf_arc[rf_i,rf_j]) /\
    rf_order[rf_j] <=
        rf_order[rf_i]+1+(rf_n-2)*(1-rf_arc[rf_i,rf_j])
);

constraint forall(rf_i in rf_nodes)(
    rf_arrival[rf_i] >= 5+rf_order[rf_i] /\
    rf_arrival[rf_i] <= 19+20*rf_order[rf_i]
);

constraint forall(rf_i in rf_nodes where rf_i mod 2 = 1)(
    rf_arrival[rf_i] >=
        rf_depot[rf_i]-(rf_depot[rf_i]-5)*(1-rf_arc[0,rf_i]) /\
    rf_arrival[rf_i] <=
        rf_depot[rf_i]+(319-rf_depot[rf_i])*(1-rf_arc[0,rf_i])
);

constraint forall(rf_i,rf_j in rf_nodes
                  where rf_i != rf_j /\
                  not (rf_i mod 2 = 0 /\ rf_j = rf_i-1))(
    rf_arrival[rf_j] >=
        rf_arrival[rf_i]+rf_distance[rf_i,rf_j]
        -(314+rf_distance[rf_i,rf_j])*(1-rf_arc[rf_i,rf_j]) /\
    rf_arrival[rf_j] <=
        rf_arrival[rf_i]+rf_distance[rf_i,rf_j]
        +(314-rf_distance[rf_i,rf_j])*(1-rf_arc[rf_i,rf_j])
);

constraint mapget1316 =
    sum(rf_i in rf_nodes)(rf_depot[rf_i]*rf_arc[0,rf_i]);
constraint mapget15521 =
    sum(rf_i in rf_nodes)(rf_depot[rf_i]*rf_arc[rf_i,0]);

constraint forall(rf_p in rf_nodes)(
    rf_prefix[rf_p] >= rf_p+4 /\
    rf_prefix[rf_p] <= 19+20*(rf_p-1)
);

constraint forall(rf_p,rf_i in rf_nodes)(
    rf_prefix[rf_p] >=
        rf_arrival[rf_i]-(319-rf_p-4)*(1-rf_assignment[rf_p,rf_i]) /\
    rf_prefix[rf_p] <=
        rf_arrival[rf_i]+(14+20*(rf_p-1))*(1-rf_assignment[rf_p,rf_i])
);

constraint objective =
    sum(rf_i in rf_nodes)(
        rf_depot[rf_i]*(rf_arc[0,rf_i]+rf_arc[rf_i,0])
    )
    + sum(rf_i,rf_j in rf_nodes where rf_i != rf_j)(
        rf_distance[rf_i,rf_j]*rf_arc[rf_i,rf_j]
    );

constraint forall(rf_i,rf_j in rf_vertices where rf_i < rf_j)(
    rf_arc[rf_i,rf_j]+rf_arc[rf_j,rf_i] <= 1
);

constraint forall(rf_i,rf_j,rf_k in rf_vertices
                  where rf_i < rf_j /\ rf_j < rf_k)(
    rf_arc[rf_i,rf_j]+rf_arc[rf_j,rf_i]
    +rf_arc[rf_i,rf_k]+rf_arc[rf_k,rf_i]
    +rf_arc[rf_j,rf_k]+rf_arc[rf_k,rf_j] <= 2
);

solve minimize objective;

output [
    "objective = ",show(objective),
    ";\n_opt:chooseOrder258:",show(chooseOrder258),
    ";\n_opt:chooseOrder296:",show(chooseOrder296),
    ";\n_opt:chooseOrder336:",show(chooseOrder336),
    ";\n_opt:chooseOrder378:",show(chooseOrder378),
    ";\n_opt:chooseOrder422:",show(chooseOrder422),
    ";\n_opt:chooseOrder468:",show(chooseOrder468),
    ";\n_opt:chooseOrder516:",show(chooseOrder516),
    ";\n_opt:chooseOrder566:",show(chooseOrder566),
    ";\n_opt:chooseOrder618:",show(chooseOrder618),
    ";\n_opt:chooseOrder672:",show(chooseOrder672),
    ";\n_opt:chooseOrder728:",show(chooseOrder728),
    ";\n_opt:chooseOrder786:",show(chooseOrder786),
    ";\n_opt:chooseOrder846:",show(chooseOrder846),
    ";\n_opt:chooseOrder908:",show(chooseOrder908),
    ";\n_opt:chooseOrder972:",show(chooseOrder972),
    ";\n_opt:chooseOrder1038:",show(chooseOrder1038),
    ";\n"
];
array[int] of int: rf_depot = [15,1,2,10,6,7,13,7,2,3,19,16];
set of int: rf_sites = index_set(rf_depot);
int: rf_n = length(rf_depot);
set of int: rf_nodes = 0..rf_n;

array[rf_sites,rf_sites] of int: rf_distance =
array2d(rf_sites,rf_sites,[
0,11,9,5,3,17,6,14,15,9,8,3,
11,0,3,20,18,18,16,19,14,16,7,11,
9,3,0,2,15,7,19,16,8,5,11,10,
5,20,2,0,2,20,14,3,18,15,11,6,
3,18,15,2,0,12,18,9,10,20,7,1,
17,18,7,20,12,0,20,13,13,2,6,7,
6,16,19,14,18,20,0,18,15,18,16,16,
14,19,16,3,9,13,18,0,11,10,7,11,
15,14,8,18,10,13,15,11,0,10,12,7,
9,16,5,15,20,2,18,10,10,0,8,4,
8,7,11,11,7,6,16,7,12,8,0,14,
3,11,10,6,1,7,16,11,7,4,14,0
]);

var 0..11: chooseOrder150;
var 0..11: chooseOrder180;
var 0..11: chooseOrder212;
var 0..11: chooseOrder246;
var 0..11: chooseOrder282;
var 0..11: chooseOrder320;
var 0..11: chooseOrder360;
var 0..11: chooseOrder402;
var 0..11: chooseOrder446;
var 0..11: chooseOrder492;
var 0..11: chooseOrder540;
var 0..11: chooseOrder590;

var 6..17: listget679;
var 0..11: chosenIndex736;
var 1..12: initialFieldValueslocationID738;
var 1..19: mapget812;
var 6..17: listget868;
var 0..11: chosenIndex913;
var 1..12: initialFieldValueslocationID915;
var 29..40: mapget932;
var 0..20: mapget1281;
var 1..39: binop1715 = mapget812 + mapget1281;
var 6..17: listget1734;
var 0..11: chosenIndex1779;
var 1..12: initialFieldValueslocationID1781;
var 29..40: mapget1798;
var 0..20: mapget1823;
var 1..59: binop2257 = binop1715 + mapget1823;
var 6..17: listget2276;
var 0..11: chosenIndex2321;
var 1..12: initialFieldValueslocationID2323;
var 29..40: mapget2340;
var 0..20: mapget2365;
var 1..79: binop2799 = binop2257 + mapget2365;
var 6..17: listget2818;
var 0..11: chosenIndex2863;
var 1..12: initialFieldValueslocationID2865;
var 29..40: mapget2882;
var 0..20: mapget2907;
var 1..99: binop3341 = binop2799 + mapget2907;
var 6..17: listget3360;
var 0..11: chosenIndex3405;
var 1..12: initialFieldValueslocationID3407;
var 29..40: mapget3424;
var 0..20: mapget3449;
var 1..119: binop3883 = binop3341 + mapget3449;
var 6..17: listget3902;
var 0..11: chosenIndex3947;
var 1..12: initialFieldValueslocationID3949;
var 29..40: mapget3966;
var 0..20: mapget3991;
var 1..139: binop4425 = binop3883 + mapget3991;
var 6..17: listget4444;
var 0..11: chosenIndex4489;
var 1..12: initialFieldValueslocationID4491;
var 29..40: mapget4508;
var 0..20: mapget4533;
var 1..159: binop4967 = binop4425 + mapget4533;
var 6..17: listget4986;
var 0..11: chosenIndex5031;
var 1..12: initialFieldValueslocationID5033;
var 29..40: mapget5050;
var 0..20: mapget5075;
var 1..179: binop5509 = binop4967 + mapget5075;
var 6..17: listget5528;
var 0..11: chosenIndex5573;
var 1..12: initialFieldValueslocationID5575;
var 29..40: mapget5592;
var 0..20: mapget5617;
var 1..199: binop6051 = binop5509 + mapget5617;
var 6..17: listget6070;
var 0..11: chosenIndex6115;
var 1..12: initialFieldValueslocationID6117;
var 29..40: mapget6134;
var 0..20: mapget6159;
var 1..219: binop6593 = binop6051 + mapget6159;
var 6..17: listget6612;
var 0..11: chosenIndex6657;
var 1..12: initialFieldValueslocationID6659;
var 29..40: mapget6676;
var 0..20: mapget6701;
var 1..239: binop7135 = binop6593 + mapget6701;
var 29..40: mapget7164;
var 1..19: mapget7189;
var 2..258: objective = binop7135 + mapget7189;

var 0..239: expectedArrivalTime7354;
var 0..239: expectedArrivalTime7357;
var 0..239: expectedArrivalTime7368;
var 0..239: expectedArrivalTime7371;
var 0..239: expectedArrivalTime7382;
var 0..239: expectedArrivalTime7385;
var 0..239: expectedArrivalTime7396;
var 0..239: expectedArrivalTime7399;
var 0..239: expectedArrivalTime7410;
var 0..239: expectedArrivalTime7413;
var 0..239: expectedArrivalTime7424;
var 0..239: expectedArrivalTime7427;

var 1..13: expectedArrivalTimeX12;
var 1..13: expectedArrivalTimeX13;
var 1..13: expectedArrivalTimeX14;
var 1..13: expectedArrivalTimeX15;
var 1..13: expectedArrivalTimeX16;
var 1..13: expectedArrivalTimeX17;
var 1..13: expectedArrivalTimeX18;
var 1..13: expectedArrivalTimeX19;
var 1..13: expectedArrivalTimeX20;
var 1..13: expectedArrivalTimeX21;
var 1..13: expectedArrivalTimeX22;
var 1..13: expectedArrivalTimeX23;

var 1..13: listget679X;
var 1..13: listget868X;
var 1..13: listget1734X;
var 1..13: listget2276X;
var 1..13: listget2818X;
var 1..13: listget3360X;
var 1..13: listget3902X;
var 1..13: listget4444X;
var 1..13: listget4986X;
var 1..13: listget5528X;
var 1..13: listget6070X;
var 1..13: listget6612X;

var 1..12: mapget812X;
var 1..12: mapget932X;
var 1..144: mapget1281X;
var 1..12: mapget1798X;
var 1..144: mapget1823X;
var 1..12: mapget2340X;
var 1..144: mapget2365X;
var 1..12: mapget2882X;
var 1..144: mapget2907X;
var 1..12: mapget3424X;
var 1..144: mapget3449X;
var 1..12: mapget3966X;
var 1..144: mapget3991X;
var 1..12: mapget4508X;
var 1..144: mapget4533X;
var 1..12: mapget5050X;
var 1..144: mapget5075X;
var 1..12: mapget5592X;
var 1..144: mapget5617X;
var 1..12: mapget6134X;
var 1..144: mapget6159X;
var 1..12: mapget6676X;
var 1..144: mapget6701X;
var 1..12: mapget7164X;
var 1..12: mapget7189X;

array[int] of var int: rf_order = [
chooseOrder150,chooseOrder180,chooseOrder212,chooseOrder246,
chooseOrder282,chooseOrder320,chooseOrder360,chooseOrder402,
chooseOrder446,chooseOrder492,chooseOrder540,chooseOrder590
];

array[int] of var int: rf_location = [
initialFieldValueslocationID738,initialFieldValueslocationID915,
initialFieldValueslocationID1781,initialFieldValueslocationID2323,
initialFieldValueslocationID2865,initialFieldValueslocationID3407,
initialFieldValueslocationID3949,initialFieldValueslocationID4491,
initialFieldValueslocationID5033,initialFieldValueslocationID5575,
initialFieldValueslocationID6117,initialFieldValueslocationID6659
];

array[int] of var int: rf_chosen = [
chosenIndex736,chosenIndex913,chosenIndex1779,chosenIndex2321,
chosenIndex2863,chosenIndex3405,chosenIndex3947,chosenIndex4489,
chosenIndex5031,chosenIndex5573,chosenIndex6115,chosenIndex6657
];

array[int] of var int: rf_list = [
listget679,listget868,listget1734,listget2276,
listget2818,listget3360,listget3902,listget4444,
listget4986,listget5528,listget6070,listget6612
];

array[int] of var int: rf_list_lookup = [
listget679X,listget868X,listget1734X,listget2276X,
listget2818X,listget3360X,listget3902X,listget4444X,
listget4986X,listget5528X,listget6070X,listget6612X
];

array[int] of var int: rf_time = [
expectedArrivalTime7354,expectedArrivalTime7357,
expectedArrivalTime7368,expectedArrivalTime7371,
expectedArrivalTime7382,expectedArrivalTime7385,
expectedArrivalTime7396,expectedArrivalTime7399,
expectedArrivalTime7410,expectedArrivalTime7413,
expectedArrivalTime7424,expectedArrivalTime7427
];

array[int] of var int: rf_time_lookup = [
expectedArrivalTimeX12,expectedArrivalTimeX13,
expectedArrivalTimeX14,expectedArrivalTimeX15,
expectedArrivalTimeX16,expectedArrivalTimeX17,
expectedArrivalTimeX18,expectedArrivalTimeX19,
expectedArrivalTimeX20,expectedArrivalTimeX21,
expectedArrivalTimeX22,expectedArrivalTimeX23
];

array[int] of var int: rf_prefix = [
mapget812,binop1715,binop2257,binop2799,
binop3341,binop3883,binop4425,binop4967,
binop5509,binop6051,binop6593,binop7135
];

array[int] of var int: rf_leg = [
mapget1281,mapget1823,mapget2365,mapget2907,
mapget3449,mapget3991,mapget4533,mapget5075,
mapget5617,mapget6159,mapget6701
];

array[int] of var int: rf_row = [
mapget932,mapget1798,mapget2340,mapget2882,
mapget3424,mapget3966,mapget4508,mapget5050,
mapget5592,mapget6134,mapget6676,mapget7164
];

array[int] of var int: rf_row_lookup = [
mapget932X,mapget1798X,mapget2340X,mapget2882X,
mapget3424X,mapget3966X,mapget4508X,mapget5050X,
mapget5592X,mapget6134X,mapget6676X,mapget7164X
];

array[int] of var int: rf_leg_lookup = [
mapget1281X,mapget1823X,mapget2365X,mapget2907X,
mapget3449X,mapget3991X,mapget4533X,mapget5075X,
mapget5617X,mapget6159X,mapget6701X
];

array[rf_sites,rf_sites] of var 0..1: rf_assignment;
array[rf_nodes,rf_nodes] of var 0..1: rf_arc;
array[rf_nodes,rf_nodes] of var 0.0..int2float(rf_n): rf_flow;

constraint forall(rf_i in rf_sites)(
    sum(rf_p in rf_sites)(rf_assignment[rf_i,rf_p]) = 1
);

constraint forall(rf_p in rf_sites)(
    sum(rf_i in rf_sites)(rf_assignment[rf_i,rf_p]) = 1
);

constraint forall(rf_i in rf_sites)(
    rf_order[rf_i] =
        sum(rf_p in rf_sites)((rf_p-1)*rf_assignment[rf_i,rf_p])
);

constraint forall(rf_p in rf_sites)(
    rf_location[rf_p] =
        sum(rf_i in rf_sites)(rf_i*rf_assignment[rf_i,rf_p])
);

constraint forall(rf_p in index_set(rf_location))(
    rf_chosen[rf_p] = rf_location[rf_p]-1 /\
    rf_list[rf_p] = rf_location[rf_p]+5 /\
    rf_list_lookup[rf_p] = rf_location[rf_p]+1 /\
    rf_row[rf_p] = rf_location[rf_p]+28 /\
    rf_row_lookup[rf_p] = rf_location[rf_p]
);

constraint forall(rf_i in index_set(rf_time_lookup))(
    rf_time_lookup[rf_i] = rf_order[rf_i]+2
);

constraint forall(rf_p in index_set(rf_leg_lookup))(
    rf_leg_lookup[rf_p] =
        rf_n*(rf_location[rf_p]-1)+rf_location[rf_p+1]
);

constraint mapget812X = rf_location[1];
constraint mapget7189X = rf_location[rf_n];

constraint mapget812 in {15,1,2,10,6,7,13,3,19,16};
constraint mapget7189 in {15,1,2,10,6,7,13,3,19,16};

constraint mapget812 =
    sum(rf_i in rf_sites)(rf_depot[rf_i]*rf_assignment[rf_i,1]);

constraint mapget7189 =
    sum(rf_i in rf_sites)(rf_depot[rf_i]*rf_assignment[rf_i,rf_n]);

constraint forall(rf_i in rf_nodes)(
    rf_arc[rf_i,rf_i] = 0 /\
    sum(rf_j in rf_nodes)(rf_arc[rf_i,rf_j]) = 1 /\
    sum(rf_j in rf_nodes)(rf_arc[rf_j,rf_i]) = 1
);

constraint forall(rf_i in rf_sites)(
    rf_arc[0,rf_i] = rf_assignment[rf_i,1] /\
    rf_arc[rf_i,0] = rf_assignment[rf_i,rf_n]
);

constraint forall(rf_i,rf_j in rf_sites where rf_i != rf_j)(
    rf_order[rf_j] >=
        rf_order[rf_i]+1-rf_n*(1-rf_arc[rf_i,rf_j]) /\
    rf_order[rf_j] <=
        rf_order[rf_i]+1+rf_n*(1-rf_arc[rf_i,rf_j])
);

constraint forall(rf_i in rf_sites where rf_i mod 2 = 1)(
    rf_order[rf_i]+1 <= rf_order[rf_i+1] /\
    rf_time[rf_i] <= rf_time[rf_i+1] /\
    rf_arc[rf_i+1,rf_i] = 0 /\
    rf_arc[0,rf_i+1] = 0 /\
    rf_arc[rf_i,0] = 0
);

constraint forall(rf_i,rf_j in rf_nodes where rf_i < rf_j)(
    rf_arc[rf_i,rf_j]+rf_arc[rf_j,rf_i] <= 1
);

constraint forall(rf_i in rf_sites)(
    rf_time[rf_i] >= rf_depot[rf_i]*rf_arc[0,rf_i] /\
    rf_time[rf_i] <=
        rf_depot[rf_i]+(239-rf_depot[rf_i])*(1-rf_arc[0,rf_i])
);

constraint forall(rf_i,rf_j in rf_sites where rf_i != rf_j)(
    rf_time[rf_j] >=
        rf_time[rf_i]+rf_distance[rf_i,rf_j]
        -(239+rf_distance[rf_i,rf_j])*(1-rf_arc[rf_i,rf_j]) /\
    rf_time[rf_j] <=
        rf_time[rf_i]+rf_distance[rf_i,rf_j]
        +(239-rf_distance[rf_i,rf_j])*(1-rf_arc[rf_i,rf_j])
);

constraint forall(rf_i,rf_p in rf_sites)(
    rf_prefix[rf_p]-rf_time[rf_i] <=
        239*(1-rf_assignment[rf_i,rf_p]) /\
    rf_time[rf_i]-rf_prefix[rf_p] <=
        239*(1-rf_assignment[rf_i,rf_p])
);

constraint forall(rf_p in index_set(rf_leg))(
    rf_leg[rf_p] = rf_prefix[rf_p+1]-rf_prefix[rf_p] /\
    rf_leg[rf_p] >= 1
);

constraint forall(rf_i,rf_j in rf_nodes)(
    rf_flow[rf_i,rf_j] <= rf_n*rf_arc[rf_i,rf_j]
);

constraint forall(rf_i in rf_nodes)(
    rf_flow[rf_i,0] = 0.0
);

constraint forall(rf_i,rf_j in rf_sites)(
    rf_flow[rf_i,rf_j] <= (rf_n-1)*rf_arc[rf_i,rf_j]
);

constraint forall(rf_i in rf_sites)(
    sum(rf_j in rf_nodes)(rf_flow[rf_j,rf_i])
    - sum(rf_j in rf_nodes)(rf_flow[rf_i,rf_j]) = 1.0
);

constraint sum(rf_i in rf_sites)(rf_flow[0,rf_i]) = rf_n;

constraint objective =
    sum(rf_i in rf_sites)(
        rf_depot[rf_i]*(rf_arc[0,rf_i]+rf_arc[rf_i,0])
    )
    + sum(rf_i,rf_j in rf_sites where rf_i != rf_j)(
        rf_distance[rf_i,rf_j]*rf_arc[rf_i,rf_j]
    );

solve minimize objective;
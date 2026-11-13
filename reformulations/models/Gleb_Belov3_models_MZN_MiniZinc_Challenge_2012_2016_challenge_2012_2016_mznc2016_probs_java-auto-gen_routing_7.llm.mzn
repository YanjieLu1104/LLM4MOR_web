array[1..14] of int: valuesToOrder_2 = [40,43,46,49,52,55,58,61,64,67,70,73,76,79];

set of int: rf7_customers = index_set(valuesToOrder_2);
int: rf7_n = length(valuesToOrder_2);
set of int: rf7_nodes = 0..max(rf7_customers);

array[1..length(valuesToOrder_2)+1] of int: rf7_depot_data =
    [14,11,18,5,1,14,6,3,6,20,17,1,8,5,20];

array[1..length(valuesToOrder_2)+1] of int: rf7_row_keys =
    [22,25,26,27,29,30,31,32,33,34,35,36,37,38,38];

array[1..length(valuesToOrder_2)*length(valuesToOrder_2)+1] of int:
rf7_travel_data =
[
     0,18,10,13,15,11,15,14,18,17,7,8,12,16,
    18,0,1,18,10,7,6,17,9,7,11,1,1,6,
    10,1,0,6,5,1,13,2,15,8,3,3,6,16,
    13,18,6,0,19,6,8,7,17,9,19,8,3,10,
    15,10,5,19,0,16,7,1,9,4,20,17,5,18,
    11,7,1,6,16,0,4,2,20,17,6,3,17,20,
    15,6,13,8,7,4,0,13,10,1,15,14,19,2,
    14,17,2,7,1,2,13,0,11,7,1,6,16,7,
    18,9,15,17,9,20,10,11,0,12,13,1,3,5,
    17,7,8,9,4,17,1,7,12,0,4,5,10,6,
    7,11,3,19,20,6,15,1,13,4,0,1,14,1,
    8,1,3,8,17,3,14,6,1,5,1,0,16,3,
    12,1,6,3,5,17,19,16,3,10,14,16,0,16,
    16,6,16,10,18,20,2,7,5,6,1,3,16,0,
    20
];

array[rf7_nodes, rf7_nodes] of int: rf7_cost =
    array2d(rf7_nodes, rf7_nodes,
        [if rf7_i = rf7_j then 0
         elseif rf7_i = 0 then rf7_depot_data[rf7_j]
         elseif rf7_j = 0 then rf7_depot_data[rf7_i]
         else rf7_travel_data[(rf7_i-1)*rf7_n+rf7_j]
         endif
         | rf7_i in rf7_nodes, rf7_j in rf7_nodes]);

array[index_set_1of2(rf7_cost), index_set_2of2(rf7_cost)]
    of var 0..1: rf7_arc;
array[index_set(valuesToOrder_2)] of var 1..rf7_n: rf7_position;
var 2..300: objective;

constraint forall(rf7_i in rf7_nodes)(
    rf7_arc[rf7_i,rf7_i] = 0
);

constraint forall(rf7_i in rf7_nodes)(
    sum(rf7_j in rf7_nodes)(rf7_arc[rf7_i,rf7_j]) = 1
);

constraint forall(rf7_j in rf7_nodes)(
    sum(rf7_i in rf7_nodes)(rf7_arc[rf7_i,rf7_j]) = 1
);

constraint forall(rf7_i,rf7_j in rf7_customers where rf7_i != rf7_j)(
    rf7_position[rf7_i] - rf7_position[rf7_j]
    + rf7_n * rf7_arc[rf7_i,rf7_j]
    + (rf7_n-2) * rf7_arc[rf7_j,rf7_i]
    <= rf7_n-1
);

constraint forall(rf7_i in rf7_customers)(
    rf7_position[rf7_i] <= 1+(rf7_n-1)*(1-rf7_arc[0,rf7_i])
    /\
    rf7_position[rf7_i] >= rf7_n-(rf7_n-1)*(1-rf7_arc[rf7_i,0])
    /\
    rf7_position[rf7_i] >= 2-rf7_arc[0,rf7_i]
    /\
    rf7_position[rf7_i] <= rf7_n-1+rf7_arc[rf7_i,0]
);

constraint forall(rf7_i in rf7_customers where rf7_i mod 2 = 1)(
    rf7_position[rf7_i] + 1 <= rf7_position[rf7_i+1]
    /\
    rf7_arc[0,rf7_i+1] = 0
    /\
    rf7_arc[rf7_i,0] = 0
    /\
    rf7_arc[rf7_i+1,rf7_i] = 0
);

constraint forall(rf7_i,rf7_j in rf7_nodes where rf7_i < rf7_j)(
    rf7_arc[rf7_i,rf7_j] + rf7_arc[rf7_j,rf7_i] <= 1
);

constraint forall(rf7_i,rf7_j,rf7_k in rf7_nodes
                   where rf7_i < rf7_j /\ rf7_j < rf7_k)(
    rf7_arc[rf7_i,rf7_j] + rf7_arc[rf7_j,rf7_i]
    + rf7_arc[rf7_i,rf7_k] + rf7_arc[rf7_k,rf7_i]
    + rf7_arc[rf7_j,rf7_k] + rf7_arc[rf7_k,rf7_j]
    <= 2
);

constraint objective =
    sum(rf7_i,rf7_j in rf7_nodes)(
        rf7_cost[rf7_i,rf7_j] * rf7_arc[rf7_i,rf7_j]
    );

solve minimize objective;
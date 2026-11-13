int: nbVehicles = 2;
int: nbCustomers = 7;
int: timeBudget = 60;

set of int: VEHICLE = 1..nbVehicles;
set of int: CUSTOMER = 1..nbCustomers;
set of int: TIME = 0..timeBudget;
set of int: NODES = 1..nbCustomers+2*nbVehicles;
set of int: DEPOT_NODES = nbCustomers+1..nbCustomers+2*nbVehicles;
set of int: START_DEPOT_NODES = nbCustomers+1..nbCustomers+nbVehicles;
set of int: END_DEPOT_NODES =
    nbCustomers+nbVehicles+1..nbCustomers+2*nbVehicles;

array[1..3, NODES, NODES] of int: distance;
array[NODES] of int: serviceTime = [4, 5, 3, 3, 6, 3, 4, 0, 0, 0, 0];

array[1..3, NODES] of var NODES: successor;
array[1..3, NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[1..3, NODES] of var TIME: arrivalTime;

array[1..3] of int: weights = [3, 2, 2];
var 0..timeBudget*3*max(weights): objective;

distance = array3d(1..3, NODES, NODES, [
    0, 4, 7, 4, 9, 11, 12, 5, 5, 5, 5,
    4, 0, 4, 5, 7, 8, 9, 4, 4, 4, 4,
    7, 4, 0, 6, 4, 5, 6, 3, 3, 3, 3,
    4, 5, 6, 0, 7, 9, 10, 3, 3, 3, 3,
    9, 7, 4, 7, 0, 2, 3, 4, 4, 4, 4,
    11, 8, 5, 9, 2, 0, 1, 6, 6, 6, 6,
    12, 9, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0,

    0, 4, 7, 7, 9, 11, 12, 5, 5, 5, 5,
    4, 0, 4, 5, 7, 8, 9, 4, 4, 4, 4,
    7, 4, 0, 6, 4, 5, 6, 3, 3, 3, 3,
    7, 5, 6, 0, 7, 9, 10, 6, 6, 6, 6,
    9, 7, 4, 7, 0, 4, 3, 4, 4, 4, 4,
    11, 8, 5, 9, 4, 0, 1, 6, 6, 6, 6,
    12, 9, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    5, 4, 3, 6, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 6, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 6, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 6, 4, 6, 7, 0, 0, 0, 0,

    0, 4, 7, 4, 9, 11, 12, 5, 5, 5, 5,
    4, 0, 7, 5, 7, 8, 9, 7, 7, 7, 7,
    7, 7, 0, 6, 4, 5, 6, 6, 6, 6, 6,
    4, 5, 6, 0, 7, 9, 10, 3, 3, 3, 3,
    9, 7, 4, 7, 0, 2, 3, 4, 4, 4, 4,
    11, 8, 5, 9, 2, 0, 1, 6, 6, 6, 6,
    12, 9, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    5, 7, 6, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 7, 6, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 7, 6, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 7, 6, 3, 4, 6, 7, 0, 0, 0, 0
]);

set of int: rf_scenarios = index_set_1of2(successor);
set of int: rf_nodes = index_set_2of2(successor);

array[rf_nodes, rf_nodes] of bool: rf_allowed =
    array2d(rf_nodes, rf_nodes, [
        if rf_i in END_DEPOT_NODES then
            rf_j =
                (if rf_i = nbCustomers+2*nbVehicles then
                    nbCustomers+1
                 else
                    rf_i-nbVehicles+1
                 endif)
        elseif rf_i in START_DEPOT_NODES then
            rf_j in CUSTOMER \/ rf_j = rf_i+nbVehicles
        else
            rf_j != rf_i /\
            (rf_j in CUSTOMER \/ rf_j in END_DEPOT_NODES)
        endif
        | rf_i in rf_nodes, rf_j in rf_nodes
    ]);

array[rf_scenarios, rf_nodes, rf_nodes] of var 0..1: rf_arc;

constraint forall(
    rf_sc in rf_scenarios,
    rf_i in rf_nodes,
    rf_j in rf_nodes
    where not rf_allowed[rf_i, rf_j]
)(
    rf_arc[rf_sc, rf_i, rf_j] = 0
);

constraint forall(rf_sc in rf_scenarios, rf_i in rf_nodes)(
    sum(rf_j in rf_nodes where rf_allowed[rf_i, rf_j])(
        rf_arc[rf_sc, rf_i, rf_j]
    ) = 1
);

constraint forall(rf_sc in rf_scenarios, rf_j in rf_nodes)(
    sum(rf_i in rf_nodes where rf_allowed[rf_i, rf_j])(
        rf_arc[rf_sc, rf_i, rf_j]
    ) = 1
);

constraint forall(rf_sc in rf_scenarios, rf_i in rf_nodes)(
    successor[rf_sc, rf_i] =
        sum(rf_j in rf_nodes where rf_allowed[rf_i, rf_j])(
            rf_j * rf_arc[rf_sc, rf_i, rf_j]
        )
);

constraint forall(rf_sc in rf_scenarios, rf_j in rf_nodes)(
    predecessor[rf_sc, rf_j] =
        sum(rf_i in rf_nodes where rf_allowed[rf_i, rf_j])(
            rf_i * rf_arc[rf_sc, rf_i, rf_j]
        )
);

constraint forall(rf_i in START_DEPOT_NODES)(
    vehicle[rf_i] = rf_i-nbCustomers
);

constraint forall(rf_i in END_DEPOT_NODES)(
    vehicle[rf_i] = rf_i-nbCustomers-nbVehicles
);

constraint forall(rf_sc in rf_scenarios, rf_i in START_DEPOT_NODES)(
    arrivalTime[rf_sc, rf_i] = 0
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_i in rf_nodes,
    rf_j in rf_nodes
    where rf_allowed[rf_i, rf_j] /\
          (rf_i in CUSTOMER \/ rf_j in CUSTOMER)
)(
    vehicle[rf_i]-vehicle[rf_j] <=
        (nbVehicles-1)*(1-rf_arc[rf_sc, rf_i, rf_j])
    /\
    vehicle[rf_j]-vehicle[rf_i] <=
        (nbVehicles-1)*(1-rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_i in rf_nodes,
    rf_j in rf_nodes
    where rf_allowed[rf_i, rf_j] /\ not (rf_i in END_DEPOT_NODES)
)(
    arrivalTime[rf_sc, rf_j] >=
        arrivalTime[rf_sc, rf_i]
        + serviceTime[rf_i]
        + distance[rf_sc, rf_i, rf_j]
        - (
            (if rf_i in START_DEPOT_NODES then 0 else timeBudget endif)
            + serviceTime[rf_i]
            + distance[rf_sc, rf_i, rf_j]
          ) * (1-rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(rf_sc in rf_scenarios)(
    sum(rf_j in END_DEPOT_NODES)(arrivalTime[rf_sc, rf_j]) >=
        sum(rf_i in CUSTOMER)(serviceTime[rf_i])
        + sum(
            rf_i in rf_nodes,
            rf_j in rf_nodes
            where rf_allowed[rf_i, rf_j] /\
                  not (rf_i in END_DEPOT_NODES)
          )(
            distance[rf_sc, rf_i, rf_j] *
            rf_arc[rf_sc, rf_i, rf_j]
          )
);

constraint forall(rf_sc in rf_scenarios)(
    arrivalTime[rf_sc, nbCustomers+nbVehicles+1] >=
        sum(rf_i in CUSTOMER)(
            serviceTime[rf_i]*(2-vehicle[rf_i])
        )
);

constraint forall(rf_sc in rf_scenarios)(
    arrivalTime[rf_sc, nbCustomers+nbVehicles+2] >=
        sum(rf_i in CUSTOMER)(
            serviceTime[rf_i]*(vehicle[rf_i]-1)
        )
);

constraint objective =
    sum(rf_sc in rf_scenarios)(
        weights[rf_sc] *
        max(rf_i in END_DEPOT_NODES)(arrivalTime[rf_sc, rf_i])
    );

solve minimize objective;

output [
    "successor = array2d(1..3, ", show(NODES), ", ", show(successor), ");\n",
    "predecessor = array2d(1..3, ", show(NODES), ", ", show(predecessor), ");\n",
    "vehicle = ", show(vehicle), ";\n",
    "arrivalTime = array2d(1..3, ", show(NODES), ", ", show(arrivalTime), ");\n",
    "objective = ", show(objective), ";\n"
];
int: nbVehicles = 2;
int: nbCustomers = 8;
int: timeBudget = 70;
set of int: VEHICLE = 1..nbVehicles;
set of int: CUSTOMER = 1..nbCustomers;
set of int: TIME = 0..timeBudget;
set of int: NODES = 1..nbCustomers+2*nbVehicles;
set of int: DEPOT_NODES = nbCustomers+1..nbCustomers+2*nbVehicles;
set of int: START_DEPOT_NODES = nbCustomers+1..nbCustomers+nbVehicles;
set of int: END_DEPOT_NODES = nbCustomers+nbVehicles+1..nbCustomers+2*nbVehicles;

array[1..5, NODES, NODES] of int: distance;
array[NODES] of int: serviceTime = [5, 3, 2, 1, 5, 4, 2, 6, 0, 0, 0, 0];
array[1..5, NODES] of var NODES: successor;
array[1..5, NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[1..5, NODES] of var TIME: arrivalTime;
var 0..timeBudget*5*max(weights): objective;

distance = array3d(1..5, NODES, NODES, [0, 4, 7, 4, 9, 10, 12, 13, 5, 5, 5, 5,
    4, 0, 4, 5, 6, 9, 9, 10, 4, 4, 4, 4, 7, 4, 0, 6, 4, 7, 6, 7, 3, 3, 3, 3, 4,
    5, 6, 0, 7, 6, 9, 10, 3, 3, 3, 3, 9, 6, 4, 7, 0, 4, 2, 3, 4, 4, 4, 4, 9, 9,
    7, 6, 4, 0, 6, 5, 5, 5, 5, 5, 11, 9, 6, 9, 2, 6, 0, 1, 6, 6, 6, 6, 12, 10,
    7, 10, 3, 5, 1, 0, 7, 7, 7, 7, 5, 4, 3, 3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 4, 3,
    3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 4, 3, 3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 4, 3, 3,
    4, 5, 6, 7, 0, 0, 0, 0, 0, 4, 7, 4, 9, 10, 12, 13, 5, 5, 5, 5, 4, 0, 8, 5,
    6, 9, 9, 10, 8, 8, 8, 8, 7, 8, 0, 6, 4, 7, 6, 7, 6, 6, 6, 6, 4, 5, 6, 0, 7,
    6, 9, 10, 6, 6, 6, 6, 9, 6, 4, 7, 0, 4, 2, 3, 4, 4, 4, 4, 9, 9, 7, 6, 4, 0,
    6, 5, 5, 5, 5, 5, 11, 9, 6, 9, 2, 6, 0, 1, 6, 6, 6, 6, 12, 10, 7, 10, 3, 5,
    1, 0, 7, 7, 7, 7, 5, 8, 6, 6, 4, 5, 6, 7, 0, 0, 0, 0, 5, 8, 6, 6, 4, 5, 6,
    7, 0, 0, 0, 0, 5, 8, 6, 6, 4, 5, 6, 7, 0, 0, 0, 0, 5, 8, 6, 6, 4, 5, 6, 7,
    0, 0, 0, 0, 0, 4, 7, 4, 9, 10, 12, 13, 5, 5, 5, 5, 4, 0, 4, 5, 6, 9, 9, 10,
    4, 4, 4, 4, 7, 4, 0, 6, 7, 7, 6, 7, 6, 6, 6, 6, 4, 5, 6, 0, 7, 6, 9, 10, 3,
    3, 3, 3, 9, 6, 7, 7, 0, 8, 2, 3, 8, 8, 8, 8, 9, 9, 7, 6, 8, 0, 6, 5, 5, 5,
    5, 5, 11, 9, 6, 9, 2, 6, 0, 1, 6, 6, 6, 6, 12, 10, 7, 10, 3, 5, 1, 0, 7, 7,
    7, 7, 5, 4, 6, 3, 8, 5, 6, 7, 0, 0, 0, 0, 5, 4, 6, 3, 8, 5, 6, 7, 0, 0, 0,
    0, 5, 4, 6, 3, 8, 5, 6, 7, 0, 0, 0, 0, 5, 4, 6, 3, 8, 5, 6, 7, 0, 0, 0, 0,
    0, 4, 7, 4, 9, 10, 12, 13, 5, 5, 5, 5, 4, 0, 4, 5, 6, 9, 9, 10, 4, 4, 4, 4,
    7, 4, 0, 6, 4, 7, 6, 7, 3, 3, 3, 3, 4, 5, 6, 0, 7, 6, 9, 10, 3, 3, 3, 3, 9,
    6, 4, 7, 0, 4, 5, 7, 4, 4, 4, 4, 9, 9, 7, 6, 4, 0, 6, 9, 5, 5, 5, 5, 11, 9,
    6, 9, 5, 6, 0, 3, 6, 6, 6, 6, 12, 10, 7, 10, 7, 9, 3, 0, 7, 7, 7, 7, 5, 4,
    3, 3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 4, 3, 3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 4, 3,
    3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 4, 3, 3, 4, 5, 6, 7, 0, 0, 0, 0, 0, 8, 7, 8,
    9, 10, 12, 13, 5, 5, 5, 5, 8, 0, 4, 9, 6, 9, 9, 10, 7, 7, 7, 7, 7, 4, 0, 6,
    4, 7, 6, 7, 3, 3, 3, 3, 8, 9, 6, 0, 7, 6, 9, 10, 3, 3, 3, 3, 9, 6, 4, 7, 0,
    4, 2, 3, 4, 4, 4, 4, 9, 9, 7, 6, 4, 0, 6, 5, 5, 5, 5, 5, 11, 9, 6, 9, 2, 6,
    0, 1, 6, 6, 6, 6, 12, 10, 7, 10, 3, 5, 1, 0, 7, 7, 7, 7, 5, 7, 3, 3, 4, 5,
    6, 7, 0, 0, 0, 0, 5, 7, 3, 3, 4, 5, 6, 7, 0, 0, 0, 0, 5, 7, 3, 3, 4, 5, 6,
    7, 0, 0, 0, 0, 5, 7, 3, 3, 4, 5, 6, 7, 0, 0, 0, 0]);

array[1..5] of int: weights = [3, 2, 2, 1, 1];

set of int: rfm_scenarios = index_set_1of2(successor);
set of int: rfm_nodes = index_set_2of2(successor);
int: rfm_node_count = card(rfm_nodes);
int: rfm_root = min(START_DEPOT_NODES);
int: rfm_vehicle_range = max(VEHICLE) - min(VEHICLE);

array[rfm_nodes, rfm_nodes] of bool: rfm_allowed =
    array2d(rfm_nodes, rfm_nodes, [
        if rfm_i in END_DEPOT_NODES then
            rfm_j =
                (if rfm_i = max(END_DEPOT_NODES) then
                    min(START_DEPOT_NODES)
                 else
                    rfm_i - nbVehicles + 1
                 endif)
        else
            rfm_i != rfm_j /\
            (rfm_j in CUSTOMER \/ rfm_j in END_DEPOT_NODES)
        endif
        | rfm_i in rfm_nodes, rfm_j in rfm_nodes
    ]);

array[rfm_scenarios, rfm_nodes, rfm_nodes] of var 0..1: rfm_arc;
array[rfm_scenarios, rfm_nodes] of var 0..rfm_node_count-1: rfm_order;
array[rfm_scenarios] of var TIME: rfm_makespan;

constraint forall(
    rfm_s in rfm_scenarios,
    rfm_i in rfm_nodes,
    rfm_j in rfm_nodes
    where not rfm_allowed[rfm_i, rfm_j]
)(
    rfm_arc[rfm_s, rfm_i, rfm_j] = 0
);

constraint forall(rfm_s in rfm_scenarios, rfm_i in rfm_nodes)(
    sum(rfm_j in rfm_nodes where rfm_allowed[rfm_i, rfm_j])(
        rfm_arc[rfm_s, rfm_i, rfm_j]
    ) = 1
);

constraint forall(rfm_s in rfm_scenarios, rfm_j in rfm_nodes)(
    sum(rfm_i in rfm_nodes where rfm_allowed[rfm_i, rfm_j])(
        rfm_arc[rfm_s, rfm_i, rfm_j]
    ) = 1
);

constraint forall(rfm_s in rfm_scenarios, rfm_i in rfm_nodes)(
    successor[rfm_s, rfm_i] =
        sum(rfm_j in rfm_nodes where rfm_allowed[rfm_i, rfm_j])(
            rfm_j * rfm_arc[rfm_s, rfm_i, rfm_j]
        )
);

constraint forall(rfm_s in rfm_scenarios, rfm_j in rfm_nodes)(
    predecessor[rfm_s, rfm_j] =
        sum(rfm_i in rfm_nodes where rfm_allowed[rfm_i, rfm_j])(
            rfm_i * rfm_arc[rfm_s, rfm_i, rfm_j]
        )
);

constraint forall(rfm_s in rfm_scenarios)(
    rfm_order[rfm_s, rfm_root] = 0
);

constraint forall(
    rfm_s in rfm_scenarios,
    rfm_i in rfm_nodes,
    rfm_j in rfm_nodes
    where rfm_allowed[rfm_i, rfm_j] /\ rfm_j != rfm_root
)(
    rfm_order[rfm_s, rfm_j] >=
        rfm_order[rfm_s, rfm_i] + 1 -
        rfm_node_count * (1 - rfm_arc[rfm_s, rfm_i, rfm_j])
);

constraint forall(rfm_i in START_DEPOT_NODES)(
    vehicle[rfm_i] = rfm_i - nbCustomers
);

constraint forall(rfm_i in END_DEPOT_NODES)(
    vehicle[rfm_i] = rfm_i - nbCustomers - nbVehicles
);

constraint forall(
    rfm_s in rfm_scenarios,
    rfm_i in rfm_nodes,
    rfm_j in rfm_nodes
    where rfm_allowed[rfm_i, rfm_j] /\
          (rfm_i in CUSTOMER \/ rfm_j in CUSTOMER)
)(
    vehicle[rfm_i] - vehicle[rfm_j] <=
        rfm_vehicle_range * (1 - rfm_arc[rfm_s, rfm_i, rfm_j])
    /\
    vehicle[rfm_j] - vehicle[rfm_i] <=
        rfm_vehicle_range * (1 - rfm_arc[rfm_s, rfm_i, rfm_j])
);

constraint forall(
    rfm_s in rfm_scenarios,
    rfm_i in START_DEPOT_NODES
)(
    arrivalTime[rfm_s, rfm_i] = 0
);

constraint forall(
    rfm_s in rfm_scenarios,
    rfm_i in rfm_nodes,
    rfm_j in rfm_nodes
    where rfm_allowed[rfm_i, rfm_j] /\
          (rfm_i in CUSTOMER \/ rfm_i in START_DEPOT_NODES)
)(
    arrivalTime[rfm_s, rfm_j] >=
        arrivalTime[rfm_s, rfm_i] +
        serviceTime[rfm_i] + distance[rfm_s, rfm_i, rfm_j] -
        (timeBudget + serviceTime[rfm_i] +
         distance[rfm_s, rfm_i, rfm_j]) *
        (1 - rfm_arc[rfm_s, rfm_i, rfm_j])
);

constraint forall(rfm_s in rfm_scenarios)(
    rfm_makespan[rfm_s] =
        max(rfm_i in END_DEPOT_NODES)(arrivalTime[rfm_s, rfm_i])
);

constraint forall(rfm_s in rfm_scenarios)(
    sum(
        rfm_i in rfm_nodes,
        rfm_j in rfm_nodes
        where rfm_allowed[rfm_i, rfm_j] /\
              (rfm_i in CUSTOMER \/ rfm_i in START_DEPOT_NODES)
    )(
        (serviceTime[rfm_i] + distance[rfm_s, rfm_i, rfm_j]) *
        rfm_arc[rfm_s, rfm_i, rfm_j]
    )
    <=
    sum(rfm_i in END_DEPOT_NODES)(arrivalTime[rfm_s, rfm_i])
);

constraint objective =
    sum(rfm_s in rfm_scenarios)(
        weights[rfm_s] * rfm_makespan[rfm_s]
    );

solve minimize objective;

output [
    "successor = array2d(1..5, ", show(NODES), ", ", show(successor), ");\n",
    "predecessor = array2d(1..5, ", show(NODES), ", ", show(predecessor), ");\n",
    "vehicle = ", show(vehicle), ";\n",
    "arrivalTime = array2d(1..5, ", show(NODES), ", ", show(arrivalTime), ");\n",
    "objective = ", show(objective), ";\n"
];
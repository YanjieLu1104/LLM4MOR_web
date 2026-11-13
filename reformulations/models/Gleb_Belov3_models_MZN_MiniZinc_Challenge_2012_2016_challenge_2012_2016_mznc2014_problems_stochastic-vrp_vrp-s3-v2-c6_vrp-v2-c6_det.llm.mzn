int: nbVehicles = 2;
int: nbCustomers = 6;
int: timeBudget = 50;

set of int: VEHICLE = 1..nbVehicles;
set of int: CUSTOMER = 1..nbCustomers;
set of int: TIME = 0..timeBudget;
set of int: NODES = 1..nbCustomers+2*nbVehicles;
set of int: DEPOT_NODES = nbCustomers+1..nbCustomers+2*nbVehicles;
set of int: START_DEPOT_NODES = nbCustomers+1..nbCustomers+nbVehicles;
set of int: END_DEPOT_NODES =
    nbCustomers+nbVehicles+1..nbCustomers+2*nbVehicles;

array[1..3, NODES, NODES] of int: distance;
array[NODES] of int: serviceTime = [5, 3, 6, 1, 3, 3, 0, 0, 0, 0];

array[1..3, NODES] of var NODES: successor;
array[1..3, NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[1..3, NODES] of var TIME: arrivalTime;

var 0..timeBudget*3*max(weights): objective;

distance = array3d(1..3, NODES, NODES, [
    0, 4, 5, 7, 9, 10, 4, 4, 4, 4,
    4, 0, 6, 4, 5, 6, 3, 3, 3, 3,
    5, 6, 0, 7, 9, 10, 3, 3, 3, 3,
    7, 4, 7, 0, 2, 3, 4, 4, 4, 4,
    9, 5, 9, 2, 0, 1, 6, 6, 6, 6,
    10, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    4, 3, 3, 4, 6, 7, 0, 0, 0, 0,

    0, 8, 5, 7, 9, 10, 4, 4, 4, 4,
    8, 0, 6, 4, 5, 6, 5, 5, 5, 5,
    5, 6, 0, 7, 9, 10, 3, 3, 3, 3,
    7, 4, 7, 0, 2, 3, 6, 6, 6, 6,
    9, 5, 9, 2, 0, 1, 6, 6, 6, 6,
    10, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    4, 5, 3, 6, 6, 7, 0, 0, 0, 0,
    4, 5, 3, 6, 6, 7, 0, 0, 0, 0,
    4, 5, 3, 6, 6, 7, 0, 0, 0, 0,
    4, 5, 3, 6, 6, 7, 0, 0, 0, 0,

    0, 4, 5, 7, 9, 10, 4, 4, 4, 4,
    4, 0, 6, 7, 5, 6, 3, 3, 3, 3,
    5, 6, 0, 7, 9, 10, 9, 9, 9, 9,
    7, 7, 7, 0, 2, 3, 4, 4, 4, 4,
    9, 5, 9, 2, 0, 1, 6, 6, 6, 6,
    10, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    4, 3, 9, 4, 6, 7, 0, 0, 0, 0,
    4, 3, 9, 4, 6, 7, 0, 0, 0, 0,
    4, 3, 9, 4, 6, 7, 0, 0, 0, 0,
    4, 3, 9, 4, 6, 7, 0, 0, 0, 0
]);

array[1..3] of int: weights = [3, 2, 2];

array[index_set_2of2(successor), index_set_2of2(successor)] of bool:
    rf_allowed =
    array2d(
        index_set_2of2(successor),
        index_set_2of2(successor),
        [
            if rf_i in CUSTOMER then
                (rf_j in CUSTOMER /\ rf_j != rf_i) \/
                rf_j in END_DEPOT_NODES
            elseif rf_i in START_DEPOT_NODES then
                rf_j in CUSTOMER \/ rf_j = rf_i + nbVehicles
            else
                rf_j =
                    (if rf_i = max(END_DEPOT_NODES) then
                        min(START_DEPOT_NODES)
                     else
                        rf_i - nbVehicles + 1
                     endif)
            endif
            | rf_i in index_set_2of2(successor),
              rf_j in index_set_2of2(successor)
        ]
    );

array[
    index_set_1of2(successor),
    index_set_2of2(successor),
    index_set_2of2(successor)
] of var 0..1: rf_arc;

array[index_set_1of2(arrivalTime)] of var TIME: rf_makespan;

constraint forall(
    rf_sc in index_set_1of2(successor),
    rf_i in NODES,
    rf_j in NODES
    where not rf_allowed[rf_i, rf_j]
)(
    rf_arc[rf_sc, rf_i, rf_j] = 0
);

constraint forall(
    rf_sc in index_set_1of2(successor),
    rf_i in NODES
)(
    sum(rf_j in NODES where rf_allowed[rf_i, rf_j])(
        rf_arc[rf_sc, rf_i, rf_j]
    ) = 1
);

constraint forall(
    rf_sc in index_set_1of2(successor),
    rf_j in NODES
)(
    sum(rf_i in NODES where rf_allowed[rf_i, rf_j])(
        rf_arc[rf_sc, rf_i, rf_j]
    ) = 1
);

constraint forall(
    rf_sc in index_set_1of2(successor),
    rf_i in NODES
)(
    successor[rf_sc, rf_i] =
        sum(rf_j in NODES where rf_allowed[rf_i, rf_j])(
            rf_j * rf_arc[rf_sc, rf_i, rf_j]
        )
);

constraint forall(
    rf_sc in index_set_1of2(predecessor),
    rf_j in NODES
)(
    predecessor[rf_sc, rf_j] =
        sum(rf_i in NODES where rf_allowed[rf_i, rf_j])(
            rf_i * rf_arc[rf_sc, rf_i, rf_j]
        )
);

constraint forall(rf_i in START_DEPOT_NODES)(
    vehicle[rf_i] = rf_i - nbCustomers
);

constraint forall(rf_i in END_DEPOT_NODES)(
    vehicle[rf_i] = rf_i - nbCustomers - nbVehicles
);

constraint forall(
    rf_sc in index_set_1of2(arrivalTime),
    rf_i in START_DEPOT_NODES
)(
    arrivalTime[rf_sc, rf_i] = 0
);

constraint forall(
    rf_sc in index_set_1of2(successor),
    rf_i in CUSTOMER union START_DEPOT_NODES,
    rf_j in NODES
    where rf_allowed[rf_i, rf_j]
)(
    vehicle[rf_i] - vehicle[rf_j] <=
        (nbVehicles - 1) * (1 - rf_arc[rf_sc, rf_i, rf_j])
    /\
    vehicle[rf_j] - vehicle[rf_i] <=
        (nbVehicles - 1) * (1 - rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(
    rf_sc in index_set_1of2(arrivalTime),
    rf_i in CUSTOMER union START_DEPOT_NODES,
    rf_j in NODES
    where rf_allowed[rf_i, rf_j]
)(
    arrivalTime[rf_sc, rf_j] >=
        arrivalTime[rf_sc, rf_i]
        + serviceTime[rf_i]
        + distance[rf_sc, rf_i, rf_j]
        - (
            (if rf_i in START_DEPOT_NODES then 0 else timeBudget endif)
            + serviceTime[rf_i]
            + distance[rf_sc, rf_i, rf_j]
          ) * (1 - rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(
    rf_sc in index_set_1of2(successor),
    rf_mask in 1..(pow(2, card(CUSTOMER)) - 1)
)(
    let {
        set of int: rf_subset = {
            rf_i | rf_i in CUSTOMER
            where
                (rf_mask div pow(2, rf_i - min(CUSTOMER))) mod 2 = 1
        }
    } in
        if card(rf_subset) >= 2 then
            sum(
                rf_i in rf_subset,
                rf_j in rf_subset
                where rf_i != rf_j
            )(
                rf_arc[rf_sc, rf_i, rf_j]
            ) <= card(rf_subset) - 1
        else
            true
        endif
);

constraint forall(rf_sc in index_set_1of2(arrivalTime))(
    rf_makespan[rf_sc] =
        max(rf_i in END_DEPOT_NODES)(arrivalTime[rf_sc, rf_i])
);

constraint forall(rf_sc in index_set_1of2(arrivalTime))(
    nbVehicles * rf_makespan[rf_sc] >=
        sum(rf_i in CUSTOMER union START_DEPOT_NODES)(
            serviceTime[rf_i]
        )
        +
        sum(
            rf_i in CUSTOMER union START_DEPOT_NODES,
            rf_j in NODES
            where rf_allowed[rf_i, rf_j]
        )(
            distance[rf_sc, rf_i, rf_j] * rf_arc[rf_sc, rf_i, rf_j]
        )
);

constraint objective =
    sum(rf_sc in index_set(weights))(
        weights[rf_sc] * rf_makespan[rf_sc]
    );

solve minimize objective;

output [
    "successor = array2d(1..3, ", show(NODES), ", ", show(successor), ");\n",
    "predecessor = array2d(1..3, ", show(NODES), ", ", show(predecessor), ");\n",
    "vehicle = ", show(vehicle), ";\n",
    "arrivalTime = array2d(1..3, ", show(NODES), ", ", show(arrivalTime), ");\n",
    "objective = ", show(objective), ";\n"
];
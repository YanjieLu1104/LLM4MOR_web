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

array[1..4, NODES, NODES] of int: distance;
array[NODES] of int: serviceTime = [5, 3, 6, 1, 3, 3, 0, 0, 0, 0];
array[1..4] of int: weights = [3, 2, 2, 1];

array[1..4, NODES] of var NODES: successor;
array[1..4, NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[1..4, NODES] of var TIME: arrivalTime;
var 0..timeBudget*4*max(weights): objective;

distance = array3d(1..4, NODES, NODES, [
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
    4, 3, 9, 4, 6, 7, 0, 0, 0, 0,

    0, 4, 5, 7, 9, 10, 4, 4, 4, 4,
    4, 0, 6, 4, 5, 6, 3, 3, 3, 3,
    5, 6, 0, 7, 9, 10, 6, 6, 6, 6,
    7, 4, 7, 0, 5, 3, 7, 7, 7, 7,
    9, 5, 9, 5, 0, 1, 6, 6, 6, 6,
    10, 6, 10, 3, 1, 0, 7, 7, 7, 7,
    4, 3, 6, 7, 6, 7, 0, 0, 0, 0,
    4, 3, 6, 7, 6, 7, 0, 0, 0, 0,
    4, 3, 6, 7, 6, 7, 0, 0, 0, 0,
    4, 3, 6, 7, 6, 7, 0, 0, 0, 0
]);

set of int: rf001_scenarios = index_set_1of3(distance);

array[
    index_set_1of3(distance),
    index_set_2of3(distance),
    index_set_3of3(distance)
] of var 0..1: rf001_arc;

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_from in NODES,
    rf001_to in NODES
)(
    if
        (
            rf001_from in END_DEPOT_NODES /\
            rf001_to =
                (if rf001_from = max(END_DEPOT_NODES) then
                    min(START_DEPOT_NODES)
                 else
                    rf001_from - nbVehicles + 1
                 endif)
        )
        \/
        (
            rf001_from in START_DEPOT_NODES /\
            (
                rf001_to in CUSTOMER \/
                rf001_to = rf001_from + nbVehicles
            )
        )
        \/
        (
            rf001_from in CUSTOMER /\
            rf001_to in (CUSTOMER union END_DEPOT_NODES) /\
            rf001_from != rf001_to
        )
    then
        true
    else
        rf001_arc[rf001_sc, rf001_from, rf001_to] = 0
    endif
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_from in NODES
)(
    sum(rf001_to in NODES)(
        rf001_arc[rf001_sc, rf001_from, rf001_to]
    ) = 1
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_to in NODES
)(
    sum(rf001_from in NODES)(
        rf001_arc[rf001_sc, rf001_from, rf001_to]
    ) = 1
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_from in NODES
)(
    successor[rf001_sc, rf001_from] =
        sum(rf001_to in NODES)(
            rf001_to * rf001_arc[rf001_sc, rf001_from, rf001_to]
        )
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_to in NODES
)(
    predecessor[rf001_sc, rf001_to] =
        sum(rf001_from in NODES)(
            rf001_from * rf001_arc[rf001_sc, rf001_from, rf001_to]
        )
);

constraint forall(rf001_node in START_DEPOT_NODES)(
    vehicle[rf001_node] = rf001_node - nbCustomers
);

constraint forall(rf001_node in END_DEPOT_NODES)(
    vehicle[rf001_node] = rf001_node - nbCustomers - nbVehicles
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_node in START_DEPOT_NODES
)(
    arrivalTime[rf001_sc, rf001_node] = 0
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_from in (CUSTOMER union START_DEPOT_NODES),
    rf001_to in (CUSTOMER union END_DEPOT_NODES)
    where rf001_from != rf001_to
)(
    vehicle[rf001_from] - vehicle[rf001_to] <=
        (nbVehicles - 1) *
        (1 - rf001_arc[rf001_sc, rf001_from, rf001_to])
    /\
    vehicle[rf001_to] - vehicle[rf001_from] <=
        (nbVehicles - 1) *
        (1 - rf001_arc[rf001_sc, rf001_from, rf001_to])
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_from in (CUSTOMER union START_DEPOT_NODES),
    rf001_to in (CUSTOMER union END_DEPOT_NODES)
    where rf001_from != rf001_to
)(
    arrivalTime[rf001_sc, rf001_to] >=
        arrivalTime[rf001_sc, rf001_from]
        + serviceTime[rf001_from]
        + distance[rf001_sc, rf001_from, rf001_to]
        - (
            timeBudget
            + serviceTime[rf001_from]
            + distance[rf001_sc, rf001_from, rf001_to]
          ) * (1 - rf001_arc[rf001_sc, rf001_from, rf001_to])
);

constraint forall(
    rf001_sc in rf001_scenarios,
    rf001_mask in 1..(pow(2, card(CUSTOMER)) - 1)
)(
    let {
        set of int: rf001_subset = {
            rf001_node |
            rf001_node in CUSTOMER
            where
                (rf001_mask div
                    pow(2, rf001_node - min(CUSTOMER))) mod 2 = 1
        };
    } in
        if card(rf001_subset) >= 2 then
            sum(
                rf001_from in rf001_subset,
                rf001_to in rf001_subset
                where rf001_from != rf001_to
            )(
                rf001_arc[rf001_sc, rf001_from, rf001_to]
            ) <= card(rf001_subset) - 1
        else
            true
        endif
);

constraint forall(rf001_sc in rf001_scenarios)(
    sum(
        rf001_from in (CUSTOMER union START_DEPOT_NODES),
        rf001_to in (CUSTOMER union END_DEPOT_NODES)
        where rf001_from != rf001_to
    )(
        (
            serviceTime[rf001_from]
            + distance[rf001_sc, rf001_from, rf001_to]
        ) * rf001_arc[rf001_sc, rf001_from, rf001_to]
    )
    <=
    sum(rf001_node in END_DEPOT_NODES)(
        arrivalTime[rf001_sc, rf001_node]
    )
);

constraint objective =
    sum(rf001_sc in rf001_scenarios)(
        weights[rf001_sc] *
        max(rf001_node in END_DEPOT_NODES)(
            arrivalTime[rf001_sc, rf001_node]
        )
    );

solve minimize objective;

output [
    "successor = array2d(1..4, ", show(NODES), ", ",
    show(successor), ");\n",
    "predecessor = array2d(1..4, ", show(NODES), ", ",
    show(predecessor), ");\n",
    "vehicle = ", show(vehicle), ";\n",
    "arrivalTime = array2d(1..4, ", show(NODES), ", ",
    show(arrivalTime), ");\n",
    "objective = ", show(objective), ";\n"
];
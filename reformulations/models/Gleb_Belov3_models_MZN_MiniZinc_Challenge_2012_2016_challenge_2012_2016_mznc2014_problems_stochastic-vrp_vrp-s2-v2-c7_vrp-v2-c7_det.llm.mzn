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

array[1..2, NODES, NODES] of int: distance;
array[NODES] of int: serviceTime = [4, 5, 3, 3, 6, 3, 4, 0, 0, 0, 0];
array[1..2] of int: weights = [3, 2];

array[1..2, NODES] of var NODES: successor;
array[1..2, NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[1..2, NODES] of var TIME: arrivalTime;
var 0..timeBudget*2*max(weights): objective;

distance = array3d(1..2, NODES, NODES, [0, 4, 7, 4, 9, 11, 12, 5, 5, 5, 5, 4,
    0, 4, 5, 7, 8, 9, 4, 4, 4, 4, 7, 4, 0, 6, 4, 5, 6, 3, 3, 3, 3, 4, 5, 6, 0,
    7, 9, 10, 3, 3, 3, 3, 9, 7, 4, 7, 0, 2, 3, 4, 4, 4, 4, 11, 8, 5, 9, 2, 0,
    1, 6, 6, 6, 6, 12, 9, 6, 10, 3, 1, 0, 7, 7, 7, 7, 5, 4, 3, 3, 4, 6, 7, 0,
    0, 0, 0, 5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0, 5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0,
    5, 4, 3, 3, 4, 6, 7, 0, 0, 0, 0, 0, 4, 7, 7, 9, 11, 12, 5, 5, 5, 5, 4, 0,
    4, 5, 7, 8, 9, 4, 4, 4, 4, 7, 4, 0, 6, 4, 5, 6, 3, 3, 3, 3, 7, 5, 6, 0, 7,
    9, 10, 6, 6, 6, 6, 9, 7, 4, 7, 0, 4, 3, 4, 4, 4, 4, 11, 8, 5, 9, 4, 0, 1,
    6, 6, 6, 6, 12, 9, 6, 10, 3, 1, 0, 7, 7, 7, 7, 5, 4, 3, 6, 4, 6, 7, 0, 0,
    0, 0, 5, 4, 3, 6, 4, 6, 7, 0, 0, 0, 0, 5, 4, 3, 6, 4, 6, 7, 0, 0, 0, 0, 5,
    4, 3, 6, 4, 6, 7, 0, 0, 0, 0]);

set of int: rf_scenarios = index_set_1of3(distance);
set of int: rf_sources = index_set_2of3(distance);
set of int: rf_targets = index_set_3of3(distance);
set of int: rf_masks = 1..(2^(card(rf_sources)-1)-1);

array[rf_sources] of int: rf_time_upper =
    array1d(rf_sources, [
        if rf_i in START_DEPOT_NODES then 0 else timeBudget endif
        | rf_i in rf_sources
    ]);

array[rf_sources] of int: rf_fixed_next =
    array1d(rf_sources, [
        if rf_i = max(END_DEPOT_NODES) then
            min(START_DEPOT_NODES)
        elseif rf_i in END_DEPOT_NODES then
            rf_i-nbVehicles+1
        else
            rf_i
        endif
        | rf_i in rf_sources
    ]);

array[rf_targets] of int: rf_fixed_previous =
    array1d(rf_targets, [
        if rf_j = min(START_DEPOT_NODES) then
            max(END_DEPOT_NODES)
        elseif rf_j in START_DEPOT_NODES then
            rf_j+nbVehicles-1
        else
            rf_j
        endif
        | rf_j in rf_targets
    ]);

array[rf_scenarios, rf_sources, rf_targets] of bool: rf_allowed =
    array3d(rf_scenarios, rf_sources, rf_targets, [
        rf_i != rf_j /\
        (if rf_i in END_DEPOT_NODES then
            rf_j = rf_fixed_next[rf_i]
         else
            true
         endif) /\
        (if rf_j in START_DEPOT_NODES then
            rf_i = rf_fixed_previous[rf_j]
         else
            true
         endif) /\
        (if rf_i in (CUSTOMER union START_DEPOT_NODES) then
            serviceTime[rf_i] + distance[rf_sc, rf_i, rf_j] <= timeBudget
         else
            true
         endif)
        | rf_sc in rf_scenarios,
          rf_i in rf_sources,
          rf_j in rf_targets
    ]);

array[rf_masks] of set of int: rf_cut_sets =
    array1d(rf_masks, [
        {
            rf_i | rf_i in rf_sources
            where rf_i != max(rf_sources) /\
                ((rf_mask div (2^(rf_i-min(rf_sources)))) mod 2 = 1)
        }
        | rf_mask in rf_masks
    ]);

array[rf_scenarios, rf_sources, rf_targets] of var 0..1: rf_arc;

constraint forall(
    rf_sc in rf_scenarios,
    rf_i in rf_sources,
    rf_j in rf_targets
    where not rf_allowed[rf_sc, rf_i, rf_j]
)(
    rf_arc[rf_sc, rf_i, rf_j] = 0
);

constraint forall(rf_sc in rf_scenarios, rf_i in rf_sources)(
    sum(rf_j in rf_targets)(rf_arc[rf_sc, rf_i, rf_j]) = 1
);

constraint forall(rf_sc in rf_scenarios, rf_j in rf_targets)(
    sum(rf_i in rf_sources)(rf_arc[rf_sc, rf_i, rf_j]) = 1
);

constraint forall(rf_sc in rf_scenarios, rf_i in rf_sources)(
    successor[rf_sc, rf_i] =
        sum(rf_j in rf_targets)(rf_j * rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(rf_sc in rf_scenarios, rf_j in rf_targets)(
    predecessor[rf_sc, rf_j] =
        sum(rf_i in rf_sources)(rf_i * rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(rf_sc in rf_scenarios, rf_i in END_DEPOT_NODES)(
    rf_arc[rf_sc, rf_i, rf_fixed_next[rf_i]] = 1
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
    rf_i in rf_sources,
    rf_j in rf_targets
    where rf_allowed[rf_sc, rf_i, rf_j] /\
        (rf_i in CUSTOMER \/ rf_j in CUSTOMER)
)(
    vehicle[rf_i] - vehicle[rf_j] <=
        (nbVehicles-1) * (1-rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_i in rf_sources,
    rf_j in rf_targets
    where rf_allowed[rf_sc, rf_i, rf_j] /\
        (rf_i in CUSTOMER \/ rf_j in CUSTOMER)
)(
    vehicle[rf_j] - vehicle[rf_i] <=
        (nbVehicles-1) * (1-rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_i in rf_sources,
    rf_j in rf_targets
    where rf_allowed[rf_sc, rf_i, rf_j] /\
        rf_i in (CUSTOMER union START_DEPOT_NODES)
)(
    arrivalTime[rf_sc, rf_i] + serviceTime[rf_i] +
        distance[rf_sc, rf_i, rf_j] <=
    arrivalTime[rf_sc, rf_j] +
        (rf_time_upper[rf_i] + serviceTime[rf_i] +
            distance[rf_sc, rf_i, rf_j]) *
        (1-rf_arc[rf_sc, rf_i, rf_j])
);

constraint forall(
    rf_sc in rf_scenarios,
    rf_mask in rf_masks
    where card(rf_cut_sets[rf_mask]) >= 2 /\
        forall(rf_i in END_DEPOT_NODES)(
            not (rf_i in rf_cut_sets[rf_mask]) \/
            rf_fixed_next[rf_i] in rf_cut_sets[rf_mask]
        )
)(
    sum(
        rf_i in rf_cut_sets[rf_mask],
        rf_j in (rf_targets diff rf_cut_sets[rf_mask])
        where rf_allowed[rf_sc, rf_i, rf_j]
    )(
        rf_arc[rf_sc, rf_i, rf_j]
    ) >= 1
);

constraint objective =
    sum(rf_sc in rf_scenarios)(
        weights[rf_sc] *
        max(rf_i in NODES)(arrivalTime[rf_sc, rf_i])
    );

solve minimize objective;

output [
    "successor = array2d(1..2, ", show(NODES), ", ", show(successor), ");\n",
    "predecessor = array2d(1..2, ", show(NODES), ", ", show(predecessor), ");\n",
    "vehicle = ", show(vehicle), ";\n",
    "arrivalTime = array2d(1..2, ", show(NODES), ", ", show(arrivalTime), ");\n",
    "objective = ", show(objective), ";\n"
];
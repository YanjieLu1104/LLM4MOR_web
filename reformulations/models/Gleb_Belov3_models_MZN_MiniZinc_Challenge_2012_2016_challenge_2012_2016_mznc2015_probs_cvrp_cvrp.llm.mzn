int: N;
int: Capacity;

int: nbVehicles = N;
int: nbCustomers = N;
int: timeBudget =
    sum(i in 1..N)(max([Distance[i,j] | j in 1..N]));

set of int: VEHICLE = 1..nbVehicles;
set of int: CUSTOMER = 1..nbCustomers;
set of int: TIME = 0..timeBudget;
set of int: LOAD = 0..Capacity;

set of int: NODES = 1..nbCustomers+2*nbVehicles;
set of int: DEPOT_NODES =
    nbCustomers+1..nbCustomers+2*nbVehicles;
set of int: START_DEPOT_NODES =
    nbCustomers+1..nbCustomers+nbVehicles;
set of int: END_DEPOT_NODES =
    nbCustomers+nbVehicles+1..nbCustomers+2*nbVehicles;

array[1..N] of int: Demand;

array[NODES] of int: demand = [
    if i <= N then Demand[i] else 0 endif
    | i in NODES
];

array[1..N+1, 1..N+1] of int: Distance;

array[NODES, NODES] of int: distance =
    array2d(NODES, NODES, [
        if i <= nbCustomers /\ j <= nbCustomers then
            Distance[i+1,j+1]
        elseif i <= nbCustomers /\ j > nbCustomers then
            Distance[1,i+1]
        elseif j <= nbCustomers /\ i > nbCustomers then
            Distance[j+1,1]
        else
            Distance[1,1]
        endif
        | i,j in NODES
    ]);

array[NODES] of var NODES: successor;
array[NODES] of var NODES: predecessor;
array[NODES] of var VEHICLE: vehicle;
array[NODES] of var LOAD: load;
array[NODES] of var TIME: arrivalTime;
var 0..timeBudget: objective;

function bool: cvrpr_allowed(int: cvrpr_from, int: cvrpr_to) =
    if cvrpr_from in END_DEPOT_NODES then
        cvrpr_to =
            (if cvrpr_from = nbCustomers+2*nbVehicles then
                nbCustomers+1
             else
                cvrpr_from-nbVehicles+1
             endif)
    else
        cvrpr_from != cvrpr_to /\
        not (cvrpr_to in START_DEPOT_NODES) /\
        distance[cvrpr_from,cvrpr_to] <= timeBudget /\
        (if cvrpr_from in CUSTOMER then
            demand[cvrpr_from] >= -Capacity /\
            demand[cvrpr_from] <= Capacity
         else
            true
         endif)
    endif;

array[int] of int: cvrpr_tail = [
    cvrpr_i
    | cvrpr_i,cvrpr_j in index_set(successor)
    where cvrpr_allowed(cvrpr_i,cvrpr_j)
];

array[index_set(cvrpr_tail)] of int: cvrpr_head = [
    cvrpr_j
    | cvrpr_i,cvrpr_j in index_set(successor)
    where cvrpr_allowed(cvrpr_i,cvrpr_j)
];

array[index_set(cvrpr_tail)] of var 0..1: cvrpr_arc;

array[index_set(successor)] of
    var 0..max(0,card(NODES)-1): cvrpr_order;

constraint forall(cvrpr_i in NODES)(
    sum(cvrpr_a in index_set(cvrpr_arc)
        where cvrpr_tail[cvrpr_a] = cvrpr_i)(
        cvrpr_arc[cvrpr_a]
    ) = 1
);

constraint forall(cvrpr_i in NODES)(
    sum(cvrpr_a in index_set(cvrpr_arc)
        where cvrpr_head[cvrpr_a] = cvrpr_i)(
        cvrpr_arc[cvrpr_a]
    ) = 1
);

constraint forall(cvrpr_i in NODES)(
    successor[cvrpr_i] =
        sum(cvrpr_a in index_set(cvrpr_arc)
            where cvrpr_tail[cvrpr_a] = cvrpr_i)(
            cvrpr_head[cvrpr_a] * cvrpr_arc[cvrpr_a]
        )
);

constraint forall(cvrpr_i in NODES)(
    predecessor[cvrpr_i] =
        sum(cvrpr_a in index_set(cvrpr_arc)
            where cvrpr_head[cvrpr_a] = cvrpr_i)(
            cvrpr_tail[cvrpr_a] * cvrpr_arc[cvrpr_a]
        )
);

constraint forall(cvrpr_i in NODES)(
    if cvrpr_i = 1 then
        cvrpr_order[cvrpr_i] = 0
    else
        cvrpr_order[cvrpr_i] >= 1
    endif
);

constraint forall(cvrpr_a in index_set(cvrpr_arc)
                  where cvrpr_head[cvrpr_a] != 1)(
    cvrpr_order[cvrpr_head[cvrpr_a]] >=
        cvrpr_order[cvrpr_tail[cvrpr_a]] + 1
        - card(NODES) * (1-cvrpr_arc[cvrpr_a])
);

constraint forall(cvrpr_i in START_DEPOT_NODES)(
    vehicle[cvrpr_i] = cvrpr_i-nbCustomers /\
    arrivalTime[cvrpr_i] = 0 /\
    load[cvrpr_i] = 0
);

constraint forall(cvrpr_i in END_DEPOT_NODES)(
    vehicle[cvrpr_i] = cvrpr_i-nbCustomers-nbVehicles
);

constraint forall(cvrpr_a in index_set(cvrpr_arc)
                  where cvrpr_tail[cvrpr_a] in CUSTOMER \/
                        cvrpr_head[cvrpr_a] in CUSTOMER)(
    vehicle[cvrpr_tail[cvrpr_a]]
        - vehicle[cvrpr_head[cvrpr_a]]
        <= (nbVehicles-1) * (1-cvrpr_arc[cvrpr_a])
    /\
    vehicle[cvrpr_head[cvrpr_a]]
        - vehicle[cvrpr_tail[cvrpr_a]]
        <= (nbVehicles-1) * (1-cvrpr_arc[cvrpr_a])
);

constraint forall(cvrpr_a in index_set(cvrpr_arc)
                  where not (cvrpr_tail[cvrpr_a] in END_DEPOT_NODES))(
    arrivalTime[cvrpr_head[cvrpr_a]] >=
        arrivalTime[cvrpr_tail[cvrpr_a]]
        + distance[cvrpr_tail[cvrpr_a],cvrpr_head[cvrpr_a]]
        - max(
            0,
            (if cvrpr_tail[cvrpr_a] in START_DEPOT_NODES then
                0
             else
                timeBudget
             endif)
            + distance[cvrpr_tail[cvrpr_a],cvrpr_head[cvrpr_a]]
          ) * (1-cvrpr_arc[cvrpr_a])
);

constraint forall(cvrpr_a in index_set(cvrpr_arc)
                  where cvrpr_tail[cvrpr_a] in CUSTOMER)(
    load[cvrpr_head[cvrpr_a]] >=
        load[cvrpr_tail[cvrpr_a]]
        + demand[cvrpr_tail[cvrpr_a]]
        - max(0,Capacity+demand[cvrpr_tail[cvrpr_a]])
          * (1-cvrpr_arc[cvrpr_a])
    /\
    load[cvrpr_head[cvrpr_a]] <=
        load[cvrpr_tail[cvrpr_a]]
        + demand[cvrpr_tail[cvrpr_a]]
        + max(0,Capacity-demand[cvrpr_tail[cvrpr_a]])
          * (1-cvrpr_arc[cvrpr_a])
);

constraint forall(cvrpr_a in index_set(cvrpr_arc)
                  where cvrpr_tail[cvrpr_a] in START_DEPOT_NODES)(
    load[cvrpr_head[cvrpr_a]] <=
        Capacity * (1-cvrpr_arc[cvrpr_a])
);

constraint objective =
    sum(cvrpr_i in END_DEPOT_NODES)(arrivalTime[cvrpr_i]);

constraint sum(cvrpr_i in END_DEPOT_NODES)(load[cvrpr_i]) =
    sum(cvrpr_i in CUSTOMER)(demand[cvrpr_i]);

constraint objective >=
    sum(cvrpr_a in index_set(cvrpr_arc)
        where not (cvrpr_tail[cvrpr_a] in END_DEPOT_NODES))(
        distance[cvrpr_tail[cvrpr_a],cvrpr_head[cvrpr_a]]
        * cvrpr_arc[cvrpr_a]
    );

solve minimize objective;

output
    ["objective = "] ++ [show(objective)] ++
    [";\nvehicle = "] ++ [show(vehicle)] ++
    [";\narrivalTime = "] ++ [show(arrivalTime)] ++
    [";\nsuccessor = "] ++ [show(successor)] ++
    [";\n"];
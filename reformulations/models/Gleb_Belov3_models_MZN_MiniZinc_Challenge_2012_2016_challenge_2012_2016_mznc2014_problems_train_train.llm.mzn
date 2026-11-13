int: n;
int: m;

int: maxTime;

0..maxTime: delayTime;
1..n: delayTrain;
0..maxTime: delayDuration;

array [1..m-1] of 0..maxTime: distance;

array [1..n, 1..m] of 0..maxTime: scheduledArrival;
array [1..n, 1..m] of 0..maxTime: scheduledDeparture;

array [1..m] of 0..maxTime: passengerStart;
array [1..m] of 0..maxTime: passengerStop =
    [scheduledDeparture[n,j] | j in 1..m];
array [1..m] of int: passengerFlow;

array [1..n, 1..m] of var 0..maxTime: departure;
array [1..n, 1..m] of var 0..maxTime: arrival;

array [1..n] of var 0..maxTime: finalArrival =
    [arrival[i,m] | i in 1..n];

array [1..n, 1..m] of var 0..maxTime: sigmaLower;
array [1..n, 1..m] of var 0..maxTime: sigmaUpper;

int: capacity;

array [1..n, 1..m] of var 0..capacity: collect;
array [1..n, 1..m] of var 0..capacity: load;
array [1..n, 1..m] of var 0..maxTime: dwell;

int: destinationWhenDelayed =
    min([j | j in 1..m
           where scheduledDeparture[delayTrain,j] > delayTime]);

constraint forall(i in 1..n)(
    arrival[i,1] = 0
);

constraint forall(i in 1..n)(
    departure[i,m] = arrival[i,m]
);

constraint forall(i in 1..n, j in 1..m-1)(
    if scheduledDeparture[i,j] <= delayTime then
        departure[i,j] = scheduledDeparture[i,j]
    else
        true
    endif
);

constraint
    if destinationWhenDelayed > 1 then
        if delayTime <
           scheduledDeparture[delayTrain,destinationWhenDelayed-1]
           + distance[destinationWhenDelayed-1]
        then
            arrival[delayTrain,destinationWhenDelayed] >=
                departure[delayTrain,destinationWhenDelayed-1]
                + delayDuration
                + distance[destinationWhenDelayed-1]
        else
            true
        endif
    else
        true
    endif;

constraint
    departure[delayTrain,destinationWhenDelayed] >=
        delayTime + delayDuration;

constraint forall(i in 1..n, j in 1..m)(
    departure[i,j] >= arrival[i,j]
);

constraint forall(i in 1..n, j in 1..m-1)(
    departure[i,j] >= scheduledDeparture[i,j]
);

constraint forall(i in 1..n, j in 1..m-1)(
    arrival[i,j+1] >= departure[i,j] + distance[j]
);

constraint forall(i in 1..n-1)(
    departure[i,1] < departure[i+1,1]
);

constraint forall(i in 1..n-1, j in 2..m-1)(
    departure[i,j] <= arrival[i+1,j] - 2
);

constraint forall(i in 1..n, j in 1..m)(
    sigmaLower[i,j] <= sigmaUpper[i,j]
);

constraint forall(j in 2..m-1)(
    sigmaLower[1,j] = passengerStart[j] /\
    sigmaUpper[n,j] = scheduledDeparture[n,j]
);

constraint forall(i in 1..n-1, j in 1..m)(
    sigmaUpper[i,j] = sigmaLower[i+1,j]
);

constraint forall(i in 1..n, j in 1..m-1)(
    sigmaUpper[i,j] <= departure[i,j]
);

constraint forall(i in 1..n, j in 1..m)(
    collect[i,j] =
        (sigmaUpper[i,j] - sigmaLower[i,j]) * passengerFlow[j]
);

constraint forall(i in 1..n)(
    load[i,1] = collect[i,1]
);

constraint forall(i in 1..n, j in 2..m)(
    load[i,j] = load[i,j-1] + collect[i,j]
);

constraint forall(i in 1..n, j in 1..m-1)(
    sigmaUpper[i,j] > sigmaLower[i,j] ->
        (
            sigmaUpper[i,j] = departure[i,j] \/
            sigmaUpper[i,j] = scheduledDeparture[n,j] \/
            (
                sigmaUpper[i,j] < scheduledDeparture[n,j] /\
                load[i,j] + passengerFlow[j] > capacity
            )
        )
);

constraint forall(i in 1..n, j in 1..m)(
    dwell[i,j] = departure[i,j] - arrival[i,j]
);

constraint forall(i in 1..n, j in 1..m)(
    collect[i,j] <= 50 * dwell[i,j]
);

constraint forall(i in 1..n, j in 2..m)(
    capacity - load[i,j-1] < 100 ->
        collect[i,j] <= 20 * dwell[i,j]
);

constraint forall(i in 1..n)(
    collect[i,m] = 0
);

constraint forall(i in 1..n, j in 1..m
                  where passengerFlow[j] <= 0)(
    collect[i,j] = 0
);

constraint forall(i in 1..n, j in 2..m-1)(
    sigmaLower[i,j] >= passengerStart[j] /\
    sigmaUpper[i,j] <= scheduledDeparture[n,j]
);

constraint forall(j in 2..m-1)(
    sum(i in 1..n)(collect[i,j]) =
        (scheduledDeparture[n,j] - passengerStart[j])
        * passengerFlow[j]
);

array [index_set_1of2(arrival)] of int: trf_final_lb =
    array1d(
        index_set_1of2(arrival),
        [
            max(
                [0] ++
                [
                    scheduledDeparture[i,j]
                    + sum(trf_station in j..m-1)(
                        distance[trf_station]
                    )
                    | j in 1..m-1
                ]
            )
            | i in index_set_1of2(arrival)
        ]
    );

constraint forall(i in index_set_1of2(arrival))(
    arrival[i,m] >= trf_final_lb[i]
);

function int: trf_bit_length(int: trf_value) =
    if trf_value <= 0 then
        0
    else
        1 + trf_bit_length(trf_value div 2)
    endif;

bool: trf_expand_load = capacity <= maxTime;
int: trf_width = trf_bit_length(min(capacity, maxTime));
int: trf_other_ub =
    if trf_expand_load then maxTime else capacity endif;

array [int] of int: trf_weights =
    [pow(2, trf_bit_index) | trf_bit_index in 0..trf_width-1];

array [
    index_set_1of2(load),
    index_set(trf_weights)
] of var bool: trf_bits;

array [
    index_set_1of2(load),
    index_set(trf_weights)
] of var 0..trf_other_ub: trf_terms;

constraint forall(i in index_set_1of2(load))(
    (
        if trf_expand_load then
            load[i,m]
        else
            arrival[i,m]
        endif
    ) =
    sum(trf_k in index_set(trf_weights))(
        trf_weights[trf_k] * bool2int(trf_bits[i,trf_k])
    )
);

constraint forall(
    i in index_set_1of2(load),
    trf_k in index_set(trf_weights)
)(
    trf_terms[i,trf_k] <=
        trf_other_ub * bool2int(trf_bits[i,trf_k])
);

constraint forall(
    i in index_set_1of2(load),
    trf_k in index_set(trf_weights)
)(
    trf_terms[i,trf_k] <=
        (
            if trf_expand_load then
                arrival[i,m]
            else
                load[i,m]
            endif
        )
);

constraint forall(
    i in index_set_1of2(load),
    trf_k in index_set(trf_weights)
)(
    trf_terms[i,trf_k] >=
        (
            if trf_expand_load then
                arrival[i,m]
            else
                load[i,m]
            endif
        )
        - trf_other_ub * (1 - bool2int(trf_bits[i,trf_k]))
);

constraint forall(i in index_set_1of2(load))(
    sum(trf_k in index_set(trf_weights))(
        trf_weights[trf_k] * trf_terms[i,trf_k]
    ) >= trf_final_lb[i] * load[i,m]
);

constraint forall(i in index_set_1of2(load))(
    sum(trf_k in index_set(trf_weights))(
        trf_weights[trf_k] * trf_terms[i,trf_k]
    ) <= maxTime * load[i,m]
);

constraint forall(i in index_set_1of2(load))(
    sum(trf_k in index_set(trf_weights))(
        trf_weights[trf_k] * trf_terms[i,trf_k]
    ) >=
        capacity * arrival[i,m]
        + maxTime * load[i,m]
        - capacity * maxTime
);

constraint forall(i in index_set_1of2(load))(
    sum(trf_k in index_set(trf_weights))(
        trf_weights[trf_k] * trf_terms[i,trf_k]
    ) <=
        capacity * arrival[i,m]
        + trf_final_lb[i] * load[i,m]
        - capacity * trf_final_lb[i]
);

int: objective_min =
    lb(sum(i in 1..n)(load[i,m] * arrival[i,m]));
int: objective_max =
    ub(sum(i in 1..n)(load[i,m] * arrival[i,m]));

var objective_min..objective_max: objective =
    sum(
        i in index_set_1of2(load),
        trf_k in index_set(trf_weights)
    )(
        trf_weights[trf_k] * trf_terms[i,trf_k]
    );

solve minimize objective;

output [
    "arrival = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(arrival), ");\n",
    "departure = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(departure), ");\n",
    "sigmaLower = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(sigmaLower), ");\n",
    "sigmaUpper = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(sigmaUpper), ");\n",
    "collect = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(collect), ");\n",
    "load = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(load), ");\n",
    "dwell = array2d(1..", show(n), ", 1..", show(m), ", ",
    show(dwell), ");\n",
    "constraint objective = ", show(objective), ";\n"
];
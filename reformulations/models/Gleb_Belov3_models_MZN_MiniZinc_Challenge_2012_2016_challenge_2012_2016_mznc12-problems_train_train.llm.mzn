include "globals.mzn";

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

array [index_set(passengerStart)] of int: rf_remaining_distance =
    array1d(
        index_set(passengerStart),
        [sum(rf_k in j..m-1)(distance[rf_k])
         | j in index_set(passengerStart)]
    );

array [index_set_1of2(arrival), index_set_2of2(arrival)]
    of int: rf_earliest_arrival =
    array2d(
        index_set_1of2(arrival),
        index_set_2of2(arrival),
        [max(
            [0] ++
            [scheduledDeparture[i,rf_k]
             + rf_remaining_distance[rf_k]
             - rf_remaining_distance[j]
             | rf_k in 1..j-1]
         )
         | i in index_set_1of2(arrival),
           j in index_set_2of2(arrival)]
    );

constraint forall(i in 1..n)(
    arrival[i,1] = 0
);

constraint forall(i in 1..n)(
    departure[i,m] = arrival[i,m]
);

constraint forall(i in 1..n, j in 1..m-1
                  where scheduledDeparture[i,j] <= delayTime)(
    departure[i,j] = scheduledDeparture[i,j]
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

constraint departure[delayTrain,destinationWhenDelayed] >=
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
    arrival[i,j] >= rf_earliest_arrival[i,j]
);

constraint forall(i in 1..n, j in 1..m)(
    departure[i,j] <= maxTime - rf_remaining_distance[j]
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

constraint forall(j in 2..m-1)(
    sum(i in 1..n)(collect[i,j]) =
        (scheduledDeparture[n,j] - passengerStart[j])
        * passengerFlow[j]
);

constraint
    sum(i in 1..n)(load[i,m]) =
        sum(i in 1..n)(collect[i,1])
        + sum(j in 2..m-1)(
            (scheduledDeparture[n,j] - passengerStart[j])
            * passengerFlow[j]
          );

constraint forall(i in 1..n, j in 1..m-1)(
    (sigmaUpper[i,j] = sigmaLower[i,j]) \/
    (sigmaUpper[i,j] = departure[i,j]) \/
    (sigmaUpper[i,j] = scheduledDeparture[n,j]) \/
    (
        if passengerFlow[j] > 0 then
            sigmaUpper[i,j] < scheduledDeparture[n,j] /\
            load[i,j] >= capacity - passengerFlow[j] + 1
        else
            false
        endif
    )
);

constraint forall(i in 1..n, j in 1..m)(
    dwell[i,j] = departure[i,j] - arrival[i,j]
);

constraint forall(i in 1..n, j in 1..m)(
    collect[i,j] <= 50 * dwell[i,j]
);

constraint forall(i in 1..n, j in 2..m)(
    if capacity < 100 then
        collect[i,j] <= 20 * dwell[i,j]
    else
        (load[i,j-1] <= capacity - 100) \/
        (collect[i,j] <= 20 * dwell[i,j])
    endif
);

function int: rf_bit_length(int: rf_value) =
    if rf_value <= 0 then
        0
    else
        1 + rf_bit_length(rf_value div 2)
    endif;

bool: rf_expand_load = capacity <= maxTime;
int: rf_expansion_bound = min(capacity, maxTime);
int: rf_other_bound = max(capacity, maxTime);

array [int] of int: rf_weights =
    [pow(2, rf_k)
     | rf_k in 0..rf_bit_length(rf_expansion_bound)-1];

array [index_set_1of2(load), index_set(rf_weights)]
    of var 0..1: rf_digit;

array [index_set_1of2(load), index_set(rf_weights)]
    of var 0..rf_other_bound: rf_piece;

constraint forall(i in index_set_1of2(load))(
    if rf_expand_load then
        load[i,m] =
            sum(rf_k in index_set(rf_weights))(
                rf_weights[rf_k] * rf_digit[i,rf_k]
            )
    else
        arrival[i,m] =
            sum(rf_k in index_set(rf_weights))(
                rf_weights[rf_k] * rf_digit[i,rf_k]
            )
    endif
);

constraint forall(i in index_set_1of2(load),
                  rf_k in index_set(rf_weights))(
    rf_piece[i,rf_k] <= rf_other_bound * rf_digit[i,rf_k]
);

constraint forall(i in index_set_1of2(load),
                  rf_k in index_set(rf_weights))(
    if rf_expand_load then
        rf_piece[i,rf_k] <= arrival[i,m] /\
        rf_piece[i,rf_k] >=
            arrival[i,m] - rf_other_bound * (1 - rf_digit[i,rf_k])
    else
        rf_piece[i,rf_k] <= load[i,m] /\
        rf_piece[i,rf_k] >=
            load[i,m] - rf_other_bound * (1 - rf_digit[i,rf_k])
    endif
);

constraint forall(i in index_set_1of2(load),
                  rf_k in index_set(rf_weights))(
    if rf_expand_load then
        rf_piece[i,rf_k] >=
            rf_earliest_arrival[i,m] * rf_digit[i,rf_k] /\
        rf_piece[i,rf_k] <=
            arrival[i,m]
            - rf_earliest_arrival[i,m] * (1 - rf_digit[i,rf_k])
    else
        true
    endif
);

int: cost_min = lb(sum(i in 1..n)(load[i,m] * arrival[i,m]));
int: cost_max = ub(sum(i in 1..n)(load[i,m] * arrival[i,m]));

var cost_min..cost_max: cost =
    sum(i in index_set_1of2(load), rf_k in index_set(rf_weights))(
        rf_weights[rf_k] * rf_piece[i,rf_k]
    );

solve minimize cost;

output [show(cost)];
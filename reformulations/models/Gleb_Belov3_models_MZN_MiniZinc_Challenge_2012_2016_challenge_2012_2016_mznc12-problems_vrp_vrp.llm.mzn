int: N;
int: Capacity;
int: K = N;

array[1..N] of int: Demand;
array[1..N+1, 1..N+1] of int: Distance;

array[0..N, 0..N] of var 0..1: x;
array[1..N] of var 0..Capacity: u;

array[index_set(Demand)] of int: vrp_rf_lb =
    array1d(
        index_set(Demand),
        [max(0, Demand[i]) | i in index_set(Demand)]
    );

constraint
    forall(j in 1..N)(
        sum(i in 0..N)(x[i, j]) = 1
    );

constraint
    forall(i in 1..N)(
        sum(j in 0..N)(x[i, j]) = 1
    );

constraint
    sum(i in 0..N)(x[i, 0]) <= K;

constraint
    sum(j in 0..N)(x[0, j]) <= K;

constraint
    forall(i in 1..N)(
        Demand[i] <= u[i]
    );

constraint
    forall(i in 1..N, j in 1..N)(
        u[i] - u[j]
        + (Capacity + Demand[j] - vrp_rf_lb[j]) * x[i, j]
        <= Capacity - vrp_rf_lb[j]
    );

constraint
    forall(i in 1..N where Demand[i] > 0)(
        x[i, i] = 0
    );

constraint
    forall(
        i in 1..N,
        j in 1..N
        where vrp_rf_lb[i] + Demand[j] > Capacity
    )(
        x[i, j] = 0
    );

constraint
    forall(
        i in 1..N,
        j in 1..N
        where i < j /\ Demand[i] + Demand[j] > 0
    )(
        x[i, j] + x[j, i] <= 1
    );

constraint
    forall(j in 1..N)(
        u[j] >= vrp_rf_lb[j]
        + sum(i in 1..N)(
            max(0, vrp_rf_lb[i] + Demand[j] - vrp_rf_lb[j])
            * x[i, j]
        )
    );

constraint
    forall(i in 1..N)(
        u[i] <= Capacity
        - sum(j in 1..N)(
            max(0, Demand[j]) * x[i, j]
        )
    );

constraint
    if Capacity > 0
       /\ forall(i in index_set(Demand))(Demand[i] >= 0)
    then
        sum(j in 1..N)(x[0, j])
        >= (sum(Demand) + Capacity - 1) div Capacity
    else
        true
    endif;

var int: objective =
    sum(i in 0..N, j in 0..N)(
        Distance[i+1, j+1] * x[i, j]
    );

solve minimize objective;

output [
    "x = ", show(x), "\n",
    "objective = ", show(objective), "\n"
];
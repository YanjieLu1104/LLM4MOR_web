int: N;
int: Capacity;
int: K = N;

array[1..N] of int: Demand;
array[1..N+1, 1..N+1] of int: Distance;

array[0..N, 0..N] of var 0..1: x;
array[1..N] of var 0..Capacity: u;

array[index_set(u), index_set_2of2(x)]
    of var 0.0..int2float(max(0, Capacity)): vrp_rf_load_flow;

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
    forall(
        vrp_rf_i in index_set(u),
        vrp_rf_j in index_set_2of2(x)
    )(
        vrp_rf_load_flow[vrp_rf_i, vrp_rf_j]
        <= int2float(Capacity) * int2float(x[vrp_rf_i, vrp_rf_j])
    );

constraint
    forall(
        vrp_rf_i in index_set(u),
        vrp_rf_j in index_set_2of2(x)
    )(
        vrp_rf_load_flow[vrp_rf_i, vrp_rf_j]
        >= int2float(max(0, Demand[vrp_rf_i]))
           * int2float(x[vrp_rf_i, vrp_rf_j])
    );

constraint
    forall(vrp_rf_i in index_set(u))(
        sum(vrp_rf_j in index_set_2of2(x))(
            vrp_rf_load_flow[vrp_rf_i, vrp_rf_j]
        ) = int2float(u[vrp_rf_i])
    );

constraint
    forall(vrp_rf_j in index_set(u))(
        sum(vrp_rf_i in index_set(u))(
            vrp_rf_load_flow[vrp_rf_i, vrp_rf_j]
        ) <= int2float(u[vrp_rf_j]) - int2float(Demand[vrp_rf_j])
    );

constraint
    forall(
        vrp_rf_i in index_set(u)
        where Demand[vrp_rf_i] > 0
    )(
        x[vrp_rf_i, vrp_rf_i] = 0
    );

constraint
    forall(
        vrp_rf_i in index_set(u),
        vrp_rf_j in index_set(u)
        where vrp_rf_i != vrp_rf_j
          /\ max(0, Demand[vrp_rf_i]) + Demand[vrp_rf_j] > Capacity
    )(
        x[vrp_rf_i, vrp_rf_j] = 0
    );

int: obj_min = 0;
int: obj_max = sum(i, j in 0..N)(Distance[i+1, j+1]);

var obj_min..obj_max: objective =
    sum(i, j in 0..N)(
        Distance[i+1, j+1] * x[i, j]
    );

solve minimize objective;

output [
    "x = ", show(x), ";\n",
    "objective = ", show(objective), ";\n"
];
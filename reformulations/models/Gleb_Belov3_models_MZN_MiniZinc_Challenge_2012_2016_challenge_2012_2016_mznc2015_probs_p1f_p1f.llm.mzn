int: n;
int: m = n-1;

array[1..m, 1..n] of var 1..n: p;

int: obj_lb = sum(i in 1..n)(i);
int: obj_ub = sum(i in 1..n)(i * n);
var obj_lb..obj_ub: objective =
    sum(i in 1..n)(i * p[1, i]);

set of int: rf_nodes = index_set_2of2(p);
set of int: rf_rows = index_set_1of2(p);

int: rf_edge_count =
    card(rf_nodes) * (card(rf_nodes) - 1) div 2;

array[1..rf_edge_count] of int: rf_edge_u =
    [rf_u | rf_u, rf_v in rf_nodes where rf_u < rf_v];

array[index_set(rf_edge_u)] of int: rf_edge_v =
    [rf_v | rf_u, rf_v in rf_nodes where rf_u < rf_v];

int: rf_pair_count =
    card(rf_rows) * (card(rf_rows) - 1) div 2;

array[1..rf_pair_count] of int: rf_pair_a =
    [rf_a | rf_a, rf_b in rf_rows where rf_a < rf_b];

array[index_set(rf_pair_a)] of int: rf_pair_b =
    [rf_b | rf_a, rf_b in rf_rows where rf_a < rf_b];

array[rf_rows, index_set(rf_edge_u)] of var 0..1: rf_edge;

float: rf_capacity =
    int2float(max(0, card(rf_nodes) - 1)) / 2.0;

array[index_set(rf_pair_a), index_set(rf_edge_u)]
    of var (-rf_capacity)..rf_capacity: rf_flow;

constraint
    card(rf_rows) = 0 \/ card(rf_nodes) mod 2 = 0;

constraint
    forall(rf_r in rf_rows, rf_v in rf_nodes)(
        sum(rf_e in index_set(rf_edge_u)
            where rf_edge_u[rf_e] = rf_v \/
                  rf_edge_v[rf_e] = rf_v)(
            rf_edge[rf_r, rf_e]
        ) = 1
    );

constraint
    forall(rf_e in index_set(rf_edge_u))(
        sum(rf_r in rf_rows)(rf_edge[rf_r, rf_e]) = 1
    );

constraint
    forall(rf_r in rf_rows, rf_v in rf_nodes)(
        p[rf_r, rf_v] =
            sum(rf_e in index_set(rf_edge_u)
                where rf_edge_u[rf_e] = rf_v)(
                rf_edge_v[rf_e] * rf_edge[rf_r, rf_e]
            )
            +
            sum(rf_e in index_set(rf_edge_u)
                where rf_edge_v[rf_e] = rf_v)(
                rf_edge_u[rf_e] * rf_edge[rf_r, rf_e]
            )
    );

constraint
    forall(rf_r in rf_rows, rf_e in index_set(rf_edge_u)
        where rf_edge_u[rf_e] = 1 /\
              rf_edge_v[rf_e] = rf_r + 1)(
        symmetry_breaking_constraint(
            rf_edge[rf_r, rf_e] = 1
        )
    );

constraint
    forall(rf_q in index_set(rf_pair_a),
           rf_e in index_set(rf_edge_u))(
        rf_flow[rf_q, rf_e] <=
            rf_capacity * int2float(
                rf_edge[rf_pair_a[rf_q], rf_e] +
                rf_edge[rf_pair_b[rf_q], rf_e]
            )
        /\
        rf_flow[rf_q, rf_e] >=
            -rf_capacity * int2float(
                rf_edge[rf_pair_a[rf_q], rf_e] +
                rf_edge[rf_pair_b[rf_q], rf_e]
            )
    );

constraint
    forall(rf_q in index_set(rf_pair_a), rf_v in rf_nodes)(
        sum(rf_e in index_set(rf_edge_u)
            where rf_edge_u[rf_e] = rf_v)(
            rf_flow[rf_q, rf_e]
        )
        -
        sum(rf_e in index_set(rf_edge_u)
            where rf_edge_v[rf_e] = rf_v)(
            rf_flow[rf_q, rf_e]
        )
        =
        int2float(
            if rf_v = 1 then
                card(rf_nodes) - 1
            else
                -1
            endif
        )
    );

constraint
    if card(rf_nodes) >= 2 /\ card(rf_nodes) mod 2 = 0 then
        p[1, 1] = 2 ->
        objective >=
            4 + sum(rf_v in rf_nodes where rf_v >= 3)(
                rf_v * (n + 3 - rf_v)
            )
    else
        true
    endif;

solve minimize objective;

output [
    "p = \(p);\n",
    "objective = \(objective);\n"
];
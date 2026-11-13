include "globals.mzn";

int: c;
int: p;

set of int: Custs = 1..c;
set of int: Prods = 1..p;

array[Custs,Prods] of 0..1: orders;

array[Custs] of int: norders =
    [sum(j in Prods)(orders[i,j]) | i in Custs];

array[Prods] of var Prods: s;

array[Custs,0..p] of var 0..max(norders): o;
var 0..c: objective;

array[index_set(s),index_set(s)] of var 0..1: rf_assignment;

array[index_set_1of2(o),index_set_2of2(o)] of var 0..1:
    rf_started;

array[index_set_1of2(o),index_set_2of2(o)] of var 0..1:
    rf_finished;

constraint forall(rf_t in Prods)(
    sum(rf_k in Prods)(rf_assignment[rf_t,rf_k]) = 1
);

constraint forall(rf_k in Prods)(
    sum(rf_t in Prods)(rf_assignment[rf_t,rf_k]) = 1
);

constraint forall(rf_t in Prods)(
    s[rf_t] =
        sum(rf_k in Prods)(rf_k * rf_assignment[rf_t,rf_k])
);

constraint forall(rf_i in Custs)(
    o[rf_i,0] = 0
);

constraint forall(rf_i in Custs, rf_t in Prods)(
    o[rf_i,rf_t] =
        o[rf_i,rf_t-1] +
        sum(rf_k in Prods where orders[rf_i,rf_k] = 1)(
            rf_assignment[rf_t,rf_k]
        )
);

constraint forall(rf_i in Custs)(
    o[rf_i,p] = norders[rf_i]
);

constraint forall(
    rf_i in Custs,
    rf_t in index_set_2of2(o)
    where norders[rf_i] = 0
)(
    rf_started[rf_i,rf_t] = 0 /\
    rf_finished[rf_i,rf_t] = 1
);

constraint forall(rf_i in Custs where norders[rf_i] > 0)(
    rf_started[rf_i,0] = 0 /\
    rf_started[rf_i,p] = 1 /\
    rf_finished[rf_i,0] = 0 /\
    rf_finished[rf_i,p] = 1
);

constraint forall(
    rf_i in Custs,
    rf_t in Prods
    where norders[rf_i] > 0
)(
    let {
        var 0..1: rf_hit = o[rf_i,rf_t] - o[rf_i,rf_t-1]
    } in
        rf_started[rf_i,rf_t] >= rf_started[rf_i,rf_t-1] /\
        rf_started[rf_i,rf_t] >= rf_hit /\
        rf_started[rf_i,rf_t] <=
            rf_started[rf_i,rf_t-1] + rf_hit /\
        rf_finished[rf_i,rf_t-1] <= rf_finished[rf_i,rf_t] /\
        rf_finished[rf_i,rf_t-1] <= 1 - rf_hit /\
        rf_finished[rf_i,rf_t-1] >=
            rf_finished[rf_i,rf_t] - rf_hit /\
        rf_started[rf_i,rf_t] - rf_finished[rf_i,rf_t-1] >= rf_hit
);

constraint forall(
    rf_i in Custs,
    rf_t in index_set_2of2(o)
    where norders[rf_i] > 0
)(
    o[rf_i,rf_t] >= rf_started[rf_i,rf_t] /\
    o[rf_i,rf_t] <= norders[rf_i] * rf_started[rf_i,rf_t] /\
    o[rf_i,rf_t] >= norders[rf_i] * rf_finished[rf_i,rf_t] /\
    o[rf_i,rf_t] <= norders[rf_i] - 1 + rf_finished[rf_i,rf_t]
);

constraint objective =
    max(rf_t in Prods)(
        sum(rf_i in Custs where norders[rf_i] > 0)(
            rf_started[rf_i,rf_t] - rf_finished[rf_i,rf_t-1]
        )
    );

constraint forall(rf_k in Prods)(
    objective >= sum(rf_i in Custs)(orders[rf_i,rf_k])
);

solve minimize objective;

output [
    "s = \(s);\n",
    "objective = \(objective);\n"
] ++ [
    if t = 1 then "% " else "" endif ++
    "\(o[i,t])" ++
    if t = p then "\n" else " " endif
    | i in Custs, t in 1..p
];
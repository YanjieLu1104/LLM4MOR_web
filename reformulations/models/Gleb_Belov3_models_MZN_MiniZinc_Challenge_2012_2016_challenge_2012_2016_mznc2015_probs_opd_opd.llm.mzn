include "lex_greatereq.mzn";

int: v;
int: b;
int: r;

set of int: rows = 1..v;
set of int: cols = 1..b;

int: rv = r*v;
int: rvmodb = rv mod b;
int: floorrv = rv div b;
int: ceilrv = rv div b + bool2int(rv mod b != 0);
int: num =
    ceilrv*ceilrv*rvmodb
    + floorrv*floorrv*(b-rvmodb)
    - rv;
int: denom = v*(v-1);
int: lb_lambda =
    num div denom + bool2int(num mod denom != 0);

array [rows, cols] of var 0..1: m;
var lb_lambda..b: objective;

array [int] of int: opd_rf_pair_left = [
    opd_rf_a
    | opd_rf_a, opd_rf_b in index_set_1of2(m)
    where opd_rf_a < opd_rf_b
];

array [int] of int: opd_rf_pair_right = [
    opd_rf_b
    | opd_rf_a, opd_rf_b in index_set_1of2(m)
    where opd_rf_a < opd_rf_b
];

array [
    index_set(opd_rf_pair_left),
    index_set_2of2(m)
] of var 0.0..1.0: opd_rf_overlap;

constraint forall(opd_rf_i in rows)(
    sum(opd_rf_j in cols)(m[opd_rf_i, opd_rf_j]) = r
);

constraint forall(
    opd_rf_p in index_set(opd_rf_pair_left),
    opd_rf_j in index_set_2of2(m)
)(
    opd_rf_overlap[opd_rf_p, opd_rf_j] >=
    int2float(
        m[opd_rf_pair_left[opd_rf_p], opd_rf_j]
        + m[opd_rf_pair_right[opd_rf_p], opd_rf_j]
        - 1
    )
);

constraint forall(
    opd_rf_p in index_set(opd_rf_pair_left),
    opd_rf_j in index_set_2of2(m)
)(
    opd_rf_overlap[opd_rf_p, opd_rf_j] <=
    int2float(m[opd_rf_pair_left[opd_rf_p], opd_rf_j])
);

constraint forall(
    opd_rf_p in index_set(opd_rf_pair_left),
    opd_rf_j in index_set_2of2(m)
)(
    opd_rf_overlap[opd_rf_p, opd_rf_j] <=
    int2float(m[opd_rf_pair_right[opd_rf_p], opd_rf_j])
);

constraint forall(opd_rf_p in index_set(opd_rf_pair_left))(
    sum(opd_rf_j in index_set_2of2(m))(
        opd_rf_overlap[opd_rf_p, opd_rf_j]
    ) <= int2float(objective)
);

constraint forall(
    opd_rf_j in index_set_2of2(m),
    opd_rf_k in 1..(card(index_set_1of2(m)) - 1)
)(
    sum(opd_rf_p in index_set(opd_rf_pair_left))(
        opd_rf_overlap[opd_rf_p, opd_rf_j]
    ) >=
    int2float(
        opd_rf_k
        * sum(opd_rf_i in index_set_1of2(m))(
            m[opd_rf_i, opd_rf_j]
        )
        - (opd_rf_k * (opd_rf_k + 1)) div 2
    )
);

constraint
    if v >= 2 /\ b > 0 then
        sum(
            opd_rf_p in index_set(opd_rf_pair_left),
            opd_rf_j in index_set_2of2(m)
        )(
            opd_rf_overlap[opd_rf_p, opd_rf_j]
        ) >= int2float(num div 2)
    else
        true
    endif;

constraint symmetry_breaking_constraint(
    forall(opd_rf_i in rows diff {max(rows)})(
        lex_greatereq(
            [m[opd_rf_i, opd_rf_j] | opd_rf_j in cols],
            [m[opd_rf_i+1, opd_rf_j] | opd_rf_j in cols]
        )
    )
);

constraint symmetry_breaking_constraint(
    forall(opd_rf_j in cols diff {max(cols)})(
        lex_greatereq(
            [m[opd_rf_i, opd_rf_j] | opd_rf_i in rows],
            [m[opd_rf_i, opd_rf_j+1] | opd_rf_i in rows]
        )
    )
);

solve minimize objective;

output [
    "% lb(lambda) = ", show(lb_lambda), ";\n",
    "objective = ", show(objective), ";\n",
    "m = array2d(", show(rows), ", ", show(cols), ", ", show(m), ");\n"
];
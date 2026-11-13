int: n;
set of int: PIZZA = 1..n;
array[PIZZA] of int: price;

int: m;
set of int: VOUCHER = 1..m;
array[VOUCHER] of int: buy;
array[VOUCHER] of int: free;

set of int: ASSIGN = -m..m;

array[PIZZA] of var ASSIGN: how;
array[VOUCHER] of var bool: used;

array[int] of int: rf_levels =
    [rf_value |
        rf_value in {price[rf_p] | rf_p in index_set(price)}];

array[index_set(price)] of int: rf_lower =
    array1d(
        index_set(price),
        [
            sum(rf_k in index_set(rf_levels))(
                bool2int(rf_levels[rf_k] < price[rf_p])
            )
            | rf_p in index_set(price)
        ]
    );

array[index_set(price), index_set(buy)] of var 0..1: rf_paid;
array[index_set(price), index_set(buy)] of var 0..1: rf_gift;

array[index_set(buy), 0..length(rf_levels)] of var 0.0..1.0:
    rf_cut;

constraint forall(rf_p in index_set(price))(
    sum(rf_v in index_set(buy))(
        rf_paid[rf_p, rf_v] + rf_gift[rf_p, rf_v]
    ) <= 1
);

constraint forall(rf_p in index_set(price))(
    how[rf_p] =
        sum(rf_v in index_set(buy))(
            rf_v * (rf_gift[rf_p, rf_v] - rf_paid[rf_p, rf_v])
        )
);

constraint forall(rf_v in index_set(buy))(
    sum(rf_p in index_set(price))(rf_paid[rf_p, rf_v])
        = buy[rf_v] * bool2int(used[rf_v])
);

constraint forall(rf_v in index_set(buy) where buy[rf_v] <= 0)(
    used[rf_v]
);

constraint forall(rf_v in index_set(buy))(
    sum(rf_p in index_set(price))(rf_gift[rf_p, rf_v])
        <= free[rf_v] * bool2int(used[rf_v])
);

constraint forall(rf_v in index_set(buy))(
    rf_cut[rf_v, 0] = 0.0
);

constraint forall(
    rf_v in index_set(buy),
    rf_k in index_set(rf_levels)
)(
    rf_cut[rf_v, rf_k - 1] <= rf_cut[rf_v, rf_k]
);

constraint forall(
    rf_p in index_set(price),
    rf_v in index_set(buy)
)(
    int2float(rf_paid[rf_p, rf_v])
        <= rf_cut[rf_v, rf_lower[rf_p] + 1]
);

constraint forall(
    rf_p in index_set(price),
    rf_v in index_set(buy)
)(
    int2float(rf_gift[rf_p, rf_v])
        + rf_cut[rf_v, rf_lower[rf_p]] <= 1.0
);

int: total = sum(price);

var 0..total: objective =
    sum(rf_p in index_set(price))(
        price[rf_p] *
        (1 - sum(rf_v in index_set(buy))(rf_gift[rf_p, rf_v]))
    );

solve minimize objective;

output [
    "how = " ++ show(how) ++ ";\nobjective = "
        ++ show(objective) ++ ";\n"
];
include "globals.mzn";

int: K;
int: NrI;
int: NrT_pos;
int: NrT_neg;

array [1..NrT_pos] of set of int: TDB_pos;
array [1..NrT_neg] of set of int: TDB_neg;

array [1..K,1..NrI] of var bool: Items;
array [1..K,1..NrT_pos] of var bool: TransP;
array [1..K,1..NrT_neg] of var bool: TransN;

array [1..NrT_pos] of var bool: Trans_pos;
array [1..NrT_neg] of var bool: Trans_neg;

var -NrT_neg..NrT_pos: objective =
    sum(t in 1..NrT_pos)(bool2int(Trans_pos[t])) -
    sum(t in 1..NrT_neg)(bool2int(Trans_neg[t]));

array [index_set(TDB_pos)] of set of int: reform_missing_pos =
    array1d(
        index_set(TDB_pos),
        [
            {
                reform_i
                | reform_i in index_set_2of2(Items)
                where not (reform_i in TDB_pos[reform_t])
            }
            | reform_t in index_set(TDB_pos)
        ]
    );

array [index_set(TDB_neg)] of set of int: reform_missing_neg =
    array1d(
        index_set(TDB_neg),
        [
            {
                reform_i
                | reform_i in index_set_2of2(Items)
                where not (reform_i in TDB_neg[reform_t])
            }
            | reform_t in index_set(TDB_neg)
        ]
    );

array [index_set_2of2(Items)] of set of int: reform_missing_item_pos =
    array1d(
        index_set_2of2(Items),
        [
            {
                reform_t
                | reform_t in index_set(TDB_pos)
                where reform_i in reform_missing_pos[reform_t]
            }
            | reform_i in index_set_2of2(Items)
        ]
    );

constraint
    forall(
        reform_d in index_set_1of2(Items),
        reform_t in index_set(TDB_pos),
        reform_i in reform_missing_pos[reform_t]
    ) (
        bool2int(Items[reform_d,reform_i]) +
        bool2int(TransP[reform_d,reform_t]) <= 1
    );

constraint
    forall(
        reform_d in index_set_1of2(Items),
        reform_t in index_set(TDB_pos)
    ) (
        bool2int(TransP[reform_d,reform_t]) +
        sum(reform_i in reform_missing_pos[reform_t])(
            bool2int(Items[reform_d,reform_i])
        ) >= 1
    );

constraint
    forall(
        reform_d in index_set_1of2(Items),
        reform_i in index_set_2of2(Items)
    ) (
        bool2int(Items[reform_d,reform_i]) +
        sum(reform_t in reform_missing_item_pos[reform_i])(
            bool2int(TransP[reform_d,reform_t])
        ) >= 1
    );

constraint
    forall(
        reform_d in index_set_1of2(Items),
        reform_t in index_set(TDB_neg),
        reform_i in reform_missing_neg[reform_t]
    ) (
        bool2int(Items[reform_d,reform_i]) +
        bool2int(TransN[reform_d,reform_t]) <= 1
    );

constraint
    forall(
        reform_d in index_set_1of2(Items),
        reform_t in index_set(TDB_neg)
    ) (
        bool2int(TransN[reform_d,reform_t]) +
        sum(reform_i in reform_missing_neg[reform_t])(
            bool2int(Items[reform_d,reform_i])
        ) >= 1
    );

constraint
    forall(d in 1..K-1) (
        lex_less(
            [TransP[d,t] | t in 1..NrT_pos],
            [TransP[d+1,t] | t in 1..NrT_pos]
        )
        /\
        lex_less(
            [TransN[d,t] | t in 1..NrT_neg],
            [TransN[d+1,t] | t in 1..NrT_neg]
        )
    );

constraint
    forall(
        reform_d in index_set_1of2(TransP),
        reform_t in index_set(Trans_pos)
    ) (
        bool2int(TransP[reform_d,reform_t]) <=
        bool2int(Trans_pos[reform_t])
    );

constraint
    forall(reform_t in index_set(Trans_pos)) (
        bool2int(Trans_pos[reform_t]) <=
        sum(reform_d in index_set_1of2(TransP))(
            bool2int(TransP[reform_d,reform_t])
        )
    );

constraint
    forall(
        reform_d in index_set_1of2(TransN),
        reform_t in index_set(Trans_neg)
    ) (
        bool2int(TransN[reform_d,reform_t]) <=
        bool2int(Trans_neg[reform_t])
    );

constraint
    forall(reform_t in index_set(Trans_neg)) (
        bool2int(Trans_neg[reform_t]) <=
        sum(reform_d in index_set_1of2(TransN))(
            bool2int(TransN[reform_d,reform_t])
        )
    );

solve maximize objective;

output [
    "objective = ", show(objective), ";\n",
    "Items = ", show(Items), ";\n"
];
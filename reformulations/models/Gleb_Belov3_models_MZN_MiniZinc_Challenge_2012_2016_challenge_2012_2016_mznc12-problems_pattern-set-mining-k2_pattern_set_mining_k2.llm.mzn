include "globals.mzn";

int: K = 2;

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

array [index_set(TDB_pos)] of set of int: rf_absent_pos =
    array1d(
        index_set(TDB_pos),
        [
            {
                rf_i
                | rf_i in index_set_2of2(Items)
                where not (rf_i in TDB_pos[rf_t])
            }
            | rf_t in index_set(TDB_pos)
        ]
    );

array [index_set(TDB_neg)] of set of int: rf_absent_neg =
    array1d(
        index_set(TDB_neg),
        [
            {
                rf_i
                | rf_i in index_set_2of2(Items)
                where not (rf_i in TDB_neg[rf_t])
            }
            | rf_t in index_set(TDB_neg)
        ]
    );

constraint
    forall(
        rf_d in index_set_1of2(Items),
        rf_t in index_set(TDB_pos),
        rf_i in rf_absent_pos[rf_t]
    ) (
        bool2int(Items[rf_d,rf_i]) +
        bool2int(TransP[rf_d,rf_t]) <= 1
    );

constraint
    forall(
        rf_d in index_set_1of2(Items),
        rf_t in index_set(TDB_pos)
    ) (
        bool2int(TransP[rf_d,rf_t]) +
        sum(rf_i in rf_absent_pos[rf_t]) (
            bool2int(Items[rf_d,rf_i])
        ) >= 1
    );

constraint
    forall(
        rf_d in index_set_1of2(Items),
        rf_i in index_set_2of2(Items)
    ) (
        bool2int(Items[rf_d,rf_i]) +
        sum(
            rf_t in index_set(TDB_pos)
            where rf_i in rf_absent_pos[rf_t]
        ) (
            bool2int(TransP[rf_d,rf_t])
        ) >= 1
    );

constraint
    forall(
        rf_d in index_set_1of2(Items),
        rf_t in index_set(TDB_neg),
        rf_i in rf_absent_neg[rf_t]
    ) (
        bool2int(Items[rf_d,rf_i]) +
        bool2int(TransN[rf_d,rf_t]) <= 1
    );

constraint
    forall(
        rf_d in index_set_1of2(Items),
        rf_t in index_set(TDB_neg)
    ) (
        bool2int(TransN[rf_d,rf_t]) +
        sum(rf_i in rf_absent_neg[rf_t]) (
            bool2int(Items[rf_d,rf_i])
        ) >= 1
    );

constraint
    forall(rf_d in 1..K-1) (
        lex_less(
            [TransP[rf_d,rf_t] | rf_t in index_set_2of2(TransP)],
            [TransP[rf_d+1,rf_t] | rf_t in index_set_2of2(TransP)]
        )
        /\
        lex_less(
            [TransN[rf_d,rf_t] | rf_t in index_set_2of2(TransN)],
            [TransN[rf_d+1,rf_t] | rf_t in index_set_2of2(TransN)]
        )
    );

constraint
    forall(
        rf_d in index_set_1of2(TransP),
        rf_t in index_set(Trans_pos)
    ) (
        bool2int(TransP[rf_d,rf_t]) <= bool2int(Trans_pos[rf_t])
    );

constraint
    forall(rf_t in index_set(Trans_pos)) (
        bool2int(Trans_pos[rf_t]) <=
        sum(rf_d in index_set_1of2(TransP)) (
            bool2int(TransP[rf_d,rf_t])
        )
    );

constraint
    forall(
        rf_d in index_set_1of2(TransN),
        rf_t in index_set(Trans_neg)
    ) (
        bool2int(TransN[rf_d,rf_t]) <= bool2int(Trans_neg[rf_t])
    );

constraint
    forall(rf_t in index_set(Trans_neg)) (
        bool2int(Trans_neg[rf_t]) <=
        sum(rf_d in index_set_1of2(TransN)) (
            bool2int(TransN[rf_d,rf_t])
        )
    );

solve maximize
    sum(rf_t in index_set(Trans_pos)) (
        bool2int(Trans_pos[rf_t])
    )
    -
    sum(rf_t in index_set(Trans_neg)) (
        bool2int(Trans_neg[rf_t])
    );

output [show(Items), "\n"];
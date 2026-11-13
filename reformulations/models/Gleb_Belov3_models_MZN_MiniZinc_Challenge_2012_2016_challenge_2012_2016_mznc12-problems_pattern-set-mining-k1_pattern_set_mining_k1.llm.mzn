int: K = 1;

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

array [index_set(TDB_pos)] of set of int: rf_missing_pos =
    array1d(
        index_set(TDB_pos),
        [
            {
                rf_item |
                rf_item in index_set_2of2(Items)
                where not (rf_item in TDB_pos[rf_transaction])
            }
            | rf_transaction in index_set(TDB_pos)
        ]
    );

array [index_set(TDB_neg)] of set of int: rf_missing_neg =
    array1d(
        index_set(TDB_neg),
        [
            {
                rf_item |
                rf_item in index_set_2of2(Items)
                where not (rf_item in TDB_neg[rf_transaction])
            }
            | rf_transaction in index_set(TDB_neg)
        ]
    );

constraint
    forall(
        rf_pattern in index_set_1of2(Items),
        rf_transaction in index_set(TDB_pos),
        rf_item in rf_missing_pos[rf_transaction]
    ) (
        bool2int(Items[rf_pattern,rf_item]) +
        bool2int(TransP[rf_pattern,rf_transaction]) <= 1
    );

constraint
    forall(
        rf_pattern in index_set_1of2(Items),
        rf_transaction in index_set(TDB_pos)
    ) (
        bool2int(TransP[rf_pattern,rf_transaction]) +
        sum(rf_item in rf_missing_pos[rf_transaction]) (
            bool2int(Items[rf_pattern,rf_item])
        ) >= 1
    );

constraint
    forall(
        rf_pattern in index_set_1of2(Items),
        rf_item in index_set_2of2(Items)
    ) (
        bool2int(Items[rf_pattern,rf_item]) +
        sum(
            rf_transaction in index_set(TDB_pos)
            where rf_item in rf_missing_pos[rf_transaction]
        ) (
            bool2int(TransP[rf_pattern,rf_transaction])
        ) >= 1
    );

constraint
    forall(
        rf_pattern in index_set_1of2(Items),
        rf_transaction in index_set(TDB_neg),
        rf_item in rf_missing_neg[rf_transaction]
    ) (
        bool2int(Items[rf_pattern,rf_item]) +
        bool2int(TransN[rf_pattern,rf_transaction]) <= 1
    );

constraint
    forall(
        rf_pattern in index_set_1of2(Items),
        rf_transaction in index_set(TDB_neg)
    ) (
        bool2int(TransN[rf_pattern,rf_transaction]) +
        sum(rf_item in rf_missing_neg[rf_transaction]) (
            bool2int(Items[rf_pattern,rf_item])
        ) >= 1
    );

constraint
    forall(rf_transaction in index_set(Trans_pos)) (
        Trans_pos[rf_transaction] = TransP[1,rf_transaction]
    );

constraint
    forall(rf_transaction in index_set(Trans_neg)) (
        Trans_neg[rf_transaction] = TransN[1,rf_transaction]
    );

solve maximize
    sum(rf_transaction in index_set(Trans_pos)) (
        bool2int(Trans_pos[rf_transaction])
    ) -
    sum(rf_transaction in index_set(Trans_neg)) (
        bool2int(Trans_neg[rf_transaction])
    );

output [show(Items), "\n"];
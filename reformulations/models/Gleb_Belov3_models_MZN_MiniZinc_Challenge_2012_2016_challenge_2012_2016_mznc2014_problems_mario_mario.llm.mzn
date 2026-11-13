include "subcircuit.mzn";

int: nbHouses;
int: MarioHouse;
int: LuigiHouse;
int: fuelMax;
int: goldTotalAmount;

array[1..nbHouses, 1..nbHouses] of int: conso;
array[1..nbHouses] of int: goldInHouse;

array[1..nbHouses] of var 1..nbHouses: succ;
var 0..fuelMax: fuel;
var 0..goldTotalAmount: objective;

set of int: rf_mario_houses = index_set(goldInHouse);

array[index_set_1of2(conso)] of int: rf_mario_row_min =
    array1d(
        index_set_1of2(conso),
        [
            min([
                conso[rf_mario_i, rf_mario_j]
                | rf_mario_j in index_set_2of2(conso)
            ])
            | rf_mario_i in index_set_1of2(conso)
        ]
    );

array[index_set_1of2(conso)] of int: rf_mario_row_max =
    array1d(
        index_set_1of2(conso),
        [
            max([
                conso[rf_mario_i, rf_mario_j]
                | rf_mario_j in index_set_2of2(conso)
            ])
            | rf_mario_i in index_set_1of2(conso)
        ]
    );

int: rf_mario_min_total =
    sum(rf_mario_i in index_set(rf_mario_row_min))(
        rf_mario_row_min[rf_mario_i]
    );

int: rf_mario_max_total =
    sum(rf_mario_i in index_set(rf_mario_row_max))(
        rf_mario_row_max[rf_mario_i]
    );

array[
    index_set_1of2(conso),
    index_set_2of2(conso)
] of var bool: rf_mario_arc;

array[index_set(succ)] of
    var 0.0..int2float(max(0, nbHouses - 1)): rf_mario_order;

constraint forall(rf_mario_i in rf_mario_houses)(
    sum(rf_mario_j in rf_mario_houses)(
        bool2int(rf_mario_arc[rf_mario_i, rf_mario_j])
    ) = 1
);

constraint forall(rf_mario_j in rf_mario_houses)(
    sum(rf_mario_i in rf_mario_houses)(
        bool2int(rf_mario_arc[rf_mario_i, rf_mario_j])
    ) = 1
);

constraint forall(rf_mario_i in rf_mario_houses)(
    succ[rf_mario_i] =
        sum(rf_mario_j in rf_mario_houses)(
            rf_mario_j *
            bool2int(rf_mario_arc[rf_mario_i, rf_mario_j])
        )
);

constraint rf_mario_arc[LuigiHouse, MarioHouse];
constraint succ[LuigiHouse] = MarioHouse;

constraint forall(
    rf_mario_i in rf_mario_houses,
    rf_mario_j in rf_mario_houses
    where
        conso[rf_mario_i, rf_mario_j]
            + rf_mario_min_total
            - rf_mario_row_min[rf_mario_i] > fuelMax
        \/
        conso[rf_mario_i, rf_mario_j]
            + rf_mario_max_total
            - rf_mario_row_max[rf_mario_i] < 0
)(
    not rf_mario_arc[rf_mario_i, rf_mario_j]
);

constraint fuel =
    sum(
        rf_mario_i in rf_mario_houses,
        rf_mario_j in rf_mario_houses
    )(
        conso[rf_mario_i, rf_mario_j] *
        bool2int(rf_mario_arc[rf_mario_i, rf_mario_j])
    );

constraint objective =
    sum(rf_mario_i in rf_mario_houses)(
        goldInHouse[rf_mario_i] *
        (1 - bool2int(rf_mario_arc[rf_mario_i, rf_mario_i]))
    );

constraint
    if MarioHouse != LuigiHouse then
        rf_mario_order[MarioHouse] = 0.0
        /\
        forall(rf_mario_i in rf_mario_houses)(
            rf_mario_order[rf_mario_i] <=
                int2float(nbHouses - 1) *
                int2float(
                    1 - bool2int(
                        rf_mario_arc[rf_mario_i, rf_mario_i]
                    )
                )
        )
        /\
        forall(
            rf_mario_i in rf_mario_houses
            where rf_mario_i != MarioHouse
        )(
            rf_mario_order[rf_mario_i] >=
                int2float(
                    1 - bool2int(
                        rf_mario_arc[rf_mario_i, rf_mario_i]
                    )
                )
        )
        /\
        forall(
            rf_mario_i in rf_mario_houses,
            rf_mario_j in rf_mario_houses
            where
                rf_mario_i != rf_mario_j
                /\ rf_mario_j != MarioHouse
        )(
            rf_mario_order[rf_mario_j] >=
                rf_mario_order[rf_mario_i] + 1.0
                - int2float(nbHouses) *
                  int2float(
                      1 - bool2int(
                          rf_mario_arc[rf_mario_i, rf_mario_j]
                      )
                  )
        )
        /\
        rf_mario_order[LuigiHouse] =
            int2float(
                sum(rf_mario_i in rf_mario_houses)(
                    1 - bool2int(
                        rf_mario_arc[rf_mario_i, rf_mario_i]
                    )
                ) - 1
            )
    else
        subcircuit(succ)
        /\
        forall(rf_mario_i in rf_mario_houses)(
            rf_mario_order[rf_mario_i] = 0.0
        )
    endif;

solve maximize objective;

output [
    "%% Mario earned " ++ show(objective)
    ++ " gold coins with " ++ show(fuel) ++ "L of fuel\n",
    "succ = ", show(succ), ";\n",
    "objective = ", show(objective), ";\n"
];
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

array[index_set_1of2(conso), index_set_2of2(conso)] of var 0..1:
    mario_rf_arc;

array[index_set_1of2(conso)] of int: mario_rf_row_min =
    array1d(
        index_set_1of2(conso),
        [
            min(
                mario_rf_j in index_set_2of2(conso)
            )(conso[mario_rf_i, mario_rf_j])
            | mario_rf_i in index_set_1of2(conso)
        ]
    );

array[index_set_1of2(conso)] of int: mario_rf_row_max =
    array1d(
        index_set_1of2(conso),
        [
            max(
                mario_rf_j in index_set_2of2(conso)
            )(conso[mario_rf_i, mario_rf_j])
            | mario_rf_i in index_set_1of2(conso)
        ]
    );

int: mario_rf_total_min = sum(mario_rf_row_min);
int: mario_rf_total_max = sum(mario_rf_row_max);

constraint forall(mario_rf_i in index_set(succ)) (
    sum(mario_rf_j in index_set(succ)) (
        mario_rf_arc[mario_rf_i, mario_rf_j]
    ) = 1
);

constraint forall(mario_rf_j in index_set(succ)) (
    sum(mario_rf_i in index_set(succ)) (
        mario_rf_arc[mario_rf_i, mario_rf_j]
    ) = 1
);

constraint forall(mario_rf_i in index_set(succ)) (
    succ[mario_rf_i] =
    sum(mario_rf_j in index_set(succ)) (
        mario_rf_j * mario_rf_arc[mario_rf_i, mario_rf_j]
    )
);

constraint fuel =
    sum(
        mario_rf_i in index_set_1of2(conso),
        mario_rf_j in index_set_2of2(conso)
    ) (
        conso[mario_rf_i, mario_rf_j]
        * mario_rf_arc[mario_rf_i, mario_rf_j]
    );

constraint objective =
    sum(mario_rf_i in index_set(succ)) (
        goldInHouse[mario_rf_i]
        * (1 - mario_rf_arc[mario_rf_i, mario_rf_i])
    );

constraint succ[LuigiHouse] = MarioHouse;
constraint mario_rf_arc[LuigiHouse, MarioHouse] = 1;

constraint forall(
    mario_rf_i in index_set_1of2(conso),
    mario_rf_j in index_set_2of2(conso)
    where
        mario_rf_total_min
        - mario_rf_row_min[mario_rf_i]
        + conso[mario_rf_i, mario_rf_j] > fuelMax
        \/
        mario_rf_total_max
        - mario_rf_row_max[mario_rf_i]
        + conso[mario_rf_i, mario_rf_j] < 0
) (
    mario_rf_arc[mario_rf_i, mario_rf_j] = 0
);

constraint
    if MarioHouse != LuigiHouse then
        let {
            array[index_set(succ)] of var 0..max(0, nbHouses - 1):
                mario_rf_rank;
        } in
            mario_rf_rank[MarioHouse] = 0
            /\
            mario_rf_rank[LuigiHouse] =
                sum(mario_rf_i in index_set(succ)) (
                    1 - mario_rf_arc[mario_rf_i, mario_rf_i]
                ) - 1
            /\
            forall(
                mario_rf_i in index_set(succ)
                where mario_rf_i != MarioHouse
            ) (
                mario_rf_rank[mario_rf_i] >=
                    1 - mario_rf_arc[mario_rf_i, mario_rf_i]
            )
            /\
            forall(mario_rf_i in index_set(succ)) (
                mario_rf_rank[mario_rf_i] <=
                    (nbHouses - 1)
                    * (1 - mario_rf_arc[mario_rf_i, mario_rf_i])
                /\
                mario_rf_rank[mario_rf_i] <=
                    mario_rf_rank[LuigiHouse]
            )
            /\
            forall(
                mario_rf_i in index_set(succ),
                mario_rf_j in index_set(succ)
                where
                    mario_rf_i != mario_rf_j
                    /\ mario_rf_j != MarioHouse
            ) (
                mario_rf_rank[mario_rf_j] >=
                    mario_rf_rank[mario_rf_i] + 1
                    - nbHouses
                    * (1 - mario_rf_arc[mario_rf_i, mario_rf_j])
            )
    else
        subcircuit(succ)
    endif;

solve maximize objective;

output [
    "Mario earned " ++ show(objective)
    ++ "gold coins with " ++ show(fuel) ++ "L of fuel"
];
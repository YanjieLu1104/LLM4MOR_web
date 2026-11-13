array[1..416, 1..2] of int: neighbours;
array[1..17, 1..3] of int: layout;

array[1..52] of var 1..52: x;
array[1..52] of var 1..52: y;

neighbours = array2d(
    1..416,
    1..2,
    [
        if bh26_component = 1 then bh26_card_a else bh26_card_b endif
        | bh26_card_a in index_set(x),
          bh26_card_b in index_set(y),
          bh26_component in 1..2
        where
            abs(
                ((bh26_card_a - 1) mod 13) -
                ((bh26_card_b - 1) mod 13)
            ) in {1, 12}
    ]
);

set of int: bh26_ranks =
    {(bh26_card - 1) mod 13 | bh26_card in index_set(y)};

array[index_set(x), index_set(y)] of var 0..1: bh26_take;

constraint
    forall(bh26_position in index_set(x)) (
        sum(bh26_card in index_set(y)) (
            bh26_take[bh26_position, bh26_card]
        ) = 1
    );

constraint
    forall(bh26_card in index_set(y)) (
        sum(bh26_position in index_set(x)) (
            bh26_take[bh26_position, bh26_card]
        ) = 1
    );

constraint
    forall(bh26_position in index_set(x)) (
        x[bh26_position] =
        sum(bh26_card in index_set(y)) (
            bh26_card * bh26_take[bh26_position, bh26_card]
        )
    );

constraint
    forall(bh26_card in index_set(y)) (
        y[bh26_card] =
        sum(bh26_position in index_set(x)) (
            bh26_position * bh26_take[bh26_position, bh26_card]
        )
    );

constraint x[1] = 1;
constraint bh26_take[1, 1] = 1;

constraint
    forall(
        bh26_position in index_set(x),
        bh26_rank in bh26_ranks
        where bh26_position < max(index_set(x))
    ) (
        sum(
            bh26_card in index_set(y)
            where (bh26_card - 1) mod 13 = bh26_rank
        ) (
            bh26_take[bh26_position, bh26_card]
        )
        <=
        sum(
            bh26_card in index_set(y)
            where
                abs(((bh26_card - 1) mod 13) - bh26_rank)
                in {1, 12}
        ) (
            bh26_take[bh26_position + 1, bh26_card]
        )
    );

constraint
    forall(
        bh26_position in index_set(x),
        bh26_rank in bh26_ranks
        where bh26_position < max(index_set(x))
    ) (
        sum(
            bh26_card in index_set(y)
            where (bh26_card - 1) mod 13 = bh26_rank
        ) (
            bh26_take[bh26_position + 1, bh26_card]
        )
        <=
        sum(
            bh26_card in index_set(y)
            where
                abs(((bh26_card - 1) mod 13) - bh26_rank)
                in {1, 12}
        ) (
            bh26_take[bh26_position, bh26_card]
        )
    );

constraint
    forall(
        bh26_pile in index_set_1of2(layout),
        bh26_depth in index_set_2of2(layout)
        where bh26_depth < max(index_set_2of2(layout))
    ) (
        y[layout[bh26_pile, bh26_depth]] + 1
        <= y[layout[bh26_pile, bh26_depth + 1]]
    );

constraint
    forall(
        bh26_pile in index_set_1of2(layout),
        bh26_depth in index_set_2of2(layout),
        bh26_cut in index_set(x)
        where bh26_depth < max(index_set_2of2(layout))
    ) (
        sum(
            bh26_position in index_set(x)
            where bh26_position <= bh26_cut
        ) (
            bh26_take[
                bh26_position,
                layout[bh26_pile, bh26_depth + 1]
            ]
        )
        <=
        sum(
            bh26_position in index_set(x)
            where bh26_position < bh26_cut
        ) (
            bh26_take[
                bh26_position,
                layout[bh26_pile, bh26_depth]
            ]
        )
    );

solve satisfy;

output [
    "x = ", show(x), ";\n",
    "y = ", show(y), ";\n"
];
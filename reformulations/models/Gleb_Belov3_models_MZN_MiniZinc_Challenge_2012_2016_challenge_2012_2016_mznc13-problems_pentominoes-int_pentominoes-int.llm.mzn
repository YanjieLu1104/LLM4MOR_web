include "globals.mzn";

int: Q = 1;
int: S = 2;
int: Fstart = 3;
int: Fend = 4;
int: Dstart = 5;

int: width;
int: height;
int: filled;
int: ntiles;
int: size;
array[1..ntiles,1..Dstart] of int: tiles;
array[1..size] of int: dfa;

array[1..width*height] of var filled..ntiles+1: board;

set of int: gb13r_positions = index_set(board);
int: gb13r_length = length(board);

int: gb13r_symbol_lower =
    if ntiles > 0 then max(filled, 1) else filled endif;

int: gb13r_symbol_upper =
    min([ntiles+1] ++
        [tiles[gb13r_tile,S] | gb13r_tile in 1..ntiles]);

set of int: gb13r_symbols =
    gb13r_symbol_lower..gb13r_symbol_upper;

set of int: gb13r_separators =
    {(gb13r_row-1)*width+width |
        gb13r_row in 1..height};

set of int: gb13r_interiors =
    {(gb13r_row-1)*width+gb13r_column |
        gb13r_row in 1..height,
        gb13r_column in 1..width-1};

array[gb13r_positions,gb13r_symbols] of bool: gb13r_allowed =
    array2d(
        gb13r_positions,
        gb13r_symbols,
        [
            (not (gb13r_position in gb13r_separators) \/
                gb13r_symbol = ntiles+1)
            /\
            (not (gb13r_position in gb13r_interiors) \/
                gb13r_symbol != ntiles+1)
            |
            gb13r_position in gb13r_positions,
            gb13r_symbol in gb13r_symbols
        ]
    );

array[gb13r_positions,gb13r_symbols] of var bool: gb13r_selected;

constraint forall(
    gb13r_row in 1..height,
    gb13r_column in 1..width-1
)(
    board[(gb13r_row-1)*width+gb13r_column] != ntiles+1
);

constraint forall(gb13r_row in 1..height)(
    board[(gb13r_row-1)*width+width] = ntiles+1
);

constraint forall(gb13r_position in gb13r_positions)(
    sum(gb13r_symbol in gb13r_symbols)(
        bool2int(gb13r_selected[gb13r_position,gb13r_symbol])
    ) = 1
);

constraint forall(gb13r_position in gb13r_positions)(
    board[gb13r_position] =
        sum(gb13r_symbol in gb13r_symbols)(
            gb13r_symbol *
            bool2int(gb13r_selected[gb13r_position,gb13r_symbol])
        )
);

constraint forall(
    gb13r_position in gb13r_positions,
    gb13r_symbol in gb13r_symbols
    where not gb13r_allowed[gb13r_position,gb13r_symbol]
)(
    not gb13r_selected[gb13r_position,gb13r_symbol]
);

constraint forall(gb13r_tile in 1..ntiles)(
    let {
        int: gb13r_states = tiles[gb13r_tile,Q],
        int: gb13r_alphabet = tiles[gb13r_tile,S],
        set of int: gb13r_accepting =
            tiles[gb13r_tile,Fstart]..tiles[gb13r_tile,Fend],

        array[1..gb13r_states,1..gb13r_alphabet] of int:
            gb13r_transition =
                array2d(
                    1..gb13r_states,
                    1..gb13r_alphabet,
                    [
                        dfa[gb13r_offset]
                        |
                        gb13r_offset in
                            tiles[gb13r_tile,Dstart]+1..
                            tiles[gb13r_tile,Dstart]
                                +gb13r_states*gb13r_alphabet
                    ]
                ),

        array[int] of int: gb13r_arcs =
            [
                (gb13r_position-1)*gb13r_states*gb13r_alphabet
                    +(gb13r_state-1)*gb13r_alphabet
                    +gb13r_symbol
                |
                gb13r_position in gb13r_positions,
                gb13r_state in 1..gb13r_states,
                gb13r_symbol in
                    gb13r_symbols intersect (1..gb13r_alphabet)
                where
                    gb13r_allowed[gb13r_position,gb13r_symbol]
                    /\
                    gb13r_transition[gb13r_state,gb13r_symbol] > 0
                    /\
                    (gb13r_position != 1 \/ gb13r_state = 1)
                    /\
                    (
                        gb13r_position != gb13r_length
                        \/
                        gb13r_transition[gb13r_state,gb13r_symbol]
                            in gb13r_accepting
                    )
            ],

        array[index_set(gb13r_arcs)] of int: gb13r_arc_position =
            [
                (gb13r_arcs[gb13r_arc]-1)
                    div (gb13r_states*gb13r_alphabet)+1
                |
                gb13r_arc in index_set(gb13r_arcs)
            ],

        array[index_set(gb13r_arcs)] of int: gb13r_arc_source =
            [
                ((gb13r_arcs[gb13r_arc]-1) div gb13r_alphabet)
                    mod gb13r_states+1
                |
                gb13r_arc in index_set(gb13r_arcs)
            ],

        array[index_set(gb13r_arcs)] of int: gb13r_arc_symbol =
            [
                (gb13r_arcs[gb13r_arc]-1) mod gb13r_alphabet+1
                |
                gb13r_arc in index_set(gb13r_arcs)
            ],

        array[index_set(gb13r_arcs)] of int: gb13r_arc_target =
            [
                gb13r_transition[
                    gb13r_arc_source[gb13r_arc],
                    gb13r_arc_symbol[gb13r_arc]
                ]
                |
                gb13r_arc in index_set(gb13r_arcs)
            ],

        array[index_set(gb13r_arcs)] of var 0.0..1.0:
            gb13r_flow
    } in
        if gb13r_length = 0 then
            1 in gb13r_accepting
        else
            forall(gb13r_state in 1..gb13r_states)(
                sum(
                    gb13r_arc in index_set(gb13r_arcs)
                    where
                        gb13r_arc_position[gb13r_arc] = 1
                        /\
                        gb13r_arc_source[gb13r_arc] = gb13r_state
                )(
                    gb13r_flow[gb13r_arc]
                ) =
                    if gb13r_state = 1 then 1.0 else 0.0 endif
            )
            /\
            forall(
                gb13r_position in 1..gb13r_length-1,
                gb13r_state in 1..gb13r_states
            )(
                sum(
                    gb13r_arc in index_set(gb13r_arcs)
                    where
                        gb13r_arc_position[gb13r_arc] = gb13r_position
                        /\
                        gb13r_arc_target[gb13r_arc] = gb13r_state
                )(
                    gb13r_flow[gb13r_arc]
                )
                =
                sum(
                    gb13r_arc in index_set(gb13r_arcs)
                    where
                        gb13r_arc_position[gb13r_arc] = gb13r_position+1
                        /\
                        gb13r_arc_source[gb13r_arc] = gb13r_state
                )(
                    gb13r_flow[gb13r_arc]
                )
            )
            /\
            forall(
                gb13r_position in gb13r_positions,
                gb13r_symbol in gb13r_symbols
            )(
                sum(
                    gb13r_arc in index_set(gb13r_arcs)
                    where
                        gb13r_arc_position[gb13r_arc] = gb13r_position
                        /\
                        gb13r_arc_symbol[gb13r_arc] = gb13r_symbol
                )(
                    gb13r_flow[gb13r_arc]
                )
                =
                int2float(
                    bool2int(
                        gb13r_selected[gb13r_position,gb13r_symbol]
                    )
                )
            )
        endif
);

solve :: int_search(board, input_order, indomain_min, complete) satisfy;

output [
    "board = ", show(board), ";\n"
];
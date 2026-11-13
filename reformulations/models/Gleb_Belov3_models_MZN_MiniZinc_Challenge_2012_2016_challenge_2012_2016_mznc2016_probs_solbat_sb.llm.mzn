int: width;
int: height;
int: maxship;

set of int: ROWS = 1..width;
set of int: COLS = 1..height;
set of int: XROWS = 0..width+1;
set of int: XCOLS = 0..height+1;

set of int: SHIPS = 1..maxship;
int: submarine = 1;
int: destroyer = 2;
int: cruiser = 3;
int: battleship = 4;

set of int: PIECES = 1..7;
int: w = 1;
int: c = 2;
int: l = 3;
int: r = 4;
int: t = 5;
int: b = 6;
int: m = 7;

array[PIECES] of string: code = [".","c","l","r","t","b","m"];

array[ROWS,COLS] of 0..7: hint;
array[ROWS] of int: rowsum;
array[COLS] of int: colsum;
array[SHIPS] of int: ship;

array[XROWS,XCOLS] of var PIECES: board
    :: output_array([XROWS,XCOLS]);
array[XROWS,XCOLS] of var 0..1: fill
    :: output_array([XROWS,XCOLS]);
array[PIECES] of var 0..width*height: npiece
    :: output_array([PIECES]);

array[
    index_set_1of2(board),
    index_set_2of2(board),
    index_set(npiece)
] of var 0..1: sbx_piece;

set of int: sbx_lengths =
    {sbx_s | sbx_s in index_set(ship) where sbx_s >= destroyer};

array[
    sbx_lengths,
    index_set_1of2(hint),
    index_set_2of2(hint)
] of var 0..1: sbx_horizontal;

array[
    sbx_lengths,
    index_set_1of2(hint),
    index_set_2of2(hint)
] of var 0..1: sbx_vertical;

constraint forall(sbx_i in XROWS, sbx_j in XCOLS)(
    sum(sbx_p in PIECES)(sbx_piece[sbx_i,sbx_j,sbx_p]) = 1
);

constraint forall(sbx_i in XROWS, sbx_j in XCOLS)(
    board[sbx_i,sbx_j] =
        sum(sbx_p in PIECES)(
            sbx_p * sbx_piece[sbx_i,sbx_j,sbx_p]
        )
);

constraint forall(sbx_i in XROWS, sbx_j in XCOLS)(
    fill[sbx_i,sbx_j] = 1 - sbx_piece[sbx_i,sbx_j,w]
);

constraint forall(
    sbx_i in ROWS,
    sbx_j in COLS
    where hint[sbx_i,sbx_j] != 0
)(
    sbx_piece[sbx_i,sbx_j,hint[sbx_i,sbx_j]] = 1
);

constraint forall(sbx_i in XROWS)(
    if 0 in XCOLS /\ (width + 1) in XCOLS then
        sbx_piece[sbx_i,0,w] = 1 /\
        sbx_piece[sbx_i,width+1,w] = 1
    else
        false
    endif
);

constraint forall(sbx_j in COLS)(
    if 0 in XROWS /\ (height + 1) in XROWS then
        sbx_piece[0,sbx_j,w] = 1 /\
        sbx_piece[height+1,sbx_j,w] = 1
    else
        false
    endif
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    fill[sbx_i,sbx_j] + fill[sbx_i+1,sbx_j+1] <= 1 /\
    fill[sbx_i,sbx_j] + fill[sbx_i+1,sbx_j-1] <= 1
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,c] +
    sbx_piece[sbx_i,sbx_j,l] +
    sbx_piece[sbx_i,sbx_j,r] +
    sbx_piece[sbx_i,sbx_j,t] +
    fill[sbx_i-1,sbx_j] <= 1
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,c] +
    sbx_piece[sbx_i,sbx_j,l] +
    sbx_piece[sbx_i,sbx_j,r] +
    sbx_piece[sbx_i,sbx_j,b] +
    fill[sbx_i+1,sbx_j] <= 1
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,c] +
    sbx_piece[sbx_i,sbx_j,l] +
    sbx_piece[sbx_i,sbx_j,t] +
    sbx_piece[sbx_i,sbx_j,b] +
    fill[sbx_i,sbx_j-1] <= 1
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,c] +
    sbx_piece[sbx_i,sbx_j,r] +
    sbx_piece[sbx_i,sbx_j,t] +
    sbx_piece[sbx_i,sbx_j,b] +
    fill[sbx_i,sbx_j+1] <= 1
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,l] <=
        sbx_piece[sbx_i,sbx_j+1,r] +
        sbx_piece[sbx_i,sbx_j+1,m]
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,r] <=
        sbx_piece[sbx_i,sbx_j-1,l] +
        sbx_piece[sbx_i,sbx_j-1,m]
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,t] <=
        sbx_piece[sbx_i+1,sbx_j,b] +
        sbx_piece[sbx_i+1,sbx_j,m]
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    sbx_piece[sbx_i,sbx_j,b] <=
        sbx_piece[sbx_i-1,sbx_j,t] +
        sbx_piece[sbx_i-1,sbx_j,m]
);

constraint forall(sbx_i in ROWS, sbx_j in COLS)(
    fill[sbx_i-1,sbx_j] - fill[sbx_i+1,sbx_j]
        <= 1 - sbx_piece[sbx_i,sbx_j,m] /\
    fill[sbx_i+1,sbx_j] - fill[sbx_i-1,sbx_j]
        <= 1 - sbx_piece[sbx_i,sbx_j,m] /\
    fill[sbx_i,sbx_j-1] - fill[sbx_i,sbx_j+1]
        <= 1 - sbx_piece[sbx_i,sbx_j,m] /\
    fill[sbx_i,sbx_j+1] - fill[sbx_i,sbx_j-1]
        <= 1 - sbx_piece[sbx_i,sbx_j,m] /\
    fill[sbx_i-1,sbx_j] + fill[sbx_i,sbx_j-1]
        >= sbx_piece[sbx_i,sbx_j,m] /\
    fill[sbx_i-1,sbx_j] + fill[sbx_i,sbx_j-1]
        <= 2 - sbx_piece[sbx_i,sbx_j,m]
);

constraint forall(sbx_p in PIECES)(
    npiece[sbx_p] =
        sum(sbx_i in ROWS, sbx_j in COLS)(
            sbx_piece[sbx_i,sbx_j,sbx_p]
        )
);

constraint
    if submarine in SHIPS then
        npiece[c] = ship[submarine]
    else
        false
    endif;

constraint npiece[l] = npiece[r];
constraint npiece[t] = npiece[b];

constraint npiece[l] + npiece[t] =
    sum(sbx_s in destroyer..maxship)(ship[sbx_s]);

constraint npiece[m] =
    sum(sbx_s in cruiser..maxship)(
        ship[sbx_s] * (sbx_s - 2)
    );

constraint forall(
    sbx_s in sbx_lengths,
    sbx_i in ROWS,
    sbx_j in COLS
)(
    if sbx_j + sbx_s - 1 <= width /\
       (sbx_j + sbx_s - 1) in XCOLS then
        sbx_horizontal[sbx_s,sbx_i,sbx_j]
            <= sbx_piece[sbx_i,sbx_j,l] /\
        sbx_horizontal[sbx_s,sbx_i,sbx_j]
            <= sbx_piece[sbx_i,sbx_j+sbx_s-1,r] /\
        forall(sbx_k in sbx_j+1..sbx_j+sbx_s-2)(
            sbx_horizontal[sbx_s,sbx_i,sbx_j]
                <= sbx_piece[sbx_i,sbx_k,m]
        ) /\
        sbx_horizontal[sbx_s,sbx_i,sbx_j] >=
            sbx_piece[sbx_i,sbx_j,l] +
            sbx_piece[sbx_i,sbx_j+sbx_s-1,r] +
            sum(sbx_k in sbx_j+1..sbx_j+sbx_s-2)(
                sbx_piece[sbx_i,sbx_k,m]
            ) - (sbx_s - 1)
    else
        sbx_horizontal[sbx_s,sbx_i,sbx_j] = 0
    endif
);

constraint forall(
    sbx_s in sbx_lengths,
    sbx_i in ROWS,
    sbx_j in COLS
)(
    if sbx_i + sbx_s - 1 <= height /\
       (sbx_i + sbx_s - 1) in XROWS then
        sbx_vertical[sbx_s,sbx_i,sbx_j]
            <= sbx_piece[sbx_i,sbx_j,t] /\
        sbx_vertical[sbx_s,sbx_i,sbx_j]
            <= sbx_piece[sbx_i+sbx_s-1,sbx_j,b] /\
        forall(sbx_k in sbx_i+1..sbx_i+sbx_s-2)(
            sbx_vertical[sbx_s,sbx_i,sbx_j]
                <= sbx_piece[sbx_k,sbx_j,m]
        ) /\
        sbx_vertical[sbx_s,sbx_i,sbx_j] >=
            sbx_piece[sbx_i,sbx_j,t] +
            sbx_piece[sbx_i+sbx_s-1,sbx_j,b] +
            sum(sbx_k in sbx_i+1..sbx_i+sbx_s-2)(
                sbx_piece[sbx_k,sbx_j,m]
            ) - (sbx_s - 1)
    else
        sbx_vertical[sbx_s,sbx_i,sbx_j] = 0
    endif
);

constraint forall(sbx_s in sbx_lengths)(
    sum(sbx_i in ROWS, sbx_j in COLS)(
        sbx_horizontal[sbx_s,sbx_i,sbx_j] +
        sbx_vertical[sbx_s,sbx_i,sbx_j]
    ) = ship[sbx_s]
);

constraint forall(sbx_i in ROWS)(
    sum(sbx_j in COLS)(fill[sbx_i,sbx_j]) = rowsum[sbx_i]
);

constraint forall(sbx_j in COLS)(
    sum(sbx_i in ROWS)(fill[sbx_i,sbx_j]) = colsum[sbx_j]
);

solve satisfy;

output ["% "] ++ [
    code[fix(board[sbx_i,sbx_j])] ++
    if sbx_j == width then
        " " ++ show(rowsum[sbx_i]) ++ "\n% "
    else
        ""
    endif
    | sbx_i in ROWS, sbx_j in COLS
] ++ [
    show(colsum[sbx_j])
    | sbx_j in COLS
] ++ [
    "\n",
    "board = array2d(",
    show(XROWS),
    ", ",
    show(XCOLS),
    ", ",
    show(board),
    ");\n"
];
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

array[XROWS,XCOLS] of var PIECES: board;
array[XROWS,XCOLS] of var 0..1: fill;
array[PIECES] of var 0..width*height: npiece;

set of int: rf_sb_lengths =
    index_set(ship) intersect (destroyer..maxship);

array[
    index_set_1of2(board),
    index_set_2of2(board),
    index_set(npiece)
] of var 0..1: rf_sb_piece;

array[
    index_set_1of2(hint),
    index_set_2of2(hint),
    rf_sb_lengths
] of var 0..1: rf_sb_horizontal;

array[
    index_set_1of2(hint),
    index_set_2of2(hint),
    rf_sb_lengths
] of var 0..1: rf_sb_vertical;

constraint forall(i in XROWS, j in XCOLS)(
    sum(p in PIECES)(rf_sb_piece[i,j,p]) = 1
);

constraint forall(i in XROWS, j in XCOLS)(
    board[i,j] = sum(p in PIECES)(p * rf_sb_piece[i,j,p])
);

constraint forall(i in XROWS, j in XCOLS)(
    fill[i,j] = 1 - rf_sb_piece[i,j,w]
);

constraint forall(i in ROWS, j in COLS)(
    if hint[i,j] != 0 then
        board[i,j] = hint[i,j]
    else
        true
    endif
);

constraint forall(i in XROWS)(
    if 0 in index_set_2of2(board) /\
       width+1 in index_set_2of2(board) then
        board[i,0] = w /\ board[i,width+1] = w
    else
        false
    endif
);

constraint forall(j in COLS)(
    if 0 in index_set_1of2(board) /\
       height+1 in index_set_1of2(board) then
        board[0,j] = w /\ board[height+1,j] = w
    else
        false
    endif
);

constraint forall(i in ROWS, j in COLS)(
    fill[i,j] + fill[i+1,j+1] <= 1 /\
    fill[i,j] + fill[i+1,j-1] <= 1
);

constraint forall(i in ROWS, j in COLS)(
    rf_sb_piece[i,j,c] +
    rf_sb_piece[i,j,l] +
    rf_sb_piece[i,j,r] +
    rf_sb_piece[i,j,t] +
    fill[i-1,j] <= 1
);

constraint forall(i in ROWS, j in COLS)(
    rf_sb_piece[i,j,c] +
    rf_sb_piece[i,j,l] +
    rf_sb_piece[i,j,r] +
    rf_sb_piece[i,j,b] +
    fill[i+1,j] <= 1
);

constraint forall(i in ROWS, j in COLS)(
    rf_sb_piece[i,j,c] +
    rf_sb_piece[i,j,l] +
    rf_sb_piece[i,j,t] +
    rf_sb_piece[i,j,b] +
    fill[i,j-1] <= 1
);

constraint forall(i in ROWS, j in COLS)(
    rf_sb_piece[i,j,c] +
    rf_sb_piece[i,j,r] +
    rf_sb_piece[i,j,t] +
    rf_sb_piece[i,j,b] +
    fill[i,j+1] <= 1
);

constraint forall(i in ROWS, j in COLS)(
    rf_sb_piece[i,j,l] <=
        rf_sb_piece[i,j+1,r] + rf_sb_piece[i,j+1,m] /\
    rf_sb_piece[i,j,r] <=
        rf_sb_piece[i,j-1,l] + rf_sb_piece[i,j-1,m] /\
    rf_sb_piece[i,j,t] <=
        rf_sb_piece[i+1,j,b] + rf_sb_piece[i+1,j,m] /\
    rf_sb_piece[i,j,b] <=
        rf_sb_piece[i-1,j,t] + rf_sb_piece[i-1,j,m]
);

constraint forall(i in ROWS, j in COLS)(
    fill[i-1,j] - fill[i+1,j] <= 1 - rf_sb_piece[i,j,m] /\
    fill[i+1,j] - fill[i-1,j] <= 1 - rf_sb_piece[i,j,m] /\
    fill[i,j-1] - fill[i,j+1] <= 1 - rf_sb_piece[i,j,m] /\
    fill[i,j+1] - fill[i,j-1] <= 1 - rf_sb_piece[i,j,m] /\
    fill[i-1,j] + fill[i,j-1] >= rf_sb_piece[i,j,m] /\
    fill[i-1,j] + fill[i,j-1] <= 2 - rf_sb_piece[i,j,m]
);

constraint forall(p in PIECES)(
    npiece[p] = sum(i in ROWS, j in COLS)(rf_sb_piece[i,j,p])
);

constraint
    if submarine in index_set(ship) then
        npiece[c] = ship[submarine]
    else
        false
    endif;

constraint npiece[l] = npiece[r];
constraint npiece[t] = npiece[b];

constraint
    npiece[l] + npiece[t] =
        sum(s in destroyer..maxship)(ship[s]);

constraint
    npiece[m] =
        sum(s in cruiser..maxship)(ship[s] * (s - 2));

constraint forall(i in ROWS, j in COLS, s in rf_sb_lengths)(
    if j + s - 1 <= width /\
       j + s - 1 in index_set_2of2(board) /\
       forall(k in j+1..j+s-2)(
           k in index_set_2of2(board)
       )
    then
        rf_sb_horizontal[i,j,s] <= rf_sb_piece[i,j,l] /\
        rf_sb_horizontal[i,j,s] <= rf_sb_piece[i,j+s-1,r] /\
        forall(k in j+1..j+s-2)(
            rf_sb_horizontal[i,j,s] <= rf_sb_piece[i,k,m]
        ) /\
        rf_sb_horizontal[i,j,s] >=
            rf_sb_piece[i,j,l] +
            rf_sb_piece[i,j+s-1,r] +
            sum(k in j+1..j+s-2)(rf_sb_piece[i,k,m]) -
            (s - 1)
    else
        rf_sb_horizontal[i,j,s] = 0
    endif
);

constraint forall(i in ROWS, j in COLS, s in rf_sb_lengths)(
    if i + s - 1 <= height /\
       i + s - 1 in index_set_1of2(board) /\
       forall(k in i+1..i+s-2)(
           k in index_set_1of2(board)
       )
    then
        rf_sb_vertical[i,j,s] <= rf_sb_piece[i,j,t] /\
        rf_sb_vertical[i,j,s] <= rf_sb_piece[i+s-1,j,b] /\
        forall(k in i+1..i+s-2)(
            rf_sb_vertical[i,j,s] <= rf_sb_piece[k,j,m]
        ) /\
        rf_sb_vertical[i,j,s] >=
            rf_sb_piece[i,j,t] +
            rf_sb_piece[i+s-1,j,b] +
            sum(k in i+1..i+s-2)(rf_sb_piece[k,j,m]) -
            (s - 1)
    else
        rf_sb_vertical[i,j,s] = 0
    endif
);

constraint forall(s in rf_sb_lengths)(
    sum(i in ROWS, j in COLS)(
        rf_sb_horizontal[i,j,s] + rf_sb_vertical[i,j,s]
    ) = ship[s]
);

constraint forall(i in ROWS)(
    sum(j in COLS)(fill[i,j]) = rowsum[i]
);

constraint forall(j in COLS)(
    sum(i in ROWS)(fill[i,j]) = colsum[j]
);

constraint
    sum(i in ROWS)(rowsum[i]) =
    sum(j in COLS)(colsum[j]);

constraint
    if submarine in index_set(ship) then
        sum(i in ROWS)(rowsum[i]) =
            ship[submarine] +
            sum(s in destroyer..maxship)(s * ship[s])
    else
        false
    endif;

constraint
    npiece[w] = width * height - sum(i in ROWS)(rowsum[i]);

solve satisfy;

output [ "% " ] ++ [
    code[fix(board[i,j])] ++
    if j == width then
        " " ++ show(rowsum[i]) ++ "\n% "
    else
        ""
    endif
    | i in ROWS, j in COLS
] ++ [
    show(colsum[j])
    | j in COLS
] ++ [
    "\n"
] ++ [
    "board = array2d(",
    show(XROWS),
    ", ",
    show(XCOLS),
    ", ",
    show(board),
    ");\n"
];
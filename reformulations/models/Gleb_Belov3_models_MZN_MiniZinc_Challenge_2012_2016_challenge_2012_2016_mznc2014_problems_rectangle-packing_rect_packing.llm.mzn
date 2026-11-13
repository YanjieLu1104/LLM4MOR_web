int: n;
set of int: Squares = 1..n;
bool: Consider_Unit_Square;
float: slack_frac = 0.3;

array [Squares] of int: int_slack =
    [floor(slack_frac * int2float(i)) | i in Squares];

int: max_width = sum([i | i in Squares where i >= (n div 2) + 1]);
int: min_height = if n mod 2 == 1 then n else n + 1 endif;
int: min_area = sum([i * i | i in Squares]);
int: max_area = max_width * min_height;
int: max_height = floor(sqrt(int2float(max_area)));
int: min_width = ceil(sqrt(int2float(min_area)));

array [Squares] of var 0..max_width: X;
array [Squares] of var 0..max_height: Y;

array [Squares] of var 0..max_width: X_div =
    [
        if int_slack[i] < 2 then
            X[i]
        else
            let {
                int: dmax = max_width div int_slack[i],
                var 0..dmax: x
            } in x
        endif
        | i in Squares
    ];

array [Squares] of var 0..max_width: X_rem =
    [
        if int_slack[i] < 2 then
            0
        else
            let {
                var 0..(int_slack[i] - 1): x
            } in x
        endif
        | i in Squares
    ];

array [Squares] of var 0..max_height: Y_div =
    [
        if int_slack[i] < 2 then
            Y[i]
        else
            let {
                int: dmax = max_height div int_slack[i],
                var 0..dmax: y
            } in y
        endif
        | i in Squares
    ];

array [Squares] of var 0..max_height: Y_rem =
    [
        if int_slack[i] < 2 then
            0
        else
            let {
                var 0..(int_slack[i] - 1): y
            } in y
        endif
        | i in Squares
    ];

var min_width..max_width: Width;
var min_height..max_height: Height;
var min_area..max_area: Area;

test consider_square(int: i) =
    (i > 1 \/ Consider_Unit_Square == true);

array [1..45] of int: fgaps =
    [0, 2, 3, 2, 3, 3, 3, 3, 4, 4,
     4, 5, 5, 5, 5, 5, 5, 6, 6, 6,
     6, 7, 7, 7, 7, 7, 7, 7, 7, 8,
     8, 8, 8, 8, 9, 9, 9, 9, 9, 9,
     9, 9, 9, 9, 10];

array [int] of int: rf_height_values =
    [rf_h | rf_h in min_height..max_height where rf_h > 0];

set of int: rf_height_indices = index_set(rf_height_values);

array [rf_height_indices] of int: rf_width_lower =
    [
        max([
            min_width,
            rf_height_values[rf_k],
            (min_area + rf_height_values[rf_k] - 1)
                div rf_height_values[rf_k],
            sum([
                rf_i
                | rf_i in Squares
                where consider_square(rf_i)
                    /\ 2 * rf_i > rf_height_values[rf_k]
            ])
        ])
        | rf_k in rf_height_indices
    ];

array [rf_height_indices] of int: rf_width_upper =
    [
        min(max_width, max_area div rf_height_values[rf_k])
        | rf_k in rf_height_indices
    ];

array [rf_height_indices] of var bool: rf_height_selected;
array [rf_height_indices] of var 0..max_width: rf_width_part;

array [index_set(X), index_set(X)] of var bool: rf_left;
array [index_set(X), index_set(X)] of var bool: rf_right;
array [index_set(X), index_set(X)] of var bool: rf_below;
array [index_set(X), index_set(X)] of var bool: rf_above;

constraint
    forall(i in Squares where consider_square(i)) (
        if int_slack[i] < 2 then
            true
        else
            X[i] = int_slack[i] * X_div[i] + X_rem[i]
            /\
            Y[i] = int_slack[i] * Y_div[i] + Y_rem[i]
        endif
    );

constraint
    sum(rf_k in rf_height_indices)(
        bool2int(rf_height_selected[rf_k])
    ) = 1;

constraint
    forall(rf_k in rf_height_indices) (
        rf_width_part[rf_k] >=
            rf_width_lower[rf_k] * bool2int(rf_height_selected[rf_k])
        /\
        rf_width_part[rf_k] <=
            rf_width_upper[rf_k] * bool2int(rf_height_selected[rf_k])
    );

constraint
    Height = sum(rf_k in rf_height_indices)(
        rf_height_values[rf_k] * bool2int(rf_height_selected[rf_k])
    );

constraint
    Width = sum(rf_k in rf_height_indices)(rf_width_part[rf_k]);

constraint
    Area = sum(rf_k in rf_height_indices)(
        rf_height_values[rf_k] * rf_width_part[rf_k]
    );

constraint Height <= Width;

constraint
    forall(rf_i in Squares where consider_square(rf_i)) (
        X[rf_i] + rf_i <= Width
        /\
        Y[rf_i] + rf_i <= Height
    );

constraint
    forall(rf_i, rf_j in Squares) (
        if rf_i < rf_j
            /\ consider_square(rf_i)
            /\ consider_square(rf_j)
        then
            bool2int(rf_left[rf_i, rf_j])
            + bool2int(rf_right[rf_i, rf_j])
            + bool2int(rf_below[rf_i, rf_j])
            + bool2int(rf_above[rf_i, rf_j]) = 1
            /\
            X[rf_i] + rf_i <= X[rf_j]
                + max_width * (1 - bool2int(rf_left[rf_i, rf_j]))
            /\
            X[rf_j] + rf_j <= X[rf_i]
                + max_width * (1 - bool2int(rf_right[rf_i, rf_j]))
            /\
            Y[rf_i] + rf_i <= Y[rf_j]
                + max_height * (1 - bool2int(rf_below[rf_i, rf_j]))
            /\
            Y[rf_j] + rf_j <= Y[rf_i]
                + max_height * (1 - bool2int(rf_above[rf_i, rf_j]))
            /\
            Width >= rf_i + rf_j
                - max(0, rf_i + rf_j - min_width)
                  * (
                      1 - bool2int(rf_left[rf_i, rf_j])
                        - bool2int(rf_right[rf_i, rf_j])
                    )
            /\
            Height >= rf_i + rf_j
                - max(0, rf_i + rf_j - min_height)
                  * (
                      1 - bool2int(rf_below[rf_i, rf_j])
                        - bool2int(rf_above[rf_i, rf_j])
                    )
            /\
            (
                if rf_i + rf_j > max_width then
                    not rf_left[rf_i, rf_j]
                    /\ not rf_right[rf_i, rf_j]
                else
                    true
                endif
            )
            /\
            (
                if rf_i + rf_j > max_height then
                    not rf_below[rf_i, rf_j]
                    /\ not rf_above[rf_i, rf_j]
                else
                    true
                endif
            )
        else
            not rf_left[rf_i, rf_j]
            /\ not rf_right[rf_i, rf_j]
            /\ not rf_below[rf_i, rf_j]
            /\ not rf_above[rf_i, rf_j]
        endif
    );

constraint
    if Consider_Unit_Square == false then
        if 1 in Squares then
            X[1] = 0 /\ Y[1] = 0
        else
            false
        endif
    else
        true
    endif;

constraint
    if n in Squares then
        2 * X[n] <= Width - n
        /\
        2 * Y[n] <= Height - n
    else
        false
    endif;

constraint
    forall(i in Squares where consider_square(i)) (
        if 2 * fgaps[i] + 2 <= max_width - i then
            let {
                var bool: b_left,
                var bool: b_right
            } in (
                (b_left -> X[i] <= 0)
                /\
                (not b_left -> X[i] > fgaps[i])
                /\
                (b_right -> X[i] >= Width - i)
                /\
                (not b_right -> X[i] < Width - i - fgaps[i])
                /\
                (not b_left \/ not b_right)
            )
        else
            let {
                var bool: b_left
            } in (
                (b_left -> X[i] <= 0)
                /\
                (not b_left -> X[i] >= Width - i)
            )
        endif
    );

constraint
    forall(i in Squares where consider_square(i)) (
        if 2 * fgaps[i] + 2 <= max_height - i then
            let {
                var bool: b_left,
                var bool: b_right
            } in (
                (b_left -> Y[i] <= 0)
                /\
                (not b_left -> Y[i] > fgaps[i])
                /\
                (b_right -> Y[i] >= Height - i)
                /\
                (not b_right -> Y[i] < Height - i - fgaps[i])
                /\
                (not b_left \/ not b_right)
            )
        else
            let {
                var bool: b_left
            } in (
                (b_left -> Y[i] <= 0)
                /\
                (not b_left -> Y[i] >= Height - i)
            )
        endif
    );

solve satisfy;

output [
    "Area = ", show(Area), ";\n",
    "Height = ", show(Height), ";\n",
    "Width = ", show(Width), ";\n",
    "X = ", show(X), ";\n",
    "Y = ", show(Y), ";\n"
];
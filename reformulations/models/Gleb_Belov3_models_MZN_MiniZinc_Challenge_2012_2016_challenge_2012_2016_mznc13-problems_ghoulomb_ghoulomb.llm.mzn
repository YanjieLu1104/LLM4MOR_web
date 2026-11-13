include "globals.mzn";

int: m1;
int: m2;
int: m3;

predicate distinct(array[int] of var int: x) =
    all_different(x);

function int: rf_distance_index(
    int: rf_size,
    int: rf_left,
    int: rf_right
) =
    ((rf_left - 1) * (2 * rf_size - rf_left)) div 2
    + rf_right - rf_left;

predicate ghoulomb(
    array[int] of var int: mark,
    array[int] of var int: differences
) =
    let {
        int: m = length(mark)
    } in
    if m >= 2 then
        mark[1] = 0
        /\
        forall(i in 1..m-1)(
            mark[i] < mark[i+1]
        )
        /\
        differences[1] < differences[(m * (m-1)) div 2]
        /\
        forall(
            rf_a in 1..m-1,
            rf_b in rf_a+1..m,
            rf_c in rf_b..m-1,
            rf_e in rf_c+1..m
        )(
            differences[rf_distance_index(m, rf_a, rf_b)]
            !=
            differences[rf_distance_index(m, rf_c, rf_e)]
        )
        /\
        forall(
            rf_a in 1..m-1,
            rf_b in rf_a+1..m
        )(
            differences[rf_distance_index(m, rf_a, rf_b)]
            >= ((rf_b-rf_a) * (rf_b-rf_a+1)) div 2
            /\
            differences[rf_distance_index(m, rf_a, rf_b)]
            <= m*m
               - ((rf_a-1) * rf_a) div 2
               - ((m-rf_b) * (m-rf_b+1)) div 2
        )
        /\
        forall(
            rf_a in 1..m-2,
            rf_b in rf_a+2..m
        )(
            let {
                int: rf_q =
                    ((rf_b-rf_a) * (rf_b-rf_a+1)) div 2
            } in
            sum(rf_t in rf_a..rf_b)(
                (2*rf_t-rf_a-rf_b) * mark[rf_t]
            ) >= (rf_q * (rf_q+1)) div 2
        )
    else
        false
    endif;

array[1..m1] of var 0..m1*m1: mark1;
array[1..(m1*(m1-1)) div 2] of var 0..m1*m1: differences1 =
    [mark1[j]-mark1[i] | i in 1..m1, j in i+1..m1];
constraint ghoulomb(mark1, differences1);

array[1..m2] of var 0..m2*m2: mark2;
array[1..(m2*(m2-1)) div 2] of var 0..m2*m2: differences2 =
    [mark2[j]-mark2[i] | i in 1..m2, j in i+1..m2];
constraint ghoulomb(mark2, differences2);

array[1..m3] of var 0..m3*m3: mark3;
array[1..(m3*(m3-1)) div 2] of var 0..m3*m3: differences3 =
    [mark3[j]-mark3[i] | i in 1..m3, j in i+1..m3];
constraint ghoulomb(mark3, differences3);

var 0..m2*m2: objective =
    if m2 >= 1 then mark2[m2] else 0 endif;

solve minimize objective;

output [
    "objective = ", show(objective), ";\n",
    "mark1 = ", show(mark1), ";\n",
    "mark2 = ", show(mark2), ";\n",
    "mark3 = ", show(mark3), ";\n"
];
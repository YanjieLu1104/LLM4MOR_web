include "lex_lesseq.mzn";

int: n;

array[1..n,1..n] of var bool: filled;
array[1..n,1..n] of var 0..1: f =
    array2d(1..n,1..n,[bool2int(filled[i,j]) | i,j in 1..n]);
array[1..n] of var 0..n: q;
var 0..n: objective;

predicate rot_sqr_sym(array[int,int] of var int: x) =
    let {
        int: n = card(index_set_1of2(x)),
        int: n2 = card(index_set_2of2(x)),
        int: l = n * n,
        array[1..l] of var int: y =
            [x[i,j] | i in index_set_1of2(x),
                      j in index_set_2of2(x)],
        array[1..4,1..l] of 1..l: p =
            array2d(1..4,1..l,
                [if k == 1 then
                     i*n + j - n
                 elseif k == 2 then
                     (n-j)*n + i
                 elseif k == 3 then
                     (n-i)*n + (n-j) + 1
                 else
                     i*n + (n-j) - n + 1
                 endif
                 | k in 1..4, i,j in 1..n])
    } in
    assert(
        n == n2,
        "rot_sqr_sym: rotation symmetry applied to non square matrix",
        var_perm_sym(y,p)
    );

predicate var_perm_sym(
    array[int] of var int: x,
    array[int,int] of int: p
) =
    let {
        int: l = min(index_set_1of2(p)),
        int: u = max(index_set_1of2(p)),
        array[1..length(x)] of var int: y =
            [x[i] | i in index_set(x)]
    } in
    forall(i in l..u, j in l..u where i != j)(
        var_perm_sym_pairwise(
            y,
            [p[i,k] | k in index_set_2of2(p)],
            [p[j,k] | k in index_set_2of2(p)]
        )
    );

predicate var_perm_sym_pairwise(
    array[int] of var int: x,
    array[int] of int: p1,
    array[int] of int: p2
) =
    let {
        array[1..length(x)] of 1..length(x): invp1 =
            [j | i,j in 1..length(x) where p1[j] = i]
    } in
    lex_lesseq(
        x,
        [x[p2[invp1[i]]] | i in 1..length(x)]
    );

set of int: rf_rows = index_set_1of2(filled);
set of int: rf_cols = index_set_2of2(filled);

set of int: rf_difference_indices =
    {rf_i - rf_j | rf_i in rf_rows, rf_j in rf_cols};
set of int: rf_sum_indices =
    {rf_i + rf_j | rf_i in rf_rows, rf_j in rf_cols};

array[rf_rows] of var 0..1: rf_row_used;
array[rf_cols] of var 0..1: rf_col_used;
array[rf_difference_indices] of var 0..1: rf_difference_used;
array[rf_sum_indices] of var 0..1: rf_sum_used;

constraint forall(rf_i in rf_rows)(
    rf_row_used[rf_i] =
        sum(rf_j in rf_cols)(f[rf_i,rf_j])
);

constraint forall(rf_j in rf_cols)(
    rf_col_used[rf_j] =
        sum(rf_i in rf_rows)(f[rf_i,rf_j])
);

constraint forall(rf_d in rf_difference_indices)(
    rf_difference_used[rf_d] =
        sum(rf_i in rf_rows where (rf_i - rf_d) in rf_cols)(
            f[rf_i,rf_i-rf_d]
        )
);

constraint forall(rf_d in rf_sum_indices)(
    rf_sum_used[rf_d] =
        sum(rf_i in rf_rows where (rf_d - rf_i) in rf_cols)(
            f[rf_i,rf_d-rf_i]
        )
);

constraint forall(rf_i in rf_rows, rf_j in rf_cols)(
    rf_row_used[rf_i]
    + rf_col_used[rf_j]
    + rf_difference_used[rf_i-rf_j]
    + rf_sum_used[rf_i+rf_j]
    - 3 * f[rf_i,rf_j] >= 1
);

constraint forall(i in 1..n)(
    q[i] = sum(j in 1..n)(j * f[i,j])
);

constraint objective =
    sum(rf_i in rf_rows)(rf_row_used[rf_i]);

constraint rot_sqr_sym(f);

solve minimize objective;

output [
    "q = ", show(q), ";\n",
    "objective = ", show(objective), ";\n"
];
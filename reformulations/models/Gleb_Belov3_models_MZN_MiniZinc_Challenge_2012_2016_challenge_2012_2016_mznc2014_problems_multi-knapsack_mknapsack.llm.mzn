int: N;
int: M;

set of int: VariableRange = 1..N;
set of int: ConstraintRange = 1..M;

array[ConstraintRange,VariableRange] of int: a;
array[ConstraintRange] of int: b;
array[VariableRange] of int: c;
int: z;

array[VariableRange] of var 0..1: x;

constraint forall(i in ConstraintRange)(
    forall(j in VariableRange)(
        assert(a[i,j] >= 0, "negative values in a")
    )
);
constraint forall(i in ConstraintRange)(
    assert(b[i] >= 0, "negative values in b")
);
constraint forall(j in VariableRange)(
    assert(c[j] >= 0, "negative values in c")
);
constraint assert(z >= 0, "negative z");

set of int: rf_mk_candidates = {
    j | j in index_set(x)
    where c[j] <= z /\
          forall(i in index_set(b))(a[i,j] <= b[i])
};

int: rf_mk_available_profit =
    sum(j in rf_mk_candidates)(c[j]);

set of int: rf_mk_mandatory = {
    j | j in rf_mk_candidates
    where rf_mk_available_profit - c[j] < z
};

int: rf_mk_residual_profit =
    z - sum(j in rf_mk_mandatory)(c[j]);

array[index_set(b)] of int: rf_mk_residual_capacity =
    array1d(
        index_set(b),
        [
            b[i] - sum(j in rf_mk_mandatory)(a[i,j])
            | i in index_set(b)
        ]
    );

set of int: rf_mk_remaining = {
    j | j in rf_mk_candidates diff rf_mk_mandatory
    where c[j] <= rf_mk_residual_profit /\
          forall(i in index_set(b))(
              a[i,j] <= rf_mk_residual_capacity[i]
          )
};

constraint forall(j in rf_mk_mandatory)(
    x[j] = 1
);

constraint forall(
    j in index_set(x) diff (rf_mk_mandatory union rf_mk_remaining)
)(
    x[j] = 0
);

constraint rf_mk_available_profit >= z;
constraint rf_mk_residual_profit >= 0;

constraint forall(i in index_set(b))(
    rf_mk_residual_capacity[i] >= 0
);

constraint forall(
    i in index_set(b)
    where sum(j in rf_mk_remaining)(a[i,j])
          > rf_mk_residual_capacity[i]
)(
    sum(j in rf_mk_remaining)(a[i,j] * x[j])
        <= rf_mk_residual_capacity[i]
);

constraint
    sum(j in rf_mk_remaining)(c[j] * x[j])
        = rf_mk_residual_profit;

constraint forall(
    i in index_set(b)
    where rf_mk_residual_capacity[i] >= 0
)(
    let {
        set of int: rf_mk_heavy_items = {
            j | j in rf_mk_remaining
            where a[i,j] > rf_mk_residual_capacity[i] div 2
        };
    } in
        if card(rf_mk_heavy_items) > 1 then
            sum(j in rf_mk_heavy_items)(x[j]) <= 1
        else
            true
        endif
);

set of int: rf_mk_heavy_profit_items = {
    j | j in rf_mk_remaining
    where c[j] > rf_mk_residual_profit div 2
};

constraint
    if rf_mk_residual_profit >= 0 /\
       card(rf_mk_heavy_profit_items) > 1
    then
        sum(j in rf_mk_heavy_profit_items)(x[j]) <= 1
    else
        true
    endif;

solve satisfy;

output [
    "x = ", show(x), ";\n"
];
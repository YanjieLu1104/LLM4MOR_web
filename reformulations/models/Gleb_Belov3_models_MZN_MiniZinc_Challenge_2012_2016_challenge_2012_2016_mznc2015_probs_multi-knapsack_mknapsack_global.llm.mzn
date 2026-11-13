int: N;
int: M;

set of int: VRange = 1..N;
set of int: CRange = 1..M;

array[CRange,VRange] of int: a;
array[CRange] of int: b;
array[VRange] of int: c;

int: z;

array[VRange] of var 0..1: x;
array[CRange] of var 0..ub_array(b): bVar;

var 0..sum(c): objective =
    sum(rf_item in VRange)(c[rf_item] * x[rf_item]);

constraint
    forall(rf_row in CRange, rf_item in VRange)(
        assert(a[rf_row,rf_item] >= 0, "negative values in a")
    );

constraint
    forall(rf_row in CRange)(
        assert(b[rf_row] >= 0, "negative values in b")
    );

constraint
    forall(rf_item in VRange)(
        assert(c[rf_item] >= 0, "negative values in c")
    );

constraint assert(z >= 0, "negative z");

bool: rf_has_rows = card(CRange) > 0;

set of int: rf_eligible = {
    rf_item |
    rf_item in VRange
    where
        forall(rf_row in CRange)(
            a[rf_row,rf_item] <= b[rf_row]
        )
        /\
        (not rf_has_rows \/ c[rf_item] <= z)
};

int: rf_available_profit =
    sum(rf_item in rf_eligible)(c[rf_item]);

constraint
    forall(rf_row in CRange)(
        bVar[rf_row] =
            sum(rf_item in VRange)(
                a[rf_row,rf_item] * x[rf_item]
            )
    );

constraint
    forall(rf_row in CRange)(
        bVar[rf_row] >= 0 /\ bVar[rf_row] <= b[rf_row]
    );

constraint
    if rf_has_rows then
        objective = z
    else
        true
    endif;

constraint
    forall(rf_item in VRange diff rf_eligible)(
        x[rf_item] = 0
    );

constraint
    if rf_has_rows then
        z <= rf_available_profit
    else
        true
    endif;

constraint
    forall(
        rf_item in rf_eligible
        where rf_has_rows /\
              rf_available_profit - c[rf_item] < z
    )(
        x[rf_item] = 1
    );

constraint
    forall(rf_row in CRange)(
        sum(
            rf_item in rf_eligible
            where a[rf_row,rf_item] > b[rf_row] div 2
        )(x[rf_item]) <= 1
    );

solve maximize objective;

output [
    "x = ", show(x), ";\n",
    "objective = ", show(objective), ";\n"
];
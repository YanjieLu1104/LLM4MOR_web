include "count.mzn";

int: num_staff;
set of int: staff = 1..num_staff;

array[1..num_staff] of 1..100: work_load;

int: num_days;
0..4: weekend_offset;

array[staff] of set of int: unavailable;
array[staff] of set of int: fixed;

set of int: weekend_days =
    {
        d * 5 + weekend_offset + 1 |
        d in 0..num_days div 5
        where d * 5 + weekend_offset + 1 <= num_days
    };

set of int: week_days = 1..num_days diff weekend_days;

var 0..num_days: week_day_bt;
var 0..num_days: weekend_bt;

int: adj_days_str;
int: wed_before_weekend_str;

array[1..num_days] of var staff: roster;

list of var staff: roster_week_days =
    [roster[i] | i in 1..num_days where i in week_days];

list of var staff: roster_weekend_days =
    [roster[i] | i in 1..num_days where i in weekend_days];

array[staff] of var 0..num_days: week_days_oc;
array[staff] of var 0..num_days: weekend_days_oc;

constraint assert(num_staff > 1, "LESS THAN TWO STAFF");
constraint assert(num_days > 5, "LESS THAN ONE WEEK");

set of int: all_unavailable = array_intersect(unavailable);

constraint assert(
    all_unavailable = {},
    "NO STAFF AVAILABLE ON DAYS: " ++ show(all_unavailable)
);

constraint forall(S in staff) (
    let {
        set of int: U = unavailable[S] intersect fixed[S]
    } in
    assert(
        U = {},
        "FIXED DAY CONFLICTS WITH UNAVAILABLE FOR STAFF MEMBER " ++
        show(S) ++ " ON DAYS " ++ show(U)
    )
);

constraint forall(i in 1..num_staff, j in i + 1..num_staff) (
    let {
        set of int: U = fixed[i] intersect fixed[j]
    } in
    assert(
        U = {},
        "FIXED DAYS FOR SURGEON " ++ show(i) ++ " AND SURGEON " ++
        show(j) ++ " CONFLICT ON DAYS " ++ show(U)
    )
);

set of int: all_fixed = array_union(fixed);

array[1..num_days - 1] of var 0..adj_days_str: adj_days;

array[1..card(weekend_days)] of
    var 0..wed_before_weekend_str: wed_before_weekend;

array[index_set(roster), index_set(work_load)] of
    var 0..1: oc_rf01_assignment;

constraint forall(D in index_set(roster)) (
    sum(S in staff)(oc_rf01_assignment[D, S]) = 1
);

constraint forall(D in index_set(roster)) (
    roster[D] =
        sum(S in staff)(S * oc_rf01_assignment[D, S])
);

constraint forall(
    S in staff,
    D in index_set(roster)
    where D in unavailable[S]
) (
    oc_rf01_assignment[D, S] = 0
);

constraint forall(S in staff, D in fixed[S]) (
    if D in index_set(roster) then
        oc_rf01_assignment[D, S] = 1
    else
        false
    endif
);

constraint forall(
    S in staff,
    D in index_set(roster)
    where D in all_fixed /\ not (D in fixed[S])
) (
    oc_rf01_assignment[D, S] = 0
);

constraint forall(S in staff) (
    week_days_oc[S] =
        sum(D in week_days)(oc_rf01_assignment[D, S])
    /\
    weekend_days_oc[S] =
        sum(D in weekend_days)(oc_rf01_assignment[D, S])
);

constraint forall(S in staff) (
    week_days_oc[S] <= card(week_days)
    /\
    weekend_days_oc[S] <= card(weekend_days)
);

constraint sum(S in staff)(week_days_oc[S]) = card(week_days);

constraint sum(S in staff)(weekend_days_oc[S]) = card(weekend_days);

constraint forall(i in 1..num_staff, j in i + 1..num_staff) (
    work_load[i] * week_days_oc[j] -
    work_load[j] * week_days_oc[i] <= 100 * week_day_bt
    /\
    work_load[j] * week_days_oc[i] -
    work_load[i] * week_days_oc[j] <= 100 * week_day_bt
    /\
    work_load[i] * weekend_days_oc[j] -
    work_load[j] * weekend_days_oc[i] <= 100 * weekend_bt
    /\
    work_load[j] * weekend_days_oc[i] -
    work_load[i] * weekend_days_oc[j] <= 100 * weekend_bt
);

constraint forall(
    i in 1..num_days - 2,
    S in staff
    where not (
        i in all_fixed /\
        i + 1 in all_fixed /\
        i + 2 in all_fixed
    )
) (
    oc_rf01_assignment[i, S] +
    oc_rf01_assignment[i + 1, S] +
    oc_rf01_assignment[i + 2, S] <= 2
);

constraint forall(i in 1..num_days - 2, S in staff) (
    adj_days[i] >=
        adj_days_str * (
            oc_rf01_assignment[i, S] +
            oc_rf01_assignment[i + 1, S] - 1
        )
);

constraint forall(i in weekend_days, S in staff) (
    if i = 1 then
        if i in all_fixed /\ i + 1 in all_fixed then
            true
        else
            oc_rf01_assignment[i, S] +
            oc_rf01_assignment[i + 1, S] <= 1
        endif
    elseif i = num_days then
        if i in all_fixed /\ i - 1 in all_fixed then
            true
        else
            oc_rf01_assignment[i, S] +
            oc_rf01_assignment[i - 1, S] <= 1
        endif
    else
        if
            i in all_fixed /\
            i + 1 in all_fixed /\
            i - 1 in all_fixed
        then
            true
        else
            oc_rf01_assignment[i, S] +
            oc_rf01_assignment[i + 1, S] <= 1
            /\
            oc_rf01_assignment[i, S] +
            oc_rf01_assignment[i - 1, S] <= 1
        endif
    endif
);

constraint forall(
    i in index_set(wed_before_weekend),
    S in staff
    where weekend_days[i] > 2
) (
    wed_before_weekend[i] >=
        wed_before_weekend_str * (
            oc_rf01_assignment[weekend_days[i], S] +
            oc_rf01_assignment[weekend_days[i] - 2, S] - 1
        )
);

constraint forall(
    i in 1..card(weekend_days) - 1,
    S in staff
    where not (
        weekend_days[i] in all_fixed /\
        weekend_days[i + 1] in all_fixed
    )
) (
    oc_rf01_assignment[weekend_days[i], S] +
    oc_rf01_assignment[weekend_days[i + 1], S] <= 1
);

var 0..(4 * num_days): objective =
    sum(adj_days) +
    sum(wed_before_weekend) +
    week_day_bt +
    weekend_bt;

ann: search = seq_search([
    int_search(roster, anti_first_fail, indomain_split, complete),
    int_search(roster_week_days, anti_first_fail, indomain_split, complete),
    int_search(roster_weekend_days, anti_first_fail, indomain_split, complete),
    int_search(week_days_oc, input_order, indomain_split, complete),
    int_search(weekend_days_oc, input_order, indomain_split, complete),
    int_search(adj_days, input_order, indomain_split, complete),
    int_search(wed_before_weekend, input_order, indomain_split, complete),
    int_search([week_day_bt, weekend_bt], input_order, indomain_split, complete)
]);

solve minimize objective;

output [
    "roster     = ", show(roster), ";\n",
    "weekday bt = ", show(week_day_bt), ";\n",
    "weekend bt = ", show(weekend_bt), ";\n",
    "objective  = ", show(objective), ";\n"
];
include "globals.mzn";

int: n;
set of int: add;
set of int: mul;
set of int: Last;
int: del_add;
int: del_mul;
int: number_add;
int: number_mul;

array[1..n] of set of int: dependencies;

array[1..n] of var 0..100: t;
array[1..n] of var 1..10: r;
array[1..n] of var 1..10: d =
    [if rf_i in add then del_add else del_mul endif | rf_i in 1..n];
array[1..card(add)] of var 0..1000: t_add =
    [t[rf_i] | rf_i in add];
array[1..card(mul)] of var 0..1000: t_mul =
    [t[rf_i] | rf_i in mul];
var 0..1000: objective;

array[index_set(t)] of int: rf_duration =
    [if rf_i in add then del_add else del_mul endif
     | rf_i in index_set(t)];

int: rf_capacity_add = max(1, min(10, number_add));
int: rf_capacity_mul = max(1, min(10, number_mul));

array[index_set(t)] of int: rf_resource_limit =
    [if rf_i in add then rf_capacity_add else rf_capacity_mul endif
     | rf_i in index_set(t)];

array[index_set(t)] of set of int: rf_reach_one =
    [dependencies[rf_i] intersect index_set(t)
     | rf_i in index_set(t)];

array[index_set(t)] of set of int: rf_reach_two =
    [rf_reach_one[rf_i] union
        union(rf_j in rf_reach_one[rf_i])(rf_reach_one[rf_j])
     | rf_i in index_set(t)];

array[index_set(t)] of set of int: rf_reach_four =
    [rf_reach_two[rf_i] union
        union(rf_j in rf_reach_two[rf_i])(rf_reach_two[rf_j])
     | rf_i in index_set(t)];

array[index_set(t)] of set of int: rf_predecessors =
    [{rf_j | rf_j in index_set(t)
           where rf_i in rf_reach_four[rf_j]}
     | rf_i in index_set(t)];

array[index_set(t)] of int: rf_lower_base =
    [max([
        0,
        ((card(rf_predecessors[rf_i] intersect add)
            + rf_capacity_add - 1) div rf_capacity_add) * del_add,
        ((card(rf_predecessors[rf_i] intersect mul)
            + rf_capacity_mul - 1) div rf_capacity_mul) * del_mul
     ])
     | rf_i in index_set(t)];

array[index_set(t)] of int: rf_upper_base =
    [min([
        100,
        if card(rf_reach_four[rf_i] intersect add) > 0 then
            100 + del_add - rf_duration[rf_i]
            - ((card(rf_reach_four[rf_i] intersect add)
                + rf_capacity_add - 1) div rf_capacity_add) * del_add
        else
            100
        endif,
        if card(rf_reach_four[rf_i] intersect mul) > 0 then
            100 + del_mul - rf_duration[rf_i]
            - ((card(rf_reach_four[rf_i] intersect mul)
                + rf_capacity_mul - 1) div rf_capacity_mul) * del_mul
        else
            100
        endif
     ])
     | rf_i in index_set(t)];

array[index_set(t)] of int: rf_lower =
    [max([rf_lower_base[rf_i]] ++
         [rf_lower_base[rf_j] + rf_duration[rf_j]
          | rf_j in rf_predecessors[rf_i]])
     | rf_i in index_set(t)];

array[index_set(t)] of int: rf_upper =
    [min([rf_upper_base[rf_i]] ++
         [rf_upper_base[rf_j] - rf_duration[rf_i]
          | rf_j in rf_reach_four[rf_i]])
     | rf_i in index_set(t)];

array[index_set(t)] of set of int: rf_conflicts =
    [{rf_j | rf_j in index_set(t)
      where rf_i < rf_j
        /\ ((rf_i in add /\ rf_j in add)
            \/ (rf_i in mul /\ rf_j in mul))
        /\ not (rf_j in rf_reach_four[rf_i])
        /\ not (rf_i in rf_reach_four[rf_j])
        /\ rf_upper[rf_i] + rf_duration[rf_i] > rf_lower[rf_j]
        /\ rf_upper[rf_j] + rf_duration[rf_j] > rf_lower[rf_i]}
     | rf_i in index_set(t)];

array[int] of int: rf_pair_first =
    [rf_i | rf_i in index_set(t), rf_j in rf_conflicts[rf_i]];

array[index_set(rf_pair_first)] of int: rf_pair_second =
    [rf_j | rf_i in index_set(t), rf_j in rf_conflicts[rf_i]];

array[index_set(rf_pair_first)] of int: rf_time_m_forward =
    [max(0,
         rf_upper[rf_pair_first[rf_p]]
         + rf_duration[rf_pair_first[rf_p]]
         - rf_lower[rf_pair_second[rf_p]])
     | rf_p in index_set(rf_pair_first)];

array[index_set(rf_pair_first)] of int: rf_time_m_reverse =
    [max(0,
         rf_upper[rf_pair_second[rf_p]]
         + rf_duration[rf_pair_second[rf_p]]
         - rf_lower[rf_pair_first[rf_p]])
     | rf_p in index_set(rf_pair_first)];

array[index_set(rf_pair_first)] of var 0..1: rf_time_forward;
array[index_set(rf_pair_first)] of var 0..1: rf_time_reverse;
array[index_set(rf_pair_first)] of var 0..1: rf_resource_forward;
array[index_set(rf_pair_first)] of var 0..1: rf_resource_reverse;

constraint
    add intersect mul = {}
    /\ card(add) + card(mul) = n;

constraint
    forall(rf_i in index_set(t)) (
        not (rf_i in rf_reach_four[rf_i])
    );

constraint
    forall(rf_i in index_set(t), rf_j in dependencies[rf_i]) (
        t[rf_i] + d[rf_i] <= t[rf_j]
    );

constraint
    forall(rf_i in index_set(t)) (
        if rf_i in add then
            r[rf_i] <= number_add
        else
            r[rf_i] <= number_mul
        endif
    );

constraint
    forall(rf_i in index_set(t)) (
        t[rf_i] >= rf_lower[rf_i]
        /\ t[rf_i] <= rf_upper[rf_i]
    );

constraint
    forall(rf_p in index_set(rf_pair_first)) (
        rf_time_forward[rf_p]
        + rf_time_reverse[rf_p]
        + rf_resource_forward[rf_p]
        + rf_resource_reverse[rf_p] = 1
    );

constraint
    forall(rf_p in index_set(rf_pair_first)) (
        t[rf_pair_first[rf_p]]
        + rf_duration[rf_pair_first[rf_p]]
        <= t[rf_pair_second[rf_p]]
           + rf_time_m_forward[rf_p] * (1 - rf_time_forward[rf_p])
    );

constraint
    forall(rf_p in index_set(rf_pair_first)) (
        t[rf_pair_second[rf_p]]
        + rf_duration[rf_pair_second[rf_p]]
        <= t[rf_pair_first[rf_p]]
           + rf_time_m_reverse[rf_p] * (1 - rf_time_reverse[rf_p])
    );

constraint
    forall(rf_p in index_set(rf_pair_first)) (
        r[rf_pair_first[rf_p]] + 1
        <= r[rf_pair_second[rf_p]]
           + rf_resource_limit[rf_pair_first[rf_p]]
             * (1 - rf_resource_forward[rf_p])
    );

constraint
    forall(rf_p in index_set(rf_pair_first)) (
        r[rf_pair_second[rf_p]] + 1
        <= r[rf_pair_first[rf_p]]
           + rf_resource_limit[rf_pair_second[rf_p]]
             * (1 - rf_resource_reverse[rf_p])
    );

constraint
    let {
        array[1..card(Last)] of var 0..1000: opp =
            [t[rf_i] + d[rf_i] | rf_i in Last]
    } in
        maximum(objective, opp);

solve minimize objective;

output [
    "objective = ", show(objective), ";\n",
    "t = ", show(t), ";\n",
    "r = ", show(r), ";\n"
];
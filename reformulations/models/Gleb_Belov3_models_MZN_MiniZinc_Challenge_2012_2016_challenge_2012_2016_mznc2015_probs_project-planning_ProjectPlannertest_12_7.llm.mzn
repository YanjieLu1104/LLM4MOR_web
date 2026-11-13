set of int: pp12_tasks = index_set([3,1,2,2,1,1,2,3,4,3,1,1]);
array[pp12_tasks] of int: pp12_duration = [3,1,2,2,1,1,2,3,4,3,1,1];

set of int: pp12_slots = index_set([16,17,18,19,20,21,22,23,24,25,26,27]);
array[pp12_slots] of int: pp12_dates = [16,17,18,19,20,21,22,23,24,25,26,27];
array[index_set(pp12_dates)] of int: pp12_capacity = [2,4,0,1,2,0,0,2,4,0,1,2];

set of int: pp12_edges = index_set([2,1,6,9,2,3,11]);
array[pp12_edges] of int: pp12_predecessor = [2,1,6,9,2,3,11];
array[index_set(pp12_predecessor)] of int: pp12_successor = [4,6,10,11,11,12,12];
array[index_set(pp12_predecessor)] of int: pp12_lag = [0,2,2,2,0,1,0];

var 16..27: chooseDay0;
var bool: chooseBool1;
var 16..27: chooseDay18;
var bool: chooseBool19;
var 16..27: chooseDay39;
var bool: chooseBool40;
var 16..27: chooseDay61;
var bool: chooseBool62;
var 16..27: chooseDay84;
var bool: chooseBool85;
var 16..27: chooseDay108;
var bool: chooseBool109;
var 16..27: chooseDay133;
var bool: chooseBool134;
var 16..27: chooseDay159;
var bool: chooseBool160;
var 16..27: chooseDay186;
var bool: chooseBool187;
var 16..27: chooseDay214;
var bool: chooseBool215;
var 16..27: chooseDay243;
var bool: chooseBool244;
var 16..27: chooseDay273;
var bool: chooseBool274;

array[index_set(pp12_duration)] of var 16..27: pp12_day = [
  chooseDay0, chooseDay18, chooseDay39, chooseDay61,
  chooseDay84, chooseDay108, chooseDay133, chooseDay159,
  chooseDay186, chooseDay214, chooseDay243, chooseDay273
];

array[index_set(pp12_duration)] of var bool: pp12_external = [
  chooseBool1, chooseBool19, chooseBool40, chooseBool62,
  chooseBool85, chooseBool109, chooseBool134, chooseBool160,
  chooseBool187, chooseBool215, chooseBool244, chooseBool274
];

array[index_set(pp12_duration), index_set(pp12_dates)] of var 0..1: pp12_internal_at;
array[index_set(pp12_duration), index_set(pp12_dates)] of var 0..1: pp12_external_at;
array[index_set(pp12_dates)] of var 0..1: pp12_external_day;

var 0..156: objective;

constraint forall(pp12_t in pp12_tasks) (
  sum(pp12_d in pp12_slots) (
    pp12_internal_at[pp12_t, pp12_d] +
    pp12_external_at[pp12_t, pp12_d]
  ) = 1
);

constraint forall(pp12_t in pp12_tasks) (
  bool2int(pp12_external[pp12_t]) =
    sum(pp12_d in pp12_slots)(pp12_external_at[pp12_t, pp12_d])
);

constraint forall(pp12_t in pp12_tasks) (
  pp12_day[pp12_t] =
    sum(pp12_d in pp12_slots) (
      pp12_dates[pp12_d] *
      (pp12_internal_at[pp12_t, pp12_d] +
       pp12_external_at[pp12_t, pp12_d])
    )
);

constraint forall(pp12_d in pp12_slots) (
  sum(pp12_t in pp12_tasks) (
    pp12_duration[pp12_t] * pp12_internal_at[pp12_t, pp12_d]
  ) <= pp12_capacity[pp12_d]
);

constraint forall(
  pp12_t in pp12_tasks,
  pp12_d in pp12_slots
  where pp12_duration[pp12_t] > pp12_capacity[pp12_d]
) (
  pp12_internal_at[pp12_t, pp12_d] = 0
);

constraint forall(pp12_t in pp12_tasks, pp12_d in pp12_slots) (
  pp12_external_at[pp12_t, pp12_d] <= pp12_external_day[pp12_d]
);

constraint forall(pp12_d in pp12_slots) (
  pp12_external_day[pp12_d] <=
    sum(pp12_t in pp12_tasks)(pp12_external_at[pp12_t, pp12_d])
);

constraint forall(pp12_e in pp12_edges) (
  pp12_day[pp12_successor[pp12_e]] >=
    pp12_day[pp12_predecessor[pp12_e]] + pp12_lag[pp12_e]
);

constraint forall(pp12_e in pp12_edges, pp12_d in pp12_slots) (
  sum(
    pp12_s in pp12_slots
    where pp12_dates[pp12_s] <= pp12_dates[pp12_d]
  ) (
    pp12_internal_at[pp12_successor[pp12_e], pp12_s] +
    pp12_external_at[pp12_successor[pp12_e], pp12_s]
  )
  <=
  sum(
    pp12_s in pp12_slots
    where pp12_dates[pp12_s] <= pp12_dates[pp12_d] - pp12_lag[pp12_e]
  ) (
    pp12_internal_at[pp12_predecessor[pp12_e], pp12_s] +
    pp12_external_at[pp12_predecessor[pp12_e], pp12_s]
  )
);

constraint forall(
  pp12_d in pp12_slots,
  pp12_t in pp12_tasks,
  pp12_u in pp12_tasks
  where pp12_t < pp12_u /\
        pp12_duration[pp12_t] <= pp12_capacity[pp12_d] /\
        pp12_duration[pp12_u] <= pp12_capacity[pp12_d] /\
        pp12_duration[pp12_t] + pp12_duration[pp12_u] > pp12_capacity[pp12_d]
) (
  pp12_internal_at[pp12_t, pp12_d] +
  pp12_internal_at[pp12_u, pp12_d] <= 1
);

constraint
  sum(pp12_t in pp12_tasks) (
    pp12_duration[pp12_t] * bool2int(pp12_external[pp12_t])
  ) >= sum(pp12_duration) - sum(pp12_capacity);

constraint forall(pp12_q in 1..max(pp12_duration)) (
  sum(
    pp12_t in pp12_tasks
    where pp12_duration[pp12_t] >= pp12_q
  ) (
    1 - bool2int(pp12_external[pp12_t])
  )
  <=
  sum(pp12_d in pp12_slots)(pp12_capacity[pp12_d] div pp12_q)
);

constraint objective =
  5 * sum(pp12_d in pp12_slots)(pp12_external_day[pp12_d]) +
  2 * sum(pp12_t in pp12_tasks) (
    pp12_duration[pp12_t] * bool2int(pp12_external[pp12_t])
  );

solve minimize objective;
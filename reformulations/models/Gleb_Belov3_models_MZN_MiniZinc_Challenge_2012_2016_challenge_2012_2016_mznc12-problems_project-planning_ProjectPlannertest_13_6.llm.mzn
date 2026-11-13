array[int] of int: rf13_duration = [3,1,2,2,1,1,2,3,4,3,1,1,4];
array[int] of int: rf13_capacity = [2,4,0,1,2,0,0,2,4,0,1,2,0];
array[int] of int: rf13_calendar = [17,18,19,20,21,22,23,24,25,26,27,28,29];

set of int: rf13_tasks = index_set(rf13_duration);
set of int: rf13_days = index_set(rf13_capacity);

var 17..29: chooseDay0;
var bool: chooseBool1;
var 17..29: chooseDay19;
var bool: chooseBool20;
var 17..29: chooseDay41;
var bool: chooseBool42;
var 17..29: chooseDay64;
var bool: chooseBool65;
var 17..29: chooseDay88;
var bool: chooseBool89;
var 17..29: chooseDay113;
var bool: chooseBool114;
var 17..29: chooseDay139;
var bool: chooseBool140;
var 17..29: chooseDay166;
var bool: chooseBool167;
var 17..29: chooseDay194;
var bool: chooseBool195;
var 17..29: chooseDay223;
var bool: chooseBool224;
var 17..29: chooseDay253;
var bool: chooseBool254;
var 17..29: chooseDay284;
var bool: chooseBool285;
var 17..29: chooseDay316;
var bool: chooseBool317;

array[int] of var int: rf13_chosen_day = [
  chooseDay0, chooseDay19, chooseDay41, chooseDay64,
  chooseDay88, chooseDay113, chooseDay139, chooseDay166,
  chooseDay194, chooseDay223, chooseDay253, chooseDay284,
  chooseDay316
];

array[int] of var bool: rf13_outsourced = [
  chooseBool1, chooseBool20, chooseBool42, chooseBool65,
  chooseBool89, chooseBool114, chooseBool140, chooseBool167,
  chooseBool195, chooseBool224, chooseBool254, chooseBool285,
  chooseBool317
];

array[int] of int: rf13_predecessor = [1,2,3,6,10,3];
array[int] of int: rf13_successor = [3,5,9,13,13,13];
array[int] of int: rf13_lag = [2,2,0,1,1,0];
set of int: rf13_arcs = index_set(rf13_predecessor);

array[rf13_tasks, rf13_days] of var 0..1: rf13_internal;
array[rf13_tasks, rf13_days] of var 0..1: rf13_external;
array[rf13_days] of var 0..1: rf13_active;
var 0..169: ite551;

constraint forall(rf13_t in rf13_tasks) (
  sum(rf13_d in rf13_days) (
    rf13_internal[rf13_t,rf13_d] + rf13_external[rf13_t,rf13_d]
  ) = 1
);

constraint forall(rf13_t in rf13_tasks) (
  bool2int(rf13_outsourced[rf13_t]) =
  sum(rf13_d in rf13_days)(rf13_external[rf13_t,rf13_d])
);

constraint forall(rf13_t in rf13_tasks) (
  rf13_chosen_day[rf13_t] =
  sum(rf13_d in rf13_days) (
    rf13_calendar[rf13_d] *
    (rf13_internal[rf13_t,rf13_d] + rf13_external[rf13_t,rf13_d])
  )
);

constraint forall(rf13_d in rf13_days) (
  sum(rf13_t in rf13_tasks) (
    rf13_duration[rf13_t] * rf13_internal[rf13_t,rf13_d]
  ) <= rf13_capacity[rf13_d]
);

constraint forall(rf13_t in rf13_tasks, rf13_d in rf13_days
                  where rf13_duration[rf13_t] > rf13_capacity[rf13_d]) (
  rf13_internal[rf13_t,rf13_d] = 0
);

constraint forall(rf13_t in rf13_tasks, rf13_d in rf13_days) (
  rf13_external[rf13_t,rf13_d] <= rf13_active[rf13_d]
);

constraint forall(rf13_d in rf13_days) (
  rf13_active[rf13_d] <=
  sum(rf13_t in rf13_tasks)(rf13_external[rf13_t,rf13_d])
);

constraint forall(rf13_a in rf13_arcs) (
  rf13_chosen_day[rf13_successor[rf13_a]] >=
  rf13_chosen_day[rf13_predecessor[rf13_a]] + rf13_lag[rf13_a]
);

constraint forall(rf13_a in rf13_arcs, rf13_d in rf13_days) (
  sum(rf13_e in rf13_days
      where rf13_calendar[rf13_e] <= rf13_calendar[rf13_d]) (
    rf13_internal[rf13_successor[rf13_a],rf13_e] +
    rf13_external[rf13_successor[rf13_a],rf13_e]
  ) <=
  sum(rf13_e in rf13_days
      where rf13_calendar[rf13_e] <=
            rf13_calendar[rf13_d] - rf13_lag[rf13_a]) (
    rf13_internal[rf13_predecessor[rf13_a],rf13_e] +
    rf13_external[rf13_predecessor[rf13_a],rf13_e]
  )
);

constraint forall(rf13_d in rf13_days) (
  sum(rf13_t in rf13_tasks
      where 2 * rf13_duration[rf13_t] > rf13_capacity[rf13_d]) (
    rf13_internal[rf13_t,rf13_d]
  ) <= 1
);

constraint forall(rf13_d in rf13_days,
                  rf13_t in rf13_tasks, rf13_u in rf13_tasks
                  where rf13_t < rf13_u /\
                        rf13_duration[rf13_t] <= rf13_capacity[rf13_d] /\
                        rf13_duration[rf13_u] <= rf13_capacity[rf13_d] /\
                        rf13_duration[rf13_t] + rf13_duration[rf13_u] >
                        rf13_capacity[rf13_d]) (
  rf13_internal[rf13_t,rf13_d] +
  rf13_internal[rf13_u,rf13_d] <= 1
);

constraint sum(rf13_t in rf13_tasks) (
  rf13_duration[rf13_t] * bool2int(rf13_outsourced[rf13_t])
) >= sum(rf13_duration) - sum(rf13_capacity);

constraint ite551 =
  5 * sum(rf13_d in rf13_days)(rf13_active[rf13_d]) +
  2 * sum(rf13_t in rf13_tasks) (
    rf13_duration[rf13_t] * bool2int(rf13_outsourced[rf13_t])
  );

solve minimize ite551;
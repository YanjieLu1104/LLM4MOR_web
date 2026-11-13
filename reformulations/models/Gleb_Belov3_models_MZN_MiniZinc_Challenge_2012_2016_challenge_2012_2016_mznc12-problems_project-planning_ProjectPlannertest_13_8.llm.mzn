array[int] of int: rfp13_duration =
    [3,1,2,2,1,1,2,3,4,3,1,1,4];

array[int] of int: rfp13_calendar =
    [17,18,19,20,21,22,23,24,25,26,27,28,29];

array[index_set(rfp13_calendar)] of int: rfp13_capacity =
    [2,4,0,1,2,0,0,2,4,0,1,2,0];

set of int: rfp13_tasks = index_set(rfp13_duration);
set of int: rfp13_days = index_set(rfp13_calendar);

array[int] of int: rfp13_predecessor = [1,2,2,3,5,6,10,3];
array[index_set(rfp13_predecessor)] of int: rfp13_successor =
    [3,4,5,9,11,13,13,13];
array[index_set(rfp13_predecessor)] of int: rfp13_lag =
    [2,2,2,0,1,1,1,0];

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

array[rfp13_tasks] of var 17..29: rfp13_chosen_day =
    [chooseDay0,chooseDay19,chooseDay41,chooseDay64,
     chooseDay88,chooseDay113,chooseDay139,chooseDay166,
     chooseDay194,chooseDay223,chooseDay253,chooseDay284,
     chooseDay316];

array[rfp13_tasks] of var bool: rfp13_outsourced =
    [chooseBool1,chooseBool20,chooseBool42,chooseBool65,
     chooseBool89,chooseBool114,chooseBool140,chooseBool167,
     chooseBool195,chooseBool224,chooseBool254,chooseBool285,
     chooseBool317];

array[rfp13_tasks,rfp13_days] of var 0..1: rfp13_internal;
array[rfp13_tasks,rfp13_days] of var 0..1: rfp13_external;
array[rfp13_days] of var 0..1: rfp13_used;

constraint forall(rfp13_t in rfp13_tasks)(
    sum(rfp13_d in rfp13_days)(
        rfp13_internal[rfp13_t,rfp13_d] +
        rfp13_external[rfp13_t,rfp13_d]
    ) = 1
);

constraint forall(rfp13_t in rfp13_tasks)(
    bool2int(rfp13_outsourced[rfp13_t]) =
    sum(rfp13_d in rfp13_days)(
        rfp13_external[rfp13_t,rfp13_d]
    )
);

constraint forall(rfp13_t in rfp13_tasks)(
    rfp13_chosen_day[rfp13_t] =
    sum(rfp13_d in rfp13_days)(
        rfp13_calendar[rfp13_d] *
        (rfp13_internal[rfp13_t,rfp13_d] +
         rfp13_external[rfp13_t,rfp13_d])
    )
);

constraint forall(rfp13_d in rfp13_days)(
    sum(rfp13_t in rfp13_tasks)(
        rfp13_duration[rfp13_t] *
        rfp13_internal[rfp13_t,rfp13_d]
    ) <= rfp13_capacity[rfp13_d]
);

constraint forall(
    rfp13_t in rfp13_tasks,
    rfp13_d in rfp13_days
    where rfp13_duration[rfp13_t] > rfp13_capacity[rfp13_d]
)(
    rfp13_internal[rfp13_t,rfp13_d] = 0
);

constraint forall(rfp13_t in rfp13_tasks, rfp13_d in rfp13_days)(
    rfp13_external[rfp13_t,rfp13_d] <= rfp13_used[rfp13_d]
);

constraint forall(rfp13_d in rfp13_days)(
    rfp13_used[rfp13_d] <=
    sum(rfp13_t in rfp13_tasks)(
        rfp13_external[rfp13_t,rfp13_d]
    )
);

constraint forall(rfp13_e in index_set(rfp13_predecessor))(
    rfp13_chosen_day[rfp13_successor[rfp13_e]] >=
    rfp13_chosen_day[rfp13_predecessor[rfp13_e]] +
    rfp13_lag[rfp13_e]
);

constraint forall(
    rfp13_e in index_set(rfp13_predecessor),
    rfp13_k in rfp13_days
)(
    sum(rfp13_d in rfp13_days
        where rfp13_calendar[rfp13_d] <= rfp13_calendar[rfp13_k])(
        rfp13_internal[rfp13_successor[rfp13_e],rfp13_d] +
        rfp13_external[rfp13_successor[rfp13_e],rfp13_d]
    )
    <=
    sum(rfp13_d in rfp13_days
        where rfp13_calendar[rfp13_d] <=
              rfp13_calendar[rfp13_k] - rfp13_lag[rfp13_e])(
        rfp13_internal[rfp13_predecessor[rfp13_e],rfp13_d] +
        rfp13_external[rfp13_predecessor[rfp13_e],rfp13_d]
    )
);

constraint forall(
    rfp13_a in rfp13_tasks,
    rfp13_b in rfp13_tasks,
    rfp13_d in rfp13_days
    where rfp13_a < rfp13_b /\
          rfp13_duration[rfp13_a] <= rfp13_capacity[rfp13_d] /\
          rfp13_duration[rfp13_b] <= rfp13_capacity[rfp13_d] /\
          rfp13_duration[rfp13_a] + rfp13_duration[rfp13_b] >
          rfp13_capacity[rfp13_d]
)(
    rfp13_internal[rfp13_a,rfp13_d] +
    rfp13_internal[rfp13_b,rfp13_d] <= 1
);

constraint sum(rfp13_t in rfp13_tasks)(
    rfp13_duration[rfp13_t] * bool2int(rfp13_outsourced[rfp13_t])
) >= sum(rfp13_duration) - sum(rfp13_capacity);

var 0..169: ite553;

constraint ite553 =
    5 * sum(rfp13_used) +
    2 * sum(rfp13_t in rfp13_tasks)(
        rfp13_duration[rfp13_t] *
        bool2int(rfp13_outsourced[rfp13_t])
    );

solve minimize ite553;
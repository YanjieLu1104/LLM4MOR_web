int: N;
int: F;
int: MaxItemsPerDay;
int: MaxDay;

array[1..N] of string: name;
array[1..N] of int: kind;
array[1..N] of set of 1..F: facility;
array[1..N] of int: producedDay;
array[1..N] of int: deadLineDay;

array[1..N] of var 1..N: assignedGroup;
array[1..N] of var 0..F: groupFacility;
array[1..N] of var 0..MaxDay: groupProcessDay;
array[1..N] of var 1..MaxDay: itemProcessDay;

var 1..N: nGroups;

int: dlp_max = sum(i in 1..N)(MaxDay - deadLineDay[i]);
var 0..dlp_max: deadLinePenalty;

int: obj_min = lb(deadLinePenalty) * 100 + lb(nGroups);
int: obj_max = ub(deadLinePenalty) * 100 + ub(nGroups);
var obj_min..obj_max: objective;

array[index_set(kind)] of int: rf26_base =
    [sum(rf26_j in index_set(kind))(
        bool2int(kind[rf26_j] < kind[rf26_i])
     ) | rf26_i in index_set(kind)];

array[index_set(kind)] of int: rf26_kindSize =
    [sum(rf26_j in index_set(kind))(
        bool2int(kind[rf26_j] = kind[rf26_i])
     ) | rf26_i in index_set(kind)];

array[index_set(kind)] of int: rf26_rank =
    [sum(rf26_j in index_set(kind) where rf26_j <= rf26_i)(
        bool2int(kind[rf26_j] = kind[rf26_i])
     ) | rf26_i in index_set(kind)];

array[index_set(producedDay)] of int: rf26_firstDay =
    [max(1, producedDay[rf26_i] + 1)
     | rf26_i in index_set(producedDay)];

array[index_set(deadLineDay)] of int: rf26_lastDay =
    [min(MaxDay, deadLineDay[rf26_i] + dlp_max)
     | rf26_i in index_set(deadLineDay)];

array[index_set(groupFacility)] of set of int: rf26_members =
    [{rf26_i | rf26_i in index_set(kind)
       where rf26_base[rf26_i] < rf26_g /\
             rf26_g <= rf26_base[rf26_i] + rf26_kindSize[rf26_i]}
     | rf26_g in index_set(groupFacility)];

array[index_set(groupFacility)] of set of int: rf26_facilities =
    [{rf26_f | rf26_i in rf26_members[rf26_g],
                rf26_f in facility[rf26_i]}
     | rf26_g in index_set(groupFacility)];

array[int] of int: rf26_edgeItem =
    [rf26_i
     | rf26_i in index_set(assignedGroup),
       rf26_g in rf26_base[rf26_i] + 1 ..
                   rf26_base[rf26_i] + rf26_kindSize[rf26_i]];

array[index_set(rf26_edgeItem)] of int: rf26_edgeGroup =
    [rf26_g
     | rf26_i in index_set(assignedGroup),
       rf26_g in rf26_base[rf26_i] + 1 ..
                   rf26_base[rf26_i] + rf26_kindSize[rf26_i]];

array[int] of int: rf26_slotGroup =
    [rf26_g
     | rf26_g in index_set(groupFacility),
       rf26_f in rf26_facilities[rf26_g],
       rf26_d in 1..MaxDay
     where exists(rf26_i in rf26_members[rf26_g])(
         rf26_f in facility[rf26_i] /\
         rf26_firstDay[rf26_i] <= rf26_d /\
         rf26_d <= rf26_lastDay[rf26_i]
     )];

array[index_set(rf26_slotGroup)] of int: rf26_slotFacility =
    [rf26_f
     | rf26_g in index_set(groupFacility),
       rf26_f in rf26_facilities[rf26_g],
       rf26_d in 1..MaxDay
     where exists(rf26_i in rf26_members[rf26_g])(
         rf26_f in facility[rf26_i] /\
         rf26_firstDay[rf26_i] <= rf26_d /\
         rf26_d <= rf26_lastDay[rf26_i]
     )];

array[index_set(rf26_slotGroup)] of int: rf26_slotDay =
    [rf26_d
     | rf26_g in index_set(groupFacility),
       rf26_f in rf26_facilities[rf26_g],
       rf26_d in 1..MaxDay
     where exists(rf26_i in rf26_members[rf26_g])(
         rf26_f in facility[rf26_i] /\
         rf26_firstDay[rf26_i] <= rf26_d /\
         rf26_d <= rf26_lastDay[rf26_i]
     )];

array[int] of int: rf26_dayItem =
    [rf26_i
     | rf26_i in index_set(itemProcessDay),
       rf26_d in rf26_firstDay[rf26_i]..rf26_lastDay[rf26_i]];

array[index_set(rf26_dayItem)] of int: rf26_dayDate =
    [rf26_d
     | rf26_i in index_set(itemProcessDay),
       rf26_d in rf26_firstDay[rf26_i]..rf26_lastDay[rf26_i]];

array[index_set(rf26_edgeItem)] of var 0..1: rf26_assign;
array[index_set(rf26_slotGroup)] of var 0..1: rf26_slot;
array[index_set(rf26_dayItem)] of var 0..1: rf26_day;
array[index_set(groupFacility)] of var 0..1: rf26_used;

constraint forall(rf26_i in index_set(assignedGroup))(
    sum(rf26_e in index_set(rf26_edgeItem)
        where rf26_edgeItem[rf26_e] = rf26_i)(
        rf26_assign[rf26_e]
    ) = 1
);

constraint forall(rf26_i in index_set(assignedGroup))(
    assignedGroup[rf26_i] =
    sum(rf26_e in index_set(rf26_edgeItem)
        where rf26_edgeItem[rf26_e] = rf26_i)(
        rf26_edgeGroup[rf26_e] * rf26_assign[rf26_e]
    )
);

constraint forall(rf26_g in index_set(groupFacility))(
    sum(rf26_s in index_set(rf26_slotGroup)
        where rf26_slotGroup[rf26_s] = rf26_g)(
        rf26_slot[rf26_s]
    ) = rf26_used[rf26_g]
);

constraint forall(rf26_g in index_set(groupFacility))(
    groupFacility[rf26_g] =
    sum(rf26_s in index_set(rf26_slotGroup)
        where rf26_slotGroup[rf26_s] = rf26_g)(
        rf26_slotFacility[rf26_s] * rf26_slot[rf26_s]
    )
);

constraint forall(rf26_g in index_set(groupProcessDay))(
    groupProcessDay[rf26_g] =
    sum(rf26_s in index_set(rf26_slotGroup)
        where rf26_slotGroup[rf26_s] = rf26_g)(
        rf26_slotDay[rf26_s] * rf26_slot[rf26_s]
    )
);

constraint forall(rf26_g in index_set(groupFacility))(
    rf26_used[rf26_g] <=
    sum(rf26_e in index_set(rf26_edgeItem)
        where rf26_edgeGroup[rf26_e] = rf26_g)(
        rf26_assign[rf26_e]
    )
);

constraint forall(rf26_g in index_set(groupFacility))(
    sum(rf26_e in index_set(rf26_edgeItem)
        where rf26_edgeGroup[rf26_e] = rf26_g)(
        rf26_assign[rf26_e]
    ) <=
    min(MaxItemsPerDay, card(rf26_members[rf26_g])) *
    rf26_used[rf26_g]
);

constraint forall(rf26_e in index_set(rf26_edgeItem))(
    rf26_assign[rf26_e] <=
    sum(rf26_s in index_set(rf26_slotGroup)
        where
            rf26_slotGroup[rf26_s] = rf26_edgeGroup[rf26_e] /\
            rf26_slotFacility[rf26_s] in
                facility[rf26_edgeItem[rf26_e]] /\
            rf26_firstDay[rf26_edgeItem[rf26_e]] <=
                rf26_slotDay[rf26_s] /\
            rf26_slotDay[rf26_s] <=
                rf26_lastDay[rf26_edgeItem[rf26_e]])(
        rf26_slot[rf26_s]
    )
);

constraint forall(rf26_i in index_set(itemProcessDay))(
    sum(rf26_t in index_set(rf26_dayItem)
        where rf26_dayItem[rf26_t] = rf26_i)(
        rf26_day[rf26_t]
    ) = 1
);

constraint forall(rf26_i in index_set(itemProcessDay))(
    itemProcessDay[rf26_i] =
    sum(rf26_t in index_set(rf26_dayItem)
        where rf26_dayItem[rf26_t] = rf26_i)(
        rf26_dayDate[rf26_t] * rf26_day[rf26_t]
    )
);

constraint forall(rf26_e in index_set(rf26_edgeItem))(
    itemProcessDay[rf26_edgeItem[rf26_e]] -
    groupProcessDay[rf26_edgeGroup[rf26_e]]
    <=
    max(0, rf26_lastDay[rf26_edgeItem[rf26_e]]) *
    (1 - rf26_assign[rf26_e])
);

constraint forall(rf26_e in index_set(rf26_edgeItem))(
    groupProcessDay[rf26_edgeGroup[rf26_e]] -
    itemProcessDay[rf26_edgeItem[rf26_e]]
    <=
    max(0, MaxDay - rf26_firstDay[rf26_edgeItem[rf26_e]]) *
    (1 - rf26_assign[rf26_e])
);

constraint forall(rf26_f in 1..F, rf26_d in 1..MaxDay)(
    sum(rf26_s in index_set(rf26_slotGroup)
        where rf26_slotFacility[rf26_s] = rf26_f /\
              rf26_slotDay[rf26_s] = rf26_d)(
        rf26_slot[rf26_s]
    ) <= 1
);

constraint forall(rf26_d in 1..MaxDay)(
    sum(rf26_t in index_set(rf26_dayItem)
        where rf26_dayDate[rf26_t] = rf26_d)(
        rf26_day[rf26_t]
    ) <= MaxItemsPerDay
);

constraint symmetry_breaking_constraint(
    forall(rf26_i in index_set(assignedGroup))(
        assignedGroup[rf26_i] <=
        rf26_base[rf26_i] + rf26_rank[rf26_i]
    )
    /\
    forall(rf26_g in index_set(groupFacility)
           where rf26_g + 1 in index_set(groupFacility))(
        if rf26_members[rf26_g] = rf26_members[rf26_g + 1] then
            rf26_used[rf26_g] >= rf26_used[rf26_g + 1]
        else
            true
        endif
    )
);

function var int: groupUsesFacility(int: g, int: f) =
    if groupFacility[g] == f then 1 else 0 endif;

function var int: itemDeadLinePenalty(int: i) =
    if itemProcessDay[i] <= deadLineDay[i] then
        0
    else
        itemProcessDay[i] - deadLineDay[i]
    endif;

constraint deadLinePenalty =
    sum(rf26_t in index_set(rf26_dayItem))(
        max(0,
            rf26_dayDate[rf26_t] -
            deadLineDay[rf26_dayItem[rf26_t]]) *
        rf26_day[rf26_t]
    );

constraint nGroups =
    sum(rf26_g in index_set(groupFacility))(rf26_used[rf26_g]);

constraint objective = deadLinePenalty * 100 + nGroups;

solve minimize objective;

output [ "% item\t k, g, f, day\n" ]
    ++ [ "% \(name[i])\t \(kind[i]), \(assignedGroup[i]), \(groupFacility[assignedGroup[i]]), \(itemProcessDay[i]) (\(producedDay[i]) - \(deadLineDay[i]))\n"
         | i in 1..N ]
    ++ [ "assignedGroup = \(assignedGroup);\n" ]
    ++ [ "groupFacility = \(groupFacility);\n" ]
    ++ [ "groupProcessDay = \(groupProcessDay);\n" ]
    ++ [ "objective = \(objective);\n" ];
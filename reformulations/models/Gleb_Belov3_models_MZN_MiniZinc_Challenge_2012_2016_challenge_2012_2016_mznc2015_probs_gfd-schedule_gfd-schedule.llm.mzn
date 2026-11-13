include "at_most.mzn";

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

set of int: gfd_rf_kinds =
    {kind[i] | i in index_set(kind)};

array[index_set(groupFacility)] of var bool: gfd_rf_used;

constraint
    forall(g in index_set(groupFacility)) (
        (gfd_rf_used[g] <-> groupFacility[g] > 0)
        /\
        groupProcessDay[g] >= bool2int(gfd_rf_used[g])
        /\
        groupProcessDay[g] <= MaxDay * bool2int(gfd_rf_used[g])
    );

constraint
    forall(k in gfd_rf_kinds) (
        let {
            int: base =
                card({i | i in index_set(kind) where kind[i] < k});
            int: size =
                card({i | i in index_set(kind) where kind[i] = k});
            array[1..size] of int: giset =
                [i | i in index_set(kind) where kind[i] = k];
            set of int: gfd_rf_allowed =
                union(i in index_set(giset))(facility[giset[i]]);
        } in
        forall(i in index_set(giset)) (
            base < assignedGroup[giset[i]]
            /\
            assignedGroup[giset[i]] <= base + size
        )
        /\
        forall(g in base + 1..base + size) (
            groupFacility[g] in ({0} union gfd_rf_allowed)
            /\
            sum(i in index_set(giset)) (
                bool2int(assignedGroup[giset[i]] = g)
            ) >= bool2int(gfd_rf_used[g])
            /\
            sum(i in index_set(giset)) (
                bool2int(assignedGroup[giset[i]] = g)
            ) <= size * bool2int(gfd_rf_used[g])
        )
        /\
        (
            if MaxItemsPerDay > 0 then
                sum(g in base + 1..base + size) (
                    bool2int(gfd_rf_used[g])
                ) >=
                    (size + MaxItemsPerDay - 1) div MaxItemsPerDay
            else
                true
            endif
        )
    );

constraint symmetry_breaking_constraint(
    forall(k in gfd_rf_kinds) (
        let {
            int: base =
                card({i | i in index_set(kind) where kind[i] < k});
            int: size =
                card({i | i in index_set(kind) where kind[i] = k});
            array[1..size] of int: giset =
                [i | i in index_set(kind) where kind[i] = k];
        } in
        forall(i in index_set(giset)) (
            assignedGroup[giset[i]] <= base + i
        )
        /\
        forall(g in (base + 1)..(base + size - 1)) (
            gfd_rf_used[g + 1] -> gfd_rf_used[g]
        )
    )
);

constraint
    forall(i in index_set(assignedGroup)) (
        itemProcessDay[i] = groupProcessDay[assignedGroup[i]]
    );

constraint
    forall(i in index_set(assignedGroup)) (
        groupFacility[assignedGroup[i]] in facility[i]
    );

constraint
    forall(i, j in index_set(assignedGroup)
        where i < j
          /\ kind[i] = kind[j]
          /\ card(facility[i] intersect facility[j]) = 0) (
        assignedGroup[i] != assignedGroup[j]
    );

constraint
    forall(i, j in index_set(groupFacility) where i < j) (
        (
            gfd_rf_used[i]
            /\ gfd_rf_used[j]
            /\ groupFacility[i] = groupFacility[j]
        )
        ->
        groupProcessDay[i] != groupProcessDay[j]
    );

constraint
    forall(i in index_set(itemProcessDay)) (
        producedDay[i] < itemProcessDay[i]
    );

constraint
    forall(d in 1..MaxDay) (
        at_most(MaxItemsPerDay, itemProcessDay, d)
    );

function var int: itemDeadLinePenalty(int: i) =
    if deadLineDay[i] >= MaxDay then
        0
    elseif deadLineDay[i] < 1 then
        itemProcessDay[i] - deadLineDay[i]
    else
        max(0, itemProcessDay[i] - deadLineDay[i])
    endif;

constraint
    deadLinePenalty =
        sum(i in index_set(itemProcessDay))(itemDeadLinePenalty(i));

constraint
    nGroups =
        sum(g in index_set(groupFacility))(bool2int(gfd_rf_used[g]));

solve minimize objective;

output [
    "% item\t k, g, f, day\n"
] ++ [
    "% \(name[i])\t \(kind[i]), \(assignedGroup[i]), \(groupFacility[assignedGroup[i]]), \(itemProcessDay[i]) (\(producedDay[i]) - \(deadLineDay[i]))\n"
    | i in 1..N
] ++ [
    "assignedGroup = \(assignedGroup);\n",
    "groupFacility = \(groupFacility);\n",
    "groupProcessDay = \(groupProcessDay);\n",
    "itemProcessDay = \(itemProcessDay);\n",
    "deadLinePenalty = \(deadLinePenalty);\n",
    "nGroups = \(nGroups);\n",
    "objective = \(objective);\n"
];
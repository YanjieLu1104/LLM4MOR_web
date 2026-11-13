int: NShips;
int: NTimeSlots;

array[1..NShips] of int: EarliestStartTimeSlotForShip;
array[1..NTimeSlots, 1..NShips] of int: MaxSailingDraft_cm;
array[1..NShips, 1..NShips] of int: MinSeparationTimeSlots;
array[1..NShips] of int: TonnesPerCmDraft;

int: NBerthSwaps;
array[1..NBerthSwaps] of int: BerthSwap_Incoming;
array[1..NBerthSwaps] of int: BerthSwap_Outgoing;
array[1..NBerthSwaps] of int: BerthSwap_MaxTimeDiff;

int: NTugs;
int: MaxNTugSets;

array[1..NShips] of 0..1: IncomingFlag;
set of 1..NShips: IncomingShips;
set of 1..NShips: OutgoingShips;

array[1..NShips] of int: NTugSetsPerShip;
array[1..NShips, 1..MaxNTugSets] of int: TugSetsPerShip;
array[1..NShips, 1..MaxNTugSets] of int: TugTurnaroundTimeSlots;
array[1..NShips, 1..NShips] of int: ExtraTugAllowanceTimeSlots;

int: MaxTugsRequiredPerShip =
    max([max([TugSetsPerShip[s,t] | t in 1..MaxNTugSets])
         | s in 1..NShips]);

array[1..NShips] of var 1..NTimeSlots: TransitStartTimeSlot;
array[1..NShips] of var 0..1: ShipSails;

int: Draft_cm_min =
    min(s in 1..NShips, t in 1..NTimeSlots)(MaxSailingDraft_cm[t,s]);
int: Draft_cm_max =
    max(s in 1..NShips, t in 1..NTimeSlots)(MaxSailingDraft_cm[t,s]);

array[1..NShips] of var Draft_cm_min..Draft_cm_max: Draft_cm;

array[1..NShips, 1..NTimeSlots, 1..MaxNTugSets]
    of var 0..MaxTugsRequiredPerShip: TugsBusy;
array[1..NShips] of var 0..MaxTugsRequiredPerShip: TugsBusyExtra;

int: TugsBusyPerTimeSlot_min =
    min(t in 1..NTimeSlots)(
        lb(sum(ship in 1..NShips, tugSet in 1..MaxNTugSets)(
            TugsBusy[ship,t,tugSet]
        ))
    );
int: TugsBusyPerTimeSlot_max =
    max(t in 1..NTimeSlots)(
        ub(sum(ship in 1..NShips, tugSet in 1..MaxNTugSets)(
            TugsBusy[ship,t,tugSet]
        ))
    );

array[1..NTimeSlots]
    of var TugsBusyPerTimeSlot_min..TugsBusyPerTimeSlot_max:
    TugsBusyPerTimeSlot;

array[index_set(TransitStartTimeSlot),
      index_set_1of2(MaxSailingDraft_cm)]
    of var 0..1: ssr_time_choice;

array[index_set(ShipSails),
      index_set_1of2(MaxSailingDraft_cm)]
    of var 0..1: ssr_active_choice;

array[index_set(TugsBusyExtra),
      index_set(TugsBusyPerTimeSlot)]
    of var 0..MaxTugsRequiredPerShip: ssr_extra_at_time;

constraint assert(NShips > 0, "Invalid data: NShips must be positive.");
constraint assert(NTimeSlots > 0, "Invalid data: NTimeSlots must be positive.");
constraint assert(
    forall(i in 1..NShips)(EarliestStartTimeSlotForShip[i] > 0),
    "Invalid data: EarliestStartTimeSlotForShip must be positive."
);
constraint assert(
    forall(i in 1..NShips)(
        EarliestStartTimeSlotForShip[i] <= NTimeSlots
    ),
    "Invalid data: EarliestStartTimeSlotForShip must be <= NTimeSlots."
);

constraint forall(s in index_set(TransitStartTimeSlot))(
    sum(t in index_set_2of2(ssr_time_choice))(
        ssr_time_choice[s,t]
    ) = 1
);

constraint forall(s in index_set(TransitStartTimeSlot))(
    TransitStartTimeSlot[s] =
        sum(t in index_set_2of2(ssr_time_choice))(
            t * ssr_time_choice[s,t]
        )
);

constraint forall(s in index_set(ShipSails))(
    sum(t in index_set_2of2(ssr_active_choice))(
        ssr_active_choice[s,t]
    ) = ShipSails[s]
);

constraint forall(
    s in index_set_1of2(ssr_active_choice),
    t in index_set_2of2(ssr_active_choice)
)(
    ssr_active_choice[s,t] <= ssr_time_choice[s,t]
);

constraint forall(
    s in index_set_1of2(ssr_active_choice),
    t in index_set_2of2(ssr_active_choice)
    where t < EarliestStartTimeSlotForShip[s] \/
          MaxSailingDraft_cm[t,s] = 0
)(
    ssr_active_choice[s,t] = 0
);

constraint forall(s in index_set(Draft_cm))(
    Draft_cm[s] =
        sum(t in index_set_2of2(ssr_time_choice))(
            MaxSailingDraft_cm[t,s] * ssr_time_choice[s,t]
        )
);

constraint forall(ship in 1..NBerthSwaps)(
    TransitStartTimeSlot[BerthSwap_Outgoing[ship]] <=
    TransitStartTimeSlot[BerthSwap_Incoming[ship]] +
        BerthSwap_MaxTimeDiff[ship]
);

constraint forall(
    ship1 in index_set(ShipSails),
    ship2 in index_set(ShipSails),
    t in index_set_2of2(ssr_active_choice)
    where ship1 < ship2 /\
          t >= EarliestStartTimeSlotForShip[ship1] /\
          MaxSailingDraft_cm[t,ship1] != 0
)(
    ssr_active_choice[ship1,t] +
    sum(
        ssr_v in index_set_2of2(ssr_active_choice)
        where ssr_v >= EarliestStartTimeSlotForShip[ship2] /\
              MaxSailingDraft_cm[ssr_v,ship2] != 0 /\
              ssr_v - t < MinSeparationTimeSlots[ship1,ship2] /\
              t - ssr_v < MinSeparationTimeSlots[ship2,ship1]
    )(
        ssr_active_choice[ship2,ssr_v]
    ) <= 1
);

constraint forall(
    ship in index_set_1of3(TugsBusy),
    t in index_set_2of3(TugsBusy),
    tugSet in index_set_3of3(TugsBusy)
)(
    TugsBusy[ship,t,tugSet] =
        TugSetsPerShip[ship,tugSet] *
        sum(
            ssr_v in index_set_2of2(ssr_active_choice)
            where ssr_v <= t /\
                  t < ssr_v + TugTurnaroundTimeSlots[ship,tugSet]
        )(
            ssr_active_choice[ship,ssr_v]
        )
);

constraint forall(t in index_set(TugsBusyPerTimeSlot))(
    TugsBusyPerTimeSlot[t] =
        sum(
            ship in index_set_1of3(TugsBusy),
            tugSet in index_set_3of3(TugsBusy)
        )(
            TugsBusy[ship,t,tugSet]
        )
);

constraint forall(
    ship in OutgoingShips,
    t in index_set_2of2(ssr_extra_at_time)
)(
    ssr_extra_at_time[ship,t] <=
        MaxTugsRequiredPerShip * ssr_time_choice[ship,t]
);

constraint forall(ship in OutgoingShips)(
    sum(t in index_set_2of2(ssr_extra_at_time))(
        ssr_extra_at_time[ship,t]
    ) = TugsBusyExtra[ship]
);

constraint forall(
    ship in index_set_1of2(ssr_extra_at_time),
    t in index_set_2of2(ssr_extra_at_time)
    where not (ship in OutgoingShips)
)(
    ssr_extra_at_time[ship,t] = 0
);

constraint forall(t in index_set_2of3(TugsBusy))(
    sum(ship in IncomingShips, tugSet in index_set_3of3(TugsBusy))(
        TugsBusy[ship,t,tugSet]
    ) <= NTugs
);

constraint forall(t in index_set_2of3(TugsBusy))(
    sum(ship in OutgoingShips)(
        sum(tugSet in index_set_3of3(TugsBusy))(
            TugsBusy[ship,t,tugSet]
        ) + ssr_extra_at_time[ship,t]
    ) <= NTugs
);

constraint forall(ship1 in IncomingShips, ship2 in OutgoingShips)(
    (
        TransitStartTimeSlot[ship1] < TransitStartTimeSlot[ship2] /\
        TransitStartTimeSlot[ship1] +
            max([TugTurnaroundTimeSlots[ship1,tugSet]
                 | tugSet in 1..MaxNTugSets]) +
            ExtraTugAllowanceTimeSlots[ship1,ship2] >
                TransitStartTimeSlot[ship2]
    ) ->
    TugsBusyExtra[ship2] =
        sum(tugSet in 1..MaxNTugSets)(
            TugSetsPerShip[ship1,tugSet]
        )
);

constraint forall(ship1 in IncomingShips)(
    TugsBusyExtra[ship1] = 0
);

constraint forall(ship1 in IncomingShips, ship2 in OutgoingShips)(
    (
        TransitStartTimeSlot[ship1] > TransitStartTimeSlot[ship2] \/
        TransitStartTimeSlot[ship1] +
            max([TugTurnaroundTimeSlots[ship1,tugSet]
                 | tugSet in 1..MaxNTugSets]) +
            ExtraTugAllowanceTimeSlots[ship1,ship2] <=
                TransitStartTimeSlot[ship2]
    ) ->
    TugsBusyExtra[ship2] = 0
);

int: objective_function_min =
    min(i in 1..NShips)(
        lb(ShipSails[i] * Draft_cm[i] * TonnesPerCmDraft[i])
    );
int: objective_function_max =
    max(i in 1..NShips)(
        ub(ShipSails[i] * Draft_cm[i] * TonnesPerCmDraft[i])
    );

array[1..NShips]
    of var objective_function_min..objective_function_max:
    objective_function = [
        sum(t in index_set_2of2(ssr_active_choice))(
            MaxSailingDraft_cm[t,i] * TonnesPerCmDraft[i] *
                ssr_active_choice[i,t]
        )
        | i in 1..NShips
    ];

int: minObj =
    lb(sum(ship in 1..NShips)(objective_function[ship]));
int: maxObj =
    ub(sum(ship in 1..NShips)(objective_function[ship]));

var minObj..maxObj: objective =
    sum(ship in 1..NShips)(objective_function[ship]);

solve maximize objective;

output
[ "% Drafts and sailing slots for each ship:\n% " ] ++
[
    "Ship " ++ show(i) ++
    ": ship sails: " ++ show(ShipSails[i] > 0) ++
    ", draft " ++ show(Draft_cm[i]) ++
    ", time " ++ show(TransitStartTimeSlot[i]) ++
    ", obj. fun. value " ++ show(objective_function[i]) ++ "\n% "
    | i in 1..NShips
] ++
[ "TOTAL OBJ FUN VALUE: " ++ show(objective) ++ "\n" ] ++
[
    "TransitStartTimeSlot = ", show(TransitStartTimeSlot), ";\n",
    "ShipSails = ", show(ShipSails), ";\n",
    "constraint objective = ", show(objective), ";\n"
];
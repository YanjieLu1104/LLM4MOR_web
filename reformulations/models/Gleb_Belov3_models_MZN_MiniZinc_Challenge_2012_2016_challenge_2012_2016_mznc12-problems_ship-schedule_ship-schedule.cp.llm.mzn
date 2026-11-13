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
    min(s in 1..NShips, t in 1..NTimeSlots)(
        MaxSailingDraft_cm[t,s]
    );

int: Draft_cm_max =
    max(s in 1..NShips, t in 1..NTimeSlots)(
        MaxSailingDraft_cm[t,s]
    );

array[1..NShips] of var Draft_cm_min..Draft_cm_max: Draft_cm;

array[1..NShips, 1..NTimeSlots, 1..MaxNTugSets]
    of var 0..MaxTugsRequiredPerShip: TugsBusy;

array[1..NShips]
    of var 0..MaxTugsRequiredPerShip: TugsBusyExtra;

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

set of int: ssrf_ships = index_set(TransitStartTimeSlot);
set of int: ssrf_times = index_set_1of2(MaxSailingDraft_cm);
set of int: ssrf_tugsets = index_set_2of2(TugSetsPerShip);

array[ssrf_ships, ssrf_times] of var 0..1: ssrf_departure;
array[ssrf_ships, ssrf_times] of var 0..1: ssrf_sailing;

array[ssrf_ships, ssrf_times]
    of var 0..MaxTugsRequiredPerShip: ssrf_extra_at;

array[ssrf_ships] of int: ssrf_max_turnaround =
    array1d(
        ssrf_ships,
        [
            max(ssrf_k in ssrf_tugsets)(
                TugTurnaroundTimeSlots[ssrf_s,ssrf_k]
            )
            | ssrf_s in ssrf_ships
        ]
    );

array[ssrf_ships] of int: ssrf_total_tugs =
    array1d(
        ssrf_ships,
        [
            sum(ssrf_k in ssrf_tugsets)(
                TugSetsPerShip[ssrf_s,ssrf_k]
            )
            | ssrf_s in ssrf_ships
        ]
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
    objective_function =
    [
        sum(ssrf_t in ssrf_times)(
            MaxSailingDraft_cm[ssrf_t,i] *
            TonnesPerCmDraft[i] *
            ssrf_sailing[i,ssrf_t]
        )
        | i in 1..NShips
    ];

constraint assert(
    NShips > 0,
    "Invalid data: NShips must be positive."
);

constraint assert(
    NTimeSlots > 0,
    "Invalid data: NTimeSlots must be positive."
);

constraint assert(
    forall(i in 1..NShips)(
        EarliestStartTimeSlotForShip[i] > 0
    ),
    "Invalid data: EarliestStartTimeSlotForShip must be positive."
);

constraint assert(
    forall(i in 1..NShips)(
        EarliestStartTimeSlotForShip[i] <= NTimeSlots
    ),
    "Invalid data: EarliestStartTimeSlotForShip must be <= NTimeSlots."
);

constraint forall(ssrf_s in ssrf_ships)(
    sum(ssrf_t in ssrf_times)(
        ssrf_departure[ssrf_s,ssrf_t]
    ) = 1
);

constraint forall(ssrf_s in ssrf_ships)(
    TransitStartTimeSlot[ssrf_s] =
    sum(ssrf_t in ssrf_times)(
        ssrf_t * ssrf_departure[ssrf_s,ssrf_t]
    )
);

constraint forall(ssrf_s in ssrf_ships)(
    Draft_cm[ssrf_s] =
    sum(ssrf_t in ssrf_times)(
        MaxSailingDraft_cm[ssrf_t,ssrf_s] *
        ssrf_departure[ssrf_s,ssrf_t]
    )
);

constraint forall(
    ssrf_s in ssrf_ships,
    ssrf_t in ssrf_times
)(
    ssrf_sailing[ssrf_s,ssrf_t] <=
    ssrf_departure[ssrf_s,ssrf_t]
);

constraint forall(ssrf_s in ssrf_ships)(
    sum(ssrf_t in ssrf_times)(
        ssrf_sailing[ssrf_s,ssrf_t]
    ) = ShipSails[ssrf_s]
);

constraint forall(
    ssrf_s in ssrf_ships,
    ssrf_t in ssrf_times
    where
        ssrf_t < EarliestStartTimeSlotForShip[ssrf_s] \/
        MaxSailingDraft_cm[ssrf_t,ssrf_s] = 0
)(
    ssrf_sailing[ssrf_s,ssrf_t] = 0
);

constraint forall(ssrf_b in index_set(BerthSwap_Incoming))(
    TransitStartTimeSlot[BerthSwap_Outgoing[ssrf_b]] <=
    TransitStartTimeSlot[BerthSwap_Incoming[ssrf_b]] +
    BerthSwap_MaxTimeDiff[ssrf_b]
);

constraint forall(
    ssrf_s in ssrf_ships,
    ssrf_r in ssrf_ships,
    ssrf_t in ssrf_times
    where
        ssrf_s < ssrf_r /\
        ssrf_t >= EarliestStartTimeSlotForShip[ssrf_s] /\
        MaxSailingDraft_cm[ssrf_t,ssrf_s] != 0
)(
    ssrf_sailing[ssrf_s,ssrf_t] +
    sum(
        ssrf_u in ssrf_times
        where
            ssrf_u >= EarliestStartTimeSlotForShip[ssrf_r] /\
            MaxSailingDraft_cm[ssrf_u,ssrf_r] != 0 /\
            ssrf_u - ssrf_t <
                MinSeparationTimeSlots[ssrf_s,ssrf_r] /\
            ssrf_t - ssrf_u <
                MinSeparationTimeSlots[ssrf_r,ssrf_s]
    )(
        ssrf_sailing[ssrf_r,ssrf_u]
    ) <= 1
);

constraint forall(
    ssrf_s in ssrf_ships,
    ssrf_t in ssrf_times,
    ssrf_k in ssrf_tugsets
)(
    TugsBusy[ssrf_s,ssrf_t,ssrf_k] =
    TugSetsPerShip[ssrf_s,ssrf_k] *
    sum(
        ssrf_u in ssrf_times
        where
            ssrf_u <= ssrf_t /\
            ssrf_t <
                ssrf_u + TugTurnaroundTimeSlots[ssrf_s,ssrf_k]
    )(
        ssrf_sailing[ssrf_s,ssrf_u]
    )
);

constraint forall(ssrf_t in ssrf_times)(
    TugsBusyPerTimeSlot[ssrf_t] =
    sum(
        ssrf_s in ssrf_ships,
        ssrf_k in ssrf_tugsets
    )(
        TugsBusy[ssrf_s,ssrf_t,ssrf_k]
    )
);

constraint forall(
    ssrf_s in ssrf_ships,
    ssrf_t in ssrf_times
)(
    if ssrf_s in OutgoingShips then
        ssrf_extra_at[ssrf_s,ssrf_t] <=
        MaxTugsRequiredPerShip * ssrf_departure[ssrf_s,ssrf_t]
    else
        ssrf_extra_at[ssrf_s,ssrf_t] = 0
    endif
);

constraint forall(ssrf_s in OutgoingShips)(
    sum(ssrf_t in ssrf_times)(
        ssrf_extra_at[ssrf_s,ssrf_t]
    ) = TugsBusyExtra[ssrf_s]
);

constraint forall(ssrf_t in ssrf_times)(
    sum(
        ssrf_s in IncomingShips,
        ssrf_k in ssrf_tugsets
    )(
        TugsBusy[ssrf_s,ssrf_t,ssrf_k]
    ) <= NTugs
);

constraint forall(ssrf_t in ssrf_times)(
    sum(ssrf_s in OutgoingShips)(
        sum(ssrf_k in ssrf_tugsets)(
            TugsBusy[ssrf_s,ssrf_t,ssrf_k]
        ) +
        ssrf_extra_at[ssrf_s,ssrf_t]
    ) <= NTugs
);

constraint forall(
    ssrf_s in IncomingShips,
    ssrf_r in OutgoingShips
)(
    (
        TransitStartTimeSlot[ssrf_s] <
            TransitStartTimeSlot[ssrf_r] /\
        TransitStartTimeSlot[ssrf_s] +
            ssrf_max_turnaround[ssrf_s] +
            ExtraTugAllowanceTimeSlots[ssrf_s,ssrf_r] >
            TransitStartTimeSlot[ssrf_r]
    ) ->
    TugsBusyExtra[ssrf_r] = ssrf_total_tugs[ssrf_s]
);

constraint forall(ssrf_s in IncomingShips)(
    TugsBusyExtra[ssrf_s] = 0
);

constraint forall(
    ssrf_s in IncomingShips,
    ssrf_r in OutgoingShips
)(
    (
        TransitStartTimeSlot[ssrf_s] >
            TransitStartTimeSlot[ssrf_r] \/
        TransitStartTimeSlot[ssrf_s] +
            ssrf_max_turnaround[ssrf_s] +
            ExtraTugAllowanceTimeSlots[ssrf_s,ssrf_r] <=
            TransitStartTimeSlot[ssrf_r]
    ) ->
    TugsBusyExtra[ssrf_r] = 0
);

solve maximize sum(ship in 1..NShips)(
    objective_function[ship]
);

output
    ["Drafts and sailing slots for each ship:\n"] ++
    [
        "Ship " ++ show(i) ++
        ": ship sails: " ++ show(ShipSails[i] > 0) ++
        ", draft " ++ show(Draft_cm[i]) ++
        ", time " ++ show(TransitStartTimeSlot[i]) ++
        ", obj. fun. value " ++ show(objective_function[i]) ++ "\n"
        | i in 1..NShips
    ] ++
    [
        "TOTAL OBJ FUN VALUE: " ++
        show(sum(ship in 1..NShips)(objective_function[ship])) ++ "\n"
    ] ++
    ["\n"];
predicate rfp_lookup(
    var int: rfp_key,
    array[int] of var int: rfp_keys,
    array[int] of var bool: rfp_active,
    array[int] of var int: rfp_values,
    bool: rfp_tail,
    var int: rfp_index,
    var int: rfp_value
) =
    rfp_index in index_set(rfp_keys) /\
    forall(rfp_j in index_set(rfp_keys))(
        (rfp_index = rfp_j) ->
        (rfp_active[rfp_j] /\
         rfp_key = rfp_keys[rfp_j] /\
         rfp_value = rfp_values[rfp_j])
    ) /\
    forall(rfp_j in index_set(rfp_keys)
           where not rfp_tail \/ rfp_j < max(index_set(rfp_keys)))(
        (rfp_active[rfp_j] /\ rfp_key = rfp_keys[rfp_j]) ->
        rfp_index >= rfp_j
    );

var {23,29,35,41,47,53,65}: chooseobj_1530;
var {23,29,35,41,47,53,65}: chooseobj_1581;
var {23,29,35,41,47,53,65}: chooseobj_1632;
var {23,29,35,41,47,53,65}: chooseobj_1683;
var {23,29,35,41,47,53,65}: chooseobj_1734;
var {47,59,65}: chooseobj_2405;
var {47,59,65}: chooseobj_2456;
var {47,59,65}: chooseobj_2507;
var {47,59,65}: chooseobj_2564;
var {47,59,65}: chooseobj_2621;
var {47,59,65}: chooseobj_2678;
var {47,59,65}: chooseobj_2735;
var {29,35,41,47,53,59,65}: chooseobj_3496;
var {29,35,41,47,53,59,65}: chooseobj_3553;
var {29,35,41,47,53,59,65}: chooseobj_3610;

var {23,29,35,41,47,53,65}: pizza_1539;
var {23,29,35,41,47,53,65}: pizza_1590;
var {23,29,35,41,47,53,65}: pizza_1641;
var {23,29,35,41,47,53,65}: pizza_1692;
var {23,29,35,41,47,53,65}: pizza_1743;
var {47,59,65}: pizza_2414;
var {47,59,65}: pizza_2465;
var {47,59,65}: pizza_2516;
var {47,59,65}: pizza_2573;
var {47,59,65}: pizza_2630;
var {47,59,65}: pizza_2687;
var {47,59,65}: pizza_2744;
var {29,35,41,47,53,59,65}: pizza_3505;
var {29,35,41,47,53,59,65}: pizza_3562;
var {29,35,41,47,53,59,65}: pizza_3619;

var 1..1: ipizza_1539;
var 1..1: ipizza_1590;
var 1..1: ipizza_1641;
var 1..1: ipizza_1692;
var 1..1: ipizza_1743;
var 1..1: ipizza_2414;
var 1..1: ipizza_2465;
var 1..1: ipizza_2516;
var 1..1: ipizza_2573;
var 1..1: ipizza_2630;
var 1..1: ipizza_2687;
var 1..1: ipizza_2744;
var 1..1: ipizza_3505;
var 1..1: ipizza_3562;
var 1..1: ipizza_3619;

var 0..1: numSlices_1599;
var 0..2: numSlices_1650;
var 0..3: numSlices_1701;
var 0..4: numSlices_1752;
var 0..5: numSlices_2423;
var 0..6: numSlices_2474;
var 0..7: numSlices_2525;
var 0..8: numSlices_2582;
var 0..9: numSlices_2639;
var 0..10: numSlices_2696;
var 0..11: numSlices_2753;
var 0..12: numSlices_3514;
var 0..13: numSlices_3571;
var 0..14: numSlices_3628;

var 1..8: inumSlices_1599;
var 1..9: inumSlices_1650;
var 1..10: inumSlices_1701;
var 1..11: inumSlices_1752;
var 1..8: inumSlices_2423;
var 1..9: inumSlices_2474;
var 1..10: inumSlices_2525;
var 1..12: inumSlices_2582;
var 1..14: inumSlices_2639;
var 1..16: inumSlices_2696;
var 1..18: inumSlices_2753;
var 1..24: inumSlices_3514;
var 1..26: inumSlices_3571;
var 1..28: inumSlices_3628;

var 0..1: fullPizzas_2592;
var 0..2: fullPizzas_2649;
var 0..3: fullPizzas_2706;
var 0..4: fullPizzas_2763;
var 0..5: fullPizzas_3524;
var 0..6: fullPizzas_3581;
var 0..7: fullPizzas_3638;

var 1..5: ifullPizzas_2592;
var 1..6: ifullPizzas_2649;
var 1..7: ifullPizzas_2706;
var 1..8: ifullPizzas_2763;
var 1..13: ifullPizzas_3524;
var 1..14: ifullPizzas_3581;
var 1..15: ifullPizzas_3638;

var 1..8: numSlices_2529;
var 1..9: numSlices_2586;
var 1..10: numSlices_2643;
var 1..11: numSlices_2700;
var 1..12: numSlices_2757;
var 1..13: numSlices_3518;
var 1..14: numSlices_3575;
var 1..15: numSlices_3632;

var 1..1: inumSlices_2529;
var 1..1: inumSlices_2586;
var 1..1: inumSlices_2643;
var 1..1: inumSlices_2700;
var 1..1: inumSlices_2757;
var 1..1: inumSlices_3518;
var 1..1: inumSlices_3575;
var 1..1: inumSlices_3632;

var 0..5: numSlices_3722;
var 0..15: numSlices_3788;
var 0..15: numSlices_3854;
var 0..15: numSlices_3920;
var 0..15: numSlices_3986;
var 0..15: numSlices_4052;
var 0..15: numSlices_4118;
var 0..15: numSlices_4184;

var 1..6: inumSlices_3722;
var 1..12: inumSlices_3788;
var 1..12: inumSlices_3854;
var 1..12: inumSlices_3920;
var 1..24: inumSlices_3986;
var 1..12: inumSlices_4052;
var 1..19: inumSlices_4118;
var 1..24: inumSlices_4184;

var 0..5: numSlices_3726;
var 0..15: numSlices_3792;
var 0..15: numSlices_3858;
var 0..15: numSlices_3924;
var 0..15: numSlices_3990;
var 0..15: numSlices_4056;
var 0..15: numSlices_4122;
var 0..15: numSlices_4188;

var 1..7: inumSlices_3726;
var 1..13: inumSlices_3792;
var 1..13: inumSlices_3858;
var 1..13: inumSlices_3924;
var 1..25: inumSlices_3990;
var 1..13: inumSlices_4056;
var 1..20: inumSlices_4122;
var 1..25: inumSlices_4188;

var 0..8: fullPizzas_3783;
var 0..8: fullPizzas_3849;
var 0..8: fullPizzas_3915;
var 0..8: fullPizzas_3981;
var 0..8: fullPizzas_4047;
var 0..8: fullPizzas_4113;
var 0..8: fullPizzas_4179;

var 1..4: ifullPizzas_3783;
var 1..4: ifullPizzas_3849;
var 1..4: ifullPizzas_3915;
var 1..9: ifullPizzas_3981;
var 1..4: ifullPizzas_4047;
var 1..9: ifullPizzas_4113;
var 1..9: ifullPizzas_4179;

var 0..20: slicesCost_3731;
var 0..75: slicesCost_3797;
var 0..60: slicesCost_3863;
var 0..75: slicesCost_3929;
var 0..45: slicesCost_3995;
var 0..60: slicesCost_4061;
var 0..45: slicesCost_4127;
var 0..75: slicesCost_4193;

var 1..2: islicesCost_3731;
var 1..2: islicesCost_3797;
var 1..2: islicesCost_3863;
var 1..2: islicesCost_3929;
var 1..2: islicesCost_3995;
var 1..2: islicesCost_4061;
var 1..2: islicesCost_4127;
var 1..2: islicesCost_4193;

var 0..20: slicesCost_3739;
var 0..75: slicesCost_3805;
var 0..60: slicesCost_3871;
var 0..75: slicesCost_3937;
var 0..45: slicesCost_4003;
var 0..60: slicesCost_4069;
var 0..45: slicesCost_4135;
var 0..75: slicesCost_4201;

var 1..3: islicesCost_3739;
var 1..3: islicesCost_3805;
var 1..3: islicesCost_3871;
var 1..3: islicesCost_3937;
var 1..3: islicesCost_4003;
var 1..3: islicesCost_4069;
var 1..3: islicesCost_4135;
var 1..3: islicesCost_4201;

var 0..80: cost_3804;
var 0..112: cost_3870;
var 0..128: cost_3936;
var 0..80: cost_4002;
var 0..120: cost_4068;
var 0..88: cost_4134;
var 0..128: cost_4200;

var 1..2: icost_3804;
var 1..2: icost_3870;
var 1..2: icost_3936;
var 1..2: icost_4002;
var 1..2: icost_4068;
var 1..2: icost_4134;
var 1..2: icost_4200;

var 0..20: cost_3743;
var 0..155: cost_3809;
var 0..172: cost_3875;
var 0..203: cost_3941;
var 0..125: cost_4007;
var 0..180: cost_4073;
var 0..133: cost_4139;
var 0..203: cost_4205;

var 1..2: icost_3743;
var 1..2: icost_3809;
var 1..2: icost_3875;
var 1..2: icost_3941;
var 1..2: icost_4007;
var 1..2: icost_4073;
var 1..2: icost_4139;
var 1..2: icost_4205;

var 0..20: ret_getCost_3747;
var 0..155: ret_getCost_3813;
var 0..172: ret_getCost_3879;
var 0..203: ret_getCost_3945;
var 0..125: ret_getCost_4011;
var 0..180: ret_getCost_4077;
var 0..133: ret_getCost_4143;
var 0..203: ret_getCost_4209;

var 1..1: iret_getCost_3747;
var 1..1: iret_getCost_3813;
var 1..1: iret_getCost_3879;
var 1..1: iret_getCost_3945;
var 1..1: iret_getCost_4011;
var 1..1: iret_getCost_4077;
var 1..1: iret_getCost_4143;
var 1..1: iret_getCost_4209;

var 0..20: totalcost_3772;
var 0..175: totalcost_3838;
var 0..347: totalcost_3904;
var 0..550: totalcost_3970;
var 0..675: totalcost_4036;
var 0..855: totalcost_4102;
var 0..988: totalcost_4168;
var 0..1191: totalcost_4214;

var 1..1: itotalcost_3772;
var 1..1: itotalcost_3838;
var 1..1: itotalcost_3904;
var 1..1: itotalcost_3970;
var 1..1: itotalcost_4036;
var 1..1: itotalcost_4102;
var 1..1: itotalcost_4168;
var 1..1: itotalcost_4214;

var 0..1191: ret_totalCost_4218;
var 1..1: iret_totalCost_4218;
var 0..1191: objective;
var 1..1: iobjective;

set of int: rfp_steps = index_set([
    chooseobj_1530, chooseobj_1581, chooseobj_1632,
    chooseobj_1683, chooseobj_1734, chooseobj_2405,
    chooseobj_2456, chooseobj_2507, chooseobj_2564,
    chooseobj_2621, chooseobj_2678, chooseobj_2735,
    chooseobj_3496, chooseobj_3553, chooseobj_3610
]);

set of int: rfp_types = index_set([23,29,35,41,47,53,59,65]);
set of int: rfp_beforesteps = rfp_steps diff {min(rfp_steps)};
set of int: rfp_resetsteps = rfp_steps intersect (8..max(rfp_steps));
set of int: rfp_fullsteps = rfp_steps intersect (9..max(rfp_steps));
set of int: rfp_fulltypes = rfp_types diff {min(rfp_types)};
set of int: rfp_counts = 0..card(rfp_steps);

array[rfp_types] of int: rfp_type = [23,29,35,41,47,53,59,65];
array[rfp_types] of int: rfp_slice_price = [4,5,4,5,3,4,3,5];
array[rfp_types] of int: rfp_whole_price = [11,10,14,16,10,15,11,16];
array[rfp_types] of int: rfp_slice_cap = [5,15,15,15,15,15,15,15];

array[rfp_steps] of set of int: rfp_allowed = [
    {23,29,35,41,47,53,65},
    {23,29,35,41,47,53,65},
    {23,29,35,41,47,53,65},
    {23,29,35,41,47,53,65},
    {23,29,35,41,47,53,65},
    {47,59,65},
    {47,59,65},
    {47,59,65},
    {47,59,65},
    {47,59,65},
    {47,59,65},
    {47,59,65},
    {29,35,41,47,53,59,65},
    {29,35,41,47,53,59,65},
    {29,35,41,47,53,59,65}
];

array[rfp_steps] of var int: rfp_choice = [
    chooseobj_1530, chooseobj_1581, chooseobj_1632,
    chooseobj_1683, chooseobj_1734, chooseobj_2405,
    chooseobj_2456, chooseobj_2507, chooseobj_2564,
    chooseobj_2621, chooseobj_2678, chooseobj_2735,
    chooseobj_3496, chooseobj_3553, chooseobj_3610
];

array[rfp_steps] of var int: rfp_pizza = [
    pizza_1539, pizza_1590, pizza_1641, pizza_1692, pizza_1743,
    pizza_2414, pizza_2465, pizza_2516, pizza_2573, pizza_2630,
    pizza_2687, pizza_2744, pizza_3505, pizza_3562, pizza_3619
];

array[rfp_beforesteps] of var int: rfp_before =
    array1d(rfp_beforesteps, [
        numSlices_1599, numSlices_1650, numSlices_1701,
        numSlices_1752, numSlices_2423, numSlices_2474,
        numSlices_2525, numSlices_2582, numSlices_2639,
        numSlices_2696, numSlices_2753, numSlices_3514,
        numSlices_3571, numSlices_3628
    ]);

array[rfp_beforesteps] of var int: rfp_before_index =
    array1d(rfp_beforesteps, [
        inumSlices_1599, inumSlices_1650, inumSlices_1701,
        inumSlices_1752, inumSlices_2423, inumSlices_2474,
        inumSlices_2525, inumSlices_2582, inumSlices_2639,
        inumSlices_2696, inumSlices_2753, inumSlices_3514,
        inumSlices_3571, inumSlices_3628
    ]);

array[rfp_steps] of var 1..card(rfp_steps): rfp_added =
    array1d(rfp_steps,
        [1] ++ [rfp_before[rfp_t] + 1 | rfp_t in rfp_beforesteps]
    );

array[rfp_resetsteps] of var int: rfp_after =
    array1d(rfp_resetsteps, [
        numSlices_2529, numSlices_2586, numSlices_2643,
        numSlices_2700, numSlices_2757, numSlices_3518,
        numSlices_3575, numSlices_3632
    ]);

array[rfp_fullsteps] of var int: rfp_full_before =
    array1d(rfp_fullsteps, [
        fullPizzas_2592, fullPizzas_2649, fullPizzas_2706,
        fullPizzas_2763, fullPizzas_3524, fullPizzas_3581,
        fullPizzas_3638
    ]);

array[rfp_fullsteps] of var int: rfp_full_before_index =
    array1d(rfp_fullsteps, [
        ifullPizzas_2592, ifullPizzas_2649, ifullPizzas_2706,
        ifullPizzas_2763, ifullPizzas_3524, ifullPizzas_3581,
        ifullPizzas_3638
    ]);

array[rfp_resetsteps] of var 1..8: rfp_full_added =
    array1d(rfp_resetsteps,
        [1] ++ [rfp_full_before[rfp_t] + 1 | rfp_t in rfp_fullsteps]
    );

set of int: rfp_events = index_set([
    rfp_t
    | rfp_t in rfp_steps,
      rfp_u in 1..(1 + bool2int(rfp_t >= 8))
]);

array[rfp_events] of int: rfp_event_step = [
    rfp_t
    | rfp_t in rfp_steps,
      rfp_u in 1..(1 + bool2int(rfp_t >= 8))
];

array[rfp_events] of bool: rfp_event_reset = [
    rfp_u = 2
    | rfp_t in rfp_steps,
      rfp_u in 1..(1 + bool2int(rfp_t >= 8))
];

array[rfp_events] of var int: rfp_event_key = [
    rfp_pizza[rfp_event_step[rfp_e]] | rfp_e in rfp_events
];

array[rfp_events] of var bool: rfp_event_active = [
    if rfp_event_reset[rfp_e] then
        rfp_added[rfp_event_step[rfp_e]] = 8
    else
        true
    endif
    | rfp_e in rfp_events
];

array[rfp_events] of var int: rfp_event_value = [
    if rfp_event_reset[rfp_e] then
        0
    else
        rfp_added[rfp_event_step[rfp_e]]
    endif
    | rfp_e in rfp_events
];

constraint forall(rfp_t in rfp_steps)(
    rfp_pizza[rfp_t] = rfp_choice[rfp_t]
);

constraint forall(rfp_t in rfp_resetsteps)(
    rfp_after[rfp_t] = rfp_added[rfp_t]
);

constraint forall(rfp_t in rfp_beforesteps)(
    rfp_lookup(
        rfp_pizza[rfp_t],
        [rfp_k | rfp_k in rfp_allowed[rfp_t]] ++
        [rfp_event_key[rfp_e]
         | rfp_e in rfp_events where rfp_event_step[rfp_e] < rfp_t],
        [true | rfp_k in rfp_allowed[rfp_t]] ++
        [rfp_event_active[rfp_e]
         | rfp_e in rfp_events where rfp_event_step[rfp_e] < rfp_t],
        [0 | rfp_k in rfp_allowed[rfp_t]] ++
        [rfp_event_value[rfp_e]
         | rfp_e in rfp_events where rfp_event_step[rfp_e] < rfp_t],
        false,
        rfp_before_index[rfp_t],
        rfp_before[rfp_t]
    )
);

constraint forall(rfp_t in rfp_fullsteps)(
    rfp_lookup(
        rfp_pizza[rfp_t],
        [rfp_k | rfp_k in rfp_allowed[rfp_t]] ++
        [rfp_pizza[rfp_j] | rfp_j in rfp_resetsteps where rfp_j < rfp_t] ++
        [rfp_pizza[rfp_t]],
        [true | rfp_k in rfp_allowed[rfp_t]] ++
        [rfp_added[rfp_j] = 8
         | rfp_j in rfp_resetsteps where rfp_j < rfp_t] ++
        [true],
        [0 | rfp_k in rfp_allowed[rfp_t]] ++
        [rfp_full_added[rfp_j]
         | rfp_j in rfp_resetsteps where rfp_j < rfp_t] ++
        [rfp_t - 8],
        true,
        rfp_full_before_index[rfp_t],
        rfp_full_before[rfp_t]
    ) /\
    ((rfp_added[rfp_t] = 8) ->
        rfp_full_before_index[rfp_t] <
        card(rfp_allowed[rfp_t]) +
        card({rfp_j | rfp_j in rfp_resetsteps where rfp_j < rfp_t}) + 1)
);

array[rfp_types] of var int: rfp_final_slices = [
    numSlices_3722, numSlices_3788, numSlices_3854, numSlices_3920,
    numSlices_3986, numSlices_4052, numSlices_4118, numSlices_4184
];

array[rfp_types] of var int: rfp_final_slices_index = [
    inumSlices_3722, inumSlices_3788, inumSlices_3854, inumSlices_3920,
    inumSlices_3986, inumSlices_4052, inumSlices_4118, inumSlices_4184
];

array[rfp_types] of var int: rfp_loose_slices = [
    numSlices_3726, numSlices_3792, numSlices_3858, numSlices_3924,
    numSlices_3990, numSlices_4056, numSlices_4122, numSlices_4188
];

array[rfp_types] of var int: rfp_loose_slices_index = [
    inumSlices_3726, inumSlices_3792, inumSlices_3858, inumSlices_3924,
    inumSlices_3990, inumSlices_4056, inumSlices_4122, inumSlices_4188
];

array[rfp_fulltypes] of var int: rfp_final_full =
    array1d(rfp_fulltypes, [
        fullPizzas_3783, fullPizzas_3849, fullPizzas_3915,
        fullPizzas_3981, fullPizzas_4047, fullPizzas_4113,
        fullPizzas_4179
    ]);

array[rfp_fulltypes] of var int: rfp_final_full_index =
    array1d(rfp_fulltypes, [
        ifullPizzas_3783, ifullPizzas_3849, ifullPizzas_3915,
        ifullPizzas_3981, ifullPizzas_4047, ifullPizzas_4113,
        ifullPizzas_4179
    ]);

array[rfp_types] of int: rfp_final_event_count = [
    sum(rfp_e in rfp_events)(
        bool2int(rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]])
    )
    | rfp_k in rfp_types
];

constraint forall(rfp_k in rfp_types)(
    rfp_lookup(
        rfp_type[rfp_k],
        [rfp_type[rfp_k]] ++
        [rfp_event_key[rfp_e]
         | rfp_e in rfp_events
         where rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]]],
        [true] ++
        [rfp_event_active[rfp_e]
         | rfp_e in rfp_events
         where rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]]],
        [0] ++
        [rfp_event_value[rfp_e]
         | rfp_e in rfp_events
         where rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]]],
        false,
        rfp_final_slices_index[rfp_k],
        rfp_final_slices[rfp_k]
    ) /\
    rfp_lookup(
        rfp_type[rfp_k],
        [rfp_type[rfp_k]] ++
        [rfp_event_key[rfp_e]
         | rfp_e in rfp_events
         where rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]]] ++
        [rfp_type[rfp_k]],
        [true] ++
        [rfp_event_active[rfp_e]
         | rfp_e in rfp_events
         where rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]]] ++
        [true],
        [0] ++
        [rfp_event_value[rfp_e]
         | rfp_e in rfp_events
         where rfp_type[rfp_k] in rfp_allowed[rfp_event_step[rfp_e]]] ++
        [rfp_slice_cap[rfp_k]],
        true,
        rfp_loose_slices_index[rfp_k],
        rfp_loose_slices[rfp_k]
    ) /\
    ((rfp_final_slices[rfp_k] > 0) ->
        rfp_loose_slices_index[rfp_k] < rfp_final_event_count[rfp_k] + 2)
);

constraint forall(rfp_k in rfp_fulltypes)(
    rfp_lookup(
        rfp_type[rfp_k],
        [rfp_type[rfp_k]] ++
        [rfp_pizza[rfp_t]
         | rfp_t in rfp_resetsteps
         where rfp_type[rfp_k] in rfp_allowed[rfp_t]],
        [true] ++
        [rfp_added[rfp_t] = 8
         | rfp_t in rfp_resetsteps
         where rfp_type[rfp_k] in rfp_allowed[rfp_t]],
        [0] ++
        [rfp_full_added[rfp_t]
         | rfp_t in rfp_resetsteps
         where rfp_type[rfp_k] in rfp_allowed[rfp_t]],
        false,
        rfp_final_full_index[rfp_k],
        rfp_final_full[rfp_k]
    )
);

array[rfp_types] of var int: rfp_pre_slice_cost = [
    slicesCost_3731, slicesCost_3797, slicesCost_3863, slicesCost_3929,
    slicesCost_3995, slicesCost_4061, slicesCost_4127, slicesCost_4193
];

array[rfp_types] of var int: rfp_pre_slice_index = [
    islicesCost_3731, islicesCost_3797, islicesCost_3863, islicesCost_3929,
    islicesCost_3995, islicesCost_4061, islicesCost_4127, islicesCost_4193
];

array[rfp_types] of var int: rfp_slice_cost = [
    slicesCost_3739, slicesCost_3805, slicesCost_3871, slicesCost_3937,
    slicesCost_4003, slicesCost_4069, slicesCost_4135, slicesCost_4201
];

array[rfp_types] of var int: rfp_slice_index = [
    islicesCost_3739, islicesCost_3805, islicesCost_3871, islicesCost_3937,
    islicesCost_4003, islicesCost_4069, islicesCost_4135, islicesCost_4201
];

array[rfp_fulltypes] of var int: rfp_pre_full_cost =
    array1d(rfp_fulltypes, [
        cost_3804, cost_3870, cost_3936, cost_4002,
        cost_4068, cost_4134, cost_4200
    ]);

array[rfp_fulltypes] of var int: rfp_pre_full_index =
    array1d(rfp_fulltypes, [
        icost_3804, icost_3870, icost_3936, icost_4002,
        icost_4068, icost_4134, icost_4200
    ]);

array[rfp_types] of var int: rfp_cost = [
    cost_3743, cost_3809, cost_3875, cost_3941,
    cost_4007, cost_4073, cost_4139, cost_4205
];

array[rfp_types] of var int: rfp_cost_index = [
    icost_3743, icost_3809, icost_3875, icost_3941,
    icost_4007, icost_4073, icost_4139, icost_4205
];

array[rfp_types] of var int: rfp_return_cost = [
    ret_getCost_3747, ret_getCost_3813, ret_getCost_3879, ret_getCost_3945,
    ret_getCost_4011, ret_getCost_4077, ret_getCost_4143, ret_getCost_4209
];

array[rfp_types] of var int: rfp_total_cost = [
    totalcost_3772, totalcost_3838, totalcost_3904, totalcost_3970,
    totalcost_4036, totalcost_4102, totalcost_4168, totalcost_4214
];

array[rfp_types] of var bool: rfp_positive = [
    rfp_final_slices[rfp_k] > 0 | rfp_k in rfp_types
];

array[rfp_types] of var int: rfp_raw_slice_cost = [
    rfp_slice_price[rfp_k] * rfp_loose_slices[rfp_k]
    | rfp_k in rfp_types
];

constraint forall(rfp_k in rfp_types)(
    rfp_pre_slice_cost[rfp_k] =
        if rfp_pre_slice_index[rfp_k] = 1 then
            rfp_raw_slice_cost[rfp_k]
        else
            rfp_slice_price[rfp_k] * rfp_slice_cap[rfp_k]
        endif /\
    (rfp_positive[rfp_k] -> rfp_pre_slice_index[rfp_k] = 1)
);

constraint forall(rfp_k in rfp_types)(
    ((rfp_slice_index[rfp_k] = 1) ->
        not (rfp_positive[rfp_k] /\
             rfp_pre_slice_cost[rfp_k] > rfp_whole_price[rfp_k])) /\
    ((rfp_slice_index[rfp_k] = 2) ->
        (rfp_positive[rfp_k] /\
         rfp_pre_slice_cost[rfp_k] > rfp_whole_price[rfp_k])) /\
    (rfp_positive[rfp_k] -> rfp_slice_index[rfp_k] < 3) /\
    rfp_slice_cost[rfp_k] =
        if rfp_slice_index[rfp_k] = 1 then
            rfp_raw_slice_cost[rfp_k]
        elseif rfp_slice_index[rfp_k] = 2 then
            rfp_whole_price[rfp_k]
        else
            rfp_slice_price[rfp_k] * rfp_slice_cap[rfp_k]
        endif
);

constraint forall(rfp_k in rfp_fulltypes)(
    rfp_pre_full_cost[rfp_k] =
        if rfp_pre_full_index[rfp_k] = 1 then
            rfp_whole_price[rfp_k] * rfp_final_full[rfp_k]
        else
            8 * rfp_whole_price[rfp_k]
        endif /\
    (rfp_positive[rfp_k] -> rfp_pre_full_index[rfp_k] = 1)
);

constraint forall(rfp_k in rfp_types)(
    rfp_cost_index[rfp_k] = 1 + bool2int(rfp_positive[rfp_k])
);

constraint cost_3743 =
    if rfp_positive[min(rfp_types)] then slicesCost_3739 else 0 endif;

constraint forall(rfp_k in rfp_fulltypes)(
    rfp_cost[rfp_k] =
        if rfp_positive[rfp_k] then
            rfp_pre_full_cost[rfp_k] + rfp_slice_cost[rfp_k]
        else
            rfp_whole_price[rfp_k] * rfp_final_full[rfp_k]
        endif
);

constraint forall(rfp_k in rfp_types)(
    rfp_return_cost[rfp_k] = rfp_cost[rfp_k] /\
    rfp_total_cost[rfp_k] =
        sum(rfp_j in rfp_types where rfp_j <= rfp_k)(
            rfp_return_cost[rfp_j]
        )
);

constraint ret_totalCost_4218 = totalcost_4214;
constraint objective = ret_totalCost_4218;

array[rfp_steps, rfp_types] of var 0..1: rfp_assignment;

constraint forall(rfp_t in rfp_steps)(
    sum(rfp_k in rfp_types)(rfp_assignment[rfp_t,rfp_k]) = 1 /\
    rfp_choice[rfp_t] =
        sum(rfp_k in rfp_types)(
            rfp_type[rfp_k] * rfp_assignment[rfp_t,rfp_k]
        )
);

constraint forall(rfp_t in rfp_steps, rfp_k in rfp_types
                  where not (rfp_type[rfp_k] in rfp_allowed[rfp_t]))(
    rfp_assignment[rfp_t,rfp_k] = 0
);

array[rfp_types, rfp_counts] of int: rfp_price =
    array2d(rfp_types, rfp_counts, [
        rfp_whole_price[rfp_k] * (rfp_n div 8) +
        min(rfp_slice_price[rfp_k] * (rfp_n mod 8),
            rfp_whole_price[rfp_k])
        | rfp_k in rfp_types, rfp_n in rfp_counts
    ]);

array[rfp_types, rfp_counts] of var 0..1: rfp_count_selected;

constraint forall(rfp_k in rfp_types)(
    sum(rfp_n in rfp_counts)(rfp_count_selected[rfp_k,rfp_n]) = 1 /\
    sum(rfp_n in rfp_counts)(
        rfp_n * rfp_count_selected[rfp_k,rfp_n]
    ) =
    sum(rfp_t in rfp_steps)(rfp_assignment[rfp_t,rfp_k]) /\
    rfp_return_cost[rfp_k] =
    sum(rfp_n in rfp_counts)(
        rfp_price[rfp_k,rfp_n] * rfp_count_selected[rfp_k,rfp_n]
    ) /\
    rfp_final_slices[rfp_k] =
    sum(rfp_n in rfp_counts)(
        (rfp_n mod 8) * rfp_count_selected[rfp_k,rfp_n]
    )
);

constraint forall(rfp_k in rfp_fulltypes)(
    rfp_final_full[rfp_k] =
        sum(rfp_n in rfp_counts)(
            (rfp_n div 8) * rfp_count_selected[rfp_k,rfp_n]
        )
);

constraint forall(rfp_k in rfp_types, rfp_n in rfp_counts
                  where rfp_n >
                    sum(rfp_t in rfp_steps)(
                        bool2int(rfp_type[rfp_k] in rfp_allowed[rfp_t])
                    ))(
    rfp_count_selected[rfp_k,rfp_n] = 0
);

int: rfp_relaxed_lower_bound =
    min([
        min(rfp_whole_price) * rfp_p +
        min(rfp_slice_price) * max(0, card(rfp_steps) - 8 * rfp_p)
        | rfp_p in 0..((card(rfp_steps) + 7) div 8)
    ]);

int: rfp_incumbent_upper_bound =
    min([
        rfp_price[rfp_k,card(rfp_steps)]
        | rfp_k in rfp_types
        where forall(rfp_t in rfp_steps)(
            rfp_type[rfp_k] in rfp_allowed[rfp_t]
        )
    ]);

constraint objective >= rfp_relaxed_lower_bound;
constraint objective <= rfp_incumbent_upper_bound;

solve minimize objective;
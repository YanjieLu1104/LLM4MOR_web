include "cumulative.mzn";
include "diffn.mzn";

int: nV;
int: nS;
set of int: VESSELS = 1..nV;
set of int: PILES = 1..nS;

int: stackbefore;
int: tMaxBetwRecl;
int: discrStackStart;
int: discrPadPos;
int: mulTonnage;
int: mulPileLen;
int: hourDiscr;

array[VESSELS] of int: eta;
array[PILES] of int: whichV;
array[PILES] of int: dS__;
array[PILES] of int: dR;

int: H;
int: T;
int: stCap;
int: reclN;
int: delayMax;
int: sum_delay_max;

set of int: StackStartTimes =
    {o * discrStackStart | o in 0..(T div discrStackStart)};
set of int: PadPos =
    {o * discrPadPos | o in 0..(H div discrPadPos)};

array[VESSELS] of int: dRtotal =
    [sum(o in PILES where whichV[o] = v)(dR[o]) | v in VESSELS];
array[PILES] of int: dS =
    [dS__[o] * discrStackStart | o in PILES];
array[PILES] of int: stTonnagePerHour =
    [dR[o] * mulTonnage div dS[o] | o in PILES];
array[PILES] of int: len =
    [dR[o] * mulPileLen div hourDiscr | o in PILES];
array[PILES] of int: len__ =
    [(len[o] + discrPadPos - 1) div discrPadPos | o in PILES];

array[VESSELS] of PILES: whichPlast =
    [max(o in PILES where whichV[o] = v)(o) | v in VESSELS];
array[PILES] of int: ones = [1 | o in PILES];

array[PILES] of var 0..T div discrStackStart: tS__;
array[PILES] of var 0..T: tS =
    [tS__[o] * discrStackStart | o in PILES];
array[PILES] of var 0..(H div discrPadPos): h__;
array[PILES] of var 0..T: tR;
array[PILES] of var 0..T div discrStackStart: dT__;
array[PILES] of var 0..T: dTotal =
    [dT__[o] * discrStackStart | o in PILES];
array[VESSELS] of var 0..T: tReady =
    [tR[whichPlast[v]] + dR[whichPlast[v]] | v in VESSELS];

var 0..sum_delay_max: sum_delay;

int: comb_min = min([lb_array(tR), lb_array(tS__), lb_array(h__)]);
int: comb_max = max([ub_array(tR), ub_array(tS__), ub_array(h__)]);

array[1..nS*3] of var comb_min..comb_max: comb =
    [[tR[i], tS__[i], h__[i]][k] | i in PILES, k in 1..3];

array[index_set(dR)] of int: cargo_rf_prefix =
    array1d(
        index_set(dR),
        [
            sum(cargo_rf_q in index_set(dR) where cargo_rf_q < cargo_rf_p)
                (dR[cargo_rf_q])
            | cargo_rf_p in index_set(dR)
        ]
    );

array[index_set(dR)] of int: cargo_rf_release =
    array1d(
        index_set(dR),
        [
            if discrStackStart > 0 then
                max([
                    0,
                    eta[whichV[cargo_rf_p]],
                    discrStackStart *
                    (
                        dS__[cargo_rf_p] +
                        (
                            (
                                max(
                                    0,
                                    eta[whichV[cargo_rf_p]] -
                                    stackbefore * discrStackStart
                                ) + discrStackStart - 1
                            ) div discrStackStart
                        )
                    )
                ])
            else
                max(0, eta[whichV[cargo_rf_p]])
            endif
            | cargo_rf_p in index_set(dR)
        ]
    );

array[index_set(dR)] of int: cargo_rf_deadline =
    array1d(
        index_set(dR),
        [
            if cargo_rf_p = whichPlast[whichV[cargo_rf_p]] then
                min([
                    T,
                    T - dR[cargo_rf_p],
                    eta[whichV[cargo_rf_p]] +
                    dRtotal[whichV[cargo_rf_p]] +
                    delayMax - dR[cargo_rf_p]
                ])
            else
                T
            endif
            | cargo_rf_p in index_set(dR)
        ]
    );

array[index_set(dR)] of int: cargo_rf_reclaim_lb =
    array1d(
        index_set(dR),
        [
            max(
                cargo_rf_a in index_set(dR)
                where cargo_rf_a <= cargo_rf_p /\
                    forall(cargo_rf_j in cargo_rf_a..(cargo_rf_p - 1))
                        (whichV[cargo_rf_j] = whichV[cargo_rf_j + 1])
            ) (
                cargo_rf_release[cargo_rf_a] +
                cargo_rf_prefix[cargo_rf_p] -
                cargo_rf_prefix[cargo_rf_a]
            )
            | cargo_rf_p in index_set(dR)
        ]
    );

array[index_set(dR)] of int: cargo_rf_reclaim_ub =
    array1d(
        index_set(dR),
        [
            min(
                cargo_rf_b in index_set(dR)
                where cargo_rf_b >= cargo_rf_p /\
                    forall(cargo_rf_j in cargo_rf_p..(cargo_rf_b - 1))
                        (whichV[cargo_rf_j] = whichV[cargo_rf_j + 1])
            ) (
                cargo_rf_deadline[cargo_rf_b] -
                cargo_rf_prefix[cargo_rf_b] +
                cargo_rf_prefix[cargo_rf_p]
            )
            | cargo_rf_p in index_set(dR)
        ]
    );

constraint forall(o in PILES)(
    dTotal[o] >= tR[o] + dR[o] - tS[o]
);

constraint forall(v in VESSELS)(
    tS__[whichPlast[v]] + dT__[whichPlast[v]] <=
    (T + discrStackStart - 1) div discrStackStart
);

constraint forall(o in PILES)(
    tR[o] >= eta[whichV[o]]
);

constraint forall(o in PILES)(
    tS[o] >= eta[whichV[o]] - stackbefore * discrStackStart
);

constraint forall(a, b in PILES where whichV[a] = whichV[b] /\ a + 1 = b)(
    tR[b] <= tR[a] + dR[a] + tMaxBetwRecl
);

constraint forall(o in PILES)(
    if discrStackStart > 0 then
        tS[o] + dS[o] <= tR[o]
    else
        tS__[o] + dS__[o] <= tR[o] div discrStackStart
    endif
);

constraint forall(o in PILES)(
    h__[o] + len__[o] <= H div discrPadPos
);

constraint forall(a, b in PILES where whichV[a] = whichV[b] /\ a + 1 = b)(
    tR[a] + dR[a] <= tR[b]
);

constraint forall(cargo_rf_p in index_set(dR))(
    tR[cargo_rf_p] >= cargo_rf_reclaim_lb[cargo_rf_p] /\
    tR[cargo_rf_p] <= cargo_rf_reclaim_ub[cargo_rf_p]
);

constraint
    if discrStackStart > 0 then
        forall(cargo_rf_p in index_set(dR) where dR[cargo_rf_p] >= 0)(
            dT__[cargo_rf_p] >=
            dS__[cargo_rf_p] +
            (dR[cargo_rf_p] + discrStackStart - 1) div discrStackStart
        )
    else
        true
    endif;

constraint sum_delay =
    sum(v in VESSELS)(tReady[v] - eta[v] - dRtotal[v]);

constraint forall(v in VESSELS)(
    tReady[v] - eta[v] - dRtotal[v] <= delayMax
);

constraint diffn(tS__, h__, dT__, len__);

constraint cumulative(tS__, dT__, len__, H div discrPadPos);
constraint cumulative(tS__, dS__, stTonnagePerHour, stCap);
constraint cumulative(tR, dR, ones, reclN);

constraint forall(
    cargo_rf_a, cargo_rf_b in index_set(dR)
    where cargo_rf_a < cargo_rf_b /\
        len__[cargo_rf_a] >= 0 /\
        len__[cargo_rf_b] >= 0 /\
        len__[cargo_rf_a] + len__[cargo_rf_b] > H div discrPadPos
)(
    tS__[cargo_rf_a] + dT__[cargo_rf_a] <= tS__[cargo_rf_b] \/
    tS__[cargo_rf_b] + dT__[cargo_rf_b] <= tS__[cargo_rf_a]
);

constraint
    if forall(cargo_rf_p in index_set(dR))(
        dS__[cargo_rf_p] >= 0 /\
        stTonnagePerHour[cargo_rf_p] >= 0
    ) then
        forall(
            cargo_rf_a, cargo_rf_b in index_set(dR)
            where cargo_rf_a < cargo_rf_b /\
                dS__[cargo_rf_a] > 0 /\
                dS__[cargo_rf_b] > 0 /\
                stTonnagePerHour[cargo_rf_a] +
                stTonnagePerHour[cargo_rf_b] > stCap
        )(
            tS__[cargo_rf_a] + dS__[cargo_rf_a] <= tS__[cargo_rf_b] \/
            tS__[cargo_rf_b] + dS__[cargo_rf_b] <= tS__[cargo_rf_a]
        )
    else
        true
    endif;

int: obj_min =
    sum(v in 5..nV-5)(lb(tReady[v]) - eta[v] - dRtotal[v]);
int: obj_max =
    sum(v in 5..nV-5)(ub(tReady[v]) - eta[v] - dRtotal[v]);
var obj_min..obj_max: objective;

constraint objective =
    sum(v in 5..nV-5)(tReady[v] - eta[v] - dRtotal[v]);

solve minimize objective;

output [
    "objective = ", show(objective),
    ";\nH      = ", show(H),
    ";\nT      = ", show(T),
    ";\ntS     = ", show(tS),
    ";\ntR     = ", show(tR),
    ";\nh      = ", show(h__),
    ";\ntReady = ",
    show([tR[whichPlast[v]] + dR[whichPlast[v]] | v in VESSELS]),
    ";\ndelay  = ",
    show([
        tR[whichPlast[v]] + dR[whichPlast[v]] - eta[v] - dRtotal[v]
        | v in VESSELS
    ]),
    ";\ndTotal = ", show(dTotal),
    ";\nlength = ", show(len),
    ";\nave_delay = ", show(sum_delay div nV),
    "\n"
];
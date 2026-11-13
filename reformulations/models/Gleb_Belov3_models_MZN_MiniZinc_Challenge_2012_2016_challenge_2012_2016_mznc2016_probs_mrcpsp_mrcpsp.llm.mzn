include "cumulative.mzn";
include "element.mzn";

int: n_res;
int: nb_res = n_res;

int: n_tasks;
int: nb_act = n_tasks;

int: n_opt;
int: nb_mod = n_opt;

array[Act] of set of Mod: modes;
array[Act] of set of Mod: mode = modes;

array[Mod] of int: dur;
array[Mod] of int: mdur = dur;

array[Res, Mod] of int: rreq;
array[Res, Mod] of int: mrreq = rreq;

array[Mod] of Act: mact =
    [sum(i in Act where m in mode[i])(i) | m in Mod];

set of int: Res = 1..nb_res;
array[Res] of int: rcap;
array[Res] of int: rtype;

set of int: RRes = {k | k in Res where rtype[k] = 1};
set of int: NRes = {k | k in Res where rtype[k] = 2};

set of int: Act = 1..nb_act;
set of int: Mod = 1..nb_mod;

array[Act] of set of Act: succ;

int: min_mrreq = min(k in Res, m in Mod)(mrreq[k,m]);
int: max_mrreq = max(k in Res, m in Mod)(mrreq[k,m]);

int: UB = sum(i in Act)(max([mdur[m] | m in mode[i]]));

array[index_set_1of2(mrreq), index_set(mode)] of int:
    rf2026_min_req =
    array2d(
        index_set_1of2(mrreq),
        index_set(mode),
        [
            min(m in mode[i])(mrreq[k,m])
            | k in index_set_1of2(mrreq), i in index_set(mode)
        ]
    );

array[Mod] of var bool: mrun;
array[Act] of var 0..UB: start;

array[Act] of var min(mdur)..max(mdur): adur =
    [
        let {
            var min([mdur[m] | m in mode[i]])..
                max([mdur[m] | m in mode[i]]): x
        } in x
        | i in Act
    ];

array[Res,Act] of var min_mrreq..max_mrreq: arreq =
    array2d(
        Res,
        Act,
        [
            let {
                var min([mrreq[k,m] | m in mode[i]])..
                    max([mrreq[k,m] | m in mode[i]]): x
            } in x
            | k in Res, i in Act
        ]
    );

var 0..UB: objective;

constraint forall(i in Act)(
    sum(m in mode[i])(bool2int(mrun[m])) = 1
);

constraint forall(i in Act)(
    adur[i] =
        sum(m in mode[i])(mdur[m] * bool2int(mrun[m]))
);

constraint forall(k in Res, i in Act)(
    arreq[k,i] =
        sum(m in mode[i])(mrreq[k,m] * bool2int(mrun[m]))
);

constraint forall(
    i in Act,
    m in mode[i]
    where exists(k in NRes)(
        mrreq[k,m]
        + sum(j in Act where j != i)(rf2026_min_req[k,j])
        > rcap[k]
    )
)(
    not mrun[m]
);

constraint forall(i in Act, j in succ[i])(
    start[i] + adur[i] <= start[j]
);

constraint forall(k in RRes)(
    cumulative(
        start,
        adur,
        [arreq[k,i] | i in Act],
        rcap[k]
    )
);

constraint forall(k in NRes)(
    sum(i in Act)(arreq[k,i]) <= rcap[k]
);

constraint redundant_constraint(
    forall(i in Act where succ[i] = {})(
        start[i] + adur[i] <= objective
    )
);

constraint objective =
    max(i in Act where succ[i] = {})(start[i] + adur[i]);

bool: opt_noc_half = false;

function bool: are_act_disjunct(int: i, int: j) =
    forall(mi in mode[i], mj in mode[j])(
        are_mod_disjunct(mi, mj)
    );

function bool: are_mod_disjunct(int: mi, int: mj) =
    exists(k in RRes)(
        mrreq[k,mi] + mrreq[k,mj] > rcap[k]
    );

function bool: can_act_be_disjunct(int: i, int: j) =
    exists(k in RRes)(
        can_act_be_disjunct_on_rres(i, j, k)
    );

function bool: can_act_be_disjunct_on_rres(
    int: i,
    int: j,
    int: k
) =
    exists(mi in mode[i], mj in mode[j])(
        mrreq[k,mi] + mrreq[k,mj] > rcap[k]
    );

predicate post_noc_disj(int: i, int: j) =
    if opt_noc_half then
        let {var bool: b} in (
            (b -> start[i] + adur[i] <= start[j])
            \/
            (not b -> start[j] + adur[j] <= start[i])
        )
    else
        (
            start[i] + adur[i] <= start[j]
            \/
            start[j] + adur[j] <= start[i]
        )
    endif;

predicate post_noc_mode(int: i, int: j) =
    forall(
        mi in mode[i],
        mj in mode[j]
        where are_mod_disjunct(mi, mj)
    )(
        if opt_noc_half then
            let {var bool: b} in (
                (
                    (mrun[mi] /\ mrun[mj]) ->
                    (
                        (b -> start[i] + mdur[mi] <= start[j])
                        \/
                        (not b -> start[j] + mdur[mj] <= start[i])
                    )
                )
                /\
                (not(mrun[mi] /\ mrun[mj]) -> b)
            )
        else
            (
                (mrun[mi] /\ mrun[mj]) ->
                (
                    start[i] + mdur[mi] <= start[j]
                    \/
                    start[j] + mdur[mj] <= start[i]
                )
            )
        endif
    );

predicate post_noc_rres(int: i, int: j) =
    forall(
        k in RRes
        where can_act_be_disjunct_on_rres(i, j, k)
    )(
        if opt_noc_half then
            let {var bool: b} in (
                (
                    (arreq[k,i] + arreq[k,j] > rcap[k]) ->
                    (
                        (b -> start[i] + adur[i] <= start[j])
                        \/
                        (not b -> start[j] + adur[j] <= start[i])
                    )
                )
                /\
                (not(arreq[k,i] + arreq[k,j] <= rcap[k]) -> b)
            )
        else
            (
                (arreq[k,i] + arreq[k,j] > rcap[k]) ->
                (
                    start[i] + adur[i] <= start[j]
                    \/
                    start[j] + adur[j] <= start[i]
                )
            )
        endif
    );

predicate post_noc_cumu(int: i, int: j) =
    forall(
        k in RRes
        where can_act_be_disjunct_on_rres(i, j, k)
    )(
        cumulative(
            [start[i], start[j]],
            [adur[i], adur[j]],
            [arreq[k,i], arreq[k,j]],
            rcap[k]
        )
    );

constraint redundant_constraint(
    forall(
        i, j in Act
        where i < j /\ can_act_be_disjunct(i, j)
    )(
        if are_act_disjunct(i, j) then
            post_noc_disj(i, j)
        else
            post_noc_rres(i, j)
        endif
    )
);

ann: durThenStartThenMode = seq_search([
    int_search(adur, smallest, indomain_min, complete),
    int_search(start, smallest, indomain_min, complete),
    bool_search(mrun, input_order, indomain_max, complete)
]);

solve
    :: durThenStartThenMode
    minimize objective;

output [
    "start = \(start);\n",
    "mrun = \(mrun);\n",
    "objective = \(objective);\n"
];
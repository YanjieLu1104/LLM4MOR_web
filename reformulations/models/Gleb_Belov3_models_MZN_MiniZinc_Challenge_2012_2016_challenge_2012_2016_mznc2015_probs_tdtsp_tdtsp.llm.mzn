include "inverse.mzn";

int: n;
set of int: VISIT = 1..n;
set of int: VISIT1 = 1..n+1;
array[VISIT] of int: D;

int: q;
set of int: PREC = 1..q;
array[PREC,1..2] of VISIT: prec;

int: steps;
int: l;
int: H = steps * l - 1;
set of int: TIME = 0..H;

int: r;
set of int: FORBID = 1..r;
array[FORBID] of VISIT: which;
array[FORBID,1..2] of TIME: interval;

array[VISIT1,VISIT1,0..steps] of int: T;

array[VISIT1] of var VISIT1: position;
array[VISIT1] of var VISIT1: next;
array[VISIT1] of var VISIT1: prev;
array[VISIT1] of var TIME: tvar;

var TIME: objective = tvar[n+1];

array[VISIT1] of var VISIT1: atposition;

array[index_set_3of3(T)] of int: td_ref_lower =
    array1d(
        index_set_3of3(T),
        [td_ref_k * l | td_ref_k in index_set_3of3(T)]
    );

array[index_set_3of3(T)] of int: td_ref_upper =
    array1d(
        index_set_3of3(T),
        [
            min(H, (td_ref_k + 1) * l - 1)
            | td_ref_k in index_set_3of3(T)
        ]
    );

array[index_set(D), index_set(tvar)] of var 0..1: td_ref_arc;

array[
    index_set(D),
    index_set(tvar),
    index_set_3of3(T)
] of var 0..1: td_ref_choice;

constraint n >= 1 /\ steps >= 1 /\ l >= 1;

constraint forall(td_ref_f in FORBID)(
    assert(
        interval[td_ref_f,1] <= interval[td_ref_f,2],
        "forbidden interval \(td_ref_f) is incorrect [\(interval[td_ref_f,1])..\(interval[td_ref_f,2])"
    )
);

constraint position[1] = 1;
constraint position[n+1] = n+1;
constraint tvar[1] = 0;
constraint prev[1] = n+1;
constraint next[n+1] = 1;

constraint forall(
    td_ref_i in index_set(D),
    td_ref_j in index_set(tvar),
    td_ref_k in index_set_3of3(T)
    where
        td_ref_j = 1
        \/ td_ref_j = td_ref_i
        \/ td_ref_lower[td_ref_k] > td_ref_upper[td_ref_k]
        \/ (td_ref_i = 1 /\ td_ref_k != 0)
        \/ td_ref_lower[td_ref_k]
           + D[td_ref_i]
           + T[td_ref_i,td_ref_j,td_ref_k] > H
        \/ exists(
            td_ref_f in FORBID
            where which[td_ref_f] = td_ref_i
        )(
            td_ref_lower[td_ref_k] + D[td_ref_i]
                > interval[td_ref_f,1]
            /\
            td_ref_upper[td_ref_k] < interval[td_ref_f,2]
        )
)(
    td_ref_choice[td_ref_i,td_ref_j,td_ref_k] = 0
);

constraint forall(
    td_ref_i in index_set(D),
    td_ref_j in index_set(tvar)
)(
    td_ref_arc[td_ref_i,td_ref_j] =
        sum(td_ref_k in index_set_3of3(T))(
            td_ref_choice[td_ref_i,td_ref_j,td_ref_k]
        )
);

constraint forall(td_ref_i in index_set(D))(
    sum(td_ref_j in index_set(tvar))(
        td_ref_arc[td_ref_i,td_ref_j]
    ) = 1
);

constraint forall(
    td_ref_j in index_set(tvar)
    where td_ref_j != 1
)(
    sum(td_ref_i in index_set(D))(
        td_ref_arc[td_ref_i,td_ref_j]
    ) = 1
);

constraint forall(td_ref_i in index_set(D))(
    next[td_ref_i] =
        sum(td_ref_j in index_set(tvar))(
            td_ref_j * td_ref_arc[td_ref_i,td_ref_j]
        )
);

constraint forall(
    td_ref_j in index_set(tvar)
    where td_ref_j != 1
)(
    prev[td_ref_j] =
        sum(td_ref_i in index_set(D))(
            td_ref_i * td_ref_arc[td_ref_i,td_ref_j]
        )
);

constraint forall(
    td_ref_i in index_set(D),
    td_ref_j in index_set(tvar)
    where td_ref_j != 1 /\ td_ref_j != td_ref_i
)(
    position[td_ref_j] >=
        position[td_ref_i] + 1
        - (n + 1) * (1 - td_ref_arc[td_ref_i,td_ref_j])
);

constraint forall(
    td_ref_i in index_set(D),
    td_ref_j in index_set(tvar)
    where td_ref_j != 1 /\ td_ref_j != td_ref_i
)(
    position[td_ref_j] <=
        position[td_ref_i] + 1
        + (n - 1) * (1 - td_ref_arc[td_ref_i,td_ref_j])
);

constraint forall(td_ref_i in index_set(D))(
    tvar[td_ref_i] >=
        sum(
            td_ref_j in index_set(tvar),
            td_ref_k in index_set_3of3(T)
        )(
            td_ref_lower[td_ref_k]
            * td_ref_choice[td_ref_i,td_ref_j,td_ref_k]
        )
);

constraint forall(td_ref_i in index_set(D))(
    tvar[td_ref_i] <=
        sum(
            td_ref_j in index_set(tvar),
            td_ref_k in index_set_3of3(T)
        )(
            td_ref_upper[td_ref_k]
            * td_ref_choice[td_ref_i,td_ref_j,td_ref_k]
        )
);

constraint forall(
    td_ref_i in index_set(D),
    td_ref_j in index_set(tvar)
    where td_ref_j != 1 /\ td_ref_j != td_ref_i
)(
    tvar[td_ref_j] >=
        tvar[td_ref_i]
        + sum(td_ref_k in index_set_3of3(T))(
            (D[td_ref_i] + T[td_ref_i,td_ref_j,td_ref_k])
            * td_ref_choice[td_ref_i,td_ref_j,td_ref_k]
        )
        - H * (1 - td_ref_arc[td_ref_i,td_ref_j])
);

constraint forall(td_ref_f in PREC)(
    tvar[prec[td_ref_f,1]] + D[prec[td_ref_f,1]]
        <= tvar[prec[td_ref_f,2]]
);

constraint forall(td_ref_f in FORBID)(
    tvar[which[td_ref_f]] + D[which[td_ref_f]]
        <= interval[td_ref_f,1]
    \/
    tvar[which[td_ref_f]] >= interval[td_ref_f,2]
);

constraint tvar[n+1] >=
    sum(D)
    + sum(
        td_ref_i in index_set(D),
        td_ref_j in index_set(tvar),
        td_ref_k in index_set_3of3(T)
    )(
        T[td_ref_i,td_ref_j,td_ref_k]
        * td_ref_choice[td_ref_i,td_ref_j,td_ref_k]
    );

constraint inverse(position, atposition);
constraint atposition[1] = 1;
constraint atposition[n+1] = n+1;

solve minimize objective;

output [
    "position = \(position);\n",
    "tvar = \(tvar);\n",
    "objective = \(objective);\n"
];
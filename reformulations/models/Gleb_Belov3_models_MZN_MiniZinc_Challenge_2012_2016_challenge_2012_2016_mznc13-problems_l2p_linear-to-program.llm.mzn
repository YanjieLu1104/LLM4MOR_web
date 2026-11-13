include "globals.mzn";

int: N;
int: M;
array[P] of int: coef;

int: Np;
int: Smax;
array[S,P] of int: RP;

set of int: P = 0..M-1;
set of int: R = M..M+N-1;
set of int: LN = M..M+N-1;
set of int: ALN = 0..M+N-1;

set of int: I =
    0..sum(i in R)(if i < M+Np then 2 else 1 endif)-1;

array[R] of set of int: Ii = array1d(R,
    [
        if i == M then
            0..1
        else
            sum(j in M..i-1)(if j < M+Np then 2 else 1 endif)
            ..
            sum(j in M..i)(if j < M+Np then 2 else 1 endif)-1
        endif
        | i in R
    ]
);

set of int: S = 1..Smax;

array[R] of var LN: line_o;
array[I] of var ALN: line_i;
var R: objective;

array[S] of int: x_O =
    array1d(S, [sum(p in P)(coef[p] * RP[s,p]) | s in S]);

int: max_x_ =
    2 * max(
        max(s in S, p in P)(abs(RP[s,p])),
        max(s in S)(abs(x_O[s]))
    );

array[S,R] of var -max_x_..max_x_: x_o;
array[S,I] of var -max_x_..max_x_: x_i;

set of int: rf_l2p_sources =
    index_set_2of2(RP) union index_set(line_o);

array[index_set(line_o), index_set(line_o)] of var bool:
    rf_l2p_position;

array[index_set(line_i), rf_l2p_sources] of var bool:
    rf_l2p_route;

array[index_set(line_o)] of var bool:
    rf_l2p_return;

constraint forall(rf_l2p_r in R)(
    sum(rf_l2p_l in R)(
        bool2int(rf_l2p_position[rf_l2p_r, rf_l2p_l])
    ) = 1
);

constraint forall(rf_l2p_l in R)(
    sum(rf_l2p_r in R)(
        bool2int(rf_l2p_position[rf_l2p_r, rf_l2p_l])
    ) = 1
);

constraint forall(rf_l2p_r in R)(
    line_o[rf_l2p_r] =
        sum(rf_l2p_l in R)(
            rf_l2p_l *
            bool2int(rf_l2p_position[rf_l2p_r, rf_l2p_l])
        )
);

constraint forall(i in R, j in Ii[i])(
    line_i[j] < line_o[i]
);

constraint
    forall(i in M..M+Np-2)(
        line_o[i] < line_o[i+1]
    )
    /\
    forall(i in M+Np..M+N-2)(
        line_o[i] < line_o[i+1]
    )
    /\
    forall(i in M..M+Np-1)(
        line_i[min(Ii[i])] <= line_i[min(Ii[i])+1]
    );

constraint forall(rf_l2p_j in I)(
    sum(rf_l2p_src in rf_l2p_sources)(
        bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_src])
    ) = 1
);

constraint forall(
    rf_l2p_owner in R,
    rf_l2p_j in Ii[rf_l2p_owner],
    rf_l2p_src in R
    where
        rf_l2p_src >= rf_l2p_owner /\
        ((rf_l2p_src < M+Np) = (rf_l2p_owner < M+Np))
)(
    not rf_l2p_route[rf_l2p_j, rf_l2p_src]
);

constraint forall(rf_l2p_j in I)(
    line_i[rf_l2p_j] >=
        sum(rf_l2p_p in P)(
            rf_l2p_p *
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_p])
        )
        +
        M * sum(rf_l2p_r in R)(
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_r])
        )
);

constraint forall(rf_l2p_j in I)(
    line_i[rf_l2p_j] <=
        sum(rf_l2p_p in P)(
            rf_l2p_p *
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_p])
        )
        +
        (M+N-1) * sum(rf_l2p_r in R)(
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_r])
        )
);

constraint forall(rf_l2p_j in I, rf_l2p_r in R)(
    rf_l2p_route[rf_l2p_j, rf_l2p_r] ->
        line_i[rf_l2p_j] = line_o[rf_l2p_r]
);

constraint forall(s in S, r in R)(
    if r < M+Np then
        x_o[s,r] =
            x_i[s,min(Ii[r])] + x_i[s,min(Ii[r])+1]
    else
        x_o[s,r] = -x_i[s,min(Ii[r])]
    endif
);

constraint forall(rf_l2p_s in S, rf_l2p_j in I)(
    x_i[rf_l2p_s, rf_l2p_j] >=
        sum(rf_l2p_p in P)(
            RP[rf_l2p_s, rf_l2p_p] *
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_p])
        )
        -
        max_x_ * sum(rf_l2p_r in R)(
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_r])
        )
);

constraint forall(rf_l2p_s in S, rf_l2p_j in I)(
    x_i[rf_l2p_s, rf_l2p_j] <=
        sum(rf_l2p_p in P)(
            RP[rf_l2p_s, rf_l2p_p] *
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_p])
        )
        +
        max_x_ * sum(rf_l2p_r in R)(
            bool2int(rf_l2p_route[rf_l2p_j, rf_l2p_r])
        )
);

constraint forall(
    rf_l2p_s in S,
    rf_l2p_j in I,
    rf_l2p_r in R
)(
    rf_l2p_route[rf_l2p_j, rf_l2p_r] ->
        x_i[rf_l2p_s, rf_l2p_j] = x_o[rf_l2p_s, rf_l2p_r]
);

constraint
    sum(rf_l2p_r in R)(
        bool2int(rf_l2p_return[rf_l2p_r])
    ) = 1;

constraint forall(rf_l2p_r in R)(
    rf_l2p_return[rf_l2p_r] ->
        objective = line_o[rf_l2p_r]
);

constraint forall(rf_l2p_s in S, rf_l2p_r in R)(
    rf_l2p_return[rf_l2p_r] ->
        x_o[rf_l2p_s, rf_l2p_r] = x_O[rf_l2p_s]
);

constraint forall(
    rf_l2p_r in R,
    rf_l2p_j in Ii[rf_l2p_r]
    where card(S) > 0
)(
    line_o[rf_l2p_r] > objective ->
        line_i[rf_l2p_j] = 0
);

solve minimize objective;

output
    ["line_o = array1d(R,", show(line_o), ");\n"] ++
    ["line_i = array1d(I,", show(line_i), ");\n"] ++
    ["objective = ", show(objective), ";\n\n"] ++
    [
        let {
            int: k = min(j in R where fix(line_o[j]) == i)(j)
        } in (
            "x" ++ show(i) ++ " = " ++
            if k < M+Np then
                if fix(line_i[min(Ii[k])]) < M then
                    "p"
                else
                    "x"
                endif
                ++ show(line_i[min(Ii[k])]) ++ " + " ++
                if fix(line_i[min(Ii[k])+1]) < M then
                    "p"
                else
                    "x"
                endif
                ++ show(line_i[min(Ii[k])+1])
            else
                "- " ++
                if fix(line_i[min(Ii[k])]) < M then
                    "p"
                else
                    "x"
                endif
                ++ show(line_i[min(Ii[k])])
            endif
            ++ "\n"
        )
        | i in R where i <= fix(objective)
    ] ++
    ["return x" ++ show(objective) ++ "\n"];
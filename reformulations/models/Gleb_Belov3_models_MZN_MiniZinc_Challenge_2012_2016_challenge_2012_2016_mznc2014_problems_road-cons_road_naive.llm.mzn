int: n;
set of int: N = 1..n;
array[N,N] of int: distance;
array[N,N] of int: cost;
int: budget;
int: M = 1000000;

array[N,N,N] of var 0..M: sp;
array[N,N] of var bool: construct;

array[N,N] of int: rfc_edge_lb =
    array2d(N, N, [
        if rfc_i = rfc_j then
            0
        elseif distance[min(rfc_i, rfc_j), max(rfc_i, rfc_j)] >= 0 /\
               distance[min(rfc_i, rfc_j), max(rfc_i, rfc_j)] <= M then
            distance[min(rfc_i, rfc_j), max(rfc_i, rfc_j)]
        else
            M
        endif
        | rfc_i in N, rfc_j in N
    ]);

array[N,N] of int: rfc_path_lb =
    array2d(N, N, [
        if rfc_i = rfc_j then
            0
        else
            let {
                int: rfc_a = min(rfc_i, rfc_j);
                int: rfc_b = max(rfc_i, rfc_j);
                set of int: rfc_internal = {
                    rfc_k | rfc_k in N
                    where rfc_k > rfc_a /\ rfc_k != rfc_b
                };
            } in
                if card(rfc_internal) = 0 then
                    rfc_edge_lb[rfc_a, rfc_b]
                else
                    min(
                        rfc_edge_lb[rfc_a, rfc_b],
                        min(rfc_k in rfc_internal)(
                            rfc_edge_lb[rfc_a, rfc_k]
                        ) +
                        min(rfc_k in rfc_internal)(
                            rfc_edge_lb[rfc_b, rfc_k]
                        )
                    )
                endif
        endif
        | rfc_i in N, rfc_j in N
    ]);

constraint forall(x in N)(
    construct[x,x] = false /\
    forall(s in N)(sp[x,x,s] = 0)
);

constraint forall(x,y in N where x < y)(
    sp[x,y,1] =
        distance[x,y] * bool2int(construct[x,y]) +
        M * (1 - bool2int(construct[x,y]))
);

constraint forall(x,y in N
    where x < y /\ (distance[x,y] < 0 \/ distance[x,y] > M)
)(
    construct[x,y] = false
);

constraint forall(x,y in N where x < y)(
    construct[y,x] = construct[x,y] /\
    forall(s in N)(sp[y,x,s] = sp[x,y,s])
);

constraint forall(x,y,s in N where x < y /\ s >= 2)(
    sp[x,y,s] >= rfc_path_lb[x,y]
);

constraint forall(x,y in N, s in 1..n-1
    where x < y /\ s < n-x
)(
    sp[x,y,s+1] =
        min(
            [sp[x,y,s]] ++
            [
                sp[x,z,s] +
                (if y < z then sp[y,z,s] else sp[z,y,s] endif)
                | z in N
                where x < z /\ y != z /\
                    (
                        if s = 1 then
                            rfc_edge_lb[x,z] + rfc_edge_lb[y,z] < M
                        else
                            rfc_path_lb[x,z] + rfc_path_lb[y,z] < M
                        endif
                    )
            ]
        )
);

constraint forall(x,y,s in N where x < y /\ s > n-x)(
    sp[x,y,s] = sp[x,y,n-x]
);

constraint sum(x,y in N where x < y)(
    cost[x,y] * bool2int(construct[x,y])
) <= budget;

int: obj_min = sum(x,y in N where x < y)(lb(sp[x,y,n]));
int: obj_max = sum(x,y in N where x < y)(ub(sp[x,y,n]));
var obj_min..obj_max: objective =
    sum(x,y in N where x < y)(sp[x,y,n]);

solve minimize objective;

output [
    "construct = array2d(", show(N), ", ", show(N), ", ",
    show(construct), ");\n",
    "constraint objective = ", show(objective), ";\n"
];
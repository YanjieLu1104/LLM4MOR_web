int: diameter;
bool: isDiameterOdd = (diameter mod 2 = 1);
int: nbV;
int: nbE;
set of int: nodes = 1..nbV;
set of int: edges = 1..nbE;

array [edges,1..2] of nodes: en;
array [nodes,edges] of bool: adj;
array [edges,nodes] of bool: endnodes;
array [edges] of int: ws;
int: radius;

array [edges] of var bool: es;
var 0..sum(ws): objective;
var 1..max(nbV, nbE): root;
array [nodes] of var 0..radius: h;
array [nodes] of var nodes: p;

set of int: dcmst_rf_root_indices =
    if isDiameterOdd then index_set(es) else index_set(h) endif;

array [dcmst_rf_root_indices] of var bool: dcmst_rf_root_pick;
array [index_set(p),index_set(p)] of var bool: dcmst_rf_parent_pick;
array [index_set(h)] of var bool: dcmst_rf_centre;

constraint objective =
    sum(dcmst_rf_e in edges)(
        bool2int(es[dcmst_rf_e]) * ws[dcmst_rf_e]
    );

constraint
    sum(dcmst_rf_e in edges)(bool2int(es[dcmst_rf_e])) = nbV - 1;

constraint
    sum(dcmst_rf_r in dcmst_rf_root_indices)(
        bool2int(dcmst_rf_root_pick[dcmst_rf_r])
    ) = 1;

constraint root =
    sum(dcmst_rf_r in dcmst_rf_root_indices)(
        dcmst_rf_r * bool2int(dcmst_rf_root_pick[dcmst_rf_r])
    );

constraint forall(dcmst_rf_n in index_set(p))(
    sum(dcmst_rf_k in index_set(p))(
        bool2int(dcmst_rf_parent_pick[dcmst_rf_n,dcmst_rf_k])
    ) = 1
);

constraint forall(dcmst_rf_n in index_set(p))(
    p[dcmst_rf_n] =
    sum(dcmst_rf_k in index_set(p))(
        dcmst_rf_k *
        bool2int(dcmst_rf_parent_pick[dcmst_rf_n,dcmst_rf_k])
    )
);

constraint
    if isDiameterOdd then
        forall(dcmst_rf_n in index_set(h))(
            bool2int(dcmst_rf_centre[dcmst_rf_n]) =
            sum(dcmst_rf_r in dcmst_rf_root_indices
                where en[dcmst_rf_r,1] = dcmst_rf_n \/
                      en[dcmst_rf_r,2] = dcmst_rf_n)(
                bool2int(dcmst_rf_root_pick[dcmst_rf_r])
            )
        )
        /\
        symmetry_breaking_constraint(
            forall(dcmst_rf_r in dcmst_rf_root_indices
                where en[dcmst_rf_r,1] >= en[dcmst_rf_r,2])(
                not dcmst_rf_root_pick[dcmst_rf_r]
            )
        )
    else
        forall(dcmst_rf_n in index_set(h))(
            dcmst_rf_centre[dcmst_rf_n] =
            dcmst_rf_root_pick[dcmst_rf_n]
        )
    endif;

constraint forall(dcmst_rf_n in index_set(h))(
    h[dcmst_rf_n] >= 1 - bool2int(dcmst_rf_centre[dcmst_rf_n])
    /\
    h[dcmst_rf_n] <=
        radius * (1 - bool2int(dcmst_rf_centre[dcmst_rf_n]))
    /\
    dcmst_rf_parent_pick[dcmst_rf_n,dcmst_rf_n] =
        dcmst_rf_centre[dcmst_rf_n]
);

constraint forall(
    dcmst_rf_n, dcmst_rf_k in index_set(p)
    where dcmst_rf_n != dcmst_rf_k
)(
    h[dcmst_rf_n] - h[dcmst_rf_k] >=
        1 - (radius + 1) *
        (1 - bool2int(
            dcmst_rf_parent_pick[dcmst_rf_n,dcmst_rf_k]
        ))
    /\
    h[dcmst_rf_n] - h[dcmst_rf_k] <=
        1 + (radius - 1) *
        (1 - bool2int(
            dcmst_rf_parent_pick[dcmst_rf_n,dcmst_rf_k]
        ))
);

constraint forall(dcmst_rf_e in edges)(
    let {
        int: dcmst_rf_u = en[dcmst_rf_e,1];
        int: dcmst_rf_v = en[dcmst_rf_e,2];
    } in
    if isDiameterOdd then
        if dcmst_rf_u != dcmst_rf_v then
            bool2int(es[dcmst_rf_e]) >=
                bool2int(dcmst_rf_centre[dcmst_rf_u]) +
                bool2int(dcmst_rf_centre[dcmst_rf_v]) - 1
            /\
            bool2int(es[dcmst_rf_e]) <=
                bool2int(dcmst_rf_parent_pick[dcmst_rf_u,dcmst_rf_v]) +
                bool2int(dcmst_rf_parent_pick[dcmst_rf_v,dcmst_rf_u]) +
                bool2int(dcmst_rf_centre[dcmst_rf_u])
            /\
            bool2int(es[dcmst_rf_e]) <=
                bool2int(dcmst_rf_parent_pick[dcmst_rf_u,dcmst_rf_v]) +
                bool2int(dcmst_rf_parent_pick[dcmst_rf_v,dcmst_rf_u]) +
                bool2int(dcmst_rf_centre[dcmst_rf_v])
        else
            bool2int(es[dcmst_rf_e]) <=
                bool2int(dcmst_rf_centre[dcmst_rf_u])
            /\
            bool2int(es[dcmst_rf_e]) >=
                sum(dcmst_rf_r in dcmst_rf_root_indices
                    where en[dcmst_rf_r,1] = dcmst_rf_u /\
                          en[dcmst_rf_r,2] = dcmst_rf_u)(
                    bool2int(dcmst_rf_root_pick[dcmst_rf_r])
                )
        endif
    else
        if dcmst_rf_u != dcmst_rf_v then
            bool2int(es[dcmst_rf_e]) <=
                bool2int(dcmst_rf_parent_pick[dcmst_rf_u,dcmst_rf_v]) +
                bool2int(dcmst_rf_parent_pick[dcmst_rf_v,dcmst_rf_u])
        else
            not es[dcmst_rf_e]
        endif
    endif
);

constraint redundant_constraint(
    forall(dcmst_rf_e1, dcmst_rf_e2 in edges
        where ws[dcmst_rf_e1] < ws[dcmst_rf_e2] /\
              en[dcmst_rf_e1,1] = en[dcmst_rf_e2,1])(
        h[en[dcmst_rf_e1,2]] - h[en[dcmst_rf_e2,2]] >=
            1 - (radius + 1) *
            (1 - bool2int(dcmst_rf_parent_pick[
                en[dcmst_rf_e1,1],en[dcmst_rf_e2,2]
            ]))
    )
);

constraint redundant_constraint(
    forall(dcmst_rf_e1, dcmst_rf_e2 in edges
        where ws[dcmst_rf_e1] < ws[dcmst_rf_e2] /\
              en[dcmst_rf_e1,2] = en[dcmst_rf_e2,2])(
        h[en[dcmst_rf_e1,1]] - h[en[dcmst_rf_e2,1]] >=
            1 - (radius + 1) *
            (1 - bool2int(dcmst_rf_parent_pick[
                en[dcmst_rf_e1,2],en[dcmst_rf_e2,1]
            ]))
    )
);

constraint redundant_constraint(
    forall(dcmst_rf_e1, dcmst_rf_e2 in edges
        where ws[dcmst_rf_e1] < ws[dcmst_rf_e2] /\
              en[dcmst_rf_e1,1] = en[dcmst_rf_e2,2])(
        h[en[dcmst_rf_e1,2]] - h[en[dcmst_rf_e2,1]] >=
            1 - (radius + 1) *
            (1 - bool2int(dcmst_rf_parent_pick[
                en[dcmst_rf_e1,1],en[dcmst_rf_e2,1]
            ]))
    )
);

constraint redundant_constraint(
    forall(dcmst_rf_e in edges)(
        bool2int(dcmst_rf_parent_pick[
            en[dcmst_rf_e,1],en[dcmst_rf_e,2]
        ]) <= bool2int(es[dcmst_rf_e])
    )
);

constraint redundant_constraint(
    forall(dcmst_rf_e in edges)(
        bool2int(dcmst_rf_parent_pick[
            en[dcmst_rf_e,2],en[dcmst_rf_e,1]
        ]) <= bool2int(es[dcmst_rf_e])
    )
);

solve minimize objective;

output [
    "root = ", show(root), ";\n",
    "h = ", show(h), ";\n",
    "p = ", show(p), ";\n",
    "es = ", show(es), ";\n",
    "objective = ", show(objective), ";\n"
];
set V;
set E within V cross V;

set Axis := {'r','c'};

param axis_size{Axis}, integer, >= 2;
set AXIS_RANGE{a in Axis} := {0 .. (axis_size[a] - 1)};

param dim{a in Axis, V}, integer, >= 2, <= axis_size[a];

param padding, integer, >= 1,
    <= min(axis_size['r'] - 1, axis_size['c'] - 1);

param e_centerAxis{Axis, V}, >= 1;

param ordinal{V}, >= 0, < card(V);

param center_axis{a in Axis} := 0.5 * (axis_size[a] - 1);

set Rpos := {'rt','lb'};

set V2_vw := {(v,w) in V cross V : ordinal[v] < ordinal[w]};

param min_sumWH, >= 0, default 0;

param rf1_position_lower := ceil(padding * 0.5);

param rf1_position_upper{a in Axis, v in V} :=
    axis_size[a] - 1 - dim[a,v] - rf1_position_lower;

param rf1_separation_M{a in Axis} :=
    axis_size[a] - 1 + padding - 2 * rf1_position_lower;

var x{a in Axis, v in V}, integer,
    >= rf1_position_lower,
    <= rf1_position_upper[a,v];

var center_dist{a in Axis, v in V}, >= 0;

var dist{a in Axis, (v1,v2) in E},
    >= 0,
    <= axis_size[a] - 1
       + max(e_centerAxis[a,v1], e_centerAxis[a,v2])
       - min(e_centerAxis[a,v1], e_centerAxis[a,v2]);

var zV{a in Axis, r in Rpos, (v,w) in V2_vw}, binary,
    <= (if dim[a,v] + dim[a,w] + padding
           <= axis_size[a] - 1 - 2 * rf1_position_lower
        then 1 else 0);

minimize drawing:
    sum{a in Axis} (
        (axis_size['r'] + axis_size['c'])
        * sum{(v1,v2) in E} dist[a,v1,v2]
        + sum{v in V} center_dist[a,v]
    );

s.t. choose1{(v,w) in V2_vw}:
    sum{r in Rpos, a in Axis} zV[a,r,v,w] = 1;

s.t. centerDistAxis1{a in Axis, v in V}:
    center_dist[a,v]
    >= center_axis[a] - x[a,v] - e_centerAxis[a,v];

s.t. centerDistAxis2{a in Axis, v in V}:
    center_dist[a,v]
    >= x[a,v] + e_centerAxis[a,v] - center_axis[a];

s.t. axisVdifLB{a in Axis, (v,w) in V2_vw}:
    x[a,w] - x[a,v]
    >= padding + dim[a,v]
       - (1 - zV[a,'lb',v,w]) * rf1_separation_M[a];

s.t. axisVdifRT{a in Axis, (v,w) in V2_vw}:
    x[a,v] - x[a,w]
    >= padding + dim[a,w]
       - (1 - zV[a,'rt',v,w]) * rf1_separation_M[a];

s.t. compDistAxis1{a in Axis, (v,w) in E}:
    dist[a,v,w]
    >= x[a,v] - x[a,w]
       + e_centerAxis[a,v] - e_centerAxis[a,w];

s.t. compDistAxis2{a in Axis, (v,w) in E}:
    dist[a,v,w]
    >= x[a,w] - x[a,v]
       + e_centerAxis[a,w] - e_centerAxis[a,v];

s.t. DistSumLB{(v,w) in E}:
    sum{a in Axis} dist[a,v,w]
    >= padding
       + min(e_centerAxis['r',v] + e_centerAxis['r',w],
             e_centerAxis['c',v] + e_centerAxis['c',w]);

s.t. CenterDistSumLB:
    sum{a in Axis, v in V} center_dist[a,v]
    >= (if card(V) > 1
        then (card(V) - 1) * padding + min_sumWH
        else 0);

s.t. DistAxisLB1{a in Axis, (v,w) in E}:
    dist[a,v,w]
    >= padding + e_centerAxis[a,v] + e_centerAxis[a,w]
       - (sum{r in Rpos}
            zV[
                if a = 'r' then 'c' else 'r',
                r,
                if ordinal[v] < ordinal[w] then v else w,
                if ordinal[v] < ordinal[w] then w else v
            ])
         * (padding + e_centerAxis[a,v] + e_centerAxis[a,w]);

s.t. triangle1{
    (a,b) in V2_vw, c in V, ax in Axis :
    (b,c) in V2_vw
}:
    zV[ax,'rt',a,b]
    + zV[ax,'lb',a,c]
    + zV[ax,'rt',b,c] <= 2;

s.t. triangle2{
    (a,b) in V2_vw, c in V, ax in Axis :
    (b,c) in V2_vw
}:
    zV[ax,'lb',a,b]
    + zV[ax,'rt',a,c]
    + zV[ax,'lb',b,c] <= 2;
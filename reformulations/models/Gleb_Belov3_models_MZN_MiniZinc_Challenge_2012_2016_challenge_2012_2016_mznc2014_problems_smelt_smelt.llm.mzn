include "cumulative.mzn";

int: m;
array[1..m] of int: f;

int: r;
array[1..r,1..m] of int: c;

int: n;
array[1..n] of 1..r: t;
array[1..n] of int: h;
array[1..n] of int: w;

int: nl;

int: p;
array[1..p] of 1..4: typ;
array[1..p] of 1..r: k1;
array[1..p] of int: d;
array[1..p] of 1..r: k2;

array[1..r] of int: duration =
    [sum(i in 1..n)(bool2int(t[i] == j) * h[i] * w[i])
     | j in 1..r];

int: horiz = 1000;

array[1..n] of var 0..horiz: s;
array[1..n] of var 0..horiz: e =
    [s[i] + h[i] * w[i] | i in 1..n];
array[1..n] of var 1..nl: l;
var 0..horiz: makespan;

array[1..r] of var 0..horiz: start;
array[1..r] of var 0..horiz: end =
    [start[i] + duration[i] | i in 1..r];
array[1..r] of var 1..nl: line;

array[1..p] of var bool: followed;

var 0..p: violation =
    sum(i in 1..p)(1 - bool2int(followed[i]));
var 0..1000*p+horiz: objective =
    1000 * violation + makespan;

bool: rf_smelt_event_ok =
    nl >= 0 /\
    forall(i in index_set(duration))(duration[i] >= 0) /\
    forall(i in index_set(f))(f[i] >= 0) /\
    forall(k in index_set_1of2(c), i in index_set_2of2(c))(
        c[k,i] >= 0
    );

array[index_set(duration), index_set(duration)] of var bool:
    rf_smelt_active;

constraint forall(i in 1..n)(
    s[i] =
        start[t[i]] +
        sum(j in 1..i-1)(
            bool2int(t[i] == t[j]) * h[j] * w[j]
        )
    /\
    l[i] = line[t[i]]
);

constraint
    if rf_smelt_event_ok then
        forall(i in index_set(duration), j in index_set(duration))(
            if duration[i] > 0 /\ duration[j] > 0 then
                rf_smelt_active[i,j] <->
                    (start[j] <= start[i] /\ start[i] < end[j])
            else
                not rf_smelt_active[i,j]
            endif
        )
        /\
        forall(i in index_set(duration) where duration[i] > 0)(
            sum(j in index_set(duration))(
                bool2int(rf_smelt_active[i,j])
            ) <= nl
        )
        /\
        forall(
            i in index_set(duration),
            j in index_set(duration)
            where i < j /\ duration[i] > 0 /\ duration[j] > 0
        )(
            line[i] != line[j] \/
            end[i] <= start[j] \/
            end[j] <= start[i]
        )
        /\
        forall(
            i in index_set(duration),
            k in index_set(f)
            where duration[i] > 0 /\
                sum(j in index_set(duration) where duration[j] > 0)(
                    c[j,k]
                ) > f[k]
        )(
            sum(j in index_set(duration) where duration[j] > 0)(
                c[j,k] * bool2int(rf_smelt_active[i,j])
            ) <= f[k]
        )
        /\
        forall(
            i in index_set(duration),
            j in index_set(duration)
            where i < j /\ duration[i] > 0 /\ duration[j] > 0 /\
                exists(k in index_set(f))(
                    c[i,k] + c[j,k] > f[k]
                )
        )(
            end[i] <= start[j] \/ end[j] <= start[i]
        )
        /\
        sum(i in index_set(duration))(duration[i]) <= nl * makespan
        /\
        forall(k in index_set(f))(
            sum(i in index_set(duration))(
                duration[i] * c[i,k]
            ) <= f[k] * makespan
        )
    else
        forall(i in index_set(duration), j in index_set(duration))(
            not rf_smelt_active[i,j]
        )
        /\
        cumulative(start, duration, [1 | i in 1..r], nl)
        /\
        forall(i in 1..nl)(
            cumulative(
                start,
                duration,
                [bool2int(line[j] == i) | j in 1..r],
                1
            )
        )
        /\
        forall(i in 1..m)(
            cumulative(
                start,
                duration,
                [c[k,i] | k in 1..r],
                f[i]
            )
        )
    endif;

constraint forall(i in 1..p)(
    if typ[i] == 1 then
        followed[i] -> end[k1[i]] + d[i] <= start[k2[i]]
    elseif typ[i] == 2 then
        followed[i] -> end[k1[i]] + d[i] >= start[k2[i]]
    elseif typ[i] == 3 then
        followed[i] -> start[k1[i]] <= start[k2[i]] + d[i]
    elseif typ[i] == 4 then
        followed[i] -> end[k1[i]] <= end[k2[i]] + d[i]
    else
        true
    endif
);

constraint forall(i in 1..r)(
    makespan >= end[i]
);

solve minimize objective;

output [
    "s = ", show(s), ";\n",
    "%% e = ", show(e), ";\n",
    "l = ", show(l), ";\n",
    "constraint objective = ", show(objective), ";\n"
];
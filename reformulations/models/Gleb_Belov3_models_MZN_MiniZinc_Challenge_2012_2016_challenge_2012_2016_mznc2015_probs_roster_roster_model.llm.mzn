int: weeks;
int: flatsize = 7 * weeks;
array [1..5,1..7] of int: reqt;
int: minobj;

int: Rest = 1;
int: Morn = 2;
int: Day = 3;
int: Eve = 4;
int: Joker = 5;

var 0..flatsize: evemorn;
var 0..flatsize: isolated;
var minobj..2*flatsize: objective = evemorn + isolated;

array [1..weeks,1..7] of var 1..5: roster;
array [1..flatsize] of var 1..5: flatroster;
array [1..flatsize+6] of var 1..5: longflatroster;

array [
    index_set(flatroster),
    index_set_1of2(reqt)
] of var 0..1: rb_flat_shift;

array [
    index_set(longflatroster),
    index_set_1of2(reqt)
] of var 0..1: rb_long_shift;

array [index_set(flatroster)] of var 0..1: rb_evemorn_hit;
array [index_set(flatroster)] of var 0..1: rb_isolated_hit;

constraint
    forall (rb_d in index_set_2of2(reqt)) (
        sum (rb_s in index_set_1of2(reqt)) (
            reqt[rb_s,rb_d]
        ) = weeks
    );

constraint
    forall (
        rb_s in index_set_1of2(reqt),
        rb_d in index_set_2of2(reqt)
    ) (
        reqt[rb_s,rb_d] >= 0 /\
        reqt[rb_s,rb_d] <= weeks
    );

constraint
    forall (rb_t in index_set(flatroster)) (
        sum (rb_s in index_set_1of2(reqt)) (
            rb_flat_shift[rb_t,rb_s]
        ) = 1
    );

constraint
    forall (rb_t in index_set(flatroster)) (
        flatroster[rb_t] =
        sum (rb_s in index_set_1of2(reqt)) (
            rb_s * rb_flat_shift[rb_t,rb_s]
        )
    );

constraint
    forall (rb_t in index_set(longflatroster)) (
        sum (rb_s in index_set_1of2(reqt)) (
            rb_long_shift[rb_t,rb_s]
        ) = 1
    );

constraint
    forall (rb_t in index_set(longflatroster)) (
        longflatroster[rb_t] =
        sum (rb_s in index_set_1of2(reqt)) (
            rb_s * rb_long_shift[rb_t,rb_s]
        )
    );

constraint
    forall (
        rb_w in index_set_1of2(roster),
        rb_d in index_set_2of2(roster)
    ) (
        flatroster[7*(rb_w-1)+rb_d] = roster[rb_w,rb_d]
    );

constraint
    forall (rb_t in 1..6) (
        if rb_t in index_set(flatroster) /\
           flatsize+rb_t in index_set(longflatroster)
        then
            forall (rb_s in index_set_1of2(reqt)) (
                rb_long_shift[flatsize+rb_t,rb_s] =
                rb_flat_shift[rb_t,rb_s]
            )
        else
            false
        endif
    );

constraint
    forall (
        rb_s in index_set_1of2(reqt),
        rb_d in index_set_2of2(reqt)
    ) (
        sum (rb_w in index_set_1of2(roster)) (
            rb_flat_shift[7*(rb_w-1)+rb_d,rb_s]
        ) = reqt[rb_s,rb_d]
    );

constraint
    forall (
        rb_s in index_set_1of2(reqt),
        rb_d in index_set_2of2(reqt),
        rb_w in index_set_1of2(roster)
        where reqt[rb_s,rb_d] = 0
    ) (
        rb_flat_shift[7*(rb_w-1)+rb_d,rb_s] = 0
    );

constraint
    forall (
        rb_s in index_set_1of2(reqt),
        rb_d in index_set_2of2(reqt),
        rb_w in index_set_1of2(roster)
        where reqt[rb_s,rb_d] = weeks
    ) (
        rb_flat_shift[7*(rb_w-1)+rb_d,rb_s] = 1
    );

constraint
    forall (rb_t in index_set(flatroster)) (
        sum (rb_u in rb_t..rb_t+6) (
            rb_long_shift[rb_u,Rest]
        ) >= 1
    );

constraint
    forall (rb_t in index_set(flatroster)) (
        sum (rb_u in rb_t..rb_t+3) (
            rb_long_shift[rb_u,Rest]
        ) <= 3
    );

constraint
    forall (rb_t in index_set(flatroster)) (
        rb_evemorn_hit[rb_t] <= rb_flat_shift[rb_t,Eve] /\
        rb_evemorn_hit[rb_t] <= rb_long_shift[rb_t+1,Morn] /\
        rb_evemorn_hit[rb_t] >=
            rb_flat_shift[rb_t,Eve] +
            rb_long_shift[rb_t+1,Morn] - 1
    );

constraint
    evemorn = sum (rb_t in index_set(flatroster)) (
        rb_evemorn_hit[rb_t]
    );

constraint
    forall (rb_t in index_set(flatroster)) (
        rb_isolated_hit[rb_t] <= rb_long_shift[rb_t+1,Rest] /\
        rb_isolated_hit[rb_t] <= 1 - rb_flat_shift[rb_t,Rest] /\
        rb_isolated_hit[rb_t] <= 1 - rb_long_shift[rb_t+2,Rest] /\
        rb_isolated_hit[rb_t] >=
            rb_long_shift[rb_t+1,Rest] -
            rb_flat_shift[rb_t,Rest] -
            rb_long_shift[rb_t+2,Rest]
    );

constraint
    isolated = sum (rb_t in index_set(flatroster)) (
        rb_isolated_hit[rb_t]
    );

solve minimize objective;

output [
    "roster = array2d(1..\(weeks), 1..7, \(roster));\n",
    "evemorn = \(evemorn);\n",
    "isolated = \(isolated);\n",
    "objective = \(objective);\n"
] ++ [
    "% Roster: \n",
    "% Week:  M T W T F S S\n"
] ++ [
    if rb_d = 1 then "%    \(rb_w):  " else "" endif ++
    "\(roster[rb_w,rb_d])" ++
    if rb_d = 7 then "\n" else " " endif
    | rb_w in index_set_1of2(roster),
      rb_d in index_set_2of2(roster)
];
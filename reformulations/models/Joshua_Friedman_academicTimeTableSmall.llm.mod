param maxNumCourses;
param numOfCourses;
set coursesneeded := {1..maxNumCourses};
set profs;
param profname{profs} symbolic;
param adjunct{profs}, default 0;
set numbcourses;
param cnumtoname{n in numbcourses} symbolic;
param numtodays{n in {1..5}} symbolic;
set days;
set times;
set finalperiods;
set finals := {0..numOfCourses};
set courses;
set groups;
param gsize{g in groups} integer;
param gperiods{g in groups} integer;
param finalexam{c in courses} integer;
param gc{groups,{1..maxNumCourses}} integer, default 0;
set sections;
set INDEX := {g in groups, i in {1..maxNumCourses}};
set rooms;
set roomtypenumbers;

param masterN{s in sections,
    {"coursenum", "periods", "profnum", "lab", "cap", "min",
     "roomtype", "labtie", "day1", "time1", "day2", "time2",
     "day3", "time3", "day4", "time4", "co1", "co2", "co3",
     "co4", "co5", "co6", "double"}} integer;

param cn{c in courses} integer, default 0;
param rl{r in rooms, {"type", "cap"}} integer, default 2;
param psp{p in profs, d in days, t in times} integer, default 1;

set Y := {s in sections, d in days, t in times, r in rooms:
    masterN[s,"roomtype"] = rl[r,"type"]};

set W := {g in groups, s in sections:
    (sum{i in coursesneeded}
        (if masterN[s,"coursenum"] = gc[g,i] then 1 else 0)) >= 1};

set A := {1..7};
set B := {a in A, b in A, c in A:
    (a = 1 and b = 2 and c = 3)
    or (a = 2 and b = 3 and c = 4)
    or (a = 5 and b = 6 and c = 7)};
set C := {a in A, b in A, c in A: a < b and b < c};
set D := C diff B;
set E := {a in A, b in A: a < b};
set F := {(a,b) in E: a != 4 and b = a+1};
set G := E diff F;

set rf01_double_ids :=
    setof{s in sections: masterN[s,"double"] != 0}
        masterN[s,"double"];

set rf01_double_members{rf01_k in rf01_double_ids} ordered :=
    {s in sections: masterN[s,"double"] = rf01_k};

param rf01_double_anchor{rf01_k in rf01_double_ids} symbolic :=
    first(rf01_double_members[rf01_k]);

set rf01_co_pairs := {p in profs, s in sections:
       (masterN[s,"co1"] > 0 and p = masterN[s,"co1"])
    or (masterN[s,"co2"] > 0 and p = masterN[s,"co2"])
    or (masterN[s,"co3"] > 0 and p = masterN[s,"co3"])
    or (masterN[s,"co4"] > 0 and p = masterN[s,"co4"])
    or (masterN[s,"co5"] > 0 and p = masterN[s,"co5"])
    or (masterN[s,"co6"] > 0 and p = masterN[s,"co6"])};

set rf01_fixed_fields dimen 2 :=
    {("day1","time1"), ("day2","time2"),
     ("day3","time3"), ("day4","time4")};

var z{(s,d,t,r) in Y} binary;

var gapday{s in sections, d in days:
    masterN[s,"periods"] <= 3
    and masterN[s,"periods"] >= 2
    and masterN[s,"lab"] = 0} >= 0, <= 1;

var tg2{d in {"M","T","W","R"}, s in sections:
    masterN[s,"periods"] = 2 and masterN[s,"lab"] = 0} binary;

var tg3{d in {"M","T","W"}, s in sections:
    masterN[s,"periods"] = 3 and masterN[s,"lab"] = 0} binary;

var y1{s in sections, d in days: masterN[s,"lab"] = 1} binary;

var y2{s in sections, d in days, r in rooms:
    masterN[s,"roomtype"] = rl[r,"type"]
    and masterN[s,"lab"] = 1} binary;

var w{p in profs, d in days, t in times} >= 0, <= 1;
var y3{p in profs, d in days} binary;
var y4{p in profs, d in days} binary;
var y5{p in profs} binary;
var tues{p in profs} binary;

var ptv{p in profs, d in days, t in times:
    psp[p,d,t] = 0} binary;

var ptvDoc{p in profs, d in days, t in times:
    psp[p,d,t] = -1} binary;

var ptvAdj{p in profs, d in days, t in times:
    psp[p,d,t] = -5} binary;

var x{(g,s) in W} binary;

var u{g in groups, d in days, t in times, s in sections:
    (g,s) in W} >= 0, <= 1;

s.t. c1{s in sections}:
    sum{d in days, t in times, r in rooms: (s,d,t,r) in Y}
        z[s,d,t,r] = masterN[s,"periods"];

s.t. rf01_double_sync{
    rf01_k in rf01_double_ids,
    s in rf01_double_members[rf01_k], d in days, t in times:
    s != rf01_double_anchor[rf01_k]}:
    sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r]
    =
    sum{r in rooms:
        (rf01_double_anchor[rf01_k],d,t,r) in Y}
        z[rf01_double_anchor[rf01_k],d,t,r];

s.t. cgapday1{s in sections, d in days:
    masterN[s,"periods"] <= 3
    and masterN[s,"periods"] >= 2
    and masterN[s,"lab"] = 0}:
    gapday[s,d] =
    sum{t in times, r in rooms: (s,d,t,r) in Y} z[s,d,t,r];

s.t. cgapdayB1{s in sections:
    masterN[s,"periods"] = 2 and masterN[s,"lab"] = 0}:
    gapday[s,"M"] + gapday[s,"T"] <= 1 + tg2["M",s];

s.t. cgapdayB2{s in sections:
    masterN[s,"periods"] = 2 and masterN[s,"lab"] = 0}:
    gapday[s,"T"] + gapday[s,"W"] <= 1 + tg2["T",s];

s.t. cgapdayB3{s in sections:
    masterN[s,"periods"] = 2 and masterN[s,"lab"] = 0}:
    gapday[s,"W"] + gapday[s,"R"] <= 1 + tg2["W",s];

s.t. cgapdayB4{s in sections:
    masterN[s,"periods"] = 2 and masterN[s,"lab"] = 0}:
    gapday[s,"R"] + gapday[s,"F"] <= 1 + tg2["R",s];

s.t. cgapdayC1{s in sections:
    masterN[s,"periods"] = 3 and masterN[s,"lab"] = 0}:
    gapday[s,"M"] + gapday[s,"T"] + gapday[s,"W"]
    <= 2 + tg3["M",s];

s.t. cgapdayC2{s in sections:
    masterN[s,"periods"] = 3 and masterN[s,"lab"] = 0}:
    gapday[s,"T"] + gapday[s,"W"] + gapday[s,"R"]
    <= 2 + tg3["T",s];

s.t. cgapdayC3{s in sections:
    masterN[s,"periods"] = 3 and masterN[s,"lab"] = 0}:
    gapday[s,"W"] + gapday[s,"R"] + gapday[s,"F"]
    <= 2 + tg3["W",s];

s.t. cRooms{r in rooms, d in days, t in times}:
    sum{s in sections: (s,d,t,r) in Y} z[s,d,t,r] <= 1;

s.t. rf01_fixed_day{
    s in sections, (rf01_df,rf01_tf) in rf01_fixed_fields:
    masterN[s,rf01_df] > 0}:
    sum{t in times, r in rooms:
        (s,numtodays[masterN[s,rf01_df]],t,r) in Y}
        z[s,numtodays[masterN[s,rf01_df]],t,r] >= 1;

s.t. rf01_fixed_time{
    s in sections, (rf01_df,rf01_tf) in rf01_fixed_fields:
    masterN[s,rf01_df] > 0 and masterN[s,rf01_tf] > 0}:
    sum{r in rooms:
        (s,numtodays[masterN[s,rf01_df]],masterN[s,rf01_tf],r) in Y}
        z[s,numtodays[masterN[s,rf01_df]],masterN[s,rf01_tf],r] = 1;

s.t. c2{s in sections, d in days: masterN[s,"lab"] = 0}:
    sum{t in times, r in rooms: (s,d,t,r) in Y}
        z[s,d,t,r] <= 1;

s.t. rf01_lab_day{s in sections, d in days:
    masterN[s,"lab"] = 1}:
    sum{t in times, r in rooms: (s,d,t,r) in Y} z[s,d,t,r]
    = masterN[s,"periods"] * y1[s,d];

s.t. rf01_lab_room{s in sections, d in days, r in rooms:
    masterN[s,"roomtype"] = rl[r,"type"]
    and masterN[s,"lab"] = 1}:
    sum{t in times} z[s,d,t,r]
    = masterN[s,"periods"] * y2[s,d,r];

s.t. rf01_lab_one_day{s in sections:
    masterN[s,"lab"] = 1 and masterN[s,"periods"] > 0}:
    sum{d in days} y1[s,d] = 1;

s.t. rf01_lab_room_day{s in sections, d in days:
    masterN[s,"lab"] = 1 and masterN[s,"periods"] > 0}:
    sum{r in rooms: masterN[s,"roomtype"] = rl[r,"type"]}
        y2[s,d,r] = y1[s,d];

s.t. rf01_lab_activation{(s,d,t,r) in Y:
    masterN[s,"lab"] = 1 and masterN[s,"periods"] > 0}:
    z[s,d,t,r] <= y2[s,d,r];

s.t. c5a{s in sections, d in days, r in rooms, (a,b) in G:
    masterN[s,"roomtype"] = rl[r,"type"]
    and masterN[s,"lab"] = 1 and masterN[s,"periods"] = 2}:
    z[s,d,a,r] + z[s,d,b,r] <= 1;

s.t. c5b{s in sections, d in days, r in rooms, (a,b,e) in D:
    masterN[s,"roomtype"] = rl[r,"type"]
    and masterN[s,"lab"] = 1 and masterN[s,"periods"] = 3}:
    z[s,d,a,r] + z[s,d,b,r] + z[s,d,e,r] <= 2;

s.t. c5c{s in sections, d in days, r in rooms:
    masterN[s,"roomtype"] = rl[r,"type"]
    and masterN[s,"lab"] = 1 and masterN[s,"periods"] = 4}:
    z[s,d,5,r] + z[s,d,6,r] + z[s,d,7,r] = 0;

s.t. c6a{p in profs, d in days}:
    sum{t in times} w[p,d,t] <= min(7,card(times)) * y3[p,d];

s.t. c6b{p in profs, d in days}:
    sum{t in times} w[p,d,t] >= y3[p,d];

s.t. rf01_prof_day_activation{p in profs, d in days, t in times}:
    w[p,d,t] <= y3[p,d];

s.t. c6d{p in profs, d in days}:
    w[p,d,1] + w[p,d,7] <= 1 + y4[p,d];

s.t. c7{p in profs}:
    sum{d in days} y3[p,d] <= 4 + y5[p];

s.t. c8{p in profs}:
    y3[p,"T"] + tues[p] >= 1;

s.t. c9{p in profs, d in days, t in times: psp[p,d,t] = 0}:
    w[p,d,t] <= ptv[p,d,t];

s.t. c9specDoc{p in profs, d in days, t in times:
    psp[p,d,t] = -1}:
    w[p,d,t] <= ptvDoc[p,d,t];

s.t. c9specAdj{p in profs, d in days, t in times:
    psp[p,d,t] = -5}:
    w[p,d,t] <= ptvAdj[p,d,t];

s.t. rf01_co_conflict{(p,s) in rf01_co_pairs, d in days, t in times}:
    w[p,d,t] + sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r] <= 1;

s.t. rf01_co_preference{(p,s) in rf01_co_pairs, d in days, t in times:
    psp[p,d,t] = 0}:
    sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r] <= ptv[p,d,t];

s.t. rf01_co_doc{(p,s) in rf01_co_pairs, d in days, t in times:
    psp[p,d,t] = -1}:
    sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r] <= ptvDoc[p,d,t];

s.t. rf01_co_adj{(p,s) in rf01_co_pairs, d in days, t in times:
    psp[p,d,t] = -5}:
    sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r] <= ptvAdj[p,d,t];

s.t. c10{p in profs, d in days, t in times}:
    w[p,d,t] =
    sum{s in sections, r in rooms:
        masterN[s,"roomtype"] = rl[r,"type"]
        and masterN[s,"profnum"] = p} z[s,d,t,r];

s.t. c11{g in groups, i in coursesneeded: gc[g,i] != 0}:
    sum{s in sections:
        (g,s) in W and masterN[s,"coursenum"] = gc[g,i]} x[g,s] = 1;

s.t. c11a{g in groups, (s,b) in (sections cross sections):
    (g,s) in W and (g,b) in W
    and masterN[s,"lab"] = 0 and masterN[b,"lab"] = 1
    and masterN[s,"labtie"] > 0 and masterN[b,"labtie"] > 0
    and masterN[s,"labtie"] = masterN[b,"labtie"]}:
    x[g,s] >= x[g,b];

s.t. c12a{s in sections}:
    sum{g in groups: (g,s) in W} gsize[g] * x[g,s]
    <= masterN[s,"cap"];

s.t. c13b{s in sections, g in groups, d in days, t in times:
    (g,s) in W}:
    u[g,d,t,s] >=
    sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r] - (1-x[g,s]);

s.t. rf01_attendance_enrollment{(g,s) in W, d in days, t in times}:
    u[g,d,t,s] <= x[g,s];

s.t. rf01_attendance_schedule{(g,s) in W, d in days, t in times}:
    u[g,d,t,s] <= sum{r in rooms: (s,d,t,r) in Y} z[s,d,t,r];

s.t. c13c{g in groups}:
    sum{d in days, t in times, s in sections: (g,s) in W}
        u[g,d,t,s] = gperiods[g];

s.t. c13d{(g,s) in W}:
    sum{d in days, t in times} u[g,d,t,s]
    = x[g,s] * masterN[s,"periods"];

s.t. c13e{g in groups, d in days, t in times}:
    sum{s in sections: (g,s) in W} u[g,d,t,s] <= 1;

s.t. c13f{g in groups, s1 in sections, s2 in sections, d in days:
    (g,s1) in W and (g,s2) in W and s1 < s2
    and masterN[s1,"labtie"] > 0 and masterN[s2,"labtie"] > 0
    and masterN[s1,"labtie"] = masterN[s2,"labtie"]}:
    sum{t in times} (u[g,d,t,s1] + u[g,d,t,s2]) <= 4;

s.t. c13g{g in groups, s1 in sections, s2 in sections,
    d in days, t in times:
    (g,s1) in W and (g,s2) in W and t <= 3 and s1 != s2
    and masterN[s1,"labtie"] > 0 and masterN[s2,"labtie"] > 0
    and masterN[s1,"labtie"] = masterN[s2,"labtie"]}:
    u[g,d,t,s1] + u[g,d,t+1,s2] <= 1;

s.t. c13h{g in groups, s1 in sections, s2 in sections,
    d in days, t in times:
    (g,s1) in W and (g,s2) in W and t <= 6 and t >= 5
    and s1 != s2
    and masterN[s1,"labtie"] > 0 and masterN[s2,"labtie"] > 0
    and masterN[s1,"labtie"] = masterN[s2,"labtie"]}:
    u[g,d,t,s1] + u[g,d,t+1,s2] <= 1;

minimize obj:
    sum{p in profs, d in days, t in times: psp[p,d,t] = 0}
        5 * ptv[p,d,t]
    + 20 * sum{p in profs, d in days, t in times: psp[p,d,t] = -1}
        ptvDoc[p,d,t]
    + 300 * sum{p in profs, d in days, t in times: psp[p,d,t] = -5}
        ptvAdj[p,d,t]
    + 1000 * sum{p in profs, d in days, t in times:
        adjunct[p] = 1 and psp[p,d,t] = 0} ptv[p,d,t]
    + sum{p in profs, d in days} y4[p,d]
    + sum{p in profs:
        adjunct[p] = 0
        and (sum{s in sections: masterN[s,"profnum"] = p}
            masterN[s,"periods"]) > 8} tues[p]
    + sum{d in {"M","T","W","R"}, s in sections:
        masterN[s,"periods"] = 2 and masterN[s,"lab"] = 0} tg2[d,s]
    + sum{d in {"M","T","W"}, s in sections:
        masterN[s,"periods"] = 3 and masterN[s,"lab"] = 0} tg3[d,s]
    + 200 * sum{p in profs} y5[p];
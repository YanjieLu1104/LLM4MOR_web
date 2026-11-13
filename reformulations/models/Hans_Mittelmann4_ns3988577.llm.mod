set Agentes := 1..130;
set Dias := 1..6;
set Periodos := 1..11;

param Demanda {d in Dias, t in Periodos} >= 0;
param Cap_dia {a in Agentes} >= 0;
param Cap_sem {a in Agentes} >= 0;
param Descanso_diario {a in Agentes} >= 0;
param Periodos_min {a in Agentes} = 4;

param rf_max_daily :=
    max {a in Agentes} min(card(Periodos), floor(Cap_dia[a]));

set rf_equal_pairs dimen 2 :=
    setof {a in Agentes, rf_b in Agentes:
        rf_b = a + 1
        and Cap_dia[a] = Cap_dia[rf_b]
        and Cap_sem[a] = Cap_sem[rf_b]
        and Periodos_min[a] = Periodos_min[rf_b]}
    (a, rf_b);

var X {a in Agentes, d in Dias, t in Periodos} binary;
var XE {a in Agentes, d in Dias, t in Periodos} binary,
    <= if t + Periodos_min[a] - 1 <= max {s in Periodos} s
       then 1 else 0;
var Y {a in Agentes} binary;

minimize AGENTES:
    sum {a in Agentes} Y[a];

subject to R1 {a in Agentes}:
    sum {d in Dias, t in Periodos} X[a,d,t]
    <= Cap_sem[a] * Y[a];

subject to R2 {a in Agentes, d in Dias}:
    sum {t in Periodos} X[a,d,t]
    <= Cap_dia[a] * sum {t in Periodos} XE[a,d,t];

subject to R3 {a in Agentes, d in Dias}:
    sum {t in Periodos} X[a,d,t]
    >= Periodos_min[a] * sum {t in Periodos} XE[a,d,t];

subject to rf_coverage {d in Dias, t in Periodos}:
    sum {a in Agentes} X[a,d,t] >= Demanda[d,t];

subject to rf_prefix_link {a in Agentes, d in Dias, t in Periodos}:
    X[a,d,t] <= sum {s in Periodos: s <= t} XE[a,d,s];

subject to R6 {a in Agentes, d in Dias, t in Periodos: t <= 10}:
    X[a,d,t] + XE[a,d,t+1] >= X[a,d,t+1];

subject to R9 {a in Agentes, d in Dias}:
    sum {t in Periodos} XE[a,d,t] <= Y[a];

subject to rf_daily_surplus {d in Dias}:
    4 * (
        sum {a in Agentes, t in Periodos} X[a,d,t]
        - sum {t in Periodos} Demanda[d,t]
    )
    >= sum {a in Agentes, t in Periodos} XE[a,d,t];

subject to rf_min_duration {a in Agentes, d in Dias, t in Periodos}:
    X[a,d,t]
    >= sum {s in Periodos:
        s <= t and t < s + Periodos_min[a]} XE[a,d,s];

subject to rf_rounded_daily_starts {d in Dias}:
    sum {a in Agentes, t in Periodos} XE[a,d,t]
    >= ceil(
        4 * sum {t in Periodos} Demanda[d,t]
        / (4 * rf_max_daily - 1)
    );

subject to rf_selection_order {(a, rf_b) in rf_equal_pairs}:
    Y[a] >= Y[rf_b];

subject to rf_workload_order {(a, rf_b) in rf_equal_pairs}:
    sum {d in Dias, t in Periodos} X[a,d,t]
    >= sum {d in Dias, t in Periodos} X[rf_b,d,t];

data;

param Demanda:
    1    2    3    4    5   6   7   8   9   10  11 :=
1   78   117  119  105  95  57  57  86  85  78  53
2   73   101  104  99   79  44  48  71  70  62  43
3   67   94   102  97   78  45  47  71  73  62  42
4   64   91   99   91   73  40  43  68  64  56  42
5   56   80   84   80   66  38  37  61  62  57  33
6   24   36   41   37   32  15  0   0   0   0   0;

param Cap_dia :=
1  10
2  10
3  10
4  10
5  10
6  10
7  10
8  10
9  10
10 10
11 10
12 10
13 10
14 10
15 10
16 10
17 10
18 10
19 10
20 10
21 10
22 10
23 10
24 10
25 10
26 10
27 10
28 10
29 10
30 10
31 10
32 10
33 10
34 10
35 10
36 10
37 10
38 10
39 10
40 10
41 10
42 10
43 10
44 10
45 10
46 10
47 10
48 10
49 10
50 10
51 10
52 10
53 10
54 10
55 10
56 10
57 10
58 10
59 10
60 10
61 10
62 10
63 10
64 10
65 10
66 10
67 10
68 10
69 10
70 10
71 10
72 10
73 10
74 10
75 10
76 10
77 10
78 10
79 10
80 10
81 10
82 10
83 10
84 10
85 10
86 10
87 10
88 10
89 10
90 10
91 10
92 10
93 10
94 10
95 10
96 6
97 6
98 6
99 6
100 6
101 6
102 6
103 6
104 6
105 6
106 6
107 6
108 6
109 6
110 6
111 6
112 6
113 6
114 6
115 6
116 6
117 6
118 6
119 6
120 6
121 6
122 6
123 6
124 6
125 6
126 6
127 6
128 6
129 6
130 6;

param Cap_sem :=
1  47
2  47
3  47
4  47
5  47
6  47
7  47
8  47
9  47
10 47
11 47
12 47
13 47
14 47
15 47
16 47
17 47
18 47
19 47
20 47
21 47
22 47
23 47
24 47
25 47
26 47
27 47
28 47
29 47
30 47
31 47
32 47
33 47
34 47
35 47
36 47
37 47
38 47
39 47
40 47
41 47
42 47
43 47
44 47
45 47
46 47
47 47
48 47
49 47
50 47
51 47
52 47
53 47
54 47
55 47
56 47
57 47
58 47
59 47
60 47
61 47
62 47
63 47
64 47
65 47
66 47
67 47
68 47
69 47
70 47
71 47
72 47
73 47
74 47
75 47
76 47
77 47
78 47
79 47
80 47
81 47
82 47
83 47
84 47
85 47
86 47
87 47
88 47
89 47
90 47
91 47
92 47
93 47
94 47
95 47
96 24
97 24
98 24
99 24
100 24
101 24
102 24
103 24
104 24
105 24
106 24
107 24
108 24
109 24
110 24
111 24
112 24
113 24
114 24
115 24
116 24
117 24
118 24
119 24
120 24
121 24
122 24
123 24
124 24
125 24
126 24
127 24
128 24
129 24
130 24;
set Agentes := 1..130;
set Dias := 1..5;
set Periodos := 1..44;

param Demanda {d in Dias, t in Periodos} >= 0;
param Cap_dia {a in Agentes} >= 0;
param Cap_sem {a in Agentes} >= 0;
param Descanso_diario {a in Agentes} >= 0;
param Periodos_min {a in Agentes} = 16;

var X {a in Agentes, d in Dias, t in Periodos} binary;
var XE {a in Agentes, d in Dias, t in Periodos}
    >= 0,
    <= (if t + Periodos_min[a] - 1 <= card(Periodos) then 1 else 0);
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

subject to R4 {d in Dias, t in Periodos}:
    sum {a in Agentes} X[a,d,t] >= Demanda[d,t];

subject to R5 {a in Agentes, d in Dias}:
    X[a,d,1] <= XE[a,d,1];

subject to R6 {a in Agentes, d in Dias, t in Periodos: t <= 43}:
    X[a,d,t] + XE[a,d,t+1] >= X[a,d,t+1];

subject to R9 {a in Agentes, d in Dias}:
    sum {t in Periodos} XE[a,d,t] <= Y[a];

subject to rf_minimum_run {a in Agentes, d in Dias, t in Periodos}:
    X[a,d,t] >=
    sum {s in Periodos: s <= t and t < s + Periodos_min[a]}
        XE[a,d,s];

subject to rf_selection_order {
    a in Agentes:
        a < 130
        and Cap_dia[a] = Cap_dia[a+1]
        and Cap_sem[a] = Cap_sem[a+1]
        and Periodos_min[a] = Periodos_min[a+1]
}:
    Y[a] >= Y[a+1];

data;

param Demanda:
    1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44 :=
1   78  78  78  78  117 117 117 117 119 119 119 119 105 105 105 105 95  95  95  95  57  57  57  57  57  57  57  57  86  86  86  86  85  85  85  85  78  78  78  78  53  53  53  53
2   73  73  73  73  101 101 101 101 104 104 104 104 99  99  99  99  79  79  79  79  44  44  44  44  48  48  48  48  71  71  71  71  70  70  70  70  62  62  62  62  43  43  43  43
3   67  67  67  67  94  94  94  94  102 102 102 102 97  97  97  97  78  78  78  78  45  45  45  45  47  47  47  47  71  71  71  71  73  73  73  73  62  62  62  62  42  42  42  42
4   64  64  64  64  91  91  91  91  99  99  99  99  91  91  91  91  73  73  73  73  40  40  40  40  43  43  43  43  68  68  68  68  64  64  64  64  56  56  56  56  42  42  42  42
5   56  56  56  56  80  80  80  80  84  84  84  84  80  80  80  80  66  66  66  66  38  38  38  38  37  37  37  37  61  61  61  61  62  62  62  62  57  57  57  57  33  33  33  33;

param Cap_dia :=
1 40
2 40
3 40
4 40
5 40
6 40
7 40
8 40
9 40
10 40
11 40
12 40
13 40
14 40
15 40
16 40
17 40
18 40
19 40
20 40
21 40
22 40
23 40
24 40
25 40
26 40
27 40
28 40
29 40
30 40
31 40
32 40
33 40
34 40
35 40
36 40
37 40
38 40
39 40
40 40
41 40
42 40
43 40
44 40
45 40
46 40
47 40
48 40
49 40
50 40
51 40
52 40
53 40
54 40
55 40
56 40
57 40
58 40
59 40
60 40
61 40
62 40
63 40
64 40
65 40
66 40
67 40
68 40
69 40
70 40
71 40
72 40
73 40
74 40
75 40
76 40
77 40
78 40
79 40
80 40
81 40
82 40
83 40
84 40
85 40
86 40
87 40
88 40
89 40
90 40
91 40
92 40
93 40
94 40
95 40
96 40
97 40
98 40
99 40
100 40
101 40
102 40
103 40
104 40
105 40
106 40
107 40
108 40
109 40
110 40
111 40
112 40
113 40
114 40
115 40
116 40
117 40
118 40
119 40
120 40
121 40
122 40
123 40
124 40
125 40
126 40
127 40
128 40
129 40
130 40;

param Cap_sem :=
1 188
2 188
3 188
4 188
5 188
6 188
7 188
8 188
9 188
10 188
11 188
12 188
13 188
14 188
15 188
16 188
17 188
18 188
19 188
20 188
21 188
22 188
23 188
24 188
25 188
26 188
27 188
28 188
29 188
30 188
31 188
32 188
33 188
34 188
35 188
36 188
37 188
38 188
39 188
40 188
41 188
42 188
43 188
44 188
45 188
46 188
47 188
48 188
49 188
50 188
51 188
52 188
53 188
54 188
55 188
56 188
57 188
58 188
59 188
60 188
61 188
62 188
63 188
64 188
65 188
66 188
67 188
68 188
69 188
70 188
71 188
72 188
73 188
74 188
75 188
76 188
77 188
78 188
79 188
80 188
81 188
82 188
83 188
84 188
85 188
86 188
87 188
88 188
89 188
90 188
91 188
92 188
93 188
94 188
95 188
96 188
97 188
98 188
99 188
100 188
101 96
102 96
103 96
104 96
105 96
106 96
107 96
108 96
109 96
110 96
111 96
112 96
113 96
114 96
115 96
116 96
117 96
118 96
119 96
120 96
121 96
122 96
123 96
124 96
125 96
126 96
127 96
128 96
129 96
130 96;
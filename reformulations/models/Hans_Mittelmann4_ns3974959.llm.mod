set Agentes := 1..130;
set Dias := 1..6;
set Periodos := 1..11;

param Demanda {rf397_d in Dias, rf397_t in Periodos} >= 0;
param Cap_dia {rf397_a in Agentes} >= 0;
param Cap_sem {rf397_a in Agentes} >= 0;
param Descanso_diario {rf397_a in Agentes} >= 0;
param Periodos_min {rf397_a in Agentes} = 4;

param rf397_last := max {rf397_t in Periodos} rf397_t;

set rf397_pairs dimen 2 :=
    setof {
        rf397_a in Agentes, rf397_b in Agentes:
        rf397_b = rf397_a + 1
        and Cap_dia[rf397_a] = Cap_dia[rf397_b]
        and Cap_sem[rf397_a] = Cap_sem[rf397_b]
        and Periodos_min[rf397_a] = Periodos_min[rf397_b]
    } (rf397_a, rf397_b);

var X {
    rf397_a in Agentes,
    rf397_d in Dias,
    rf397_t in Periodos
} binary;

var XE {
    rf397_a in Agentes,
    rf397_d in Dias,
    rf397_t in Periodos
} >= 0,
    <= if rf397_t + Periodos_min[rf397_a] - 1 <= rf397_last
       then 1 else 0;

var Y {rf397_a in Agentes} binary;

minimize AGENTES:
    sum {rf397_a in Agentes} Y[rf397_a];

s.t. R1 {rf397_a in Agentes}:
    sum {rf397_d in Dias, rf397_t in Periodos}
        X[rf397_a, rf397_d, rf397_t]
    <= Cap_sem[rf397_a] * Y[rf397_a];

s.t. R2 {rf397_a in Agentes, rf397_d in Dias}:
    sum {rf397_t in Periodos} X[rf397_a, rf397_d, rf397_t]
    <= Cap_dia[rf397_a]
       * sum {rf397_t in Periodos} XE[rf397_a, rf397_d, rf397_t];

s.t. rf397_coverage {rf397_d in Dias, rf397_t in Periodos}:
    sum {rf397_a in Agentes} X[rf397_a, rf397_d, rf397_t]
    >= Demanda[rf397_d, rf397_t];

s.t. rf397_prefix {
    rf397_a in Agentes,
    rf397_d in Dias,
    rf397_t in Periodos
}:
    X[rf397_a, rf397_d, rf397_t]
    <= sum {rf397_s in Periodos: rf397_s <= rf397_t}
        XE[rf397_a, rf397_d, rf397_s];

s.t. rf397_minimum_block {
    rf397_a in Agentes,
    rf397_d in Dias,
    rf397_t in Periodos
}:
    X[rf397_a, rf397_d, rf397_t]
    >= sum {
        rf397_s in Periodos:
        rf397_s <= rf397_t
        and rf397_s > rf397_t - Periodos_min[rf397_a]
    } XE[rf397_a, rf397_d, rf397_s];

s.t. R6 {
    rf397_a in Agentes,
    rf397_d in Dias,
    rf397_t in Periodos: rf397_t < rf397_last
}:
    X[rf397_a, rf397_d, rf397_t]
    + XE[rf397_a, rf397_d, rf397_t + 1]
    >= X[rf397_a, rf397_d, rf397_t + 1];

s.t. R9 {rf397_a in Agentes, rf397_d in Dias}:
    sum {rf397_t in Periodos} XE[rf397_a, rf397_d, rf397_t]
    <= Y[rf397_a];

s.t. rf397_daily_surplus {rf397_d in Dias}:
    4 * (
        sum {rf397_a in Agentes, rf397_t in Periodos}
            X[rf397_a, rf397_d, rf397_t]
        - sum {rf397_t in Periodos} Demanda[rf397_d, rf397_t]
    )
    >= sum {rf397_a in Agentes, rf397_t in Periodos}
        XE[rf397_a, rf397_d, rf397_t];

s.t. rf397_selection_order {
    (rf397_a, rf397_b) in rf397_pairs
}:
    Y[rf397_a] >= Y[rf397_b];

s.t. rf397_workload_order {
    (rf397_a, rf397_b) in rf397_pairs
}:
    sum {rf397_d in Dias, rf397_t in Periodos}
        X[rf397_a, rf397_d, rf397_t]
    >= sum {rf397_d in Dias, rf397_t in Periodos}
        X[rf397_b, rf397_d, rf397_t];

data;

param Demanda:
    1   2   3   4   5   6   7   8   9   10  11 :=
1   78  117 119 105 95  57  57  86  85  78  53
2   73  101 104 99  79  44  48  71  70  62  43
3   67  94  102 97  78  45  47  71  73  62  42
4   64  91  99  91  73  40  43  68  64  56  42
5   56  80  84  80  66  38  37  61  62  57  33
6   24  36  41  37  32  15  0   0   0   0   0;

param: Cap_dia Cap_sem :=
1   10 47
2   10 47
3   10 47
4   10 47
5   10 47
6   10 47
7   10 47
8   10 47
9   10 47
10  10 47
11  10 47
12  10 47
13  10 47
14  10 47
15  10 47
16  10 47
17  10 47
18  10 47
19  10 47
20  10 47
21  10 47
22  10 47
23  10 47
24  10 47
25  10 47
26  10 47
27  10 47
28  10 47
29  10 47
30  10 47
31  10 47
32  10 47
33  10 47
34  10 47
35  10 47
36  10 47
37  10 47
38  10 47
39  10 47
40  10 47
41  10 47
42  10 47
43  10 47
44  10 47
45  10 47
46  10 47
47  10 47
48  10 47
49  10 47
50  10 47
51  10 47
52  10 47
53  10 47
54  10 47
55  10 47
56  10 47
57  10 47
58  10 47
59  10 47
60  10 47
61  10 47
62  10 47
63  10 47
64  10 47
65  10 47
66  10 47
67  10 47
68  10 47
69  10 47
70  10 47
71  10 47
72  10 47
73  10 47
74  10 47
75  10 47
76  10 47
77  10 47
78  10 47
79  10 47
80  10 47
81  10 47
82  10 47
83  10 47
84  10 47
85  10 47
86  10 47
87  10 47
88  10 47
89  10 47
90  10 47
91  10 47
92  10 47
93  10 47
94  10 47
95  10 47
96  10 24
97  10 24
98  10 24
99  10 24
100 10 24
101 10 24
102 10 24
103 10 24
104 10 24
105 10 24
106 10 24
107 10 24
108 10 24
109 10 24
110 10 24
111 10 24
112 10 24
113 10 24
114 10 24
115 10 24
116 10 24
117 10 24
118 10 24
119 10 24
120 10 24
121 10 24
122 10 24
123 10 24
124 10 24
125 10 24
126 10 24
127 10 24
128 10 24
129 10 24
130 10 24;

end;
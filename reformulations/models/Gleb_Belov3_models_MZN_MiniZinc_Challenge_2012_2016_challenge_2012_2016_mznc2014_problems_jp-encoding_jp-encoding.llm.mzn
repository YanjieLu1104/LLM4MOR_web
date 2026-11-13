array[1..256] of int: sjis_score = [
135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 57, 135, 135, 135, 135, 135,
135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135,
74, 135, 128, 119, 135, 100, 135, 135, 96, 96, 112, 104, 106, 92, 106, 107,
97, 92, 99, 95, 98, 106, 107, 103, 97, 101, 105, 135, 135, 111, 135, 119,
65, 46, 45, 64, 75, 74, 79, 78, 71, 74, 79, 76, 71, 79, 59, 64,
81, 78, 70, 67, 80, 81, 70, 82, 69, 81, 75, 72, 62, 60, 73, 70,
76, 79, 75, 66, 77, 75, 78, 73, 77, 43, 43, 79, 54, 68, 68, 61,
73, 67, 80, 66, 69, 53, 51, 72, 73, 68, 74, 71, 77, 80, 77, 135,
77, 28, 11, 51, 75, 73, 69, 69, 51, 47, 49, 49, 44, 49, 41, 47,
44, 48, 48, 47, 50, 46, 45, 48, 63, 76, 75, 79, 74, 68, 63, 73,
50, 67, 40, 80, 45, 79, 56, 71, 59, 42, 45, 55, 67, 49, 68, 58,
69, 53, 65, 54, 69, 45, 57, 50, 64, 60, 65, 54, 67, 44, 49, 58,
66, 47, 58, 74, 43, 47, 43, 59, 43, 45, 62, 62, 40, 45, 60, 72,
71, 69, 72, 68, 61, 80, 62, 68, 72, 68, 70, 75, 51, 66, 67, 61,
47, 56, 59, 61, 62, 53, 53, 47, 51, 43, 49, 60, 74, 60, 83, 74,
47, 47, 76, 71, 78, 82, 77, 83, 80, 81, 70, 67, 67, 135, 135, 135
];

array[1..256] of int: eucjp_score = [
135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 57, 135, 135, 135, 135, 135,
135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135,
74, 135, 128, 119, 135, 100, 135, 135, 96, 96, 112, 104, 106, 92, 106, 107,
97, 92, 99, 95, 98, 106, 107, 103, 97, 101, 105, 135, 135, 111, 135, 119,
135, 112, 114, 100, 108, 102, 135, 113, 121, 110, 124, 135, 111, 106, 111, 111,
100, 135, 114, 109, 112, 124, 135, 135, 124, 119, 128, 128, 121, 128, 135, 135,
135, 94, 128, 102, 104, 95, 113, 97, 108, 90, 124, 124, 99, 101, 95, 90,
105, 135, 93, 99, 94, 108, 128, 113, 135, 124, 117, 135, 135, 135, 135, 135,
135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135,
135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135,
135, 28, 41, 44, 11, 50, 45, 72, 55, 64, 57, 42, 45, 54, 65, 46,
49, 49, 51, 48, 50, 48, 54, 41, 45, 45, 52, 44, 48, 45, 49, 39,
43, 50, 51, 43, 49, 53, 40, 43, 41, 50, 34, 36, 48, 45, 38, 43,
53, 66, 62, 66, 61, 62, 49, 50, 59, 62, 62, 63, 63, 68, 50, 63,
63, 58, 46, 55, 57, 59, 58, 52, 50, 46, 49, 43, 48, 58, 63, 58,
73, 67, 46, 46, 70, 68, 58, 66, 71, 73, 72, 74, 66, 61, 58, 135
];

array[1..256] of int: utf8_score = [
139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 61, 139, 139, 139, 139, 139,
139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139,
78, 139, 132, 123, 139, 104, 139, 139, 100, 100, 116, 108, 110, 96, 110, 111,
101, 96, 103, 99, 102, 110, 111, 107, 101, 105, 109, 139, 139, 115, 139, 139,
139, 116, 118, 104, 112, 107, 139, 117, 125, 114, 128, 139, 115, 110, 115, 115,
104, 139, 118, 113, 116, 128, 139, 139, 128, 123, 132, 132, 125, 132, 139, 139,
139, 98, 132, 107, 108, 99, 117, 101, 112, 95, 128, 128, 103, 105, 99, 94,
109, 139, 97, 103, 98, 112, 132, 117, 139, 128, 121, 139, 139, 139, 139, 139,
36, 17, 27, 51, 42, 55, 47, 54, 41, 40, 49, 38, 42, 47, 64, 48,
53, 52, 49, 45, 56, 51, 56, 46, 58, 50, 58, 52, 57, 51, 65, 46,
51, 53, 63, 48, 54, 54, 44, 48, 45, 54, 45, 46, 61, 53, 42, 47,
53, 61, 63, 57, 61, 63, 62, 62, 48, 59, 45, 53, 39, 57, 49, 57,
139, 139, 139, 132, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 118, 139,
139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139,
139, 139, 68, 14, 42, 36, 40, 44, 44, 47, 139, 139, 139, 139, 139, 40,
139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139, 139
];

int: e_ascii = 0;
int: e_euc_jp = 1;
int: e_sjis = 2;
int: e_utf8 = 3;
int: e_unknown = 4;

int: b_ascii = 0;
int: b_euc1 = 1;
int: b_euc2 = 2;
int: b_sjis1_1 = 3;
int: b_sjis2_1 = 4;
int: b_sjis2_2 = 5;
int: b_utf8_2_1 = 6;
int: b_utf8_2_2 = 7;
int: b_utf8_3_1 = 8;
int: b_utf8_3_2 = 9;
int: b_utf8_3_3 = 10;
int: b_utf8_4_1 = 11;
int: b_utf8_4_2 = 12;
int: b_utf8_4_3 = 13;
int: b_utf8_4_4 = 14;
int: b_unknown = 15;

int: len;
array[1..len] of int: stream;

array[1..len] of var 0..b_unknown: byte_status;
array[1..len] of var 0..e_unknown: encoding;
array[1..len] of var 0..1: char_start;
var 0..len: n_unknown;

int: maxObj =
    len * (max(i in 1..256)(
        eucjp_score[i] + sjis_score[i] + utf8_score[i]
    ) + 1000);

array[int] of int: rf_jp_kind = [
    b_ascii, b_euc1, b_sjis1_1, b_sjis2_1,
    b_utf8_2_1, b_utf8_3_1, b_utf8_4_1, b_unknown
];

array[index_set(rf_jp_kind)] of int: rf_jp_width = [
    if rf_jp_kind[rf_jp_k] in {b_ascii, b_sjis1_1, b_unknown} then 1
    elseif rf_jp_kind[rf_jp_k] = b_utf8_3_1 then 3
    elseif rf_jp_kind[rf_jp_k] = b_utf8_4_1 then 4
    else 2
    endif
    | rf_jp_k in index_set(rf_jp_kind)
];

array[index_set(rf_jp_kind)] of int: rf_jp_encoding = [
    if rf_jp_kind[rf_jp_k] = b_ascii then e_ascii
    elseif rf_jp_kind[rf_jp_k] = b_euc1 then e_euc_jp
    elseif rf_jp_kind[rf_jp_k] in {b_sjis1_1, b_sjis2_1} then e_sjis
    elseif rf_jp_kind[rf_jp_k] = b_unknown then e_unknown
    else e_utf8
    endif
    | rf_jp_k in index_set(rf_jp_kind)
];

array[index_set(stream), index_set(rf_jp_kind)] of bool: rf_jp_allowed =
    array2d(index_set(stream), index_set(rf_jp_kind), [
        if rf_jp_i + rf_jp_width[rf_jp_k] - 1 > len then
            false
        elseif rf_jp_kind[rf_jp_k] = b_ascii then
            stream[rf_jp_i] < 128
        elseif rf_jp_kind[rf_jp_k] = b_unknown then
            true
        elseif rf_jp_kind[rf_jp_k] = b_sjis1_1 then
            161 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 223
        elseif rf_jp_kind[rf_jp_k] = b_euc1 then
            (
                (161 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 168)
                \/ stream[rf_jp_i] = 173
                \/ (176 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 244)
                \/ (249 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 252)
            )
            /\ 161 <= stream[rf_jp_i + 1]
            /\ stream[rf_jp_i + 1] <= 254
        elseif rf_jp_kind[rf_jp_k] = b_sjis2_1 then
            (
                (129 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 159)
                \/ (224 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 252)
            )
            /\ (
                (64 <= stream[rf_jp_i + 1] /\ stream[rf_jp_i + 1] <= 126)
                \/ (128 <= stream[rf_jp_i + 1] /\ stream[rf_jp_i + 1] <= 252)
            )
        else
            (
                if rf_jp_kind[rf_jp_k] = b_utf8_2_1 then
                    194 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 223
                elseif rf_jp_kind[rf_jp_k] = b_utf8_3_1 then
                    224 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 239
                else
                    240 <= stream[rf_jp_i] /\ stream[rf_jp_i] <= 247
                endif
            )
            /\ forall(rf_jp_d in 1..(rf_jp_width[rf_jp_k] - 1))(
                128 <= stream[rf_jp_i + rf_jp_d]
                /\ stream[rf_jp_i + rf_jp_d] <= 191
            )
        endif
        | rf_jp_i in index_set(stream),
          rf_jp_k in index_set(rf_jp_kind)
    ]);

array[index_set(stream), index_set(rf_jp_kind)] of int: rf_jp_byte_cost =
    array2d(index_set(stream), index_set(rf_jp_kind), [
        if rf_jp_encoding[rf_jp_k] = e_euc_jp then
            eucjp_score[stream[rf_jp_i] + 1]
        elseif rf_jp_encoding[rf_jp_k] = e_sjis then
            sjis_score[stream[rf_jp_i] + 1]
        elseif rf_jp_encoding[rf_jp_k] = e_utf8 then
            utf8_score[stream[rf_jp_i] + 1]
        else
            0
        endif
        | rf_jp_i in index_set(stream),
          rf_jp_k in index_set(rf_jp_kind)
    ]);

array[index_set(stream), index_set(rf_jp_kind)] of var 0..1: rf_jp_take;

constraint forall(
    rf_jp_i in index_set(stream),
    rf_jp_k in index_set(rf_jp_kind)
    where not rf_jp_allowed[rf_jp_i, rf_jp_k]
)(
    rf_jp_take[rf_jp_i, rf_jp_k] = 0
);

constraint forall(rf_jp_i in index_set(stream))(
    sum(
        rf_jp_j in max(1, rf_jp_i - 3)..rf_jp_i,
        rf_jp_k in index_set(rf_jp_kind)
        where rf_jp_allowed[rf_jp_j, rf_jp_k]
            /\ rf_jp_i < rf_jp_j + rf_jp_width[rf_jp_k]
    )(
        rf_jp_take[rf_jp_j, rf_jp_k]
    ) = 1
);

constraint forall(rf_jp_i in index_set(byte_status))(
    byte_status[rf_jp_i] =
        sum(
            rf_jp_j in max(1, rf_jp_i - 3)..rf_jp_i,
            rf_jp_k in index_set(rf_jp_kind)
            where rf_jp_allowed[rf_jp_j, rf_jp_k]
                /\ rf_jp_i < rf_jp_j + rf_jp_width[rf_jp_k]
        )(
            (rf_jp_kind[rf_jp_k] + rf_jp_i - rf_jp_j)
            * rf_jp_take[rf_jp_j, rf_jp_k]
        )
);

constraint forall(rf_jp_i in index_set(encoding))(
    encoding[rf_jp_i] =
        sum(
            rf_jp_j in max(1, rf_jp_i - 3)..rf_jp_i,
            rf_jp_k in index_set(rf_jp_kind)
            where rf_jp_allowed[rf_jp_j, rf_jp_k]
                /\ rf_jp_i < rf_jp_j + rf_jp_width[rf_jp_k]
        )(
            rf_jp_encoding[rf_jp_k] * rf_jp_take[rf_jp_j, rf_jp_k]
        )
);

constraint forall(rf_jp_i in index_set(char_start))(
    char_start[rf_jp_i] =
        sum(rf_jp_k in index_set(rf_jp_kind))(
            rf_jp_take[rf_jp_i, rf_jp_k]
        )
);

constraint n_unknown =
    sum(
        rf_jp_i in index_set(stream),
        rf_jp_k in index_set(rf_jp_kind)
        where rf_jp_kind[rf_jp_k] = b_unknown
    )(
        rf_jp_take[rf_jp_i, rf_jp_k]
    );

var 0..maxObj: objective =
    sum(rf_jp_i in index_set(stream))(
        sum(
            rf_jp_j in max(1, rf_jp_i - 3)..rf_jp_i,
            rf_jp_k in index_set(rf_jp_kind)
            where rf_jp_allowed[rf_jp_j, rf_jp_k]
                /\ rf_jp_i < rf_jp_j + rf_jp_width[rf_jp_k]
        )(
            rf_jp_byte_cost[rf_jp_i, rf_jp_k]
            * rf_jp_take[rf_jp_j, rf_jp_k]
        )
    ) + 1000 * n_unknown;

solve minimize objective;

output [
    "encoding = ", show(encoding), ";\n",
    "byte_status = ", show(byte_status), ";\n",
    "char_start = ", show(char_start), ";\n",
    "n_unknown = ", show(n_unknown), ";\n",
    "constraint objective = ", show(objective), ";\n"
];
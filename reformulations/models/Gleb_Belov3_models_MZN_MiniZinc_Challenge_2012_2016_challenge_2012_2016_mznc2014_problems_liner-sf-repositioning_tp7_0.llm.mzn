int: vv;
int: ww;
int: pip;
int: poPorts0;
int: poPorts1;
int: poPorts2;
int: poPorts3;
int: poPorts4;
int: poPorts5;
int: poPorts6;
int: poPorts7;
int: poPorts8;

vv = 9;
ww = 11;
pip = 13;
poPorts0 = 17;
poPorts1 = 17;
poPorts2 = 17;
poPorts3 = 10;
poPorts4 = 10;
poPorts5 = 10;
poPorts6 = 15;
poPorts7 = 13;
poPorts8 = 12;

set of int: POPORTS0 = 0..poPorts0;
set of int: POPORTS1 = 0..poPorts1;
set of int: POPORTS2 = 0..poPorts2;
set of int: POPORTS3 = 0..poPorts3;
set of int: POPORTS4 = 0..poPorts4;
set of int: POPORTS5 = 0..poPorts5;
set of int: POPORTS6 = 0..poPorts6;
set of int: POPORTS7 = 0..poPorts7;
set of int: POPORTS8 = 0..poPorts8;
set of int: VESSELS = 1..vv;
set of int: WEEKS = 1..ww;
set of int: PIPORTS = 1..pip;
set of int: REPOSTYPES = 1..3;

var POPORTS0: poAct0;
var POPORTS1: poAct1;
var POPORTS2: poAct2;
var POPORTS3: poAct3;
var POPORTS4: poAct4;
var POPORTS5: poAct5;
var POPORTS6: poAct6;
var POPORTS7: poAct7;
var POPORTS8: poAct8;
var PIPORTS: piPort;
array[VESSELS] of var WEEKS: piWeek;
array[VESSELS] of var REPOSTYPES: reposType;

constraint forall(rf_v in VESSELS)(reposType[rf_v] = 1);

array[POPORTS0] of int: poTimes0 =
    array1d(POPORTS0, [18,1026,128,1136,148,1156,180,1188,213,1221,229,1237,229,1237,655,655,764,764]);
array[POPORTS1] of int: poTimes1 =
    array1d(POPORTS1, [186,1194,296,1304,316,1324,348,1356,381,1389,397,1405,397,1405,823,823,932,932]);
array[POPORTS2] of int: poTimes2 =
    array1d(POPORTS2, [354,1362,464,1472,484,1492,516,1524,549,1557,565,1573,565,1573,991,991,1100,1100]);
array[POPORTS3] of int: poTimes3 =
    array1d(POPORTS3, [31,66,109,156,210,236,502,619,680,721,754]);
array[POPORTS4] of int: poTimes4 =
    array1d(POPORTS4, [199,234,277,324,378,404,670,787,848,889,922]);
array[POPORTS5] of int: poTimes5 =
    array1d(POPORTS5, [367,402,445,492,546,572,838,955,1016,1057,1090]);
array[POPORTS6] of int: poTimes6 =
    array1d(POPORTS6, [30,702,1374,186,858,1530,332,1004,1676,426,1098,1770,542,1214,572,1244]);
array[POPORTS7] of int: poTimes7 =
    array1d(POPORTS7, [198,870,1542,354,1026,1698,500,1172,594,1266,710,1382,740,1412]);
array[POPORTS8] of int: poTimes8 =
    array1d(POPORTS8, [366,1038,1710,522,1194,668,1340,762,1434,878,1550,908,1580]);

array[PIPORTS,WEEKS] of int: piTimes = array2d(PIPORTS,WEEKS,[
164,332,500,668,836,1004,1172,1340,1508,1676,1844,
0,192,360,528,696,864,1032,1200,1368,1536,1704,
0,0,364,532,700,868,1036,1204,1372,1540,1708,
0,0,444,612,780,948,1116,1284,1452,1620,1788,
0,0,0,546,714,882,1050,1218,1386,1554,1722,
0,0,0,594,762,930,1098,1266,1434,1602,1770,
0,0,0,0,726,894,1062,1230,1398,1566,1734,
0,0,0,0,0,900,1068,1236,1404,1572,1740,
0,0,0,0,0,930,1098,1266,1434,1602,1770,
0,0,0,0,0,0,1100,1268,1436,1604,1772,
0,0,0,0,0,0,0,1256,1424,1592,1760,
0,0,0,0,0,0,0,1328,1496,1664,1832,
0,0,0,0,0,0,0,0,1362,1530,1698
]);

array[int] of int: rf_profile0 = [
1,291789,25214,-1,-1,
2,206650,24937,-1,-1,
2,155886,23498,-1,-1,
2,225201,34033,-1,-1,
3,149676,41524,-1,-1,
2,495404,42019,-1,-1,
2,83939,23498,-1,-1,
2,114687,25214,-1,-1,
2,24937,-1,-1,-1,
2,23498,-1,-1,-1,
2,509413,44522,41524,-1,
2,409950,45140,-1,-1,
3,357977,46666,-1,-1,

2,12867,-1,-1,-1,
2,170321,12590,-1,-1,
3,22050,-1,-1,-1,
3,97483,35220,-1,-1,
3,520108,55217,43917,-1,
3,379402,43632,-1,-1,
3,22050,-1,-1,-1,
2,78358,12867,-1,-1,
2,12590,-1,-1,-1,
2,243221,22050,-1,-1,
3,414954,43917,-1,-1,
3,315252,47524,-1,-1,
4,236480,48079,-1,-1,

2,12824,-1,-1,-1,
3,12546,-1,-1,-1,
3,21973,-1,-1,-1,
3,151630,35177,-1,-1,
3,574256,109365,43874,-1,
3,432672,43557,-1,-1,
3,21973,-1,-1,-1,
2,132505,12824,-1,-1,
2,41833,12546,-1,-1,
2,296439,21973,-1,-1,
3,469102,43874,-1,-1,
3,369400,47481,-1,-1,
4,290628,48036,-1,-1,

2,14575,-1,-1,-1,
3,14298,-1,-1,-1,
3,86882,21599,-1,-1,
3,223432,34570,-1,-1,
4,181166,43267,-1,-1,
3,508020,43129,43078,-1,
3,21599,-1,-1,-1,
3,14575,-1,-1,-1,
2,178716,14298,-1,-1,
3,21599,-1,-1,-1,
3,540904,76012,43267,-1,
3,439766,46822,-1,-1,
4,362430,47429,-1,-1,

2,148046,17298,-1,-1,
3,70373,17291,-1,-1,
3,218202,23049,-1,-1,
3,292511,33764,-1,-1,
4,276664,43418,-1,-1,
3,628353,163461,44130,-1,
3,146254,23049,-1,-1,
3,17298,-1,-1,-1,
3,17291,-1,-1,-1,
3,41100,23049,-1,-1,
4,171510,43418,-1,-1,
3,491995,45405,-1,-1,
4,407392,45749,-1,-1,

2,250706,19413,-1,-1,
3,165568,19136,-1,-1,
3,279814,23677,-1,-1,
3,420279,36790,-1,-1,
4,354804,44646,-1,-1,
4,223209,44690,-1,-1,
3,207867,23677,-1,-1,
3,73605,19413,-1,-1,
3,19136,-1,-1,-1,
3,102713,23677,-1,-1,
4,249650,44646,-1,-1,
3,609575,144684,48062,-1,
4,560234,95342,49683,-1,

7,712030,247138,77647,-1,
7,1091782,626891,162000,77369,
7,589001,124110,59550,-1,
6,784670,319779,57817,-1,
6,701954,237063,48201,-1,
6,604345,139453,49477,-1,
7,517053,59550,-1,-1,
7,999820,534928,77647,-1,
7,909147,444255,77369,-1,
7,411899,59550,-1,-1,
6,596800,131909,48201,-1,
6,431059,49415,-1,-1,
7,504464,55484,-1,-1,

8,915329,450437,90931,-1,
8,1295081,830190,365299,90653,
8,776534,311642,72263,-1,
7,865223,400332,66652,-1,
7,767672,302780,56499,-1,
7,610589,145698,55620,-1,
8,704586,239695,72263,-1,
8,1203118,738227,273336,90931,
8,1112445,647554,182663,90653,
8,599432,134541,72263,-1,
7,662518,197626,56499,-1,
7,486727,57348,-1,-1,
8,570182,105290,63782,-1
];

array[int] of int: rf_profile3 = [
2,3087,-1,-1,-1,
2,149663,3053,-1,-1,
2,125081,2869,-1,-1,
2,174558,4158,-1,-1,
3,157712,5069,-1,-1,
2,299201,107970,5114,-1,
3,2869,-1,-1,-1,
4,3087,-1,-1,-1,
4,3053,-1,-1,-1,
5,2869,-1,-1,-1,
6,5069,-1,-1,-1,
6,5508,-1,-1,-1,
7,5694,-1,-1,-1,

2,9810,2867,-1,-1,
2,165493,2833,-1,-1,
2,161100,2834,-1,-1,
2,221291,30060,4222,-1,
3,204904,13673,5136,-1,
3,154771,5178,-1,-1,
3,2834,-1,-1,-1,
4,2867,-1,-1,-1,
4,2833,-1,-1,-1,
5,2834,-1,-1,-1,
6,5136,-1,-1,-1,
6,5523,-1,-1,-1,
7,5752,-1,-1,-1,

2,37273,2670,-1,-1,
3,2636,-1,-1,-1,
3,30141,2938,-1,-1,
3,101408,4427,-1,-1,
3,276711,85481,5346,-1,
3,225362,34132,5376,-1,
3,2938,-1,-1,-1,
4,2670,-1,-1,-1,
4,2636,-1,-1,-1,
5,2938,-1,-1,-1,
6,5346,-1,-1,-1,
6,5728,-1,-1,-1,
7,5957,-1,-1,-1,

2,56882,2359,-1,-1,
3,21334,2325,-1,-1,
3,76949,2877,-1,-1,
3,159617,4470,-1,-1,
4,147596,5425,-1,-1,
3,284780,93550,5430,-1,
3,47354,2877,-1,-1,
4,2359,-1,-1,-1,
4,2325,-1,-1,-1,
5,2877,-1,-1,-1,
6,5425,-1,-1,-1,
6,5840,-1,-1,-1,
7,6037,-1,-1,-1,

2,31614,1563,-1,-1,
3,1529,-1,-1,-1,
3,116860,2679,-1,-1,
3,200291,9060,4280,-1,
4,199413,8182,5336,-1,
4,140992,5302,-1,-1,
3,87265,2679,-1,-1,
4,1563,-1,-1,-1,
4,1529,-1,-1,-1,
5,2679,-1,-1,-1,
6,5336,-1,-1,-1,
6,5775,-1,-1,-1,
7,5842,-1,-1,-1,

2,60634,1558,-1,-1,
3,25087,1524,-1,-1,
3,145435,2670,-1,-1,
3,229312,38081,4274,-1,
4,228433,37203,5331,-1,
4,169591,5293,-1,-1,
3,115840,2670,-1,-1,
4,1558,-1,-1,-1,
4,1524,-1,-1,-1,
5,2670,-1,-1,-1,
6,5331,-1,-1,-1,
6,5769,-1,-1,-1,
7,5837,-1,-1,-1,

5,68771,4117,-1,-1,
5,224454,33223,4084,-1,
5,1302,-1,-1,-1,
4,0,-1,-1,-1,
5,1411,-1,-1,-1,
4,46628,1388,-1,-1,
5,1302,-1,-1,-1,
5,187152,4117,-1,-1,
5,149328,4084,-1,-1,
5,1302,-1,-1,-1,
6,1411,-1,-1,-1,
6,1714,-1,-1,-1,
7,2246,-1,-1,-1,

6,143177,5332,-1,-1,
6,298860,107630,5298,-1,
6,2535,-1,-1,-1,
5,1411,-1,-1,-1,
5,0,-1,-1,-1,
5,87,-1,-1,-1,
6,2535,-1,-1,-1,
6,261558,70328,5332,-1,
6,223734,32503,5298,-1,
5,111414,2535,-1,-1,
6,0,-1,-1,-1,
6,708,-1,-1,-1,
7,885,-1,-1,-1,

6,225249,34019,5448,-1,
7,189701,5414,-1,-1,
6,83321,2726,-1,-1,
5,73084,1714,-1,-1,
5,38498,708,-1,-1,
5,409,-1,-1,-1,
6,53725,2726,-1,-1,
7,152400,5448,-1,-1,
6,305806,114575,5414,-1,
6,10471,2726,-1,-1,
6,708,-1,-1,-1,
6,0,-1,-1,-1,
7,1593,-1,-1,-1,

6,217318,26087,4947,-1,
7,183579,4930,-1,-1,
6,129027,2718,-1,-1,
6,1465,-1,-1,-1,
6,197,-1,-1,-1,
5,119,-1,-1,-1,
6,99432,2718,-1,-1,
7,144468,4947,-1,-1,
7,108452,4930,-1,-1,
6,56177,2718,-1,-1,
6,197,-1,-1,-1,
6,327,-1,-1,-1,
7,496,-1,-1,-1,

6,248351,57120,4887,-1,
7,214598,23367,4870,-1,
7,2623,-1,-1,-1,
6,1388,-1,-1,-1,
6,87,-1,-1,-1,
5,0,-1,-1,-1,
6,126639,2623,-1,-1,
7,175501,4887,-1,-1,
7,139472,4870,-1,-1,
6,83384,2623,-1,-1,
6,87,-1,-1,-1,
6,409,-1,-1,-1,
7,577,-1,-1,-1
];

array[int] of int: rf_profile6 = [
1,33004,1701,-1,-1,
2,1667,-1,-1,-1,
3,73742,4163,-1,-1,
3,147963,5679,-1,-1,
3,351412,160182,6856,-1,
3,257878,66648,6499,-1,
2,235377,44147,4163,-1,
2,1701,-1,-1,-1,
2,1667,-1,-1,-1,
2,192123,4163,-1,-1,
3,308158,116927,6856,-1,
3,199205,7974,6608,-1,
3,339901,148670,6500,-1,

2,0,-1,-1,-1,
2,33,-1,-1,-1,
3,74437,2541,-1,-1,
3,155280,4117,-1,-1,
4,171634,5332,-1,-1,
3,259733,68503,4887,-1,
3,44842,2541,-1,-1,
2,0,-1,-1,-1,
2,33,-1,-1,-1,
3,2541,-1,-1,-1,
4,128380,5332,-1,-1,
3,250291,59061,5448,-1,
4,199757,8527,5340,-1,

3,65988,2359,-1,-1,
4,30440,2325,-1,-1,
4,86055,2877,-1,-1,
4,168724,4470,-1,-1,
5,156702,5425,-1,-1,
4,293886,102656,5430,-1,
4,56460,2877,-1,-1,
4,2359,-1,-1,-1,
4,2325,-1,-1,-1,
4,13205,2877,-1,-1,
4,304678,113447,5425,-1,
4,267985,76755,5840,-1,
5,250767,59536,6037,-1,

3,86251,1563,-1,-1,
4,50703,1529,-1,-1,
5,2679,-1,-1,-1,
5,63698,4280,-1,-1,
5,254050,62819,5336,-1,
5,195629,5302,-1,-1,
4,141902,2679,-1,-1,
4,13401,1563,-1,-1,
4,1529,-1,-1,-1,
4,98648,2679,-1,-1,
5,210795,19565,5336,-1,
5,176630,5775,-1,-1,
5,336511,145281,5842,-1,

4,0,-1,-1,-1,
5,33,-1,-1,-1,
5,97202,2541,-1,-1,
5,178046,4117,-1,-1,
6,194400,5332,-1,-1,
5,282499,91269,4887,-1,
5,67607,2541,-1,-1,
4,0,-1,-1,-1,
4,33,-1,-1,-1,
5,24353,2541,-1,-1,
6,151145,5332,-1,-1,
5,273057,81826,5448,-1,
6,222523,31292,5340,-1,

4,265,-1,-1,-1,
5,231,-1,-1,-1,
5,148842,2701,-1,-1,
5,233792,42561,4315,-1,
6,250146,58915,5530,-1,
6,144041,5058,-1,-1,
5,119247,2701,-1,-1,
5,265,-1,-1,-1,
4,231,-1,-1,-1,
5,75992,2701,-1,-1,
6,206891,15661,5530,-1,
5,328803,137572,5646,-1,
6,278269,87038,5538,-1
];

function int: rf_decode(
    array[int] of int: rf_encoding,
    int: rf_kind,
    int: rf_port_index,
    int: rf_week_index,
    int: rf_shift
) =
    let {
        int: rf_base = min(index_set(rf_encoding)) +
            5 * ((rf_kind - 1) * card(PIPORTS) +
                 rf_port_index - min(PIPORTS)),
        int: rf_first = rf_encoding[rf_base],
        int: rf_count = sum(rf_j in 1..4)(
            bool2int(rf_encoding[rf_base + rf_j] >= 0)
        ),
        int: rf_relative = rf_week_index - rf_shift
    } in
    if piTimes[rf_port_index,rf_week_index] = 0 \/
       rf_relative < rf_first then
        -1
    else
        rf_encoding[
            rf_base + min(rf_count, rf_relative - rf_first + 1)
        ]
    endif;

array[index_set(poTimes0)] of int: rf_kind0 =
    array1d(index_set(poTimes0),
        [1,1,2,2,3,3,4,4,5,5,6,6,6,6,7,7,8,8]);
array[index_set(poTimes0)] of int: rf_shift0 =
    array1d(index_set(poTimes0),
        [0,6,0,6,0,6,0,6,0,6,0,6,0,6,0,0,0,0]);

array[index_set(poTimes6)] of int: rf_kind6 =
    array1d(index_set(poTimes6),
        [1,1,1,2,2,2,3,3,3,4,4,4,5,5,6,6]);
array[index_set(poTimes6)] of int: rf_shift6 =
    array1d(index_set(poTimes6),
        [0,4,8,0,4,8,0,4,8,0,4,8,0,4,0,4]);

array[index_set(poTimes7)] of int: rf_kind7 =
    array1d(index_set(poTimes7),
        [1,1,1,2,2,2,3,3,4,4,5,5,6,6]);
array[index_set(poTimes7)] of int: rf_shift7 =
    array1d(index_set(poTimes7),
        [1,5,9,1,5,9,1,5,1,5,1,5,1,5]);

array[index_set(poTimes8)] of int: rf_kind8 =
    array1d(index_set(poTimes8),
        [1,1,1,2,2,3,3,4,4,5,5,6,6]);
array[index_set(poTimes8)] of int: rf_shift8 =
    array1d(index_set(poTimes8),
        [2,6,10,2,6,2,6,2,6,2,6,2,6]);

array[POPORTS0,PIPORTS,WEEKS] of int: directCostArr0;
array[POPORTS1,PIPORTS,WEEKS] of int: directCostArr1;
array[POPORTS2,PIPORTS,WEEKS] of int: directCostArr2;
array[POPORTS3,PIPORTS,WEEKS] of int: directCostArr3;
array[POPORTS4,PIPORTS,WEEKS] of int: directCostArr4;
array[POPORTS5,PIPORTS,WEEKS] of int: directCostArr5;
array[POPORTS6,PIPORTS,WEEKS] of int: directCostArr6;
array[POPORTS7,PIPORTS,WEEKS] of int: directCostArr7;
array[POPORTS8,PIPORTS,WEEKS] of int: directCostArr8;

directCostArr0 = array3d(POPORTS0,PIPORTS,WEEKS,[
    rf_decode(rf_profile0,rf_kind0[rf_a],rf_p,rf_w,rf_shift0[rf_a])
    | rf_a in POPORTS0, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr1 = array3d(POPORTS1,PIPORTS,WEEKS,[
    rf_decode(rf_profile0,rf_kind0[rf_a],rf_p,rf_w,rf_shift0[rf_a]+1)
    | rf_a in POPORTS1, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr2 = array3d(POPORTS2,PIPORTS,WEEKS,[
    rf_decode(rf_profile0,rf_kind0[rf_a],rf_p,rf_w,rf_shift0[rf_a]+2)
    | rf_a in POPORTS2, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr3 = array3d(POPORTS3,PIPORTS,WEEKS,[
    rf_decode(rf_profile3,rf_a-min(POPORTS3)+1,rf_p,rf_w,0)
    | rf_a in POPORTS3, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr4 = array3d(POPORTS4,PIPORTS,WEEKS,[
    rf_decode(rf_profile3,rf_a-min(POPORTS4)+1,rf_p,rf_w,1)
    | rf_a in POPORTS4, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr5 = array3d(POPORTS5,PIPORTS,WEEKS,[
    rf_decode(rf_profile3,rf_a-min(POPORTS5)+1,rf_p,rf_w,2)
    | rf_a in POPORTS5, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr6 = array3d(POPORTS6,PIPORTS,WEEKS,[
    rf_decode(rf_profile6,rf_kind6[rf_a],rf_p,rf_w,rf_shift6[rf_a])
    | rf_a in POPORTS6, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr7 = array3d(POPORTS7,PIPORTS,WEEKS,[
    rf_decode(rf_profile6,rf_kind7[rf_a],rf_p,rf_w,rf_shift7[rf_a])
    | rf_a in POPORTS7, rf_p in PIPORTS, rf_w in WEEKS
]);
directCostArr8 = array3d(POPORTS8,PIPORTS,WEEKS,[
    rf_decode(rf_profile6,rf_kind8[rf_a],rf_p,rf_w,rf_shift8[rf_a])
    | rf_a in POPORTS8, rf_p in PIPORTS, rf_w in WEEKS
]);

int: directCostMax = max([
    max(array1d(1..ww*pip*(poPorts0+1),directCostArr0)),
    max(array1d(1..ww*pip*(poPorts1+1),directCostArr1)),
    max(array1d(1..ww*pip*(poPorts2+1),directCostArr2)),
    max(array1d(1..ww*pip*(poPorts3+1),directCostArr3)),
    max(array1d(1..ww*pip*(poPorts4+1),directCostArr4)),
    max(array1d(1..ww*pip*(poPorts5+1),directCostArr5)),
    max(array1d(1..ww*pip*(poPorts6+1),directCostArr6)),
    max(array1d(1..ww*pip*(poPorts7+1),directCostArr7)),
    max(array1d(1..ww*pip*(poPorts8+1),directCostArr8))
]);

array[VESSELS] of var 0..directCostMax: directCost;
int: maxCost = 500000;

set of int: rf_possible_ports = {
    rf_p | rf_p in index_set_1of2(piTimes)
    where sum(rf_w in index_set_2of2(piTimes))(
        bool2int(piTimes[rf_p,rf_w] != 0)
    ) >= card(index_set(piWeek))
};

array[index_set_1of2(piTimes)] of var 0..1: rf_port_choice;
array[index_set(piWeek),index_set_2of2(piTimes)] of var 0..1: rf_week_choice;

set of int: rf_window_starts =
    min(index_set_2of2(piTimes))..
    (max(index_set_2of2(piTimes))-card(index_set(piWeek))+1);
array[rf_window_starts] of var 0..1: rf_window_choice;

int: rf_largest_po_time = max([
    max(poTimes0),max(poTimes1),max(poTimes2),
    max(poTimes3),max(poTimes4),max(poTimes5),
    max(poTimes6),max(poTimes7),max(poTimes8)
]);
int: rf_largest_pi_time = max(array1d(piTimes));
array[index_set(piWeek)] of
    var (-88*rf_largest_po_time)..(88*rf_largest_pi_time): rf_hotel;

constraint sum(rf_port_choice) = 1;
constraint piPort =
    sum(rf_p in index_set(rf_port_choice))(
        rf_p * rf_port_choice[rf_p]
    );
constraint forall(rf_p in index_set(rf_port_choice)
                  where not (rf_p in rf_possible_ports))(
    rf_port_choice[rf_p] = 0
);

constraint sum(rf_window_choice) = 1;
constraint forall(rf_w in index_set_2of2(rf_week_choice))(
    sum(rf_v in index_set_1of2(rf_week_choice))(
        rf_week_choice[rf_v,rf_w]
    ) =
    sum(rf_s in index_set(rf_window_choice)
        where rf_s <= rf_w /\
              rf_w < rf_s + card(index_set(piWeek)))(
        rf_window_choice[rf_s]
    )
);

predicate rf_assignment(
    array[int,int,int] of int: rf_cost_table,
    array[int] of int: rf_po_times,
    var int: rf_activity,
    var int: rf_week_value,
    var int: rf_direct_value,
    var int: rf_hotel_value,
    array[int] of var int: rf_port_indicator,
    array[int] of var int: rf_week_indicator,
    int: rf_rate
) =
    let {
        array[int] of int: rf_tuple_a = [
            rf_a
            | rf_a in index_set_1of3(rf_cost_table),
              rf_p in index_set_2of3(rf_cost_table),
              rf_w in index_set_3of3(rf_cost_table)
            where rf_p in rf_possible_ports /\
                  rf_cost_table[rf_a,rf_p,rf_w] >= 0
        ],
        array[index_set(rf_tuple_a)] of int: rf_tuple_p = [
            rf_p
            | rf_a in index_set_1of3(rf_cost_table),
              rf_p in index_set_2of3(rf_cost_table),
              rf_w in index_set_3of3(rf_cost_table)
            where rf_p in rf_possible_ports /\
                  rf_cost_table[rf_a,rf_p,rf_w] >= 0
        ],
        array[index_set(rf_tuple_a)] of int: rf_tuple_w = [
            rf_w
            | rf_a in index_set_1of3(rf_cost_table),
              rf_p in index_set_2of3(rf_cost_table),
              rf_w in index_set_3of3(rf_cost_table)
            where rf_p in rf_possible_ports /\
                  rf_cost_table[rf_a,rf_p,rf_w] >= 0
        ],
        array[index_set(rf_tuple_a)] of var 0..1: rf_selected
    } in
    sum(rf_selected) = 1 /\
    rf_activity =
        sum(rf_t in index_set(rf_selected))(
            rf_tuple_a[rf_t] * rf_selected[rf_t]
        ) /\
    rf_week_value =
        sum(rf_t in index_set(rf_selected))(
            rf_tuple_w[rf_t] * rf_selected[rf_t]
        ) /\
    rf_direct_value =
        sum(rf_t in index_set(rf_selected))(
            rf_cost_table[
                rf_tuple_a[rf_t],rf_tuple_p[rf_t],rf_tuple_w[rf_t]
            ] * rf_selected[rf_t]
        ) /\
    rf_hotel_value =
        sum(rf_t in index_set(rf_selected))(
            rf_rate *
            (piTimes[rf_tuple_p[rf_t],rf_tuple_w[rf_t]] -
             rf_po_times[rf_tuple_a[rf_t]]) *
            rf_selected[rf_t]
        ) /\
    forall(rf_p in index_set(rf_port_indicator))(
        sum(rf_t in index_set(rf_selected)
            where rf_tuple_p[rf_t] = rf_p)(
            rf_selected[rf_t]
        ) = rf_port_indicator[rf_p]
    ) /\
    forall(rf_w in index_set(rf_week_indicator))(
        sum(rf_t in index_set(rf_selected)
            where rf_tuple_w[rf_t] = rf_w)(
            rf_selected[rf_t]
        ) = rf_week_indicator[rf_w]
    );

constraint rf_assignment(
    directCostArr0,poTimes0,poAct0,piWeek[1],directCost[1],rf_hotel[1],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[1,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    88
);
constraint rf_assignment(
    directCostArr1,poTimes1,poAct1,piWeek[2],directCost[2],rf_hotel[2],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[2,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    88
);
constraint rf_assignment(
    directCostArr2,poTimes2,poAct2,piWeek[3],directCost[3],rf_hotel[3],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[3,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    88
);
constraint rf_assignment(
    directCostArr3,poTimes3,poAct3,piWeek[4],directCost[4],rf_hotel[4],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[4,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    66
);
constraint rf_assignment(
    directCostArr4,poTimes4,poAct4,piWeek[5],directCost[5],rf_hotel[5],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[5,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    66
);
constraint rf_assignment(
    directCostArr5,poTimes5,poAct5,piWeek[6],directCost[6],rf_hotel[6],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[6,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    66
);
constraint rf_assignment(
    directCostArr6,poTimes6,poAct6,piWeek[7],directCost[7],rf_hotel[7],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[7,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    66
);
constraint rf_assignment(
    directCostArr7,poTimes7,poAct7,piWeek[8],directCost[8],rf_hotel[8],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[8,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    66
);
constraint rf_assignment(
    directCostArr8,poTimes8,poAct8,piWeek[9],directCost[9],rf_hotel[9],
    rf_port_choice,
    array1d(index_set_2of2(rf_week_choice),
        [rf_week_choice[9,rf_w] | rf_w in index_set_2of2(rf_week_choice)]),
    66
);

int: objectiveMax = ub(
    88 * (piTimes[piPort,piWeek[1]] - poTimes0[poAct0]) +
    88 * (piTimes[piPort,piWeek[2]] - poTimes1[poAct1]) +
    88 * (piTimes[piPort,piWeek[3]] - poTimes2[poAct2]) +
    66 * (piTimes[piPort,piWeek[4]] - poTimes3[poAct3]) +
    66 * (piTimes[piPort,piWeek[5]] - poTimes4[poAct4]) +
    66 * (piTimes[piPort,piWeek[6]] - poTimes5[poAct5]) +
    66 * (piTimes[piPort,piWeek[7]] - poTimes6[poAct6]) +
    66 * (piTimes[piPort,piWeek[8]] - poTimes7[poAct7]) +
    66 * (piTimes[piPort,piWeek[9]] - poTimes8[poAct8]) +
    sum(directCost)
);

var 0..objectiveMax: objective = sum(directCost) + sum(rf_hotel);

solve minimize objective;

output [
    "poAct0 = ",show(poAct0),";\n",
    "poAct1 = ",show(poAct1),";\n",
    "poAct2 = ",show(poAct2),";\n",
    "poAct3 = ",show(poAct3),";\n",
    "poAct4 = ",show(poAct4),";\n",
    "poAct5 = ",show(poAct5),";\n",
    "poAct6 = ",show(poAct6),";\n",
    "poAct7 = ",show(poAct7),";\n",
    "poAct8 = ",show(poAct8),";\n",
    "piPort = ",show(piPort),";\n",
    "piWeek = ",show(piWeek),";\n",
    "reposType = ",show(reposType),";\n",
    "directCost = ",show(directCost),";\n",
    "constraint objective = ",show(objective),";\n"
];
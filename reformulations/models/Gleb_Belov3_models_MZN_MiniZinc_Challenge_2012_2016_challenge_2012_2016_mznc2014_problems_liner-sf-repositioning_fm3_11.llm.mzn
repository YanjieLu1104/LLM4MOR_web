include "globals.mzn";

int: vv;
int: ww;
int: pip;
int: poPorts0;
int: poPorts1;
int: poPorts2;
int: poPorts3;
int: poPorts4;
int: sosActSize;
int: sosSize;
int: seActSize;

vv = 5;
ww = 11;
pip = 13;
poPorts0 = 16;
poPorts1 = 15;
poPorts2 = 27;
poPorts3 = 24;
poPorts4 = 3;
sosActSize = 10;
sosSize = 4;
seActSize = 1;

set of int: POPORTS0 = 0..poPorts0;
set of int: POPORTS1 = 0..poPorts1;
set of int: POPORTS2 = 0..poPorts2;
set of int: POPORTS3 = 0..poPorts3;
set of int: POPORTS4 = 0..poPorts4;
set of int: VESSELS = 1..vv;
set of int: WEEKS = 1..ww;
set of int: PIPORTS = 1..pip;
set of int: REPOSTYPES = 1..3;
set of int: SOSACTS = 0..sosActSize;
set of int: SOS = 0..sosSize;
set of int: SEACTS = 0..seActSize;

array[POPORTS0] of int: poTimes0 = array1d(POPORTS0,
[128,1304,160,1336,218,1394,244,1420,394,1570,762,937,1088,1160,1213,1416,1807]);
array[POPORTS1] of int: poTimes1 = array1d(POPORTS1,
[296,1472,328,1504,386,1562,412,1588,562,1738,930,1105,1256,1328,1381,1584]);
array[POPORTS2] of int: poTimes2 = array1d(POPORTS2,
[41,1553,132,1644,194,1706,221,1733,283,1795,344,421,464,552,579,593,967,1001,1216,1257,1316,1351,1377,1420,1457,1473,1567,1596]);
array[POPORTS3] of int: poTimes3 = array1d(POPORTS3,
[209,1721,300,1812,362,389,451,512,589,632,720,747,761,1135,1169,1384,1425,1484,1519,1545,1588,1625,1641,1735,1764]);
array[POPORTS4] of int: poTimes4 = array1d(POPORTS4,
[179,1355,270,1446]);

array[PIPORTS,WEEKS] of int: piTimes = array2d(PIPORTS,WEEKS,[
152,320,488,656,824,992,1160,1328,1496,1664,1832,
0,198,366,534,702,870,1038,1206,1374,1542,1710,
0,273,441,609,777,945,1113,1281,1449,1617,1785,
0,318,486,654,822,990,1158,1326,1494,1662,1830,
0,0,413,581,749,917,1085,1253,1421,1589,1757,
0,0,0,0,697,865,1033,1201,1369,1537,1705,
0,0,0,0,800,968,1136,1304,1472,1640,1808,
0,0,0,0,0,840,1008,1176,1344,1512,1680,
0,0,0,0,0,912,1080,1248,1416,1584,1752,
0,0,0,0,0,949,1117,1285,1453,1621,1789,
0,0,0,0,0,0,1147,1315,1483,1651,1819,
0,0,0,0,0,0,0,0,1471,1639,1807,
0,0,0,0,0,0,0,0,0,1580,1748
]);

array[VESSELS] of int: sailCoef =
array1d(VESSELS,[-1138,-1138,-1138,-1138,-1138]);
int: maxCost = 500000;

function array[int,int] of int: rf_pair(
    set of int: rf_pd, array[int] of int: rf_values
) =
array2d(rf_pd,SEACTS,[
    if rf_a = 0 then 0
    else rf_values[rf_i-min(rf_pd)+min(index_set(rf_values))]
    endif
    | rf_i in rf_pd, rf_a in SEACTS
]);

array[POPORTS0,SEACTS] of int: seBfixedArr0 = rf_pair(POPORTS0,
[114881,114881,62474,62474,149690,149690,121302,121302,303746,303746,938120,1147664,740359,729677,1208092,938120,303746]);
array[POPORTS1,SEACTS] of int: seBfixedArr1 = rf_pair(POPORTS1,
[114881,114881,62474,62474,149690,149690,121302,121302,303746,303746,938120,1147664,740359,729677,1208092,938120]);
array[POPORTS2,SEACTS] of int: seBfixedArr2 = rf_pair(POPORTS2,
[486990,486990,462874,462874,967530,967530,464948,464948,454969,454969,439043,1007509,464948,875165,872868,486990,325343,303746,0,22149,62380,64333,62474,96003,122311,149690,303746,325343]);
array[POPORTS3,SEACTS] of int: seBfixedArr3 = rf_pair(POPORTS3,
[486990,486990,462874,462874,967530,464948,454969,439043,1007509,464948,875165,872868,486990,325343,303746,0,22149,62380,64333,62474,96003,122311,149690,303746,325343]);
array[POPORTS4,SEACTS] of int: seBfixedArr4 = rf_pair(POPORTS4,
[992919,992919,1014976,1014976]);

array[POPORTS0,SEACTS] of int: maxBtimeArr0 = rf_pair(POPORTS0,
[100,100,54,54,130,130,105,105,264,264,816,999,644,635,1051,816,264]);
array[POPORTS1,SEACTS] of int: maxBtimeArr1 = rf_pair(POPORTS1,
[100,100,54,54,130,130,105,105,264,264,816,999,644,635,1051,816]);
array[POPORTS2,SEACTS] of int: maxBtimeArr2 = rf_pair(POPORTS2,
[423,423,402,402,842,842,404,404,396,396,382,877,404,761,759,423,283,264,0,19,54,56,54,83,106,130,264,283]);
array[POPORTS3,SEACTS] of int: maxBtimeArr3 = rf_pair(POPORTS3,
[423,423,402,402,842,404,396,382,877,404,761,759,423,283,264,0,19,54,56,54,83,106,130,264,283]);
array[POPORTS4,SEACTS] of int: maxBtimeArr4 = rf_pair(POPORTS4,
[864,864,883,883]);

array[POPORTS0,SEACTS] of int: minBtimeArr0 = rf_pair(POPORTS0,
[46,46,25,25,60,60,49,49,122,122,379,464,299,295,489,379,122]);
array[POPORTS1,SEACTS] of int: minBtimeArr1 = rf_pair(POPORTS1,
[46,46,25,25,60,60,49,49,122,122,379,464,299,295,489,379]);
array[POPORTS2,SEACTS] of int: minBtimeArr2 = rf_pair(POPORTS2,
[197,197,187,187,391,391,188,188,184,184,177,407,188,354,353,197,131,122,0,8,25,26,25,38,49,60,122,131]);
array[POPORTS3,SEACTS] of int: minBtimeArr3 = rf_pair(POPORTS3,
[197,197,187,187,391,188,184,177,407,188,354,353,197,131,122,0,8,25,26,25,38,49,60,122,131]);
array[POPORTS4,SEACTS] of int: minBtimeArr4 = rf_pair(POPORTS4,
[402,402,410,410]);

array[VESSELS,SEACTS] of int: seDfixedArr =
array2d(VESSELS,SEACTS,[771667*rf_a | rf_v in VESSELS, rf_a in SEACTS]);
array[VESSELS,SEACTS] of int: maxDtimeArr =
array2d(VESSELS,SEACTS,[694*rf_a | rf_v in VESSELS, rf_a in SEACTS]);
array[VESSELS,SEACTS] of int: minDtimeArr =
array2d(VESSELS,SEACTS,[322*rf_a | rf_v in VESSELS, rf_a in SEACTS]);

array[index_set_1of2(piTimes)] of int: rf_af =
array1d(index_set_1of2(piTimes),
[751209,505111,470308,664473,501342,78961,281114,272038,309605,312477,78961,501342,664473]);
array[index_set_1of2(piTimes)] of int: rf_au =
array1d(index_set_1of2(piTimes),
[653,439,409,578,436,68,244,236,269,272,68,436,578]);
array[index_set_1of2(piTimes)] of int: rf_al =
array1d(index_set_1of2(piTimes),
[304,204,190,269,202,31,113,110,125,126,31,202,269]);

array[VESSELS,PIPORTS,WEEKS,SEACTS] of int: seAfixedArr =
array4d(VESSELS,PIPORTS,WEEKS,SEACTS,[
    if rf_a = 0 then 0
    elseif piTimes[rf_p,rf_w] = 0 then -1
    else rf_af[rf_p] endif
    | rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SEACTS
]);
array[VESSELS,PIPORTS,WEEKS,SEACTS] of int: maxAtimeArr =
array4d(VESSELS,PIPORTS,WEEKS,SEACTS,[
    if rf_a = 0 \/ piTimes[rf_p,rf_w] = 0 then 0
    else rf_au[rf_p] endif
    | rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SEACTS
]);
array[VESSELS,PIPORTS,WEEKS,SEACTS] of int: minAtimeArr =
array4d(VESSELS,PIPORTS,WEEKS,SEACTS,[
    if rf_a = 0 \/ piTimes[rf_p,rf_w] = 0 then 0
    else rf_al[rf_p] endif
    | rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SEACTS
]);

array[SOSACTS] of int: sosIds =
array1d(SOSACTS,[0,1,1,1,2,2,2,3,3,4,4]);
array[index_set(sosIds)] of int: rf_savings =
array1d(index_set(sosIds),
[0,2107000,2079128,2115984,2095912,2068040,2104896,51430,33524,51430,33524]);
array[VESSELS,SOSACTS] of int: sosActSavingsArr =
array2d(VESSELS,SOSACTS,[rf_savings[rf_a] | rf_v in VESSELS, rf_a in SOSACTS]);

array[POPORTS0,SOSACTS] of int: sosSailCostBArr0 = array2d(POPORTS0,SOSACTS,[
0,1948,2146,3582,1948,2146,3582,3554,2146,3554,2146,
0,-1,-1,-1,-1,-1,-1,-1,2146,-1,2146,
0,2102,2083,2641,2102,2083,2641,3621,2083,3621,2083,
0,-1,-1,-1,-1,-1,-1,-1,17764,-1,2083,
0,1563,1761,23117,1563,1761,3197,3329,1761,3329,1761,
0,-1,-1,-1,-1,-1,-1,-1,48658,-1,1761,
0,1485,1453,2098,1485,1453,2098,3287,1453,3287,1453,
0,-1,-1,-1,-1,-1,-1,-1,44673,-1,1453,
0,0,265,60322,0,265,1701,3254,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,
0,-1,270229,-1,-1,78999,-1,4392,5694,4392,5694,
0,-1,-1,-1,-1,-1,-1,2896,166747,2896,7616,
0,-1,-1,-1,-1,-1,-1,155170,182786,3417,6186,
0,-1,-1,-1,-1,-1,-1,-1,239551,28473,48320,
0,-1,-1,-1,-1,-1,-1,-1,-1,75337,350108,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,311207,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);
array[POPORTS1,SOSACTS] of int: sosSailCostBArr1 = array2d(POPORTS1,SOSACTS,[
0,1948,2146,153835,1948,2146,3582,3554,2146,3554,2146,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,2146,
0,2102,2083,87698,2102,2083,2641,3621,2083,3621,2083,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,17764,
0,1563,1761,-1,1563,1761,23117,3329,1761,3329,1761,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,48658,
0,1485,1453,-1,1485,1453,2098,3287,1453,3287,1453,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,44673,
0,0,265,-1,0,265,60322,3254,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,-1,-1,-1,270229,-1,81618,5694,4392,5694,
0,-1,-1,-1,-1,-1,-1,117794,357977,2896,166747,
0,-1,-1,-1,-1,-1,-1,-1,-1,155170,182786,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,239551,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);
array[POPORTS2,SOSACTS] of int: sosSailCostBArr2 = array2d(POPORTS2,SOSACTS,[
0,4639,4469,3002,4639,4469,3002,1384,4469,1384,4469,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,4874,4703,3289,4874,4703,3289,1710,4703,1710,4703,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,120210,5934,203045,6155,5934,11814,1755,5934,1755,5934,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,14834,4736,40135,4907,4736,3322,1744,4736,1744,4736,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,90890,4788,119259,4957,4788,3401,1855,4788,1855,4788,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,153362,4725,184623,4893,4725,3363,1855,4725,1855,4725,
0,-1,6301,-1,227347,6301,310182,1859,6301,1859,6301,
0,-1,4736,-1,100205,4736,125506,1744,4736,1744,4736,
0,-1,5087,-1,244118,5087,-1,1418,5087,1418,5087,
0,-1,5066,-1,272554,5066,-1,1386,5066,1386,5066,
0,-1,4469,-1,217872,4469,-1,1384,4469,1384,4469,
0,-1,0,-1,-1,0,-1,3084,0,3084,0,
0,-1,265,-1,-1,265,-1,38428,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,2984,121996,2984,
0,-1,-1,-1,-1,-1,-1,-1,2434,147007,2434,
0,-1,-1,-1,-1,-1,-1,-1,80498,-1,2868,
0,-1,-1,-1,-1,-1,-1,-1,86448,-1,2557,
0,-1,-1,-1,-1,-1,-1,-1,64434,-1,2083,
0,-1,-1,-1,-1,-1,-1,-1,87956,-1,1850,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,1449,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,1761,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,0
]);
array[POPORTS3,SOSACTS] of int: sosSailCostBArr3 = array2d(POPORTS3,SOSACTS,[
0,4639,4469,3002,4639,4469,3002,1384,4469,1384,4469,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,101172,4703,126387,4874,4703,3289,1710,4703,1710,4703,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,311441,5934,-1,120210,5934,203045,1755,5934,1755,5934,
0,206064,4736,-1,14834,4736,40135,1744,4736,1744,4736,
0,282121,4788,-1,90890,4788,119259,1855,4788,1855,4788,
0,-1,4725,-1,153362,4725,184623,1855,4725,1855,4725,
0,-1,139479,-1,-1,6301,-1,1859,6301,1859,6301,
0,-1,17884,-1,-1,4736,-1,1744,4736,1744,4736,
0,-1,156250,-1,-1,5087,-1,1418,5087,1418,5087,
0,-1,184686,-1,-1,5066,-1,1386,5066,1386,5066,
0,-1,135572,-1,-1,4469,-1,1384,4469,1384,4469,
0,-1,-1,-1,-1,0,-1,172412,0,3084,0,
0,-1,-1,-1,-1,265,-1,-1,265,38428,265,
0,-1,-1,-1,-1,-1,-1,-1,170538,-1,2984,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,2434,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,80498,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,86448,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,64434,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,87956,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);
array[POPORTS4,SOSACTS] of int: sosSailCostBArr4 = array2d(POPORTS4,SOSACTS,[
0,636760,212153,-1,445530,20923,-1,7922,11248,7922,11248,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,331475,-1,564852,140245,-1,7991,11392,7991,11392,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);
array[VESSELS,PIPORTS,WEEKS,SOSACTS] of int: sosSailCostAArr =
array4d(VESSELS,PIPORTS,WEEKS,SOSACTS,[
    if rf_a = 0 then 0 else -1 endif
    | rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SOSACTS
]);

function array[int,int,int] of int: rf_decode(
    set of int: rf_po_domain,
    array[int] of int: rf_code
) =
let {
    array[int] of int: rf_marks =
        [rf_j | rf_j in index_set(rf_code) where rf_code[rf_j] < 0]
        ++ [max(index_set(rf_code))+1];
    constraint assert(
        length(rf_marks) = card(rf_po_domain)*card(PIPORTS)+1,
        "Invalid fixed cost encoding"
    );
} in
array3d(rf_po_domain,PIPORTS,WEEKS,[
    let {
        int: rf_row = (rf_i-min(rf_po_domain))*card(PIPORTS)
                     + rf_p-min(PIPORTS)+1;
        int: rf_begin = rf_marks[rf_row];
        int: rf_first = -rf_code[rf_begin];
    } in
    if rf_w < rf_first then -1
    else rf_code[min(rf_marks[rf_row+1]-1,rf_begin+rf_w-rf_first+1)]
    endif
    | rf_i in rf_po_domain, rf_p in PIPORTS, rf_w in WEEKS
]);

array[POPORTS0,PIPORTS,WEEKS] of int: directCostArr0;
directCostArr0 = rf_decode(POPORTS0,[
-1,23229,463,
-2,271,
-2,391,
-2,488,
-3,1948,
-5,4713,
-5,211799,20568,8958,
-6,157192,8875,
-6,112802,9219,
-6,73558,9246,
-7,4713,
-9,1948,
-10,488,

-8,23229,463,
-9,271,
-9,391,
-8,28262,488,
-9,79237,1948,
-10,248658,57428,
-11,403029,
-12,
-11,495263,
-11,456019,
-10,118895,4713,
-9,22323,1948,
-10,488,

-2,85,
-2,0,
-2,638,
-2,619,
-3,2102,
-5,4714,
-5,5835,
-6,5662,
-6,6165,
-6,6177,
-7,4714,
-9,2102,
-10,619,

-9,85,
-9,0,
-9,638,
-9,619,
-10,2102,
-11,93968,
-10,290176,98945,
-11,225836,
-11,198654,
-10,349090,157860,
-10,155435,4714,
-9,75519,2102,
-10,619,

-2,873,
-3,619,
-2,42,
-2,0,
-3,1563,
-5,4556,
-5,272312,81082,8573,
-6,217705,26475,8490,
-6,173316,8835,
-6,134071,8861,
-7,4556,
-9,1563,
-10,0,

-9,873,
-10,619,
-9,42,
-9,0,
-10,1563,
-11,142748,
-11,463542,
-12,
-12,
-11,516532,
-10,204215,12984,
-9,82836,1563,
-10,0,

-2,695,
-3,638,
-2,0,
-2,42,
-3,1485,
-5,4514,
-5,5855,
-6,5687,
-6,6185,
-6,6195,
-7,4514,
-9,1485,
-10,42,

-9,695,
-10,638,
-9,0,
-9,42,
-10,1485,
-11,167843,
-11,196816,
-11,324158,
-11,296447,
-11,255452,
-10,229310,38080,
-10,1485,
-10,42,

-4,2359,
-4,69828,2102,
-4,1485,
-3,65762,1563,
-3,0,
-5,160959,4639,
-5,309517,118287,7077,
-6,254910,63680,6994,
-6,210521,19290,7338,
-6,171277,7365,
-7,4639,
-9,0,
-10,1563,

-11,2359,
-11,69828,
-11,1485,
-10,65762,1563,
-10,0,
-12,
-12,
-12,
-12,
-12,
-11,222426,
-10,0,
-11,1563,

-7,425233,234003,42772,8055,
-8,296944,105713,7358,
-7,336123,144893,6747,
-7,344451,153220,7293,
-7,279922,88692,5939,
-7,149921,4204,
-7,198779,7549,5727,
-8,168183,5864,
-7,221395,30165,5350,
-7,172845,5291,
-7,20157,4204,
-9,5939,
-10,7293,

-9,451514,260284,69053,
-9,212546,21316,6511,
-8,275208,83978,6115,
-9,370732,179501,9215,
-9,306203,114973,7861,
-7,122021,2121,
-7,228757,37527,4175,
-8,198161,6930,4312,
-8,62555,3820,
-7,202824,11593,3739,
-7,2121,
-9,249289,58059,7861,
-10,272840,81609,

-9,295210,103979,6967,
-10,246681,55450,
-9,320068,128837,6704,
-9,273436,82205,6746,
-9,311533,120303,6333,
-8,124868,2325,
-8,2103,
-9,2214,
-8,30334,1948,
-8,1934,
-8,2325,
-9,254619,63389,6333,
-10,175544,6746,

-9,363050,171820,6837,
-10,313952,122722,
-9,383612,192381,6535,
-9,336967,145737,6577,
-10,176739,6099,
-9,7324,2249,
-8,80703,2243,
-9,45688,2340,
-9,2120,
-8,87517,2107,
-8,68791,2249,
-9,311056,119825,6099,
-10,239075,47845,

-11,443645,
-10,361762,170532,
-10,237883,46652,
-10,554093,362863,
-10,489565,298334,
-9,61308,2190,
-9,135531,3947,
-10,104935,4084,
-9,160560,3592,
-9,109598,3510,
-8,122775,2190,
-10,432651,241420,
-11,456201,

-11,404744,
-12,
-11,315634,
-11,323962,
-11,259433,
-11,129432,
-11,178290,
-11,338924,
-11,200906,
-11,152356,
-10,190899,4204,
-11,202519,
-11,417300,

-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-11,0,
-12
]);

array[POPORTS1,PIPORTS,WEEKS] of int: directCostArr1;
directCostArr1 = rf_decode(POPORTS1,[
-2,23229,463,
-3,271,
-3,391,
-2,28262,488,
-3,79237,1948,
-5,57428,4713,
-5,403029,211799,20568,8958,
-6,348423,157192,8875,
-6,304033,112802,9219,
-6,264789,73558,9246,
-7,4713,
-9,1948,
-10,488,

-9,23229,463,
-10,271,
-10,391,
-9,28262,488,
-10,79237,1948,
-11,248658,
-12,
-12,
-12,
-12,
-11,118895,
-10,22323,1948,
-10,488,

-3,85,
-3,0,
-3,638,
-3,619,
-4,2102,
-5,93968,4714,
-5,98945,5835,
-6,34605,5662,
-6,7424,6165,
-6,6177,
-7,4714,
-9,2102,
-10,619,

-10,85,
-10,0,
-10,638,
-10,619,
-11,2102,
-12,
-11,290176,
-12,
-12,
-11,349090,
-11,155435,
-10,75519,2102,
-10,619,

-3,873,
-4,619,
-3,42,
-3,0,
-4,1563,
-5,142748,4556,
-5,463542,272312,81082,8573,
-6,408936,217705,26475,8490,
-6,364546,173316,8835,
-6,325302,134071,8861,
-7,4556,
-9,1563,
-10,0,

-10,873,
-11,619,
-10,42,
-10,0,
-11,1563,
-12,
-12,
-12,
-12,
-12,
-11,204215,
-10,82836,1563,
-10,0,

-3,695,
-4,638,
-3,0,
-3,42,
-4,1485,
-5,167843,4514,
-5,196816,5855,
-6,132927,5687,
-6,105217,6185,
-6,64222,6195,
-7,4514,
-9,1485,
-10,42,

-10,695,
-11,638,
-10,0,
-10,42,
-11,1485,
-12,
-12,
-12,
-12,
-12,
-11,229310,
-11,1485,
-11,42,

-5,2359,
-5,69828,2102,
-5,1485,
-4,65762,1563,
-4,0,
-6,160959,4639,
-6,309517,118287,7077,
-7,254910,63680,6994,
-6,401751,210521,19290,7338,
-6,362507,171277,7365,
-7,4639,
-9,0,
-10,1563,

-12,
-12,
-12,
-11,65762,
-11,0,
-12,
-12,
-12,
-12,
-12,
-12,
-11,0,
-12,

-8,425233,234003,42772,8055,
-9,296944,105713,7358,
-8,336123,144893,6747,
-8,344451,153220,7293,
-8,279922,88692,5939,
-8,149921,4204,
-8,198779,7549,5727,
-9,168183,5864,
-8,221395,30165,5350,
-8,172845,5291,
-7,211388,20157,4204,
-9,31778,5939,
-10,55328,7293,

-10,451514,260284,
-10,212546,21316,
-9,275208,83978,6115,
-10,370732,179501,
-10,306203,114973,
-8,122021,2121,
-8,228757,37527,4175,
-9,198161,6930,4312,
-9,62555,3820,
-8,202824,11593,3739,
-8,2121,
-9,440520,249289,58059,
-10,464070,272840,

-10,295210,103979,
-11,246681,
-10,320068,128837,
-10,273436,82205,
-10,311533,120303,
-9,124868,2325,
-9,2103,
-10,2214,
-9,30334,1948,
-9,1934,
-9,2325,
-10,254619,63389,
-10,366774,175544,

-10,363050,171820,
-11,313952,
-10,383612,192381,
-10,336967,145737,
-11,176739,
-10,7324,2249,
-9,80703,2243,
-10,45688,2340,
-10,2120,
-9,87517,2107,
-9,68791,2249,
-10,311056,119825,
-11,239075,

-12,
-11,361762,
-11,237883,
-11,554093,
-11,489565,
-10,61308,2190,
-10,135531,3947,
-11,104935,
-10,160560,3592,
-10,109598,3510,
-9,122775,2190,
-11,432651,
-12,

-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-11,190899,
-12,
-12
]);

array[POPORTS2,PIPORTS,WEEKS] of int: directCostArr2;
directCostArr2 = rf_decode(POPORTS2,[
-2,191683,4670,
-3,144052,4714,
-2,228172,36941,4514,
-2,181449,4556,
-3,82418,4639,
-5,0,
-5,1761,
-6,1661,
-6,2006,
-6,2008,
-7,0,
-9,4639,
-10,4556,

-11,191683,
-12,
-11,228172,
-11,181449,
-12,
-11,0,
-10,92987,1761,
-11,36573,
-11,2006,
-11,2008,
-10,0,
-11,216734,
-12,

-3,87985,4523,
-3,232913,41682,4579,
-3,137967,4491,
-3,91004,4530,
-3,211585,20354,4874,
-5,626,
-5,1449,
-6,1307,
-6,1754,
-6,1761,
-7,626,
-9,4874,
-10,4530,

-12,
-12,
-12,
-12,
-12,
-11,626,
-11,1449,
-12,
-11,68370,
-11,27021,
-11,626,
-12,
-12,

-4,395119,203889,12659,8447,
-4,116111,4614,
-3,212908,21678,4531,
-4,310661,119430,7651,
-4,230623,39393,6155,
-5,649,
-5,1614,
-6,1526,
-6,1908,
-6,1924,
-7,649,
-9,6155,
-10,7651,

-12,
-12,
-12,
-12,
-12,
-12,
-11,59893,
-12,
-12,
-12,
-11,649,
-12,
-12,

-3,191711,4545,
-4,145460,4601,
-3,242204,50973,4518,
-3,195231,4557,
-4,125247,4907,
-5,647,
-5,1417,
-6,1273,
-6,1723,
-6,1730,
-7,647,
-9,4907,
-10,4557,

-12,
-12,
-12,
-12,
-12,
-12,
-11,69177,
-12,
-12,
-12,
-11,647,
-12,
-12,

-3,254621,63391,4475,
-4,208745,17515,4535,
-4,118175,4487,
-3,262325,71095,4525,
-4,201303,10072,4957,
-5,845,
-5,1393,
-6,1236,
-6,1713,
-6,1721,
-7,845,
-9,4957,
-10,4525,

-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,

-4,117863,4338,
-5,72155,4399,
-4,174856,4370,
-4,127709,4407,
-4,263775,72545,4893,
-5,963,
-5,1492,
-6,1329,
-6,1818,
-6,1827,
-7,963,
-9,4893,
-10,4407,

-5,502256,311026,119796,8814,
-5,159129,4393,
-5,70775,4365,
-5,417798,226567,35337,8018,
-5,337760,146530,6522,
-5,972,
-5,1987,
-6,1830,
-6,2273,
-6,2286,
-7,972,
-9,6522,
-10,8018,

-5,85851,4545,
-5,230831,39600,4601,
-5,136344,4518,
-5,89372,4557,
-5,210618,19387,4907,
-5,647,
-5,1417,
-6,1273,
-6,1723,
-6,1730,
-7,647,
-9,4907,
-10,4557,

-6,327797,136566,7600,
-6,154289,4735,
-5,238908,47678,4540,
-6,243338,52108,6804,
-6,163301,5308,
-5,35,
-5,1769,
-6,1685,
-6,2030,
-6,2056,
-7,35,
-9,5308,
-10,6804,

-6,356233,165002,7579,
-6,182624,4713,
-6,75592,4514,
-6,271774,80543,6783,
-6,191737,5287,
-5,4,
-5,1790,
-6,1706,
-6,2051,
-6,2077,
-7,4,
-9,5287,
-10,6783,

-5,246320,55090,4670,
-6,198690,7459,4714,
-6,91579,4514,
-5,236086,44856,4556,
-6,137055,4639,
-5,0,
-5,1761,
-6,1661,
-6,2006,
-6,2008,
-7,0,
-9,4639,
-10,4556,

-7,59129,2557,
-8,2083,
-7,1453,
-7,1761,
-7,265,
-8,220943,29712,4469,
-8,363933,172703,6856,
-9,309326,118096,6773,
-9,264937,73706,7117,
-8,416923,225693,34462,7143,
-8,91179,4469,
-9,265,
-10,1761,

-7,76233,2359,
-8,2102,
-7,34452,1485,
-7,1563,
-7,0,
-9,86971,4639,
-9,235529,44299,7077,
-9,372153,180922,6994,
-9,327763,136533,7338,
-9,288519,97289,7365,
-8,148438,4639,
-9,0,
-10,1563,

-8,590,
-9,573,
-8,47314,1112,
-8,24479,1372,
-9,70399,2785,
-10,121603,4466,
-11,394192,
-11,530815,
-11,486426,
-11,447181,
-9,183070,4466,
-9,13485,2785,
-10,1372,

-8,506,
-9,588,
-9,1023,
-8,33482,1027,
-9,84664,2488,
-10,149151,4291,
-10,140508,5287,
-10,267376,76146,
-10,239996,48766,
-10,199258,8028,
-9,210618,19388,4291,
-9,27750,2488,
-10,1027,

-9,517,
-9,519,
-9,1157,
-9,1210,
-10,2670,
-10,283727,92497,
-11,495382,
-12,
-12,
-11,548372,
-10,153964,4909,
-9,114676,2670,
-10,1210,

-9,0,
-9,85,
-9,695,
-9,873,
-10,2359,
-11,106312,
-11,501332,
-12,
-12,
-11,554322,
-10,167779,4670,
-9,120626,2359,
-10,873,

-9,85,
-10,0,
-9,638,
-9,619,
-10,2102,
-11,140638,
-10,336845,145615,
-11,272505,
-11,245324,
-11,204529,
-10,202104,10874,
-9,122189,2102,
-10,619,

-9,392,
-10,307,
-9,19108,478,
-9,443,
-10,9511,1851,
-11,204742,
-11,219437,
-12,
-11,319244,
-11,278389,
-10,266209,74978,
-10,1851,
-10,443,

-9,31723,698,
-10,638,
-10,25,
-9,22,
-10,10929,1478,
-11,212594,
-11,241663,
-12,
-11,341295,
-11,300301,
-11,82830,
-10,1478,
-10,22,

-10,873,
-10,619,
-10,42,
-9,0,
-10,38443,1563,
-11,232672,
-12,
-12,
-12,
-12,
-11,102908,
-10,1563,
-10,0,

-11,2359,
-11,66413,
-11,1485,
-10,62347,1563,
-10,0,
-12,
-12,
-12,
-12,
-12,
-11,219011,
-10,0,
-11,1563,

-11,10183,
-11,97444,
-11,1453,
-11,1761,
-11,265,
-12,
-12,
-12,
-12,
-12,
-11,233464,
-10,265,
-11,19063
]);

array[POPORTS3,PIPORTS,WEEKS] of int: directCostArr3;
directCostArr3 = rf_decode(POPORTS3,[
-3,191683,4670,
-4,144052,4714,
-3,228172,36941,4514,
-3,181449,4556,
-4,82418,4639,
-5,0,
-5,1761,
-6,1661,
-6,2006,
-6,2008,
-7,0,
-9,4639,
-10,4556,

-12,
-12,
-12,
-12,
-12,
-12,
-11,92987,
-12,
-12,
-12,
-11,0,
-12,
-12,

-4,87985,4523,
-4,232913,41682,4579,
-4,137967,4491,
-4,91004,4530,
-4,211585,20354,4874,
-5,626,
-5,1449,
-6,1307,
-6,1754,
-6,1761,
-7,626,
-9,4874,
-10,4530,

-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,

-5,395119,203889,12659,8447,
-5,116111,4614,
-4,212908,21678,4531,
-5,310661,119430,7651,
-5,230623,39393,6155,
-5,649,
-5,1614,
-6,1526,
-6,1908,
-6,1924,
-7,649,
-9,6155,
-10,7651,

-4,191711,4545,
-5,145460,4601,
-4,242204,50973,4518,
-4,195231,4557,
-5,125247,4907,
-5,647,
-5,1417,
-6,1273,
-6,1723,
-6,1730,
-7,647,
-9,4907,
-10,4557,

-4,254621,63391,4475,
-5,208745,17515,4535,
-5,118175,4487,
-4,262325,71095,4525,
-5,201303,10072,4957,
-5,845,
-5,1393,
-6,1236,
-6,1713,
-6,1721,
-7,845,
-9,4957,
-10,4525,

-5,117863,4338,
-6,72155,4399,
-5,174856,4370,
-5,127709,4407,
-5,263775,72545,4893,
-5,963,
-5,1492,
-6,1329,
-6,1818,
-6,1827,
-7,963,
-9,4893,
-10,4407,

-6,502256,311026,119796,8814,
-6,159129,4393,
-6,70775,4365,
-6,417798,226567,35337,8018,
-6,337760,146530,6522,
-5,972,
-5,1987,
-6,1830,
-6,2273,
-6,2286,
-7,972,
-9,6522,
-10,8018,

-6,85851,4545,
-6,230831,39600,4601,
-6,136344,4518,
-6,89372,4557,
-6,210618,19387,4907,
-5,647,
-5,1417,
-6,1273,
-6,1723,
-6,1730,
-7,647,
-9,4907,
-10,4557,

-7,327797,136566,7600,
-7,154289,4735,
-6,238908,47678,4540,
-7,243338,52108,6804,
-7,163301,5308,
-6,35,
-5,101823,1769,
-6,47216,1685,
-6,2827,2030,
-6,2056,
-7,35,
-9,5308,
-10,6804,

-7,356233,165002,7579,
-7,182624,4713,
-7,75592,4514,
-7,271774,80543,6783,
-7,191737,5287,
-6,4,
-6,1790,
-6,80248,1706,
-6,35858,2051,
-6,2077,
-7,4,
-9,5287,
-10,6783,

-6,246320,55090,4670,
-7,198690,7459,4714,
-7,91579,4514,
-6,236086,44856,4556,
-7,137055,4639,
-6,0,
-6,1761,
-6,91210,1661,
-6,46854,2006,
-6,4998,2008,
-7,0,
-9,4639,
-10,4556,

-8,59129,2557,
-9,2083,
-8,1453,
-8,1761,
-8,265,
-9,220943,29712,4469,
-9,363933,172703,6856,
-10,309326,118096,
-10,264937,73706,
-9,416923,225693,34462,
-9,91179,4469,
-9,265,
-10,1761,

-8,76233,2359,
-9,2102,
-8,34452,1485,
-8,1563,
-8,0,
-10,86971,4639,
-10,235529,44299,
-10,372153,180922,
-10,327763,136533,
-10,288519,97289,
-9,148438,4639,
-9,0,
-10,1563,

-9,590,
-10,573,
-9,47314,1112,
-9,24479,1372,
-10,70399,2785,
-11,121603,
-12,
-12,
-12,
-12,
-10,183070,4466,
-10,13485,2785,
-10,1372,

-9,506,
-10,588,
-10,1023,
-9,33482,1027,
-10,84664,2488,
-11,149151,
-11,140508,
-11,267376,
-11,239996,
-11,199258,
-10,210618,19388,
-10,27750,2488,
-10,1027,

-10,517,
-10,519,
-10,1157,
-10,1210,
-11,2670,
-11,283727,
-12,
-12,
-12,
-12,
-11,153964,
-10,114676,2670,
-10,22724,1210,

-10,0,
-10,85,
-10,695,
-10,873,
-11,2359,
-12,
-12,
-12,
-12,
-12,
-11,167779,
-10,120626,2359,
-10,25801,873,

-10,85,
-11,0,
-10,638,
-10,619,
-11,2102,
-12,
-11,336845,
-12,
-12,
-12,
-11,202104,
-10,122189,2102,
-10,27713,619,

-10,392,
-11,307,
-10,19108,478,
-10,443,
-11,9511,
-12,
-12,
-12,
-12,
-12,
-11,266209,
-11,1851,
-11,443,

-10,31723,698,
-11,638,
-11,25,
-10,22,
-11,10929,
-12,
-12,
-12,
-12,
-12,
-12,
-11,1478,
-11,22,

-11,873,
-11,619,
-11,42,
-10,0,
-11,38443,
-12,
-12,
-12,
-12,
-12,
-12,
-11,1563,
-11,0,

-12,
-12,
-12,
-11,62347,
-11,0,
-12,
-12,
-12,
-12,
-12,
-12,
-11,0,
-12,

-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-11,265,
-12
]);

array[POPORTS4,PIPORTS,WEEKS] of int: directCostArr4;
directCostArr4 = rf_decode(POPORTS4,[
-4,443068,251838,60607,9043,
-5,345148,153918,8625,
-4,517266,326036,134806,9233,
-4,516226,324996,133766,9693,
-5,555942,364712,173482,11049,
-5,125864,6562,
-5,513629,322399,131168,11194,
-6,483147,291917,100687,11332,
-6,342717,151487,10796,
-6,298303,107073,10774,
-7,6562,
-9,11049,
-10,9693,

-11,443068,
-12,
-11,517266,
-11,516226,
-12,
-11,317094,
-12,
-12,
-12,
-12,
-10,378561,187331,
-12,
-12,

-5,377593,186362,9247,
-5,487603,296372,105142,8982,
-5,468332,277101,85871,9588,
-5,454657,263427,72196,9933,
-6,484034,292803,101573,11194,
-5,234772,43541,6611,
-5,592398,401167,209937,18707,10966,
-6,561916,370686,179455,11104,
-6,421486,230255,39025,10568,
-6,377072,185841,10547,
-7,6611,
-9,11194,
-10,9933,

-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-12,
-11,296239,
-12,
-12
]);

int: seBfixedMax = max([
max(array1d(seBfixedArr0)),max(array1d(seBfixedArr1)),
max(array1d(seBfixedArr2)),max(array1d(seBfixedArr3)),
max(array1d(seBfixedArr4))]);
int: seDfixedMax = max(array1d(seDfixedArr));
int: seAfixedMax = max(array1d(seAfixedArr));
int: sosActBCostMax = max([
max(array1d(sosSailCostBArr0)),max(array1d(sosSailCostBArr1)),
max(array1d(sosSailCostBArr2)),max(array1d(sosSailCostBArr3)),
max(array1d(sosSailCostBArr4))]);
int: sosActACostMax = max(array1d(sosSailCostAArr));
int: sosActSavingsMax = max(array1d(sosActSavingsArr));
int: directCostMax = max([
max(array1d(directCostArr0)),max(array1d(directCostArr1)),
max(array1d(directCostArr2)),max(array1d(directCostArr3)),
max(array1d(directCostArr4))]);

var POPORTS0: poAct0;
var POPORTS1: poAct1;
var POPORTS2: poAct2;
var POPORTS3: poAct3;
var POPORTS4: poAct4;
var PIPORTS: piPort;
array[VESSELS] of var WEEKS: piWeek;
array[VESSELS] of var REPOSTYPES: reposType;
array[VESSELS] of var SOSACTS: sosAct;
array[VESSELS] of var SOS: sos;
array[VESSELS] of var 0..sosActSavingsMax: sosActSavings;
array[VESSELS] of var SEACTS: seAct;
array[VESSELS] of var 0..seBfixedMax: seBfixed;
array[VESSELS] of var 0..3000: seBdur;
array[VESSELS] of var 0..seDfixedMax: seDfixed;
array[VESSELS] of var 0..3000: seDdur;
array[VESSELS] of var 0..seAfixedMax: seAfixed;
array[VESSELS] of var 0..3000: seAdur;
array[VESSELS] of var 0..directCostMax: directCost;
array[VESSELS] of var 0..sosActBCostMax: sosActBCost;
array[VESSELS] of var 0..sosActACostMax: sosActACost;

array[index_set_1of2(piTimes)] of var 0..1: rf_port_selected;
array[index_set(piWeek),index_set_2of2(piTimes)] of var 0..1: rf_week_selected;
set of int: rf_starts =
min(index_set_2of2(piTimes))..
(max(index_set_2of2(piTimes))-length(piWeek)+1);
array[rf_starts] of var 0..1: rf_start_selected;
array[index_set(piWeek)] of var 0..max(array1d(piTimes)): rf_elapsed;

constraint sum(rf_port_selected) = 1;
constraint piPort =
sum(rf_p in index_set(rf_port_selected))(rf_p*rf_port_selected[rf_p]);

constraint sum(rf_start_selected) = 1;
constraint forall(rf_w in index_set_2of2(rf_week_selected))(
    sum(rf_v in index_set_1of2(rf_week_selected))(rf_week_selected[rf_v,rf_w])
    =
    sum(rf_s in index_set(rf_start_selected)
        where rf_s <= rf_w /\ rf_w < rf_s+length(piWeek))
        (rf_start_selected[rf_s])
);
constraint forall(rf_v in index_set(piWeek))(
    sum(rf_w in index_set_2of2(rf_week_selected))(rf_week_selected[rf_v,rf_w]) = 1
    /\
    piWeek[rf_v] =
    sum(rf_w in index_set_2of2(rf_week_selected))
        (rf_w*rf_week_selected[rf_v,rf_w])
);

constraint forall(rf_v in VESSELS)(
    sosAct[rf_v] = 0 /\
    sos[rf_v] = 0 /\
    sosActSavings[rf_v] = 0 /\
    sosActBCost[rf_v] = 0 /\
    sosActACost[rf_v] = 0 /\
    reposType[rf_v] = 1+2*seAct[rf_v]
);
constraint sum(seAct) <= 1;

predicate rf_vessel(
    int: rf_vessel_id,
    var int: rf_po_choice,
    array[int] of int: rf_po_times,
    array[int,int,int] of int: rf_direct,
    array[int,int] of int: rf_bfixed,
    array[int,int] of int: rf_bmin,
    array[int,int] of int: rf_bmax
) =
let {
    set of int: rf_qpo = index_set_1of3(rf_direct);
    set of int: rf_qpi = index_set_2of3(rf_direct);
    set of int: rf_qweek = index_set_3of3(rf_direct);
    int: rf_np = card(rf_qpi);
    int: rf_nw = card(rf_qweek);
    int: rf_na = card(SEACTS);
    array[int] of int: rf_candidates = [
        (((rf_i-min(rf_qpo))*rf_np + rf_p-min(rf_qpi))*rf_nw
            + rf_w-min(rf_qweek))*rf_na + rf_a-min(SEACTS)
        | rf_i in rf_qpo, rf_p in rf_qpi, rf_w in rf_qweek, rf_a in SEACTS
        where
        piTimes[rf_p,rf_w] >= rf_po_times[rf_i] /\
        (
            (rf_a = 0 /\ rf_direct[rf_i,rf_p,rf_w] >= 0)
            \/
            (rf_a > 0 /\
             rf_bfixed[rf_i,rf_a] >= 0 /\
             seDfixedArr[rf_vessel_id,rf_a] >= 0 /\
             seAfixedArr[rf_vessel_id,rf_p,rf_w,rf_a] >= 0 /\
             rf_bmin[rf_i,rf_a] + minDtimeArr[rf_vessel_id,rf_a]
                + minAtimeArr[rf_vessel_id,rf_p,rf_w,rf_a]
                <= piTimes[rf_p,rf_w]-rf_po_times[rf_i])
        )
    ];
    set of int: rf_options = index_set(rf_candidates);
    array[rf_options] of int: rf_opo = array1d(rf_options,[
        rf_candidates[rf_k] div (rf_na*rf_nw*rf_np)+min(rf_qpo)
        | rf_k in rf_options
    ]);
    array[rf_options] of int: rf_opi = array1d(rf_options,[
        (rf_candidates[rf_k] div (rf_na*rf_nw)) mod rf_np+min(rf_qpi)
        | rf_k in rf_options
    ]);
    array[rf_options] of int: rf_oweek = array1d(rf_options,[
        (rf_candidates[rf_k] div rf_na) mod rf_nw+min(rf_qweek)
        | rf_k in rf_options
    ]);
    array[rf_options] of int: rf_oact = array1d(rf_options,[
        rf_candidates[rf_k] mod rf_na+min(SEACTS)
        | rf_k in rf_options
    ]);
    array[rf_options] of int: rf_ogap = array1d(rf_options,[
        piTimes[rf_opi[rf_k],rf_oweek[rf_k]]-rf_po_times[rf_opo[rf_k]]
        | rf_k in rf_options
    ]);
    array[rf_options] of int: rf_ototal = array1d(rf_options,[
        if rf_oact[rf_k] = 0 then 0
        else min(
            rf_bmax[rf_opo[rf_k],rf_oact[rf_k]]
            +maxDtimeArr[rf_vessel_id,rf_oact[rf_k]]
            +maxAtimeArr[rf_vessel_id,rf_opi[rf_k],rf_oweek[rf_k],rf_oact[rf_k]],
            rf_ogap[rf_k]
        ) endif
        | rf_k in rf_options
    ]);
    array[rf_options] of var 0..1: rf_choose;
} in
    sum(rf_choose) = 1
    /\
    rf_po_choice = sum(rf_k in rf_options)(rf_opo[rf_k]*rf_choose[rf_k])
    /\
    forall(rf_p in rf_qpi)(
        sum(rf_k in rf_options where rf_opi[rf_k] = rf_p)(rf_choose[rf_k])
        = rf_port_selected[rf_p]
    )
    /\
    forall(rf_w in rf_qweek)(
        sum(rf_k in rf_options where rf_oweek[rf_k] = rf_w)(rf_choose[rf_k])
        = rf_week_selected[rf_vessel_id,rf_w]
    )
    /\
    seAct[rf_vessel_id] =
        sum(rf_k in rf_options)(rf_oact[rf_k]*rf_choose[rf_k])
    /\
    rf_elapsed[rf_vessel_id] =
        sum(rf_k in rf_options)(rf_ogap[rf_k]*rf_choose[rf_k])
    /\
    directCost[rf_vessel_id] =
        sum(rf_k in rf_options where rf_oact[rf_k] = 0)(
            rf_direct[rf_opo[rf_k],rf_opi[rf_k],rf_oweek[rf_k]]*rf_choose[rf_k]
        )
    /\
    seBfixed[rf_vessel_id] =
        sum(rf_k in rf_options)(
            rf_bfixed[rf_opo[rf_k],rf_oact[rf_k]]*rf_choose[rf_k]
        )
    /\
    seDfixed[rf_vessel_id] =
        sum(rf_k in rf_options)(
            seDfixedArr[rf_vessel_id,rf_oact[rf_k]]*rf_choose[rf_k]
        )
    /\
    seAfixed[rf_vessel_id] =
        sum(rf_k in rf_options)(
            seAfixedArr[rf_vessel_id,rf_opi[rf_k],rf_oweek[rf_k],rf_oact[rf_k]]
            *rf_choose[rf_k]
        )
    /\
    seBdur[rf_vessel_id] >=
        sum(rf_k in rf_options)(
            rf_bmin[rf_opo[rf_k],rf_oact[rf_k]]*rf_choose[rf_k]
        )
    /\
    seBdur[rf_vessel_id] <=
        sum(rf_k in rf_options)(
            rf_bmax[rf_opo[rf_k],rf_oact[rf_k]]*rf_choose[rf_k]
        )
    /\
    seDdur[rf_vessel_id] >=
        sum(rf_k in rf_options)(
            minDtimeArr[rf_vessel_id,rf_oact[rf_k]]*rf_choose[rf_k]
        )
    /\
    seDdur[rf_vessel_id] <=
        sum(rf_k in rf_options)(
            maxDtimeArr[rf_vessel_id,rf_oact[rf_k]]*rf_choose[rf_k]
        )
    /\
    seAdur[rf_vessel_id] >=
        sum(rf_k in rf_options)(
            minAtimeArr[rf_vessel_id,rf_opi[rf_k],rf_oweek[rf_k],rf_oact[rf_k]]
            *rf_choose[rf_k]
        )
    /\
    seAdur[rf_vessel_id] <=
        sum(rf_k in rf_options)(
            maxAtimeArr[rf_vessel_id,rf_opi[rf_k],rf_oweek[rf_k],rf_oact[rf_k]]
            *rf_choose[rf_k]
        )
    /\
    seBdur[rf_vessel_id]+seDdur[rf_vessel_id]+seAdur[rf_vessel_id]
        = sum(rf_k in rf_options)(rf_ototal[rf_k]*rf_choose[rf_k]);

constraint rf_vessel(1,poAct0,poTimes0,directCostArr0,seBfixedArr0,minBtimeArr0,maxBtimeArr0);
constraint rf_vessel(2,poAct1,poTimes1,directCostArr1,seBfixedArr1,minBtimeArr1,maxBtimeArr1);
constraint rf_vessel(3,poAct2,poTimes2,directCostArr2,seBfixedArr2,minBtimeArr2,maxBtimeArr2);
constraint rf_vessel(4,poAct3,poTimes3,directCostArr3,seBfixedArr3,minBtimeArr3,maxBtimeArr3);
constraint rf_vessel(5,poAct4,poTimes4,directCostArr4,seBfixedArr4,minBtimeArr4,maxBtimeArr4);

constraint sum(directCost)+sum(sosActSavings)+sum(sosActBCost)+sum(sosActACost)
    < maxCost;
constraint sum(seBfixed)+sum(seDfixed)+sum(seAfixed)
    +sum(rf_v in VESSELS)(
        sailCoef[rf_v]*(seBdur[rf_v]+seDdur[rf_v]+seAdur[rf_v])
    ) < maxCost;

int: objectiveMax = ub(
    66*(piTimes[piPort,piWeek[1]]-poTimes0[poAct0])
    +66*(piTimes[piPort,piWeek[2]]-poTimes1[poAct1])
    +66*(piTimes[piPort,piWeek[3]]-poTimes2[poAct2])
    +66*(piTimes[piPort,piWeek[4]]-poTimes3[poAct3])
    +66*(piTimes[piPort,piWeek[5]]-poTimes4[poAct4])
    +sum(directCost)-sum(sosActSavings)+sum(sosActBCost)+sum(sosActACost)
    +sum(seBfixed)+sum(seDfixed)+sum(seAfixed)
    +sum(rf_v in VESSELS)(
        sailCoef[rf_v]*(seBdur[rf_v]+seDdur[rf_v]+seAdur[rf_v])
    )
);
var 0..objectiveMax: objective =
    66*sum(rf_elapsed)
    +sum(directCost)-sum(sosActSavings)+sum(sosActBCost)+sum(sosActACost)
    +sum(seBfixed)+sum(seDfixed)+sum(seAfixed)
    +sum(rf_v in VESSELS)(
        sailCoef[rf_v]*(seBdur[rf_v]+seDdur[rf_v]+seAdur[rf_v])
    );

solve minimize objective;

output [
    "poAct0 = ",show(poAct0),";\n",
    "poAct1 = ",show(poAct1),";\n",
    "poAct2 = ",show(poAct2),";\n",
    "poAct3 = ",show(poAct3),";\n",
    "poAct4 = ",show(poAct4),";\n",
    "piPort = ",show(piPort),";\n",
    "piWeek = ",show(piWeek),";\n",
    "reposType = ",show(reposType),";\n",
    "sosAct = ",show(sosAct),";\n",
    "sos = ",show(sos),";\n",
    "sosActSavings = ",show(sosActSavings),";\n",
    "seAct = ",show(seAct),";\n",
    "seBfixed = ",show(seBfixed),";\n",
    "seBdur = ",show(seBdur),";\n",
    "seDfixed = ",show(seDfixed),";\n",
    "seDdur = ",show(seDdur),";\n",
    "seAfixed = ",show(seAfixed),";\n",
    "seAdur = ",show(seAdur),";\n",
    "directCost = ",show(directCost),";\n",
    "sosActBCost = ",show(sosActBCost),";\n",
    "sosActACost = ",show(sosActACost),";\n",
    "constraint objective = ",show(objective),";\n"
];
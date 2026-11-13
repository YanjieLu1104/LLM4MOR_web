include "globals.mzn";

int: vv;
int: ww;
int: pip;
int: poPorts0;
int: poPorts1;
int: poPorts2;
int: poPorts3;
int: poPorts4;
int: poPorts5;
vv = 6;
ww = 11;
pip = 13;
poPorts0 = 16;
poPorts1 = 15;
poPorts2 = 27;
poPorts3 = 24;
poPorts4 = 3;
poPorts5 = 2;

set of int: VESSELS = 1..vv;
set of int: WEEKS = 1..ww;
set of int: PIPORTS = 1..pip;
set of int: REPOSTYPES = 1..3;
set of int: POPORTS0 = 0..poPorts0;
set of int: POPORTS1 = 0..poPorts1;
set of int: POPORTS2 = 0..poPorts2;
set of int: POPORTS3 = 0..poPorts3;
set of int: POPORTS4 = 0..poPorts4;
set of int: POPORTS5 = 0..poPorts5;

int: sosActSize;
int: sosSize;
int: seActSize;
sosActSize = 15;
sosSize = 6;
seActSize = 1;
set of int: SOSACTS = 0..sosActSize;
set of int: SOS = 0..sosSize;
set of int: SEACTS = 0..seActSize;

array[POPORTS0] of int: poTimes0 = array1d(POPORTS0,[128,1304,160,1336,218,1394,244,1420,394,1570,762,937,1088,1160,1213,1416,1807]);
array[POPORTS1] of int: poTimes1 = array1d(POPORTS1,[296,1472,328,1504,386,1562,412,1588,562,1738,930,1105,1256,1328,1381,1584]);
array[POPORTS2] of int: poTimes2 = array1d(POPORTS2,[41,1553,132,1644,194,1706,221,1733,283,1795,344,421,464,552,579,593,967,1001,1216,1257,1316,1351,1377,1420,1457,1473,1567,1596]);
array[POPORTS3] of int: poTimes3 = array1d(POPORTS3,[209,1721,300,1812,362,389,451,512,589,632,720,747,761,1135,1169,1384,1425,1484,1519,1545,1588,1625,1641,1735,1764]);
array[POPORTS4] of int: poTimes4 = array1d(POPORTS4,[179,1355,270,1446]);
array[POPORTS5] of int: poTimes5 = array1d(POPORTS5,[347,1523,438]);

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

array[SOSACTS] of int: sosIds = array1d(SOSACTS,[0,1,1,1,2,2,2,3,3,3,4,4,5,5,6,6]);
array[index_set(sosIds)] of int: rf_savings = array1d(index_set(sosIds),[
0,2103106,2075234,2112090,2092018,2064146,2101002,2080930,2053058,2089914,51430,33524,51430,33524,51430,33524
]);
array[VESSELS,SOSACTS] of int: sosActSavingsArr =
array2d(VESSELS,SOSACTS,[rf_savings[rf_a] | rf_v in VESSELS, rf_a in SOSACTS]);

array[POPORTS0,SOSACTS] of int: sosSailCostBArr0 = array2d(POPORTS0,SOSACTS,[
0,1948,2146,3582,1948,2146,3582,1948,2146,3582,3554,2146,3554,2146,3554,2146,
0,-1,-1,-1,-1,-1,-1,-1,117909,-1,-1,2146,-1,2146,33505,2146,
0,2102,2083,2641,2102,2083,2641,2102,2083,2641,3621,2083,3621,2083,3621,2083,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,17764,-1,2083,77230,2083,
0,1563,1761,23117,1563,1761,3197,1563,1761,3197,3329,1761,3329,1761,3329,1761,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,48658,-1,1761,111483,1761,
0,1485,1453,2098,1485,1453,2098,1485,1453,2098,3287,1453,3287,1453,3287,1453,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,44673,-1,1453,136487,1453,
0,0,265,60322,0,265,1701,0,265,1701,3254,265,3254,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,-1,265,
0,-1,270229,-1,-1,78999,-1,-1,5694,-1,4392,5694,4392,5694,4392,5694,
0,-1,-1,-1,-1,-1,-1,-1,296510,-1,2896,166747,2896,7616,2896,7616,
0,-1,-1,-1,-1,-1,-1,-1,312549,-1,155170,182786,3417,6186,3417,6186,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,239551,28473,48320,3257,5955,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,75337,350108,3133,158878,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,311207,252360,119977,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,265
]);
array[POPORTS1,SOSACTS] of int: sosSailCostBArr1 = array2d(POPORTS1,SOSACTS,[
0,1948,2146,153835,1948,2146,3582,1948,2146,3582,3554,2146,3554,2146,3554,2146,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,2146,-1,2146,
0,2102,2083,87698,2102,2083,2641,2102,2083,2641,3621,2083,3621,2083,3621,2083,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,17764,-1,2083,
0,1563,1761,-1,1563,1761,23117,1563,1761,3197,3329,1761,3329,1761,3329,1761,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,48658,-1,1761,
0,1485,1453,-1,1485,1453,2098,1485,1453,2098,3287,1453,3287,1453,3287,1453,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,44673,-1,1453,
0,0,265,-1,0,265,60322,0,265,1701,3254,265,3254,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,
0,-1,-1,-1,-1,270229,-1,-1,78999,-1,81618,5694,4392,5694,4392,5694,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,117794,357977,2896,166747,2896,7616,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,155170,182786,3417,6186,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,239551,28473,48320,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,75337,350108,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,311207
]);
array[POPORTS2,SOSACTS] of int: sosSailCostBArr2 = array2d(POPORTS2,SOSACTS,[
0,4639,4469,3002,4639,4469,3002,4639,4469,3002,1384,4469,1384,4469,1384,4469,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,80426,142402,
0,4874,4703,3289,4874,4703,3289,4874,4703,3289,1710,4703,1710,4703,1710,4703,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,271546,
0,120210,5934,203045,6155,5934,11814,6155,5934,5098,1755,5934,1755,5934,1755,5934,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,14834,4736,40135,4907,4736,3322,4907,4736,3322,1744,4736,1744,4736,1744,4736,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,90890,4788,119259,4957,4788,3401,4957,4788,3401,1855,4788,1855,4788,1855,4788,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,153362,4725,184623,4893,4725,3363,4893,4725,3363,1855,4725,1855,4725,1855,4725,
0,-1,6301,-1,227347,6301,310182,36117,6301,118951,1859,6301,1859,6301,1859,6301,
0,-1,4736,-1,100205,4736,125506,4907,4736,3322,1744,4736,1744,4736,1744,4736,
0,-1,5087,-1,244118,5087,-1,52888,5087,135722,1418,5087,1418,5087,1418,5087,
0,-1,5066,-1,272554,5066,-1,81324,5066,164158,1386,5066,1386,5066,1386,5066,
0,-1,4469,-1,217872,4469,-1,26642,4469,46203,1384,4469,1384,4469,1384,4469,
0,-1,0,-1,-1,0,-1,265,0,-1,3084,0,3084,0,3084,0,
0,-1,265,-1,-1,265,-1,0,265,-1,38428,265,3254,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,109071,-1,-1,2984,121996,2984,3530,2984,
0,-1,-1,-1,-1,-1,-1,-1,95836,-1,-1,2434,147007,2434,3331,2434,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,80498,-1,2868,89229,2868,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,86448,-1,2557,91818,2557,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,64434,-1,2083,123899,2083,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,87956,-1,1850,180383,1850,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1449,181037,1449,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1761,-1,1761,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,-1,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,-1,0
]);
array[POPORTS3,SOSACTS] of int: sosSailCostBArr3 = array2d(POPORTS3,SOSACTS,[
0,4639,4469,3002,4639,4469,3002,4639,4469,3002,1384,4469,1384,4469,1384,4469,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,101172,4703,126387,4874,4703,3289,4874,4703,3289,1710,4703,1710,4703,1710,4703,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,311441,5934,-1,120210,5934,203045,6155,5934,11814,1755,5934,1755,5934,1755,5934,
0,206064,4736,-1,14834,4736,40135,4907,4736,3322,1744,4736,1744,4736,1744,4736,
0,282121,4788,-1,90890,4788,119259,4957,4788,3401,1855,4788,1855,4788,1855,4788,
0,-1,4725,-1,153362,4725,184623,4893,4725,3363,1855,4725,1855,4725,1855,4725,
0,-1,139479,-1,-1,6301,-1,227347,6301,310182,1859,6301,1859,6301,1859,6301,
0,-1,17884,-1,-1,4736,-1,100205,4736,125506,1744,4736,1744,4736,1744,4736,
0,-1,156250,-1,-1,5087,-1,244118,5087,-1,1418,5087,1418,5087,1418,5087,
0,-1,184686,-1,-1,5066,-1,272554,5066,-1,1386,5066,1386,5066,1386,5066,
0,-1,135572,-1,-1,4469,-1,217872,4469,-1,1384,4469,1384,4469,1384,4469,
0,-1,-1,-1,-1,0,-1,-1,0,-1,172412,0,3084,0,3084,0,
0,-1,-1,-1,-1,265,-1,-1,265,-1,-1,265,38428,265,3254,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,170538,-1,2984,121996,2984,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,2434,147007,2434,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,80498,-1,2868,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,86448,-1,2557,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,64434,-1,2083,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,87956,-1,1850,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1449,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1761,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0
]);
array[POPORTS4,SOSACTS] of int: sosSailCostBArr4 = array2d(POPORTS4,SOSACTS,[
0,636760,212153,-1,445530,20923,-1,254299,11248,559773,7922,11248,7922,11248,7922,11248,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,656081,
0,-1,331475,-1,564852,140245,-1,373621,11392,703795,7991,11392,7991,11392,7991,11392,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);
array[POPORTS5,SOSACTS] of int: sosSailCostBArr5 = array2d(POPORTS5,SOSACTS,[
0,-1,403384,-1,636760,212153,-1,445530,20923,-1,7922,11248,7922,11248,7922,11248,
0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
0,-1,522706,-1,-1,331475,-1,564852,140245,-1,7991,11392,7991,11392,7991,11392
]);
array[VESSELS,PIPORTS,WEEKS,SOSACTS] of int: sosSailCostAArr =
array4d(VESSELS,PIPORTS,WEEKS,SOSACTS,[
if rf_a = 0 then 0 else -1 endif |
rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SOSACTS
]);

array[POPORTS0,SEACTS] of int: seBfixedArr0 = array2d(POPORTS0,SEACTS,[
0,114881,0,114881,0,62474,0,62474,0,149690,0,149690,0,121302,0,121302,
0,303746,0,303746,0,938120,0,1147664,0,740359,0,729677,0,1208092,0,938120,0,303746
]);
array[POPORTS1,SEACTS] of int: seBfixedArr1 = array2d(POPORTS1,SEACTS,[
seBfixedArr0[rf_o,rf_a] | rf_o in POPORTS1, rf_a in SEACTS
]);
array[POPORTS2,SEACTS] of int: seBfixedArr2 = array2d(POPORTS2,SEACTS,[
0,486990,0,486990,0,462874,0,462874,0,967530,0,967530,0,464948,0,464948,
0,454969,0,454969,0,439043,0,1007509,0,464948,0,875165,0,872868,0,486990,
0,325343,0,303746,0,0,0,22149,0,62380,0,64333,0,62474,0,96003,0,122311,
0,149690,0,303746,0,325343
]);
array[index_set(poTimes3)] of int: rf_parent3 = array1d(index_set(poTimes3),[
0,1,2,3,4,6,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27
]);
array[POPORTS3,SEACTS] of int: seBfixedArr3 = array2d(POPORTS3,SEACTS,[
seBfixedArr2[rf_parent3[rf_o],rf_a] | rf_o in POPORTS3, rf_a in SEACTS
]);
array[POPORTS4,SEACTS] of int: seBfixedArr4 = array2d(POPORTS4,SEACTS,[
0,992919,0,992919,0,1014976,0,1014976
]);
array[POPORTS5,SEACTS] of int: seBfixedArr5 = array2d(POPORTS5,SEACTS,[
seBfixedArr4[rf_o,rf_a] | rf_o in POPORTS5, rf_a in SEACTS
]);

array[POPORTS0,SEACTS] of int: maxBtimeArr0 = array2d(POPORTS0,SEACTS,[
0,100,0,100,0,54,0,54,0,130,0,130,0,105,0,105,0,264,0,264,
0,816,0,999,0,644,0,635,0,1051,0,816,0,264
]);
array[POPORTS1,SEACTS] of int: maxBtimeArr1 = array2d(POPORTS1,SEACTS,[
maxBtimeArr0[rf_o,rf_a] | rf_o in POPORTS1, rf_a in SEACTS
]);
array[POPORTS2,SEACTS] of int: maxBtimeArr2 = array2d(POPORTS2,SEACTS,[
0,423,0,423,0,402,0,402,0,842,0,842,0,404,0,404,0,396,0,396,
0,382,0,877,0,404,0,761,0,759,0,423,0,283,0,264,0,0,0,19,
0,54,0,56,0,54,0,83,0,106,0,130,0,264,0,283
]);
array[POPORTS3,SEACTS] of int: maxBtimeArr3 = array2d(POPORTS3,SEACTS,[
maxBtimeArr2[rf_parent3[rf_o],rf_a] | rf_o in POPORTS3, rf_a in SEACTS
]);
array[POPORTS4,SEACTS] of int: maxBtimeArr4 = array2d(POPORTS4,SEACTS,[0,864,0,864,0,883,0,883]);
array[POPORTS5,SEACTS] of int: maxBtimeArr5 = array2d(POPORTS5,SEACTS,[
maxBtimeArr4[rf_o,rf_a] | rf_o in POPORTS5, rf_a in SEACTS
]);

array[POPORTS0,SEACTS] of int: minBtimeArr0 = array2d(POPORTS0,SEACTS,[
0,46,0,46,0,25,0,25,0,60,0,60,0,49,0,49,0,122,0,122,
0,379,0,464,0,299,0,295,0,489,0,379,0,122
]);
array[POPORTS1,SEACTS] of int: minBtimeArr1 = array2d(POPORTS1,SEACTS,[
minBtimeArr0[rf_o,rf_a] | rf_o in POPORTS1, rf_a in SEACTS
]);
array[POPORTS2,SEACTS] of int: minBtimeArr2 = array2d(POPORTS2,SEACTS,[
0,197,0,197,0,187,0,187,0,391,0,391,0,188,0,188,0,184,0,184,
0,177,0,407,0,188,0,354,0,353,0,197,0,131,0,122,0,0,0,8,
0,25,0,26,0,25,0,38,0,49,0,60,0,122,0,131
]);
array[POPORTS3,SEACTS] of int: minBtimeArr3 = array2d(POPORTS3,SEACTS,[
minBtimeArr2[rf_parent3[rf_o],rf_a] | rf_o in POPORTS3, rf_a in SEACTS
]);
array[POPORTS4,SEACTS] of int: minBtimeArr4 = array2d(POPORTS4,SEACTS,[0,402,0,402,0,410,0,410]);
array[POPORTS5,SEACTS] of int: minBtimeArr5 = array2d(POPORTS5,SEACTS,[
minBtimeArr4[rf_o,rf_a] | rf_o in POPORTS5, rf_a in SEACTS
]);

array[VESSELS,SEACTS] of int: seDfixedArr = array2d(VESSELS,SEACTS,[
if rf_a = 0 then 0 else 771667 endif | rf_v in VESSELS, rf_a in SEACTS
]);
array[VESSELS,SEACTS] of int: maxDtimeArr = array2d(VESSELS,SEACTS,[
if rf_a = 0 then 0 else 694 endif | rf_v in VESSELS, rf_a in SEACTS
]);
array[VESSELS,SEACTS] of int: minDtimeArr = array2d(VESSELS,SEACTS,[
if rf_a = 0 then 0 else 322 endif | rf_v in VESSELS, rf_a in SEACTS
]);

array[index_set_1of2(piTimes)] of int: rf_af = array1d(index_set_1of2(piTimes),[
751209,505111,470308,664473,501342,78961,281114,272038,309605,312477,78961,501342,664473
]);
array[index_set_1of2(piTimes)] of int: rf_amin = array1d(index_set_1of2(piTimes),[
304,204,190,269,202,31,113,110,125,126,31,202,269
]);
array[index_set_1of2(piTimes)] of int: rf_amax = array1d(index_set_1of2(piTimes),[
653,439,409,578,436,68,244,236,269,272,68,436,578
]);
array[VESSELS,PIPORTS,WEEKS,SEACTS] of int: seAfixedArr = array4d(VESSELS,PIPORTS,WEEKS,SEACTS,[
if rf_a = 0 then 0 elseif piTimes[rf_p,rf_w] = 0 then -1 else rf_af[rf_p] endif |
rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SEACTS
]);
array[VESSELS,PIPORTS,WEEKS,SEACTS] of int: minAtimeArr = array4d(VESSELS,PIPORTS,WEEKS,SEACTS,[
if rf_a = 0 \/ piTimes[rf_p,rf_w] = 0 then 0 else rf_amin[rf_p] endif |
rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SEACTS
]);
array[VESSELS,PIPORTS,WEEKS,SEACTS] of int: maxAtimeArr = array4d(VESSELS,PIPORTS,WEEKS,SEACTS,[
if rf_a = 0 \/ piTimes[rf_p,rf_w] = 0 then 0 else rf_amax[rf_p] endif |
rf_v in VESSELS, rf_p in PIPORTS, rf_w in WEEKS, rf_a in SEACTS
]);

function array[int] of int: rf_r(int: rf_first, array[int] of int: rf_values) =
[if rf_w < rf_first then -1
 else rf_values[min(index_set(rf_values)) + min(rf_w-rf_first,length(rf_values)-1)]
 endif | rf_w in WEEKS];

function array[int] of int: rf_n(int: rf_count) =
[-1 | rf_i in 1..rf_count, rf_w in WEEKS];

array[POPORTS0,PIPORTS,WEEKS] of int: directCostArr0;
directCostArr0 = array3d(POPORTS0,PIPORTS,WEEKS,
rf_r(1,[23229,463]) ++
rf_r(2,[271]) ++
rf_r(2,[391]) ++
rf_r(2,[488]) ++
rf_r(3,[1948]) ++
rf_r(5,[4713]) ++
rf_r(5,[211799,20568,8958]) ++
rf_r(6,[157192,8875]) ++
rf_r(6,[112802,9219]) ++
rf_r(6,[73558,9246]) ++
rf_r(7,[4713]) ++
rf_r(9,[1948]) ++
rf_r(10,[488]) ++

rf_r(8,[23229,463]) ++
rf_r(9,[271]) ++
rf_r(9,[391]) ++
rf_r(8,[28262,488]) ++
rf_r(9,[79237,1948]) ++
rf_r(10,[248658,57428]) ++
rf_r(11,[403029]) ++
rf_n(1) ++
rf_r(11,[495263]) ++
rf_r(11,[456019]) ++
rf_r(10,[118895,4713]) ++
rf_r(9,[22323,1948]) ++
rf_r(10,[488]) ++

rf_r(2,[85]) ++
rf_r(2,[0]) ++
rf_r(2,[638]) ++
rf_r(2,[619]) ++
rf_r(3,[2102]) ++
rf_r(5,[4714]) ++
rf_r(5,[5835]) ++
rf_r(6,[5662]) ++
rf_r(6,[6165]) ++
rf_r(6,[6177]) ++
rf_r(7,[4714]) ++
rf_r(9,[2102]) ++
rf_r(10,[619]) ++

rf_r(9,[85]) ++
rf_r(9,[0]) ++
rf_r(9,[638]) ++
rf_r(9,[619]) ++
rf_r(10,[2102]) ++
rf_r(11,[93968]) ++
rf_r(10,[290176,98945]) ++
rf_r(11,[225836]) ++
rf_r(11,[198654]) ++
rf_r(10,[349090,157860]) ++
rf_r(10,[155435,4714]) ++
rf_r(9,[75519,2102]) ++
rf_r(10,[619]) ++

rf_r(2,[873]) ++
rf_r(3,[619]) ++
rf_r(2,[42]) ++
rf_r(2,[0]) ++
rf_r(3,[1563]) ++
rf_r(5,[4556]) ++
rf_r(5,[272312,81082,8573]) ++
rf_r(6,[217705,26475,8490]) ++
rf_r(6,[173316,8835]) ++
rf_r(6,[134071,8861]) ++
rf_r(7,[4556]) ++
rf_r(9,[1563]) ++
rf_r(10,[0]) ++

rf_r(9,[873]) ++
rf_r(10,[619]) ++
rf_r(9,[42]) ++
rf_r(9,[0]) ++
rf_r(10,[1563]) ++
rf_r(11,[142748]) ++
rf_r(11,[463542]) ++
rf_n(2) ++
rf_r(11,[516532]) ++
rf_r(10,[204215,12984]) ++
rf_r(9,[82836,1563]) ++
rf_r(10,[0]) ++

rf_r(2,[695]) ++
rf_r(3,[638]) ++
rf_r(2,[0]) ++
rf_r(2,[42]) ++
rf_r(3,[1485]) ++
rf_r(5,[4514]) ++
rf_r(5,[5855]) ++
rf_r(6,[5687]) ++
rf_r(6,[6185]) ++
rf_r(6,[6195]) ++
rf_r(7,[4514]) ++
rf_r(9,[1485]) ++
rf_r(10,[42]) ++

rf_r(9,[695]) ++
rf_r(10,[638]) ++
rf_r(9,[0]) ++
rf_r(9,[42]) ++
rf_r(10,[1485]) ++
rf_r(11,[167843]) ++
rf_r(11,[196816]) ++
rf_r(11,[324158]) ++
rf_r(11,[296447]) ++
rf_r(11,[255452]) ++
rf_r(10,[229310,38080]) ++
rf_r(10,[1485]) ++
rf_r(10,[42]) ++

rf_r(4,[2359]) ++
rf_r(4,[69828,2102]) ++
rf_r(4,[1485]) ++
rf_r(3,[65762,1563]) ++
rf_r(3,[0]) ++
rf_r(5,[160959,4639]) ++
rf_r(5,[309517,118287,7077]) ++
rf_r(6,[254910,63680,6994]) ++
rf_r(6,[210521,19290,7338]) ++
rf_r(6,[171277,7365]) ++
rf_r(7,[4639]) ++
rf_r(9,[0]) ++
rf_r(10,[1563]) ++

rf_r(11,[2359]) ++
rf_r(11,[69828]) ++
rf_r(11,[1485]) ++
rf_r(10,[65762,1563]) ++
rf_r(10,[0]) ++
rf_n(5) ++
rf_r(11,[222426]) ++
rf_r(10,[0]) ++
rf_r(11,[1563]) ++

rf_r(7,[425233,234003,42772,8055]) ++
rf_r(8,[296944,105713,7358]) ++
rf_r(7,[336123,144893,6747]) ++
rf_r(7,[344451,153220,7293]) ++
rf_r(7,[279922,88692,5939]) ++
rf_r(7,[149921,4204]) ++
rf_r(7,[198779,7549,5727]) ++
rf_r(8,[168183,5864]) ++
rf_r(7,[221395,30165,5350]) ++
rf_r(7,[172845,5291]) ++
rf_r(7,[20157,4204]) ++
rf_r(9,[5939]) ++
rf_r(10,[7293]) ++

rf_r(9,[451514,260284,69053]) ++
rf_r(9,[212546,21316,6511]) ++
rf_r(8,[275208,83978,6115]) ++
rf_r(9,[370732,179501,9215]) ++
rf_r(9,[306203,114973,7861]) ++
rf_r(7,[122021,2121]) ++
rf_r(7,[228757,37527,4175]) ++
rf_r(8,[198161,6930,4312]) ++
rf_r(8,[62555,3820]) ++
rf_r(7,[202824,11593,3739]) ++
rf_r(7,[2121]) ++
rf_r(9,[249289,58059,7861]) ++
rf_r(10,[272840,81609]) ++

rf_r(9,[295210,103979,6967]) ++
rf_r(10,[246681,55450]) ++
rf_r(9,[320068,128837,6704]) ++
rf_r(9,[273436,82205,6746]) ++
rf_r(9,[311533,120303,6333]) ++
rf_r(8,[124868,2325]) ++
rf_r(8,[2103]) ++
rf_r(9,[2214]) ++
rf_r(8,[30334,1948]) ++
rf_r(8,[1934]) ++
rf_r(8,[2325]) ++
rf_r(9,[254619,63389,6333]) ++
rf_r(10,[175544,6746]) ++

rf_r(9,[363050,171820,6837]) ++
rf_r(10,[313952,122722]) ++
rf_r(9,[383612,192381,6535]) ++
rf_r(9,[336967,145737,6577]) ++
rf_r(10,[176739,6099]) ++
rf_r(9,[7324,2249]) ++
rf_r(8,[80703,2243]) ++
rf_r(9,[45688,2340]) ++
rf_r(9,[2120]) ++
rf_r(8,[87517,2107]) ++
rf_r(8,[68791,2249]) ++
rf_r(9,[311056,119825,6099]) ++
rf_r(10,[239075,47845]) ++

rf_r(11,[443645]) ++
rf_r(10,[361762,170532]) ++
rf_r(10,[237883,46652]) ++
rf_r(10,[554093,362863]) ++
rf_r(10,[489565,298334]) ++
rf_r(9,[61308,2190]) ++
rf_r(9,[135531,3947]) ++
rf_r(10,[104935,4084]) ++
rf_r(9,[160560,3592]) ++
rf_r(9,[109598,3510]) ++
rf_r(8,[122775,2190]) ++
rf_r(10,[432651,241420]) ++
rf_r(11,[456201]) ++

rf_r(11,[404744]) ++
rf_n(1) ++
rf_r(11,[315634]) ++
rf_r(11,[323962]) ++
rf_r(11,[259433]) ++
rf_r(11,[129432]) ++
rf_r(11,[178290]) ++
rf_r(11,[338924]) ++
rf_r(11,[200906]) ++
rf_r(11,[152356]) ++
rf_r(10,[190899,4204]) ++
rf_r(11,[202519]) ++
rf_r(11,[417300]) ++

rf_n(11) ++ rf_r(11,[0]) ++ rf_n(1)
);

array[POPORTS2,PIPORTS,WEEKS] of int: directCostArr2;
directCostArr2 = array3d(POPORTS2,PIPORTS,WEEKS,
rf_r(2,[191683,4670]) ++
rf_r(3,[144052,4714]) ++
rf_r(2,[228172,36941,4514]) ++
rf_r(2,[181449,4556]) ++
rf_r(3,[82418,4639]) ++
rf_r(5,[0]) ++
rf_r(5,[1761]) ++
rf_r(6,[1661]) ++
rf_r(6,[2006]) ++
rf_r(6,[2008]) ++
rf_r(7,[0]) ++
rf_r(9,[4639]) ++
rf_r(10,[4556]) ++

rf_r(11,[191683]) ++
rf_n(1) ++
rf_r(11,[228172]) ++
rf_r(11,[181449]) ++
rf_n(1) ++
rf_r(11,[0]) ++
rf_r(10,[92987,1761]) ++
rf_r(11,[36573]) ++
rf_r(11,[2006]) ++
rf_r(11,[2008]) ++
rf_r(10,[0]) ++
rf_r(11,[216734]) ++
rf_n(1) ++

rf_r(3,[87985,4523]) ++
rf_r(3,[232913,41682,4579]) ++
rf_r(3,[137967,4491]) ++
rf_r(3,[91004,4530]) ++
rf_r(3,[211585,20354,4874]) ++
rf_r(5,[626]) ++
rf_r(5,[1449]) ++
rf_r(6,[1307]) ++
rf_r(6,[1754]) ++
rf_r(6,[1761]) ++
rf_r(7,[626]) ++
rf_r(9,[4874]) ++
rf_r(10,[4530]) ++

rf_n(5) ++
rf_r(11,[626]) ++
rf_r(11,[1449]) ++
rf_n(1) ++
rf_r(11,[68370]) ++
rf_r(11,[27021]) ++
rf_r(11,[626]) ++
rf_n(2) ++

rf_r(4,[395119,203889,12659,8447]) ++
rf_r(4,[116111,4614]) ++
rf_r(3,[212908,21678,4531]) ++
rf_r(4,[310661,119430,7651]) ++
rf_r(4,[230623,39393,6155]) ++
rf_r(5,[649]) ++
rf_r(5,[1614]) ++
rf_r(6,[1526]) ++
rf_r(6,[1908]) ++
rf_r(6,[1924]) ++
rf_r(7,[649]) ++
rf_r(9,[6155]) ++
rf_r(10,[7651]) ++

rf_n(6) ++
rf_r(11,[59893]) ++
rf_n(3) ++
rf_r(11,[649]) ++
rf_n(2) ++

rf_r(3,[191711,4545]) ++
rf_r(4,[145460,4601]) ++
rf_r(3,[242204,50973,4518]) ++
rf_r(3,[195231,4557]) ++
rf_r(4,[125247,4907]) ++
rf_r(5,[647]) ++
rf_r(5,[1417]) ++
rf_r(6,[1273]) ++
rf_r(6,[1723]) ++
rf_r(6,[1730]) ++
rf_r(7,[647]) ++
rf_r(9,[4907]) ++
rf_r(10,[4557]) ++

rf_n(6) ++
rf_r(11,[69177]) ++
rf_n(3) ++
rf_r(11,[647]) ++
rf_n(2) ++

rf_r(3,[254621,63391,4475]) ++
rf_r(4,[208745,17515,4535]) ++
rf_r(4,[118175,4487]) ++
rf_r(3,[262325,71095,4525]) ++
rf_r(4,[201303,10072,4957]) ++
rf_r(5,[845]) ++
rf_r(5,[1393]) ++
rf_r(6,[1236]) ++
rf_r(6,[1713]) ++
rf_r(6,[1721]) ++
rf_r(7,[845]) ++
rf_r(9,[4957]) ++
rf_r(10,[4525]) ++

rf_n(13) ++

rf_r(4,[117863,4338]) ++
rf_r(5,[72155,4399]) ++
rf_r(4,[174856,4370]) ++
rf_r(4,[127709,4407]) ++
rf_r(4,[263775,72545,4893]) ++
rf_r(5,[963]) ++
rf_r(5,[1492]) ++
rf_r(6,[1329]) ++
rf_r(6,[1818]) ++
rf_r(6,[1827]) ++
rf_r(7,[963]) ++
rf_r(9,[4893]) ++
rf_r(10,[4407]) ++

rf_r(5,[502256,311026,119796,8814]) ++
rf_r(5,[159129,4393]) ++
rf_r(5,[70775,4365]) ++
rf_r(5,[417798,226567,35337,8018]) ++
rf_r(5,[337760,146530,6522]) ++
rf_r(5,[972]) ++
rf_r(5,[1987]) ++
rf_r(6,[1830]) ++
rf_r(6,[2273]) ++
rf_r(6,[2286]) ++
rf_r(7,[972]) ++
rf_r(9,[6522]) ++
rf_r(10,[8018]) ++

rf_r(5,[85851,4545]) ++
rf_r(5,[230831,39600,4601]) ++
rf_r(5,[136344,4518]) ++
rf_r(5,[89372,4557]) ++
rf_r(5,[210618,19387,4907]) ++
rf_r(5,[647]) ++
rf_r(5,[1417]) ++
rf_r(6,[1273]) ++
rf_r(6,[1723]) ++
rf_r(6,[1730]) ++
rf_r(7,[647]) ++
rf_r(9,[4907]) ++
rf_r(10,[4557]) ++

rf_r(6,[327797,136566,7600]) ++
rf_r(6,[154289,4735]) ++
rf_r(5,[238908,47678,4540]) ++
rf_r(6,[243338,52108,6804]) ++
rf_r(6,[163301,5308]) ++
rf_r(5,[35]) ++
rf_r(5,[1769]) ++
rf_r(6,[1685]) ++
rf_r(6,[2030]) ++
rf_r(6,[2056]) ++
rf_r(7,[35]) ++
rf_r(9,[5308]) ++
rf_r(10,[6804]) ++

rf_r(6,[356233,165002,7579]) ++
rf_r(6,[182624,4713]) ++
rf_r(6,[75592,4514]) ++
rf_r(6,[271774,80543,6783]) ++
rf_r(6,[191737,5287]) ++
rf_r(5,[4]) ++
rf_r(5,[1790]) ++
rf_r(6,[1706]) ++
rf_r(6,[2051]) ++
rf_r(6,[2077]) ++
rf_r(7,[4]) ++
rf_r(9,[5287]) ++
rf_r(10,[6783]) ++

rf_r(5,[246320,55090,4670]) ++
rf_r(6,[198690,7459,4714]) ++
rf_r(6,[91579,4514]) ++
rf_r(5,[236086,44856,4556]) ++
rf_r(6,[137055,4639]) ++
rf_r(5,[0]) ++
rf_r(5,[1761]) ++
rf_r(6,[1661]) ++
rf_r(6,[2006]) ++
rf_r(6,[2008]) ++
rf_r(7,[0]) ++
rf_r(9,[4639]) ++
rf_r(10,[4556]) ++

rf_r(7,[59129,2557]) ++
rf_r(8,[2083]) ++
rf_r(7,[1453]) ++
rf_r(7,[1761]) ++
rf_r(7,[265]) ++
rf_r(8,[220943,29712,4469]) ++
rf_r(8,[363933,172703,6856]) ++
rf_r(9,[309326,118096,6773]) ++
rf_r(9,[264937,73706,7117]) ++
rf_r(8,[416923,225693,34462,7143]) ++
rf_r(8,[91179,4469]) ++
rf_r(9,[265]) ++
rf_r(10,[1761]) ++

rf_r(7,[76233,2359]) ++
rf_r(8,[2102]) ++
rf_r(7,[34452,1485]) ++
rf_r(7,[1563]) ++
rf_r(7,[0]) ++
rf_r(9,[86971,4639]) ++
rf_r(9,[235529,44299,7077]) ++
rf_r(9,[372153,180922,6994]) ++
rf_r(9,[327763,136533,7338]) ++
rf_r(9,[288519,97289,7365]) ++
rf_r(8,[148438,4639]) ++
rf_r(9,[0]) ++
rf_r(10,[1563]) ++

rf_r(8,[590]) ++
rf_r(9,[573]) ++
rf_r(8,[47314,1112]) ++
rf_r(8,[24479,1372]) ++
rf_r(9,[70399,2785]) ++
rf_r(10,[121603,4466]) ++
rf_r(11,[394192]) ++
rf_r(11,[530815]) ++
rf_r(11,[486426]) ++
rf_r(11,[447181]) ++
rf_r(9,[183070,4466]) ++
rf_r(9,[13485,2785]) ++
rf_r(10,[1372]) ++

rf_r(8,[506]) ++
rf_r(9,[588]) ++
rf_r(9,[1023]) ++
rf_r(8,[33482,1027]) ++
rf_r(9,[84664,2488]) ++
rf_r(10,[149151,4291]) ++
rf_r(10,[140508,5287]) ++
rf_r(10,[267376,76146]) ++
rf_r(10,[239996,48766]) ++
rf_r(10,[199258,8028]) ++
rf_r(9,[210618,19388,4291]) ++
rf_r(9,[27750,2488]) ++
rf_r(10,[1027]) ++

rf_r(9,[517]) ++
rf_r(9,[519]) ++
rf_r(9,[1157]) ++
rf_r(9,[1210]) ++
rf_r(10,[2670]) ++
rf_r(10,[283727,92497]) ++
rf_r(11,[495382]) ++
rf_n(2) ++
rf_r(11,[548372]) ++
rf_r(10,[153964,4909]) ++
rf_r(9,[114676,2670]) ++
rf_r(10,[1210]) ++

rf_r(9,[0]) ++
rf_r(9,[85]) ++
rf_r(9,[695]) ++
rf_r(9,[873]) ++
rf_r(10,[2359]) ++
rf_r(11,[106312]) ++
rf_r(11,[501332]) ++
rf_n(2) ++
rf_r(11,[554322]) ++
rf_r(10,[167779,4670]) ++
rf_r(9,[120626,2359]) ++
rf_r(10,[873]) ++

rf_r(9,[85]) ++
rf_r(10,[0]) ++
rf_r(9,[638]) ++
rf_r(9,[619]) ++
rf_r(10,[2102]) ++
rf_r(11,[140638]) ++
rf_r(10,[336845,145615]) ++
rf_r(11,[272505]) ++
rf_r(11,[245324]) ++
rf_r(11,[204529]) ++
rf_r(10,[202104,10874]) ++
rf_r(9,[122189,2102]) ++
rf_r(10,[619]) ++

rf_r(9,[392]) ++
rf_r(10,[307]) ++
rf_r(9,[19108,478]) ++
rf_r(9,[443]) ++
rf_r(10,[9511,1851]) ++
rf_r(11,[204742]) ++
rf_r(11,[219437]) ++
rf_n(1) ++
rf_r(11,[319244]) ++
rf_r(11,[278389]) ++
rf_r(10,[266209,74978]) ++
rf_r(10,[1851]) ++
rf_r(10,[443]) ++

rf_r(9,[31723,698]) ++
rf_r(10,[638]) ++
rf_r(10,[25]) ++
rf_r(9,[22]) ++
rf_r(10,[10929,1478]) ++
rf_r(11,[212594]) ++
rf_r(11,[241663]) ++
rf_n(1) ++
rf_r(11,[341295]) ++
rf_r(11,[300301]) ++
rf_r(11,[82830]) ++
rf_r(10,[1478]) ++
rf_r(10,[22]) ++

rf_r(10,[873]) ++
rf_r(10,[619]) ++
rf_r(10,[42]) ++
rf_r(9,[0]) ++
rf_r(10,[38443,1563]) ++
rf_r(11,[232672]) ++
rf_n(4) ++
rf_r(11,[102908]) ++
rf_r(10,[1563]) ++
rf_r(10,[0]) ++

rf_r(11,[2359]) ++
rf_r(11,[66413]) ++
rf_r(11,[1485]) ++
rf_r(10,[62347,1563]) ++
rf_r(10,[0]) ++
rf_n(5) ++
rf_r(11,[219011]) ++
rf_r(10,[0]) ++
rf_r(11,[1563]) ++

rf_r(11,[10183]) ++
rf_r(11,[97444]) ++
rf_r(11,[1453]) ++
rf_r(11,[1761]) ++
rf_r(11,[265]) ++
rf_n(5) ++
rf_r(11,[233464]) ++
rf_r(10,[265]) ++
rf_r(11,[19063])
);

array[POPORTS4,PIPORTS,WEEKS] of int: directCostArr4;
directCostArr4 = array3d(POPORTS4,PIPORTS,WEEKS,
rf_r(4,[443068,251838,60607,9043]) ++
rf_r(5,[345148,153918,8625]) ++
rf_r(4,[517266,326036,134806,9233]) ++
rf_r(4,[516226,324996,133766,9693]) ++
rf_r(5,[555942,364712,173482,11049]) ++
rf_r(5,[125864,6562]) ++
rf_r(5,[513629,322399,131168,11194]) ++
rf_r(6,[483147,291917,100687,11332]) ++
rf_r(6,[342717,151487,10796]) ++
rf_r(6,[298303,107073,10774]) ++
rf_r(7,[6562]) ++
rf_r(9,[11049]) ++
rf_r(10,[9693]) ++

rf_r(11,[443068]) ++
rf_n(1) ++
rf_r(11,[517266]) ++
rf_r(11,[516226]) ++
rf_n(1) ++
rf_r(11,[317094]) ++
rf_n(4) ++
rf_r(10,[378561,187331]) ++
rf_n(2) ++

rf_r(5,[377593,186362,9247]) ++
rf_r(5,[487603,296372,105142,8982]) ++
rf_r(5,[468332,277101,85871,9588]) ++
rf_r(5,[454657,263427,72196,9933]) ++
rf_r(6,[484034,292803,101573,11194]) ++
rf_r(5,[234772,43541,6611]) ++
rf_r(5,[592398,401167,209937,18707,10966]) ++
rf_r(6,[561916,370686,179455,11104]) ++
rf_r(6,[421486,230255,39025,10568]) ++
rf_r(6,[377072,185841,10547]) ++
rf_r(7,[6611]) ++
rf_r(9,[11194]) ++
rf_r(10,[9933]) ++

rf_n(10) ++ rf_r(11,[296239]) ++ rf_n(2)
);

array[index_set(poTimes1),index_set_1of2(piTimes)] of int: rf_edge1 =
array2d(index_set(poTimes1),index_set_1of2(piTimes),[
-1,-1,-1,28262,79237,57428,403029,348423,304033,264789,4713,1948,488,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,488,
-1,-1,-1,-1,-1,93968,98945,34605,7424,6177,4714,2102,619,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,619,
-1,-1,-1,-1,-1,142748,463542,408936,364546,325302,4556,1563,0,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,
-1,-1,-1,-1,-1,167843,196816,132927,105217,64222,4514,1485,42,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,401751,362507,4639,0,1563,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,211388,31778,55328,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,440520,464070,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,366774,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);

array[index_set(poTimes3),index_set_1of2(piTimes)] of int: rf_edge3 =
array2d(index_set(poTimes3),index_set_1of2(piTimes),[
-1,-1,-1,-1,-1,0,1761,1661,2006,2008,0,4639,4556,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,626,1449,1307,1754,1761,626,4874,4530,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,649,1614,1526,1908,1924,649,6155,7651,
-1,-1,-1,-1,-1,647,1417,1273,1723,1730,647,4907,4557,
-1,-1,-1,-1,-1,845,1393,1236,1713,1721,845,4957,4525,
-1,-1,-1,-1,-1,963,1492,1329,1818,1827,963,4893,4407,
-1,-1,-1,-1,-1,972,1987,1830,2273,2286,972,6522,8018,
-1,-1,-1,-1,-1,647,1417,1273,1723,1730,647,4907,4557,
-1,-1,-1,-1,-1,-1,101823,47216,2827,2056,35,5308,6804,
-1,-1,-1,-1,-1,-1,-1,80248,35858,2077,4,5287,6783,
-1,-1,-1,-1,-1,-1,-1,91210,46854,4998,0,4639,4556,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,265,1761,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,1563,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1372,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1027,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,22724,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,25801,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,27713,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
]);

array[index_set(poTimes5),index_set_1of2(piTimes)] of int: rf_edge5 =
array2d(index_set(poTimes5),index_set_1of2(piTimes),[
-1,-1,-1,-1,-1,317094,-1,-1,533947,489534,6562,11049,9693,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,612716,568302,6611,44659,9933
]);

function int: rf_shift(
    array[int,int,int] of int: rf_base,
    array[int,int] of int: rf_edge,
    int: rf_old,
    int: rf_new,
    int: rf_port,
    int: rf_week
) =
if piTimes[rf_port,rf_week] = 0 then -1
elseif rf_week = min(WEEKS) then rf_edge[rf_new,rf_port]
elseif piTimes[rf_port,rf_week-1] = 0 then rf_edge[rf_new,rf_port]
else rf_base[rf_old,rf_port,rf_week-1]
endif;

array[POPORTS1,PIPORTS,WEEKS] of int: directCostArr1;
directCostArr1 = array3d(POPORTS1,PIPORTS,WEEKS,[
rf_shift(directCostArr0,rf_edge1,rf_o,rf_o,rf_p,rf_w) |
rf_o in POPORTS1, rf_p in PIPORTS, rf_w in WEEKS
]);
array[POPORTS3,PIPORTS,WEEKS] of int: directCostArr3;
directCostArr3 = array3d(POPORTS3,PIPORTS,WEEKS,[
rf_shift(directCostArr2,rf_edge3,rf_parent3[rf_o],rf_o,rf_p,rf_w) |
rf_o in POPORTS3, rf_p in PIPORTS, rf_w in WEEKS
]);
array[POPORTS5,PIPORTS,WEEKS] of int: directCostArr5;
directCostArr5 = array3d(POPORTS5,PIPORTS,WEEKS,[
rf_shift(directCostArr4,rf_edge5,rf_o,rf_o,rf_p,rf_w) |
rf_o in POPORTS5, rf_p in PIPORTS, rf_w in WEEKS
]);

int: seBfixedMax = max([
max(array1d(seBfixedArr0)),max(array1d(seBfixedArr1)),
max(array1d(seBfixedArr2)),max(array1d(seBfixedArr3)),
max(array1d(seBfixedArr4)),max(array1d(seBfixedArr5))
]);
int: seDfixedMax = max(array1d(seDfixedArr));
int: seAfixedMax = max(array1d(seAfixedArr));
int: sosActBCostMax = max([
max(array1d(sosSailCostBArr0)),max(array1d(sosSailCostBArr1)),
max(array1d(sosSailCostBArr2)),max(array1d(sosSailCostBArr3)),
max(array1d(sosSailCostBArr4)),max(array1d(sosSailCostBArr5))
]);
int: sosActACostMax = max(array1d(sosSailCostAArr));
int: sosActSavingsMax = max(array1d(sosActSavingsArr));
int: directCostMax = max([
max(array1d(directCostArr0)),max(array1d(directCostArr1)),
max(array1d(directCostArr2)),max(array1d(directCostArr3)),
max(array1d(directCostArr4)),max(array1d(directCostArr5))
]);
int: maxCost = 500000;
array[VESSELS] of int: sailCoef = array1d(VESSELS,[-1138,-1138,-1138,-1138,-1138,-1138]);

var POPORTS0: poAct0;
var POPORTS1: poAct1;
var POPORTS2: poAct2;
var POPORTS3: poAct3;
var POPORTS4: poAct4;
var POPORTS5: poAct5;
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
array[index_set_2of2(piTimes)] of var 0..1: rf_window;
array[index_set(piWeek)] of var 0..max(array1d(piTimes)): rf_elapsed;

constraint sum(rf_port_selected) = 1;
constraint piPort = sum(rf_p in index_set(rf_port_selected))(rf_p * rf_port_selected[rf_p]);
constraint sum(rf_window) = 1;
constraint forall(rf_w in index_set(rf_window) where rf_w + vv - 1 > max(WEEKS))(
rf_window[rf_w] = 0
);
constraint forall(rf_v in index_set(piWeek))(
sum(rf_w in WEEKS)(rf_week_selected[rf_v,rf_w]) = 1 /\
piWeek[rf_v] = sum(rf_w in WEEKS)(rf_w * rf_week_selected[rf_v,rf_w])
);
constraint forall(rf_w in WEEKS)(
sum(rf_v in VESSELS)(rf_week_selected[rf_v,rf_w]) =
sum(rf_s in index_set(rf_window) where rf_s <= rf_w /\ rf_w < rf_s + vv)(rf_window[rf_s])
);

constraint forall(rf_v in VESSELS)(
sosAct[rf_v] = 0 /\
sos[rf_v] = 0 /\
sosActSavings[rf_v] = 0 /\
sosActBCost[rf_v] = 0 /\
sosActACost[rf_v] = 0 /\
reposType[rf_v] = 1 + 2 * seAct[rf_v]
);
constraint sum(seAct) <= 1;

predicate rf_vessel(
    int: rf_vessel_id,
    var int: rf_po,
    array[int] of int: rf_times,
    array[int,int,int] of int: rf_direct,
    array[int,int] of int: rf_bfixed,
    array[int,int] of int: rf_bmin,
    array[int,int] of int: rf_bmax
) =
let {
    int: rf_po_first = min(index_set(rf_times)),
    int: rf_p_first = min(index_set_1of2(piTimes)),
    int: rf_w_first = min(index_set_2of2(piTimes)),
    int: rf_np = card(index_set_1of2(piTimes)),
    int: rf_nw = card(index_set_2of2(piTimes)),
    array[int] of int: rf_ids = [
        (((rf_o-rf_po_first)*rf_np + rf_p-rf_p_first)*rf_nw + rf_w-rf_w_first)*2 + rf_e
        | rf_o in index_set(rf_times),
          rf_p in index_set_1of2(piTimes),
          rf_w in index_set_2of2(piTimes),
          rf_e in SEACTS
        where
          if rf_e = 0 then
            rf_direct[rf_o,rf_p,rf_w] >= 0 /\
            piTimes[rf_p,rf_w] >= rf_times[rf_o]
          else
            seAfixedArr[rf_vessel_id,rf_p,rf_w,rf_e] >= 0 /\
            rf_bmin[rf_o,rf_e] +
            minDtimeArr[rf_vessel_id,rf_e] +
            minAtimeArr[rf_vessel_id,rf_p,rf_w,rf_e]
            <= piTimes[rf_p,rf_w] - rf_times[rf_o]
          endif
    ],
    array[index_set(rf_ids)] of int: rf_os =
        [rf_po_first + rf_ids[rf_j] div (2*rf_nw*rf_np) | rf_j in index_set(rf_ids)],
    array[index_set(rf_ids)] of int: rf_ps =
        [rf_p_first + (rf_ids[rf_j] div (2*rf_nw)) mod rf_np | rf_j in index_set(rf_ids)],
    array[index_set(rf_ids)] of int: rf_ws =
        [rf_w_first + (rf_ids[rf_j] div 2) mod rf_nw | rf_j in index_set(rf_ids)],
    array[index_set(rf_ids)] of int: rf_es =
        [rf_ids[rf_j] mod 2 | rf_j in index_set(rf_ids)],
    array[index_set(rf_ids)] of int: rf_gaps =
        [piTimes[rf_ps[rf_j],rf_ws[rf_j]] - rf_times[rf_os[rf_j]] | rf_j in index_set(rf_ids)],
    array[index_set(rf_ids)] of int: rf_totals = [
        if rf_es[rf_j] = 0 then 0 else
        min(
          rf_bmax[rf_os[rf_j],rf_es[rf_j]] +
          maxDtimeArr[rf_vessel_id,rf_es[rf_j]] +
          maxAtimeArr[rf_vessel_id,rf_ps[rf_j],rf_ws[rf_j],rf_es[rf_j]],
          rf_gaps[rf_j]
        ) endif | rf_j in index_set(rf_ids)
    ],
    array[index_set(rf_ids)] of var 0..1: rf_x
} in
sum(rf_x) = 1 /\
rf_po = sum(rf_j in index_set(rf_ids))(rf_os[rf_j] * rf_x[rf_j]) /\
forall(rf_p in index_set(rf_port_selected))(
    sum(rf_j in index_set(rf_ids) where rf_ps[rf_j] = rf_p)(rf_x[rf_j])
    = rf_port_selected[rf_p]
) /\
forall(rf_w in WEEKS)(
    sum(rf_j in index_set(rf_ids) where rf_ws[rf_j] = rf_w)(rf_x[rf_j])
    = rf_week_selected[rf_vessel_id,rf_w]
) /\
seAct[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids))(rf_es[rf_j] * rf_x[rf_j]) /\
rf_elapsed[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids))(rf_gaps[rf_j] * rf_x[rf_j]) /\
directCost[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids) where rf_es[rf_j] = 0)(
        rf_direct[rf_os[rf_j],rf_ps[rf_j],rf_ws[rf_j]] * rf_x[rf_j]
    ) /\
seBfixed[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids))(rf_bfixed[rf_os[rf_j],rf_es[rf_j]] * rf_x[rf_j]) /\
seDfixed[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids))(seDfixedArr[rf_vessel_id,rf_es[rf_j]] * rf_x[rf_j]) /\
seAfixed[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids))(
        seAfixedArr[rf_vessel_id,rf_ps[rf_j],rf_ws[rf_j],rf_es[rf_j]] * rf_x[rf_j]
    ) /\
seBdur[rf_vessel_id] >=
    sum(rf_j in index_set(rf_ids))(rf_bmin[rf_os[rf_j],rf_es[rf_j]] * rf_x[rf_j]) /\
seBdur[rf_vessel_id] <=
    sum(rf_j in index_set(rf_ids))(rf_bmax[rf_os[rf_j],rf_es[rf_j]] * rf_x[rf_j]) /\
seDdur[rf_vessel_id] >=
    sum(rf_j in index_set(rf_ids))(minDtimeArr[rf_vessel_id,rf_es[rf_j]] * rf_x[rf_j]) /\
seDdur[rf_vessel_id] <=
    sum(rf_j in index_set(rf_ids))(maxDtimeArr[rf_vessel_id,rf_es[rf_j]] * rf_x[rf_j]) /\
seAdur[rf_vessel_id] >=
    sum(rf_j in index_set(rf_ids))(
        minAtimeArr[rf_vessel_id,rf_ps[rf_j],rf_ws[rf_j],rf_es[rf_j]] * rf_x[rf_j]
    ) /\
seAdur[rf_vessel_id] <=
    sum(rf_j in index_set(rf_ids))(
        maxAtimeArr[rf_vessel_id,rf_ps[rf_j],rf_ws[rf_j],rf_es[rf_j]] * rf_x[rf_j]
    ) /\
seBdur[rf_vessel_id] + seDdur[rf_vessel_id] + seAdur[rf_vessel_id] =
    sum(rf_j in index_set(rf_ids))(rf_totals[rf_j] * rf_x[rf_j]);

constraint rf_vessel(1,poAct0,poTimes0,directCostArr0,seBfixedArr0,minBtimeArr0,maxBtimeArr0);
constraint rf_vessel(2,poAct1,poTimes1,directCostArr1,seBfixedArr1,minBtimeArr1,maxBtimeArr1);
constraint rf_vessel(3,poAct2,poTimes2,directCostArr2,seBfixedArr2,minBtimeArr2,maxBtimeArr2);
constraint rf_vessel(4,poAct3,poTimes3,directCostArr3,seBfixedArr3,minBtimeArr3,maxBtimeArr3);
constraint rf_vessel(5,poAct4,poTimes4,directCostArr4,seBfixedArr4,minBtimeArr4,maxBtimeArr4);
constraint rf_vessel(6,poAct5,poTimes5,directCostArr5,seBfixedArr5,minBtimeArr5,maxBtimeArr5);

constraint sum(directCost) + sum(sosActSavings) + sum(sosActBCost) + sum(sosActACost) < maxCost;
constraint sum(seBfixed) + sum(seDfixed) + sum(seAfixed) +
sum(rf_v in VESSELS)(sailCoef[rf_v] * (seBdur[rf_v] + seDdur[rf_v] + seAdur[rf_v])) < maxCost;

int: objectiveMax = ub(
66 * (piTimes[piPort,piWeek[1]] - poTimes0[poAct0]) +
66 * (piTimes[piPort,piWeek[2]] - poTimes1[poAct1]) +
66 * (piTimes[piPort,piWeek[3]] - poTimes2[poAct2]) +
66 * (piTimes[piPort,piWeek[4]] - poTimes3[poAct3]) +
66 * (piTimes[piPort,piWeek[5]] - poTimes4[poAct4]) +
66 * (piTimes[piPort,piWeek[6]] - poTimes5[poAct5]) +
sum(directCost) - sum(sosActSavings) + sum(sosActBCost) + sum(sosActACost) +
sum(seBfixed) + sum(seDfixed) + sum(seAfixed) +
sum(rf_v in VESSELS)(sailCoef[rf_v] * (seBdur[rf_v] + seDdur[rf_v] + seAdur[rf_v]))
);

var 0..objectiveMax: objective =
66 * sum(rf_elapsed) +
sum(directCost) - sum(sosActSavings) + sum(sosActBCost) + sum(sosActACost) +
sum(seBfixed) + sum(seDfixed) + sum(seAfixed) +
sum(rf_v in VESSELS)(sailCoef[rf_v] * (seBdur[rf_v] + seDdur[rf_v] + seAdur[rf_v]));

solve minimize objective;

output [
"poAct0 = ",show(poAct0),";\n",
"poAct1 = ",show(poAct1),";\n",
"poAct2 = ",show(poAct2),";\n",
"poAct3 = ",show(poAct3),";\n",
"poAct4 = ",show(poAct4),";\n",
"poAct5 = ",show(poAct5),";\n",
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
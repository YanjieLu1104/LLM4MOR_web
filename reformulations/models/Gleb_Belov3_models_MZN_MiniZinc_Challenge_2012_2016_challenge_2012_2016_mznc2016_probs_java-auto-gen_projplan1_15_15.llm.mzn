var 1..45: chooseint_750;
var 1..45: chooseint_791;
var 1..45: chooseint_832;
var 1..45: chooseint_873;
var 1..45: chooseint_914;
var 1..45: chooseint_955;
var 1..45: chooseint_996;
var 1..45: chooseint_1037;
var 1..45: chooseint_1078;
var 1..45: chooseint_1119;
var 1..45: chooseint_1160;
var 1..45: chooseint_1201;
var 1..45: chooseint_1242;
var 1..45: chooseint_1283;
var 1..45: chooseint_1324;

var 1..45: objective;

constraint chooseint_955 >= chooseint_750 + 1;
constraint chooseint_1119 >= chooseint_996 + 1;
constraint chooseint_1160 >= chooseint_1119;
constraint chooseint_1201 >= chooseint_750;
constraint chooseint_1201 >= chooseint_1119 + 1;
constraint chooseint_1201 >= chooseint_873 + 2;
constraint chooseint_1242 >= chooseint_914 + 2;
constraint chooseint_1242 >= chooseint_1201 + 2;
constraint chooseint_1242 >= chooseint_832 + 1;
constraint chooseint_1283 >= chooseint_1037 + 2;
constraint chooseint_1283 >= chooseint_791;
constraint chooseint_1283 >= chooseint_1078;
constraint chooseint_1324 >= chooseint_1078 + 2;
constraint chooseint_1324 >= chooseint_750 + 2;
constraint chooseint_1324 >= chooseint_873;

constraint objective = max([
    chooseint_750,
    chooseint_791,
    chooseint_832,
    chooseint_873,
    chooseint_914,
    chooseint_955,
    chooseint_996,
    chooseint_1037,
    chooseint_1078,
    chooseint_1119,
    chooseint_1160,
    chooseint_1201,
    chooseint_1242,
    chooseint_1283,
    chooseint_1324
]);

constraint objective >= 5;
constraint objective >= chooseint_750;
constraint objective >= chooseint_791;
constraint objective >= chooseint_832;
constraint objective >= chooseint_873;
constraint objective >= chooseint_914;
constraint objective >= chooseint_955;
constraint objective >= chooseint_996;
constraint objective >= chooseint_1037;
constraint objective >= chooseint_1078;
constraint objective >= chooseint_1119;
constraint objective >= chooseint_1160;
constraint objective >= chooseint_1201;
constraint objective >= chooseint_1242;
constraint objective >= chooseint_1283;
constraint objective >= chooseint_1324;

solve minimize objective;
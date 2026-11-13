var 0..5: chooseint_239;
var 0..5: chooseint_268;
var 0..5: chooseint_297;
var 0..5: chooseint_326;
var 0..5: chooseint_355;
var 0..5: chooseint_384;
var 0..5: chooseint_413;
var 0..5: chooseint_442;
var 0..5: chooseint_471;
var 0..5: chooseint_500;
var 0..5: chooseint_529;
var 0..5: chooseint_558;
var 0..5: chooseint_587;

constraint
    chooseint_239 + chooseint_268 + chooseint_297 +
    chooseint_326 + chooseint_355 + chooseint_384 <= 19;

constraint
    chooseint_268 + chooseint_297 + chooseint_326 +
    chooseint_355 + chooseint_384 + chooseint_413 <= 19;

constraint
    chooseint_297 + chooseint_326 + chooseint_355 +
    chooseint_384 + chooseint_413 + chooseint_442 <= 19;

constraint
    chooseint_326 + chooseint_355 + chooseint_384 +
    chooseint_413 + chooseint_442 + chooseint_471 <= 19;

constraint
    chooseint_355 + chooseint_384 + chooseint_413 +
    chooseint_442 + chooseint_471 + chooseint_500 <= 19;

constraint
    chooseint_384 + chooseint_413 + chooseint_442 +
    chooseint_471 + chooseint_500 + chooseint_529 <= 19;

constraint
    chooseint_413 + chooseint_442 + chooseint_471 +
    chooseint_500 + chooseint_529 + chooseint_558 <= 19;

constraint
    chooseint_442 + chooseint_471 + chooseint_500 +
    chooseint_529 + chooseint_558 + chooseint_587 <= 19;

var 0..65: obj_max =
    chooseint_239 + chooseint_268 + chooseint_297 +
    chooseint_326 + chooseint_355 + chooseint_384 +
    chooseint_413 + chooseint_442 + chooseint_471 +
    chooseint_500 + chooseint_529 + chooseint_558 +
    chooseint_587;

constraint obj_max <= 43;

var -ub(obj_max)..-lb(obj_max): objective = -1 * obj_max;

solve minimize objective;
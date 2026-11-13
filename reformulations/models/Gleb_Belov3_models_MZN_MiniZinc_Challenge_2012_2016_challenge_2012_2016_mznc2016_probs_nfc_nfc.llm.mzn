int: n_periods;
int: shift_periods;
set of int: Periods = 0..n_periods - 1;
array[Periods] of int: worker_count;

array[Periods] of var 0..max(worker_count): w;
array[Periods] of var 0..max(worker_count): f;

var 0..n_periods * max(worker_count): objective;

constraint forall (nfc_rf_period in Periods) (
    w[nfc_rf_period] >= worker_count[nfc_rf_period]
);

constraint forall (nfc_rf_period in Periods) (
    w[nfc_rf_period] + f[nfc_rf_period]
    =
    w[(nfc_rf_period + n_periods - 1) mod n_periods]
    +
    f[(nfc_rf_period + (shift_periods mod n_periods)) mod n_periods]
);

constraint objective = sum(nfc_rf_period in Periods)(
    w[nfc_rf_period]
);

constraint
    if shift_periods >= 0 then
        objective = shift_periods * sum(nfc_rf_period in Periods)(
            f[nfc_rf_period]
        )
    else
        forall (nfc_rf_period in Periods) (
            w[nfc_rf_period] = 0
        )
    endif;

solve minimize objective;

output [
    "w = array1d(\(Periods), \(w));\n",
    "f = array1d(\(Periods), \(f));\n",
    "objective = \(objective);\n"
];
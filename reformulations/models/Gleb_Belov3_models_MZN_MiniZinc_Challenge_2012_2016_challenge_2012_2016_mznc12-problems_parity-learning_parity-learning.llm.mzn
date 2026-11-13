int: num_vars;
set of int: VARS = 1..num_vars;

int: num_samples;
set of int: SAMPLES = 1..num_samples;

int: max_errors;

array [SAMPLES, VARS] of bool: sample_inputs;
array [SAMPLES] of bool: sample_outputs;

constraint assert(max_errors >= 0, "max_errors can't be negative");
constraint assert(max_errors <= num_samples,
    "max_errors can't be greater than num_samples");
constraint assert(num_vars > 0, "num_vars must be positive");
constraint assert(num_samples > 0, "num_samples must be positive");

array [VARS] of var bool: parity_bits;
array [SAMPLES] of var bool: computed_parities;

array [index_set(sample_outputs)] of int: plrf_degree =
    [sum(plrf_v in VARS)(bool2int(sample_inputs[plrf_s, plrf_v]))
     | plrf_s in index_set(sample_outputs)];

array [index_set(sample_outputs)] of var 0..(num_vars div 2):
    plrf_quotient;

constraint forall(plrf_s in SAMPLES)(
    plrf_quotient[plrf_s] <= plrf_degree[plrf_s] div 2
);

constraint forall(plrf_s in SAMPLES)(
    sum(plrf_v in VARS where sample_inputs[plrf_s, plrf_v])(
        bool2int(parity_bits[plrf_v])
    ) =
    2 * plrf_quotient[plrf_s]
    + bool2int(computed_parities[plrf_s])
);

constraint forall(
    plrf_s in SAMPLES,
    plrf_v in VARS
    where sample_inputs[plrf_s, plrf_v]
)(
    bool2int(parity_bits[plrf_v])
    <= plrf_quotient[plrf_s]
       + bool2int(computed_parities[plrf_s])
);

constraint forall(
    plrf_s in SAMPLES
    where plrf_degree[plrf_s] mod 2 = 0
)(
    plrf_quotient[plrf_s]
    + bool2int(computed_parities[plrf_s])
    <= plrf_degree[plrf_s] div 2
);

constraint forall(
    plrf_s in SAMPLES,
    plrf_v in VARS
    where plrf_degree[plrf_s] mod 2 = 1
          /\ sample_inputs[plrf_s, plrf_v]
)(
    plrf_quotient[plrf_s]
    + bool2int(computed_parities[plrf_s])
    - bool2int(parity_bits[plrf_v])
    <= plrf_degree[plrf_s] div 2
);

var 0..max_errors: num_errors =
    sum(plrf_s in SAMPLES)(
        if sample_outputs[plrf_s] then
            1 - bool2int(computed_parities[plrf_s])
        else
            bool2int(computed_parities[plrf_s])
        endif
    );

solve minimize num_errors;

output [
    "The parity bits ", show([bool2int(parity_bits[v]) | v in VARS]), "\n",
    "disagree with ", show(num_errors),
    " out of ", show(num_samples), " samples ",
    "(max allowed is ", show(max_errors), ").\n",
    if fix(num_errors) > 0 then "Disagreeing samples:\n" else "" endif
    ] ++ [
    if fix(sample_outputs[s] != computed_parities[s])
    then
        show(s) ++ ": parity("
        ++ show([bool2int(sample_inputs[s,v]) | v in VARS]) ++ ") = "
        ++ show(sample_outputs[s]) ++ "\n"
    else ""
    endif | s in SAMPLES ];
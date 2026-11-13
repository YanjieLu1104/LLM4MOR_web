array[int] of int: rb11_weights = [4,1,8,8,10,1,5,3,8,6,1];
array[int] of int: rb11_bin_ids = [4,7,10,13,16,19,22,25,28,31,34];

set of int: rb11_items = index_set(rb11_weights);
set of int: rb11_bins = index_set(rb11_bin_ids);

int: rb11_capacity = 20;

array[rb11_items] of var rb11_bins: rb11_assignment;
array[rb11_items, rb11_bins] of var 0..1: rb11_x;
array[rb11_bins] of var 0..1: rb11_used;
array[rb11_bins] of var 0..rb11_capacity: rb11_load;

var 0..length(rb11_bin_ids): objective;

constraint forall(rb11_i in rb11_items)(
    sum(rb11_b in rb11_bins)(rb11_x[rb11_i, rb11_b]) = 1
);

constraint forall(rb11_i in rb11_items)(
    rb11_assignment[rb11_i] =
        sum(rb11_b in rb11_bins)(
            rb11_b * rb11_x[rb11_i, rb11_b]
        )
);

constraint forall(rb11_i in rb11_items, rb11_b in rb11_bins)(
    rb11_x[rb11_i, rb11_b] <= rb11_used[rb11_b]
);

constraint forall(rb11_b in rb11_bins)(
    rb11_used[rb11_b] <=
        sum(rb11_i in rb11_items)(rb11_x[rb11_i, rb11_b])
    /\
    rb11_load[rb11_b] =
        sum(rb11_i in rb11_items)(
            rb11_weights[rb11_i] * rb11_x[rb11_i, rb11_b]
        )
    /\
    rb11_load[rb11_b] <= rb11_capacity * rb11_used[rb11_b]
);

constraint forall(rb11_b in rb11_bins where rb11_b < max(rb11_bins))(
    rb11_load[rb11_b] >= rb11_load[rb11_b + 1]
);

constraint objective =
    sum(rb11_b in rb11_bins)(rb11_used[rb11_b]);

constraint objective >=
    (sum(rb11_weights) + rb11_capacity - 1) div rb11_capacity;

solve minimize objective;
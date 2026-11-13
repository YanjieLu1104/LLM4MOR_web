array[int] of string: zph15_group_names = [
    "c3_xlarge",
    "m3_medium",
    "m1_large",
    "m1_xlarge",
    "c3_large",
    "amazon_internals"
];

array[index_set(zph15_group_names)] of int: zph15_group_sizes =
    array1d(index_set(zph15_group_names), [15, 15, 15, 15, 15, 1]);

array[int] of string: zph15_location_names = [
    zph15_group_names[zph15_g]
    | zph15_g in index_set(zph15_group_names),
      zph15_r in 1..zph15_group_sizes[zph15_g]
];

array[int] of string: zph15_component_names = [
    "platformserviceimpl",
    "loadbalancerserviceimpl",
    "deploymentserviceimpl",
    "serviceproviderimpl",
    "queryserviceimpl",
    "infrastructureserviceimpl"
];

array[int] of string: zph15_category_names = [
    "platform_provider",
    "loadbalancer",
    "deployment_query",
    "infrastructure"
];

array[index_set(zph15_category_names)] of int: zph15_category_component =
    array1d(index_set(zph15_category_names), [1, 2, 3, 6]);

array[index_set(zph15_category_names)] of int: zph15_category_rank =
    array1d(index_set(zph15_category_names), [3, 2, 4, 1]);

array[index_set(zph15_component_names)] of int: zph15_objective_weight =
    array1d(index_set(zph15_component_names), [2, 2, 1, 2, 2, 1]);

array[
    index_set(zph15_location_names),
    index_set(zph15_component_names)
] of var 0..100000: zph15_counts;

array[
    index_set(zph15_location_names),
    index_set(zph15_category_names)
] of var 0..1: zph15_active;

var 0..100000: objective;

constraint forall(zph15_c in index_set(zph15_component_names)) (
    sum(zph15_l in index_set(zph15_location_names)) (
        zph15_counts[zph15_l, zph15_c]
    ) <= 100000
);

constraint sum(zph15_l in index_set(zph15_location_names)) (
    zph15_counts[zph15_l, 5]
) = 10;

constraint forall(zph15_c in {1, 2, 4}) (
    sum(zph15_l in index_set(zph15_location_names)) (
        zph15_counts[zph15_l, zph15_c]
    ) >= 1
);

constraint forall(zph15_l in index_set(zph15_location_names)) (
    zph15_counts[zph15_l, 5] <= 1 /\
    zph15_counts[zph15_l, 5] <= zph15_counts[zph15_l, 3] /\
    zph15_counts[zph15_l, 5] <= zph15_active[zph15_l, 3] /\
    zph15_counts[zph15_l, 4] <= 100000 * zph15_active[zph15_l, 1] /\
    sum(zph15_k in index_set(zph15_category_names)) (
        zph15_active[zph15_l, zph15_k]
    ) <= 1
);

constraint forall(
    zph15_l in index_set(zph15_location_names),
    zph15_k in index_set(zph15_category_names)
) (
    zph15_counts[zph15_l, zph15_category_component[zph15_k]]
        >= zph15_active[zph15_l, zph15_k] /\
    zph15_counts[zph15_l, zph15_category_component[zph15_k]]
        <= 100000 * zph15_active[zph15_l, zph15_k]
);

constraint objective =
    sum(
        zph15_l in index_set(zph15_location_names),
        zph15_c in index_set(zph15_component_names)
    ) (
        zph15_objective_weight[zph15_c] * zph15_counts[zph15_l, zph15_c]
    );

constraint objective >= 36;

constraint sum(zph15_l in index_set(zph15_location_names)) (
    zph15_counts[zph15_l, 3]
) >= 10;

constraint forall(zph15_k in {1, 2}) (
    sum(zph15_l in index_set(zph15_location_names)) (
        zph15_active[zph15_l, zph15_k]
    ) >= 1
);

constraint sum(
    zph15_l in index_set(zph15_location_names),
    zph15_k in index_set(zph15_category_names)
) (
    zph15_active[zph15_l, zph15_k]
) >= 12;

constraint forall(
    zph15_l in index_set(zph15_location_names)
    where zph15_l < max(index_set(zph15_location_names))
) (
    zph15_counts[zph15_l, 5] >= zph15_counts[zph15_l + 1, 5]
);

constraint forall(
    zph15_l in index_set(zph15_location_names)
    where zph15_l < max(index_set(zph15_location_names))
) (
    sum(zph15_k in index_set(zph15_category_names)) (
        zph15_category_rank[zph15_k] * zph15_active[zph15_l, zph15_k]
    ) >=
    sum(zph15_k in index_set(zph15_category_names)) (
        zph15_category_rank[zph15_k] * zph15_active[zph15_l + 1, zph15_k]
    )
);

solve minimize objective;
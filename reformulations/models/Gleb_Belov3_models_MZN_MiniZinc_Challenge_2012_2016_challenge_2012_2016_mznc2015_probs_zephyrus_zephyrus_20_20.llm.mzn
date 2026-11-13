array[int] of set of int: rf01_location_groups = [
    0..19,
    20..39,
    40..59,
    60..79,
    80..99,
    100..100
];

array[index_set(rf01_location_groups)] of string: rf01_location_families = [
    "c3_xlarge",
    "m3_medium",
    "m1_large",
    "m1_xlarge",
    "c3_large",
    "amazon_internals"
];

array[int] of int: rf01_location_ids = [
    rf01_location
    | rf01_group in index_set(rf01_location_groups),
      rf01_location in rf01_location_groups[rf01_group]
];

array[int] of string: rf01_component_names = [
    "component_def___fredhoppercloudservices_platformserviceimpl_on",
    "component_def___fredhoppercloudservices_loadbalancerserviceimpl_on",
    "component_def___fredhoppercloudservices_deploymentserviceimpl_on",
    "component_def___fredhoppercloudservices_serviceproviderimpl_on",
    "component_def___fredhoppercloudservices_queryserviceimpl_on",
    "component_amazon_internals___fredhoppercloudservices_infrastructureserviceimpl_on"
];

array[
    index_set(rf01_location_ids),
    index_set(rf01_component_names)
] of var 0..1: rf01_count;

var 0..100000: objective;

constraint sum(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 1]
) = 1;

constraint sum(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 2]
) = 1;

constraint sum(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 5]
) = 20;

constraint forall(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 4] = rf01_count[rf01_row, 1]
);

constraint forall(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 3] = rf01_count[rf01_row, 5]
);

constraint forall(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 6] = 0
);

constraint forall(rf01_row in index_set(rf01_location_ids))(
    rf01_count[rf01_row, 1]
    + rf01_count[rf01_row, 2]
    + rf01_count[rf01_row, 5] <= 1
);

constraint objective =
    sum(rf01_row in index_set(rf01_location_ids))(
        2 * (
            rf01_count[rf01_row, 1]
            + rf01_count[rf01_row, 2]
            + rf01_count[rf01_row, 4]
            + rf01_count[rf01_row, 5]
        )
        + rf01_count[rf01_row, 3]
        + rf01_count[rf01_row, 6]
    );

solve minimize objective;
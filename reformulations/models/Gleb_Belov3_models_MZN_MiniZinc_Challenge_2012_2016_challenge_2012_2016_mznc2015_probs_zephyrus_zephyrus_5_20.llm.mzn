array[int] of string: zrf_1_locations = [
    "c3_xlarge___0",
    "c3_xlarge___1",
    "c3_xlarge___2",
    "c3_xlarge___3",
    "c3_xlarge___4",
    "m3_medium___5",
    "m3_medium___6",
    "m3_medium___7",
    "m3_medium___8",
    "m3_medium___9",
    "m1_large___10",
    "m1_large___11",
    "m1_large___12",
    "m1_large___13",
    "m1_large___14",
    "m1_xlarge___15",
    "m1_xlarge___16",
    "m1_xlarge___17",
    "m1_xlarge___18",
    "m1_xlarge___19",
    "c3_large___20",
    "c3_large___21",
    "c3_large___22",
    "c3_large___23",
    "c3_large___24",
    "amazon_internals___25"
];

array[int] of string: zrf_1_components = [
    "def___fredhoppercloudservices_platformserviceimpl_on",
    "def___fredhoppercloudservices_loadbalancerserviceimpl_on",
    "def___fredhoppercloudservices_deploymentserviceimpl_on",
    "def___fredhoppercloudservices_serviceproviderimpl_on",
    "def___fredhoppercloudservices_queryserviceimpl_on",
    "amazon_internals___fredhoppercloudservices_infrastructureserviceimpl_on"
];

array[index_set(zrf_1_locations), index_set(zrf_1_components)]
    of var 0..100000: zrf_1_local;

array[index_set(zrf_1_components)] of var 0..100000: zrf_1_total;

var 0..100000: objective;

array[int] of int: zrf_1_group_columns = [1, 2, 3, 6];

array[index_set(zrf_1_group_columns)] of int: zrf_1_group_cap = [
    if zrf_1_group_columns[zrf_1_g] = 1 \/
       zrf_1_group_columns[zrf_1_g] = 2 then
        (100000 - (2 * 20 + 20 + 2 + 2)) div 2
    elseif zrf_1_group_columns[zrf_1_g] = 3 then
        100000 - (2 * 20 + 2 + 2 + 2)
    else
        100000 - (2 * 20 + 20 + 2 + 2 + 2)
    endif
    | zrf_1_g in index_set(zrf_1_group_columns)
];

array[index_set(zrf_1_locations), index_set(zrf_1_group_columns)]
    of var 0..1: zrf_1_present;

constraint forall(zrf_1_c in index_set(zrf_1_components)) (
    zrf_1_total[zrf_1_c] =
        sum(zrf_1_i in index_set(zrf_1_locations)) (
            zrf_1_local[zrf_1_i, zrf_1_c]
        )
);

constraint zrf_1_total[5] = 20;
constraint zrf_1_total[1] >= 1;
constraint zrf_1_total[2] >= 1;
constraint zrf_1_total[4] >= 1;

constraint forall(zrf_1_i in index_set(zrf_1_locations)) (
    zrf_1_local[zrf_1_i, 5] <= 1
);

constraint forall(
    zrf_1_i in index_set(zrf_1_locations),
    zrf_1_g in index_set(zrf_1_group_columns)
) (
    zrf_1_local[zrf_1_i, zrf_1_group_columns[zrf_1_g]]
        >= zrf_1_present[zrf_1_i, zrf_1_g]
    /\
    zrf_1_local[zrf_1_i, zrf_1_group_columns[zrf_1_g]]
        <= zrf_1_group_cap[zrf_1_g]
           * zrf_1_present[zrf_1_i, zrf_1_g]
);

constraint forall(zrf_1_i in index_set(zrf_1_locations)) (
    sum(zrf_1_g in index_set(zrf_1_group_columns)) (
        zrf_1_present[zrf_1_i, zrf_1_g]
    ) <= 1
);

constraint forall(zrf_1_i in index_set(zrf_1_locations)) (
    zrf_1_local[zrf_1_i, 4] <=
        ((100000 - (2 * 20 + 20 + 2 + 2)) div 2)
        * zrf_1_present[zrf_1_i, 1]
    /\
    zrf_1_local[zrf_1_i, 5] <= zrf_1_present[zrf_1_i, 3]
    /\
    zrf_1_local[zrf_1_i, 3] >= zrf_1_local[zrf_1_i, 5]
);

constraint sum(zrf_1_i in index_set(zrf_1_locations)) (
    zrf_1_present[zrf_1_i, 1]
) >= 1;

constraint sum(zrf_1_i in index_set(zrf_1_locations)) (
    zrf_1_present[zrf_1_i, 2]
) >= 1;

constraint sum(zrf_1_i in index_set(zrf_1_locations)) (
    zrf_1_present[zrf_1_i, 3]
) >= 20;

constraint zrf_1_total[3] >= 20;

constraint objective =
    2 * (
        zrf_1_total[1]
        + zrf_1_total[2]
        + zrf_1_total[4]
        + zrf_1_total[5]
    )
    + zrf_1_total[3]
    + zrf_1_total[6];

constraint objective >= 2 * (20 + 1 + 1 + 1) + 20;

solve minimize objective;
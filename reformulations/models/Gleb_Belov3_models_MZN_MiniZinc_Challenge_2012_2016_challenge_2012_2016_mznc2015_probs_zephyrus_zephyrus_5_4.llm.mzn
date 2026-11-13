array[int] of string: zeph_reform_2_locations = [
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

array[int] of string: zeph_reform_2_components = [
    "def___fredhoppercloudservices_platformserviceimpl_on",
    "def___fredhoppercloudservices_loadbalancerserviceimpl_on",
    "def___fredhoppercloudservices_deploymentserviceimpl_on",
    "def___fredhoppercloudservices_serviceproviderimpl_on",
    "def___fredhoppercloudservices_queryserviceimpl_on",
    "amazon_internals___fredhoppercloudservices_infrastructureserviceimpl_on"
];

set of int: zeph_reform_2_location_indices =
    index_set(zeph_reform_2_locations);
set of int: zeph_reform_2_component_indices =
    index_set(zeph_reform_2_components);

array[
    zeph_reform_2_location_indices,
    zeph_reform_2_component_indices
] of var 0..1: zeph_reform_2_counts;

var 18..18: objective;

constraint sum(
    zeph_reform_2_i in zeph_reform_2_location_indices
)(zeph_reform_2_counts[zeph_reform_2_i, 1]) = 1;

constraint sum(
    zeph_reform_2_i in zeph_reform_2_location_indices
)(zeph_reform_2_counts[zeph_reform_2_i, 2]) = 1;

constraint sum(
    zeph_reform_2_i in zeph_reform_2_location_indices
)(zeph_reform_2_counts[zeph_reform_2_i, 3]) = 4;

constraint sum(
    zeph_reform_2_i in zeph_reform_2_location_indices
)(zeph_reform_2_counts[zeph_reform_2_i, 4]) = 1;

constraint sum(
    zeph_reform_2_i in zeph_reform_2_location_indices
)(zeph_reform_2_counts[zeph_reform_2_i, 5]) = 4;

constraint forall(
    zeph_reform_2_i in zeph_reform_2_location_indices
)(
    zeph_reform_2_counts[zeph_reform_2_i, 6] = 0 /\
    zeph_reform_2_counts[zeph_reform_2_i, 3] =
        zeph_reform_2_counts[zeph_reform_2_i, 5] /\
    zeph_reform_2_counts[zeph_reform_2_i, 1] =
        zeph_reform_2_counts[zeph_reform_2_i, 4] /\
    zeph_reform_2_counts[zeph_reform_2_i, 1] +
    zeph_reform_2_counts[zeph_reform_2_i, 2] +
    zeph_reform_2_counts[zeph_reform_2_i, 5] <= 1
);

constraint objective =
    sum(zeph_reform_2_i in zeph_reform_2_location_indices)(
        2 * (
            zeph_reform_2_counts[zeph_reform_2_i, 1] +
            zeph_reform_2_counts[zeph_reform_2_i, 2] +
            zeph_reform_2_counts[zeph_reform_2_i, 4] +
            zeph_reform_2_counts[zeph_reform_2_i, 5]
        ) +
        zeph_reform_2_counts[zeph_reform_2_i, 3] +
        zeph_reform_2_counts[zeph_reform_2_i, 6]
    );

solve minimize objective;
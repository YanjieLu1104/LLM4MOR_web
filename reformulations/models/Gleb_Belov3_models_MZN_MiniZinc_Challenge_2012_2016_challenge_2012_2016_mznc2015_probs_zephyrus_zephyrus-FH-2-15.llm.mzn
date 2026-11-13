var 0..100000 : objective;
var 0..100000 : global_component_def___fredhoppercloudservices_platformserviceimpl_on;
var 0..100000 : global_component_def___fredhoppercloudservices_loadbalancerserviceimpl_on;
var 0..100000 : global_component_def___fredhoppercloudservices_deploymentserviceimpl_on;
var 0..100000 : global_component_def___fredhoppercloudservices_serviceproviderimpl_on;
var 0..100000 : global_component_def___fredhoppercloudservices_queryserviceimpl_on;
var 0..100000 : global_component_amazon_internals___fredhoppercloudservices_infrastructureserviceimpl_on;

constraint global_component_def___fredhoppercloudservices_queryserviceimpl_on = 2;
constraint global_component_def___fredhoppercloudservices_platformserviceimpl_on >= 1;
constraint global_component_def___fredhoppercloudservices_loadbalancerserviceimpl_on >= 1;
constraint global_component_def___fredhoppercloudservices_serviceproviderimpl_on >= 1;
constraint global_component_def___fredhoppercloudservices_deploymentserviceimpl_on >= 2;

constraint objective =
    2 * (
        global_component_def___fredhoppercloudservices_platformserviceimpl_on
        + global_component_def___fredhoppercloudservices_loadbalancerserviceimpl_on
        + global_component_def___fredhoppercloudservices_serviceproviderimpl_on
        + global_component_def___fredhoppercloudservices_queryserviceimpl_on
    )
    + global_component_def___fredhoppercloudservices_deploymentserviceimpl_on
    + global_component_amazon_internals___fredhoppercloudservices_infrastructureserviceimpl_on;

constraint objective >= 12;

solve minimize objective;

output [
    "objective = ", show(objective), ";\n"
];
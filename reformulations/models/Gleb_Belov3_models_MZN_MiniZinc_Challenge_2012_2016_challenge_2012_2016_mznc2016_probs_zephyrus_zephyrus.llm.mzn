% Copyright (c) 2016, Jacopo Mauro. All rights reserved.
% This file is licensed under the terms of the ISC License.

include "lex_greatereq.mzn";
include "lex_less.mzn";

int: MAX_INT = 4096;

set of int: comps;
set of int: ports;
set of int: multi_provide_ports;
set of int: locations;
set of int: resources;

array[comps, ports] of int: requirement_port_nums;
array[comps, multi_provide_ports] of int: provide_port_nums;
array[comps, ports] of bool: conflicts;
array[multi_provide_ports, ports] of bool: multi_provides;

array[locations] of int: costs;
array[locations, resources] of int: resource_provisions;
array[comps, resources] of int: resource_consumptions;

array[multi_provide_ports, ports, comps, comps]
    of var 0..MAX_INT: bindings;
array[comps] of var 0..MAX_INT: comps_num;
array[locations, comps] of var 0..MAX_INT: comp_locations;

var 0..MAX_INT: sum_comp;

array[locations] of var 0..1: used_locations;
array[index_set(comps_num)] of var 0..1: zb16_present;

constraint sum_comp = sum(i in comps)(comps_num[i]);

constraint forall(i in comps)(
    comps_num[i] >= zb16_present[i] /\
    comps_num[i] <= MAX_INT * zb16_present[i]
);

constraint forall(
    mport in multi_provide_ports,
    port in ports
    where not multi_provides[mport, port]
)(
    forall(i in comps, j in comps)(
        bindings[mport, port, i, j] = 0
    )
);

constraint forall(
    mport in multi_provide_ports,
    pcomp in comps
)(
    if provide_port_nums[pcomp, mport] = 0 then
        forall(port in ports, rcomp in comps)(
            bindings[mport, port, pcomp, rcomp] = 0
        )
    elseif provide_port_nums[pcomp, mport] = -1 then
        forall(port in ports, rcomp in comps)(
            bindings[mport, port, pcomp, rcomp]
                <= MAX_INT * zb16_present[pcomp]
        )
    else
        sum(port in ports, rcomp in comps)(
            bindings[mport, port, pcomp, rcomp]
        ) <= comps_num[pcomp] * provide_port_nums[pcomp, mport]
    endif
);

constraint forall(port in ports, rcomp in comps)(
    sum(mport in multi_provide_ports, pcomp in comps)(
        bindings[mport, port, pcomp, rcomp]
    ) = comps_num[rcomp] * requirement_port_nums[rcomp, port]
);

constraint forall(
    pcomp in comps,
    rcomp in comps
    where exists(port in ports)(
        conflicts[rcomp, port] /\
        exists(mport in multi_provide_ports)(
            multi_provides[mport, port] /\
            provide_port_nums[pcomp, mport] != 0
        )
    )
)(
    zb16_present[pcomp] + zb16_present[rcomp] <= 1
);

constraint forall(
    mport in multi_provide_ports,
    pcomp in comps,
    rcomp in comps
)(
    let {
        int: max_req = sum(port in ports)(
            if multi_provides[mport, port] then
                requirement_port_nums[rcomp, port]
            else
                0
            endif
        )
    } in
    if pcomp = rcomp then
        sum(port in ports)(
            bindings[mport, port, pcomp, rcomp]
        ) <= max_req * (comps_num[pcomp] - zb16_present[pcomp])
        /\
        (
            if provide_port_nums[pcomp, mport] != 0 /\
               exists(port in ports)(multi_provides[mport, port])
            then
                forall(i in 2..min(MAX_INT, max_req - 1))(
                    comps_num[pcomp] = i ->
                    sum(port in ports)(
                        bindings[mport, port, pcomp, rcomp]
                    ) <= i * (i - 1)
                )
            else
                true
            endif
        )
    else
        sum(port in ports)(
            bindings[mport, port, pcomp, rcomp]
        ) <= max_req * comps_num[rcomp]
        /\
        (
            if provide_port_nums[pcomp, mport] != 0 /\
               exists(port in ports)(multi_provides[mport, port])
            then
                forall(i in 1..min(MAX_INT, max_req - 1))(
                    comps_num[pcomp] = i ->
                    sum(port in ports)(
                        bindings[mport, port, pcomp, rcomp]
                    ) <= i * comps_num[rcomp]
                )
            else
                true
            endif
        )
    endif
);

constraint forall(l in locations)(
    sum(c in comps)(comp_locations[l, c]) >= used_locations[l]
    /\
    sum(c in comps)(comp_locations[l, c])
        <= MAX_INT * used_locations[l]
);

constraint forall(c in comps)(
    sum(l in locations)(comp_locations[l, c]) = comps_num[c]
);

constraint forall(res in resources, loc in locations)(
    sum(comp in comps)(
        comp_locations[loc, comp] * resource_consumptions[comp, res]
    ) <= resource_provisions[loc, res]
);

constraint sum(i in locations)(used_locations[i]) <= sum_comp;

constraint symmetry_breaking_constraint(
    forall(l1 in locations, l2 in locations)(
        if l1 < l2 /\
           forall(r in resources)(
               resource_provisions[l1, r] = resource_provisions[l2, r]
           )
        then
            if costs[l1] > costs[l2] then
                lex_greatereq(
                    [comp_locations[l2, c] | c in comps],
                    [comp_locations[l1, c] | c in comps]
                )
                /\
                (used_locations[l1] = 1 -> used_locations[l2] = 1)
            else
                lex_greatereq(
                    [comp_locations[l1, c] | c in comps],
                    [comp_locations[l2, c] | c in comps]
                )
                /\
                (used_locations[l2] = 1 -> used_locations[l1] = 1)
            endif
        else
            true
        endif
    )
);

constraint
    (
        sum(l in locations)(comp_locations[l, 1]) > 0
        \/
        sum(l in locations)(comp_locations[l, 2]) > 0
    )
    /\
    forall(x in locations)(comp_locations[x, 3] < 2)
    /\
    forall(x in locations)(comp_locations[x, 4] < 2);

int: obj_min =
    sum(l in locations)(if costs[l] < 0 then costs[l] else 0 endif);
int: obj_max =
    sum(l in locations)(if costs[l] > 0 then costs[l] else 0 endif);

var obj_min..obj_max: objective;

constraint objective = sum(l in locations)(used_locations[l] * costs[l]);

array[locations] of locations: costs_asc = arg_sort(costs);
array[locations] of locations: costs_desc = reverse(costs_asc);

solve minimize objective;

output [
    "bindings = array4d(\(multi_provide_ports), \(ports), \(comps), \(comps), \(bindings));\n",
    "comps_num = \(comps_num);\n",
    "comp_locations = array2d(\(locations), \(comps), \(comp_locations));\n",
    "used_locations = \(used_locations);\n",
    "objective = \(objective);\n",
    "% [\(objective), \(sum(x in locations)(sum(y in comps)(comp_locations[x,y])))]\n"
];
include "globals.mzn";

int: row;
int: col;
int: k = row*col;
int: n = k + 2;
int: no_links;
int: m = no_links + 2*k;
int: no_flows;
int: link_bandwidth;

int: no_actors;

array[1..m, 1..2] of int: arc;
array[1..m] of int: unit_cost;
array[1..no_flows, 1..n] of int: balance;

int: processor_load;
array[1..k] of var 0..processor_load: cpu_loads;

array[1..no_actors] of int: actor_load;
array[1..2, 1..no_flows] of int: load;

array[1..no_flows] of var 0..10000: cost;

var 0..10000: communication_cost;
var 0..10000: objective;

array[1..2*no_flows] of var 1..k: flow_processor;

array[1..no_links] of var 0..link_bandwidth: comm_full;
array[1..k] of var 0..5*link_bandwidth: flow_from_processor;

array[1..k] of var 0..10000*no_flows: cc;

array[1..no_flows] of int: inStream;
array[1..no_flows, 1..n] of int: b;

array[1..no_flows, 1..k] of var 0..max(inStream): inFlow;
array[1..no_flows, 1..k] of var 0..max(inStream): outFlow;
array[1..no_flows, 1..no_links] of var 0..link_bandwidth: commFlow;

array[1..no_flows, 1..m] of
    var 0..max(max(inStream),link_bandwidth): flows;

array[1..no_flows, 1..2] of int: source_destination_actor;

array[1..no_actors] of var 1..k: actor_processor;

array[1..2*k*no_flows + no_links] of
    var 0..max(max(inStream),link_bandwidth): total_flow;
array[1..2*k*no_flows + no_links] of int: total_unit_cost;
array[1..k+2*no_flows] of int: total_balance;

array[1..2*no_flows*k] of int: in_connections;
array[1..2*no_flows*k] of int: out_connections;
array[1..2*no_flows*k+no_links, 1..2] of int: all_connections;

array[1..no_links] of string: link_str;

array[index_set(flow_processor)] of int: rf_endpoint_actor =
    array1d(
        index_set(flow_processor),
        [
            if rf_e <= no_flows then
                source_destination_actor[rf_e,1]
            else
                source_destination_actor[rf_e-no_flows,2]
            endif
            | rf_e in index_set(flow_processor)
        ]
    );

array[index_set(flow_processor)] of int: rf_representative =
    array1d(
        index_set(flow_processor),
        [
            min([
                rf_t
                | rf_t in index_set(flow_processor)
                where rf_endpoint_actor[rf_t] = rf_endpoint_actor[rf_e]
            ])
            | rf_e in index_set(flow_processor)
        ]
    );

array[index_set(flow_processor), index_set(cpu_loads)] of
    var bool: rf_selected;

array[index_set(cost), index_set(cpu_loads)] of
    var 0..10000: rf_allocated_cost;

constraint
    forall(rf_e in index_set(flow_processor)) (
        sum(rf_p in index_set(cpu_loads)) (
            bool2int(rf_selected[rf_e,rf_p])
        ) = 1
    );

constraint
    forall(
        rf_e in index_set(flow_processor),
        rf_p in index_set(cpu_loads)
    ) (
        rf_selected[rf_e,rf_p] <->
        flow_processor[rf_e] = rf_p
    );

constraint
    forall(
        rf_e in index_set(flow_processor),
        rf_p in index_set(cpu_loads)
        where rf_e != rf_representative[rf_e]
    ) (
        rf_selected[rf_e,rf_p] =
        rf_selected[rf_representative[rf_e],rf_p]
    );

constraint
    forall(
        rf_f in index_set_1of2(inFlow),
        rf_p in index_set_2of2(inFlow)
    ) (
        inFlow[rf_f,rf_p] in {0,inStream[rf_f]} /\
        outFlow[rf_f,rf_p] in {0,inStream[rf_f]}
    );

constraint
    forall(
        rf_f in index_set(cost),
        rf_p in index_set(cpu_loads)
    ) (
        flows[rf_f,rf_p] >= bool2int(rf_selected[rf_f,rf_p]) /\
        flows[rf_f,rf_p] <=
            max(max(inStream),link_bandwidth) *
            bool2int(rf_selected[rf_f,rf_p]) /\
        flows[rf_f,m-k+rf_p] >=
            bool2int(rf_selected[no_flows+rf_f,rf_p]) /\
        flows[rf_f,m-k+rf_p] <=
            max(max(inStream),link_bandwidth) *
            bool2int(rf_selected[no_flows+rf_f,rf_p])
    );

constraint
    forall(rf_f in index_set(cost)) (
        network_flow_cost(
            arc,
            [balance[rf_f,rf_p] | rf_p in index_set_2of2(balance)],
            unit_cost,
            [flows[rf_f,rf_a] | rf_a in index_set_2of2(flows)],
            cost[rf_f]
        )
    );

constraint
    network_flow_cost(
        all_connections,
        total_balance,
        total_unit_cost,
        total_flow,
        communication_cost
    );

constraint
    forall(rf_a in index_set(comm_full)) (
        comm_full[rf_a] =
            sum(rf_f in index_set(cost)) (
                flows[rf_f,rf_a+k]
            )
    );

constraint
    bin_packing_load(
        cpu_loads,
        flow_processor,
        [
            load[rf_s,rf_f]
            | rf_s in index_set_1of2(load),
              rf_f in index_set_2of2(load)
        ]
    );

constraint
    forall(rf_f in index_set(cost)) (
        sum(rf_p in index_set(cpu_loads)) (
            rf_allocated_cost[rf_f,rf_p]
        ) = cost[rf_f]
    );

constraint
    forall(
        rf_f in index_set(cost),
        rf_p in index_set(cpu_loads)
    ) (
        rf_allocated_cost[rf_f,rf_p] <=
            10000 * bool2int(
                rf_selected[source_destination_actor[rf_f,1],rf_p]
            )
    );

constraint
    forall(rf_p in index_set(cc)) (
        cc[rf_p] =
            sum(rf_f in index_set(cost)) (
                rf_allocated_cost[rf_f,rf_p]
            )
    );

constraint
    maximum(
        objective,
        [
            cpu_loads[rf_p] + cc[rf_p]
            | rf_p in index_set(cpu_loads)
        ]
    );

constraint
    forall(rf_p in index_set(flow_from_processor)) (
        flow_from_processor[rf_p] =
            sum(
                rf_f in index_set(cost),
                rf_a in k+1..no_links+k
                where arc[rf_a,1] = rf_p
            ) (
                flows[rf_f,rf_a]
            )
    );

constraint
    forall(rf_f in index_set(cost)) (
        cost[rf_f] <= objective
    );

constraint
    sum(rf_p in index_set(cpu_loads)) (
        cpu_loads[rf_p]
    ) +
    sum(rf_f in index_set(cost)) (
        cost[rf_f]
    ) <= k * objective;

solve minimize objective;
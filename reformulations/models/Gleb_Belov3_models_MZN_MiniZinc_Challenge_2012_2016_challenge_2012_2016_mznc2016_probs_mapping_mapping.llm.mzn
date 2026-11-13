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

array[1..no_flows, 1..m] of var 0..max(max(inStream),link_bandwidth): flows;

array[1..no_flows, 1..2] of int: source_destination_actor;

array[1..no_actors] of var 1..k: actor_processor;

array[1..2*k*no_flows + no_links] of var 0..max(max(inStream),link_bandwidth): total_flow;
array[1..2*k*no_flows + no_links] of int: total_unit_cost;
array[1..k+2*no_flows] of int: total_balance;

array[1..2*no_flows*k] of int: in_connections;
array[1..2*no_flows*k] of int: out_connections;
array[1..2*no_flows*k+no_links, 1..2] of int: all_connections;

array[1..no_links] of string: link_str;

int: rf_flow_bound = max(max(inStream), link_bandwidth);

array[index_set(flow_processor)] of int: rf_endpoint_actor =
    array1d(
        index_set(flow_processor),
        [
            if rf_s <= no_flows then
                source_destination_actor[rf_s, 1]
            else
                source_destination_actor[rf_s-no_flows, 2]
            endif
            | rf_s in index_set(flow_processor)
        ]
    );

array[index_set(flow_processor)] of int: rf_representative =
    array1d(
        index_set(flow_processor),
        [
            min({
                rf_t
                | rf_t in index_set(flow_processor)
                where rf_endpoint_actor[rf_t] = rf_endpoint_actor[rf_s]
            })
            | rf_s in index_set(flow_processor)
        ]
    );

array[index_set(flow_processor), index_set(cpu_loads)] of var 0..1:
    rf_assignment;

array[index_set(cost), index_set(cpu_loads)] of var 0..10000:
    rf_allocated_cost;

constraint
    forall(rf_s in index_set(flow_processor)) (
        sum(rf_p in index_set(cpu_loads)) (
            rf_assignment[rf_s, rf_p]
        ) = 1
        /\
        flow_processor[rf_s] =
            sum(rf_p in index_set(cpu_loads)) (
                rf_p * rf_assignment[rf_s, rf_p]
            )
    );

constraint
    forall(
        rf_s in index_set(flow_processor),
        rf_p in index_set(cpu_loads)
        where rf_representative[rf_s] != rf_s
    ) (
        rf_assignment[rf_s, rf_p] =
            rf_assignment[rf_representative[rf_s], rf_p]
    );

constraint
    forall(
        rf_f in index_set(cost),
        rf_p in index_set(cpu_loads)
    ) (
        inFlow[rf_f, rf_p] in {0, inStream[rf_f]}
        /\
        outFlow[rf_f, rf_p] in {0, inStream[rf_f]}
    );

constraint
    forall(
        rf_f in index_set(cost),
        rf_p in index_set(cpu_loads)
    ) (
        flows[rf_f, rf_p] >= rf_assignment[rf_f, rf_p]
        /\
        flows[rf_f, rf_p] <=
            rf_flow_bound * rf_assignment[rf_f, rf_p]
        /\
        flows[rf_f, m-k+rf_p] >=
            rf_assignment[no_flows+rf_f, rf_p]
        /\
        flows[rf_f, m-k+rf_p] <=
            rf_flow_bound * rf_assignment[no_flows+rf_f, rf_p]
    );

constraint
    forall(rf_f in index_set(cost)) (
        network_flow_cost(
            arc,
            [balance[rf_f, rf_v] | rf_v in 1..n],
            unit_cost,
            [flows[rf_f, rf_e] | rf_e in 1..m],
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
    forall(rf_e in index_set(comm_full)) (
        comm_full[rf_e] =
            sum(rf_f in index_set(cost)) (
                flows[rf_f, rf_e+k]
            )
    );

constraint
    forall(rf_p in index_set(cpu_loads)) (
        cpu_loads[rf_p] =
            sum(rf_f in index_set(cost)) (
                load[1, rf_f] * rf_assignment[rf_f, rf_p]
                +
                load[2, rf_f] * rf_assignment[no_flows+rf_f, rf_p]
            )
    );

constraint
    forall(rf_f in index_set(cost)) (
        sum(rf_p in index_set(cpu_loads)) (
            rf_allocated_cost[rf_f, rf_p]
        ) = cost[rf_f]
    );

constraint
    forall(
        rf_f in index_set(cost),
        rf_p in index_set(cpu_loads)
    ) (
        rf_allocated_cost[rf_f, rf_p] <=
            10000 * rf_assignment[source_destination_actor[rf_f, 1], rf_p]
    );

constraint
    forall(rf_p in index_set(cc)) (
        cc[rf_p] =
            sum(rf_f in index_set(cost)) (
                rf_allocated_cost[rf_f, rf_p]
            )
    );

constraint
    maximum(
        objective,
        [cpu_loads[rf_p] + cc[rf_p] | rf_p in index_set(cpu_loads)]
    );

constraint
    forall(rf_p in index_set(cpu_loads)) (
        cpu_loads[rf_p] + cc[rf_p] <= objective
    );

constraint
    forall(rf_f in index_set(cost)) (
        cost[rf_f] <= objective
    );

constraint
    sum(rf_r in index_set_1of2(load), rf_f in index_set_2of2(load)) (
        load[rf_r, rf_f]
    )
    +
    sum(rf_f in index_set(cost)) (
        cost[rf_f]
    )
    <= k * objective;

constraint
    forall(rf_p in index_set(flow_from_processor)) (
        flow_from_processor[rf_p] =
            sum(
                rf_f in index_set(cost),
                rf_e in k+1..no_links+k
                where arc[rf_e, 1] = rf_p
            ) (
                flows[rf_f, rf_e]
            )
    );

solve minimize objective;

output [
    "objective = \(objective);\n",
    "communication_cost = \(communication_cost);\n",
    "flow_processor = \(flow_processor);\n",
    "constraint total_flow = \(total_flow);\n",
    "cpu_loads = \(cpu_loads);\n",
    "inFlow = array2d(1..\(no_flows), 1..\(k), \(inFlow));\n",
    "outFlow = array2d(1..\(no_flows), 1..\(k), \(outFlow));\n",
    "commFlow = array2d(1..\(no_flows), 1..\(no_links), \(commFlow));\n",
    "constraint flows = array2d(1..\(no_flows), 1..\(m), \(flows));\n",
    "constraint actor_processor = \(actor_processor);\n"
];
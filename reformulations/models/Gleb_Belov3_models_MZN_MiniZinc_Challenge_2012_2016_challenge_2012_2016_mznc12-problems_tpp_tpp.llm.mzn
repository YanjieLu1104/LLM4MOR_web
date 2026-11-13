int: numproducts;
int: numcities;
int: maxprice;
int: maxdist;

array[1..numcities,1..numcities] of int: dist;
array[1..numcities-1,1..numproducts] of int: price;

array[1..numcities] of var 1..numcities: succ;
array[1..numcities] of var 0..maxdist: travelCost;
array[1..numproducts] of var 1..numcities-1: purchaseLoc;
array[1..numproducts] of var 0..maxprice: purchaseCost;

int: totalCost_min = lb(sum(travelCost) + sum(purchaseCost));
int: totalCost_max = ub(sum(travelCost) + sum(purchaseCost));
var totalCost_min..totalCost_max: totalCost =
    sum(travelCost) + sum(purchaseCost);

array[index_set_1of2(dist), index_set_2of2(dist)] of bool:
    tpp_rf_travel_ok =
    array2d(
        index_set_1of2(dist),
        index_set_2of2(dist),
        [
            dist[tpp_rf_i,tpp_rf_j] >= 0 /\
            dist[tpp_rf_i,tpp_rf_j] <= maxdist
            | tpp_rf_i in index_set_1of2(dist),
              tpp_rf_j in index_set_2of2(dist)
        ]
    );

array[index_set_1of2(price), index_set_2of2(price)] of bool:
    tpp_rf_purchase_ok =
    array2d(
        index_set_1of2(price),
        index_set_2of2(price),
        [
            price[tpp_rf_i,tpp_rf_p] >= 0 /\
            price[tpp_rf_i,tpp_rf_p] <= maxprice
            | tpp_rf_i in index_set_1of2(price),
              tpp_rf_p in index_set_2of2(price)
        ]
    );

array[index_set_1of2(dist), index_set_2of2(dist)] of var 0..1:
    tpp_rf_arc;

array[index_set_1of2(price), index_set_2of2(price)] of var 0..1:
    tpp_rf_buy;

int: tpp_rf_capacity = max(0, numcities - 1);

array[index_set_1of2(dist), index_set_2of2(dist)]
    of var 0.0..int2float(tpp_rf_capacity): tpp_rf_flow;

constraint forall(
    tpp_rf_i in index_set_1of2(dist),
    tpp_rf_j in index_set_2of2(dist)
    where not tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
)(
    tpp_rf_arc[tpp_rf_i,tpp_rf_j] = 0
);

constraint forall(tpp_rf_i in index_set_1of2(dist))(
    sum(
        tpp_rf_j in index_set_2of2(dist)
        where tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
    )(tpp_rf_arc[tpp_rf_i,tpp_rf_j]) = 1
);

constraint forall(tpp_rf_j in index_set_2of2(dist))(
    sum(
        tpp_rf_i in index_set_1of2(dist)
        where tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
    )(tpp_rf_arc[tpp_rf_i,tpp_rf_j]) = 1
);

constraint forall(tpp_rf_i in index_set(succ))(
    succ[tpp_rf_i] =
        sum(
            tpp_rf_j in index_set_2of2(dist)
            where tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
        )(tpp_rf_j * tpp_rf_arc[tpp_rf_i,tpp_rf_j])
);

constraint forall(tpp_rf_i in index_set(travelCost))(
    travelCost[tpp_rf_i] =
        sum(
            tpp_rf_j in index_set_2of2(dist)
            where tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
        )(
            dist[tpp_rf_i,tpp_rf_j] *
            tpp_rf_arc[tpp_rf_i,tpp_rf_j]
        )
);

constraint succ[numcities] != numcities;

constraint forall(
    tpp_rf_i in index_set_1of2(price),
    tpp_rf_p in index_set_2of2(price)
    where not tpp_rf_purchase_ok[tpp_rf_i,tpp_rf_p]
)(
    tpp_rf_buy[tpp_rf_i,tpp_rf_p] = 0
);

constraint forall(tpp_rf_p in index_set_2of2(price))(
    sum(
        tpp_rf_i in index_set_1of2(price)
        where tpp_rf_purchase_ok[tpp_rf_i,tpp_rf_p]
    )(tpp_rf_buy[tpp_rf_i,tpp_rf_p]) = 1
);

constraint forall(
    tpp_rf_i in index_set_1of2(price),
    tpp_rf_p in index_set_2of2(price)
    where tpp_rf_purchase_ok[tpp_rf_i,tpp_rf_p]
)(
    tpp_rf_buy[tpp_rf_i,tpp_rf_p] <=
        1 - tpp_rf_arc[tpp_rf_i,tpp_rf_i]
);

constraint forall(tpp_rf_p in index_set(purchaseLoc))(
    purchaseLoc[tpp_rf_p] =
        sum(
            tpp_rf_i in index_set_1of2(price)
            where tpp_rf_purchase_ok[tpp_rf_i,tpp_rf_p]
        )(tpp_rf_i * tpp_rf_buy[tpp_rf_i,tpp_rf_p])
);

constraint forall(tpp_rf_p in index_set(purchaseCost))(
    purchaseCost[tpp_rf_p] =
        sum(
            tpp_rf_i in index_set_1of2(price)
            where tpp_rf_purchase_ok[tpp_rf_i,tpp_rf_p]
        )(
            price[tpp_rf_i,tpp_rf_p] *
            tpp_rf_buy[tpp_rf_i,tpp_rf_p]
        )
);

constraint forall(
    tpp_rf_i in index_set_1of2(dist),
    tpp_rf_j in index_set_2of2(dist)
    where tpp_rf_i = tpp_rf_j \/
          tpp_rf_j = numcities \/
          not tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
)(
    tpp_rf_flow[tpp_rf_i,tpp_rf_j] = 0.0
);

constraint forall(
    tpp_rf_i in index_set_1of2(dist),
    tpp_rf_j in index_set_2of2(dist)
    where tpp_rf_i != tpp_rf_j /\
          tpp_rf_j != numcities /\
          tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
)(
    tpp_rf_flow[tpp_rf_i,tpp_rf_j] <=
        int2float(tpp_rf_capacity * tpp_rf_arc[tpp_rf_i,tpp_rf_j])
    /\
    tpp_rf_flow[tpp_rf_i,tpp_rf_j] >=
        int2float(tpp_rf_arc[tpp_rf_i,tpp_rf_j])
);

constraint forall(
    tpp_rf_i in index_set_1of2(dist)
    where tpp_rf_i != numcities
)(
    sum(
        tpp_rf_j in index_set_1of2(dist)
        where tpp_rf_j != tpp_rf_i /\
              tpp_rf_travel_ok[tpp_rf_j,tpp_rf_i]
    )(tpp_rf_flow[tpp_rf_j,tpp_rf_i])
    -
    sum(
        tpp_rf_j in index_set_2of2(dist)
        where tpp_rf_j != tpp_rf_i /\
              tpp_rf_j != numcities /\
              tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j]
    )(tpp_rf_flow[tpp_rf_i,tpp_rf_j])
    =
    int2float(1 - tpp_rf_arc[tpp_rf_i,tpp_rf_i])
);

constraint forall(
    tpp_rf_i in index_set_1of2(dist),
    tpp_rf_j in index_set_2of2(dist)
    where tpp_rf_i < tpp_rf_j /\
          tpp_rf_i != numcities /\
          tpp_rf_j != numcities /\
          tpp_rf_travel_ok[tpp_rf_i,tpp_rf_j] /\
          tpp_rf_travel_ok[tpp_rf_j,tpp_rf_i]
)(
    tpp_rf_arc[tpp_rf_i,tpp_rf_j] +
    tpp_rf_arc[tpp_rf_j,tpp_rf_i] <= 1
);

solve minimize totalCost;

output [
    if tpp_rf_k <= numcities then
        "successor of " ++ show(tpp_rf_k) ++ ": " ++
        show(succ[tpp_rf_k]) ++ "\n"
    else
        "product " ++ show(tpp_rf_k - numcities) ++ " bought at: " ++
        show(purchaseLoc[tpp_rf_k - numcities]) ++ "\n"
    endif
    | tpp_rf_k in 1..numcities+numproducts
];
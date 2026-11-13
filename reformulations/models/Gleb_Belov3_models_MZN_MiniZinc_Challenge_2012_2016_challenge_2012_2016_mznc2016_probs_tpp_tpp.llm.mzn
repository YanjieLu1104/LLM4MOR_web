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
var totalCost_min..totalCost_max: objective;

array[int] of int: tpp_rf_arc_tail = [
  tpp_rf_i
  | tpp_rf_i in index_set_1of2(dist),
    tpp_rf_j in index_set_2of2(dist)
  where dist[tpp_rf_i,tpp_rf_j] >= 0 /\
        dist[tpp_rf_i,tpp_rf_j] <= maxdist /\
        (tpp_rf_i != numcities \/ tpp_rf_j != numcities)
];

array[index_set(tpp_rf_arc_tail)] of int: tpp_rf_arc_head =
  array1d(index_set(tpp_rf_arc_tail), [
    tpp_rf_j
    | tpp_rf_i in index_set_1of2(dist),
      tpp_rf_j in index_set_2of2(dist)
    where dist[tpp_rf_i,tpp_rf_j] >= 0 /\
          dist[tpp_rf_i,tpp_rf_j] <= maxdist /\
          (tpp_rf_i != numcities \/ tpp_rf_j != numcities)
  ]);

array[int] of int: tpp_rf_buy_city = [
  tpp_rf_i
  | tpp_rf_i in index_set_1of2(price),
    tpp_rf_p in index_set_2of2(price)
  where price[tpp_rf_i,tpp_rf_p] >= 0 /\
        price[tpp_rf_i,tpp_rf_p] <= maxprice
];

array[index_set(tpp_rf_buy_city)] of int: tpp_rf_buy_product =
  array1d(index_set(tpp_rf_buy_city), [
    tpp_rf_p
    | tpp_rf_i in index_set_1of2(price),
      tpp_rf_p in index_set_2of2(price)
    where price[tpp_rf_i,tpp_rf_p] >= 0 /\
          price[tpp_rf_i,tpp_rf_p] <= maxprice
  ]);

array[index_set(tpp_rf_arc_tail)] of var 0..1: tpp_rf_arc_used;
array[index_set(tpp_rf_buy_city)] of var 0..1: tpp_rf_buy_used;
array[index_set(succ)] of var 0..1: tpp_rf_visited;

array[index_set(tpp_rf_arc_tail)] of
  var 0.0..int2float(max(0,numcities-1)): tpp_rf_flow;

constraint objective = sum(travelCost) + sum(purchaseCost);

constraint forall(tpp_rf_c in index_set(succ)) (
  sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
      where tpp_rf_arc_tail[tpp_rf_a] = tpp_rf_c) (
    tpp_rf_arc_used[tpp_rf_a]
  ) = 1
);

constraint forall(tpp_rf_c in index_set(succ)) (
  sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
      where tpp_rf_arc_head[tpp_rf_a] = tpp_rf_c) (
    tpp_rf_arc_used[tpp_rf_a]
  ) = 1
);

constraint forall(tpp_rf_c in index_set(succ)) (
  succ[tpp_rf_c] =
    sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
        where tpp_rf_arc_tail[tpp_rf_a] = tpp_rf_c) (
      tpp_rf_arc_head[tpp_rf_a] * tpp_rf_arc_used[tpp_rf_a]
    )
);

constraint forall(tpp_rf_c in index_set(travelCost)) (
  travelCost[tpp_rf_c] =
    sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
        where tpp_rf_arc_tail[tpp_rf_a] = tpp_rf_c) (
      dist[tpp_rf_arc_tail[tpp_rf_a],tpp_rf_arc_head[tpp_rf_a]]
      * tpp_rf_arc_used[tpp_rf_a]
    )
);

constraint forall(tpp_rf_c in index_set(succ)) (
  tpp_rf_visited[tpp_rf_c] =
    sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
        where tpp_rf_arc_tail[tpp_rf_a] = tpp_rf_c /\
              tpp_rf_arc_head[tpp_rf_a] != tpp_rf_c) (
      tpp_rf_arc_used[tpp_rf_a]
    )
);

constraint tpp_rf_visited[numcities] = 1;
constraint succ[numcities] != numcities;

constraint forall(tpp_rf_p in index_set(purchaseLoc)) (
  sum(tpp_rf_b in index_set(tpp_rf_buy_city)
      where tpp_rf_buy_product[tpp_rf_b] = tpp_rf_p) (
    tpp_rf_buy_used[tpp_rf_b]
  ) = 1
);

constraint forall(tpp_rf_p in index_set(purchaseLoc)) (
  purchaseLoc[tpp_rf_p] =
    sum(tpp_rf_b in index_set(tpp_rf_buy_city)
        where tpp_rf_buy_product[tpp_rf_b] = tpp_rf_p) (
      tpp_rf_buy_city[tpp_rf_b] * tpp_rf_buy_used[tpp_rf_b]
    )
);

constraint forall(tpp_rf_p in index_set(purchaseCost)) (
  purchaseCost[tpp_rf_p] =
    sum(tpp_rf_b in index_set(tpp_rf_buy_city)
        where tpp_rf_buy_product[tpp_rf_b] = tpp_rf_p) (
      price[tpp_rf_buy_city[tpp_rf_b],tpp_rf_buy_product[tpp_rf_b]]
      * tpp_rf_buy_used[tpp_rf_b]
    )
);

constraint forall(tpp_rf_b in index_set(tpp_rf_buy_city)) (
  tpp_rf_buy_used[tpp_rf_b] <=
    tpp_rf_visited[tpp_rf_buy_city[tpp_rf_b]]
);

constraint forall(tpp_rf_a in index_set(tpp_rf_arc_tail)) (
  if tpp_rf_arc_tail[tpp_rf_a] = tpp_rf_arc_head[tpp_rf_a] \/
     tpp_rf_arc_head[tpp_rf_a] = numcities then
    tpp_rf_flow[tpp_rf_a] = 0.0
  else
    tpp_rf_flow[tpp_rf_a] >= int2float(tpp_rf_arc_used[tpp_rf_a]) /\
    tpp_rf_flow[tpp_rf_a] <=
      int2float(
        if tpp_rf_arc_tail[tpp_rf_a] = numcities then
          max(0,numcities-1)
        else
          max(0,numcities-2)
        endif
      ) * int2float(tpp_rf_arc_used[tpp_rf_a])
  endif
);

constraint forall(tpp_rf_c in index_set(succ)
                  where tpp_rf_c != numcities) (
  sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
      where tpp_rf_arc_head[tpp_rf_a] = tpp_rf_c) (
    tpp_rf_flow[tpp_rf_a]
  )
  -
  sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
      where tpp_rf_arc_tail[tpp_rf_a] = tpp_rf_c) (
    tpp_rf_flow[tpp_rf_a]
  )
  = int2float(tpp_rf_visited[tpp_rf_c])
);

constraint
  sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
      where tpp_rf_arc_tail[tpp_rf_a] = numcities) (
    tpp_rf_flow[tpp_rf_a]
  )
  -
  sum(tpp_rf_a in index_set(tpp_rf_arc_tail)
      where tpp_rf_arc_head[tpp_rf_a] = numcities) (
    tpp_rf_flow[tpp_rf_a]
  )
  =
  int2float(
    sum(tpp_rf_c in index_set(succ) where tpp_rf_c != numcities) (
      tpp_rf_visited[tpp_rf_c]
    )
  );

solve minimize objective;

output [
  "succ = \(succ);\n",
  "purchaseLoc = \(purchaseLoc);\n",
  "objective = \(objective);"
];
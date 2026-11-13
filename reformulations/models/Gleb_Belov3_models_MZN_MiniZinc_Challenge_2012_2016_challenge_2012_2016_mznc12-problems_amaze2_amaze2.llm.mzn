include "globals.mzn";

int: X;
int: Y;
int: N;

array[1..N] of 1..X: end_points_start_x;
array[1..N] of 1..Y: end_points_start_y;
array[1..N] of 1..X: end_points_end_x;
array[1..N] of 1..Y: end_points_end_y;

int: M = X * Y;

array[1..X, 1..Y] of 1..M: id =
  array2d(1..X, 1..Y, [i | i in 1..M]);

array[1..M] of set of 1..M: neighbours =
  [
    (if i > 1 then {id[i-1, j]} else {} endif) union
    (if i < X then {id[i+1, j]} else {} endif) union
    (if j > 1 then {id[i, j-1]} else {} endif) union
    (if j < Y then {id[i, j+1]} else {} endif)
    | i in 1..X, j in 1..Y
  ];

array[1..N] of 1..M: start =
  [id[end_points_start_x[i], end_points_start_y[i]] | i in 1..N];

array[1..N] of 1..M: end =
  [id[end_points_end_x[i], end_points_end_y[i]] | i in 1..N];

array[0..M] of var 0..N: path;
array[1..M] of var 0..M: next;

set of int: rf_start_cells =
  {start[rf_k] | rf_k in index_set(start)};

set of int: rf_end_cells =
  {end[rf_k] | rf_k in index_set(end)};

array[int] of int: rf_arc_source =
  [
    rf_u
    | rf_u in index_set(next),
      rf_v in neighbours[rf_u]
    where not (rf_u in rf_end_cells) /\
          not (rf_v in rf_start_cells)
  ];

array[int] of int: rf_arc_target =
  [
    rf_v
    | rf_u in index_set(next),
      rf_v in neighbours[rf_u]
    where not (rf_u in rf_end_cells) /\
          not (rf_v in rf_start_cells)
  ];

array[index_set(next)] of set of int: rf_out_arcs =
  array1d(
    index_set(next),
    [
      {rf_a | rf_a in index_set(rf_arc_source)
              where rf_arc_source[rf_a] = rf_u}
      | rf_u in index_set(next)
    ]
  );

array[index_set(next)] of set of int: rf_in_arcs =
  array1d(
    index_set(next),
    [
      {rf_a | rf_a in index_set(rf_arc_target)
              where rf_arc_target[rf_a] = rf_u}
      | rf_u in index_set(next)
    ]
  );

array[index_set(next)] of var 0..1: rf_occupied;
array[index_set(rf_arc_source)] of var 0..1: rf_arc_used;

constraint path[0] = 0;

constraint forall(rf_k in index_set(start)) (
  path[start[rf_k]] = rf_k /\
  path[end[rf_k]] = rf_k
);

constraint forall(rf_u in index_set(next)) (
  rf_occupied[rf_u] <= path[rf_u] /\
  path[rf_u] <= N * rf_occupied[rf_u]
);

constraint forall(rf_u in index_set(next)
                  where not (rf_u in rf_end_cells)) (
  sum(rf_a in rf_out_arcs[rf_u]) (rf_arc_used[rf_a])
    = rf_occupied[rf_u]
);

constraint forall(rf_u in index_set(next)
                  where not (rf_u in rf_start_cells)) (
  sum(rf_a in rf_in_arcs[rf_u]) (rf_arc_used[rf_a])
    = rf_occupied[rf_u]
);

constraint forall(rf_u in index_set(next)) (
  next[rf_u] =
    if rf_u in rf_end_cells then
      rf_u
    else
      sum(rf_a in rf_out_arcs[rf_u]) (
        rf_arc_target[rf_a] * rf_arc_used[rf_a]
      )
    endif
);

constraint forall(rf_a in index_set(rf_arc_source)) (
  path[rf_arc_source[rf_a]] - path[rf_arc_target[rf_a]]
    <= N * (1 - rf_arc_used[rf_a]) /\
  path[rf_arc_target[rf_a]] - path[rf_arc_source[rf_a]]
    <= N * (1 - rf_arc_used[rf_a])
);

solve
  :: int_search(next ++ path, first_fail, indomain_min, complete)
  satisfy;

output [
  show_int(
    floor(log10(int2float(max(1, N))) + 1.0),
    path[id[x, y]]
  ) ++
  if x = X then "\n" else " " endif
  | y in 1..Y, x in 1..X
];
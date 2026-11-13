include "globals.mzn";

int: nbTeams;
int: nbRounds = nbTeams-1;

set of int: Teams = 1..nbTeams;
set of int: Rounds = 1..nbRounds;
set of int: Travels = 1..nbRounds+1;

array[Teams,Teams] of 1..2: pv;

array[Teams,Teams] of int: distance =
  array2d(Teams,Teams,[
    if i>=j then
      if i-j < j-i+nbTeams then i-j else j-i+nbTeams endif
    else
      if j-i < i-j+nbTeams then j-i else i-j+nbTeams endif
    endif
    | i,j in Teams
  ]);

int: digs = ceil(log(10.0,int2float(nbTeams)));

array[Teams,Rounds] of var Teams: opponent;
array[Teams,Rounds] of var 1..2: venue;
array[Teams,Travels] of var 0..(nbTeams div 2): travel;

int: nbStates = 7;
set of int: States = 1..nbStates;
array[States,1..2] of int: delta =
  [| 2, 5
   | 3, 5
   | 4, 5
   | 0, 5
   | 2, 6
   | 2, 7
   | 2, 0 |];

array[
  index_set_1of2(opponent),
  index_set_2of2(pv),
  index_set_2of2(opponent)
] of var 0..1: rf_game;

constraint nbTeams mod 2 = 0;

constraint forall(rf_i in Teams, rf_k in Rounds)(
  rf_game[rf_i,rf_i,rf_k] = 0
);

constraint forall(
  rf_i,rf_j in Teams, rf_k in Rounds
  where rf_i < rf_j
)(
  rf_game[rf_i,rf_j,rf_k] = rf_game[rf_j,rf_i,rf_k]
);

constraint forall(rf_i in Teams, rf_k in Rounds)(
  sum(rf_j in Teams)(rf_game[rf_i,rf_j,rf_k]) = 1
);

constraint forall(rf_i,rf_j in Teams where rf_i < rf_j)(
  sum(rf_k in Rounds)(rf_game[rf_i,rf_j,rf_k]) = 1
);

constraint forall(rf_k in Rounds)(
  sum(rf_i,rf_j in Teams where rf_i < rf_j)(
    rf_game[rf_i,rf_j,rf_k]
  ) = nbTeams div 2
);

constraint forall(rf_i in Teams, rf_k in Rounds)(
  opponent[rf_i,rf_k] =
    sum(rf_j in Teams)(rf_j * rf_game[rf_i,rf_j,rf_k])
);

constraint forall(rf_i in Teams, rf_k in Rounds)(
  venue[rf_i,rf_k] =
    sum(rf_j in Teams)(
      pv[rf_i,rf_j] * rf_game[rf_i,rf_j,rf_k]
    )
);

constraint forall(
  rf_i in Teams, rf_k in Rounds
  where rf_k + 3 <= nbRounds
)(
  sum(rf_h in rf_k..rf_k+3)(venue[rf_i,rf_h]) >= 5 /\
  sum(rf_h in rf_k..rf_k+3)(venue[rf_i,rf_h]) <= 7
);

constraint
  if nbRounds >= 1 then
    opponent[1,1] < opponent[1,nbRounds]
  else
    false
  endif;

set of int: rf_cuts =
  if nbTeams mod 2 = 0 then
    {rf_c | rf_c in index_set_1of2(pv)
          where rf_c <= nbTeams div 2}
  else
    index_set_1of2(pv)
  endif;

int: rf_distance_scale =
  if nbTeams mod 2 = 0 then 1 else 2 endif;

array[index_set_1of2(pv),rf_cuts] of 0..1: rf_cut_member =
  array2d(index_set_1of2(pv),rf_cuts,[
    bool2int(
      ((rf_v - rf_c + nbTeams) mod nbTeams) < nbTeams div 2
    )
    | rf_v in index_set_1of2(pv), rf_c in rf_cuts
  ]);

array[
  index_set_1of2(opponent),
  index_set_2of2(opponent),
  rf_cuts
] of var 0..1: rf_at_cut;

array[
  index_set_1of2(travel),
  index_set_2of2(travel),
  rf_cuts
] of var 0..1: rf_cross_cut;

constraint forall(
  rf_i in Teams, rf_k in Rounds, rf_c in rf_cuts
)(
  rf_at_cut[rf_i,rf_k,rf_c] =
    sum(rf_j in Teams)(
      rf_cut_member[
        if pv[rf_i,rf_j] = 1 then rf_i else rf_j endif,
        rf_c
      ] * rf_game[rf_i,rf_j,rf_k]
    )
);

constraint
  if nbRounds >= 1 then
    forall(rf_i in Teams, rf_c in rf_cuts)(
      rf_cross_cut[rf_i,1,rf_c] =
        (if rf_cut_member[rf_i,rf_c] = 0 then
           rf_at_cut[rf_i,1,rf_c]
         else
           1 - rf_at_cut[rf_i,1,rf_c]
         endif)
      /\
      rf_cross_cut[rf_i,nbRounds+1,rf_c] =
        (if rf_cut_member[rf_i,rf_c] = 0 then
           rf_at_cut[rf_i,nbRounds,rf_c]
         else
           1 - rf_at_cut[rf_i,nbRounds,rf_c]
         endif)
    )
  else
    false
  endif;

constraint forall(
  rf_i in Teams, rf_k in Rounds, rf_c in rf_cuts
  where rf_k < nbRounds
)(
  rf_cross_cut[rf_i,rf_k+1,rf_c] >=
    rf_at_cut[rf_i,rf_k,rf_c] -
    rf_at_cut[rf_i,rf_k+1,rf_c]
  /\
  rf_cross_cut[rf_i,rf_k+1,rf_c] >=
    rf_at_cut[rf_i,rf_k+1,rf_c] -
    rf_at_cut[rf_i,rf_k,rf_c]
  /\
  rf_cross_cut[rf_i,rf_k+1,rf_c] <=
    rf_at_cut[rf_i,rf_k,rf_c] +
    rf_at_cut[rf_i,rf_k+1,rf_c]
  /\
  rf_cross_cut[rf_i,rf_k+1,rf_c] <=
    2 - rf_at_cut[rf_i,rf_k,rf_c] -
    rf_at_cut[rf_i,rf_k+1,rf_c]
);

constraint forall(rf_i in Teams, rf_k in Travels)(
  rf_distance_scale * travel[rf_i,rf_k] =
    sum(rf_c in rf_cuts)(rf_cross_cut[rf_i,rf_k,rf_c])
);

constraint forall(rf_i in Teams)(
  sum(rf_k in Travels)(travel[rf_i,rf_k]) >=
    2 * max(
      [0] ++
      [distance[rf_i,rf_j]
       | rf_j in Teams
       where rf_j != rf_i /\ pv[rf_i,rf_j] = 2]
    )
);

int: maxObj =
  sum(i in Teams, k in Travels)(ub(travel[i,k]));

var 0..maxObj: objective =
  sum(i in Teams, k in Travels)(travel[i,k]);

solve minimize objective;

output [
  "%% SCHEDULE\n%% "
] ++ [
  if fix(venue[i,k]) == 1 then " " else "@" endif ++
  show_int(digs,opponent[i,k]) ++ " " ++
  if k == nbRounds /\ i != nbTeams then "\n%% " else "" endif
  | i in Teams, k in Rounds
] ++ ["\n"] ++ [
  "opponent = array2d(", show(Teams), ", ", show(Rounds),
  ", ", show(opponent), ");\n",
  "venue = array2d(", show(Teams), ", ", show(Rounds),
  ", ", show(venue), ");\n",
  "travel = array2d(", show(Teams), ", ", show(Travels),
  ", ", show(travel), ");\n",
  "constraint objective = ", show(objective), ";\n"
];
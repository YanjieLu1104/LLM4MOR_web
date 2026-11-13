int: PSize;

var 1..TSize: Depot;

int: TSize = (PSize + 1) * 2;
int: TourLength = PSize + 1;
int: AWHouse = 1;
int: BWHouse = TourLength + 1;
int: ASize = TourLength + 1;
int: BSize = TourLength + 1;

array[1..ASize] of var 1..TSize: TourALoc;
array[1..BSize] of var 1..TSize: TourBLoc;

array[1..14, 1..14] of int: AllDist;

int: MaxTotDist =
    sum([
        max([AllDist[rf_i, rf_j] | rf_j in 1..TSize])
        | rf_i in 1..TSize
    ]);

int: MaxLeg =
    max([
        max([AllDist[rf_i, rf_j] | rf_j in 1..TSize])
        | rf_i in 1..TSize
    ]);

array[1..ASize] of var 0..MaxLeg: ALegDist;
array[1..BSize] of var 0..MaxLeg: BLegDist;

var 0..MaxTotDist: ADist;
var 0..MaxTotDist: BDist;
var 0..MaxTotDist: objective;

set of int: rf_locations =
    index_set_1of2(AllDist) intersect 1..TSize;
set of int: rf_positions_a = index_set(TourALoc);
set of int: rf_positions_b = index_set(TourBLoc);

array[rf_positions_a, rf_locations] of var bool: rf_at_a;
array[rf_positions_b, rf_locations] of var bool: rf_at_b;
array[rf_locations] of var bool: rf_depot_choice;

array[rf_positions_a] of var bool: rf_depot_at_a;
array[rf_positions_b] of var bool: rf_depot_at_b;

array[rf_positions_a, rf_locations, rf_locations]
    of var 0.0..1.0: rf_arc_a;
array[rf_positions_b, rf_locations, rf_locations]
    of var 0.0..1.0: rf_arc_b;

constraint
    forall(rf_n in rf_positions_a)(
        sum(rf_c in rf_locations)(
            bool2int(rf_at_a[rf_n, rf_c])
        ) = 1
    );

constraint
    forall(rf_n in rf_positions_b)(
        sum(rf_c in rf_locations)(
            bool2int(rf_at_b[rf_n, rf_c])
        ) = 1
    );

constraint
    forall(rf_n in rf_positions_a)(
        TourALoc[rf_n] =
        sum(rf_c in rf_locations)(
            rf_c * bool2int(rf_at_a[rf_n, rf_c])
        )
    );

constraint
    forall(rf_n in rf_positions_b)(
        TourBLoc[rf_n] =
        sum(rf_c in rf_locations)(
            rf_c * bool2int(rf_at_b[rf_n, rf_c])
        )
    );

constraint
    sum(rf_c in rf_locations)(
        bool2int(rf_depot_choice[rf_c])
    ) = 1;

constraint
    Depot =
    sum(rf_c in rf_locations)(
        rf_c * bool2int(rf_depot_choice[rf_c])
    );

constraint TourALoc[1] = AWHouse;
constraint TourBLoc[1] = BWHouse;

constraint
    forall(rf_n in rf_positions_a)(
        not rf_at_a[rf_n, BWHouse]
    );

constraint
    forall(rf_n in rf_positions_b)(
        not rf_at_b[rf_n, AWHouse]
    );

constraint
    forall(rf_n in 3..ASize-1)(
        not rf_at_a[rf_n, AWHouse]
    );

constraint
    forall(rf_n in 3..BSize-1)(
        not rf_at_b[rf_n, BWHouse]
    );

constraint
    symmetry_breaking_constraint(
        TourALoc[ASize] != AWHouse
    );

constraint
    symmetry_breaking_constraint(
        TourALoc[BSize] != BWHouse
    );

constraint
    forall(rf_c in rf_locations)(
        sum(rf_n in rf_positions_a where rf_n >= 2)(
            bool2int(rf_at_a[rf_n, rf_c])
        ) <= 1
    );

constraint
    forall(rf_c in rf_locations)(
        sum(rf_n in rf_positions_b where rf_n >= 2)(
            bool2int(rf_at_b[rf_n, rf_c])
        ) <= 1
    );

constraint
    forall(rf_c in rf_locations)(
        sum(rf_n in rf_positions_a)(
            bool2int(rf_at_a[rf_n, rf_c])
        ) +
        sum(rf_n in rf_positions_b)(
            bool2int(rf_at_b[rf_n, rf_c])
        ) >= 1
    );

constraint
    forall(rf_n in rf_positions_a, rf_c in rf_locations)(
        bool2int(rf_depot_at_a[rf_n]) >=
            bool2int(rf_at_a[rf_n, rf_c]) +
            bool2int(rf_depot_choice[rf_c]) - 1
        /\
        bool2int(rf_depot_at_a[rf_n]) <=
            1 - bool2int(rf_at_a[rf_n, rf_c]) +
            bool2int(rf_depot_choice[rf_c])
    );

constraint
    forall(rf_n in rf_positions_b, rf_c in rf_locations)(
        bool2int(rf_depot_at_b[rf_n]) >=
            bool2int(rf_at_b[rf_n, rf_c]) +
            bool2int(rf_depot_choice[rf_c]) - 1
        /\
        bool2int(rf_depot_at_b[rf_n]) <=
            1 - bool2int(rf_at_b[rf_n, rf_c]) +
            bool2int(rf_depot_choice[rf_c])
    );

constraint
    forall(rf_n in rf_positions_a)(
        sum(rf_m in rf_positions_a where rf_m <= rf_n)(
            bool2int(rf_depot_at_a[rf_m])
        ) >=
        sum(rf_c in rf_locations where rf_c > TourLength)(
            bool2int(rf_at_a[rf_n, rf_c])
        )
    );

constraint
    forall(rf_n in rf_positions_b)(
        sum(rf_m in rf_positions_b where rf_m <= rf_n)(
            bool2int(rf_depot_at_b[rf_m])
        ) >=
        sum(rf_c in rf_locations where rf_c <= TourLength)(
            bool2int(rf_at_b[rf_n, rf_c])
        )
    );

constraint
    forall(rf_n in rf_positions_a, rf_c in rf_locations)(
        sum(rf_d in rf_locations)(
            rf_arc_a[rf_n, rf_c, rf_d]
        ) =
        int2float(bool2int(rf_at_a[rf_n, rf_c]))
    );

constraint
    forall(rf_n in rf_positions_a, rf_d in rf_locations)(
        sum(rf_c in rf_locations)(
            rf_arc_a[rf_n, rf_c, rf_d]
        ) =
        int2float(bool2int(
            rf_at_a[
                if rf_n < ASize then rf_n + 1 else 1 endif,
                rf_d
            ]
        ))
    );

constraint
    forall(rf_n in rf_positions_b, rf_c in rf_locations)(
        sum(rf_d in rf_locations)(
            rf_arc_b[rf_n, rf_c, rf_d]
        ) =
        int2float(bool2int(rf_at_b[rf_n, rf_c]))
    );

constraint
    forall(rf_n in rf_positions_b, rf_d in rf_locations)(
        sum(rf_c in rf_locations)(
            rf_arc_b[rf_n, rf_c, rf_d]
        ) =
        int2float(bool2int(
            rf_at_b[
                if rf_n < BSize then rf_n + 1 else 1 endif,
                rf_d
            ]
        ))
    );

constraint
    forall(
        rf_n in rf_positions_a,
        rf_c in rf_locations,
        rf_d in rf_locations
        where AllDist[rf_c, rf_d] < 0
            \/ (rf_c = rf_d /\ rf_c != AWHouse)
    )(
        rf_arc_a[rf_n, rf_c, rf_d] = 0.0
    );

constraint
    forall(
        rf_n in rf_positions_b,
        rf_c in rf_locations,
        rf_d in rf_locations
        where AllDist[rf_c, rf_d] < 0
            \/ (rf_c = rf_d /\ rf_c != BWHouse)
    )(
        rf_arc_b[rf_n, rf_c, rf_d] = 0.0
    );

constraint
    forall(rf_n in rf_positions_a)(
        int2float(ALegDist[rf_n]) =
        sum(rf_c in rf_locations, rf_d in rf_locations)(
            int2float(AllDist[rf_c, rf_d]) *
            rf_arc_a[rf_n, rf_c, rf_d]
        )
    );

constraint
    forall(rf_n in rf_positions_b)(
        int2float(BLegDist[rf_n]) =
        sum(rf_c in rf_locations, rf_d in rf_locations)(
            int2float(AllDist[rf_c, rf_d]) *
            rf_arc_b[rf_n, rf_c, rf_d]
        )
    );

constraint ADist = sum(ALegDist);
constraint BDist = sum(BLegDist);
constraint objective = max(ADist, BDist);

solve minimize objective;

output [
    "%% Maximum Tour Distance: ", show(objective),
    ";\nDepot = ", show(Depot),
    ";\n%% ADist is: ", show(ADist),
    ";\n%% BDist is: ", show(BDist),
    ";\nTourALoc = ", show(TourALoc),
    ";\nTourBLoc = ", show(TourBLoc),
    ";\nobjective = ", show(objective),
    ";\n"
];
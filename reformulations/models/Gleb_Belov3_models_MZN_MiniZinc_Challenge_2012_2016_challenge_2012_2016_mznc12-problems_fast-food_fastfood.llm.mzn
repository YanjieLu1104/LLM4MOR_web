int: nr;
set of int: Restaurant = 1..nr;
array[Restaurant] of string: name;

array[Restaurant] of int: k;
set of int: ks = { k[r] | r in Restaurant };
int: maxdist = max(ks);

set of Restaurant: first =
    { min(r in Restaurant where k[r] == pos)(r) | pos in ks };

int: number_of_depots;
set of int: Depot = 1..number_of_depots;
array[Depot] of var 0..maxdist: p;

constraint forall(d in Depot)(p[d] in ks);
constraint forall(d in 1..number_of_depots-1)(p[d] < p[d+1]);

int: obj_min =
    sum(r in Restaurant)(
        min(d in Depot)(lb(abs(p[d] - k[r])))
    );
int: obj_max =
    sum(r in Restaurant)(
        min(d in Depot)(ub(abs(p[d] - k[r])))
    );

array[int] of int: ff2026_site_position =
    sort([
        ff2026_pos
        | ff2026_pos in ks
        where ff2026_pos >= 0 /\ ff2026_pos <= maxdist
    ]);

set of int: ff2026_Site = index_set(ff2026_site_position);
int: ff2026_site_count = length(ff2026_site_position);

array[int] of int: ff2026_customer =
    [ff2026_r | ff2026_r in first];

set of int: ff2026_Customer = index_set(ff2026_customer);

array[ff2026_Customer] of int: ff2026_weight =
    [
        sum(ff2026_r in Restaurant)(
            bool2int(k[ff2026_r] = k[ff2026_customer[ff2026_c]])
        )
        | ff2026_c in ff2026_Customer
    ];

array[ff2026_Customer, ff2026_Site] of int: ff2026_threshold =
    array2d(
        ff2026_Customer,
        ff2026_Site,
        [
            let {
                array[ff2026_Site] of int: ff2026_sorted_row =
                    sort([
                        abs(
                            k[ff2026_customer[ff2026_c]]
                            - ff2026_site_position[ff2026_s]
                        )
                        | ff2026_s in ff2026_Site
                    ]);
            } in ff2026_sorted_row[ff2026_j]
            | ff2026_c in ff2026_Customer,
              ff2026_j in ff2026_Site
        ]
    );

array[ff2026_Customer, ff2026_Site] of int: ff2026_left_count =
    array2d(
        ff2026_Customer,
        ff2026_Site,
        [
            sum(ff2026_s in ff2026_Site)(
                bool2int(
                    ff2026_site_position[ff2026_s]
                    <= k[ff2026_customer[ff2026_c]]
                       - ff2026_threshold[ff2026_c, ff2026_j]
                )
            )
            | ff2026_c in ff2026_Customer,
              ff2026_j in ff2026_Site
        ]
    );

array[ff2026_Customer, ff2026_Site] of int: ff2026_right_count =
    array2d(
        ff2026_Customer,
        ff2026_Site,
        [
            if ff2026_threshold[ff2026_c, ff2026_j] = 0 then
                ff2026_left_count[ff2026_c, ff2026_j]
            else
                sum(ff2026_s in ff2026_Site)(
                    bool2int(
                        ff2026_site_position[ff2026_s]
                        < k[ff2026_customer[ff2026_c]]
                          + ff2026_threshold[ff2026_c, ff2026_j]
                    )
                )
            endif
            | ff2026_c in ff2026_Customer,
              ff2026_j in ff2026_Site
        ]
    );

array[Depot, ff2026_Site] of var 0..1: ff2026_slot;
array[ff2026_Site] of var 0..1: ff2026_open;

array[0..ff2026_site_count] of var 0..ff2026_site_count:
    ff2026_prefix;

array[ff2026_Customer, ff2026_Site] of var 0..1:
    ff2026_uncovered;

constraint forall(d in Depot)(
    sum(ff2026_s in ff2026_Site)(
        ff2026_slot[d, ff2026_s]
    ) = 1
);

constraint forall(d in Depot)(
    p[d] =
        sum(ff2026_s in ff2026_Site)(
            ff2026_site_position[ff2026_s]
            * ff2026_slot[d, ff2026_s]
        )
);

constraint forall(ff2026_s in ff2026_Site)(
    ff2026_open[ff2026_s] =
        sum(d in Depot)(ff2026_slot[d, ff2026_s])
);

constraint ff2026_prefix[0] = 0;

constraint forall(ff2026_s in ff2026_Site)(
    ff2026_prefix[ff2026_s] =
        ff2026_prefix[ff2026_s - 1] + ff2026_open[ff2026_s]
);

constraint
    ff2026_prefix[ff2026_site_count] = number_of_depots;

constraint forall(
    ff2026_c in ff2026_Customer,
    ff2026_j in ff2026_Site
)(
    ff2026_uncovered[ff2026_c, ff2026_j]
    + ff2026_prefix[ff2026_right_count[ff2026_c, ff2026_j]]
    - ff2026_prefix[ff2026_left_count[ff2026_c, ff2026_j]]
    >= 1
);

constraint forall(
    ff2026_c in ff2026_Customer,
    ff2026_j in ff2026_Site
)(
    ff2026_prefix[ff2026_right_count[ff2026_c, ff2026_j]]
    - ff2026_prefix[ff2026_left_count[ff2026_c, ff2026_j]]
    <=
    (
        ff2026_right_count[ff2026_c, ff2026_j]
        - ff2026_left_count[ff2026_c, ff2026_j]
    ) * (1 - ff2026_uncovered[ff2026_c, ff2026_j])
);

var obj_min..obj_max: obj =
    sum(
        ff2026_c in ff2026_Customer,
        ff2026_j in ff2026_Site
    )(
        ff2026_weight[ff2026_c]
        *
        (
            ff2026_threshold[ff2026_c, ff2026_j]
            -
            (
                if ff2026_j = 1 then
                    0
                else
                    ff2026_threshold[ff2026_c, ff2026_j - 1]
                endif
            )
        )
        * ff2026_uncovered[ff2026_c, ff2026_j]
    );

solve minimize obj;

output [show(p), "\n", show(obj), "\n"] ++
       [
           if fix(p[d]) == k[r] then
               "depot(" ++ name[r] ++ "," ++ show(p[d]) ++ ").\n"
           else
               ""
           endif
           | d in Depot, r in first
       ];
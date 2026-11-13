include "globals.mzn";

int: roll_wid;
int: max_roll_len;

set of int: Ori = 1..4;

int: n_rm;
set of int: Rooms = 1..n_rm;
array [Rooms] of set of int: rm_rec_ids;
array [Rooms] of set of Ori: rm_ori;
array [Rooms] of int: rm_max_len;
array [Rooms] of int: rm_max_wid;

int: n_rm_rec;
set of int: RmRecs = 1..n_rm_rec;
array [RmRecs] of int: rm_rec_len;
array [RmRecs] of int: rm_rec_wid;
array [RmRecs, Ori] of int: rm_rec_os_x;
array [RmRecs, Ori] of int: rm_rec_os_y;

array [Rooms] of int: rm_area =
    [sum(j in rm_rec_ids[i])(rm_rec_len[j] * rm_rec_wid[j])
     | i in Rooms];

array [Rooms] of int: rm_pos =
    [sum(j in Rooms where
         (j != i /\ rm_area[j] > rm_area[i]) \/
         (j < i /\ rm_area[j] = rm_area[i]))(1) + 1
     | i in Rooms];

array [Rooms] of int: rm_sort =
    [j | i, j in Rooms where rm_pos[j] = i];

int: n_st;
set of int: Stairs = 1..n_st;
array [Stairs] of int: st_len;
array [Stairs] of int: st_wid;
array [Stairs] of int: st_no_steps;
array [Stairs] of int: st_min_steps;
array [Stairs] of int: st_max_breaks;

array [Stairs] of int: st_rec_id_offset =
    [sum(j in Stairs where j < i)(st_no_steps[j]) | i in Stairs];

array [Stairs] of set of int: st_rec_ids =
    [(st_rec_id_offset[i] + 1)..
     (st_rec_id_offset[i] + st_no_steps[i]) | i in Stairs];

int: n_st_rec = sum(i in Stairs)(st_no_steps[i]);
set of int: StRecs = 1..n_st_rec;

array [StRecs] of int: st_rec_len =
    [st_len[i] div st_no_steps[i]
     | i in Stairs, j in st_rec_ids[i]];

array [StRecs] of int: st_rec_wid =
    [st_wid[i] | i in Stairs, j in st_rec_ids[i]];

int: TotalArea =
    sum(i in RmRecs)(rm_rec_len[i] * rm_rec_wid[i]) +
    sum(i in Stairs)(st_len[i] * st_wid[i]);

int: MinRollLen =
    (TotalArea div roll_wid) +
    if TotalArea mod roll_wid > 0 then 1 else 0 endif;

int: TotalLen =
    sum(i in Rooms)(max(rm_max_len[i], rm_max_wid[i])) +
    sum(i in Stairs)(st_len[i]);

int: MaxRollLen = min(max_roll_len, TotalLen);

set of int: DomX = 0..MaxRollLen;
set of int: DomY = 0..roll_wid;

int: MinRmRecSize =
    min(i in RmRecs)(min(rm_rec_len[i], rm_rec_wid[i]));

int: MaxRmRecSize =
    max(i in RmRecs)(max(rm_rec_len[i], rm_rec_wid[i]));

array [index_set(rm_ori), Ori] of int: cc_rf_x_lower =
    array2d(
        index_set(rm_ori),
        Ori,
        [max([0] ++
             [-rm_rec_os_x[j, cc_rf_o] | j in rm_rec_ids[i]])
         | i in index_set(rm_ori), cc_rf_o in Ori]
    );

array [index_set(rm_ori), Ori] of int: cc_rf_y_lower =
    array2d(
        index_set(rm_ori),
        Ori,
        [max([0] ++
             [-rm_rec_os_y[j, cc_rf_o] | j in rm_rec_ids[i]])
         | i in index_set(rm_ori), cc_rf_o in Ori]
    );

array [index_set(rm_ori), Ori] of int: cc_rf_x_upper =
    array2d(
        index_set(rm_ori),
        Ori,
        [min(
            [MaxRollLen,
             MaxRollLen -
                (if cc_rf_o in {1, 3}
                 then rm_max_len[i]
                 else rm_max_wid[i]
                 endif)] ++
            [MaxRollLen - rm_rec_os_x[j, cc_rf_o]
             | j in rm_rec_ids[i]]
         )
         | i in index_set(rm_ori), cc_rf_o in Ori]
    );

array [index_set(rm_ori), Ori] of int: cc_rf_y_upper =
    array2d(
        index_set(rm_ori),
        Ori,
        [min(
            [roll_wid,
             roll_wid -
                (if cc_rf_o in {1, 3}
                 then rm_max_wid[i]
                 else rm_max_len[i]
                 endif)] ++
            [roll_wid - rm_rec_os_y[j, cc_rf_o]
             | j in rm_rec_ids[i]]
         )
         | i in index_set(rm_ori), cc_rf_o in Ori]
    );

var MinRollLen..MaxRollLen: RollLen;

array [Rooms] of var DomX: rm_x;
array [Rooms] of var DomY: rm_y;
array [Rooms] of var Ori: rm_vori;
array [Rooms] of var bool: rm_ori_0_or_180;
array [Rooms] of var bool: rm_ori_0_or_90;

array [RmRecs] of var DomX: rm_rec_x;
array [RmRecs] of var DomY: rm_rec_y;

array [RmRecs] of var MinRmRecSize..MaxRmRecSize: rm_rec_vlen =
    [rm_rec_wid[i] +
     (rm_rec_len[i] - rm_rec_wid[i]) *
     bool2int(rm_ori_0_or_180[j])
     | i in RmRecs, j in Rooms where i in rm_rec_ids[j]];

array [RmRecs] of var MinRmRecSize..MaxRmRecSize: rm_rec_vwid =
    [rm_rec_len[i] +
     (rm_rec_wid[i] - rm_rec_len[i]) *
     bool2int(rm_ori_0_or_180[j])
     | i in RmRecs, j in Rooms where i in rm_rec_ids[j]];

array [StRecs] of var DomX: st_rec_x;
array [StRecs] of var DomY: st_rec_y;

array [index_set(rm_ori), Ori] of var 0..1: cc_rf_choose;

constraint
    forall(i in Rooms)(
        sum(cc_rf_o in Ori)(cc_rf_choose[i, cc_rf_o]) = 1
        /\
        rm_vori[i] =
            sum(cc_rf_o in Ori)(
                cc_rf_o * cc_rf_choose[i, cc_rf_o]
            )
        /\
        bool2int(rm_ori_0_or_180[i]) =
            cc_rf_choose[i, 1] + cc_rf_choose[i, 3]
        /\
        bool2int(rm_ori_0_or_90[i]) =
            cc_rf_choose[i, 1] + cc_rf_choose[i, 2]
    );

constraint
    forall(i in Rooms, cc_rf_o in Ori where
        not(cc_rf_o in rm_ori[i]) \/
        cc_rf_x_lower[i, cc_rf_o] > cc_rf_x_upper[i, cc_rf_o] \/
        cc_rf_y_lower[i, cc_rf_o] > cc_rf_y_upper[i, cc_rf_o]
    )(
        cc_rf_choose[i, cc_rf_o] = 0
    );

constraint
    forall(i in Rooms)(
        rm_x[i] >=
            sum(cc_rf_o in Ori)(
                cc_rf_x_lower[i, cc_rf_o] * cc_rf_choose[i, cc_rf_o]
            )
        /\
        rm_x[i] <=
            sum(cc_rf_o in Ori)(
                cc_rf_x_upper[i, cc_rf_o] * cc_rf_choose[i, cc_rf_o]
            )
        /\
        rm_y[i] >=
            sum(cc_rf_o in Ori)(
                cc_rf_y_lower[i, cc_rf_o] * cc_rf_choose[i, cc_rf_o]
            )
        /\
        rm_y[i] <=
            sum(cc_rf_o in Ori)(
                cc_rf_y_upper[i, cc_rf_o] * cc_rf_choose[i, cc_rf_o]
            )
    );

constraint
    forall(i in Rooms)(
        rm_x[i] + rm_max_wid[i] +
        (rm_max_len[i] - rm_max_wid[i]) *
        bool2int(rm_ori_0_or_180[i]) <= RollLen
        /\
        rm_y[i] + rm_max_len[i] +
        (rm_max_wid[i] - rm_max_len[i]) *
        bool2int(rm_ori_0_or_180[i]) <= roll_wid
        /\
        forall(j in rm_rec_ids[i])(
            rm_rec_x[j] + rm_rec_vlen[j] <= RollLen
            /\
            rm_rec_y[j] + rm_rec_vwid[j] <= roll_wid
        )
    );

constraint
    forall(i in Rooms, j in rm_rec_ids[i])(
        rm_rec_x[j] =
            rm_x[i] +
            sum(cc_rf_o in Ori)(
                rm_rec_os_x[j, cc_rf_o] * cc_rf_choose[i, cc_rf_o]
            )
        /\
        rm_rec_y[j] =
            rm_y[i] +
            sum(cc_rf_o in Ori)(
                rm_rec_os_y[j, cc_rf_o] * cc_rf_choose[i, cc_rf_o]
            )
    );

constraint
    forall(i in Stairs, j in st_rec_ids[i])(
        st_rec_x[j] + st_rec_len[j] <= RollLen
        /\
        st_rec_y[j] + st_rec_wid[j] <= roll_wid
    );

constraint
    forall(i in Stairs, j1 in st_rec_ids[i]
           where (j1 + 1) in st_rec_ids[i])(
        let {
            int: j2 = j1 + 1
        } in (
            st_rec_y[j1] <= st_rec_y[j2]
            /\
            (
                st_rec_y[j1] >= st_rec_y[j2] ->
                st_rec_x[j1] + st_rec_len[j1] <= st_rec_x[j2]
            )
        )
    );

constraint
    forall(i in Stairs)(
        let {
            int: os = st_rec_id_offset[i],
            set of int: J = 1..st_no_steps[i],
            array [J] of var bool: last_part
        } in (
            last_part[st_no_steps[i]] = true
            /\
            forall(j in J where j != st_no_steps[i])(
                last_part[j] <->
                (
                    st_rec_y[j + os] < st_rec_y[j + os + 1]
                    \/
                    st_rec_x[j + os] + st_rec_len[j] <
                        st_rec_x[j + os + 1]
                )
            )
            /\
            forall(j in J)(
                (
                    st_rec_x[j + os] +
                    2 * st_rec_len[j + os] > RollLen
                ) -> last_part[j]
            )
            /\
            sum(j in J)(bool2int(last_part[j])) <=
                st_max_breaks[i] + 1
            /\
            if st_min_steps[i] > 1 then
                forall(j in 1..(st_min_steps[i] - 1))(
                    last_part[j] = false
                )
                /\
                forall(j in J where j >= st_min_steps[i])(
                    forall(k in
                           (j - st_min_steps[i] + 1)..(j - 1))(
                        last_part[j] -> not(last_part[k])
                    )
                )
            else
                true
            endif
        )
    );

constraint
    cumulative(
        rm_rec_x ++ st_rec_x,
        rm_rec_vlen ++ st_rec_len,
        rm_rec_vwid ++ st_rec_wid,
        roll_wid
    );

constraint
    cumulative(
        rm_rec_y ++ st_rec_y,
        rm_rec_vwid ++ st_rec_wid,
        rm_rec_vlen ++ st_rec_len,
        RollLen
    );

constraint
    diffn(
        rm_rec_x ++ st_rec_x,
        rm_rec_y ++ st_rec_y,
        rm_rec_vlen ++ st_rec_len,
        rm_rec_vwid ++ st_rec_wid
    );

ann: fix_ori_0_or_180 =
    bool_search(
        rm_ori_0_or_180, input_order, indomain_max, complete
    );

ann: fix_ori_0_or_90 =
    bool_search(
        rm_ori_0_or_90, input_order, indomain_max, complete
    );

ann: fix_yx =
    int_search(
        [[rm_y[rm_sort[i]], rm_x[rm_sort[i]]][p]
         | i in Rooms, p in 1..2]
        ++
        [[st_rec_x[i], st_rec_y[i]][p]
         | i in StRecs, p in 1..2],
        input_order, indomain_min, complete
    );

ann: fix_rl =
    int_search([RollLen], input_order, indomain_min, complete);

ann: search1 =
    seq_search([
        fix_ori_0_or_180,
        fix_ori_0_or_90,
        fix_yx,
        fix_rl
    ]);

solve :: search1 minimize RollLen;

output [
    "RolLen    = ", show(RollLen), "\n",
    "rm_vori   = ", show(rm_vori), "\n",
    "rm_x      = ", show(rm_x), "\n",
    "rm_y      = ", show(rm_y), "\n",
    "rm_rec_x  = ", show(rm_rec_x), "\n",
    "rm_rec_y  = ", show(rm_rec_y), "\n",
    "st_rec_x  = ", show(st_rec_x), "\n",
    "st_rec_y  = ", show(st_rec_y), "\n",
    "objective = ", show(RollLen), "\n"
];
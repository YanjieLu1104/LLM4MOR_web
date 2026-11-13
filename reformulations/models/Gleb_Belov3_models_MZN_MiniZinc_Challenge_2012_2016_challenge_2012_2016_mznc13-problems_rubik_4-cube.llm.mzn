array [1..1908] of var bool: b;

array [int] of int: rf_initial_1 = [
    1,51,81,101,141,171,191,236,246,
    296,306,336,381,391,431,466,506,536,
    566,576,606,651,661,701,736,776,806,
    831,861,891,926,931,971,1006,1026,1056,
    1081,1116,1166,1171,1216,1246,1261,1306,1336,
    1356,1381,1411,1456,1481,1511,1546,1571,1601
];

array [index_set(rf_initial_1)] of int: rf_final_1 = [
    25,55,85,115,145,175,205,235,265,
    280,310,340,365,395,425,480,510,540,
    550,580,610,635,665,695,750,780,810,
    820,850,880,905,935,965,1020,1050,1080,
    1100,1130,1160,1190,1220,1250,1280,1310,1340,
    1365,1395,1425,1455,1485,1515,1545,1575,1605
];

array [int] of int: rf_centers_1 = [26,20,41,50,5,23];

array [int] of int: rf_cycles_1 = [
    3,48,39,15,
    6,51,42,24,
    9,54,45,33,
    16,18,36,34,
    17,27,35,25,

    1,13,37,46,
    4,22,40,49,
    7,31,43,52,
    10,12,30,28,
    11,21,29,19,

    28,31,34,48,
    29,32,35,47,
    30,33,36,46,
    37,39,45,43,
    38,42,44,40,

    3,10,43,36,
    2,19,44,27,
    1,28,45,18,
    46,48,54,52,
    47,51,53,49,

    1,3,9,7,
    2,6,8,4,
    10,54,16,13,
    11,53,17,14,
    12,52,18,15,

    7,16,39,30,
    8,25,38,21,
    9,34,37,12,
    13,15,33,31,
    14,24,32,22
];

set of int: rf_positions_1 = index_set(rf_initial_1);
int: rf_nflaces_1 = length(rf_centers_1);
int: rf_ncolors_1 = rf_nflaces_1;
int: rf_nsteps_1 = 4;
int: rf_nstates_1 = rf_nsteps_1 + 1;
int: rf_blockwidth_1 = rf_ncolors_1 * rf_nstates_1;
int: rf_nstatebits_1 = length(rf_initial_1) * rf_blockwidth_1;
set of int: rf_moves_1 = 0..3 * rf_nflaces_1 - 1;
set of int: rf_steps_1 = 0..rf_nsteps_1 - 1;
set of int: rf_states_1 = 0..rf_nstates_1 - 1;
set of int: rf_colors_1 = 0..rf_ncolors_1 - 1;
int: rf_filwidth_1 = length(rf_cycles_1) div rf_nflaces_1;
int: rf_movefirst_1 = min(index_set(b)) + rf_nstatebits_1;
int: rf_triggerfirst_1 =
    rf_movefirst_1 + card(rf_moves_1) * rf_nsteps_1;

function int: rf_preimage_1(int: rf_whichmove_1, int: rf_dest_1) =
    let {
        int: rf_whichface_1 = rf_whichmove_1 mod rf_nflaces_1;
        int: rf_rotation_1 =
            if rf_whichmove_1 < rf_nflaces_1 then 2
            elseif rf_whichmove_1 < 2 * rf_nflaces_1 then 1
            else 3
            endif;
        set of int: rf_hits_1 = {
            rf_r_1 |
            rf_r_1 in index_set(rf_cycles_1) where
            (rf_r_1 - 1) div rf_filwidth_1 = rf_whichface_1 /\
            rf_cycles_1[rf_r_1] = rf_dest_1
        };
    } in
    if card(rf_hits_1) = 0 then
        rf_dest_1
    else
        let {
            int: rf_hit_1 = min(rf_hits_1);
            int: rf_blockstart_1 = 4 * ((rf_hit_1 - 1) div 4);
        } in
        rf_cycles_1[
            rf_blockstart_1 + 1 +
            ((rf_hit_1 - 1) mod 4 + rf_rotation_1) mod 4
        ]
    endif;

array [rf_moves_1, rf_positions_1] of int: rf_source_1 = array2d(
    rf_moves_1,
    rf_positions_1,
    [
        rf_preimage_1(rf_m_1, rf_p_1)
        | rf_m_1 in rf_moves_1, rf_p_1 in rf_positions_1
    ]
);

array [rf_positions_1] of set of int: rf_predecessors_1 = [
    {rf_p_1} union {rf_source_1[rf_m_1,rf_p_1] |
                   rf_m_1 in rf_moves_1}
    | rf_p_1 in rf_positions_1
];

array [rf_colors_1] of int: rf_colorcount_1 = array1d(
    rf_colors_1,
    [
        sum(rf_p_1 in rf_positions_1)(
            bool2int(
                ((rf_initial_1[rf_p_1] - 1) mod rf_blockwidth_1)
                    div rf_nstates_1 = rf_c_1
            )
        )
        | rf_c_1 in rf_colors_1
    ]
);

function int: rf_stateindex_1(int: rf_pos_1, int: rf_col_1,
                              int: rf_state_1) =
    min(index_set(b)) + (rf_pos_1 - 1) * rf_blockwidth_1 +
    rf_col_1 * rf_nstates_1 + rf_state_1;

function int: rf_moveindex_1(int: rf_mov_1, int: rf_step_1) =
    rf_movefirst_1 + rf_mov_1 * rf_nsteps_1 + rf_step_1;

function int: rf_triggerindex_1(int: rf_tpos_1, int: rf_tstep_1) =
    rf_triggerfirst_1 + (rf_tpos_1 - 1) * rf_nsteps_1 +
    rf_tstep_1;

constraint forall(rf_p_1 in rf_positions_1)(
    b[rf_initial_1[rf_p_1]] /\
    b[rf_final_1[rf_p_1]]
);

constraint forall(rf_p_1 in rf_positions_1,
                  rf_t_1 in rf_states_1)(
    sum(rf_c_1 in rf_colors_1)(
        bool2int(b[rf_stateindex_1(rf_p_1,rf_c_1,rf_t_1)])
    ) = 1
);

constraint forall(rf_t_1 in rf_steps_1)(
    sum(rf_m_1 in rf_moves_1)(
        bool2int(b[rf_moveindex_1(rf_m_1,rf_t_1)])
    ) <= 1
);

constraint forall(rf_p_1 in rf_positions_1,
                  rf_t_1 in rf_steps_1)(
    bool2int(b[rf_triggerindex_1(rf_p_1,rf_t_1)]) =
        sum(rf_m_1 in rf_moves_1 where
            rf_source_1[rf_m_1,rf_p_1] != rf_p_1 \/
            rf_centers_1[rf_m_1 mod rf_nflaces_1 + 1] = rf_p_1)(
                bool2int(b[rf_moveindex_1(rf_m_1,rf_t_1)])
        )
);

constraint forall(
    rf_p_1 in rf_positions_1,
    rf_s_1 in rf_predecessors_1[rf_p_1],
    rf_t_1 in rf_steps_1,
    rf_c_1 in rf_colors_1
)(
    bool2int(b[rf_stateindex_1(rf_s_1,rf_c_1,rf_t_1)]) -
    bool2int(b[rf_stateindex_1(rf_p_1,rf_c_1,rf_t_1 + 1)])
    <=
    if rf_s_1 = rf_p_1 then
        sum(rf_m_1 in rf_moves_1 where
            rf_source_1[rf_m_1,rf_p_1] != rf_p_1)(
                bool2int(b[rf_moveindex_1(rf_m_1,rf_t_1)])
        )
    else
        1 - sum(rf_m_1 in rf_moves_1 where
                rf_source_1[rf_m_1,rf_p_1] = rf_s_1)(
                    bool2int(b[rf_moveindex_1(rf_m_1,rf_t_1)])
            )
    endif
);

constraint forall(rf_c_1 in rf_colors_1,
                  rf_t_1 in rf_states_1)(
    sum(rf_p_1 in rf_positions_1)(
        bool2int(b[rf_stateindex_1(rf_p_1,rf_c_1,rf_t_1)])
    ) = rf_colorcount_1[rf_c_1]
);

constraint forall(rf_p_1 in rf_positions_1 where
    (rf_initial_1[rf_p_1] - 1) div rf_nstates_1 !=
    (rf_final_1[rf_p_1] - 1) div rf_nstates_1
)(
    sum(rf_t_1 in rf_steps_1)(
        bool2int(b[rf_triggerindex_1(rf_p_1,rf_t_1)])
    ) >= 1
);

solve satisfy;

output [ "b = ", show(b), ";\n" ];
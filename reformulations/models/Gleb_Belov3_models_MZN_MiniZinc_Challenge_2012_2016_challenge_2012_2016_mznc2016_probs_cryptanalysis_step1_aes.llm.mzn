int: n;
int: objective;

int: KEY_BITS;
int: BLOCK_BITS = 128;
int: KC = KEY_BITS div 32;
int: BC = BLOCK_BITS div 32;
int: NBK = KC + n * BC div KC;

array[0..n-2, 0..BC-1, 0..3] of var 0..1: deltaY;
array[0..n-1, 0..BC-1, 0..3] of var 0..1: deltaX;
array[0..n-1, 0..BC-1, 0..3] of var 0..1: deltaSR;
array[0..n-1, 0..BC-1, 0..3] of var 0..1: deltaK;
array[0..n-1, 0..BC-1, 0..3, 0..NBK-1] of var 0..1: Kcomp;
array[0..3, 0..n-1, 0..BC-1, 0..n-1, 0..BC-1] of var 0..1: eqK;
array[0..n-1, 0..BC-1] of var 0..4: colX;
array[0..n-1, 0..BC-1] of var 0..4: colSRX;
array[0..n-1, 0..BC-1] of var 0..4: colK;

predicate aesrf_activity_xor(
    var 0..1: aesrf_a,
    var 0..1: aesrf_b,
    var 0..1: aesrf_c
) =
    aesrf_a <= aesrf_b + aesrf_c /\
    aesrf_b <= aesrf_a + aesrf_c /\
    aesrf_c <= aesrf_a + aesrf_b;

predicate aesrf_binary_xor(
    var 0..1: aesrf_a,
    var 0..1: aesrf_b,
    var 0..1: aesrf_c
) =
    aesrf_c >= aesrf_a - aesrf_b /\
    aesrf_c >= aesrf_b - aesrf_a /\
    aesrf_c <= aesrf_a + aesrf_b /\
    aesrf_c <= 2 - aesrf_a - aesrf_b;

constraint
    sum(aesrf_r in 0..n-1, aesrf_j in 0..BC-1)(
        colSRX[aesrf_r, aesrf_j]
    ) +
    sum(aesrf_J in 0..BC*n-1 where aesrf_J mod KC == KC-1)(
        colK[aesrf_J div BC, aesrf_J mod BC]
    ) = objective;

constraint forall(aesrf_r in 0..n-1, aesrf_j in 0..BC-1)(
    colX[aesrf_r, aesrf_j] =
        sum(aesrf_i in 0..3)(deltaX[aesrf_r, aesrf_j, aesrf_i]) /\
    colK[aesrf_r, aesrf_j] =
        sum(aesrf_i in 0..3)(deltaK[aesrf_r, aesrf_j, aesrf_i]) /\
    colSRX[aesrf_r, aesrf_j] =
        sum(aesrf_i in 0..3)(deltaSR[aesrf_r, aesrf_j, aesrf_i])
);

constraint forall(
    aesrf_r in 1..n-1,
    aesrf_j in 0..BC-1,
    aesrf_i in 0..3
)(
    aesrf_activity_xor(
        deltaY[aesrf_r-1, aesrf_j, aesrf_i],
        deltaK[aesrf_r, aesrf_j, aesrf_i],
        deltaX[aesrf_r, aesrf_j, aesrf_i]
    )
);

constraint forall(
    aesrf_r in 0..n-1,
    aesrf_j in 0..BC-1,
    aesrf_i in 0..3
)(
    deltaSR[aesrf_r, aesrf_j, aesrf_i] =
        deltaX[aesrf_r, (aesrf_j + aesrf_i) mod BC, aesrf_i]
);

constraint forall(aesrf_r in 0..n-2, aesrf_j in 0..BC-1)(
    let {
        var 0..1: aesrf_active,
        var int: aesrf_total =
            colSRX[aesrf_r, aesrf_j] +
            sum(aesrf_i in 0..3)(
                deltaY[aesrf_r, aesrf_j, aesrf_i]
            )
    } in
        aesrf_total >= 5 * aesrf_active /\
        aesrf_total <= 8 * aesrf_active
);

constraint forall(aesrf_J in 0..n*BC-1, aesrf_i in 0..3)(
    let {
        int: aesrf_r = aesrf_J div BC,
        int: aesrf_j = aesrf_J mod BC
    } in
    forall(aesrf_k in 0..NBK-1)(
        if aesrf_J < KC then
            if aesrf_k == aesrf_J then
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] =
                    deltaK[aesrf_r, aesrf_j, aesrf_i]
            else
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] = 0
            endif
        elseif aesrf_J mod KC == 0 then
            if aesrf_k == (aesrf_J div KC) * BC + aesrf_j then
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] =
                    deltaK[
                        (aesrf_J-1) div BC,
                        (aesrf_J+BC-1) mod BC,
                        (aesrf_i+1) mod 4
                    ]
            else
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] =
                    Kcomp[
                        (aesrf_J-KC) div BC,
                        (aesrf_J-KC) mod BC,
                        aesrf_i,
                        aesrf_k
                    ]
            endif
        else
            true
        endif
    )
);

constraint forall(aesrf_J in KC..n*BC-1, aesrf_i in 0..3)(
    let {
        int: aesrf_r = aesrf_J div BC,
        int: aesrf_j = aesrf_J mod BC,
        int: aesrf_ra = (aesrf_J-KC) div BC,
        int: aesrf_ja = (aesrf_J-KC) mod BC,
        int: aesrf_rb = (aesrf_J-1) div BC,
        int: aesrf_jb = (aesrf_J+BC-1) mod BC,
        var int: aesrf_total =
            sum(aesrf_k in 0..NBK-1)(
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k]
            ) + deltaK[aesrf_r, aesrf_j, aesrf_i]
    } in
    (
        if aesrf_J mod KC == 0 then
            aesrf_activity_xor(
                deltaK[aesrf_ra, aesrf_ja, aesrf_i],
                deltaK[aesrf_rb, aesrf_jb, (aesrf_i+1) mod 4],
                deltaK[aesrf_r, aesrf_j, aesrf_i]
            )
        else
            aesrf_activity_xor(
                deltaK[aesrf_ra, aesrf_ja, aesrf_i],
                deltaK[aesrf_rb, aesrf_jb, aesrf_i],
                deltaK[aesrf_r, aesrf_j, aesrf_i]
            ) /\
            eqK[aesrf_i, aesrf_rb, aesrf_jb, aesrf_ra, aesrf_ja] =
                1 - deltaK[aesrf_r, aesrf_j, aesrf_i] /\
            eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_ra, aesrf_ja] =
                1 - deltaK[aesrf_rb, aesrf_jb, aesrf_i] /\
            eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_rb, aesrf_jb] =
                1 - deltaK[aesrf_ra, aesrf_ja, aesrf_i] /\
            forall(aesrf_k in 0..NBK-1)(
                let {
                    var 0..1: aesrf_gated_a,
                    var 0..1: aesrf_gated_b
                } in
                    aesrf_gated_a <=
                        Kcomp[aesrf_ra, aesrf_ja, aesrf_i, aesrf_k] /\
                    aesrf_gated_a <=
                        deltaK[aesrf_ra, aesrf_ja, aesrf_i] /\
                    aesrf_gated_a >=
                        Kcomp[aesrf_ra, aesrf_ja, aesrf_i, aesrf_k] +
                        deltaK[aesrf_ra, aesrf_ja, aesrf_i] - 1 /\
                    aesrf_gated_b <=
                        Kcomp[aesrf_rb, aesrf_jb, aesrf_i, aesrf_k] /\
                    aesrf_gated_b <=
                        deltaK[aesrf_rb, aesrf_jb, aesrf_i] /\
                    aesrf_gated_b >=
                        Kcomp[aesrf_rb, aesrf_jb, aesrf_i, aesrf_k] +
                        deltaK[aesrf_rb, aesrf_jb, aesrf_i] - 1 /\
                    aesrf_binary_xor(
                        aesrf_gated_a,
                        aesrf_gated_b,
                        Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k]
                    )
            )
        endif
    ) /\
    2 * deltaK[aesrf_r, aesrf_j, aesrf_i] <= aesrf_total /\
    forall(aesrf_k in 0..NBK-1)(
        2 * Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] <= aesrf_total
    )
);

constraint forall(
    aesrf_J in 0..n*BC-1,
    aesrf_J2 in aesrf_J+1..n*BC-1,
    aesrf_i in 0..3
)(
    let {
        int: aesrf_r = aesrf_J div BC,
        int: aesrf_j = aesrf_J mod BC,
        int: aesrf_r2 = aesrf_J2 div BC,
        int: aesrf_j2 = aesrf_J2 mod BC,
        array[index_set_4of4(Kcomp)] of var 0..1: aesrf_mismatch
    } in
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] =
            eqK[aesrf_i, aesrf_r2, aesrf_j2, aesrf_r, aesrf_j] /\
        deltaK[aesrf_r, aesrf_j, aesrf_i] -
            deltaK[aesrf_r2, aesrf_j2, aesrf_i] <=
            1 - eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] /\
        deltaK[aesrf_r2, aesrf_j2, aesrf_i] -
            deltaK[aesrf_r, aesrf_j, aesrf_i] <=
            1 - eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] /\
        deltaK[aesrf_r, aesrf_j, aesrf_i] +
            deltaK[aesrf_r2, aesrf_j2, aesrf_i] +
            eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] >= 1 /\
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] <=
            eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r, aesrf_j] /\
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] <=
            eqK[aesrf_i, aesrf_r2, aesrf_j2, aesrf_r2, aesrf_j2] /\
        forall(aesrf_k in index_set(aesrf_mismatch))(
            aesrf_mismatch[aesrf_k] <=
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] +
                Kcomp[aesrf_r2, aesrf_j2, aesrf_i, aesrf_k] /\
            aesrf_mismatch[aesrf_k] <=
                2 -
                Kcomp[aesrf_r, aesrf_j, aesrf_i, aesrf_k] -
                Kcomp[aesrf_r2, aesrf_j2, aesrf_i, aesrf_k]
        ) /\
        sum(aesrf_k in index_set(aesrf_mismatch))(
            aesrf_mismatch[aesrf_k]
        ) >= 1 - eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2]
);

constraint forall(
    aesrf_J in 0..n*BC-1,
    aesrf_J2 in aesrf_J+1..n*BC-1,
    aesrf_J3 in aesrf_J2+1..n*BC-1,
    aesrf_i in 0..3
)(
    let {
        int: aesrf_r = aesrf_J div BC,
        int: aesrf_j = aesrf_J mod BC,
        int: aesrf_r2 = aesrf_J2 div BC,
        int: aesrf_j2 = aesrf_J2 mod BC,
        int: aesrf_r3 = aesrf_J3 div BC,
        int: aesrf_j3 = aesrf_J3 mod BC
    } in
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] +
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r3, aesrf_j3] -
        eqK[aesrf_i, aesrf_r2, aesrf_j2, aesrf_r3, aesrf_j3] <= 1 /\
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] +
        eqK[aesrf_i, aesrf_r2, aesrf_j2, aesrf_r3, aesrf_j3] -
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r3, aesrf_j3] <= 1 /\
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r3, aesrf_j3] +
        eqK[aesrf_i, aesrf_r2, aesrf_j2, aesrf_r3, aesrf_j3] -
        eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] <= 1
);

constraint forall(
    aesrf_J in BC..n*BC-1,
    aesrf_J2 in aesrf_J+1..n*BC-1
)(
    let {
        int: aesrf_r = aesrf_J div BC,
        int: aesrf_j = aesrf_J mod BC,
        int: aesrf_r2 = aesrf_J2 div BC,
        int: aesrf_j2 = aesrf_J2 mod BC,
        var 0..1: aesrf_diff,
        array[index_set_3of3(deltaSR)] of var 0..1: aesrf_equal_sr,
        array[index_set_3of3(deltaY)] of var 0..1: aesrf_equal_y
    } in
        forall(aesrf_i in 0..3)(
            aesrf_diff >=
                deltaSR[aesrf_r-1, aesrf_j, aesrf_i] -
                deltaSR[aesrf_r2-1, aesrf_j2, aesrf_i] /\
            aesrf_diff >=
                deltaSR[aesrf_r2-1, aesrf_j2, aesrf_i] -
                deltaSR[aesrf_r-1, aesrf_j, aesrf_i] /\
            aesrf_diff >=
                deltaY[aesrf_r-1, aesrf_j, aesrf_i] -
                deltaY[aesrf_r2-1, aesrf_j2, aesrf_i] /\
            aesrf_diff >=
                deltaY[aesrf_r2-1, aesrf_j2, aesrf_i] -
                deltaY[aesrf_r-1, aesrf_j, aesrf_i] /\
            aesrf_diff >=
                1 -
                eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] -
                deltaX[aesrf_r, aesrf_j, aesrf_i] -
                deltaX[aesrf_r2, aesrf_j2, aesrf_i] /\
            aesrf_diff >=
                eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] +
                deltaK[aesrf_r, aesrf_j, aesrf_i] +
                deltaX[aesrf_r, aesrf_j, aesrf_i] -
                deltaX[aesrf_r2, aesrf_j2, aesrf_i] - 2 /\
            aesrf_diff >=
                eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] +
                deltaK[aesrf_r, aesrf_j, aesrf_i] +
                deltaX[aesrf_r2, aesrf_j2, aesrf_i] -
                deltaX[aesrf_r, aesrf_j, aesrf_i] - 2 /\
            aesrf_equal_sr[aesrf_i] >=
                1 -
                deltaSR[aesrf_r-1, aesrf_j, aesrf_i] -
                deltaSR[aesrf_r2-1, aesrf_j2, aesrf_i] /\
            aesrf_equal_y[aesrf_i] >=
                eqK[aesrf_i, aesrf_r, aesrf_j, aesrf_r2, aesrf_j2] -
                deltaX[aesrf_r, aesrf_j, aesrf_i] -
                deltaX[aesrf_r2, aesrf_j2, aesrf_i] /\
            aesrf_equal_y[aesrf_i] >=
                1 -
                deltaY[aesrf_r-1, aesrf_j, aesrf_i] -
                deltaY[aesrf_r2-1, aesrf_j2, aesrf_i]
        ) /\
        sum(aesrf_i in index_set(aesrf_equal_sr))(
            aesrf_equal_sr[aesrf_i]
        ) +
        sum(aesrf_i in index_set(aesrf_equal_y))(
            aesrf_equal_y[aesrf_i]
        ) <= 8 - 5 * aesrf_diff
);

solve satisfy;

output [
    "deltaX = array3d(0..\(n-1), 0..\(BC-1),0..3,\(deltaX));\n"
    ++ "deltaY = array3d(0..\(n-2), 0..\(BC-1),0..3,\(deltaY));\n"
    ++ "deltaK = array3d(0..\(n-1), 0..\(BC-1),0..3,\(deltaK));\n"
    ++ "deltaSR = array3d(0..\(n-1), 0..\(BC-1),0..3,\(deltaSR));\n"
    ++ "%% objective = \(objective);\n"
];
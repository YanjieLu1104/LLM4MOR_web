set M;
set H;
set I;
set T dimen 4;

set ON;
set OFF;

set P1{H};
set P2{H};
set P3{H};

param psr_delta {psr_h in H, psr_i in I} :=
    (if psr_i in P3[psr_h] then 1 else 0)
  - (if psr_i in P1[psr_h] then 1 else 0)
  - (if psr_i in P2[psr_h] then 1 else 0);

set psr_need_on {psr_h in H} within I :=
    (setof {
        (psr_i, psr_a, psr_b, psr_c) in T:
        psr_i in I and (psr_a = psr_h or psr_b = psr_h)
    } psr_i)
    union
    {psr_i in I: psr_delta[psr_h, psr_i] < 0};

set psr_need_off {psr_h in H} within I :=
    (setof {
        (psr_i, psr_a, psr_b, psr_c) in T:
        psr_i in I and psr_c = psr_h
    } psr_i)
    union
    {psr_i in I: psr_delta[psr_h, psr_i] > 0};

set psr_disabled within I :=
    {psr_i in I:
        card({psr_h in H:
            psr_delta[psr_h, psr_i] < -1
        }) > 0
        or
        card({psr_h in H:
            psr_i in psr_need_on[psr_h]
            and psr_i in psr_need_off[psr_h]
        }) > 0
    };

var x{M, H} binary;
var y{M, I} binary;

minimize Obj:
    sum {psr_h in H} x[35, psr_h];

subject to Init_on {psr_h in ON}:
    x[0, psr_h] = 1;

subject to Init_off {psr_h in OFF}:
    x[0, psr_h] = 0;

subject to Move_choice {psr_m in M: psr_m < 35}:
    sum {psr_i in I} y[psr_m, psr_i] = 1;

subject to psr_occupied_requirement {
    psr_m in M, psr_h in H:
    psr_m < 35 and card(psr_need_on[psr_h]) > 0
}:
    sum {psr_i in psr_need_on[psr_h]} y[psr_m, psr_i]
    <= x[psr_m, psr_h];

subject to psr_empty_requirement {
    psr_m in M, psr_h in H:
    psr_m < 35 and card(psr_need_off[psr_h]) > 0
}:
    sum {psr_i in psr_need_off[psr_h]} y[psr_m, psr_i]
    <= 1 - x[psr_m, psr_h];

subject to psr_disable_move {
    psr_m in M, psr_i in psr_disabled: psr_m < 35
}:
    y[psr_m, psr_i] = 0;

subject to Transition {
    psr_m in M, psr_h in H: psr_m < 35
}:
    x[psr_m + 1, psr_h]
    = x[psr_m, psr_h]
      - sum {psr_i in P1[psr_h]} y[psr_m, psr_i]
      - sum {psr_i in P2[psr_h]} y[psr_m, psr_i]
      + sum {psr_i in P3[psr_h]} y[psr_m, psr_i];
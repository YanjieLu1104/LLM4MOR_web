int: n;

array[1..n, 0..n] of int: p;
int: min_p = min(i in 1..n, j in 0..n)(p[i, j]);
int: max_p = max(i in 1..n, j in 0..n)(p[i, j]);

int: max_obj =
    sum(i in 1..n)(max(0, max([p[i, j] | j in 1..n])));

array[1..n] of var 0..n: pos;
array[1..n] of var 0..n: next;
array[1..n] of var min_p..max_p: prize;
var 0..max_obj: objective;

array[index_set_1of2(p), index_set_2of2(p)] of var 0..1:
    pc_reform_arc;

constraint pos[1] = 1;

constraint forall(pc_reform_i in index_set(pos)) (
    sum(pc_reform_j in index_set_2of2(p)) (
        pc_reform_arc[pc_reform_i, pc_reform_j]
    ) = 1
);

constraint forall(pc_reform_i in index_set(pos)) (
    next[pc_reform_i] =
        sum(pc_reform_j in index_set_2of2(p)) (
            pc_reform_j * pc_reform_arc[pc_reform_i, pc_reform_j]
        )
);

constraint forall(pc_reform_i in index_set(pos)) (
    prize[pc_reform_i] =
        sum(pc_reform_j in index_set_2of2(p)) (
            p[pc_reform_i, pc_reform_j] *
            pc_reform_arc[pc_reform_i, pc_reform_j]
        )
);

constraint forall(pc_reform_i in index_set(pos)) (
    pos[pc_reform_i] >= 1 - pc_reform_arc[pc_reform_i, 0]
    /\
    pos[pc_reform_i] <= n * (1 - pc_reform_arc[pc_reform_i, 0])
);

constraint forall(pc_reform_i in index_set(pos)) (
    sum(pc_reform_k in index_set(pos)) (
        pc_reform_arc[pc_reform_k, pc_reform_i]
    ) = 1 - pc_reform_arc[pc_reform_i, 0]
);

constraint forall(
    pc_reform_i in index_set(pos)
    where pc_reform_i > 1
) (
    pc_reform_arc[pc_reform_i, pc_reform_i] = 0
    /\
    pos[pc_reform_i] >= 2 * (1 - pc_reform_arc[pc_reform_i, 0])
    /\
    pos[pc_reform_i] <=
        sum(pc_reform_k in index_set(pos)) (
            1 - pc_reform_arc[pc_reform_k, 0]
        )
);

constraint forall(
    pc_reform_i in index_set(pos),
    pc_reform_j in index_set(pos)
    where pc_reform_j > 1 /\ pc_reform_i != pc_reform_j
) (
    pos[pc_reform_j] >=
        pos[pc_reform_i] + 1
        - (if pc_reform_i = 1 then 2 else n + 1 endif)
          * (1 - pc_reform_arc[pc_reform_i, pc_reform_j])
    /\
    pos[pc_reform_j] <=
        pos[pc_reform_i] + 1
        + (if pc_reform_i = 1 then n - 2 else n - 1 endif)
          * (1 - pc_reform_arc[pc_reform_i, pc_reform_j])
);

constraint objective = sum(i in 1..n)(prize[i]);

solve maximize objective;

output [
    "pos = \(pos);\n",
    "next = \(next);\n",
    "prize = \(prize);\n",
    "objective = \(objective);\n"
];
int: rows;
int: cols;
set of int: row = 1..rows;
set of int: col = 1..cols;
array [row, col] of 0..9: puzzle;

set of int: id = 1..(rows * cols);
set of int: Time = 1..min(9, rows + cols);

array [id] of var 0..(rows * cols): size;
array [row, col] of var id: area;
array [row, col] of var Time: when;
array [row, col] of var 1..9: what;

test ok(int: r, int: c) =
    r in row /\ c in col;

test after(int: r, int: c, int: rr, int: cc) =
    rr > r \/ (rr = r /\ cc > c);

array [row, col] of int: same_in_range =
    array2d(row, col, [
        sum([
            bool2int(puzzle[rr, cc] = puzzle[r, c])
            | rr in row, cc in col
            where after(r, c, rr, cc)
                /\ abs(rr - r) + abs(cc - c) < puzzle[r, c]
        ])
        | r in row, c in col
    ]);

array [row, col] of set of int: fmz_candidates =
    array2d(row, col, [
        {
            (rr - 1) * cols + cc
            | rr in row, cc in col
            where
                abs(rr - r) + abs(cc - c) < min(9, rows + cols)
                /\ (
                    puzzle[r, c] = 0
                    \/ abs(rr - r) + abs(cc - c) < puzzle[r, c]
                )
                /\ (
                    puzzle[rr, cc] = 0
                    \/ abs(rr - r) + abs(cc - c) < puzzle[rr, cc]
                )
                /\ (
                    puzzle[r, c] = 0
                    \/ puzzle[rr, cc] = 0
                    \/ puzzle[r, c] = puzzle[rr, cc]
                )
                /\ (
                    puzzle[r, c] = 0
                    \/ same_in_range[r, c] != 0
                    \/ (r = rr /\ c = cc)
                )
        }
        | r in row, c in col
    ]);

array [int] of int: fmz_link_row =
    [r | r in row, c in col, a in fmz_candidates[r, c]];

set of int: fmz_links = index_set(fmz_link_row);

array [fmz_links] of int: fmz_link_col =
    [c | r in row, c in col, a in fmz_candidates[r, c]];

array [fmz_links] of int: fmz_link_area =
    [a | r in row, c in col, a in fmz_candidates[r, c]];

array [row, col] of set of int: fmz_cell_links =
    array2d(row, col, [
        {
            fmz_k
            | fmz_k in fmz_links
            where fmz_link_row[fmz_k] = r
                /\ fmz_link_col[fmz_k] = c
        }
        | r in row, c in col
    ]);

array [id] of set of int: fmz_area_links =
    [
        {
            fmz_k
            | fmz_k in fmz_links
            where fmz_link_area[fmz_k] = a
        }
        | a in id
    ];

array [fmz_links] of var bool: fmz_selected;

constraint
    forall (a in id) (
        size[a] <= 9
    );

constraint
    forall (r in row, c in col where puzzle[r, c] != 0) (
        let { int: s = puzzle[r, c] } in
            what[r, c] = s
            /\ if same_in_range[r, c] = 0 then
                when[r, c] = 1
                /\ area[r, c] = (r - 1) * cols + c
            else
                true
            endif
    );

constraint
    forall (r in row, c in col) (
        sum (fmz_k in fmz_cell_links[r, c]) (
            bool2int(fmz_selected[fmz_k])
        ) = 1
        /\
        area[r, c] =
            sum (fmz_k in fmz_cell_links[r, c]) (
                fmz_link_area[fmz_k] * bool2int(fmz_selected[fmz_k])
            )
    );

constraint
    forall (a in id) (
        size[a] =
            sum (fmz_k in fmz_area_links[a]) (
                bool2int(fmz_selected[fmz_k])
            )
    );

constraint
    forall (fmz_k in fmz_links) (
        fmz_selected[fmz_k] ->
            what[fmz_link_row[fmz_k], fmz_link_col[fmz_k]]
                = size[fmz_link_area[fmz_k]]
    );

predicate joins(row: r, col: c, int: rr, int: cc) =
    if ok(rr, cc) then
        when[r, c] = 1 + when[rr, cc]
        /\ area[r, c] = area[rr, cc]
        /\ what[r, c] = what[rr, cc]
    else
        false
    endif;

constraint
    forall (r in row, c in col) (
        (
            when[r, c] = 1
            /\ area[r, c] = (r - 1) * cols + c
        )
        \/
        (
            1 < when[r, c]
            /\ (
                joins(r, c, r - 1, c)
                \/ joins(r, c, r + 1, c)
                \/ joins(r, c, r, c - 1)
                \/ joins(r, c, r, c + 1)
            )
        )
    );

constraint
    forall (r in row, c in col) (
        when[r, c] <= what[r, c]
    );

constraint
    forall (r in row, c in col) (
        size[(r - 1) * cols + c]
            <= 9 * bool2int(when[r, c] = 1)
    );

constraint
    forall (r in row, c in col where c > 1) (
        (area[r, c - 1] != area[r, c])
            = (what[r, c - 1] != what[r, c])
    );

constraint
    forall (r in row, c in col where r > 1) (
        (area[r - 1, c] != area[r, c])
            = (what[r - 1, c] != what[r, c])
    );

solve satisfy;

output [
    "what = array2d(", show(row), ", ", show(col), ", ", show(what), ");\n",
    "when = array2d(", show(row), ", ", show(col), ", ", show(when), ");\n",
    "area = array2d(", show(row), ", ", show(col), ", ", show(area), ");\n"
];
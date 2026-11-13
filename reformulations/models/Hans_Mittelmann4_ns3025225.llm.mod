param width;
param height;
param blocks;
param levels;
param separation;
param objectiveBound;

param W = width;
param H = height;
param L = levels;

param w{i in 1..levels, j in 1..blocks} := 1;
param h{i in 1..levels, j in 1..blocks} := 1;

param wireOrigins{i in 1..blocks} := (W * i)/(blocks+1);

param rf302_requiredTop{i in 1..levels} :=
    ceil(i * blocks / width);

param rf302_lowRow{i in 1..levels} :=
    if rf302_requiredTop[i] > (i-1) * separation
    then max(1, rf302_requiredTop[i] - separation)
    else 1;

set rf302_cells dimen 4 :=
    {i in 1..levels, j in 1..blocks,
     m in 1..height, n in 1..width:
         m >= rf302_lowRow[i]
         and m <= i * separation
         and wireOrigins[j] - (n - 1/2) <= objectiveBound};

var placement{(i,j,m,n) in rf302_cells} binary;

var wireLength{i in 1..levels, j in 1..blocks} =
    sum{m in 1..height, n in 1..width:
        (i,j,m,n) in rf302_cells}
        (wireOrigins[j] - (n - 1/2)) * placement[i,j,m,n];

var maximumWireLength >= 0;

var rf302_levelBase{i in 1..levels}
    >= rf302_lowRow[i],
    <= min(height, i * separation);

minimize wire:
    maximumWireLength;

s.t. foundPlace{i in 1..levels, j in 1..blocks}:
    sum{m in 1..height, n in 1..width:
        (i,j,m,n) in rf302_cells}
        placement[i,j,m,n] = 1;

s.t. usedOnce{m in 1..height, n in 1..width}:
    sum{i in 1..levels, j in 1..blocks:
        (i,j,m,n) in rf302_cells}
        placement[i,j,m,n] <= 1;

s.t. absoluteLength1{i in 1..levels, j in 1..blocks}:
    sum{m in 1..height, n in 1..width:
        (i,j,m,n) in rf302_cells}
        abs(wireOrigins[j] - (n - 1/2)) * placement[i,j,m,n]
    <= maximumWireLength;

s.t. rf302_rangeLower{i in 1..levels, j in 1..blocks}:
    sum{m in 1..height, n in 1..width:
        (i,j,m,n) in rf302_cells}
        m * placement[i,j,m,n]
    >= rf302_levelBase[i];

s.t. rf302_rangeUpper{i in 1..levels, j in 1..blocks}:
    sum{m in 1..height, n in 1..width:
        (i,j,m,n) in rf302_cells}
        m * placement[i,j,m,n]
    <= rf302_levelBase[i] + separation;

data;

param width := 25;
param height := 13;
param blocks := 65;
param levels := 5;
param separation := 3;
param objectiveBound := 1.0;
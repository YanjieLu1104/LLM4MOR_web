set N;
set C;

param nWE{c in C}, integer, > 0;

set S;

param isNightS{s in S}, integer, >= 0, <= 1;

set D;

set WE{c in C, 1..nWE[c]} within D;
set NS{n in N};

param r{d in D, s in S}, >= 0, integer;
param nx{n in N, s in S, d in D}, integer, default 0;
param cn{n in N}, symbolic, in C;

param na_Max{c in C}, integer, >= 0;
param wna_Max{c in C}, integer, >= 0;
param na_Min{c in C}, integer, >= 0;
param wna_Min{c in C}, integer, >= 0;

param nw_Max{c in C}, integer, >= 0;
param wnw_Max{c in C}, integer, >= 0;
param nw_Min{c in C}, integer, >= 0;
param wnw_Min{c in C}, integer, >= 0;

param nf_Max{c in C}, integer, >= 0;
param wnf_Max{c in C}, integer, >= 0;
param nf_Min{c in C}, integer, >= 0;
param wnf_Min{c in C}, integer, >= 0;

param nwec_Max{c in C}, integer, >= 0;
param wnwec_Max{c in C}, integer, >= 0;
param nwec_Min{c in C}, integer, >= 0;
param wnwec_Min{c in C}, integer, >= 0;

param nw4_Max{c in C}, integer, >= 0;
param wnw4_Max{c in C}, integer, >= 0;

param nO{c in C}, integer, >= 0;

param fw{c in C}, binary;
param wfw{c in C}, integer, >= 0;

param nnsbw{c in C}, binary, >= 0;
param wnnsbw{c in C}, integer, >= 0;

param ssw{c in C}, binary;
param wssw{c in C}, integer, >= 0;

param wAltS{c in C}, integer, >= 0;

param npit{c in C}, integer, >= 0, default 0;
param tpit{c in C, i in 1..npit[c]}, integer, >= 0, default 0;
param cpit{c in C, i in 1..npit[c], j in 1..tpit[c,i]},
    symbolic, in S;
param wpit{c in C, i in 1..npit[c]}, integer, default 1;

param npid{c in C}, integer, >= 0, default 0;
param tpid{c in C, i in 1..npid[c]}, integer, >= 0, default 0;
param cpid{c in C, i in 1..npid[c], j in 1..tpid[c,i]}, integer;
param wpid{c in C, i in 1..npid[c]}, integer, default 1;

param reform01_calendar binary :=
    if card(D inter (1..card(D))) = card(D) then 1 else 0;

var x{n in N, s in S, d in D}, binary;

var y{n in N, i in 0..nWE[cn[n]]}, binary;

var z{n in N, il in 1..nWE[cn[n]], ill in il..nWE[cn[n]]},
    binary;

var ww{n in N, d1 in D, d2 in D: d1 <= d2}, binary;
var rw{n in N, d1 in D, d2 in D: d1 <= d2}, binary;

var vna_Max{n in N}, >= 0, integer, <= card(D)-na_Max[cn[n]];
var vna_Min{n in N}, >= 0, integer, <= na_Min[cn[n]];

var vnwec_Max{
    n in N,
    i in 1..nWE[cn[n]]-nwec_Max[cn[n]]:
    nwec_Max[cn[n]] != 0
}, >= 0, integer, <= nWE[cn[n]]-nwec_Max[cn[n]];

var vnwec_Min{
    n in N,
    i in 1..nWE[cn[n]]:
    nwec_Min[cn[n]] != 0
}, >= 0, integer, <= nwec_Min[cn[n]];

var vnw4_Max{n in N, i in 1..nWE[cn[n]]-3},
    >= 0, integer, <= 4-nw4_Max[cn[n]];

var vno{
    n in N, d in D:
    d <= card(D)-2 and nO[cn[n]] >= 1
}, >= 0, integer, <= 2;

var vnnsbw{n in N, i in 1..nWE[cn[n]]}, >= 0, binary;

var vssw{
    n in N, s in S, i in 1..nWE[cn[n]],
    d1 in WE[cn[n],i], d2 in WE[cn[n],i]:
    d1 < d2 and ssw[cn[n]] = 1
}, binary;

var vpit{n in N, i in 1..npit[cn[n]], d in D}, binary;
var vpid{n in N, i in 1..npid[cn[n]]}, binary;

minimize penalties:
    sum{n in N, s in S diff NS[n], d in D}
        wAltS[cn[n]]*x[n,s,d]

  + sum{n in N} wna_Max[cn[n]]*vna_Max[n]
  + sum{n in N} wna_Min[cn[n]]*vna_Min[n]

  + sum{
        n in N, i1 in 1..nWE[cn[n]], i2 in i1..nWE[cn[n]]:
        nwec_Max[cn[n]] != 0
        and i2-i1+1 > nwec_Max[cn[n]]
        and wnwec_Max[cn[n]] > 0
    }
        wnwec_Max[cn[n]]
        *((i2-i1+1)-nwec_Max[cn[n]])*z[n,i1,i2]

  + sum{
        n in N, i in 1..nWE[cn[n]]:
        nwec_Max[cn[n]] = 0 and wnwec_Max[cn[n]] > 0
    }
        (sum{
            d1 in 1..card(D), d2 in d1..card(D):
            card(WE[cn[n],i] inter (d1..d2)) > 0
        } wnwec_Max[cn[n]]*ww[n,d1,d2])

  + sum{
        n in N, i1 in 1..nWE[cn[n]], i2 in i1..nWE[cn[n]]:
        nwec_Min[cn[n]] != 0
        and i2-i1+1 < nwec_Min[cn[n]]
        and wnwec_Min[cn[n]] > 0
    }
        wnwec_Min[cn[n]]
        *(nwec_Min[cn[n]]-(i2-i1+1))*z[n,i1,i2]

  + sum{n in N, i in 1..nWE[cn[n]]-3}
        wnw4_Max[cn[n]]*vnw4_Max[n,i]

  + sum{
        n in N, d in D:
        d <= card(D)-2 and nO[cn[n]] >= 1
    } vno[n,d]

  + sum{n in N, i in 1..nWE[cn[n]]}
        wnnsbw[cn[n]]*vnnsbw[n,i]

  + sum{
        n in N, s in S, i in 1..nWE[cn[n]],
        d1 in WE[cn[n],i], d2 in WE[cn[n],i]:
        d1 < d2 and ssw[cn[n]] = 1
    } wssw[cn[n]]*vssw[n,s,i,d1,d2]

  + sum{n in N, i in 1..npit[cn[n]], d in D}
        vpit[n,i,d]*wpit[cn[n],i]

  + sum{n in N, i in 1..npid[cn[n]]}
        vpid[n,i]*wpid[cn[n],i]

  + sum{
        n in N, d1 in D, d2 in D:
        d1 <= card(D)-nw_Max[cn[n]]
        and d2 >= d1
        and d2-d1+1 > nw_Max[cn[n]]
    }
        ww[n,d1,d2]*((d2-d1+1)-nw_Max[cn[n]])*wnw_Max[cn[n]]

  + sum{
        n in N, d1 in D, d2 in D:
        d1 <= d2 and d2-d1+1 < nw_Min[cn[n]]
    }
        ww[n,d1,d2]*(nw_Min[cn[n]]-(d2-d1+1))*wnw_Min[cn[n]]

  + sum{
        n in N, i in 1..nWE[cn[n]],
        d1 in 1..card(D), d2 in d1..card(D):
        fw[cn[n]] = 1
        and card(WE[cn[n],i] inter (d1..d2)) > 0
        and card(WE[cn[n],i] inter (d1..d2)) < card(WE[cn[n],i])
    }
        wfw[cn[n]]*ww[n,d1,d2]

  + sum{
        n in N, d1 in D, d2 in D:
        d1 <= card(D)-nf_Max[cn[n]]
        and d2 >= d1
        and d2-d1+1 > nf_Max[cn[n]]
    }
        rw[n,d1,d2]*((d2-d1+1)-nf_Max[cn[n]])*wnf_Max[cn[n]]

  + sum{
        n in N, d1 in D, d2 in D:
        d2 >= d1 and d2-d1+1 < nf_Min[cn[n]]
    }
        rw[n,d1,d2]*(nf_Min[cn[n]]-(d2-d1+1))*wnf_Min[cn[n]]

  + sum{n in N, s in S, d in D}
        nx[n,s,d]*x[n,s,d];

s.t. shiftCover{d in D, s in S}:
    sum{n in N} x[n,s,d] = r[d,s];

s.t. nurseShiftNoClash{n in N, d in D}:
    sum{s in S} x[n,s,d] <= 1;

s.t. weekend0{n in N}:
    y[n,0] = 0;

s.t. worksOnWeekend{
    n in N, i in 1..nWE[cn[n]], d in WE[cn[n],i]
}:
    y[n,i] >= sum{s in S} x[n,s,d];

s.t. doNotWorksWeekend{n in N, i in 1..nWE[cn[n]]}:
    y[n,i] <= sum{s in S, d in WE[cn[n],i]} x[n,s,d];

s.t. workWindX{n in N, d in D}:
    sum{s in S} x[n,s,d]
    = sum{
        d1 in D, d2 in D:
        d1 <= d2 and d1 <= d and d2 >= d
      } ww[n,d1,d2];

s.t. restWindX{n in N, d in D}:
    sum{s in S} x[n,s,d]
    = 1 - sum{
        d1 in D, d2 in D:
        d1 <= d2 and d1 <= d and d2 >= d
      } rw[n,d1,d2];

s.t. windowsDay{n in N, d in D: reform01_calendar = 0}:
    sum{d1 in 1..d, d2 in d..card(D)} ww[n,d1,d2]
  + sum{d1 in 1..d, d2 in d..card(D)} rw[n,d1,d2]
    = 1;

s.t. joinWW{
    n in N, d in 1..card(D)-1:
    reform01_calendar = 0
}:
    sum{di in 1..d} ww[n,di,d]
  + sum{dj in d+1..card(D)} ww[n,d+1,dj]
    <= 1;

s.t. joinRW{
    n in N, d in 1..card(D)-1:
    reform01_calendar = 0
}:
    sum{di in 1..d} rw[n,di,d]
  + sum{dj in d+1..card(D)} rw[n,d+1,dj]
    <= 1;

s.t. reform01_work_to_rest{
    n in N, d in D:
    reform01_calendar = 1 and d < card(D)
}:
    sum{d1 in D: d1 <= d} ww[n,d1,d]
    = sum{d2 in D: d2 >= d+1} rw[n,d+1,d2];

s.t. reform01_rest_to_work{
    n in N, d in D:
    reform01_calendar = 1 and d < card(D)
}:
    sum{d1 in D: d1 <= d} rw[n,d1,d]
    = sum{d2 in D: d2 >= d+1} ww[n,d+1,d2];

s.t. joinWWRW{n in N, d1 in D, d2 in D: d2-d1 = 2}:
    sum{di in 1..d1} ww[n,di,d1]
  + sum{de in d2..card(D)} rw[n,d2,de]
    <= 1;

s.t. joinRWWW{n in N, d1 in D, d2 in D: d2-d1 = 2}:
    sum{di in 1..d1} rw[n,di,d1]
  + sum{de in d2..card(D)} ww[n,d2,de]
    <= 1;

s.t. weekendWindowZAndX{n in N, i in 1..nWE[cn[n]]}:
    y[n,i]
    = sum{il in 1..i, ill in i..nWE[cn[n]]} z[n,il,ill];

s.t. reform01_weekend_start{n in N, i in 2..nWE[cn[n]]}:
    sum{ill in i..nWE[cn[n]]} z[n,i,ill]
    <= 1-y[n,i-1];

s.t. reform01_weekend_end{n in N, i in 1..nWE[cn[n]]-1}:
    sum{il in 1..i} z[n,il,i]
    <= 1-y[n,i+1];

s.t. maxAllocations{n in N}:
    sum{s in S, d in D} x[n,s,d]
    <= na_Max[cn[n]] + vna_Max[n];

s.t. minAllocations{n in N}:
    sum{s in S, d in D} x[n,s,d]
    >= na_Min[cn[n]] - vna_Min[n];

s.t. maxWeekendsFourWeeks{
    n in N, i in 1..nWE[cn[n]]-3:
    nw4_Max[cn[n]] > 0
}:
    sum{i1 in i..i+3} y[n,i1]
    <= nw4_Max[cn[n]] + vnw4_Max[n,i];

s.t. twoDaysOffAfterNightShift{
    n in N, d in D:
    d <= card(D)-2 and nO[cn[n]] >= 1
}:
    2*sum{s1 in S} isNightS[s1]*x[n,s1,d]
  + sum{s in S, d1 in d+1..d+2} (1-isNightS[s])*x[n,s,d1]
    <= 2 + vno[n,d];

s.t. sameShiftWeekend1{
    n in N, s in S, i in 1..nWE[cn[n]],
    d1 in WE[cn[n],i], d2 in WE[cn[n],i]:
    d1 < d2 and ssw[cn[n]] = 1
}:
    vssw[n,s,i,d1,d2] >= x[n,s,d1]-x[n,s,d2];

s.t. sameShiftWeekend2{
    n in N, s in S, i in 1..nWE[cn[n]],
    d1 in WE[cn[n],i], d2 in WE[cn[n],i]:
    d1 < d2 and ssw[cn[n]] = 1
}:
    vssw[n,s,i,d1,d2] >= x[n,s,d2]-x[n,s,d1];

s.t. noNightShiftBeforeFreeWeekend{
    n in N, s in S, i in 1..nWE[cn[n]]:
    nnsbw[cn[n]] > 0 and min{d in WE[cn[n],i]} d > 1
}:
    isNightS[s]*x[n,s,(min{d in WE[cn[n],i]} d)-1]
  + (1-y[n,i])
    <= 1 + vnnsbw[n,i];

s.t. shiftSequenceViol{
    n in N, i in 1..npit[cn[n]],
    d in 1..card(D)-tpit[cn[n],i]+1
}:
    sum{j in 1..tpit[cn[n],i]}
        x[n,cpit[cn[n],i,j],d+j-1]
    <= tpit[cn[n],i]-1 + vpit[n,i,d];

s.t. daysSequenceViol{n in N, i in 1..npid[cn[n]]}:
    sum{
        s in S, j in 1..tpid[cn[n],i]:
        cpid[cn[n],i,j] >= 1
    } x[n,s,cpid[cn[n],i,j]]
  + sum{
        j in 1..tpid[cn[n],i]:
        cpid[cn[n],i,j] <= -1
    } (1-sum{s in S} x[n,s,abs(cpid[cn[n],i,j])])
    <= tpid[cn[n],i]-1 + vpid[n,i];
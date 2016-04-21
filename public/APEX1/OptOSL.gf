OPTION NLP = minos5  ;
*OPTION LP = BDMLP  ;
OPTION LP = OSL  ;
OPTION MIP = OSL ;
OPTION ITERLIM = 99999 ;
OPTION DOMLIM = 500 ;


model dairy / all / ;
dairy.optfile = 1 ;

*solve dairy using MIP maximizing z ;
solve dairy using LP minimizing z1a ;

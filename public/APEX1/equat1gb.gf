
EQUATIONS
  excessd(ll)    ratio of fed dry matter to dry matter requirement
  dmcalc(ll)  calculation of actual dry matter fed in ration
  minfeed(qq,ll) minimum amount of specific feeds allowable in diet of ll livstock
  maxfeed(qq,ll) maximum amount of specific feeds allowable in diet of ll livestock
  ;


excessd(ll).. (BOUND('nut101',ll)*TOTALDM(ll)) - dmfed(ll) =L= 0 ;

dmcalc(ll).. dmfed(ll) =E= sum(qq, NIF(qq,'nut101')* 
             ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) )  +
             ((1-WASTE2(qq))*pfl(qq,ll)))) ;

minfeed(qq,ll).. MINFD(qq,ll)*dmfed(ll) =L= NIF(qq,'nut101')*
              ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) ) +
              ((1-WASTE2(qq))*pfl(qq,ll))) ;

maxfeed(qq,ll).. MAXFD(qq,ll)*dmfed(ll) =G= NIF(qq,'nut101')*
              ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) ) +
              ((1-WASTE2(qq))*pfl(qq,ll))) ;



EQUATIONS
  feedsale sale of raised feed or forage
  feedcost cost of purchased feed
*  feedset1(qq,ll)
*  feedset2(qq,ll)
  cropu1(qq)   crop use
*  cropu2(qq,ll)   crop use
*  cropu3(qq)   crop use
*  ration1(ww,ll)  ration requirements
*  rationd(ll)  ration requirements
*  excess1(ww,ll)  ratio of fed energy to energy requirement
*  excessd(ll)    ratio of fed dry matter to dry matter requirement
*  dmcalc(ll)  calculation of actual dry matter fed in ration
*  minfeed(qq,ll) minimum amount of specific feeds allowable in diet of ll livstock
*  maxfeed(qq,ll) maximum amount of specific feeds allowable in diet of ll livestock
  ;

*pfl.l(qq,ll) = 100 ;

feedsale.. sum(qq, (((0.950*SPF(qq))-(0.0*SPF(qq)))*cs(qq)) ) =E= z2a ;

feedcost.. z1a =E= 0 ;

*feedset1(qq,ll).. pfl(qq,ll) =L= PFUP(qq,ll)*dmfed(ll) ;

*feedset2(qq,ll).. pfl(qq,ll) =G= PFLP(qq,ll)*dmfed(ll) ;

cropu1(qq).. - OUTPUTA(qq) + cs(qq)  =E= 0 ;

*cropu2(qq,ll).. - OUTPUTB(qq,ll) + cflb(qq,ll)
*             + csl(qq,ll) =E= 0 ;

*cropu3(qq).. extra(qq) =E= sum(ll,csl(qq,ll)) ;

*ration1(ww,ll).. RR(ww,ll)*1*S(ll) =L= sum(qq, NIF(qq,'nut101')*NIF(qq,ww)*
*              ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll))  ) +
*              ((1-WASTE2(qq))*pfl(qq,ll)))) ;

*rationd(ll).. TOTALDM(ll) - dmfed(ll)  =G= 0 ;

*excess1(ww,ll).. BOUND(ww,ll)*1*dmfed(ll) =G= sum(qq, NIF(qq,'nut101')*
*              NIF(qq,ww)*( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) ) +
*              ((1-WASTE2(qq))*pfl(qq,ll)))) ;

*excessd(ll).. (BOUND('nut101',ll)*1*TOTALDM(ll)) - dmfed(ll) =L= 0 ;

*dmcalc(ll).. dmfed(ll) =E= sum(qq, NIF(qq,'nut101')* 
*             ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) )  +
*             ((1-WASTE2(qq))*pfl(qq,ll)))) ;

*minfeed(qq,ll).. MINFD(qq,ll)*1*dmfed(ll) =L= NIF(qq,'nut101')*
*              ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) ) +
*              ((1-WASTE2(qq))*pfl(qq,ll))) ;

*maxfeed(qq,ll).. MAXFD(qq,ll)*1*dmfed(ll) =G= NIF(qq,'nut101')*
*              ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) ) +
*              ((1-WASTE2(qq))*pfl(qq,ll))) ;


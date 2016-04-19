
EQUATIONS
  feedcost cost of purchased feed
  feedset1(qq,ll)
  feedset2(qq,ll)
  cropu1(qq)   crop use
  cropu2(qq,ll)   crop use
  cropu3(qq)   crop use
  ration1(ww,ll)  ration requirements
  rationd(ll)  ration requirements
  excess1(ww,ll)  ratio of fed energy to energy requirement
  ;

feedcost.. sum(qq, (PPF(qq)*sum(ll, pfl(qq,ll))) - SPF(qq)*cs(qq) ) =E= z1a ;

feedset1(qq,ll).. pfl(qq,ll) =L= PFUP(qq,ll) ;

feedset2(qq,ll).. pfl(qq,ll) =G= PFLP(qq,ll) ;

cropu1(qq).. - OUTPUTA(qq) + sum(ll, cfla(qq,ll))
             + cs(qq) - extra(qq) =E= 0 ;

cropu2(qq,ll).. - OUTPUTB(qq,ll) + cflb(qq,ll)
             + csl(qq,ll) =E= 0 ;

cropu3(qq).. extra(qq) =E= sum(ll,csl(qq,ll)) ;

ration1(ww,ll).. RR(ww,ll)*S(ll) =L= sum(qq, NIF(qq,'nut101')*NIF(qq,ww)*
              ( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll))  ) +
              ((1-WASTE2(qq))*pfl(qq,ll)))) ;

rationd(ll).. TOTALDM(ll) - dmfed(ll)  =G= 0 ;

excess1(ww,ll).. BOUND(ww,ll)*1*dmfed(ll) =G= sum(qq, NIF(qq,'nut101')*
              NIF(qq,ww)*( ((1-WASTE1(qq))*(cfla(qq,ll)+cflb(qq,ll)) ) +
              ((1-WASTE2(qq))*pfl(qq,ll)))) ;



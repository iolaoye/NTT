 EQUATIONS
 mintp10(ll) minimum proportions of tp10 feeds
 mintp20(ll) minimum proportions of tp20 feeds
 mintp30(ll) minimum proportions of tp30 feeds
 mintp70(ll) minimum proportions of tp70 feeds
 maxtp10(ll) maximum proportions of tp10 feeds
 maxtp20(ll) maximum proportions of tp20 feeds
 maxtp30(ll) maximum proportions of tp30 feeds
 maxtp70(ll) maximum proportions of tp70 feeds
 ;
 
 mintp10(ll).. mntp10(ll)*dmfed(ll) =L= sum(tp10qq, NIF(tp10qq,'nut101')* 
 ( ((1-WASTE1(tp10qq))*(cfla(tp10qq,ll)+cflb(tp10qq,ll)) ) +
 ((1-WASTE2(tp10qq))*pfl(tp10qq,ll)))) ;
 
 mintp20(ll).. mntp20(ll)*dmfed(ll) =L= sum(tp20qq, NIF(tp20qq,'nut101')* 
 ( ((1-WASTE1(tp20qq))*(cfla(tp20qq,ll)+cflb(tp20qq,ll)) ) +
 ((1-WASTE2(tp20qq))*pfl(tp20qq,ll)))) ;
 
 mintp30(ll).. mntp30(ll)*dmfed(ll) =L= sum(tp30qq, NIF(tp30qq,'nut101')* 
 ( ((1-WASTE1(tp30qq))*(cfla(tp30qq,ll)+cflb(tp30qq,ll)) ) +
 ((1-WASTE2(tp30qq))*pfl(tp30qq,ll)))) ;
 
 mintp70(ll).. mntp70(ll)*dmfed(ll) =L= sum(tp70qq, NIF(tp70qq,'nut101')* 
 ( ((1-WASTE1(tp70qq))*(cfla(tp70qq,ll)+cflb(tp70qq,ll)) ) +
 ((1-WASTE2(tp70qq))*pfl(tp70qq,ll)))) ;
 
 maxtp10(ll).. mxtp10(ll)*dmfed(ll) =G= sum(tp10qq, NIF(tp10qq,'nut101')* 
 ( ((1-WASTE1(tp10qq))*(cfla(tp10qq,ll)+cflb(tp10qq,ll)) ) +
 ((1-WASTE2(tp10qq))*pfl(tp10qq,ll)))) ;
 
 maxtp20(ll).. mxtp20(ll)*dmfed(ll) =G= sum(tp20qq, NIF(tp20qq,'nut101')* 
 ( ((1-WASTE1(tp20qq))*(cfla(tp20qq,ll)+cflb(tp20qq,ll)) ) +
 ((1-WASTE2(tp20qq))*pfl(tp20qq,ll)))) ;
 
 maxtp30(ll).. mxtp30(ll)*dmfed(ll) =G= sum(tp30qq, NIF(tp30qq,'nut101')* 
 ( ((1-WASTE1(tp30qq))*(cfla(tp30qq,ll)+cflb(tp30qq,ll)) ) +
 ((1-WASTE2(tp30qq))*pfl(tp30qq,ll)))) ;
 
 maxtp70(ll).. mxtp70(ll)*dmfed(ll) =G= sum(tp70qq, NIF(tp70qq,'nut101')* 
 ( ((1-WASTE1(tp70qq))*(cfla(tp70qq,ll)+cflb(tp70qq,ll)) ) +
 ((1-WASTE2(tp70qq))*pfl(tp70qq,ll)))) ;
 

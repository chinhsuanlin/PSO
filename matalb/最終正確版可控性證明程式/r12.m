%r2=0及r2=0.5有不同值
%但對應的r1為線性直線
%若要以簡略寫法時
%以r2 = 0所求r1即可
function output =r12(ep2range,temp)
c2r2 = ep2range + max(temp.c20);
r2 = c2r2/temp.c2;
%c2r2 = c20+ep2
%ep2 = c2r2-c20
ep2 = temp.c2*r2-temp.c20;
%ep1*phi1+ep2*phi2<1
%ep1 >(1-(ep2*phi2))/phi1
ep1 = (1-(ep2*temp.phi2))/temp.phi1;
c1r1 = ep1 + temp.c10;
r1 =c1r1 / temp.c1;
output =r1;
end




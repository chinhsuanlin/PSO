%r2=0��r2=0.5�����P��
%��������r1���u�ʪ��u
%�Y�n�H²���g�k��
%�Hr2 = 0�ҨDr1�Y�i
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




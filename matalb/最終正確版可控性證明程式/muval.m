function output =muval(dashM1,dashM2,e)
matrixmu = -(e(1)*dashM1+e(2)*dashM2);
mu=matrixvalue(matrixmu,'matmea','2')
for abbuse =1:1
if e(1)>= 0
    phi1 = matrixvalue(-1*dashM1,'matmea','2')
else 
    phi1 = -matrixvalue(dashM1,'matmea','2')
end
if e(2)>=0
    phi2 = matrixvalue(-1*dashM2,'matmea','2')
else 
    phi2 = -matrixvalue(dashM2,'matmea','2')
end
end
largemu= e(1)*phi1+e(2)*phi2
output = [mu,largemu,phi1,phi2];
end
function [fitness] = fitness_all(Z, fun_num)
xx = Z;
%n = D; %須依實際情況調整
y = 0;
%單峰
if fun_num==1% SPHERE FUNCTION
    d = length(xx);
    temp = 0;
    for ii = 1:d
        xi = xx(ii);
        temp = temp + xi^2;
    end
    y = temp;
%valley-shaped
elseif fun_num==2% ROSENBROCK FUNCTION
    d = length(xx);
    temp = 0;
    for i = 1:(d-1)
        xi = xx(i);
        xnext = xx(i+1);
        new = 100*(xnext-xi^2)^2 + (xi-1)^2;
        temp = temp + new;
    end
    y = temp;
%many locoal
elseif fun_num==3% RASTRIGIN FUNCTION
      d = length(xx);
    temp = 0;
    for ii = 1:d
        xi = xx(ii);
        temp = temp + (xi^2 - 10*cos(2*pi*xi));
    end
    y = 10*d + temp;
%many local 
elseif fun_num==4% GRIEWANK FUNCTION
     d = length(xx);
    temp = 0;
    prod = 1;
    for ii = 1:d
        xi = xx(ii);
        temp = temp + xi^2/4000;
        prod = prod * cos(xi/sqrt(ii));
    end
    y = temp - prod + 1;
%many local
elseif fun_num==5% ACKLEY FUNCTION
     d = length(xx);
    temp1 = 0;
    temp2 = 0;
    for ii = 1:d
        xi = xx(ii);
        temp1 = temp1 + xi^2;
        temp2 = temp2 + cos(2*pi*xi);
    end
    term1 = -20 * exp(-0.2*sqrt(temp1/d));
    term2 = -exp(temp2/d);
    y = term1 + term2 + 20 + exp(1);
elseif fun_num==6% HAPPYCAT FUNCTION
    if nargin < 2 
        alpha = 0.5;       
    end
    alpha = 1/8;
    n = size(xx, 2);
    x2 = sum(xx .* xx, 2);
    y = ((x2 - n).^2).^(alpha) + (0.5*x2 + sum(xx,2))/n + 0.5;
elseif fun_num==7% QING FUNCTION
    n = size(xx, 2);
    x2 = xx.^2;
    y = 0;
    for i = 1:n
        y = y + (x2(:, i) - i) .^ 2;
    end
elseif fun_num==8% SCHWEFEL_2.22 FUNCTION
    absx = abs(xx);
    y = sum(absx, 2) + prod(absx, 2);
%Bowl-Shaped
elseif fun_num==11 % BOHACHEVSKY FUNCTION 1 2D [-100 100] min=0 at (0,0)
    x1 = xx(1);
    x2 = xx(2);
    term1 = x1^2;
    term2 = 2*x2^2;
    term3 = -0.3 * cos(3*pi*x1);
    term4 = -0.4 * cos(4*pi*x2);
    y = term1 + term2 + term3 + term4 + 0.7;
 %Other
elseif fun_num==12 %COLVILLE FUNCTION  4D [-10 10] min=0 at(1,1,1,1)
    x1 = xx(1);
    x2 = xx(2);
    x3 = xx(3);
    x4 = xx(4);
    term1 = 100 * (x1^2-x2)^2;
    term2 = (x1-1)^2;
    term3 = (x3-1)^2;
    term4 = 90 * (x3^2-x4)^2;
    term5 = 10.1 * ((x2-1)^2 + (x4-1)^2);
    term6 = 19.8*(x2-1)*(x4-1);
    y = term1 + term2 + term3 + term4 + term5 + term6;
 %Many Local Minima
 elseif fun_num==13 % DROP-WAVE FUNCTION x[-5.12 5.12] 2D min=-1 at (0,0)
    x1 = xx(1);
    x2 = xx(2);
    frac1 = 1 + cos(12*sqrt(x1^2+x2^2));
    frac2 = 0.5*(x1^2+x2^2) + 2;
    y = -frac1/frac2;
 %Steep Ridges/Drops
 %大部分都是為0的位置，容易卡住
 elseif fun_num==14 % EASOM FUNCTION x[-100 100] 2D min=-1 at (pi,pi)
    x1 = xx(1);
    x2 = xx(2);
    fact1 = -cos(x1)*cos(x2);
    fact2 = exp(-(x1-pi)^2-(x2-pi)^2);
    y = fact1*fact2;
end
fitness = y;

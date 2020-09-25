function [fitness] = fitness_fun2(Z, fun_num)
xx = Z;
%n = D; %須依實際情況調整
y = 0;

if fun_num==1% SPHERE FUNCTION
    d = length(xx);
    sum = 0;
    for ii = 1:d
        xi = xx(ii);
        sum = sum + xi^2;
    end
    y = sum;
elseif fun_num==2% ROSENBROCK FUNCTION
    d = length(xx);
    sum = 0;
    for i = 1:(d-1)
        xi = xx(i);
        xnext = xx(i+1);
        new = 100*(xnext-xi^2)^2 + (xi-1)^2;
        sum = sum + new;
    end
    y = sum;
elseif fun_num==3% RASTRIGIN FUNCTION
      d = length(xx);
    sum = 0;
    for ii = 1:d
        xi = xx(ii);
        sum = sum + (xi^2 - 10*cos(2*pi*xi));
    end
    y = 10*d + sum;
elseif fun_num==4% GRIEWANK FUNCTION
     d = length(xx);
    sum = 0;
    prod = 1;
    for ii = 1:d
        xi = xx(ii);
        sum = sum + xi^2/4000;
        prod = prod * cos(xi/sqrt(ii));
    end
    y = sum - prod + 1;   
elseif fun_num==5% ACKLEY FUNCTION
     d = length(xx);
    sum1 = 0;
    sum2 = 0;
    for ii = 1:d
        xi = xx(ii);
        sum1 = sum1 + xi^2;
        sum2 = sum2 + cos(2*pi*xi);
    end
    term1 = -20 * exp(-0.2*sqrt(sum1/d));
    term2 = -exp(sum2/d);
    y = term1 + term2 + 20 + exp(1);
%elseif fun_num==6         

end
fitness = y;
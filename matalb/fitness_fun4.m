function [fitness] = fitness_fun4(Z, fun_num)
xx = Z;
%n = D; %須依實際情況調整
y = 0;
if fun_num==6% HAPPYCAT FUNCTION
    if nargin < 2 
        alpha = 0.5;       
    end
    alpha = 1/8;
    n = size(xx, 2);
    x2 = sum(xx .* xx, 2);
    y = ((x2 - n).^2).^(alpha) + (0.5*x2 + sum(xx,2))/n + 0.5;
elseif fun_num==7% QUING FUNCTION
    n = size(xx, 2);
    x2 = xx .^2;
    
    y = 0;
    for i = 1:n
        y = y + (x2(:, i) - i) .^ 2;
    end
elseif fun_num==8% SCHWEFEL_2.22 FUNCTION
    absx = abs(xx);
    y = sum(absx, 2) + prod(absx, 2);

end
fitness = y;
%3個case 3個維度
function output=matrixvalue(matrix,normcase,dim)
    A=matrix;
    switch normcase            
        case {'inmatnorm'}%induced matrix norm歸納矩陣範數
            switch dim
                case {'1'}
                    output = norm(A,1);
                case {'2'}
                    output = norm(A,2);
                case {'inf'}
                    output = norm(A,inf);
            end
         
        case {'matnorm'}%matrix norm矩陣範數
            A=abs(A(:));
            switch dim
                case {'1'}
                    output = sum(A);
                case {'2'}
                    output = sqrt(sum(A.^2));
                case {'inf'}
                    output = max(A);
            end
            
        case {'matmea'}%matrix measure 矩陣測度
            matsize = length(A);%矩陣大小    
            switch dim
               case {'1'}
                 x=zeros(1,matsize);
                   for k=1:matsize
                      temp = A(:,k);
                      temp(k) = [];
                      x(k) = real(A(k,k))+sum(abs(temp));
                       output = max(x);
                   end
                case {'2'}
                    output = max((eig(A+A'))/2);
                case {'inf'}
                    x=zeros(1,matsize);
                   for k=1:matsize
                      temp = A(k,:);
                      temp(k) = [];
                      x(k) = real(A(k,k))+sum(abs(temp));
                       output = max(x);
                   end     
            end
      end 
end
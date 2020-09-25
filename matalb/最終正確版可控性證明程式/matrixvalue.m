%3��case 3�Ӻ���
function output=matrixvalue(matrix,normcase,dim)
    A=matrix;
    switch normcase            
        case {'inmatnorm'}%induced matrix norm�k�ǯx�}�d��
            switch dim
                case {'1'}
                    output = norm(A,1);
                case {'2'}
                    output = norm(A,2);
                case {'inf'}
                    output = norm(A,inf);
            end
         
        case {'matnorm'}%matrix norm�x�}�d��
            A=abs(A(:));
            switch dim
                case {'1'}
                    output = sum(A);
                case {'2'}
                    output = sqrt(sum(A.^2));
                case {'inf'}
                    output = max(A);
            end
            
        case {'matmea'}%matrix measure �x�}����
            matsize = length(A);%�x�}�j�p    
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
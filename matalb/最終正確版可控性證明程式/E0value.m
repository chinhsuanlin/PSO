function output = E0value(size,matrix)
n_zemat = zeros(size.n);
zebmat = zeros(size.n,size.m);
A=matrix.AI0;
B=matrix.BI0;
EAI = cell(size.n,size.AIcol);
EB = cell(size.n,size.Bcol);
%�N�s�x�}��J����}�C
%�]�s�x�}�j�p���P�A�ݤ��}�B�z
%%
%A�PI�`�pn�C n-1��
for i=1:size.n
    for j =1 :size.AIcol
        EAI{i,j} = n_zemat; 
    end
end
%%�N���x�}��J����}�C
for i= 1:size.n-1
    EAI{i,i} = eye(size.n);
end
for i= 1:size.n-1
    EAI{i+1,i} = -A;    
end
output1 = cell2mat(EAI);
%%
%B�`�pn�Cm��
for i=1:size.n
    for j =1 :size.Bcol
        EB{i,j} = zebmat; 
    end
end
%%�N���x�}��J����}�C
for i= 1:size.Bcol
    EB{i,size.Bcol-i+1} = B;
end
output2 = cell2mat(EB);
%�X��E
output = cat(2,output1,output2);
end
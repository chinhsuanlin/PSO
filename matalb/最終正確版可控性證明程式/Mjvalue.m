function output = Mjvalue(size,Aj,Bj)
zebmat = zeros(size.n,size.m);
n_zemat = zeros(size.n);
A=Aj;
B=Bj;
EAI = cell(size.n,size.AIcol);
EB = cell(size.n,size.Bcol);
%將零矩陣放入異質陣列
%因零矩陣大小不同，需分開處理
%%
%A與I總計n列 n-1行
for i=1:size.n
    for j =1 :size.AIcol
        EAI{i,j} = n_zemat; 
    end
end
for i= 1:size.n-1
    EAI{i+1,i} = -A;    
end
output1 = cell2mat(EAI);
%%
%B總計n列m行
for i=1:size.n
    for j =1 :size.Bcol
        EB{i,j} = zebmat; 
    end
end
for i= 1:size.Bcol
    EB{i,size.Bcol-i+1} = B;
end
%%將單位矩陣放入異質陣列
output2 = cell2mat(EB);
%合併E
output = cat(2,output1,output2);
end
%維度D、位置限制XMAXMIN、實驗次數REP_NO、代數ITERMAX、幾群S、C1C2、fun
clc;close all;clear;
for datafun= 1:5
    for dataD =1:4

switch datafun
    case 1
        data.fun = 1;
        fun = 'SPHERE'
        data.XMAX = 100;
        data.XMIN = -100;
    case 2
        data.fun = 2;
        fun = 'ROSENBROCK'
        data.XMAX = 30;
        data.XMIN = -30;
    case 3
        data.fun = 3;
        fun = 'RASTRIGIN'
        data.XMAX = 5.12;
        data.XMIN = -5.12;
    case 4
        data.fun = 4;
        fun = 'GRIEWANK'
        data.XMAX = 600;
        data.XMIN = -600;
    case 5
        data.fun = 5;
        fun = 'ACKLEY'
        data.XMAX = 32;
        data.XMIN = -32;        
end
switch dataD
    case 1
        data.D = 10;
        data.ITERMAX = 120000;
    case 2
        data.D = 20;
        data.ITERMAX = 160000;
    case 3
        data.D = 30;
        data.ITERMAX = 200000;
    case 4
        data.D = 100;
        data.ITERMAX = 300000;
end   
    
tic;
data.REP_NO = 3;
data.S = 40;
%data.D = 30;
%data.ITERMAX = 200000;
%data.XMAX = 5.12;
%data.XMIN = -5.12;
%data.fun = 5;
data.C1MAX = 2;
data.C2MAX = 2;
bestFPSOvalue = ones(1,data.REP_NO);
bestCPSOvalue = ones(1,data.REP_NO);
iterfpsonum = ones(1,data.REP_NO);
itercpsonum = ones(1,data.REP_NO);
bestoriFPSOvalue = ones(1,data.REP_NO);
iterorifpsonum = ones(1,data.REP_NO);
% switch data.fun
%     case 5
%         fun = 'RASTRIGIN'
%     case 6
%         fun = 'SPHERE'
%     case 7
%         fun = 'ACKLEY'
%     case 8
%         fun ='ROSENBROCK'
%     case 9
%         fun ='GRIEWANK'
%     
% end
%{
    5 % RASTRIGIN FUNCTION
    6 % SPHERE FUNCTION
    7 % ACKLEY FUNCTION
    8 % ROSENBROCK FUNCTION
    9 % GRIEWANK FUNCTION
    10 % Schwefel 2.22
    15 % schwefel P1.2
%}
%判斷最好的數據圖
%先判斷是不是最佳值在判斷迭代數有沒有比較小，若有則取代
for REPT = 1: data.REP_NO
    disp(strcat('REPT=',num2str(REPT)));
    for I =1:data.S
    data.sameX_C{I} = unifrnd(data.XMIN,data.XMAX,1,data.D);
    end
    data_all_initial_position{REPT} = data.sameX_C;%紀錄所有初始位置
%%%%%%%%
outfpso = funfpso(data);
bestFPSOvalue(REPT) = min(outfpso.best_v) ;
iterfpsonum(REPT) =outfpso.iternum;
if (REPT==1)
    bestfpsofigvalue = outfpso.best_v(end);             %計算第1代中最小值
    bestfpsofig = outfpso.best_v;                       %獲得最小值之圖形
    bestfpsonum = outfpso.iternum;                      %獲得最小值之圖形的代數
    bestfpsoposition = outfpso.position;                %獲得最小值之當下位置
else
    if(bestFPSOvalue(REPT)) <= bestfpsofigvalue         %如果第REPT代最小值比目前還好
        if(iterfpsonum(REPT) < bestfpsonum)             %如果第REPT獲得最小值時的代數比目前好
            bestfpsofig = outfpso.best_v;               %取代最小值之圖形
            bestfpsonum = outfpso.iternum;              %取代代數
            bestfpsoposition = outfpso.position;        %取代位置
        end
    end
end
%%%%%%%%%%
outcpso = funcpso(data);
bestCPSOvalue(REPT) = min(outcpso.best_v) ;
itercpsonum(REPT) =outcpso.iternum;
if (REPT==1)
    bestcpsofigvalue = outcpso.best_v(end);
    bestcpsofig = outcpso.best_v;
    bestcpsonum = outcpso.iternum;
    bestcpsoposition = outcpso.position;
else
    if(bestCPSOvalue(REPT)) <= bestcpsofigvalue
        if(itercpsonum(REPT) < bestcpsonum)
            bestcpsofig = outcpso.best_v;
            bestcpsonum = outcpso.iternum;
            bestcpsoposition = outcpso.position;
        end
    end
end
%%%%%%%%%%
outorifpso = funorifpso(data);
bestoriFPSOvalue(REPT) = min(outorifpso.best_v) ;
iterorifpsonum(REPT) =outorifpso.iternum;
if (REPT==1)
    bestorifpsofigvalue = outorifpso.best_v(end);             %計算第1代中最小值
    bestorifpsofig = outorifpso.best_v;                       %獲得最小值之圖形
    bestorifpsonum = outorifpso.iternum;                      %獲得最小值之圖形的代數
    bestorifpsoposition = outorifpso.position;                %獲得最小值之當下位置
else
    if(bestoriFPSOvalue(REPT)) <= bestorifpsofigvalue         %如果第REPT代最小值比目前還好
        if(iterorifpsonum(REPT) < bestorifpsonum)             %如果第REPT獲得最小值時的代數比目前好
            bestorifpsofig = outorifpso.best_v;               %取代最小值之圖形
            bestorifpsonum = outorifpso.iternum;              %取代代數
            bestorifpsoposition = outorifpso.position;        %取代位置
        end
    end
end
%%%%%%%%%
end
%開啟最後實驗的cost圖

semilogy(bestfpsofig),title(strcat('CFPSO ',fun,' D=',num2str(data.D)));
FPSOFILEPICNAME = strcat('CFPSO ',fun,' D=',num2str(data.D),'.fig');
saveas(gcf,FPSOFILEPICNAME);

figure;
semilogy(bestcpsofig),title(strcat('CPSO ',fun,' D=',num2str(data.D)));
CPSOFILEPICNAME = strcat('CPSO ',fun,' D=',num2str(data.D),'.fig');
saveas(gcf,CPSOFILEPICNAME);

figure;
semilogy(bestorifpsofig),title(strcat('ORIFPSO ',fun,' D=',num2str(data.D)));
ORIFPSOFILEPICNAME = strcat('ORIFPSO ',fun,' D=',num2str(data.D),'.fig');
saveas(gcf,ORIFPSOFILEPICNAME);

%%%%
BS_FPSOMEAN = mean(bestFPSOvalue)
BS_FPSOMIN = min(bestFPSOvalue)
BS_FPSOSTD = std(bestFPSOvalue)
BS_FPSOITER = mean(iterfpsonum)
BS_FPSOITERMIN = bestfpsonum
BS_FPSOPOSITION = bestfpsoposition;
%%%%
BS_CPSOMEAN = mean(bestCPSOvalue)
BS_CPSOMIN = min(bestCPSOvalue)
BS_CPSOSTD = std(bestCPSOvalue)
BS_CPSOITER = mean(itercpsonum)
BS_CPSOITERMIN = bestcpsonum
BS_CPSOPOSITION = bestcpsoposition;
%%%%
BS_ORIFPSOMEAN = mean(bestoriFPSOvalue)
BS_ORIFPSOMIN = min(bestoriFPSOvalue)
BS_ORIFPSOSTD = std(bestoriFPSOvalue)
BS_ORIFPSOITER = mean(iterorifpsonum)
BS_ORIFPSOITERMIN = bestorifpsonum
BS_ORIFPSOPOSITION = bestorifpsoposition;
%%%%
BS_FPSOALL = [BS_FPSOMEAN BS_FPSOMIN BS_FPSOSTD]
BS_CPSOALL = [BS_CPSOMEAN BS_CPSOMIN BS_CPSOSTD]
BS_ORIFPSOALL = [BS_ORIFPSOMEAN BS_ORIFPSOMIN BS_ORIFPSOSTD]
save(strcat('data_all_initial_position',fun,' D=',num2str(data.D),'.mat'),'data_all_initial_position');
save(strcat(fun,' D=',num2str(data.D),'.mat'));
toc;
close all;
    end
end

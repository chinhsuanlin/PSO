%����D�B��m����XMAXMIN�B���禸��REP_NO�B�N��ITERMAX�B�X�sS�BC1C2�Bfun
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
%�P�_�̦n���ƾڹ�
%���P�_�O���O�̨έȦb�P�_���N�Ʀ��S������p�A�Y���h���N
for REPT = 1: data.REP_NO
    disp(strcat('REPT=',num2str(REPT)));
    for I =1:data.S
    data.sameX_C{I} = unifrnd(data.XMIN,data.XMAX,1,data.D);
    end
    data_all_initial_position{REPT} = data.sameX_C;%�����Ҧ���l��m
%%%%%%%%
outfpso = funfpso(data);
bestFPSOvalue(REPT) = min(outfpso.best_v) ;
iterfpsonum(REPT) =outfpso.iternum;
if (REPT==1)
    bestfpsofigvalue = outfpso.best_v(end);             %�p���1�N���̤p��
    bestfpsofig = outfpso.best_v;                       %��o�̤p�Ȥ��ϧ�
    bestfpsonum = outfpso.iternum;                      %��o�̤p�Ȥ��ϧΪ��N��
    bestfpsoposition = outfpso.position;                %��o�̤p�Ȥ���U��m
else
    if(bestFPSOvalue(REPT)) <= bestfpsofigvalue         %�p�G��REPT�N�̤p�Ȥ�ثe�٦n
        if(iterfpsonum(REPT) < bestfpsonum)             %�p�G��REPT��o�̤p�Ȯɪ��N�Ƥ�ثe�n
            bestfpsofig = outfpso.best_v;               %���N�̤p�Ȥ��ϧ�
            bestfpsonum = outfpso.iternum;              %���N�N��
            bestfpsoposition = outfpso.position;        %���N��m
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
    bestorifpsofigvalue = outorifpso.best_v(end);             %�p���1�N���̤p��
    bestorifpsofig = outorifpso.best_v;                       %��o�̤p�Ȥ��ϧ�
    bestorifpsonum = outorifpso.iternum;                      %��o�̤p�Ȥ��ϧΪ��N��
    bestorifpsoposition = outorifpso.position;                %��o�̤p�Ȥ���U��m
else
    if(bestoriFPSOvalue(REPT)) <= bestorifpsofigvalue         %�p�G��REPT�N�̤p�Ȥ�ثe�٦n
        if(iterorifpsonum(REPT) < bestorifpsonum)             %�p�G��REPT��o�̤p�Ȯɪ��N�Ƥ�ثe�n
            bestorifpsofig = outorifpso.best_v;               %���N�̤p�Ȥ��ϧ�
            bestorifpsonum = outorifpso.iternum;              %���N�N��
            bestorifpsoposition = outorifpso.position;        %���N��m
        end
    end
end
%%%%%%%%%
end
%�}�ҳ̫���窺cost��

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

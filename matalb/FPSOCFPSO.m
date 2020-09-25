%����D�B��m����XMAXMIN�B���禸��REP_NO�B�N��ITERMAX�B�X�sS�BC1C2�Bfun
clc;close all;clear;
tic;
%%�n�]���ƾ�
for datafun= 1:8
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
            case 6
                data.fun =6;
                fun = 'HAPPYCAT'
                data.XMAX = 2;
                data.XMIN = -2;
            case 7
                data.fun = 7;
                fun = 'QING'
                data.XMAX = 500;
                data.XMIN = -500
            case 8 
                data.fun = 8;
                fun = 'SCHWEFEL_2.22'
                data.XMAX = 100;
                data.XMIN = -100;
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
%%��l�ѼƳ]�m
data.S = 40;%�ڸs
data.ITERMAX = data.ITERMAX/data.S;%���N��
data.REP_NO = 30;%�W�߹����
data.C1MAX = 2;
data.C2MAX = 2;
data.Wflag = '2';
%%��l�Ŷ��]�m
bestFPSOvalue = ones(1,data.REP_NO);
iterfpsonum = ones(1,data.REP_NO);

bestCPSOvalue = ones(1,data.REP_NO);
itercpsonum = ones(1,data.REP_NO);


bestPSOvalue = ones(1,data.REP_NO);
iterpsonum = ones(1,data.REP_NO);

bestoriFPSOvalue = ones(1,data.REP_NO);
iterorifpsonum = ones(1,data.REP_NO);
%%��l��m�]�m
for REPT = 1: data.REP_NO
    disp(strcat('REPT=',num2str(REPT)));
    for I =1:data.S
        data.sameX_C{I} = unifrnd(data.XMIN,data.XMAX,1,data.D);%keep same position
    end
    data_all_initial_position{REPT} = data.sameX_C;%�����Ҧ���l��m
    %%%%%%%%%%%%%CFPSO �{�ǳ]�m
    L = 0.3;A = 1; B = 1;R=1;
    data.BESTUNI = [L A B R];
    data.method = 'CFPSO'
    outfpso = funallkindpso(data);
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
    %%%%%%%%%��lFPSO
    L = 0.3;A = 1; B = 1; R=1;
    data.BESTUNI = [L A B R];
    data.method = 'ORIFPSO'
    outorifpso = funallkindpso(data);
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
   %%%%%%%% 
end
%�}�ҳ̫���窺cost��
semilogy(bestfpsofig),title(strcat('CFPSO ',fun,' D=',num2str(data.D)));
FPSOFILEPICNAME = strcat('CFPSO ',fun,' D=',num2str(data.D),'.fig');
saveas(gcf,FPSOFILEPICNAME);

figure;
semilogy(bestorifpsofig),title(strcat('ORIFPSO ',fun,' D=',num2str(data.D)));
ORIFPSOFILEPICNAME = strcat('ORIFPSO ',fun,' D=',num2str(data.D),'.fig');
saveas(gcf,ORIFPSOFILEPICNAME);
%%%�p��
BS_FPSOMEAN = mean(bestFPSOvalue);
BS_FPSOMIN = min(bestFPSOvalue);
BS_FPSOSTD = std(bestFPSOvalue);
BS_FPSOITER = mean(iterfpsonum);
BS_FPSOITERMIN = bestfpsonum;
BS_FPSOPOSITION = bestfpsoposition;
%%%%
BS_ORIFPSOMEAN = mean(bestoriFPSOvalue);
BS_ORIFPSOMIN = min(bestoriFPSOvalue);
BS_ORIFPSOSTD = std(bestoriFPSOvalue);
BS_ORIFPSOITER = mean(iterorifpsonum);
BS_ORIFPSOITERMIN = bestorifpsonum;
BS_ORIFPSOPOSITION = bestorifpsoposition;
%%%%
BS_FPSOALL = [BS_FPSOMEAN BS_FPSOMIN BS_FPSOSTD]
BS_ORIFPSOALL = [BS_ORIFPSOMEAN BS_ORIFPSOMIN BS_ORIFPSOSTD]
%%%%
save(strcat(fun,' D=',num2str(data.D),'.mat'));
save(strcat('data_all_initial_position_',datestr(now,1),fun,' D=',num2str(data.D),'.mat'),'data_all_initial_position');

toc;
close all
    end
end

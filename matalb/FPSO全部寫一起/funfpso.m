%% This is for finding duplicated optimal value by using the best parameter from OP
% UPDATAE BY PO YUAN YANG - KAO TECH 2018
% ORIGINAL FROM PSO NIMA PEDRAMASL - MIDDLE EAST TECHNICAL UNIVERSITY 2015
% FRACTINOAL ORDER PARTICLE SWARM OPTIMIZATION (FPSO)
function out = funfpso(data)
%clear;clc;close;
%% 把计砞﹚ PSO PARAMETERS WITH THEIR USUAL RANGE USED IN LITERATURE
BESTUNI = [0.3 1 1 1]; %Аっ砞璸程ㄎ
L=BESTUNI(1);A=BESTUNI(2);B=BESTUNI(3);R=BESTUNI(4);
%L= lambda %A = alpha %B = beta %R = gamma
S = data.S; % 采竤
D = data.D; % 蝴 跑计计秖
ITERMAX = data.ITERMAX; % 程
XMAX =  data.XMAX; % 竚程
XMIN = data.XMIN;% 竚程

OBJ = @(x) fitness_fun2(x,data.fun); % ヘ夹よ祘
%{
    6 sphere
    7 ackley
    8 ROSENBROCK
    9 GRIEWANK
 %}

% OBJ = @(x) IIR_fitness_f3_all_1 (x); % ヘ夹よ祘
C1MAX = data.C1MAX; % 砰厩策把计 [0-4]
C1MIN = 0; % 砰厩策把计 [0-4]
C2MAX = data.C2MAX; % 竤砰厩策把计 [0-4]
C2MIN = 0; % 竤砰厩策把计 [0-4]
WMAX = 0.9; % 舦 [0-1]
WMIN = 0.4; % 舦 [0-1]
X_C = cell(1,S); % 讽玡采竚
X_1 = cell(1,S); % 玡采竚
X_2 = cell(1,S); % 玡采竚
X_3 = cell(1,S); % 玡采竚
OBJX = zeros(1,S); % 采そΑ┮璸衡
V = cell(1,S); % 采硉
DT = 1; % TIME STEP ˙ !づ笆赣!
% BEST_V = zeros(1,REP_NO);
BEST_V = 99999;
VMAX_LMT = XMAX - XMIN; % VELOCITY LIMIT
VMIN_LMT = -VMAX_LMT;
BESTGB = zeros(1,D);
%%跋遏
r1temp = 0.208743;%lambdar1程
GBVITER = zeros(1,ITERMAX);
%% ﹍て PSO INITIALIZE PARTICLES POSITION AND VELOCITIES
% while BEST_V > 6.48
    PB = cell(1,S);         % 砰程ㄎ竚
    PBV = ones(1,S)*1E50;   % 砰程ㄎ
    GBV = 1E50;             % 竤砰程ㄎ
    GB = zeros(1,D);        % 竤砰程ㄎ竚
    ITER = 0; % 讽玡
    for I = 1:S
        X_C{I} = data.sameX_C{I};
        %X_C{I} = unifrnd(XMIN,XMAX,1,D);%﹍繦诀ネΘ
        X_1{I} = zeros(1,D);
        X_2{I} = zeros(1,D);
        X_3{I} = zeros(1,D);
        V{I} = X_C{I}/DT;
    end
      %% 瑈祘 PSO MAIN LOOP
    while ITER < ITERMAX
        ITER = ITER + 1;
        %ネΘ﹍竚
        for I = 1:S
            OBJX(I) = OBJ(X_C{I});
            %碝т程ㄎ竚
            if OBJX(I) < PBV(I) % FINDING BEST LOCAL
                PB{I} = X_C{I};%砰程ㄎ竚
                PBV(I) = OBJX(I);%砰程ㄎ
            end
        end
        %碝т办程ㄎ竚
        if min(OBJX) < GBV % FINDING BEST GLOBAL
            GB = X_C{OBJX == min(OBJX)};
            GBV = min(OBJX);
        end
        %–计い程ㄎ

        W = WMIN + ((ITERMAX-ITER)/ITERMAX)^A*(WMAX-WMIN); %Aボalfa
        C1 = C1MAX;       
        C2 = C2MAX;
        %C1 = C1MIN + ((ITERMAX-ITER)/ITERMAX)^B*(C1MAX-C1MIN); %Bボbeta
        %C2 = C2MAX + ((ITERMAX-ITER)/ITERMAX)^R*(C2MIN-C2MAX); %Rボgama
        for I = 1:S % PARTICLE POSITION UPDATE
              R1 = rand(); % random number [0-1]
              R1 =  r1temp+((R1-0)/(1-0))*(1-r1temp);   %タ砏て
              R2 = rand(); % random number [0-1]
            V{I} = W*V{I}+C1*R1*(PB{I}-L*X_C{I}-(L/2)*(1-L)*X_1{I}-(L/6)*(1-L)*(2-L)*X_2{I}+(L/24)*(1-L)*(2-L)*(3-L)*X_3{I})/DT+C2*R2*(GB-X_C{I})/DT; % PARTICLE VELOCITY UPDATE % LボLamda
            if V{I}>VMAX_LMT
                [VALUE_V, INDEX_V] = find(V{I}>VMAX_LMT);
                V{I}(INDEX_V)=VMAX_LMT;
            end
            if V{I}<VMIN_LMT
                [VALUE_V, INDEX_V] = find(V{I}<VMIN_LMT);
                V{I}(INDEX_V)=VMIN_LMT;
            end            
            X_3{:,I} = X_2{:,I};
            X_2{:,I} = X_1{:,I};
            X_1{:,I} = X_C{:,I};
            
            if max(X_1{I})>XMAX
                [VALUE_X, INDEX_X] = find(X_1{I}>XMAX);
                X_1{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            if min(X_1{I})<XMIN
                [VALUE_X, INDEX_X] = find(X_1{I}<XMIN);
                X_1{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            
            X_C{I} = X_C{I}+V{I}*DT; % PARTICLE POSITION UPDATE
            
            if max(X_C{I})>XMAX
                [VALUE_X, INDEX_X] = find(X_C{I}>XMAX);
                X_C{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            if min(X_C{I})<XMIN
                [VALUE_X, INDEX_X] = find(X_C{I}<XMIN);
                X_C{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
                
            end
        end
    GBVITER(ITER) = GBV;
    POSITION = GB;
    %魁ㄧ计0
    if(GBV ==0)
        ITERNUM = ITER;
        break;
    else
        ITERNUM =ITERMAX;
    end   
    end
 %   best_v(REPT) = GBV;
   % BEST_V(REPT) = GBV; % 竤砰程ㄎ倒ぉ–Ω龟喷程ㄎ
%     BFR_BEST_V = BEST_V;
%     BFR_BESTGB = BESTGB;
%     BEST_V = GBV;
%     BESTGB = GB;    % 竤砰程ㄎ竚
%     disp(['材',num2str(REPT),'ΩBEST PARTICLE VALUE >> ' num2str(BEST_V)]);
%     if BFR_BEST_V < BEST_V
%         BEST_V = BFR_BEST_V;
%         BESTGB = BFR_BESTGB;
%     end

out.best_v =  GBVITER;
out.iternum = ITERNUM;
out.position = POSITION;

%  out.BS_M=mean(best_v);%キА
%  out.BS_S=std(best_v);%夹非畉
%  out.BS_MAX=max(best_v);
%  out.BS_MIN=min(best_v);%程
%  out.BS_ALL = [out.BS_M out.BS_MIN out.BS_S];
%BS_ALL=[BS_M, BS_S, BS_MAX, BS_MIN]
% disp(['BEST PARTICLE VALUE - MEAN >> ' num2str(BS_M)]); 
% disp(['BEST PARTICLE VALUE - STD >> ' num2str(BS_S)]); 
% disp(['BEST PARTICLE VALUE - MAX >> ' num2str(BS_MAX)]); 
% disp(['BEST PARTICLE VALUE - MIN >> ' num2str(BS_MIN)]);

%semilogy(GBVITER);title('xx')

% disp(['┮Τ龟喷いBEST VALUE >> ' num2str(BEST_V)]);
% disp(['┮Τ龟喷BEST PARTICLE POSITION >> ' num2str(BESTGB)]);

end
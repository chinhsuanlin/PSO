function out = funallkindpso(data)

%% 參數設定 PSO PARAMETERS WITH THEIR USUAL RANGE USED IN LITERATURE
%CPSO CFPSO改變區域
BESTUNI = data.BESTUNI;
%BESTUNI = [0.3 1 1 1]; %均勻設計最佳值
L=BESTUNI(1);A=BESTUNI(2);B=BESTUNI(3);R=BESTUNI(4);
%L= lambda %A = alpha %B = beta %R = gamma
S = data.S; % 粒子群大小
D = data.D; % 維度 變數數量
ITERMAX = data.ITERMAX; % 迭代最大值
XMAX =  data.XMAX; % 位置最大值
XMIN = data.XMIN;% 位置最小值

OBJ = @(x) fitness_all(x,data.fun); % 目標方程
if data.fun ==8
    OBJ = @(x) fitness_fun4(x,data.fun); % 目標方程
end

C1MAX = data.C1MAX; % 個體學習參數 [0-4]
C1MIN = 0; % 個體學習參數 [0-4]
C2MAX = data.C2MAX; % 群體學習參數 [0-4]
C2MIN = 0; % 群體學習參數 [0-4]
WMAX = 0.9; % 權重 [0-1]
WMIN = 0.4; % 權重 [0-1]

X_C = cell(1,S); % 當前的粒子位置
X_1 = cell(1,S); % 前一個粒子位置
X_2 = cell(1,S); % 前二個粒子位置
X_3 = cell(1,S); % 前三個粒子位置
OBJX = zeros(1,S); % 粒子代入公式後所計算出的值
V = cell(1,S); % 粒子速度
DT = 1; % TIME STEP 時步 !勿動該值!
% BEST_V = zeros(1,REP_NO);
BEST_V = 99999;
VMAX_LMT = XMAX - XMIN; % VELOCITY LIMIT
VMIN_LMT = -VMAX_LMT;
BESTGB = zeros(1,D);
%%多加區塊
%CPSO CFPSO 改變區域
orifpsoflg = 0;
method=data.method;
switch method
    case 'PSO'
        r1temp = 0;
        ifpso = 1;
        oripsoflg = 1;
    case 'CPSO'
        r1temp = 0.267945;%lambda值時r1最低限制
        ifpso = 1;
        oripsoflg = 0;
    case 'ORIFPSO'
        r1temp = 0;
        ifpso = 0;
        orifpsoflg = 1;
    case 'CFPSO'
        r1temp = 0.208743;%lambda值時r1最低限制
        ifpso = 0;
        orifpsoflg = 0;
end
GBVITER = zeros(1,ITERMAX);
TEMP_OBJX = cell(1,S);
croflag_count=0;
Wvalue = zeros(1,ITERMAX);
Wflag = data.Wflag;
%% 初始化 PSO INITIALIZE PARTICLES POSITION AND VELOCITIES
% while BEST_V > 6.48
    PB = cell(1,S);         % 個體最佳位置
    PBV = ones(1,S)*1E200;   % 個體最佳值
    GBV = 1E50;             % 群體最佳值
    GB = zeros(1,D);        % 群體最佳位置
    ITER = 0; % 當前迭代值
    for I = 1:S
        X_C{I} = data.sameX_C{I};
        %X_C{I} = unifrnd(XMIN,XMAX,1,D);%原始隨機生成
        X_1{I} = zeros(1,D);
        X_2{I} = zeros(1,D);
        X_3{I} = zeros(1,D);
        V{I} = X_C{I}/DT;
    end
      %% 主流程 PSO MAIN LOOP
    while ITER < ITERMAX
        ITER = ITER + 1;
        %生成初始位置
        for I = 1:S
            OBJX(I) = OBJ(X_C{I});
            %尋找最佳位置
            if OBJX(I) < PBV(I) % FINDING BEST LOCAL
                PB{I} = X_C{I};%個體最佳位置
                PBV(I) = OBJX(I);%個體最佳值
            end
        end
        %尋找全域最佳位置
        if min(OBJX) < GBV % FINDING BEST GLOBAL
            GB = X_C{OBJX == min(OBJX)};
            GBV = min(OBJX);
        end
        %每迭代數中最佳值
        TEMP_OBJX{ITER}=OBJX;
        
        %可控性區域
        croflag=0;
        if ITER >1
            croflag=1;
            for I = 1:S
                flg = abs(TEMP_OBJX{ITER}(I)-TEMP_OBJX{ITER-1}(I)) <10^-4; %epbest
                croflag=croflag * flg ; 
                if croflag==1
                    croflag_count =croflag_count+1;
                end
            end
        end
        %W遞減區域
        switch Wflag
            case '1'
              W = W*WDAMP;    %每迭代1次後慣性權重下降
              Wvalue(ITER) = W;
            case '2'
              W = WMIN + ((ITERMAX-ITER)/ITERMAX)^A*(WMAX-WMIN); %A表示alfa
              Wvalue(ITER) = W;
            case '3'
              if ITER<MaxIt*wtimes
                  W = W;
              else
                  W = WMIN + ((ITERMAX-ITER)/ (ITERMAX-ITERMAX*Wtimes)^A)*(WMAX-WMIN); %A表示alfa
                  %w = wmin+(((MaxIt-it)/(MaxIt-MaxIt*wtimes))^walpha)*(wmax-wmin);%要同減wtimes修正
              end
              Wvalue(ITER) = W;
        end
        %W = WMIN + ((ITERMAX-ITER)/ITERMAX)^A*(WMAX-WMIN); %A表示alfa
        %C1、C2區域
        C1 = C1MAX;       
        C2 = C2MAX;
        %C1 = C1MIN + ((ITERMAX-ITER)/ITERMAX)^B*(C1MAX-C1MIN); %B表示beta
        %C2 = C2MAX + ((ITERMAX-ITER)/ITERMAX)^R*(C2MIN-C2MAX); %R表示gama
        
        for I = 1:S % PARTICLE POSITION UPDATE
            R2 = rand(); % random number [0-1]
            if croflag ==1
                R1 = rand(1,1);
                if ifpso == 1
                    %R1 = rand(); % random number [0-1]
                    R1 =  r1temp+((R1-0)/(1-0))*(1-r1temp);   %正規化
                else
                    if R1 < 0.20874
                      %R2 = -0.7612666 * R1 + 0.158952;
                      R2_ = -0.7612666 * R1 + 0.158952;
                      if R2 < R2_ 
                            R2 = R2_;
                     end       
                    end
                end
            else
                R1=rand();
            end
%             if croflag ==1
%                 R1 = rand(); % random number [0-1]
%                 R1 =  r1temp+((R1-0)/(1-0))*(1-r1temp);   %正規化
%             else
%                 R1 =rand();
%             end
            
            if orifpsoflg ==1
                L = 0.3;%unifrnd(0,2)
            end
            %速度更新區塊 PSO、FPSO
            if ifpso == 1
                if oripsoflg ==1
                    V{I} = W*V{I}+C1*R1*(PB{I}-X_C{I})/DT+C2*R2*(GB-X_C{I})/DT;
                else   
                    V{I} = W*V{I}+C1*R1*(PB{I}-X_C{I})/DT+C2*R2*(GB-X_C{I})/DT; % PARTICLE VELOCITY UPDATE % L表示Lamda
                end
            else
                if orifpsoflg == 1
                    V{I} = 0.2*V{I}+C1*R1*(PB{I}-L*X_C{I}-(L/2)*(1-L)*X_1{I}-(L/6)*(1-L)*(2-L)*X_2{I}+(L/24)*(1-L)*(2-L)*(3-L)*X_3{I})/DT+C2*R2*(GB-X_C{I})/DT;
                else
                    V{I} = W*V{I}+C1*R1*(PB{I}-L*X_C{I}-(L/2)*(1-L)*X_1{I}-(L/6)*(1-L)*(2-L)*X_2{I}+(L/24)*(1-L)*(2-L)*(3-L)*X_3{I})/DT+C2*R2*(GB-X_C{I})/DT; % PARTICLE VELOCITY UPDATE % L表示Lamda
                end
            end
            
            %速度界線區塊
            if V{I}>VMAX_LMT
                [VALUE_V, INDEX_V] = find(V{I}>VMAX_LMT);
                V{I}(INDEX_V)=VMAX_LMT;
            end
            if V{I}<VMIN_LMT
                [VALUE_V, INDEX_V] = find(V{I}<VMIN_LMT);
                V{I}(INDEX_V)=VMIN_LMT;
            end 
            %位置記憶區塊 FPSO
            if ifpso == 0
                X_3{:,I} = X_2{:,I};
                X_2{:,I} = X_1{:,I};
                X_1{:,I} = X_C{:,I};
            end
            
            %位置界線區塊 上一時刻
            if max(X_1{I})>XMAX
                [VALUE_X, INDEX_X] = find(X_1{I}>XMAX);
                X_1{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));%超出邊界則重新生成
            end
            if min(X_1{I})<XMIN
                [VALUE_X, INDEX_X] = find(X_1{I}<XMIN);
                X_1{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            
            %位置更新
            X_C{I} = X_C{I}+V{I}*DT; % PARTICLE POSITION UPDATE
            
            %位置界線區塊 此時刻
            if max(X_C{I})>XMAX
                [VALUE_X, INDEX_X] = find(X_C{I}>XMAX);
                X_C{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            if min(X_C{I})<XMIN
                [VALUE_X, INDEX_X] = find(X_C{I}<XMIN);
                X_C{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
                
            end
        end%每一族群結束
    GBVITER(ITER) = GBV;
    POSITION = GB;
    %紀錄函數值到0的時候
        if(GBV ==0)
            ITERNUM = ITER;%跑到的次數
            break;
        else
            ITERNUM =ITERMAX;
        end   
    end
 %   best_v(REPT) = GBV;
   % BEST_V(REPT) = GBV; % 群體最佳值給予每次實驗最佳值
%     BFR_BEST_V = BEST_V;
%     BFR_BESTGB = BESTGB;
%     BEST_V = GBV;
%     BESTGB = GB;    % 群體最佳位置
%     disp(['第',num2str(REPT),'次BEST PARTICLE VALUE >> ' num2str(BEST_V)]);
%     if BFR_BEST_V < BEST_V
%         BEST_V = BFR_BEST_V;
%         BESTGB = BFR_BESTGB;
%     end
out.croflag_count=croflag_count;
out.best_v =  GBVITER;
out.iternum = ITERNUM;
out.position = POSITION;
out.method = method;
out.wvalue = Wvalue;
%  out.BS_M=mean(best_v);%平均值
%  out.BS_S=std(best_v);%標準差
%  out.BS_MAX=max(best_v);
%  out.BS_MIN=min(best_v);%最小值
%  out.BS_ALL = [out.BS_M out.BS_MIN out.BS_S];
%BS_ALL=[BS_M, BS_S, BS_MAX, BS_MIN]
% disp(['BEST PARTICLE VALUE - MEAN >> ' num2str(BS_M)]); 
% disp(['BEST PARTICLE VALUE - STD >> ' num2str(BS_S)]); 
% disp(['BEST PARTICLE VALUE - MAX >> ' num2str(BS_MAX)]); 
% disp(['BEST PARTICLE VALUE - MIN >> ' num2str(BS_MIN)]);

%semilogy(GBVITER);title('xx')

% disp(['所有實驗中BEST VALUE >> ' num2str(BEST_V)]);
% disp(['所有實驗BEST PARTICLE POSITION >> ' num2str(BESTGB)]);

end

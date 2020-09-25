function out = funallkindpso(data)

%% �ѼƳ]�w PSO PARAMETERS WITH THEIR USUAL RANGE USED IN LITERATURE
%CPSO CFPSO���ܰϰ�
BESTUNI = data.BESTUNI;
%BESTUNI = [0.3 1 1 1]; %���ó]�p�̨έ�
L=BESTUNI(1);A=BESTUNI(2);B=BESTUNI(3);R=BESTUNI(4);
%L= lambda %A = alpha %B = beta %R = gamma
S = data.S; % �ɤl�s�j�p
D = data.D; % ���� �ܼƼƶq
ITERMAX = data.ITERMAX; % ���N�̤j��
XMAX =  data.XMAX; % ��m�̤j��
XMIN = data.XMIN;% ��m�̤p��

OBJ = @(x) fitness_all(x,data.fun); % �ؼФ�{
if data.fun ==8
    OBJ = @(x) fitness_fun4(x,data.fun); % �ؼФ�{
end

C1MAX = data.C1MAX; % ����ǲ߰Ѽ� [0-4]
C1MIN = 0; % ����ǲ߰Ѽ� [0-4]
C2MAX = data.C2MAX; % �s��ǲ߰Ѽ� [0-4]
C2MIN = 0; % �s��ǲ߰Ѽ� [0-4]
WMAX = 0.9; % �v�� [0-1]
WMIN = 0.4; % �v�� [0-1]

X_C = cell(1,S); % ��e���ɤl��m
X_1 = cell(1,S); % �e�@�Ӳɤl��m
X_2 = cell(1,S); % �e�G�Ӳɤl��m
X_3 = cell(1,S); % �e�T�Ӳɤl��m
OBJX = zeros(1,S); % �ɤl�N�J������ҭp��X����
V = cell(1,S); % �ɤl�t��
DT = 1; % TIME STEP �ɨB !�Űʸӭ�!
% BEST_V = zeros(1,REP_NO);
BEST_V = 99999;
VMAX_LMT = XMAX - XMIN; % VELOCITY LIMIT
VMIN_LMT = -VMAX_LMT;
BESTGB = zeros(1,D);
%%�h�[�϶�
%CPSO CFPSO ���ܰϰ�
orifpsoflg = 0;
method=data.method;
switch method
    case 'PSO'
        r1temp = 0;
        ifpso = 1;
        oripsoflg = 1;
    case 'CPSO'
        r1temp = 0.267945;%lambda�Ȯ�r1�̧C����
        ifpso = 1;
        oripsoflg = 0;
    case 'ORIFPSO'
        r1temp = 0;
        ifpso = 0;
        orifpsoflg = 1;
    case 'CFPSO'
        r1temp = 0.208743;%lambda�Ȯ�r1�̧C����
        ifpso = 0;
        orifpsoflg = 0;
end
GBVITER = zeros(1,ITERMAX);
TEMP_OBJX = cell(1,S);
croflag_count=0;
Wvalue = zeros(1,ITERMAX);
Wflag = data.Wflag;
%% ��l�� PSO INITIALIZE PARTICLES POSITION AND VELOCITIES
% while BEST_V > 6.48
    PB = cell(1,S);         % ����̨Φ�m
    PBV = ones(1,S)*1E200;   % ����̨έ�
    GBV = 1E50;             % �s��̨έ�
    GB = zeros(1,D);        % �s��̨Φ�m
    ITER = 0; % ��e���N��
    for I = 1:S
        X_C{I} = data.sameX_C{I};
        %X_C{I} = unifrnd(XMIN,XMAX,1,D);%��l�H���ͦ�
        X_1{I} = zeros(1,D);
        X_2{I} = zeros(1,D);
        X_3{I} = zeros(1,D);
        V{I} = X_C{I}/DT;
    end
      %% �D�y�{ PSO MAIN LOOP
    while ITER < ITERMAX
        ITER = ITER + 1;
        %�ͦ���l��m
        for I = 1:S
            OBJX(I) = OBJ(X_C{I});
            %�M��̨Φ�m
            if OBJX(I) < PBV(I) % FINDING BEST LOCAL
                PB{I} = X_C{I};%����̨Φ�m
                PBV(I) = OBJX(I);%����̨έ�
            end
        end
        %�M�����̨Φ�m
        if min(OBJX) < GBV % FINDING BEST GLOBAL
            GB = X_C{OBJX == min(OBJX)};
            GBV = min(OBJX);
        end
        %�C���N�Ƥ��̨έ�
        TEMP_OBJX{ITER}=OBJX;
        
        %�i���ʰϰ�
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
        %W����ϰ�
        switch Wflag
            case '1'
              W = W*WDAMP;    %�C���N1����D���v���U��
              Wvalue(ITER) = W;
            case '2'
              W = WMIN + ((ITERMAX-ITER)/ITERMAX)^A*(WMAX-WMIN); %A���alfa
              Wvalue(ITER) = W;
            case '3'
              if ITER<MaxIt*wtimes
                  W = W;
              else
                  W = WMIN + ((ITERMAX-ITER)/ (ITERMAX-ITERMAX*Wtimes)^A)*(WMAX-WMIN); %A���alfa
                  %w = wmin+(((MaxIt-it)/(MaxIt-MaxIt*wtimes))^walpha)*(wmax-wmin);%�n�P��wtimes�ץ�
              end
              Wvalue(ITER) = W;
        end
        %W = WMIN + ((ITERMAX-ITER)/ITERMAX)^A*(WMAX-WMIN); %A���alfa
        %C1�BC2�ϰ�
        C1 = C1MAX;       
        C2 = C2MAX;
        %C1 = C1MIN + ((ITERMAX-ITER)/ITERMAX)^B*(C1MAX-C1MIN); %B���beta
        %C2 = C2MAX + ((ITERMAX-ITER)/ITERMAX)^R*(C2MIN-C2MAX); %R���gama
        
        for I = 1:S % PARTICLE POSITION UPDATE
            R2 = rand(); % random number [0-1]
            if croflag ==1
                R1 = rand(1,1);
                if ifpso == 1
                    %R1 = rand(); % random number [0-1]
                    R1 =  r1temp+((R1-0)/(1-0))*(1-r1temp);   %���W��
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
%                 R1 =  r1temp+((R1-0)/(1-0))*(1-r1temp);   %���W��
%             else
%                 R1 =rand();
%             end
            
            if orifpsoflg ==1
                L = 0.3;%unifrnd(0,2)
            end
            %�t�ק�s�϶� PSO�BFPSO
            if ifpso == 1
                if oripsoflg ==1
                    V{I} = W*V{I}+C1*R1*(PB{I}-X_C{I})/DT+C2*R2*(GB-X_C{I})/DT;
                else   
                    V{I} = W*V{I}+C1*R1*(PB{I}-X_C{I})/DT+C2*R2*(GB-X_C{I})/DT; % PARTICLE VELOCITY UPDATE % L���Lamda
                end
            else
                if orifpsoflg == 1
                    V{I} = 0.2*V{I}+C1*R1*(PB{I}-L*X_C{I}-(L/2)*(1-L)*X_1{I}-(L/6)*(1-L)*(2-L)*X_2{I}+(L/24)*(1-L)*(2-L)*(3-L)*X_3{I})/DT+C2*R2*(GB-X_C{I})/DT;
                else
                    V{I} = W*V{I}+C1*R1*(PB{I}-L*X_C{I}-(L/2)*(1-L)*X_1{I}-(L/6)*(1-L)*(2-L)*X_2{I}+(L/24)*(1-L)*(2-L)*(3-L)*X_3{I})/DT+C2*R2*(GB-X_C{I})/DT; % PARTICLE VELOCITY UPDATE % L���Lamda
                end
            end
            
            %�t�׬ɽu�϶�
            if V{I}>VMAX_LMT
                [VALUE_V, INDEX_V] = find(V{I}>VMAX_LMT);
                V{I}(INDEX_V)=VMAX_LMT;
            end
            if V{I}<VMIN_LMT
                [VALUE_V, INDEX_V] = find(V{I}<VMIN_LMT);
                V{I}(INDEX_V)=VMIN_LMT;
            end 
            %��m�O�а϶� FPSO
            if ifpso == 0
                X_3{:,I} = X_2{:,I};
                X_2{:,I} = X_1{:,I};
                X_1{:,I} = X_C{:,I};
            end
            
            %��m�ɽu�϶� �W�@�ɨ�
            if max(X_1{I})>XMAX
                [VALUE_X, INDEX_X] = find(X_1{I}>XMAX);
                X_1{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));%�W�X��ɫh���s�ͦ�
            end
            if min(X_1{I})<XMIN
                [VALUE_X, INDEX_X] = find(X_1{I}<XMIN);
                X_1{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            
            %��m��s
            X_C{I} = X_C{I}+V{I}*DT; % PARTICLE POSITION UPDATE
            
            %��m�ɽu�϶� ���ɨ�
            if max(X_C{I})>XMAX
                [VALUE_X, INDEX_X] = find(X_C{I}>XMAX);
                X_C{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
            end
            if min(X_C{I})<XMIN
                [VALUE_X, INDEX_X] = find(X_C{I}<XMIN);
                X_C{I}(INDEX_X)=unifrnd(XMIN,XMAX,1,length(INDEX_X));
                
            end
        end%�C�@�ڸs����
    GBVITER(ITER) = GBV;
    POSITION = GB;
    %������ƭȨ�0���ɭ�
        if(GBV ==0)
            ITERNUM = ITER;%�]�쪺����
            break;
        else
            ITERNUM =ITERMAX;
        end   
    end
 %   best_v(REPT) = GBV;
   % BEST_V(REPT) = GBV; % �s��̨έȵ����C������̨έ�
%     BFR_BEST_V = BEST_V;
%     BFR_BESTGB = BESTGB;
%     BEST_V = GBV;
%     BESTGB = GB;    % �s��̨Φ�m
%     disp(['��',num2str(REPT),'��BEST PARTICLE VALUE >> ' num2str(BEST_V)]);
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
%  out.BS_M=mean(best_v);%������
%  out.BS_S=std(best_v);%�зǮt
%  out.BS_MAX=max(best_v);
%  out.BS_MIN=min(best_v);%�̤p��
%  out.BS_ALL = [out.BS_M out.BS_MIN out.BS_S];
%BS_ALL=[BS_M, BS_S, BS_MAX, BS_MIN]
% disp(['BEST PARTICLE VALUE - MEAN >> ' num2str(BS_M)]); 
% disp(['BEST PARTICLE VALUE - STD >> ' num2str(BS_S)]); 
% disp(['BEST PARTICLE VALUE - MAX >> ' num2str(BS_MAX)]); 
% disp(['BEST PARTICLE VALUE - MIN >> ' num2str(BS_MIN)]);

%semilogy(GBVITER);title('xx')

% disp(['�Ҧ����礤BEST VALUE >> ' num2str(BEST_V)]);
% disp(['�Ҧ�����BEST PARTICLE POSITION >> ' num2str(BESTGB)]);

end

function [bestPop, bestFval, minFval] = ga_mTSP(objective, nVars, nCity, opts) 
    def.FunctionTolerance = 1e-10;
    def.MaxFunctionEvaluations = inf;
    def.MaxGenerations = inf;
    def.MaxStallGenerations = 50*ceil(log(nVars));
    def.PopulationSize = 100*ceil(nVars/10);
    def.Display = "on";
    if nargin < 4
        opts = struct();
    end
    customized = fieldnames(opts);
    for i = 1:numel(customized)
        if ~isfield(def,customized{i})
            error('输入的options中有不能识别的项�?%s�?',customized{i});
        end
        def.(customized{i}) = opts.(customized{i});
    end
    opts = def; stalls = 0; iter = 1;
    %%��Ⱥ��ʼ��
    Population = my_Create(opts.PopulationSize, nVars, nCity);
    minFval = objective(Population(1, :));
    while true
        fval = objective(Population);
        fcount = iter*opts.PopulationSize;
        iter = iter + 1;
        [fval, idx] = sort(fval);
        minFval(iter) = fval(1);
        Population = Population(idx, :);
        if minFval(iter) < minFval(iter-1) - opts.FunctionTolerance
            stalls = 0;
        else
            stalls = stalls + 1;
        end
        if opts.Display == "on"
            display(iter-1, fcount, minFval(iter), fval, stalls)
        end
        if (stalls > opts.MaxStallGenerations) || ...
           (iter > opts.MaxGenerations) || ...
           (fcount > opts.MaxFunctionEvaluations)
            break
        end
        pMean = stalls./opts.MaxStallGenerations;
        idx = reshape(1:opts.PopulationSize, opts.PopulationSize/10, 10); %ÿһ����ʮ����������Ⱥ�еı�ţ��������еı���ÿһ����һ������
        for i = 1:opts.PopulationSize/10
            Population(idx(i, :), :) = IPGA(Population(idx(i, :), :), nCity, pMean);
        end
    end
    bestPop = Population(1, :);
    bestFval = minFval(iter);
end

%% ���ɳ�ʼ��Ⱥ
function new_X = my_Create(nPop, nVars, nCity) % ���ɳ�ʼ��Ⱥ 
    new_X = zeros(nPop, nVars);
    nCars = nVars - nCity; %����������
    %%ȷ���ϵ�ķ�Χ������ż��
    for i = 1:nPop
        new_X(i, 1:nCity) = randperm(nCity);
        new_X(i,nCity+1:nVars) = Points_Creat(nCity,nCars);
        %%���������ɣ�Ҫ��֤ÿ�������̶�Ҫ����ż�����켣��
        %%����Ӧ����[2,nCity-2]�в�������� �������ڵĲ�������2���켣 ��������������޷�����Ҫ����ν������
        %%����ÿ����������С���г���������
%         new_X(i, nCity+1:nVars) = sort(randperm(nCity, nCars));
%         randperm(27,2��+1;
%         new_X(i, nCity+1:nVars) = max(2:nCars+1, new_X(i, nCity+1:nVars)); %�������ɲ����Ĺ���ȷ�������е�Ⱦɫ�����
%         new_X(i, nCity+1:nVars) = min(nCity-nCars:nCity-1, new_X(i, nCity+1:nVars));
        
    end
end

%% ������������Ҫ��Ķϵ㼯��
%%% 1�������ģ�����-1�����ϵ㣬�Ҵ�С����������У�2����һ���ϵ㲻��С��M(M��ѹ·������Ҫ�����Ĺ켣����);3�����������ϵ�֮�������ҲҪ����M;
%%% 4�����һ���ϵ�͹켣����֮�����ٲ�M��5��ÿ���ϵ��Ϊż���������ܱ�֤���ѹ·�����Թ켣���ظ�
function breakPoints = Points_Creat(nCity,nCars)
    M = 2;%MҲӦ����ż��
    temp = randperm(nCity-2*M+1)+M-1; %��֤��С�����Ķϵ㴦�Ĺ켣������С��M
    temp = temp(find(mod(temp,2)==0));
    %%��������ϵ㣬Ȼ���ж��Ƿ�����Ҫ��
    while true
        breakPoints =sort( temp(randperm(length(temp),nCars))); 
        findit = true;
        for i = 2:length(breakPoints)
            if breakPoints(i)-breakPoints(i-1)<M
                findit = false;
                break
            end
        end
        if findit == true
            break
        end 
    end
end

%% ʹ��IPGA���������µ���Ⱥ������
function s = IPGA(s, nCity, pMean)
    SegmentP = sort(randperm(nCity, 2)); %�����s������ѡ�е���Ⱥ��Ⱦɫ�����
    I = SegmentP(1); %��ȡͻ��Ľڵ�
    J = SegmentP(2);
    nVars = length(s); %%ȷ��Ⱦɫ���л�������
%     bestGene = s(1,:);
%     breaks =nVars-nCity;
%     for n = 1 : 10
%         switch n
%             case 2 %FlipInsert
%                 s(n,I:J) = s(n,J:I);
%             case 3 %SwapInsert
%                 s(n,[I J]) = s(n, [J I]);
%             case 4 %LSlideInsert
%                 s(n,I:J) = s(n, [I+1:J I]);
%             case 5 %RSlideInset
%                 s(n, I:J) =s(n, [J I:J-1]);
%             case 6
%                 s(n,
%                 
%             otherwise
%         end
%     end 
    for k = 2:5
        s(k, :) = crossover(s(1, :), k-1);
    end
    for k = 6:10
        %s(k, :) = crossover(s(1,:), k-6);
        s(k, :) = variation(s(k-5, :));
    end
    function s = crossover(s, Rand) % 
        %%����Ҫ���в����P�ļ��㣬Ŀǰ����������沢û���漰�� https://blog.csdn.net/LOVEmy134611/article/details/111698662
        %%https://www.codenong.com/cs103787788/
        %%https://www.freesion.com/article/4612242819/
        switch Rand
            case 1 % FlipInsert
                s(SegmentP(1):SegmentP(2)) = s(SegmentP(2):-1:SegmentP(1));
            case 2 % SwapInsert
                %s(SegmentP) = s(sort(SegmentP, 'descend'));
                s([I J]) = s([J I]);
            case 3 % LSliInsert
%                 SegmentP = max([2, 3; SegmentP]);
%                 s1 = s(SegmentP(1)-1:SegmentP(2)-1);
%                 s2 = s([1:SegmentP(1)-2, SegmentP(2):nVars]);
%                 s(SegmentP(1):SegmentP(2)) = s1;
%                 s([1:SegmentP(1)-1, SegmentP(2)+1:nVars]) = s2;
                  s(I:J) = s([I+1:J I]);
            case 4 % RSliInsert
                  s(I:J) = s([J I:J-1]);
%                 SegmentP = min([nCity-2, nCity-1; SegmentP]);
%                 s1 = s(SegmentP(1)+1:SegmentP(2)+1);
%                 s2 = s([1:SegmentP(1), SegmentP(2)+2:nVars]);
%                 s(SegmentP(1):SegmentP(2)) = s1;
%                 s([1:SegmentP(1)-1, SegmentP(2)+1:nVars]) = s2;
            otherwise
                %s(SegmentP(1):SegmentP(2)) = s(SegmentP(2):-1:SegmentP(1));
        end
    end    
    function s = variation(s) % 变异函数
        nCars = nVars - nCity;
%         M = 2;%MҲӦ����ż��
%         temp = randperm(nCity-2*M+1)+M-1; %��֤��С�����Ķϵ㴦�Ĺ켣������С��M
%         temp = temp(find(mod(temp,2)==0));
        s(nCity+1:end) =  Points_Creat(nCity,nCars);
%         if rand > pMean
%             s(nCity+1:end) = sort(randperm(nCity, nCars));
%         else % 保证切割点位于中�?
%             nPoints = rand(1, nCars+1); %��������0~1֮�������
%             nPoints = cumsum(round(nCity*(1+nPoints)./sum(1+nPoints)));
%             s(nCity+1:end) = nPoints(1:end-1);
%         end
%         s(nCity+1:end) = max(2:nCars+1, s(nCity+1:end));
%         s(nCity+1:end) = min(nCity-nCars:nCity-1, s(nCity+1:end));
    end
end

function display(gen, fcount, best, fval, stall)
    if mod(gen, 30) == 1
        disp('                                  Best           Mean      Stall');
        disp('Generation      Func-count        f(x)           f(x)    Generations');
    end
    fprintf('%5d     %12d    %12g    %12g    %5d\n',gen,fcount,best,nanmean(fval),stall);
end

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
            error('杈撳叆鐨刼ptions涓湁涓嶈兘璇嗗埆鐨勯」鐩?%s銆?',customized{i});
        end
        def.(customized{i}) = opts.(customized{i});
    end
    opts = def; stalls = 0; iter = 1;
    %%种群初始化
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
        idx = reshape(1:opts.PopulationSize, opts.PopulationSize/10, 10); %每一行是十个个体在种群中的编号，其中最有的便是每一个第一个个体
        for i = 1:opts.PopulationSize/10
            Population(idx(i, :), :) = IPGA(Population(idx(i, :), :), nCity, pMean);
        end
    end
    bestPop = Population(1, :);
    bestFval = minFval(iter);
end

%% 生成初始中群
function new_X = my_Create(nPop, nVars, nCity) % 生成初始种群 
    new_X = zeros(nPop, nVars);
    nCars = nVars - nCity; %插入点的数量
    %%确定断点的范围，均是偶数
    for i = 1:nPop
        new_X(i, 1:nCity) = randperm(nCity);
        new_X(i,nCity+1:nVars) = Points_Creat(nCity,nCars);
        %%插入点的生成：要保证每个旅行商都要经过偶数个轨迹。
        %%所以应该在[2,nCity-2]中产生插入点 而且相邻的插入点相差2个轨迹 这里出现了问题无法满足要求。如何进行设计
        %%满足每个旅行商最小旅行城市数量。
%         new_X(i, nCity+1:nVars) = sort(randperm(nCity, nCars));
%         randperm(27,2）+1;
%         new_X(i, nCity+1:nVars) = max(2:nCars+1, new_X(i, nCity+1:nVars)); %按照生成插入点的规则将确定个体中的染色体组成
%         new_X(i, nCity+1:nVars) = min(nCity-nCars:nCity-1, new_X(i, nCity+1:nVars));
        
    end
end

%% 产生满足以下要求的断点集合
%%% 1、产生的（车辆-1）个断点，且从小到大进行排列；2、第一个断点不能小于M(M是压路机最少要遍历的轨迹数量);3、相邻两个断点之间的数量也要大于M;
%%% 4、最后一个断点和轨迹数量之间至少差M；5、每个断点均为偶数，这样能保证冲击压路机可以轨迹的重复
function breakPoints = Points_Creat(nCity,nCars)
    M = 2;%M也应该是偶数
    temp = randperm(nCity-2*M+1)+M-1; %保证最小和最大的断点处的轨迹数量不小于M
    temp = temp(find(mod(temp,2)==0));
    %%随机产生断点，然后判断是否满足要求
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

%% 使用IPGA方法进行新的种群的生成
function s = IPGA(s, nCity, pMean)
    SegmentP = sort(randperm(nCity, 2)); %这里的s则是所选中的种群的染色体组成
    I = SegmentP(1); %获取突变的节点
    J = SegmentP(2);
    nVars = length(s); %%确定染色体中基因数量
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
        %%这里要进行插入点P的计算，目前这个方法里面并没有涉及到 https://blog.csdn.net/LOVEmy134611/article/details/111698662
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
    function s = variation(s) % 鍙樺紓鍑芥暟
        nCars = nVars - nCity;
%         M = 2;%M也应该是偶数
%         temp = randperm(nCity-2*M+1)+M-1; %保证最小和最大的断点处的轨迹数量不小于M
%         temp = temp(find(mod(temp,2)==0));
        s(nCity+1:end) =  Points_Creat(nCity,nCars);
%         if rand > pMean
%             s(nCity+1:end) = sort(randperm(nCity, nCars));
%         else % 淇濊瘉鍒囧壊鐐逛綅浜庝腑闂?
%             nPoints = rand(1, nCars+1); %产生三个0~1之间的数字
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

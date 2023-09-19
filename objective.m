function fval = objective(Population, nCity, Dist)
    nPops = size(Population, 1);
    nCars = size(Population, 2) - nCity + 1;
    Fval = zeros(nPops, nCars);
    for i = 1:nPops
        Fval(i, :) = subFun(Population(i, :), nCity, Dist);
    end
    %fval1 = sum(Fval, 2); % 求行和 也就是将Fval中的元素相加，每个元素对应着一个旅行商的成本 这一应该换算成max(Fval)选择旅行商中时间最长的作为目标
    [fval, index] = max(Fval,[],2);
    %fval = (fval1+fval2)/2;
end


function mFval = subFun(s, nCity, dist)
    nCars = length(s) - nCity + 1;
    path = s(1:nCity);
    cutPoint = [0, s(nCity+1:end), nCity];
    mFval = zeros(1, nCars);
    %pathCell =cell(1,nCars);
    for j = 1:nCars
        mPath = path(cutPoint(j)+1:cutPoint(j+1)); %%依次获得各个旅行商轨迹顺序
        cmDist = dist(sub2ind(size(dist), mPath(1:end-1), mPath(2:end))); %% 为第i行第j列的元素在整个矩阵中的索引，其中一列一列的数。
        mFval(j) = sum(cmDist)+dist(mPath(end),mPath(1)); %% 加上从结束点到起始点的转弯时间，这个是总的转弯时间。旅行总时间还得加上直线路径上的时间
        lineDist = dist(sub2ind(size(dist),mPath(1:end),mPath(1:end)));
        mFval(j) = mFval(j) + sum(lineDist);
        %pathCell(1,j) =mPath;
    end
    %%后面还得添加惩罚项
    
end

%% 判断这个解对应的各个旅行商之间是否存在时间冲突的问题
%%$dist是距离矩阵，mPathList包括解决方案中不同旅行商的遍历点的顺序。 cell数组
%%mPathList(1,1)等于第一个旅行商的遍历顺序结合
function conflict = space_time(dist, mPathList)
    %%如何判断是否存在旅行商冲突的问题
    %%isuper 判断是否在上部分转弯，isuper=true，则在上部分转弯，反之为下部分转弯。
end

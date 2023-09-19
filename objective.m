function fval = objective(Population, nCity, Dist)
    nPops = size(Population, 1);
    nCars = size(Population, 2) - nCity + 1;
    Fval = zeros(nPops, nCars);
    for i = 1:nPops
        Fval(i, :) = subFun(Population(i, :), nCity, Dist);
    end
    %fval1 = sum(Fval, 2); % ���к� Ҳ���ǽ�Fval�е�Ԫ����ӣ�ÿ��Ԫ�ض�Ӧ��һ�������̵ĳɱ� ��һӦ�û����max(Fval)ѡ����������ʱ�������ΪĿ��
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
        mPath = path(cutPoint(j)+1:cutPoint(j+1)); %%���λ�ø��������̹켣˳��
        cmDist = dist(sub2ind(size(dist), mPath(1:end-1), mPath(2:end))); %% Ϊ��i�е�j�е�Ԫ�������������е�����������һ��һ�е�����
        mFval(j) = sum(cmDist)+dist(mPath(end),mPath(1)); %% ���ϴӽ����㵽��ʼ���ת��ʱ�䣬������ܵ�ת��ʱ�䡣������ʱ�仹�ü���ֱ��·���ϵ�ʱ��
        lineDist = dist(sub2ind(size(dist),mPath(1:end),mPath(1:end)));
        mFval(j) = mFval(j) + sum(lineDist);
        %pathCell(1,j) =mPath;
    end
    %%���滹����ӳͷ���
    
end

%% �ж�������Ӧ�ĸ���������֮���Ƿ����ʱ���ͻ������
%%$dist�Ǿ������mPathList������������в�ͬ�����̵ı������˳�� cell����
%%mPathList(1,1)���ڵ�һ�������̵ı���˳����
function conflict = space_time(dist, mPathList)
    %%����ж��Ƿ���������̳�ͻ������
    %%isuper �ж��Ƿ����ϲ���ת�䣬isuper=true�������ϲ���ת�䣬��֮Ϊ�²���ת�䡣
end

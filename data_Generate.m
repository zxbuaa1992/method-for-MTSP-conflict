%% 获得时间矩阵，其中对角线上的时间表示IC红击压路机在直线轨迹上所消耗的时间
function [CityCoor, Dist] = data_Generate(nCity, rangeX, rangeY)
    CityCoor(:, 1) = unifrnd(rangeX(1), rangeX(2), nCity, 1); %生成城市X坐标
    CityCoor(:, 2) = unifrnd(rangeY(1), rangeY(2), nCity, 1); %生成城市Y坐标 用于后续绘图，代表虚拟的轨迹空间分布位置（节点）
    Dist = zeros(nCity, nCity);
    for i = 1:nCity  % 计算城市之间的距离
        for j = 1 :nCity
            Dist(i, j) = dis(i,j);%%确定每两个轨迹之间转弯的距离，如果轨迹距离很近则，有惩罚项。 在这里确定时间 这里是所消耗的时间 记住这一点 别闹混了
        end
        
    end
end

%% 计算在轨迹内以及转弯所消耗的时间
function distance = dis(location1, location2)
    lenofLine = 200;
    speedofLine = 3.62;
    speedofTurn = 1.67;
    if location1 == location2
        distance = lenofLine/speedofLine;
    else
        distance = disofTurn(location1,location2)/speedofTurn; 
    end
end
%%
%% 计算两个点之间的最小转弯距离
function distance = disofTurn(Node1, Node2)
    width = 4.05; % 轨迹带宽度
    rmin = 6; % 压路机的最小转弯半径
    m=floor(abs(Node1-Node2)/2);%取整
    n=abs(Node1-Node2)-m*2;%取余
    %%dis=0;
    if n==0
        dis=m*width;%% 直接等于作业行的宽度的m倍
    else
        %% 不同情况下的两轨迹线之间的直线距离不同
        if mod(max(Node1,Node2),2)==0
            dis=m*width+1; 
        else
            dis=m*width+3;
        end    
    end
    %% 根据dis 和rmin的大小计算len
    if dis>=2*rmin
        distance = dis+(pi-2)*rmin; %U型转弯形式对应的转弯距离
    else
        distance = (pi+4*acos((dis+2*rmin)/(4*rmin)))*rmin;%Ω型转弯方式对应的转弯距离
    end
    %%这里的距离计算要进行分析，因为确定的轨迹之间有相邻的情况。
    if abs(Node1-Node2)<=2
        distance = 100;
    end
end
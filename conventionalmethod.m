%%根据压路机数量和轨迹数量自动生成每个车辆传统的压路机施工路径集合
nCity =30;
nCars = 3;
Dist = zeros(nCity, nCity);
for i = 1:nCity  % 计算城市之间的距离
    for j = 1 :nCity
        Dist(i, j) = dis(i,j);%%确定每两个轨迹之间转弯的距离，如果轨迹距离很近则，有惩罚项。 在这里确定时间 这里是所消耗的时间 记住这一点 别闹混了
    end
end
%%自动生成传统的压路机路径集合



%% 传统方法两个冲击压路机的施工方法及对应的成本计算  该方案对应的时间成本为1778s 优化后的时间是1558； 那就只考虑这种并排施工的情况
roller1 = [1 16 3 18 5 20 7 22 9 24 11 26 13 28 15 30];
roller2 = [2 17 4 19 6 21 8 23 10 25 12 27 14 29];
%计算时间成本 转弯时间+直线时间
t1 = sum(Dist(sub2ind(size(Dist), roller1(1:end-1), roller1(2:end))))+Dist(roller1(end),roller1(1))+sum(Dist(sub2ind(size(Dist), roller1(1:end), roller1(1:end))));
t2 = sum(Dist(sub2ind(size(Dist), roller2(1:end-1), roller2(2:end))))+Dist(roller2(end),roller2(1))+sum(Dist(sub2ind(size(Dist), roller2(1:end), roller2(1:end))));
t=(t1+t2+max(t1,t2))/2;

%% 另一个传统方法下的冲击压路机施工轨迹及对应的时间成本 roller1=roller2
roller = [1 16 2 17 3 18 4 19 5 20 6 21 7 22 8 23 9 24 10 25 11 26 12 27 13 28 14 29 15 30];
t_1 = sum(Dist(sub2ind(size(Dist), roller(1:end-1), roller(2:end))))+Dist(roller(end),roller(1))+sum(Dist(sub2ind(size(Dist), roller(1:end), roller(1:end))));
t11 =(2*t_1+t_1)/2;

%% 传统的三个冲击压路机的施工轨迹以及对应的时间成本
roller11 = [1 16 4 19 7 22 10 25 13 28];
roller22 = [2 17 5 20 8 23 11 26 14 29];
roller33 = [3 18 6 21 9 24 12 27 15 30];
t_11 = sum(Dist(sub2ind(size(Dist), roller11(1:end-1), roller11(2:end))))+Dist(roller11(end),roller11(1))+sum(Dist(sub2ind(size(Dist), roller11(1:end), roller11(1:end))));
t_22 = sum(Dist(sub2ind(size(Dist), roller22(1:end-1), roller22(2:end))))+Dist(roller22(end),roller22(1))+sum(Dist(sub2ind(size(Dist), roller22(1:end), roller22(1:end))));
t_33 = sum(Dist(sub2ind(size(Dist), roller33(1:end-1), roller33(2:end))))+Dist(roller33(end),roller33(1))+sum(Dist(sub2ind(size(Dist), roller33(1:end), roller33(1:end))));
tempmax=max(t_11,t_22);
tempmax = max(tempmax, t_33);
t22=(t_11+t_22+t_33+tempmax)/2;
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
        W=m*width;%% 直接等于作业行的宽度的m倍
    else
        %% 不同情况下的两轨迹线之间的直线距离不同
        if mod(max(Node1,Node2),2)==0
            W=m*width+1; 
        else
            W=m*width+3;
        end    
    end
    %% 根据dis 和rmin的大小计算len
    if W>=2*rmin
        distance = W+(pi-2)*rmin; %U型转弯形式对应的转弯距离
    else
        distance = (pi+4*acos((W+2*rmin)/(4*rmin)))*rmin;%Ω型转弯方式对应的转弯距离
    end
    %%这里的距离计算要进行分析，因为确定的轨迹之间有相邻的情况。
    if abs(Node1-Node2)<=2
        distance = 100;
    end
end
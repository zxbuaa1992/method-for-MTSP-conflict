%%����ѹ·�������͹켣�����Զ�����ÿ��������ͳ��ѹ·��ʩ��·������
nCity =30;
nCars = 3;
Dist = zeros(nCity, nCity);
for i = 1:nCity  % �������֮��ľ���
    for j = 1 :nCity
        Dist(i, j) = dis(i,j);%%ȷ��ÿ�����켣֮��ת��ľ��룬����켣����ܽ����гͷ�� ������ȷ��ʱ�� �����������ĵ�ʱ�� ��ס��һ�� ���ֻ���
    end
end
%%�Զ����ɴ�ͳ��ѹ·��·������



%% ��ͳ�����������ѹ·����ʩ����������Ӧ�ĳɱ�����  �÷�����Ӧ��ʱ��ɱ�Ϊ1778s �Ż����ʱ����1558�� �Ǿ�ֻ�������ֲ���ʩ�������
roller1 = [1 16 3 18 5 20 7 22 9 24 11 26 13 28 15 30];
roller2 = [2 17 4 19 6 21 8 23 10 25 12 27 14 29];
%����ʱ��ɱ� ת��ʱ��+ֱ��ʱ��
t1 = sum(Dist(sub2ind(size(Dist), roller1(1:end-1), roller1(2:end))))+Dist(roller1(end),roller1(1))+sum(Dist(sub2ind(size(Dist), roller1(1:end), roller1(1:end))));
t2 = sum(Dist(sub2ind(size(Dist), roller2(1:end-1), roller2(2:end))))+Dist(roller2(end),roller2(1))+sum(Dist(sub2ind(size(Dist), roller2(1:end), roller2(1:end))));
t=(t1+t2+max(t1,t2))/2;

%% ��һ����ͳ�����µĳ��ѹ·��ʩ���켣����Ӧ��ʱ��ɱ� roller1=roller2
roller = [1 16 2 17 3 18 4 19 5 20 6 21 7 22 8 23 9 24 10 25 11 26 12 27 13 28 14 29 15 30];
t_1 = sum(Dist(sub2ind(size(Dist), roller(1:end-1), roller(2:end))))+Dist(roller(end),roller(1))+sum(Dist(sub2ind(size(Dist), roller(1:end), roller(1:end))));
t11 =(2*t_1+t_1)/2;

%% ��ͳ���������ѹ·����ʩ���켣�Լ���Ӧ��ʱ��ɱ�
roller11 = [1 16 4 19 7 22 10 25 13 28];
roller22 = [2 17 5 20 8 23 11 26 14 29];
roller33 = [3 18 6 21 9 24 12 27 15 30];
t_11 = sum(Dist(sub2ind(size(Dist), roller11(1:end-1), roller11(2:end))))+Dist(roller11(end),roller11(1))+sum(Dist(sub2ind(size(Dist), roller11(1:end), roller11(1:end))));
t_22 = sum(Dist(sub2ind(size(Dist), roller22(1:end-1), roller22(2:end))))+Dist(roller22(end),roller22(1))+sum(Dist(sub2ind(size(Dist), roller22(1:end), roller22(1:end))));
t_33 = sum(Dist(sub2ind(size(Dist), roller33(1:end-1), roller33(2:end))))+Dist(roller33(end),roller33(1))+sum(Dist(sub2ind(size(Dist), roller33(1:end), roller33(1:end))));
tempmax=max(t_11,t_22);
tempmax = max(tempmax, t_33);
t22=(t_11+t_22+t_33+tempmax)/2;
%% �����ڹ켣���Լ�ת�������ĵ�ʱ��
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
%% ����������֮�����Сת�����
function distance = disofTurn(Node1, Node2)
    width = 4.05; % �켣�����
    rmin = 6; % ѹ·������Сת��뾶
    m=floor(abs(Node1-Node2)/2);%ȡ��
    n=abs(Node1-Node2)-m*2;%ȡ��
    %%dis=0;
    if n==0
        W=m*width;%% ֱ�ӵ�����ҵ�еĿ�ȵ�m��
    else
        %% ��ͬ����µ����켣��֮���ֱ�߾��벻ͬ
        if mod(max(Node1,Node2),2)==0
            W=m*width+1; 
        else
            W=m*width+3;
        end    
    end
    %% ����dis ��rmin�Ĵ�С����len
    if W>=2*rmin
        distance = W+(pi-2)*rmin; %U��ת����ʽ��Ӧ��ת�����
    else
        distance = (pi+4*acos((W+2*rmin)/(4*rmin)))*rmin;%����ת�䷽ʽ��Ӧ��ת�����
    end
    %%����ľ������Ҫ���з�������Ϊȷ���Ĺ켣֮�������ڵ������
    if abs(Node1-Node2)<=2
        distance = 100;
    end
end
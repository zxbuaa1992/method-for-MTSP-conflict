%% ���ʱ��������жԽ����ϵ�ʱ���ʾIC���ѹ·����ֱ�߹켣�������ĵ�ʱ��
function [CityCoor, Dist] = data_Generate(nCity, rangeX, rangeY)
    CityCoor(:, 1) = unifrnd(rangeX(1), rangeX(2), nCity, 1); %���ɳ���X����
    CityCoor(:, 2) = unifrnd(rangeY(1), rangeY(2), nCity, 1); %���ɳ���Y���� ���ں�����ͼ����������Ĺ켣�ռ�ֲ�λ�ã��ڵ㣩
    Dist = zeros(nCity, nCity);
    for i = 1:nCity  % �������֮��ľ���
        for j = 1 :nCity
            Dist(i, j) = dis(i,j);%%ȷ��ÿ�����켣֮��ת��ľ��룬����켣����ܽ����гͷ�� ������ȷ��ʱ�� �����������ĵ�ʱ�� ��ס��һ�� ���ֻ���
        end
        
    end
end

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
        dis=m*width;%% ֱ�ӵ�����ҵ�еĿ�ȵ�m��
    else
        %% ��ͬ����µ����켣��֮���ֱ�߾��벻ͬ
        if mod(max(Node1,Node2),2)==0
            dis=m*width+1; 
        else
            dis=m*width+3;
        end    
    end
    %% ����dis ��rmin�Ĵ�С����len
    if dis>=2*rmin
        distance = dis+(pi-2)*rmin; %U��ת����ʽ��Ӧ��ת�����
    else
        distance = (pi+4*acos((dis+2*rmin)/(4*rmin)))*rmin;%����ת�䷽ʽ��Ӧ��ת�����
    end
    %%����ľ������Ҫ���з�������Ϊȷ���Ĺ켣֮�������ڵ������
    if abs(Node1-Node2)<=2
        distance = 100;
    end
end
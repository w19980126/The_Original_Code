function begin = w_triggerTime(data,t,Fs)

% ��data�����л��CS�ӵ翪ʼʱ�����ݵ㣬�Լ�pike�����ʼ�ɼ�ʱ��Ӧ�����ݵ��Լ��ӵ�ʱ
% ��Ӧ��֡��

data = data';
plot(t,data(2,:));

[~,begin.pike] = max(diff(data(1,:)));      % max�����������ֵ�Լ������ֵ��������

tmp = ginput(2);
x1 = t(round(10000*tmp(1)):round(10000*tmp(2)))';
y1 = data(2,round(10000*tmp(1)):round(10000*tmp(2)));
y1 = y1';
tmp = ginput(2);
x2 = t(round(10000*tmp(1)):round(10000*tmp(2)))';
y2 = data(2,round(10000*tmp(1)):round(10000*tmp(2)));
y2 = y2';

[begin.CS,~] = crosspoint(x1,y1,x2,y2);
begin.CS = begin.CS*10000;

clear x1 x2 y1 y2;

begin.frame = ceil((begin.CS - begin.pike)/10000*Fs);

end


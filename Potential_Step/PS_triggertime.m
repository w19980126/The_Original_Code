function begin = PS__triggertime(t,data,first_dur,Fs)

%% ������������ȡ��Ծ���Ʋ��������еĵ�·��ͨʱ�̵��������

% �÷��� �������ƽ�Ծ��Ӧ�����ߵõ����ƽ�Ծ����ʱ�̣����ɸ�ʱ�̼�ȥ����ʱ�伴�Ǽӵ�ʱ��

data = data';

%% pike�������֡��

tmp1 = diff(data(1,:));
[~,begin.pike] = max(tmp1);

%% ��üӵ�ʱ��

figure
plot(t,data(2,:));
tmp = ginput(1);
begin.CS = round(tmp(1)*10000)/10000;
begin.CS = (begin.CS-first_dur)*10000;

close
%% �ӵ翪ʼ֡��

begin.frame = ceil((begin.CS-begin.pike)/10000*Fs);

end


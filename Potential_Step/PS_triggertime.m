function begin = PS__triggertime(t,data,first_dur,Fs)

%% 本函数用来获取阶跃电势测量过程中的电路连通时刻的相关数据

% 用法： 单击电势阶跃对应的竖线得到电势阶跃处的时刻，再由该时刻减去静置时间即是加电时间

data = data';

%% pike相机接入帧数

tmp1 = diff(data(1,:));
[~,begin.pike] = max(tmp1);

%% 获得加电时间

figure
plot(t,data(2,:));
tmp = ginput(1);
begin.CS = round(tmp(1)*10000)/10000;
begin.CS = (begin.CS-first_dur)*10000;

close
%% 加电开始帧数

begin.frame = ceil((begin.CS-begin.pike)/10000*Fs);

end


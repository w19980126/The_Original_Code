function begin = w_triggerTime(data,t,Fs)

% 从data数据中获得CS加电开始时的数据点，以及pike相机开始采集时对应的数据点以及加电时
% 对应的帧数

data = data';
plot(t,data(2,:));

[~,begin.pike] = max(diff(data(1,:)));      % max函数返回最大值以及该最大值所在坐标

tmp = ginput(2);
x1 = t(10000*tmp(1):10000*tmp(2))';
y1 = data(2,10000*tmp(1):10000*tmp(2));
y1 = y1';
tmp = ginput(2);
x2 = t(10000*tmp(1):10000*tmp(2))';
y2 = data(2,10000*tmp(1):10000*tmp(2));
y2 = y2';

[begin.CS,~] = crosspoint(x1,y1,x2,y2);
begin.CS = begin.CS*10000;

clear x1 x2 y1 y2;

begin.frame = ceil((begin.CS - begin.pike)/10000*Fs);
% 
% [~, begin.pike] = max(diff(data(:, 1))); % trigger dot of the camera
% 
% plot(t, data(:, 2))
% % plot(t, data(:, 2))
% 
% [x, ~] = ginput(2);
% x1 = t((x(1)*10000):(x(2)*10000))';
% y1 = data((x(1)*10000):(x(2)*10000), 2);
% [x, ~] = ginput(2);
% x2 = t((x(1)*10000):(x(2)*10000))';
% y2 = data((x(1)*10000):(x(2)*10000), 2);
% 
% [px, ~] = crosspoint(x1, y1, x2, y2);
% begin.CS1 = px*10000;
end


function CV_batch(expname,zone,tifpath,mask,begin,scanrate,samplerate,saveroute,...
    cycle_num,high_potential,low_potential)
        
% 本函数使用来处理多圈CV并多个zone的数据的
% 得到的数据包括：
% 1）ROImean对于帧数的变化趋势
% 2）dROImean对于电势的变化趋势，即光电流CV曲线
% 3）各组数据相应的Value结构

tic

%% 判断mask是否是ROI区域为1，非ROI区域为0，如果不是，对mask做非运算

mask = logical(imread(mask));
tmp1 = mask(1,1);   % 基于常识判断，第一个像素不可能是ROI，故tmp1 = 1表明mask不对
if tmp1 > 0 
    
    mask = ~mask;
    
end

roi = mask;
SE = strel('disk',1);
roi_edge = edge(roi,'canny');
roi_edge = imdilate(roi_edge,SE);
Value.roi = roi;
Value.roi_edge = roi_edge;

%% 将各数据存入Value结构体中

Value.tifDir = dir(fullfile(tifpath,'*.tiff'));
Value.begin = begin;
[potential,seg_length] = w_potentialLine(scanrate,samplerate,cycle_num,high_potential,low_potential);
Value.seg_length = seg_length;
Value.potential = potential;

%% 判断是否掉帧

if length(Value.tifDir) <= (begin.frame+length(Value.potential)-1)
    
    disp(['第' num2str(1i) '组数据掉帧严重，中止处理']);
    return
    
else
    
    Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)-1));
    
end

%% 生成points/curve矩阵

points = w_ReadTifMaskPoint(tifpath,Value,mask);
Value.points = points;
curve = points;     % 保留原数据points，其后所有的变化值都通过curve进行计算

[m,n] = size(points);

for ii = 1:n
    curve(:,ii) = lowp(points(:,ii), 20*0.01, 6, 0.0001, 20, 50);
end

Value.curve = curve;

%% 创建新的文件夹用来保存数据

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % 否则saveas函数将无法保存数据

%% 以下，求平均强度对帧数Frame的变化曲线

avr = zeros(m,1);

parfor ii = 1:m
    avr(ii) = mean(curve(ii,:));
end

Value.avr = avr;     % 所谓平均强度，后来发现即是ROImean，所不同者，这里是对frame作图，后面是对potential作图
tmp = Value.begin.frame;
figure;
plot(avr,'k','linewidth',1.5);
ylim = get(gca,'ylim');
hold on
for ii = 1:(cycle_num+1)
    
    x = tmp+(ii-1)*2*seg_length;
    plot([x x],ylim,'--','linewidth',1.5);
    
end
hold off 
title([expname  '\_zone' num2str(zone) '，光强随帧数变化曲线,Scan Rate：' num2str(scanrate) 'mV/s'],'fontsize',15);
xlabel('Frames','fontsize',15);
ylabel('Mean Intensity','fontsize',15);
set(gca,'fontsize',15)
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_光强随帧数变化曲线.fig'];
saveas(gcf,fig_savepath);
close 

%% 以下，求强度一阶差分/ROI和值/ROI均值

dcurve = diff(curve);

parfor ii = 1:size(dcurve,2)
    dcurve(:,ii) = lowp(dcurve(:, ii), 0.2, 6, 0.0001, 20,samplerate);
end

Value.dcurve = dcurve;

%% 以下，求强度dcurve对frame的变化趋势

figure;

imshow(dcurve,[]);
title([expname '\_zone' num2str(zone) '光电流二维图，Scan Rate：' num2str(scanrate) 'mV/s'],'fontsize',15);

tmp_savepath = [new_folder  '\' expname '_zone' num2str(zone) ' 光电流二维图.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，求强度dROImean对potential的变化趋势

frame = begin.frame;
dROImean = zeros(1,size(dcurve,1));

parfor ii = 1:size(dcurve,1)
    
    dROImean(ii) = mean(dcurve(ii,:));
    
end

Value.dROImean = dROImean;
Current = potential;

figure

for ii = 1:cycle_num
    
    hold on
    h_name = ['h_' num2str(ii)];
    h_name = plot(potential((1+(ii-1)*2*seg_length):(ii*2*seg_length)),...
        -dROImean((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length)),'linewidth',1.5);
    Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = -dROImean((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
    legend(h_name,['第' num2str(ii) '圈'],'fontsize',30);
    hold off

end

Value.Current = Current;

legend off
legend 
xlabel('Potential','fontsize',15);
ylabel('\DeltaIntensuty','fontsize',15);
title([expname '\_zone' num2str(zone) '光电流CV曲线，Scan Rate：' num2str(scanrate) 'mV/s'],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_光电流CV曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，dROImean对帧数作图，并用断线将不同电势区间进行区分

plot(-dROImean,'k');
hold on
ylim = get(gca,'ylim');
tmp = Value.begin.frame;

for ii = 1:(cycle_num+1)
    
    x = tmp+(ii-1)*2*seg_length;
    plot([x x],ylim,'--','linewidth',1.5);
    
end

hold off
xlabel('Frame','fontsize',15);
ylabel('\Delta Intensity','fontsize',15);
title([expname '\_zone' num2str(zone) '光电流随帧数变化趋势，Scan Rate：' num2str(scanrate) 'mV/s'],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_光电流随帧数变化趋势.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，保存数据 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
% save(tmp_savepath,'Value','-v7.3');
save(tmp_savepath,'Value');

toc

end

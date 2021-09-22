function zone_TaS2_batch(expname,zone,tifpath,mask,begin,scanrate,samplerate,saveroute)

tic

mask = im2bw(imread(mask));

Value.tifDir = dir(fullfile(tifpath,'*.tiff'));
Value.begin = begin;
% Value.potential = w_potentialLine(ScanRate,sampleRate,highpotential,lowpotential);
Value.potential = w_potentialLine(scanrate,samplerate,0,-0.6);

%% 判断是否掉帧

if length(Value.tifDir) <= (begin.frame+length(Value.potential)-1)
    disp(['第' num2str(i) '组数据掉帧严重，中止处理']);
    return
else
    Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)-1));
end

% Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)-1));

%% 生成points/curve矩阵

points = w_ReadTifMaskPoint(tifpath,Value,mask);
Value.points = points;
curve = points;     % 保留原数据points，其后所有的变化值都通过curve进行计算

[m,n] = size(points);
for ii = 1:n
    curve(:,ii) = lowp(points(:, ii), 2, 12, 0.1, 20, 100);
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
x1 = 1:m;
figure;
hold on
plot(x1,avr,'linewidth');
title([expname  '\_zone' num2str(zone) ',Scan Rate:' num2str(scanrate) 'mV/s']);
xlabel('Frames');ylabel('Mean Intensity');

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_平均强度随帧数变化曲线.fig'];
saveas(gcf,fig_savepath);
close 

%% 以下，求强度一阶差分/ROI和值/ROI均值

dcurve = zeros((size(points,1)-1),size(points,2));

dcurve = diff(curve);
parfor ii = 1:size(dcurve,2)
    dcurve(:,ii) = lowp(dcurve(:, ii), 2, 12, 0.1, 20, 100);
end
Value.dcurve = dcurve;

ROIsum = zeros(size(curve,1),1);
for ii = 1:m
    tmp = points(ii,:);
    ROIsum(ii) = sum(tmp);
    clear tmp
end
ROImean = ROIsum/sum(mask(:));
Value.ROIsum = ROIsum;
Value.ROImean = ROImean;

%% 以下，求强度dcurve对frame的变化趋势

figure;
X2 = 1:size(dcurve);
Y2 = figSketch(dcurve);
hold on
plot(X2,Y2(:,1:2),'.k');    % 只用极值作图（极大值/极小值）
xlabel('Frames','fontsize',20);
ylabel('\DeltaIntensity','fontsize',20);
title([expname '\_zone' num2str(zone) '\DeltaIntensity with scanrate:' num2str(scanrate) 'mV/s'],'fontsize',20);

tmp_savepath = [new_folder  '\' expname '_zone' num2str(zone) '_光电流随帧数变化曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，求强度dcurve对potential的变化趋势

Y2 = zeros(length(dcurve));       % 这里的Y2用的是ROImean而不是小娜的figSketch函数得到的极值，
                                  % 按小娜的想法感觉不太对，一则光电流不会体现电容性质，再则忽略了整体而强调个体
parfor ii = 1:length(dcurve)
    
    Y2(ii) = mean(dcurve(ii,:));
end

figure;
tmp = floor(length(Value.potential)/6);
X3(:,1) = Value.potential(1:tmp);
X3(:,2) = Value.potential(tmp+1:2*tmp);
X3(:,3) = Value.potential(2*tmp+1:3*tmp);
X3(:,4) = Value.potential(3*tmp+1:4*tmp);
X3(:,5) = Value.potential(4*tmp+1:5*tmp);
X3(:,6) = Value.potential(5*tmp+1:6*tmp);

tmp2 = Value.begin.frame;
% Y3_1 = Y2((tmp2+1):(length(X3)+tmp2),1:2);
% Y3_2 = Y2((tmp2+1+length(X3)):(length(X3)*2+tmp2),1:2);
% Y3_3 = Y2((tmp2+1+length(X3)*2):(length(X3)*3+tmp2),1:2);
% Y3_4 = Y2((tmp2+1+length(X3)*3):(length(X3)*4+tmp2),1:2);
% Y3_5 = Y2((tmp2+1+length(X3)*4):(length(X3)*5+tmp2),1:2);
% Y3_6 = Y2((tmp2+1+length(X3)*5):(length(X3)*6+tmp2),1:2);

Y3_1 = Y2((tmp2+1):(length(X3)+tmp2));      % 这里的Y2配套Y2 = ROImean使用，而非小娜的figSketch
Y3_2 = Y2((tmp2+1+length(X3)):(length(X3)*2+tmp2));
Y3_2 = Y3_2(end:-1:1);
Y3_3 = Y2((tmp2+1+length(X3)*2):(length(X3)*3+tmp2));
Y3_4 = Y2((tmp2+1+length(X3)*3):(length(X3)*4+tmp2));
Y3_4 = Y3_4(end:-1:1);
Y3_5 = Y2((tmp2+1+length(X3)*4):(length(X3)*5+tmp2));
Y3_6 = Y2((tmp2+1+length(X3)*5):(length(X3)*6+tmp2));
Y3_6 = Y3_6(end:-1:1);

% for i = 1:4
%     clear(eval(['Y3_' num2str(i)]));
% end

% hold on
% for i = 1:4
%     plot(X3(:,i),eval(['Y3_' num2str(i)]));
% end
% hold off

% for ii = 1:6
%     subplot(eval(['23' num2str(ii)]));
%     hold on
%     plot(X3(:,ii),-(eval(['Y3_' num2str(ii)])));
%     title(['第' num2str(ii) '段'],'fontsize',20);
%     xlabel('potential','fontsize',20);
%     ylabel('\DeltaIntensity','fontsize',20);
%     hold off
% end

figure
hold on
for ii = 1:6
    plot(X3(:,ii),-(eval(['Y3_' num2str(ii)])),'linewidth',1.5);
    xlabel('potential','fontsize',20);
    ylabel('\DeltaIntensity','fontsize',20);
    title('光电流CV曲线','fontsize',20);
    legend(['第' num2str(ii) '段'],'fontsize',15);
end
hold off

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_光电流随电势变化曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_path;
close

%% 以下，求强度dROImean对potential的变化趋势

figure;
X4 = X3;
tmp = Value.begin.frame;
ROImean_lp = lowp(ROImean, 2, 12, 0.1, 20, 100);
dROImean = diff(ROImean_lp);
Value.dROImean = dROImean;
Y4_1 = dROImean((tmp+1):(length(X4)+tmp));
Y4_2 = dROImean((tmp+1+length(X4)):(length(X4)*2+tmp));
Y4_3 = dROImean((tmp+1+length(X4)*2):(length(X4)*3+tmp));
Y4_4 = dROImean((tmp+1+length(X4)*3):(length(X4)*4+tmp));
for ii = 1:4
    subplot(eval(['22' num2str(ii)]));
    hold on
    plot(X4(:,ii),eval(['Y4_' num2str(ii)]),'.k');
    title(['第' num2str(ii) '段'],'fontsize',20);
    xlabel('potential','fontsize',20);
    ylabel('\DeltaROImean','fontsize',20);
    hold off
end
tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_ROImean随电势变化曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，求强度dROIsum对potential的变化趋势

figure;
X5 = X3;
tmp = Value.begin.frame;
ROIsum_lp = lowp(ROIsum, 2, 12, 0.1, 20, 100);
dROIsum = diff(ROIsum_lp);
Value.dROIsum = dROIsum;
Y5_1 = dROIsum((tmp+1):(length(X5)+tmp));
Y5_2 = dROIsum((tmp+1+length(X5)):(length(X5)*2+tmp));
Y5_3 = dROIsum((tmp+1+length(X5)*2):(length(X5)*3+tmp));
Y5_4 = dROIsum((tmp+1+length(X5)*3):(length(X5)*4+tmp));
for ii = 1:4
    subplot(eval(['22' num2str(ii)]));
    hold on
    plot(X5(:,ii),eval(['Y5_' num2str(ii)]),'.k');
    title(['第' num2str(ii) '段'],'fontsize',20);
    xlabel('potential','fontsize',20);
    ylabel('\DeltaROIsum','fontsize',20);
    hold off
end
tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_ROIsum随电势变化曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，保存数据 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

toc

end

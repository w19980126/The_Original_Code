Ffunction w_TaS2_batch(expname,zone,tifpath,mask,begin,scanrate,samplerate,saveroute)

tic

mask = imread(mask);
% mask = ~~mask;

Value.tifDir = dir(fullfile(tifpath,'*.tiff'));
Value.begin = begin;
% Value.potential = w_potentialLine(ScanRate,sampleRate,highpotential,lowpotential);
Value.potential = w_potentialLine(scanrate,samplerate,0,-0.6);

if length(Value.tifDir) <= (begin.frame+length(Value.potential)-1)
    disp(['第' num2str(i) '组数据掉帧严重，中止处理']);
    return
else
    Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)-1));
end

% Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)-1));

points = w_ReadTifMaskPoint(tifpath,Value,mask);
Value.points = points;
curve = points;     % 保留原数据points，其后所有的变化值都通过curve进行计算

% <<<<<<<<<<<< 以下，对points每一列进行降噪 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

[m,n] = size(points);
for ii = 1:n
    curve(:,ii) = lowp(points(:, ii), 2, 12, 0.1, 20, 100);
end
Value.curve = curve;
% <<<<<<<<<<<< 以下，求平均强度对帧数Frame的变化曲线 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

avr = zeros(m,1);
parfor ii = 1:m
    avr(ii) = mean(curve(ii,:));
end
Value.avr = avr;     % 所谓平均强度，后来发现即是ROImean，所不同者，这里是对frame作图，后面是对potential作图
x1 = 1:m;
f1 = figure;
hold on
plot(x1,avr,'.k');
title([expname ',Scan Rate:' num2str(scanrate) 'mV/s']);
xlabel('Frames');ylabel('Mean Intensity');
fig_savepath = [saveroute '\' expname  '_MeanIntensity.fig'];
saveas(f1,fig_savepath);
close 

% <<<<<<<<<<<< 以下，求强度一阶差分/ROI和值/ROI均值 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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

% <<<<<<<<<<<< 以下，求强度dcurve对frame的变化趋势 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

f2 = figure;
X2 = 1:size(dcurve);
Y2 = figSketch(dcurve);
hold on
plot(X2,Y2(:,1:2),'.k');    % 只用极值作图（极大值/极小值）
xlabel('Frames','fontsize',20);
ylabel('\DeltaIntensity','fontsize',20);
title([expname '\DeltaIntensity with scanrate:' num2str(scanrate) 'mV/s'],'fontsize',20);
tmp_savepath = [saveroute '\' expname '_Intensity_Vs_frames.fig'];
saveas(f2,tmp_savepath);
clear tmp_savepath;
close

% <<<<<<<<<<<< 以下，求强度dcurve对potential的变化趋势 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

f3 = figure;
tmp = floor(length(Value.potential)/4);
X3(:,1) = Value.potential(1:tmp);
X3(:,2) = Value.potential(tmp+1:2*tmp);
X3(:,3) = Value.potential(2*tmp+1:3*tmp);
X3(:,4) = Value.potential(3*tmp+1:4*tmp);
tmp2 = Value.begin.frame;
Y3_1 = Y2((tmp2+1):(length(X3)+tmp2),1:2);
Y3_2 = Y2((tmp2+1+length(X3)):(length(X3)*2+tmp2),1:2);
Y3_3 = Y2((tmp2+1+length(X3)*2):(length(X3)*3+tmp2),1:2);
Y3_4 = Y2((tmp2+1+length(X3)*3):(length(X3)*4+tmp2),1:2);

% for i = 1:4
%     clear(eval(['Y3_' num2str(i)]));
% end

% hold on
% for i = 1:4
%     plot(X3(:,i),eval(['Y3_' num2str(i)]));
% end
% hold off

for ii = 1:4
    subplot(eval(['22' num2str(ii)]));
    hold on
    plot(X3(:,ii),eval(['Y3_' num2str(ii)]),'.k');
    title(['第' num2str(ii) '段'],'fontsize',20);
    xlabel('potential','fontsize',20);
    ylabel('\DeltaIntensity','fontsize',20);
    hold off
end

tmp_savepath = [saveroute '\' expname '_Intensity_Vs_potential.fig'];
saveas(f3,tmp_savepath);
clear tmp_path;
close

% <<<<<<<<<<<< 以下，求强度dROImean对potential的变化趋势 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

f4 = figure;
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
tmp_savepath = [saveroute '\' expname '_ROImean_Vs_potential.fig'];
saveas(f4,tmp_savepath);
clear tmp_savepath;
close

% <<<<<<<<<<<< 以下，求强度dROIsum对potential的变化趋势 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

f5 = figure;
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
tmp_savepath = [saveroute '\' expname '_ROIsum_Vs_potential.fig'];
saveas(f5,tmp_savepath);
clear tmp_savepath;
close

% <<<<<<<<<<<< 以下，保存数据 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

tmp_savepath = [saveroute '\' expname '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

toc

end

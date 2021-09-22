% 本函数用以处理具体数据
% 小娜用四张图片描述图像强度变化的整体趋势，分别是
%                                              1）ROI内每帧图片的一阶差分的极值随Frame的变化
%                                              2）ROI内每帧图片的一阶差分的极值随Potential的变化
%                                              3）ROI内每帧图片的均值差分的极值随Potential的变化
%                                              4）ROI内每帧图片的和值差分的极值随Potential的变化
function TaS2_batch(expName, tifPath, Mask, begin, rate, saveRoute, zone, Fs)

tic

Value.tifFile = tifPath;        % 将数据一一存入Value结构体中
Value.tifDir = dir(fullfile(Value.tifFile, '*.tiff'));      %读取所有的图片
Value.potential = potentialLine(ScanRate, 100, 0, -1);         %得到四段电势的数据，每一张图片对应一个电势

Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)));       %读取加电后的图像
%？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？好像是某一段电势对应的图片？？
Value.begin = begin;

Mask = imread(Mask);
mask = ~Mask;       % ROI置为1，背景置为0

if sum(mask(:)) == 0
    return
end

points = ReadTifMaskPoint(Value.tifFile, Value.validDir, mask);     %读入mask所覆盖各点信息
                                                                    %各点都已经差减归一
？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
col = size(points, 2);          %此值即是ROI点个数
curve = zeros(size(points));    %意图覆盖所有图片的所有ROI点，新生成矩阵如此
parfor ii = 1:1:col
    % curve(:, ii) = lowp(points(:, ii), 1, 36, 0.1, 20, Fs); % SPR, 20;
    %curve(:, ii) = lowp(points(:, ii), 2, 12, 0.1, 20, Fs); % Bright Field, CV;
    curve(:, ii) = lowp(points(:, ii), 2, 12, 0.1, 20, 100); % Bright Field, CV, Fs = 20;
    %points矩阵的每一列的变量为图片张数/时间，此循环是为了得到各ROI点去除高频噪声后的历时的变化曲线
end

clear points

X = (1:1:(size(curve, 1)-1))';      % 之所以减一，是因为curve差分后行数随之减一，X是为了与dcurve协调的，X的作用相当于时间横轴
dcurve = zeros(size(curve, 1)-1, size(curve, 2));       %生成一个用以存放信号历时一阶导数的矩阵，大小仍只是剔除第一张

parfor ii = 1:col
    dcurve(:, ii) = diff(curve(:, ii));
end

Value.outside = -figSketch(dcurve);
outside = Value.outside;
img = figure('color','w');
hold on
for ii = 1:2
    plot(X, outside(:, ii), '.k')       % 作极值历时散点图，所以取极值者，极值用以表现历时过程中ROI区域信号变化趋势
end
xlabel('Frames'); ylabel('\DeltaIntensity''');
title([expName ' Na_2SO_4 ROI, ' num2str(rate) ' mV/s'])    % 我的天哪，这个命名法太帅了
hold off
figPath = [saveRoute '\' expName '_' num2str(zone) '_roi'];
saveas(img, figPath, 'fig')
% end
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
img2 = figure('color','w');
hold on
% for n = 1:length(Value.maskNames)
% outside = Value.outside;
for ii = 1:2
    plot(Value.potential, outside(:, ii), '.k')
end
% end
xlabel('Potential/V'); ylabel('\DeltaIntensity''');
title([expName ' \DeltaIntensity'' with Potential, Na_2SO_4, ' num2str(rate) ' mV/s'])
hold off
figPath2 = [saveRoute '\' expName '_intensityVSpotential_roi_' num2str(zone)];
saveas(img2, figPath2, 'fig')
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% 这一段与上一段相似，但得到的曲线横轴是电势，且四段电势相互叠加
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% % ROIMEAN
tif0 = double(imread(fullfile(Value.tifFile, Value.tifDir(1).name)));
for ii = Value.begin.frame:(Value.begin.frame+length(Value.potential))
    tif  = (double(imread(fullfile(Value.tifFile, Value.tifDir(ii).name))) - tif0)./tif0;
%     tif  = (double(imread(fullfile(Value.tifFile, Value.tifDir(ii).name))) - tif0);
    Value.ROImean((ii-Value.begin.frame+1), 1) = ROImean(tif, mask);	% ROImean是一个一维向量，其长度等于加电后采集帧数，各元素值为ROI中原始数据均值
    Value.ROIsum((ii-Value.begin.frame+1), 1) = ROIsum(tif, mask);      % ROIsum是一个一维向量，其长度等于加电后采集帧数，各元素值为ROI中原始数据和值
%     Value.ROImean((ii-Value.begin.frame+1), 1) = -ROImean(tif, mask); % TiS2
end
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
temp = lowp(Value.ROImean, 2, 12, 0.1, 20, Fs);         % 均值数据低通降噪后输出
% temp = lowp(Value.ROImean, 2, 12, 0.1, 20, 100); % Low sampleRate
% temp = lowp(Value.ROImean, 5, 22, 0.1, 20, 100); % TiS2 is not good
% enough
Value.dROImean = -diff(temp);           % 一阶差分后存入value
clear temp
% Value.dROImean = -diff(Value.ROImean); % imfilter
img3 = figure('color','w');
plot(Value.potential, Value.dROImean, 'k')
xlabel('Potential/V'); ylabel('\DeltaIntensity''');
title([expName ' Averagered Intensity'' with Potential, Na_2SO_4, ' num2str(rate) ' mV/s'])
hold off
figPath3 = [saveRoute '\' expName '_AveragedintensityVSpotential_roi_' num2str(zone)];
saveas(img3, figPath3, 'fig')
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% 以上，ROI内像素均值一阶差分随电势作图
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
temp = lowp(Value.ROIsum, 2, 12, 0.1, 20, Fs); % Low sampleRate
Value.dROIsum = diff(temp); clear temp
img4 = figure('color', 'w');
plot(Value.potential, Value.dROIsum, 'k')
xlabel('Potential/V'); ylabel('\DeltaIntensity''');
title([expName ' Total Intensity'' with Potential, Na_2SO_4, ' num2str(rate) ' mV/s'])
hold off
figPath4 = [saveRoute '\' expName '_TotalintensityVSpotential_roi_' num2str(zone)];
saveas(img4, figPath4, 'fig')
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% 以上，ROI内像素和值一阶差分随电势作图
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
close all

% Save Value
cellpath = [saveRoute '\' expName '_' num2str(zone) '.mat']; 
save(cellpath, 'Value', '-v7.3');

toc

end

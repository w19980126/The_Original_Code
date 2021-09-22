% ���������Դ����������
% С��������ͼƬ����ͼ��ǿ�ȱ仯���������ƣ��ֱ���
%                                              1��ROI��ÿ֡ͼƬ��һ�ײ�ֵļ�ֵ��Frame�ı仯
%                                              2��ROI��ÿ֡ͼƬ��һ�ײ�ֵļ�ֵ��Potential�ı仯
%                                              3��ROI��ÿ֡ͼƬ�ľ�ֵ��ֵļ�ֵ��Potential�ı仯
%                                              4��ROI��ÿ֡ͼƬ�ĺ�ֵ��ֵļ�ֵ��Potential�ı仯
function TaS2_batch(expName, tifPath, Mask, begin, rate, saveRoute, zone, Fs)

tic

Value.tifFile = tifPath;        % ������һһ����Value�ṹ����
Value.tifDir = dir(fullfile(Value.tifFile, '*.tiff'));      %��ȡ���е�ͼƬ
Value.potential = potentialLine(ScanRate, 100, 0, -1);         %�õ��Ķε��Ƶ����ݣ�ÿһ��ͼƬ��Ӧһ������

Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)));       %��ȡ�ӵ���ͼ��
%������������������������������������������������������������������������������������������������ĳһ�ε��ƶ�Ӧ��ͼƬ����
Value.begin = begin;

Mask = imread(Mask);
mask = ~Mask;       % ROI��Ϊ1��������Ϊ0

if sum(mask(:)) == 0
    return
end

points = ReadTifMaskPoint(Value.tifFile, Value.validDir, mask);     %����mask�����Ǹ�����Ϣ
                                                                    %���㶼�Ѿ������һ
����������������������������������������������������������������������������������������������������������������
col = size(points, 2);          %��ֵ����ROI�����
curve = zeros(size(points));    %��ͼ��������ͼƬ������ROI�㣬�����ɾ������
parfor ii = 1:1:col
    % curve(:, ii) = lowp(points(:, ii), 1, 36, 0.1, 20, Fs); % SPR, 20;
    %curve(:, ii) = lowp(points(:, ii), 2, 12, 0.1, 20, Fs); % Bright Field, CV;
    curve(:, ii) = lowp(points(:, ii), 2, 12, 0.1, 20, 100); % Bright Field, CV, Fs = 20;
    %points�����ÿһ�еı���ΪͼƬ����/ʱ�䣬��ѭ����Ϊ�˵õ���ROI��ȥ����Ƶ���������ʱ�ı仯����
end

clear points

X = (1:1:(size(curve, 1)-1))';      % ֮���Լ�һ������Ϊcurve��ֺ�������֮��һ��X��Ϊ����dcurveЭ���ģ�X�������൱��ʱ�����
dcurve = zeros(size(curve, 1)-1, size(curve, 2));       %����һ�����Դ���ź���ʱһ�׵����ľ��󣬴�С��ֻ���޳���һ��

parfor ii = 1:col
    dcurve(:, ii) = diff(curve(:, ii));
end

Value.outside = -figSketch(dcurve);
outside = Value.outside;
img = figure('color','w');
hold on
for ii = 1:2
    plot(X, outside(:, ii), '.k')       % ����ֵ��ʱɢ��ͼ������ȡ��ֵ�ߣ���ֵ���Ա�����ʱ������ROI�����źű仯����
end
xlabel('Frames'); ylabel('\DeltaIntensity''');
title([expName ' Na_2SO_4 ROI, ' num2str(rate) ' mV/s'])    % �ҵ����ģ����������̫˧��
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
% ��һ������һ�����ƣ����õ������ߺ����ǵ��ƣ����Ķε����໥����
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% % ROIMEAN
tif0 = double(imread(fullfile(Value.tifFile, Value.tifDir(1).name)));
for ii = Value.begin.frame:(Value.begin.frame+length(Value.potential))
    tif  = (double(imread(fullfile(Value.tifFile, Value.tifDir(ii).name))) - tif0)./tif0;
%     tif  = (double(imread(fullfile(Value.tifFile, Value.tifDir(ii).name))) - tif0);
    Value.ROImean((ii-Value.begin.frame+1), 1) = ROImean(tif, mask);	% ROImean��һ��һά�������䳤�ȵ��ڼӵ��ɼ�֡������Ԫ��ֵΪROI��ԭʼ���ݾ�ֵ
    Value.ROIsum((ii-Value.begin.frame+1), 1) = ROIsum(tif, mask);      % ROIsum��һ��һά�������䳤�ȵ��ڼӵ��ɼ�֡������Ԫ��ֵΪROI��ԭʼ���ݺ�ֵ
%     Value.ROImean((ii-Value.begin.frame+1), 1) = -ROImean(tif, mask); % TiS2
end
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
temp = lowp(Value.ROImean, 2, 12, 0.1, 20, Fs);         % ��ֵ���ݵ�ͨ��������
% temp = lowp(Value.ROImean, 2, 12, 0.1, 20, 100); % Low sampleRate
% temp = lowp(Value.ROImean, 5, 22, 0.1, 20, 100); % TiS2 is not good
% enough
Value.dROImean = -diff(temp);           % һ�ײ�ֺ����value
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
% ���ϣ�ROI�����ؾ�ֵһ�ײ���������ͼ
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
% ���ϣ�ROI�����غ�ֵһ�ײ���������ͼ
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
close all

% Save Value
cellpath = [saveRoute '\' expName '_' num2str(zone) '.mat']; 
save(cellpath, 'Value', '-v7.3');

toc

end

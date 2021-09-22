function CV_batch(expname,zone,tifpath,mask,begin,scanrate,samplerate,saveroute,...
    cycle_num,high_potential,low_potential)
        
% ������ʹ���������ȦCV�����zone�����ݵ�
% �õ������ݰ�����
% 1��ROImean����֡���ı仯����
% 2��dROImean���ڵ��Ƶı仯���ƣ��������CV����
% 3������������Ӧ��Value�ṹ

tic

%% �ж�mask�Ƿ���ROI����Ϊ1����ROI����Ϊ0��������ǣ���mask��������

mask = logical(imread(mask));
tmp1 = mask(1,1);   % ���ڳ�ʶ�жϣ���һ�����ز�������ROI����tmp1 = 1����mask����
if tmp1 > 0 
    
    mask = ~mask;
    
end

roi = mask;
SE = strel('disk',1);
roi_edge = edge(roi,'canny');
roi_edge = imdilate(roi_edge,SE);
Value.roi = roi;
Value.roi_edge = roi_edge;

%% �������ݴ���Value�ṹ����

Value.tifDir = dir(fullfile(tifpath,'*.tiff'));
Value.begin = begin;
[potential,seg_length] = w_potentialLine(scanrate,samplerate,cycle_num,high_potential,low_potential);
Value.seg_length = seg_length;
Value.potential = potential;

%% �ж��Ƿ��֡

if length(Value.tifDir) <= (begin.frame+length(Value.potential)-1)
    
    disp(['��' num2str(1i) '�����ݵ�֡���أ���ֹ����']);
    return
    
else
    
    Value.validDir = Value.tifDir(begin.frame:(begin.frame+length(Value.potential)-1));
    
end

%% ����points/curve����

points = w_ReadTifMaskPoint(tifpath,Value,mask);
Value.points = points;
curve = points;     % ����ԭ����points��������еı仯ֵ��ͨ��curve���м���

[m,n] = size(points);

for ii = 1:n
    curve(:,ii) = lowp(points(:,ii), 20*0.01, 6, 0.0001, 20, 50);
end

Value.curve = curve;

%% �����µ��ļ���������������

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % ����saveas�������޷���������

%% ���£���ƽ��ǿ�ȶ�֡��Frame�ı仯����

avr = zeros(m,1);

parfor ii = 1:m
    avr(ii) = mean(curve(ii,:));
end

Value.avr = avr;     % ��νƽ��ǿ�ȣ��������ּ���ROImean������ͬ�ߣ������Ƕ�frame��ͼ�������Ƕ�potential��ͼ
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
title([expname  '\_zone' num2str(zone) '����ǿ��֡���仯����,Scan Rate��' num2str(scanrate) 'mV/s'],'fontsize',15);
xlabel('Frames','fontsize',15);
ylabel('Mean Intensity','fontsize',15);
set(gca,'fontsize',15)
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_��ǿ��֡���仯����.fig'];
saveas(gcf,fig_savepath);
close 

%% ���£���ǿ��һ�ײ��/ROI��ֵ/ROI��ֵ

dcurve = diff(curve);

parfor ii = 1:size(dcurve,2)
    dcurve(:,ii) = lowp(dcurve(:, ii), 0.2, 6, 0.0001, 20,samplerate);
end

Value.dcurve = dcurve;

%% ���£���ǿ��dcurve��frame�ı仯����

figure;

imshow(dcurve,[]);
title([expname '\_zone' num2str(zone) '�������άͼ��Scan Rate��' num2str(scanrate) 'mV/s'],'fontsize',15);

tmp_savepath = [new_folder  '\' expname '_zone' num2str(zone) ' �������άͼ.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£���ǿ��dROImean��potential�ı仯����

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
    legend(h_name,['��' num2str(ii) 'Ȧ'],'fontsize',30);
    hold off

end

Value.Current = Current;

legend off
legend 
xlabel('Potential','fontsize',15);
ylabel('\DeltaIntensuty','fontsize',15);
title([expname '\_zone' num2str(zone) '�����CV���ߣ�Scan Rate��' num2str(scanrate) 'mV/s'],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_�����CV����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£�dROImean��֡����ͼ�����ö��߽���ͬ���������������

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
title([expname '\_zone' num2str(zone) '�������֡���仯���ƣ�Scan Rate��' num2str(scanrate) 'mV/s'],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_�������֡���仯����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£��������� 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
% save(tmp_savepath,'Value','-v7.3');
save(tmp_savepath,'Value');

toc

end

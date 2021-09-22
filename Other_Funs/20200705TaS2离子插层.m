%% 2020/7/5����TaS2����������������Ӳ��

%% expTab�ṹ�������

expcell = cell(2,10);
fields = {'expname','zone','tifpath','mask','begin','scanrate','samplerate','saveroute','figpath','datapath'};
expTab = cell2struct(expcell,fields',2);
clear expcell fields
save([expTab(1).saveroute '\expTab.mat'],'expTab');
%% ��fig������ȡ��������,ֻ�ǵ�δ����data����ʱʹ�ñ��ű��ȼ�

load('D:\TiS2\200806_TiS2\_Result\expTab.mat');

hwait = waitbar(0,'�Ϳ쿪ʼ������');

group_num = size(expTab,1);

for i = 1:group_num
    mes = ['���ڴ����' num2str(i) '������,һ����' num2str(group_num) '������'];
    waitbar(i/group_num,hwait,mes);
    uiopen(expTab(i).figpath,1);
    h = findobj(gca,'type','line');
    t = get(h,'xdata');
    t = cell2mat(t);
    t(1:2,:) = [];
    data = get(h,'ydata');
    data = cell2mat(data);
    close 
    tmp_path = ['G:\wanjunhao\TaS2_20200630_ITO\_Timer\Data_' expTab(i).expName '.mat'];
    save(tmp_path,'t','data');
end

clear data
clear t
clear mes
clear h
clear i
clear tmp_path
delete(hwait);

%% triggerTime

for i = 1:size(expTab,1)
    
    load(expTab(i).datapath);   

    Fs = expTab(i).samplerate;
%     data = data';       % ע�͵������������������Ľű�ʹ��
%     t = t';
    begin = w_triggerTime(data,t,Fs);
    expTab(i).begin = begin;
    clear begin
    
end

clear data    % ͬ�����������ű�ʹ�õ�
clear t
clear i
save([expTab(1).saveroute '\expTab.mat'],'expTab');

%% ��ʼ������������

% ���ȶ����������ݴ���Ļ����ļ�����expTab
load([expTab(1).saveroute 'expTab.mat');

hwait = waitbar(0,['��û��ʼ��']);

for i = 2:size(expTab,1)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    mask = expTab(i).mask;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    
    w_TaS2_batch(expname,zone,tifpath,mask,begin,scanrate,samplerate,saveroute);
    
    mes = ['����ɽ��ȣ�' num2str(i/size(expTab,1))];
    waitbar(i/size(expTab,1),hwait,mes)
end

delete(hwait);

%% ��ʼ������������
%  2020��8��6��TiS2����Ũ���ݶȲ��ʵ�鴦�����ڹ۲�
%  ������ͬ����ͬʱ����5��ROI�������޸Ĵ������½�����������

% ���ȶ����������ݴ���Ļ����ļ�����expTab
load( [expTab(1).saveroute '\expTab.mat']);

% hwait = waitbar(0,['��û��ʼ��']);

parfor i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    mask_path = expTab(i).mask;
    
    for j = 1:zone
        
        mask = [mask_path '\' expname '\' expname '_Mask_' num2str(j) '.tif'];
        zone_TaS2_batch(expname,j,tifpath,mask,begin,scanrate,samplerate,saveroute);
        
    end
    
%     mes = ['����ɽ��ȣ�' num2str(i/size(expTab,1))];
%     waitbar(i/size(expTab,1),hwait,mes)
end

% delete(hwait);
























    
%% 2020/7/5处理TaS2碱金属碱土金属离子插层

%% expTab结构体的生成

expcell = cell(2,10);
fields = {'expname','zone','tifpath','mask','begin','scanrate','samplerate','saveroute','figpath','datapath'};
expTab = cell2struct(expcell,fields',2);
clear expcell fields
save([expTab(1).saveroute '\expTab.mat'],'expTab');
%% 从fig里面提取出数据来,只是当未保存data数据时使用本脚本救急

load('D:\TiS2\200806_TiS2\_Result\expTab.mat');

hwait = waitbar(0,'就快开始处理了');

group_num = size(expTab,1);

for i = 1:group_num
    mes = ['正在处理第' num2str(i) '组数据,一共有' num2str(group_num) '组数据'];
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
%     data = data';       % 注释掉的这两句配合着上面的脚本使用
%     t = t';
    begin = w_triggerTime(data,t,Fs);
    expTab(i).begin = begin;
    clear begin
    
end

clear data    % 同样是配合上面脚本使用的
clear t
clear i
save([expTab(1).saveroute '\expTab.mat'],'expTab');

%% 开始批量处理数据

% 首先读入所有数据处理的基础文件——expTab
load([expTab(1).saveroute 'expTab.mat');

hwait = waitbar(0,['还没开始呢']);

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
    
    mes = ['已完成进度：' num2str(i/size(expTab,1))];
    waitbar(i/size(expTab,1),hwait,mes)
end

delete(hwait);

%% 开始批量处理数据
%  2020年8月6日TiS2离子浓度梯度插层实验处理，由于观察
%  区域相同，且同时都有5块ROI，所以修改代码如下进行批量处理

% 首先读入所有数据处理的基础文件——expTab
load( [expTab(1).saveroute '\expTab.mat']);

% hwait = waitbar(0,['还没开始呢']);

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
    
%     mes = ['已完成进度：' num2str(i/size(expTab,1))];
%     waitbar(i/size(expTab,1),hwait,mes)
end

% delete(hwait);
























    
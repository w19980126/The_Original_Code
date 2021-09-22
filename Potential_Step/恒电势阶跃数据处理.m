%% 恒电势阶跃实验数据处理

% 本脚本暂时只支持阶跃时间相同的数据

%% expTab结构体的生成

expcell = cell(3,10);
fields = {'expname','zone','tifpath','mask','begin','PS_duration','samplerate','saveroute','figpath','datapath'};
expTab = cell2struct(expcell,fields',2);
clear expcell fields
save([expTab(1).saveroute '\expTab.mat'],'expTab');

%% PS_triggertime
load('H:\TiS2\20200820_TiS2\_Reslut\expTab.mat');

for i = 1:length(expTab)
    
    load(expTab(i).datapath);
    Fs = expTab(i).samplerate;
    PS_duration = expTab(i).PS_duration;
    begin = PS_triggertime(t,data,PS_duration,Fs);
    expTab(i).begin = begin;
    clear begin
    
end

save([expTab(1).saveroute '\expTab.mat'],'expTab');

%% 批量处理数据

load('H:\TiS2\20200820_TiS2\_Reslut\expTab.mat');

hwaitbar = waitbar(0,'还没开始呢');

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    begin = expTab(i).begin;
    PS_duration = expTab(i).PS_duration;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    mask_path = expTab(i).mask;
    
    PS_batch(expname,tifpath,begin,PS_duration,samplerate,saveroute,mask_path);
    
    mes = ['已完成' num2str(i) '组数据,总共有' num2str(length(expTab)) '组数据'];
    waitbar(i/length(expTab),hwaitbar,mes);
    
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
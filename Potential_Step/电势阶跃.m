%% 多电势阶跃实验数据处理

%% expTab结构体的生成

fields = {'expname','zone','tifpath','mask','begin','samplerate','saveroute',...
    'figpath','datapath','seg_num','first_dur','mid_dur','end_dur'};
expcell = cell(4,length(fields));
expTab = cell2struct(expcell,fields',2);
clear expcell fields
save([expTab(1).saveroute '\PS_expTab.mat'],'expTab');

%% PS_triggertime

load('H:\TiS2\20200820_TiS2\_Reslut\PS_expTab.mat');

for i = 1:length(expTab)
    
    load(expTab(i).datapath);
    Fs = expTab(i).samplerate;
    first_dur = expTab(i).first_dur;
    begin = PS_triggertime(t,data,first_dur,Fs);
    expTab(i).begin = begin;
    clear begin
    
end

clear i t Fs data

save([expTab(1).saveroute '\PS_expTab.mat'],'expTab');

%% 从原始数据中得到points矩阵

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    begin = expTab(i).begin;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    seg_num = expTab(i).seg_num;
    first_dur = expTab(i).first_dur;
    mid_dur = expTab(i).mid_dur;
    end_dur = expTab(i).end_dur;
    mask_path = expTab(i).mask;
    
    for j = 1:zone
        
        mask = [mask_path num2str(j) '.tif'];
        PS_batch_for_points(expname,tifpath,begin,j,saveroute,mask_path);
        
    end
  
end

%% 批量处理数据

load('H:\TiS2\20200820_TiS2\_Reslut\PS_expTab.mat');

% hwaitbar = waitbar(0,'还没开始呢');

for i = 2:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    begin = expTab(i).begin;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    seg_num = expTab(i).seg_num;
    first_dur = expTab(i).first_dur;
    mid_dur = expTab(i).mid_dur;
    end_dur = expTab(i).end_dur;
    mask_path = expTab(i).mask;
    
    for j = 1:zone
        
        tic
        
        mask = [mask_path num2str(j) '.tif'];
        PSbatch(expname,j,tifpath,begin,samplerate,saveroute,mask,seg_num,first_dur,...
    mid_dur,end_dur)
        
        toc
        
    end
    
%     mes = ['已完成' num2str(i) '组数据,总共有' num2str(length(expTab)) '组数据'];
%     waitbar(i/length(expTab),hwaitbar,mes);
    
end













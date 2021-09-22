%% ����ƽ�Ծʵ�����ݴ���

%% expTab�ṹ�������

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

%% ��ԭʼ�����еõ�points����

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

%% ������������

load('H:\TiS2\20200820_TiS2\_Reslut\PS_expTab.mat');

% hwaitbar = waitbar(0,'��û��ʼ��');

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
    
%     mes = ['�����' num2str(i) '������,�ܹ���' num2str(length(expTab)) '������'];
%     waitbar(i/length(expTab),hwaitbar,mes);
    
end













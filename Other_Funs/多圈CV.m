%% 多圈CV扫描数据处理

%% expTab结构体的生成

fields = {'expname','zone','tifpath','mask','begin','scanrate','samplerate','saveroute',...
    'figpath','datapath','cycle_num','high_potential','low_potential'};
expcell = cell(4,length(fields));
expTab = cell2struct(expcell,fields',2);
clear expcell fields
save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

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

clear data t i Fs
close 

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% 开始批量处理数据

load( [expTab(1).saveroute '\CV_expTab.mat']);

% hwait = waitbar(0,['还没开始呢']);
tic

for i = 4:length(expTab)
    
    tic
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    mask_path = expTab(i).mask;
    cycle_num = expTab(i).cycle_num;
    high_potential = expTab(i).high_potential;
    low_potential = expTab(i).low_potential;
    
    for j = 1:zone
        
        tic
        
        mask = [mask_path num2str(j) '.tif'];
        CV_batch(expname,j,tifpath,mask,begin,scanrate,samplerate,saveroute,...
            cycle_num,high_potential,low_potential);
        
        toc
        
    end

    load(fullfile(expTab(i).saveroute,expTab(i).expname,['zone' num2str(j)],[expTab(i).expname...
    '_zone' num2str(j) '_Value.mat']));
    
    first_tif = imread(fullfile(Value.tifDir(1).folder,Value.tifDir(1).name));
    [~,loc] = max(Value.avr(:));
    intercated_tif = imread(fullfile(Value.tifDir(loc).folder,Value.tifDir(loc).name))-first_tif;
    
    maskedge = zeros(480,640);
    for j = 1:zone
        
        load(fullfile(expTab(i).saveroute,expTab(i).expname,['zone' num2str(j)],[expTab(i).expname...
            '_zone' num2str(j) '_Value.mat']));
        tmp = Value.roi_edge;
        maskedge = maskedge + tmp;
        
    end
    maskedge = im2bw(maskedge);
    expTab(i).maskedge = maskedge;

    figure
    p_fig1 = pseudo_color(first_tif);
    title('未插层示意图','fontsize',15);
    tmp_savepath = [expTab(i).saveroute '\' expTab(i).expname '\' expTab(i).expname '未插层示意图.fig'];
    saveas(gcf,tmp_savepath);
    
%     figure
%     image_overlap(p_fig1,maskedge);
%     title('未插层加ROI示意图','fontsize',15);
%     tmp_savepath = [expTab(i).saveroute '\' expTab(i).expname '\' expTab(i).expname '未插层加ROI示意图.fig'];
%     saveas(gcf,tmp_savepath);

    figure
    p_fig2 = pseudo_color(intercated_tif);
    title('完全插入后示意图','fontsize',15);
    tmp_savepath = [expTab(i).saveroute '\' expTab(i).expname '\' expTab(i).expname '完全插入后示意图.fig'];
    saveas(gcf,tmp_savepath);

%     figure
%     image_overlap(p_fig2,maskedge);
%     title('完全插入后加ROI示意图','fontsize',15);
%     tmp_savepath = [expTab(i).saveroute '\' expTab(i).expname '\' expTab(i).expname '未插层示意图.fig'];
%     saveas(gcf,tmp_savepath);

    close all
    clear tmp_savepath
               
%     mes = ['已完成进度：' num2str(i/size(expTab,1))];
%     waitbar(i/size(expTab,1),hwait,mes)
    toc

end

% delete(hwait);
toc




function expTab_function

%% 简化输入
    
    SSD_number = input('请输入固态硬盘编号（如H/D之类）：');
    experiment_path = uigetdir(['"' SSD_number ':\"'],'选择实验批次，如20201216：');
    
    mask_path = fullfile(experiment_path,'_Mask');
    mask_dir = dir(mask_path);
    mask_dir(1:2) = [];
    len = input('请输入PS相关的数据序号(排除掉不处理的数据):');
    mask_dir = mask_dir(len);
    
    TIFF_path = fullfile(experiment_path,'TIFF');
    tiffpath_dir = dir(TIFF_path);
    tiffpath_dir(1:2) = [];
    len = input('请输入PS相关的TIFF数据序号(不排除掉不处理的数据):');
    tiffpath_dir = tiffpath_dir(len);
    
    Timer_path = fullfile(experiment_path,'_Timer');
    fig_dir = dir(fullfile(Timer_path,'*.fig'));
    fig_dir = fig_dir(len);
    data_dir = dir(fullfile(Timer_path,'*.mat'));
    data_dir = data_dir(len);
    
    for ii = 1:length(len)

        expTab(ii).saveroute = fullfile(experiment_path,'Result');
        expTab(ii).expname = mask_dir(ii).name;
        zonedir = dir(fullfile(mask_path,mask_dir(ii).name,'*.tif'));
        expTab(ii).zone = length(zonedir);
        expTab(ii).tifpath = fullfile(TIFF_path,tiffpath_dir(ii).name);
        expTab(ii).mask = fullfile(mask_path,mask_dir(ii).name);
        expTab(ii).samplerate = 100;
        expTab(ii).figpath = fullfile(Timer_path,fig_dir(ii).name);
        expTab(ii).datapath = fullfile(Timer_path,data_dir(ii).name);
        expTab(ii).seg_num = 3;
        expTab(ii).first_dur = 3;
        expTab(ii).mid_dur = 15;
        expTab(ii).end_dur = 3;
        expTab(ii).I_background = input(['请输入第' num2str(ii) '组数据背景信号的强度：']);

    end
    
    mkdir(fullfile(experiment_path,'Result'));
    save([expTab(1).saveroute '\PS_expTab.mat'],'expTab');
    load([expTab(1).saveroute '\PS_expTab.mat']);
    
end





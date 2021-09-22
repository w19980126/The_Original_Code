function expTab_function

%% ������
    
    SSD_number = input('�������̬Ӳ�̱�ţ���H/D֮�ࣩ��');
    experiment_path = uigetdir(['"' SSD_number ':\"'],'ѡ��ʵ�����Σ���20201216��');
    
    mask_path = fullfile(experiment_path,'_Mask');
    mask_dir = dir(mask_path);
    mask_dir(1:2) = [];
    len = input('������CV��ص��������:');
    mask_dir = mask_dir(len);
    
    TIFF_path = fullfile(experiment_path,'TIFF');
    tiffpath_dir = dir(TIFF_path);
    tiffpath_dir(1:2) = [];
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
        expTab(ii).scanrate = 100;
        expTab(ii).samplerate = 100;
        expTab(ii).figpath = fullfile(Timer_path,fig_dir(ii).name);
        expTab(ii).datapath = fullfile(Timer_path,data_dir(ii).name);

        expTab(ii).cycle_num = 1;
        expTab(ii).high_potential = 0;
        expTab(ii).low_potential = -0.6;
        expTab(ii).I_background = 12000;

    end
    
    mkdir(fullfile(experiment_path,'Result'));
    save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');
    load([expTab(1).saveroute '\CV_expTab.mat']);
    
end





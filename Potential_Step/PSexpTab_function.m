function expTab_function

%% ������
    
    SSD_number = input('�������̬Ӳ�̱�ţ���H/D֮�ࣩ��');
    experiment_path = uigetdir(['"' SSD_number ':\"'],'ѡ��ʵ�����Σ���20201216��');
    
    mask_path = fullfile(experiment_path,'_Mask');
    mask_dir = dir(mask_path);
    mask_dir(1:2) = [];
    len = input('������PS��ص��������(�ų��������������):');
    mask_dir = mask_dir(len);
    
    TIFF_path = fullfile(experiment_path,'TIFF');
    tiffpath_dir = dir(TIFF_path);
    tiffpath_dir(1:2) = [];
    len = input('������PS��ص�TIFF�������(���ų��������������):');
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
        expTab(ii).I_background = input(['�������' num2str(ii) '�����ݱ����źŵ�ǿ�ȣ�']);

    end
    
    mkdir(fullfile(experiment_path,'Result'));
    save([expTab(1).saveroute '\PS_expTab.mat'],'expTab');
    load([expTab(1).saveroute '\PS_expTab.mat']);
    
end





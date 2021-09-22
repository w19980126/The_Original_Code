%% 生成expTab结构体并填写数据

PSexpTab_function;

%% PS_triggertime

for ii = 1:length(expTab)
    
    load(expTab(ii).datapath);
    Fs = expTab(ii).samplerate;
    first_dur = expTab(ii).first_dur;
    begin = PS_triggertime(t,data,first_dur,Fs);
    expTab(ii).begin = begin;
    clear begin
    
end

clear ii t Fs data first_dur

save([expTab(1).saveroute '\PS_expTab.mat'],'expTab');

%% 从原始数据中得到points矩阵

for ii = 1:length(expTab)
    
    expname = expTab(ii).expname;
    zone = expTab(ii).zone;
    tifpath = expTab(ii).tifpath;
    begin = expTab(ii).begin;
    samplerate = expTab(ii).samplerate;
    saveroute = expTab(ii).saveroute;
    seg_num = expTab(ii).seg_num;
    first_dur = expTab(ii).first_dur;
    mid_dur = expTab(ii).mid_dur;
    end_dur = expTab(ii).end_dur;
    mask_path = expTab(ii).mask;
    maskdir = dir(fullfile(mask_path,'*.tif'));
    I_background = expTab(ii).I_background;
    
    for jj = 1:zone
        
        zonepath = fullfile(mask_path,maskdir(jj).name);
        PS_batch_for_points(expname,tifpath,begin,jj,saveroute,zonepath,I_background);
        
    end
  
end

%% smooth和高斯滤波处理

说明：滤波之前需在GUI中对任一条points曲线进行cheby滤波已得到合适的滤波参数，在此基础上对
各points曲线进行滤波，从而得到滤波后的curve矩阵
而且使用光强和OD数据的切比雪夫滤波参数不同

span = 10;

for kk = 1:length(expTab)
    
    zone = expTab(kk).zone;

    for jj = 1:zone

        for ii = 1:length(expTab)

            expname = expTab(ii).expname;
            saveroute = expTab(ii).saveroute;
            Fs = expTab(ii).samplerate;
            valueroute = fullfile(saveroute,expname,[expname '_zone' num2str(jj) '_Value.mat']);
            load(valueroute);
            T_avr = Value.T_avr;
            OD_avr = Value.OD_avr;

            G_OD_avr = Gaussianfilter(10,5,OD_avr);
            G_T_avr = Gaussianfilter(10,5,T_avr);

            S_OD_avr = smooth(OD_avr,span);
            S_T_avr = smooth(T_avr,span);

            Value.S_T_avr = S_T_avr;     
            Value.dS_T_avr = diff(S_T_avr);  
            Value.S_OD_avr = S_OD_avr;
            Value.dS_OD_avr = diff(S_OD_avr);

            Value.G_T_avr = G_T_avr;
            Value.G_OD_avr = G_OD_avr;
            Value.dG_T_avr = diff(G_T_avr);
            Value.dG_OD_avr = diff(G_OD_avr);

            save(valueroute,'Value','-v7.3');

        end

    end
    
end

%% 对原始数据进行平滑和高斯滤波/切比雪夫滤波并作图

需手动输入明暗状况LD、平滑参数和高斯滤波参数、

for ii = 1:length(expTab)
    
    expname = expTab(ii).expname;
    zone = expTab(ii).zone;
    begin = expTab(ii).begin;
    saveroute = expTab(ii).saveroute;
    samplerate = expTab(ii).samplerate;
    first_dur = expTab(ii).first_dur;
    mid_dur = expTab(ii).mid_dur;
    end_dur = expTab(ii).end_dur; 

    parfor jj = 1:zone        
            
        PS_Batch_For_Fig(expname,zone,begin,saveroute,samplerate,first_dur,mid_dur,end_dur);
          
    end
    
end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

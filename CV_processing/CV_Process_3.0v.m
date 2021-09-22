%% ����expTab�ṹ�岢��д����

expTab_function;

%% triggerTime

for ii = 1:length(expTab)
    
    load(expTab(ii).datapath);   

    Fs = expTab(ii).samplerate;
    begin = w_triggerTime(data,t,Fs);
    expTab(ii).begin = begin;
    
end

close 
clear data    % ͬ�����������ű�ʹ�õ�
clear t
clear ii
clear Fs
clear begin

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% ��ԭʼ�����еõ�points�����mean�������avr��tifDir��seg_length��potential��

for ii = 1:length(expTab)
    
    expname = expTab(ii).expname;
    zone = expTab(ii).zone;
    tifpath = expTab(ii).tifpath;
    begin = expTab(ii).begin;
    scanrate = expTab(ii).scanrate;
    samplerate = expTab(ii).samplerate;
    saveroute = expTab(ii).saveroute;
    mask_path = expTab(ii).mask;
    maskdir = dir(fullfile(mask_path,'*.tif'));
    cycle_num = expTab(ii).cycle_num;
    high_potential = expTab(ii).high_potential;
    low_potential = expTab(ii).low_potential;
    I_background = expTab(ii).I_background;
    
    parfor jj = 1:zone        
        
        zonepath = fullfile(mask_path,maskdir(jj).name);
        CV_batch_for_points(expname,jj,tifpath,zonepath,begin,scanrate,samplerate,saveroute,...
    cycle_num,high_potential,low_potential,I_background);
        
    end

end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');
clear all


%% cheby�˲���smooth�͸�˹�˲�����

˵�����˲�֮ǰ����GUI�ж���һ��points���߽���cheby�˲��ѵõ����ʵ��˲��������ڴ˻����϶�
��points���߽����˲����Ӷ��õ��˲����curve����
����ʹ�ù�ǿ��OD���ݵ��б�ѩ���˲�������ͬ

span = 10;

for kk = 1:length(expTab)
    
    zone = expTab(kk).zone;

    for jj = 1:zone

            expname = expTab(kk).expname;
            saveroute = expTab(kk).saveroute;
            Fs = expTab(kk).samplerate;
            valueroute = fullfile(saveroute,expname,[expname '_zone' num2str(jj) '_Value.mat']);
            load(valueroute);
            T_avr = Value.T_avr;
%             OD_avr = Value.OD_avr;
            seg_length = Value.seg_length;

%             G_OD_avr = Gaussianfilter(10,5,OD_avr);
            G_T_avr = Gaussianfilter(10,5,T_avr);

%             cheby_OD_avr = lowp(OD_avr,7.5,35,3,50,Fs);
%             cheby_T_avr = lowp(T_avr,7.5,35,3,50,Fs);
% 
%             if span<=1;
%                 l = round(span*seg_length);
%             elseif span >1
%                 l = span;
%             end  
% 
%             S_OD_avr = smooth(OD_avr,span);
%             S_T_avr = smooth(T_avr,l);
% 
%             Value.S_T_avr = S_T_avr;     
%             Value.dS_T_avr = diff(S_T_avr);  
%             Value.S_OD_avr = S_OD_avr;
%             Value.dS_OD_avr = diff(S_OD_avr);

            Value.G_T_avr = G_T_avr;
%             Value.G_OD_avr = G_OD_avr;
            Value.dG_T_avr = diff(G_T_avr);
%             Value.dG_OD_avr = diff(G_OD_avr);

%             Value.cheby_T_avr = cheby_T_avr;     
%             Value.dcheby_T_avr = diff(cheby_T_avr);  
%             Value.cheby_OD_avr = cheby_OD_avr;
%             Value.dcheby_OD_avr = diff(cheby_OD_avr);

            save(valueroute,'Value','-v7.3');

    end
    
end

clear all

%% ��ԭʼ���ݽ���ƽ���͸�˹�˲�/�б�ѩ���˲�����ͼ

���ֶ���������״��LD��ƽ�������͸�˹�˲�������

for ii = 1:length(expTab)
    
    expname = expTab(ii).expname;
    zone = expTab(ii).zone;
    begin = expTab(ii).begin;
    scanrate = expTab(ii).scanrate;
    saveroute = expTab(ii).saveroute;
    cycle_num = expTab(ii).cycle_num;

    parfor j = 1:zone        
            
        CV_Batch_For_Trans_Fig(expname,j,begin,scanrate,saveroute,cycle_num);
%         CV_Batch_For_OD_Fig(expname,j,begin,scanrate,saveroute,cycle_num);
%         CV_Batch_For_Fig(expname,j,begin,scanrate,saveroute,cycle_num);
          
    end
    
end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

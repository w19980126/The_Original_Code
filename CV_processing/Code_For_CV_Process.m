%% ��ȦCVɨ�����ݴ���

%% expTab�ṹ�������

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
%     data = data';       % ע�͵������������������Ľű�ʹ��
%     t = t';
    begin = w_triggerTime(data,t,Fs);
    expTab(i).begin = begin;
    clear begin
    
end

clear data    % ͬ�����������ű�ʹ�õ�
clear t
clear i
clear Fs

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% ��ԭʼ�����еõ�points�����mean�������avr��tifDir��seg_length��potential��

load( [expTab(1).saveroute '\expTab.mat']);

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    tifpath = expTab(i).tifpath;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    samplerate = expTab(i).samplerate;
    saveroute = expTab(i).saveroute;
    mask_path = expTab(i).mask;
    maskdir = dir(fullfile(mask_path,'*.tif'));
    cycle_num = expTab(i).cycle_num;
    high_potential = expTab(i).high_potential;
    low_potential = expTab(i).low_potential;
    
    parfor jj = 1:zone        
        
        zonepath = fullfile(mask_path,maskdir(jj).name);
        CV_batch_for_points(expname,jj,tifpath,zonepath,begin,scanrate,samplerate,saveroute,...
    cycle_num,high_potential,low_potential)
        
    end

end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% 

���Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ���

����������������ݣ������Ǹ���ԭʼ�����ص�����е��˲�����

���Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ�����Ӻ���

%% ʹ��CV_batch��������

������ԭʼ�Ĵ��룬������������ĺ�����CV_batch���ô����Ƕ�ÿһ�����ص��
���ݽ����б�ѩ���˲����õ�curve����֮�����������curve����Ļ����Ͻ���
�ģ��ô���������ǣ��б�ѩ���˲�������δ����ʵ�����ݽ����Ż�����˿��ܳ�
���˲���������ʧ�������

cheby�˲�������Ҫ��Ϊ�޸ģ�����������������������������������������������������������������������������

% hwait = waitbar(0,['��û��ʼ��']);
% tic

for i = 1:length(expTab)
    
%     tic
    
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
        
        mask = [mask_path num2str(j) '.tif'];
        CV_batch(expname,j,tifpath,mask,begin,scanrate,samplerate,saveroute,...
            cycle_num,high_potential,low_potential);
        
    end

end

% delete(hwait);
% toc
save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% ��pointsÿ�����߽���cheby�˲����õ��µľ���curve��ʹ��curve���й�ѧCV���ߵļ���

˵�����˲�֮ǰ����GUI�ж���һ��points���߽���cheby�˲��ѵõ����ʵ��˲��������ڴ˻����϶�
��points���߽����˲����Ӷ��õ��˲����curve����

zone = expTab(1).zone;

for jj = 1:zone
    
    for ii = 1:length(expTab)
        
        expname = expTab(ii).expname;
        saveroute = expTab(ii).saveroute;
        Fs = expTab(ii).samplerate;
        valueroute = fullfile(saveroute,expname,[expname '_zone' num2str(jj) '_Value.mat']);
        load(valueroute);
        points = Value.points;
        curve = points;
        
        parfor kk = 1:size(curve,2)
            
            curve(:,kk) = lowp(points(:,kk),18,40,3,50,Fs);
            
        end
        
        Value.cheby_curve = curve;
        Value.d_cheby_curve = diff(curve);

        save(valueroute,'Value');
        
    end
  
end

%% ��˹�˲���ƽ���˲�

���ֶ�����span��ƽ���˲����ȣ�����˹�˲�������r��sigma��
�����������˲��������Ե����ʣ��ʿ���ֱ�Ӷ�avr�����˲����õ��Ľ����һ����


zone = expTab(1).zone;
span = 5;

for jj = 1:zone
    
    for ii = 1:length(expTab)
        
        expname = expTab(ii).expname;
        saveroute = expTab(ii).saveroute;
        Fs = expTab(ii).samplerate;
        valueroute = fullfile(saveroute,expname,[expname '_zone' num2str(jj) '_Value.mat']);
        load(valueroute);
        avr = Value.avr;
        seg_length = Value.seg_length;
        
        G_avr = Gaussianfilter(10,5,avr);
        Value.G_avr = G_avr;
        Value.dG_avr = diff(G_avr);
        
        if span<=1;
            l = round(span*seg_length);
        elseif span >1
            l = span;
        end  
        S_avr = smooth(avr,l);
        Value.S_avr = S_avr;
        Value.dS_avr = diff(S_avr);        

        save(valueroute,'Value');
        
    end
  
end

%% ��˹�˲�

���ֶ�����span��ƽ���˲����ȣ�����˹�˲�������r��sigma��
�����������˲��������Ե����ʣ��ʿ���ֱ�Ӷ�avr�����˲����õ��Ľ����һ����


zone = expTab(1).zone;

for jj = 1:zone
    
    for ii = 1:length(expTab)
        
        expname = expTab(ii).expname;
        saveroute = expTab(ii).saveroute;
        Fs = expTab(ii).samplerate;
        valueroute = fullfile(saveroute,expname,[expname '_zone' num2str(jj) '_Value.mat']);
        load(valueroute);
        avr = Value.avr;
        
        G_curve = points;
        G_avr = Gaussianfilter(50,6,avr);
        Value.G_avr = G_avr;
        Value.dG_avr = diff(G_avr);   

        save(valueroute,'Value');
        
    end
  
end
%% ��ԭʼ���ݽ���ƽ���͸�˹�˲�����ͼ

���ֶ���������״��LD��ƽ�������͸�˹�˲�������

load( [expTab(1).saveroute '\expTab.mat']);

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    saveroute = expTab(i).saveroute;
    cycle_num = expTab(i).cycle_num;

    parfor j = 1:zone        
        
%         CV_batch_Smooth(�����仯,�˲�������,expname,j,begin,scanrate,saveroute,cycle_num);
            CV_batch_Smooth('L',0.1,expname,j,begin,scanrate,saveroute,cycle_num);
            CV_batch_Gaussian('L',50,10,expname,j,begin,scanrate,saveroute,cycle_num);
          
    end
    
end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% ��ԭʼ���ݽ��и�˹�˲�����ͼ

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    saveroute = expTab(i).saveroute;
    cycle_num = expTab(i).cycle_num;
    
    parfor j = 1:zone        
        
%         CV_batch_Smooth(�����仯,r,sigma,expname,j,begin,scanrate,saveroute,cycle_num);
        CV_batch_Gaussian('L',50,10,expname,j,begin,scanrate,saveroute,cycle_num);
        
    end
    
end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');
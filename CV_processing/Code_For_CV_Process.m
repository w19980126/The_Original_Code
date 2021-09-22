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

clear data    % 同样是配合上面脚本使用的
clear t
clear i
clear Fs

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% 从原始数据中得到points矩阵和mean后的向量avr、tifDir、seg_length和potential等

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

楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界

以上是最基本的数据，以下是根据原始数据特点而进行的滤波处理

楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界楚河汉界

%% 使用CV_batch处理数据

这是最原始的代码，这里批量处理的函数是CV_batch，该代码是对每一个像素点的
数据进行切比雪夫滤波，得到curve矩阵，之后的运算是在curve矩阵的基础上进行
的，该代码的问题是：切比雪夫滤波参数并未根据实际数据进行优化，因此可能出
现滤波导致数据失真的现象。

cheby滤波参数需要人为修改！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！

% hwait = waitbar(0,['还没开始呢']);
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

%% 对points每条曲线进行cheby滤波并得到新的矩阵curve，使用curve进行光学CV曲线的计算

说明：滤波之前需在GUI中对任一条points曲线进行cheby滤波已得到合适的滤波参数，在此基础上对
各points曲线进行滤波，从而得到滤波后的curve矩阵

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

%% 高斯滤波和平滑滤波

需手动输入span（平滑滤波长度），高斯滤波参数（r和sigma）
由于这两种滤波具有线性的性质，故可以直接对avr进行滤波，得到的结果是一样的


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

%% 高斯滤波

需手动输入span（平滑滤波长度），高斯滤波参数（r和sigma）
由于这两种滤波具有线性的性质，故可以直接对avr进行滤波，得到的结果是一样的


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
%% 对原始数据进行平滑和高斯滤波并作图

需手动输入明暗状况LD、平滑参数和高斯滤波参数、

load( [expTab(1).saveroute '\expTab.mat']);

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    saveroute = expTab(i).saveroute;
    cycle_num = expTab(i).cycle_num;

    parfor j = 1:zone        
        
%         CV_batch_Smooth(明暗变化,滤波器长度,expname,j,begin,scanrate,saveroute,cycle_num);
            CV_batch_Smooth('L',0.1,expname,j,begin,scanrate,saveroute,cycle_num);
            CV_batch_Gaussian('L',50,10,expname,j,begin,scanrate,saveroute,cycle_num);
          
    end
    
end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');

%% 对原始数据进行高斯滤波并作图

for i = 1:length(expTab)
    
    expname = expTab(i).expname;
    zone = expTab(i).zone;
    begin = expTab(i).begin;
    scanrate = expTab(i).scanrate;
    saveroute = expTab(i).saveroute;
    cycle_num = expTab(i).cycle_num;
    
    parfor j = 1:zone        
        
%         CV_batch_Smooth(明暗变化,r,sigma,expname,j,begin,scanrate,saveroute,cycle_num);
        CV_batch_Gaussian('L',50,10,expname,j,begin,scanrate,saveroute,cycle_num);
        
    end
    
end

save([expTab(1).saveroute '\CV_expTab.mat'],'expTab');
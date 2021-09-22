%% 以zone2为例重新对各信号进行滤波，然后将CV曲线整合到一张图中

% 得到的newavr仅仅是对原始数据points进行加和平均而已
% 得到的avr_med70是对newavr使用长度为70的中值滤波器进行滤波后的结果
% 得到的avr_smooth是对avr_med70在进行长度为100的平滑滤波器进行滤波的结果

    for ii = 1:length(expTab)
        
        expname = expTab(ii).expname;
        set_route = ['H:\TiS2\20201009\_Reslut\' expname];
        scanrate = expTab(ii).scanrate;
        zone = expTab(ii).zone;
        n = expTab(ii).cycle_num;
        value_route = fullfile(set_route,[expname '_zone2_Value.mat']);
        load(value_route);

        seg_length = Value.seg_length;
        potential = Value.potential;
        begin = Value.begin;
        frame = begin.frame;
%         current = -Value.dROImean;
        intensity = Value.points;
        points = Value.points;
        newval(ii).expname = expname;
        newval(ii).points = intensity;
        avr = Value.avr;
        
        newavr = ones(1,size(points,1));
        parfor jj = 1:length(avr)
            newavr(jj) = mean(points(jj,:));    
        end
        newval(ii).newavr = newavr;
        
        avr_med70 = medfilt1(newavr,70);
        newval(ii).avr_med70 = avr_med70;
        
        avr_smooth = smooth(avr_med70,100);
        newval(ii).avr_smooth = avr_smooth;
        d_avr_smooth = -diff(avr_smooth);
        d_newavr = -diff(newavr);
        d_avr_med70 = -diff(avr_med70);

        if n==1

            d_avr_smooth = d_avr_smooth((frame+1):(frame+2*seg_length));
            d_newavr = d_newavr((frame+1):(frame+2*seg_length));
            d_avr_med70 = d_avr_med70((frame+1):(frame+2*seg_length));
            potential = potential(1:end-1);
%             CV_data(jj).current.expname = current;
%             CV_data(jj).potential.expname = potential;

        else 

            d_avr_smooth = d_avr_smooth((frame+1+(n-1)*2*seg_length):(frame+n*2*seg_length));
            d_newavr = d_newavr((frame+1+(n-1)*2*seg_length):(frame+n*2*seg_length));
            d_avr_med70 = d_avr_med70((frame+1+(n-1)*2*seg_length):(frame+n*2*seg_length));
            potential = potential((2*seg_length+1):4*seg_length);
%             CV_data(jj).current.expname = current;
%             CV_data(jj).potential.expname = potential;

        end
        
        newval(ii).potential = potential;
        newval(ii).d_avr_smooth = d_avr_smooth';
        newval(ii).d_avr_med70 = d_avr_med70;
        newval(ii).d_newavr = d_newavr;
        
        subplot(131)
        plot(potential,d_newavr*1000,'linewidth',1.5);
        title('原始数据');
        subplot(132)
        plot(potential,d_avr_smooth*1000,'linewidth',1.5);
        title('只平滑');
        subplot(133)
        plot(potential,d_avr_med70*1000,'linewidth',1.5);
        title('平滑+中值');

        hold off
        
    end
    
%     legend off
%     legend
    legend({'100mV/s','75mV/s','50mV/s','25mV/s','5mV/s'},'fontsize',15);
    title(['zone\_2变扫速CV'],'fontsize',15);
    xlabel('potential','fontsize',15);
    ylabel('current','fontsize',15);
    
    
    tmp_saveroute = ['H:\TiS2\20201009\_Reslut\CV\zone' num2str(jj) '_.fig'];
    saveas(gcf,tmp_saveroute);
    close 


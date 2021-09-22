%% 比较smooth+med70、smooth、avr以及smooth0.1之间的差别

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
    ds_avr = -Value.ds_avr;

        if n==1

            ds_avr = ds_avr((frame+1):(frame+2*seg_length));
            potential = potential(1:end-1);

        else 

            ds_avr = ds_avr((frame+1+(n-1)*2*seg_length):(frame+n*2*seg_length));
            potential = potential((2*seg_length+1):4*seg_length);

        end
    
    d_avr_smooth = newval(ii).d_avr_smooth;
    d_newavr = newval(ii).d_newavr;
    d_avr_med70 = newval(ii).d_avr_med70;
    
    figure
    
    subplot(131)
    plot(potential,ds_avr);
    hold on
    plot(potential,d_avr_smooth);
    legend('ds\_avr','d\_avr\_smooth');
    subplot(132)
    plot(potential,ds_avr);
    hold on
    plot(potential,d_newavr);
    legend('ds\_avr','d\_avr\_smooth');
    subplot(133)
    plot(potential,ds_avr);
    hold on
    plot(potential,d_avr_med70);
    legend('ds\_avr','d\_avr\_med70');
    
end
    

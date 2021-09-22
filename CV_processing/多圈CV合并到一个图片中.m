%% 多圈光强曲线合并到一个图片中

zone = expTab(1).zone;

for jj = 1:zone
    
    figure
    S = cell(length(expTab),1);
    
    for ii = 1:length(expTab)
        
        expname = expTab(ii).expname;
        set_route = ['G:\TiS2\experiment\20210321\Result\' expname];
        scanrate = expTab(ii).scanrate;
        n = expTab(ii).cycle_num;
        value_route = fullfile(set_route,[expname '_zone' num2str(jj) '_Value.mat']);
        load(value_route);

        seg_length = Value.seg_length;
        potential = Value.potential;
        begin = Value.begin;
        frame = begin.frame;
        dG_T_avr = Value.dG_T_avr;

        if n==1

            Intensity = dG_T_avr((frame):(frame+2*seg_length));

        else 

            Intensity = dG_T_avr((frame+(n-1)*2*seg_length):(frame+n*2*seg_length));

        end
        
        hold on

        plot(potential,Intensity,'linewidth',2);
        S{ii} = [num2str(expTab(ii).scanrate) 'mV/s'];
        
        hold off
        
    end
    
    legend(S)
    title(['不同扫速下光强曲线对比'],'fontsize',15);
    xlabel('Potential vs. Ag/AgCl (V)','fontsize',15);
    ylabel('Reflectivity (a.u.)','fontsize',15);
    
    box on
    axis square
    set(gca,'fontsize',15);
    set(gca,'fontweight','bold');
    
end
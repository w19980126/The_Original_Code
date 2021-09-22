function CV_Batch_For_Trans_Fig(expname,zone,begin,scanrate,saveroute,cycle_num)

%% 创建新的文件夹用来保存数据

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % 否则saveas函数将无法保存数据

%% 以下，加载Value，并读入相关数据

value_path = fullfile(saveroute,expname,[expname '_zone' num2str(zone) '_Value.mat']);
load(value_path);

tmp = begin.frame;
seg_length = Value.seg_length;
potential = Value.potential;

T_avr = Value.T_avr;
T_avr = T_avr(tmp:tmp+length(potential)-1);
d_T_avr = diff(T_avr);

% S_T_avr = Value.S_T_avr;
% S_T_avr = S_T_avr(tmp:tmp+length(potential)-1);
% dS_T_avr = diff(S_T_avr);

G_T_avr = Value.G_T_avr;
G_T_avr = G_T_avr(tmp:tmp+length(potential)-1);
dG_T_avr = diff(G_T_avr);

% cheby_T_avr = Value.cheby_T_avr;
% dcheby_T_avr = Value.dcheby_T_avr;



%% 以下，求平均强度对帧数Frame的变化曲线


figure;
plot(T_avr,'k','linewidth',2);
% hold on
% plot(S_T_avr,'r-','linewidth',2);
% plot(G_T_avr,'b-','linewidth',2);
% plot(cheby_T_avr,'m','linewidth',2);
xlim([0 length(T_avr)]);
ylim = get(gca,'ylim');

Fig_Standard
title([expname  '\_zone' num2str(zone) '\_光强随帧数变化曲线,Scan Rate:' num2str(scanrate) 'mV/s'],'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('Intensity','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_光强随帧数变化曲线.fig'];
saveas(gcf,fig_savepath);
close 

%% 以下，求光学CV曲线

avr_Trans = mean(T_avr);
if avr_Trans >0
    LD = 'L';
elseif avr_Trans <0
    LD = 'D';
end

if LD == 'L'
    d_T_avr = -d_T_avr;
%     dS_T_avr = -dS_T_avr;
    dG_T_avr = -dG_T_avr;
%     dcheby_T_avr = -dcheby_T_avr;
elseif LD == 'D'
    d_T_avr = d_T_avr;
%     dS_T_avr = dS_T_avr;
    dG_T_avr = dG_T_avr;
%     dcheby_T_avr = dcheby_T_avr;
end

%------------------------->>>>>>>>>>> 平滑与原始数据作图 <<<<<<<<<<<----------------------------------
% 
% figure
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = dS_T_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     plot(x,y,'k','linewidth',2);
%     hold on 
% end
% Value.dS_T_avr = dS_T_avr;
% 
% Fig_Standard
% xlabel('Potential');
% set(gca,'ytick',[]);
% set(gca,'fontsize',20);
% set(gca,'fontweight','bold');
% title([expname '\_zone' num2str(zone) '\_Trans\_光学CV曲线,Scan Rate:' num2str(scanrate) 'mV/s'],'fontsize',20);
% axis square
% 
% tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_光学CV曲线_Smooth.fig'];
% saveas(gcf,tmp_savepath);
% clear tmp_savepath;
% close

%------------------------->>>>>>>>>>> 高斯与原始数据作图 <<<<<<<<<<<----------------------------------

figure
for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dG_T_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end

Fig_Standard
title([expname '\_zone' num2str(zone) '\_Trans\_光学CV曲线,Scan Rate:' num2str(scanrate) 'mV/s']);
xlabel('Potential (V vs. Ag/AgCl)');
set(gca,'ytick',[]);

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_光学CV曲线_Gaussian.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%------------------------->>>>>>>>>>> cheby与原始数据作图 <<<<<<<<<<<----------------------------------
% 
% figure
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = d_T_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
%     plot(x,y,'k','linewidth',2);
%     hold on 
%     T_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = y;
%     h_str1{ii} = ['原始数据\_第' num2str(ii) '圈'];
%     legend on;   
% end
% 
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = dcheby_T_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
%     plot(x,y,'r','linewidth',2);
%     hold on 
%     cheby_T_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = y;
%     h_str2{ii} = ['cheby\_第' num2str(ii) '圈'];
% end
% h_str = [h_str1 h_str2];
% hl = findobj(gca,'type','line');
% legend(hl,'String',fliplr(h_str));
% Value.cheby_T_Current = cheby_T_Current;
% 
% Fig_Standard
% title([expname '\_zone' num2str(zone) '\_Trans\_光学CV曲线,Scan Rate:' num2str(scanrate) 'mV/s']);
% xlabel('Potential');
% set(gca,'ytick',[]);
% 
% tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_光学CV曲线_cheby.fig'];
% saveas(gcf,tmp_savepath);
% clear tmp_savepath;
% close

%% 以下，保存数据 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

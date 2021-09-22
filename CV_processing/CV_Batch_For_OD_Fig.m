function CV_Batch_For_OD_Fig(expname,zone,begin,scanrate,saveroute,cycle_num)

%% 创建新的文件夹用来保存数据

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % 否则saveas函数将无法保存数据

%% 以下，加载Value，并读入相关数据

value_path = fullfile(saveroute,expname,[expname '_zone' num2str(zone) '_Value.mat']);
load(value_path);

tmp = begin.frame;
seg_length = Value.seg_length;
potential = Value.potential;

OD_avr = Value.OD_avr;
OD_avr = OD_avr(tmp:tmp+length(potential)-1);
d_OD_avr = diff(OD_avr);
% 
% S_OD_avr = Value.S_OD_avr;
% S_OD_avr = S_OD_avr(tmp:tmp+length(potential)-1);
% dS_OD_avr = diff(S_OD_avr);

G_OD_avr = Value.G_OD_avr;
G_OD_avr = G_OD_avr(tmp:tmp+length(potential)-1);
dG_OD_avr = diff(G_OD_avr);

% cheby_OD_avr = Value.cheby_OD_avr;
% dcheby_OD_avr = Value.dcheby_OD_avr;



%% 以下，求平均强度对帧数Frame的变化曲线

figure;
plot(OD_avr,'k','linewidth',2);
xlim([0 length(OD_avr)]);
ylim = get(gca,'ylim');

Fig_Standard
title([expname  '\_zone' num2str(zone) '\_OD随帧数变化曲线,Scan Rate:' num2str(scanrate) 'mV/s'],'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('\Delta OD','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_OD随帧数变化曲线.fig'];
saveas(gcf,fig_savepath);
close 

%% 以下，求光学CV曲线

avr_Trans = mean(OD_avr);
if avr_Trans >0
    LD = 'L';
elseif avr_Trans <0
    LD = 'D';
end

if LD == 'L'
    d_OD_avr = -d_OD_avr;
%     dS_OD_avr = -dS_OD_avr;
    dG_OD_avr = -dG_OD_avr;
%     dcheby_OD_avr = -dcheby_OD_avr;
elseif LD == 'D'
    d_OD_avr = d_OD_avr;
%     dS_OD_avr = dS_OD_avr;
    dG_OD_avr = dG_OD_avr;
%     dcheby_OD_avr = dcheby_OD_avr;
end

%------------------------->>>>>>>>>>> 平滑与原始数据作图 <<<<<<<<<<<----------------------------------
% 
% figure
% 
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = dS_OD_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     plot(x,y,'k','linewidth',2);
%     hold on 
% end
% Value.dS_OD_avr = dS_OD_avr;
% 
% xlabel('Potential');
% set(gca,'ytick',[]);
% set(gca,'fontsize',20);
% set(gca,'fontweight','bold');
% title([expname '\_zone' num2str(zone) '\_OD\_CV曲线,Scan Rate:' num2str(scanrate) 'mV/s'],'fontsize',20);
% axis square
% 
% tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_OD_CV曲线_Smooth.fig'];
% saveas(gcf,tmp_savepath);
% clear tmp_savepath;
% close

%------------------------->>>>>>>>>>> 高斯与原始数据作图 <<<<<<<<<<<----------------------------------

figure

for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dG_OD_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end
% Value.dG_OD_avr = dG_OD_avr;

Fig_Standard
title([expname '\_zone' num2str(zone) '\_OD\_CV曲线,Scan Rate:' num2str(scanrate) 'mV/s']);
xlabel('Potential');
set(gca,'ytick',[]);

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_OD_CV曲线_Gaussian.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%------------------------->>>>>>>>>>> cheby与原始数据作图 <<<<<<<<<<<----------------------------------
% 
% figure
% 
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = dcheby_OD_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
%     plot(x,y,'r','linewidth',2);
%     hold on 
%     cheby_OD_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = y;
%     h_str2{ii} = ['cheby\_第' num2str(ii) '圈'];
% end
% h_str = [h_str1 h_str2];
% hl = findobj(gca,'type','line');
% legend(hl,'String',fliplr(h_str));
% Value.cheby_OD_Current = cheby_OD_Current;
% 
% Fig_Standard
% title([expname '\_zone' num2str(zone) '\_OD\_CV曲线,Scan Rate:' num2str(scanrate) 'mV/s']);
% xlabel('Potential');
% set(gca,'ytick',[]);
% 
% tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_OD_光学CV曲线_cheby.fig'];
% saveas(gcf,tmp_savepath);
% clear tmp_savepath;
% close

%% 以下，保存数据 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

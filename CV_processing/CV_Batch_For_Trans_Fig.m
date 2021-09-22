function CV_Batch_For_Trans_Fig(expname,zone,begin,scanrate,saveroute,cycle_num)

%% �����µ��ļ���������������

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % ����saveas�������޷���������

%% ���£�����Value���������������

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



%% ���£���ƽ��ǿ�ȶ�֡��Frame�ı仯����


figure;
plot(T_avr,'k','linewidth',2);
% hold on
% plot(S_T_avr,'r-','linewidth',2);
% plot(G_T_avr,'b-','linewidth',2);
% plot(cheby_T_avr,'m','linewidth',2);
xlim([0 length(T_avr)]);
ylim = get(gca,'ylim');

Fig_Standard
title([expname  '\_zone' num2str(zone) '\_��ǿ��֡���仯����,Scan Rate:' num2str(scanrate) 'mV/s'],'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('Intensity','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_��ǿ��֡���仯����.fig'];
saveas(gcf,fig_savepath);
close 

%% ���£����ѧCV����

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

%------------------------->>>>>>>>>>> ƽ����ԭʼ������ͼ <<<<<<<<<<<----------------------------------
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
% title([expname '\_zone' num2str(zone) '\_Trans\_��ѧCV����,Scan Rate:' num2str(scanrate) 'mV/s'],'fontsize',20);
% axis square
% 
% tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_��ѧCV����_Smooth.fig'];
% saveas(gcf,tmp_savepath);
% clear tmp_savepath;
% close

%------------------------->>>>>>>>>>> ��˹��ԭʼ������ͼ <<<<<<<<<<<----------------------------------

figure
for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dG_T_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end

Fig_Standard
title([expname '\_zone' num2str(zone) '\_Trans\_��ѧCV����,Scan Rate:' num2str(scanrate) 'mV/s']);
xlabel('Potential (V vs. Ag/AgCl)');
set(gca,'ytick',[]);

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_��ѧCV����_Gaussian.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%------------------------->>>>>>>>>>> cheby��ԭʼ������ͼ <<<<<<<<<<<----------------------------------
% 
% figure
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = d_T_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
%     plot(x,y,'k','linewidth',2);
%     hold on 
%     T_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = y;
%     h_str1{ii} = ['ԭʼ����\_��' num2str(ii) 'Ȧ'];
%     legend on;   
% end
% 
% for ii = 1:cycle_num    
%     x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
%     y = dcheby_T_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
%     plot(x,y,'r','linewidth',2);
%     hold on 
%     cheby_T_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = y;
%     h_str2{ii} = ['cheby\_��' num2str(ii) 'Ȧ'];
% end
% h_str = [h_str1 h_str2];
% hl = findobj(gca,'type','line');
% legend(hl,'String',fliplr(h_str));
% Value.cheby_T_Current = cheby_T_Current;
% 
% Fig_Standard
% title([expname '\_zone' num2str(zone) '\_Trans\_��ѧCV����,Scan Rate:' num2str(scanrate) 'mV/s']);
% xlabel('Potential');
% set(gca,'ytick',[]);
% 
% tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_��ѧCV����_cheby.fig'];
% saveas(gcf,tmp_savepath);
% clear tmp_savepath;
% close

%% ���£��������� 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

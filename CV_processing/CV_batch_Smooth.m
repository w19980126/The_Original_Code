function CV_batch_Smooth(LD,span,expname,zone,begin,scanrate,saveroute,cycle_num)

% �õ���S_Current������ƽ���õ��ĵ�������
tic

%% �����µ��ļ���������������

new_folder = [saveroute '\' expname '\zone' num2str(zone) '\Smooth_' num2str(span)];
mkdir(new_folder);      % ����saveas�������޷���������

%% ���£�����Value���������������

value_path = fullfile(saveroute,expname,[expname '_zone' num2str(zone) '_Value.mat']);
load(value_path);
S_avr = Value.S_avr;
dS_avr = Value.dS_avr;
seg_length = Value.seg_length;
potential = Value.potential;

%% ���£���ƽ��ǿ�ȶ�֡��Frame�ı仯����

tmp = begin.frame;
figure;
plot(S_avr,'.','MarkerSize',10);
ylim = get(gca,'ylim');
hold on
for ii = 1:(2*cycle_num+1)
    
    x = tmp+(ii-1)*seg_length;
    plot([x x],ylim,'--','linewidth',1.5);
    
end
hold off 
title([expname  '\_zone' num2str(zone) '\_͸������֡���仯����,Scan Rate:' num2str(scanrate) 'mV/s,smooth\_' num2str(span)],'fontsize',15);
xlabel('Frames','fontsize',15);
ylabel('Mean Intensity','fontsize',15);
set(gca,'fontsize',15)
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_͸������֡���仯����.fig'];
saveas(gcf,fig_savepath);
close 

%% ���£����ѧCV����

frame = begin.frame;
S_Current = potential;
if LD == 'L'
    d_avr = -dS_avr;
elseif LD == 'D'
    d_avr = dS_avr;
elseif LD == 'LD' 
    d_avr = -dS_avr;
elseif LD =='DL'
    d_avr = dS_avr;
else
    error('��������ȷ�������仯');
end

figure

for ii = 1:cycle_num
    
    hold on
    h_name = ['h_' num2str(ii)];
    h_name = plot(potential((1+(ii-1)*2*seg_length):(ii*2*seg_length)),...
        d_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length)),'.','MarkerSize',10);
    S_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = d_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
    legend(h_name,['��' num2str(ii) 'Ȧ'],'fontsize',30);
    hold off

end

Value.S_Current = S_Current;

legend off
legend; 
xlabel('Potential','fontsize',15);
ylabel('\DeltaIntensuty','fontsize',15);
title([expname '\_zone' num2str(zone) '��ѧCV����,Scan Rate:' num2str(scanrate) 'mV/s,smooth\_' num2str(span)],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_��ѧCV����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£�d_avr��֡����ͼ�����ö��߽���ͬ���������������

plot(d_avr,'k','linewidth',1.5);
hold on
ylim = get(gca,'ylim');
tmp = begin.frame;

for ii = 1:(2*cycle_num+1)
    
    x = tmp+(ii-1)*2*seg_length;
    plot([x x],ylim,'.','MarkerSize',10);
    
end

hold off
xlabel('Frame','fontsize',15);
ylabel('\Delta Intensity','fontsize',15);
title([expname '\_zone' num2str(zone) '͸���ʲ����֡���仯����,Scan Rate:' num2str(scanrate) 'mV/s,smooth\_' num2str(span)],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_͸���ʲ����֡���仯����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£��������� 

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value');

toc

end

function CV_batch_Gaussian(LD,r,sigma,expname,zone,begin,scanrate,saveroute,cycle_num)

% �õ���G_Current������ƽ���õ��ĵ�������
tic

%% �����µ��ļ���������������

new_folder = [saveroute '\' expname '\zone' num2str(zone) '\Gaussian_' num2str(r) '_' num2str(sigma)];
mkdir(new_folder);      % ����saveas�������޷���������

%% ���£�����Value���������������

value_path = fullfile(saveroute,expname,[expname '_zone' num2str(zone) '_Value.mat']);
load(value_path);
G_avr = Value.G_avr;
dG_avr = Value.dG_avr;
seg_length = Value.seg_length;
potential = Value.potential;

%% ���£���ƽ��ǿ�ȶ�֡��Frame�ı仯����

tmp = begin.frame;
figure;
plot(G_avr,'.','MarkerSize',10);
ylim = get(gca,'ylim');
hold on
for ii = 1:(2*cycle_num+1)
    
    x = tmp+(ii-1)*seg_length;
    plot([x x],ylim,'--','linewidth',1.5);
    
end
hold off 
title([expname  '\_zone' num2str(zone) '\_͸������֡���仯����,Scan Rate:' num2str(scanrate) 'mV/s,Gaussian\_' num2str(r) '\_' num2str(sigma)],'fontsize',15);
xlabel('Frames','fontsize',15);
ylabel('Mean Intensity','fontsize',15);
set(gca,'fontsize',15)
axis tight

fig_savepath = [new_folder '\' expname '_zone' num2str(zone)  '_͸������֡���仯����.fig'];
saveas(gcf,fig_savepath);
close 

%% ���£����ѧCV����

frame = begin.frame;
G_Current = potential;
if LD == 'L'
    d_avr = -dG_avr;
elseif LD == 'D'
    d_avr = dG_avr;
elseif LD == 'LD' 
    d_avr = -dG_avr;
elseif LD =='DL'
    d_avr = dG_avr;
else
    error('��������ȷ�������仯');
end

figure

for ii = 1:cycle_num
    
    hold on
    h_name = ['h_' num2str(ii)];
    h_name = plot(potential((1+(ii-1)*2*seg_length):(ii*2*seg_length)),...
        d_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length)),'.','MarkerSize',10);
    G_Current((1+seg_length*2*(ii-1)):seg_length*2*ii) = d_avr((frame+1+(ii-1)*2*seg_length):(frame+ii*2*seg_length));
    legend(h_name,['��' num2str(ii) 'Ȧ'],'fontsize',30);
    hold off

end

Value.G_Current = G_Current;

legend off
legend; 
xlabel('Potential','fontsize',15);
ylabel('\DeltaIntensuty','fontsize',15);
title([expname '\_zone' num2str(zone) '��ѧCV����,Scan Rate:' num2str(scanrate) 'mV/s,Gaussian\_' num2str(r) '\_' num2str(sigma)],'fontsize',15);
set(gca,'fontsize',15);
axis tight

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_��ѧCV����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£�d_avr��֡����ͼ�����ö��߽���ͬ���������������

plot(d_avr,'.','MarkerSize',10);
hold on
ylim = get(gca,'ylim');
tmp = begin.frame;

for ii = 1:(2*cycle_num+1)
    
    x = tmp+(ii-1)*2*seg_length;
    plot([x x],ylim,'--','linewidth',1.5);
    
end

hold off
xlabel('Frame','fontsize',15);
ylabel('\Delta Intensity','fontsize',15);
title([expname '\_zone' num2str(zone) '͸���ʲ����֡���仯����,Scan Rate:' num2str(scanrate) 'mV/s,Gaussian\_' num2str(r) '\_' num2str(sigma)],'fontsize',15);
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

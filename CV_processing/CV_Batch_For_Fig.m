function CV_Batch_For_Fig(expname,zone,begin,scanrate,saveroute,cycle_num)

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

S_T_avr = Value.S_T_avr;
S_T_avr = S_T_avr(tmp:tmp+length(potential)-1);
dS_T_avr = diff(S_T_avr);

G_T_avr = Value.G_T_avr;
G_T_avr = G_T_avr(tmp:tmp+length(potential)-1);
dG_T_avr = diff(G_T_avr);

% cheby_T_avr = Value.cheby_T_avr;
% dcheby_T_avr = Value.dcheby_T_avr;

OD_avr = Value.OD_avr;
OD_avr = OD_avr(tmp:tmp+length(potential)-1);
d_OD_avr = diff(OD_avr);

S_OD_avr = Value.S_OD_avr;
S_OD_avr = S_OD_avr(tmp:tmp+length(potential)-1);
dS_OD_avr = diff(S_OD_avr);

G_OD_avr = Value.G_OD_avr;
G_OD_avr = G_OD_avr(tmp:tmp+length(potential)-1);
dG_OD_avr = diff(G_OD_avr);

% cheby_OD_avr = Value.cheby_OD_avr;
% dcheby_OD_avr = Value.dcheby_OD_avr;

%% ���£�OD���

% ---------------------------------���£���ƽ��ǿ�ȶ�֡��Frame�ı仯����---------------------------------

figure;
subplot(131)
plot(OD_avr,'k','linewidth',2);
xlim([0 length(S_OD_avr)]);
ylim = get(gca,'ylim');

Fig_Standard
title({[expname  '\_zone' num2str(zone) '\_OD��֡���仯����'];['Scan Rate:' num2str(scanrate) 'mV/s']},'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('\Delta OD','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis square

% ---------------------------------���£����ѧ��������---------------------------------

avr_Trans = mean(OD_avr);
if avr_Trans >0
    LD = 'L';
elseif avr_Trans <0
    LD = 'D';
end

if LD == 'L'
    d_OD_avr = -d_OD_avr;
    dS_OD_avr = -dS_OD_avr;
    dG_OD_avr = -dG_OD_avr;
%     dcheby_OD_avr = -dcheby_OD_avr;
elseif LD == 'D'
    d_OD_avr = d_OD_avr;
    dS_OD_avr = dS_OD_avr;
    dG_OD_avr = dG_OD_avr;
%     dcheby_OD_avr = dcheby_OD_avr;
end

% ---------------------------------ƽ��������ͼ---------------------------------

subplot(133)

for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dS_OD_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end
Value.dS_OD_avr = dS_OD_avr;

xlabel('Potential (V vs. Ag/AgCl)');
set(gca,'ytick',[]);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
title({[expname '\_zone' num2str(zone) '\_OD\_CV����\_Smooth'];['Scan Rate:' num2str(scanrate) 'mV/s']},'fontsize',20);
axis square

% ---------------------------------��˹������ͼ---------------------------------

subplot(132)
for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dG_OD_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end
Value.dG_OD_avr = dG_OD_avr;

Fig_Standard
title({[expname '\_zone' num2str(zone) '\_OD\_CV����\_Gaussian'];['Scan Rate:' num2str(scanrate) 'mV/s']});
xlabel('Potential (V vs. Ag/AgCl)');
set(gca,'ytick',[]);
axis square

% ---------------------------------���£�����ͼƬ---------------------------------

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_OD����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£�Trans���

% ---------------------------------���£���ƽ��ǿ�ȶ�֡��Frame�ı仯����---------------------------------

figure;
subplot(131)
plot(T_avr,'k','linewidth',2);
xlim([0 length(T_avr)]);
ylim = get(gca,'ylim');

Fig_Standard
title({[expname  '\_zone' num2str(zone) '\_͸������֡���仯����'];['Scan Rate:' num2str(scanrate) 'mV/s']},'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('\Delta Transmittance','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis square

% ---------------------------------���£����ѧ��������---------------------------------

avr_Trans = mean(T_avr);
if avr_Trans >0
    LD = 'L';
elseif avr_Trans <0
    LD = 'D';
end

if LD == 'L'
    d_T_avr = -d_T_avr;
    dS_T_avr = -dS_T_avr;
    dG_T_avr = -dG_T_avr;
%     dcheby_T_avr = -dcheby_T_avr;
elseif LD == 'D'
    d_T_avr = d_T_avr;
    dS_T_avr = dS_T_avr;
    dG_T_avr = dG_T_avr;
%     dcheby_T_avr = dcheby_T_avr;
end


% ---------------------------------ƽ��������ͼ---------------------------------

subplot(133)
for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dS_T_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end
Value.dS_T_avr = dS_T_avr;

Fig_Standard
xlabel('Potential (V vs. Ag/AgCl)');
set(gca,'ytick',[]);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
title({[expname '\_zone' num2str(zone) '\_Trans\_��ѧCV����\_Smooth'];['Scan Rate:' num2str(scanrate) 'mV/s']},'fontsize',20);
axis square

% ---------------------------------��˹������ͼ---------------------------------

subplot(132)
for ii = 1:cycle_num    
    x = potential((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    y = dG_T_avr((1+(ii-1)*2*seg_length):(ii*2*seg_length));
    plot(x,y,'k','linewidth',2);
    hold on 
end
Value.dG_T_avr = dG_T_avr;

Fig_Standard
title({[expname '\_zone' num2str(zone) '\_Trans\_��ѧCV����\_Gaussian'];['Scan Rate:' num2str(scanrate) 'mV/s']});
xlabel('Potential (V vs. Ag/AgCl)');
set(gca,'ytick',[]);
axis square

% ---------------------------------���£�����ͼƬ---------------------------------

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_Trans����.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% ���£���������

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

function PS_Batch_For_Fig(expname,zone,begin,saveroute,samplerate,first_dur,mid_dur,end_dur);

%% 创建新的文件夹用来保存数据

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % 否则saveas函数将无法保存数据

%% 以下，加载Value，并读入相关数据

value_path = fullfile(saveroute,expname,[expname '_zone' num2str(zone) '_Value.mat']);
load(value_path);

begin_frame = begin.frame;

OD_avr = Value.OD_avr;
d_OD_avr = diff(OD_avr);
S_OD_avr = Value.S_OD_avr;
dS_OD_avr = diff(S_OD_avr);
G_OD_avr = Value.G_OD_avr;
dG_OD_avr = diff(G_OD_avr);

T_avr = Value.T_avr;
d_T_avr = diff(T_avr);
S_T_avr = Value.S_T_avr;
dS_T_avr = diff(S_T_avr);
G_T_avr = Value.G_T_avr;
dG_T_avr = diff(G_T_avr);

%% 以下，OD相关

% ---------------------------------以下，求平均强度对帧数Frame的变化曲线---------------------------------

figure;
subplot(131)
plot(OD_avr,'k','linewidth',2);

xlim([0 length(OD_avr)]);
ylim = get(gca,'ylim');

x_tick = zeros(1,4);
x_tick(1) = begin_frame;
x_tick(2:4) = [first_dur mid_dur+first_dur end_dur+mid_dur+first_dur]*samplerate + begin_frame;

hold on
for ii = 1:4
    
    plot([x_tick(ii) x_tick(ii)],ylim,'--','linewidth',2);
    
end
hold off

Fig_Standard
title([expname  '\_zone' num2str(zone) '\_透射率随帧数变化曲线'],'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('\Delta Transmittance','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis tight

% ---------------------------------以下，求光学电流曲线---------------------------------

avr_Trans = mean(OD_avr);
if avr_Trans >0;
    LD = 'L';
elseif avr_Trans <0;
    LD = 'D';
end

if LD == 'L'
    d_OD_avr = -d_OD_avr;
    dS_OD_avr = -dS_OD_avr;
    dG_OD_avr = -dG_OD_avr;
elseif LD == 'D'
    d_OD_avr = d_OD_avr;
    dS_OD_avr = dS_OD_avr;
    dG_OD_avr = dG_OD_avr;
end

% ---------------------------------平滑数据作图---------------------------------

subplot(133)
plot(1:length(dS_OD_avr),dS_OD_avr,'k','linewidth',2);
Value.dS_OD_avr = dS_OD_avr;

ylim = get(gca,'ylim');
x_tick = zeros(1,4);
x_tick(1) = begin_frame;
x_tick(2:4) = [first_dur mid_dur+first_dur end_dur+mid_dur+first_dur]*samplerate + begin_frame;

hold on
for ii = 1:4
    
    plot([x_tick(ii) x_tick(ii)],ylim,'--','linewidth',2);
    
end
hold off

Fig_Standard
xlabel('Frames');
set(gca,'ytick',[]);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
title([expname '\_zone' num2str(zone) '\_Trans\_光学电流曲线\_Smooth'],'fontsize',20);
axis tight

% ---------------------------------高斯数据作图---------------------------------

subplot(132)
plot(1:length(dG_OD_avr),dG_OD_avr,'k','linewidth',2);
Value.dG_OD_avr = dG_OD_avr;

ylim = get(gca,'ylim');
x_tick = zeros(1,4);
x_tick(1) = begin_frame;
x_tick(2:4) = [first_dur mid_dur+first_dur end_dur+mid_dur+first_dur]*samplerate + begin_frame;

hold on
for ii = 1:4
    
    plot([x_tick(ii) x_tick(ii)],ylim,'--','linewidth',2);
    
end
hold off

Fig_Standard
xlabel('Frames');
set(gca,'ytick',[]);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
title([expname '\_zone' num2str(zone) '\_Trans\_光学电流曲线\_Gaussian'],'fontsize',20);
axis tight

% ---------------------------------以下，保存图片---------------------------------

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_OD曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，Trans相关

% ---------------------------------以下，求平均强度对帧数Frame的变化曲线---------------------------------

figure;
subplot(131)
plot(T_avr,'k','linewidth',2);

xlim([0 length(T_avr)]);
ylim = get(gca,'ylim');
x_tick = zeros(1,4);
x_tick(1) = begin_frame;
x_tick(2:4) = [first_dur mid_dur+first_dur end_dur+mid_dur+first_dur]*samplerate + begin_frame;

hold on
for ii = 1:4
    
    plot([x_tick(ii) x_tick(ii)],ylim,'--','linewidth',2);
    
end
hold off

Fig_Standard
title([expname  '\_zone' num2str(zone) '\_透射率随帧数变化曲线'],'fontsize',20);
xlabel('Frames','fontsize',20);
ylabel('\Delta Transmittance','fontsize',20);
set(gca,'fontsize',20)
set(gca,'fontweight','bold');
axis tight

% ---------------------------------以下，求光学电流曲线---------------------------------

avr_Trans = mean(T_avr);
if avr_Trans >0;
    LD = 'L';
elseif avr_Trans <0;
    LD = 'D';
end

if LD == 'L'
    d_T_avr = -d_T_avr;
    dS_T_avr = -dS_T_avr;
    dG_T_avr = -dG_T_avr;
elseif LD == 'D'
    d_T_avr = d_T_avr;
    dS_T_avr = dS_T_avr;
    dG_T_avr = dG_T_avr;
end


% ---------------------------------平滑数据作图---------------------------------

subplot(133)
plot(1:length(dS_T_avr),dS_T_avr,'k','linewidth',2);

ylim = get(gca,'ylim');
x_tick = zeros(1,4);
x_tick(1) = begin_frame;
x_tick(2:4) = [first_dur mid_dur+first_dur end_dur+mid_dur+first_dur]*samplerate + begin_frame;

hold on
for ii = 1:4
    
    plot([x_tick(ii) x_tick(ii)],ylim,'--','linewidth',2);
    
end
hold off

Value.dS_T_avr = dS_T_avr;

Fig_Standard
xlabel('Frames');
set(gca,'ytick',[]);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
title([expname '\_zone' num2str(zone) '\_Trans\_光学电流曲线\_Smooth'],'fontsize',20);
axis tight

% ---------------------------------高斯数据作图---------------------------------

subplot(132)
plot(1:length(dG_T_avr),dG_T_avr,'k','linewidth',2);
Value.dG_T_avr = dG_T_avr;

ylim = get(gca,'ylim');
x_tick = zeros(1,4);
x_tick(1) = begin_frame;
x_tick(2:4) = [first_dur mid_dur+first_dur end_dur+mid_dur+first_dur]*samplerate + begin_frame;

hold on
for ii = 1:4
    
    plot([x_tick(ii) x_tick(ii)],ylim,'--','linewidth',2);
    
end
hold off

Fig_Standard
xlabel('Frames');
set(gca,'ytick',[]);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
title([expname '\_zone' num2str(zone) '\_Trans\_光学电流曲线\_Gaussian'],'fontsize',20);
axis tight

% ---------------------------------以下，保存图片---------------------------------

tmp_savepath = [new_folder '\' expname '_zone' num2str(zone) '_Trans曲线.fig'];
saveas(gcf,tmp_savepath);
clear tmp_savepath;
close

%% 以下，保存数据

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

%% 光谱数据作图

%% 从原始数据中分离得到强度、波长和时间矩阵

% 时间和强度矩阵分为顺序（seq，从上到下对应时间从开始到结束）
% 和逆序（inv，从上到下对应时间从结束到开始）
% 这么做的目的是方便二维作图时横轴和纵轴正方向都是从小变到大

t_seq = CV(2:end,1);
wave_length = CV(1,2:end);
I_seq = CV(2:end,2:end);
[t_inv,t_index] = sort(t_seq,'descend');
I_inv = I_seq(t_index,:);

%% 绝对强队转成二维图，对与纵轴，从下到上对应时间从0到1200s

figure
imagesc(I_inv);
colorbar

x = round((1:150:length(wave_length))/150)*150;     % 在x处进行刻度说明，x是一个一维向量
tmp1 = 400:50:800;
x_label = cell(length(tmp1),1);
for ii = 1:length(tmp1)
    
    x_label{ii} = num2str(tmp1(ii));           % 刻度说明内容，x_label是一个一维字符串数组
    
end
set(gca,'xtick',x);                                 % 表示在x处进行刻度标记
set(gca,'xticklabel',x_label);                      % 表示标记内容是x_label中的内容，因此需要x与x_label一一对应
set(gca,'layer','bottom');                          % 只显示刻度处标记而不显示刻度线

y = [0:766/3:1001 1001];
% tmp2 = [0:-0.2:-0.6 -0.42];
tmp2 = [-0.42 -0.6:0.2:0];
y_label = cell(length(tmp2),1);
for ii = 1:length(y_label)
    
    y_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'ytick',y);
set(gca,'yticklabel',y_label);

xlabel('Wave Length (nm)');
ylabel('Potential v.s Ag/AgCl (V)');
title('20201102\_ScanRate\_1 mV/s');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
axis square

%% 相对强队转成二维图，对与纵轴，从下到上对应时间从0到1200s

figure
I_reletive = I_inv;
for ii = 1:size(I_reletive,1)
    
    I_reletive(ii,:) = (I_inv(ii,:)-I_inv(end,:))./I_inv(end,:);

end
I_reletive(:,[24 1230]) = [];
imagesc(I_reletive);
colorbar

set(gca,'xtick',x);
set(gca,'xticklabel',x_label);
set(gca,'ytick',y);
set(gca,'yticklabel',y_label);
xlabel('Wave Length (nm)');
ylabel('Potential v.s Ag/AgCl (V)');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
title('20201102\_ScanRate\_1 mV/s\_normalization based on the initial spectral data');
axis square

%% 每个25nm进行平均然后作图

wave_step = length(wave_length)/400;
for ii = 1:15
    
    mean_I(1:length(t_seq),ii) = mean(I_seq(:,((ii-1)*77+1:ii*77)),2);
    
end
mean_I(1:length(t_seq),16) = mean(I_seq(:,((ii-1)*77+1:end)),2);
figure
hold on
legend_string = cell(1,size(mean_I,2));
for ii = 1:16

    plot(mean_I(:,ii)/10000,'linewidth',1.5);
    legend_string{ii} = [num2str(400+(ii-1)*25) '~' num2str(425+(ii-1)*25) 'nm'];

end
legend(legend_string);

x = [0:766/3:1001 1001];
% tmp2 = [0:-0.2:-0.6 -0.42];
tmp2 = [-0.42 -0.6:0.2:0];
x_label = cell(length(tmp2),1);
for ii = 1:length(x_label)
    
    x_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

% x = 0:20:120;
% x_label = [0:-0.2:-0.6 -0.4:0.2:0];
% x_label = num2cell(x_label);
% set(gca,'xtick',x);
% set(gca,'xticklabel',x_label);
xlabel('Potential v.s Ag/AgCl (V)');
ylabel('Intensity (*10^4)');
title('20201102\_variation trend of intensity in different wavelength range');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on


figure
mesh(mean_I);
x = 1:16;
for ii = 1:16

    x_label{ii} = [num2str(400+(ii-1)*25) '~' num2str(425+(ii-1)*25)];

end
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);
xlabel('Wave Length (nm)');

y = [0:766/3:1001 1001];
tmp2 = [0:-0.2:-0.6 -0.42];
% tmp2 = [-0.42 -0.6:0.2:0];
y_label = cell(length(tmp2),1);
for ii = 1:length(y_label)
    
    y_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'ytick',y);
set(gca,'yticklabel',y_label);

ylabel('Potential v.s Ag/AgCl (V)');
zlabel('Intensity');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
set(gca,'XTickLabelRotation',-45)
title('20201102\_variation trend of intensity in different wavelength range');


%% 相对强度

for ii = 1:1001
    
    mean_reletive_I(ii,:) = (mean_I(ii,:)-mean_I(1,:))./mean_I(1,:);
    
end 

figure
hold on
legend_string = cell(1,size(mean_I,2));
for ii = 1:16

    plot(mean_reletive_I(:,ii),'linewidth',1.5);
    legend_string{ii} = [num2str(400+(ii-1)*25) '~' num2str(425+(ii-1)*25) 'nm'];

end
legend(legend_string);

x = [0:766/3:1001 1001];
tmp2 = [0:-0.2:-0.6 -0.42];
% tmp2 = [-0.42 -0.6:0.2:0];
x_label = cell(length(tmp2),1);
for ii = 1:length(x_label)
    
    x_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

xlabel('Potential v.s Ag/AgCl (V)');
ylabel('Relative Intensity');
title('20201102\_variation trend of intensity in different wavelength range');

set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
box on
xlim([0 1001]);



figure
mesh(mean_reletive_I);
x = 1:16;
for ii = 1:16

    x_label{ii} = [num2str(400+(ii-1)*25) '~' num2str(425+(ii-1)*25)];

end
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);
xlabel('Wave Length (nm)');

y = [0:766/3:1001 1001];
tmp2 = [0:-0.2:-0.6 -0.42];
% tmp2 = [-0.42 -0.6:0.2:0];
y_label = cell(length(tmp2),1);
for ii = 1:length(y_label)
    
    y_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'ytick',y);
set(gca,'yticklabel',y_label);

ylabel('Potential v.s Ag/AgCl (V)');
zlabel('reletive Intensity');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
set(gca,'XTickLabelRotation',-45)
title('20201102\_variation trend of intensity in different wavelength range');

%% 选择550~600nm的波段进行分析

figure
I_sample1 = mean(I_seq(:,round(1231*300/400:1231*350/400)),2);  % 550~600nm
plot(I_sample1/10000,'r','linewidth',1.5);
set(gca,'xtick',y);
set(gca,'xticklabel',y_label);
ylabel('Intensity (*10^4)');
xlabel('Potential v.s Ag/AgCl (V)');
title('20201102\_700~750 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on

figure
I_sample2 = mean(I_seq(:,round(1231*125/400:1231*175/400)),2);  % 650~700nm
plot(I_sample2/10000,'r','linewidth',1.5);
set(gca,'xtick',y);
set(gca,'xticklabel',y_label);
ylabel('Intensity (*10^4)');
xlabel('Potential v.s Ag/AgCl (V)');
title('20201102\_525~575 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on

figure
potential_range = [0:-0.01:-0.6 -0.59:0.01:-0.01];      
plot(diff(I_sample1),'r','linewidth',1.5)
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
set(gca,'ytick',[]);
xlabel('Potential v.s Ag/AgCl (V)');
ylabel('\Delta Intensity (a.u.)');
title('20201102\_550~600 nm');
box on

figure
potential_range = [0:-0.01:-0.6 -0.59:0.01:-0.01];
% plot(potential_range,diff(I_sample2),'r','linewidth',1.5)
plot(diff(I_sample2),'r','linewidth',1.5)
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
xlabel('Potential v.s Ag/AgCl (V)');
set(gca,'ytick',[]);
ylabel('\Delta Intensity (a.u.)');
title('20201102\_650~700 nm');
box on

close all

%% 吸光度变化趋势

I_relative = I_inv;
for ii = 1:size(I_inv,1)
    I_relative(ii,:) = log(I_inv(end,:)./I_inv(ii,:));
end
figure
imagesc(I_relative(:,51:1150))
colorbar

y = [0:766/3:1001 1001];
tmp2 = [-0.42 -0.6:0.2:0];
y_label = cell(length(tmp2),1);
for ii = 1:length(y_label)
    
    y_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'ytick',y);
set(gca,'yticklabel',y_label);

x = 100:150:1100;     % 在x处进行刻度说明，x是一个一维向量
tmp1 = 450:50:750;
x_label = cell(length(tmp1),1);
for ii = 1:length(tmp1)
    
    x_label{ii} = num2str(tmp1(ii));           % 刻度说明内容，x_label是一个一维字符串数组
    
end
set(gca,'xtick',x);                                 % 表示在x处进行刻度标记
set(gca,'xticklabel',x_label);                      % 表示标记内容是x_label中的内容，因此需要x与x_label一一对应
set(gca,'layer','bottom');                          % 只显示刻度处标记而不显示刻度线

xlabel('Wave Length (nm)');
ylabel('Potential v.s Ag/AgCl (V)');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
title('20201102\_ScanRate\_1 mV/s\_normalization based on the initial spectral data');
axis square


figure
I_sample1 = mean(I_relative(:,round(1231*250/400:1231*300/400)),2);  % 650~700nm
tmp1 = I_sample1;
for ii = 1:length(tmp1)
    tmp1(ii) = I_sample1(1001-ii+1);
end
plot(-diff(tmp1),'r','linewidth',1.5);
x = [0:766/3:1001 1001];
tmp2 = [0:-0.2:-0.6 -0.42];
x_label = cell(length(tmp2),1);
for ii = 1:length(x_label)
    
    x_label{ii} = num2str(tmp2(ii));
    
end
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

ylabel('diff(\DeltaAbsorbance) (a.u.)');
set(gca,'yticklabel',[]);
xlabel('Potential v.s Ag/AgCl (V)');
title('20201117\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on

figure
plot(tmp1,'r','linewidth',1.5);
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

ylabel('\DeltaAbsorbance (a.u.)');
set(gca,'yticklabel',[]);
xlabel('Potential v.s Ag/AgCl (V)');
title('20201117\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on


figure
I_sample2 = mean(I_reletive(:,round(1231*250/400:1231*300/400)),2);  % 650~700nm
tmp2 = I_sample2;
for ii = 1:length(tmp2)
    tmp2(ii) = I_sample2(1001-ii+1);
end
plot(diff(tmp2),'r','linewidth',1.5);
grid on
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

ylabel('diff(\DeltaTransmittance) (a.u.)');
set(gca,'yticklabel',[]);
xlabel('Potential v.s Ag/AgCl (V)');
title('20201117\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on

figure
plot(tmp2,'r','linewidth',1.5);
grid on
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

ylabel('\DeltaTransmittance (a.u.)');
set(gca,'yticklabel',[]);
xlabel('Potential v.s Ag/AgCl (V)');
title('20201117\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on

tmp3 = mean(I_relative,2);
for ii = 1:length(tmp3)
    tmp4(ii) = tmp3(1002-ii);
end
figure
plot(tmp4)
plot(diff(tmp4),'r','linewidth',1.5);
grid on
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

ylabel('diff(\DeltaTransmittance) (a.u.)');
set(gca,'yticklabel',[]);
xlabel('Potential v.s Ag/AgCl (V)');
title('20201117\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on

figure
plot(tmp4,'r','linewidth',1.5);
grid on
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);

ylabel('\DeltaTransmittance (a.u.)');
set(gca,'yticklabel',[]);
xlabel('Potential v.s Ag/AgCl (V)');
title('20201117\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 1001]);
box on























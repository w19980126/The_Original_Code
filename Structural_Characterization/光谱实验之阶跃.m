%% ����������ͼ

%% ��ԭʼ�����з���õ�ǿ�ȡ�������ʱ�����

% ʱ���ǿ�Ⱦ����Ϊ˳��seq�����ϵ��¶�Ӧʱ��ӿ�ʼ��������
% ������inv�����ϵ��¶�Ӧʱ��ӽ�������ʼ��
% ��ô����Ŀ���Ƿ����ά��ͼʱ����������������Ǵ�С�䵽��

t_seq = PS(2:end,1);
wave_length = PS(1,2:end);
I_seq = PS(2:end,2:end);
[t_inv,t_index] = sort(t_seq,'descend');
I_inv = I_seq(t_index,:);

%% ����ǿ��ת�ɶ�άͼ���������ᣬ���µ��϶�Ӧʱ���0��1200s

figure
imagesc(I_inv);
colorbar

x = round((1:150:length(wave_length))/150)*150;     % ��x�����п̶�˵����x��һ��һά����
x = 0:1231/400*50:1231;
x_label = num2cell(400:50:800);
set(gca,'xtick',x);                                 % ��ʾ��x�����п̶ȱ��
set(gca,'xticklabel',x_label);                      % ��ʾ���������x_label�е����ݣ������Ҫx��x_labelһһ��Ӧ
set(gca,'layer','bottom');                          % ֻ��ʾ�̶ȴ���Ƕ�����ʾ�̶���

set(gca,'ytick',[]);

xlabel('Wave Length (nm)');
ylabel('Potential v.s Ag/AgCl (V)');
title('20201102\_Potential Step From 0 to -0.5 to 0 V (v.s Ag/AgCl)');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
axis square

I_inv_part = I_inv(end-11:end,:);
figure
imagesc(I_inv_part);
axis square
colormap(parula(256))
colorbar

x = 0:1231/400*50:1231;
x_label = num2cell(400:50:800);
y = 1.2:2.4:12;
y_label = num2cell([0 -0.5 0 -0.5 0]);
set(gca,'xtick',x);                             
set(gca,'xticklabel',x_label);   
set(gca,'ytick',y);                             
set(gca,'yticklabel',y_label);   
set(gca,'layer','bottom');

xlabel('Wave Length (nm)');
ylabel('Potential v.s Ag/AgCl (V)');
title('20201102\_Potential Step From 0 to -0.5 to 0 V (v.s Ag/AgCl)');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');


%% ���ǿ��ת�ɶ�άͼ���������ᣬ���µ��϶�Ӧʱ���0��1200s

figure
% I_relative = I_inv(:,round(50*1231/400:350*1231/400));        
% ���εĲ��ι�ǿ��С�������������ţ��ʹ�һ��ʱ��������
I_relative = I_inv;
% tmp = I_inv(:,round(50*1231/400:350*1231/400));
% 
% for ii = 1:size(I_relative,1)
%     
%     I_relative(ii,:) = (tmp(ii,:)-tmp(end,:))./tmp(end,:);
% 
% end

for ii = 1:size(I_relative,1)
    
    I_relative(ii,:) = (I_inv(ii,:)-I_inv(end,:))./I_inv(end,:);

end
% I_relative(:,54:57) = [];
imagesc(I_relative);
colorbar

x = 0:1231/400*50:1231/400*50*9;
x_label = num2cell(400:50:800);
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);
set(gca,'ytick',[]);
xlabel('Wave Length (nm)');
ylabel('Potential v.s Ag/AgCl (V)');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
title('20201102\_ScanRate\_1 mV/s\_normalization based on the initial spectral data');
axis square

%% ÿ��50nm����ƽ��Ȼ����ͼ

wave_step = length(wave_length)/400;
for ii = 1:7
    
    mean_I(1:length(t_seq),ii) = mean(I_seq(:,((ii-1)*154+1:ii*154)),2);
    
end
mean_I(1:length(t_seq),8) = mean(I_seq(:,((ii-1)*154+1:end)),2);
figure
hold on
legend_string = cell(1,size(mean_I,2));
for ii = 1:8

    plot(mean_I(:,ii)/10000,'linewidth',1.5);
    legend_string{ii} = [num2str(400+(ii-1)*50) '~' num2str(450+(ii-1)*50) 'nm'];

end
legend(legend_string);

x = 0:30:180;
x_label = 0:300:1800;
x_label = num2cell(x_label);
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);
xlabel('Time (s)');
ylabel('Intensity (*10^4)');
title('20201102\_variation trend of intensity in different wavelength range');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 181]);
ylim([0 3])
box on

%% ���ǿ��

clear mean_I
clear mean_relative_I
for ii = 1:3
    
    mean_I(1:length(t_seq),ii) = mean(I_seq(:,((ii-1)*308+1:ii*308)),2);
    
end
mean_I(1:length(t_seq),4) = mean(I_seq(:,((ii-1)*308+1:end)),2);

for ii = 1:181
    
    mean_relative_I(ii,:) = (mean_I(ii,:)-mean_I(1,:))./mean_I(1,:);
    
end 

figure
for ii = 1:4
    
    subplot(eval(['22' num2str(ii)]));
    plot(mean_relative_I(:,ii),'linewidth',1.5);
    title([num2str(400+(ii-1)*100) '~' num2str(500+(ii-1)*100) 'nm']);
    
    x = 0:60:180;
    x_label = 0:600:1800;
    x_label = num2cell(x_label);
    set(gca,'xtick',x);
    set(gca,'xticklabel',x_label);
    xlabel('Time (s)');
    ylabel('Relative Intensity');

    set(gca,'titlefontweight','bold');
    set(gca,'fontsize',15);
    set(gca,'fontweight','bold');
    set(gca,'layer','bottom');
    axis square
    box on
    xlim([0 181]);
    ylim([-0.25 0]);

end


figure
mesh(mean_relative_I);
x = 1:16;
for ii = 1:16

    x_label{ii} = [num2str(400+(ii-1)*25) '~' num2str(425+(ii-1)*25)];

end
set(gca,'xtick',x);
set(gca,'xticklabel',x_label);
xlabel('Wave Length (nm)');
y = 0:20:120;
y_label = [0:-0.2:-0.6 -0.4:0.2:0];
y_label = num2cell(y_label);
set(gca,'ytick',y);
set(gca,'yticklabel',y_label);
ylabel('Potential v.s Ag/AgCl (V)');
zlabel('relative Intensity');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
set(gca,'XTickLabelRotation',-45)
title('20201102\_variation trend of intensity in different wavelength range');

%% ѡ��550~600nm�Ĳ��ν��з���

figure
I_sample1 = mean(I_seq(:,round(1231*150/400:1231*200/400)),2);  % 550~600nm
plot(I_sample1/10000,'r','linewidth',1.5);
set(gca,'xtick',y);
set(gca,'xticklabel',y_label);
ylabel('Intensity (*10^4)');
xlabel('Potential v.s Ag/AgCl (V)');
title('20201102\_550~600 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 121]);
box on

figure
I_sample2 = mean(I_seq(:,round(1231*250/400:1231*300/400)),2);  % 650~700nm
plot(I_sample2/10000,'r','linewidth',1.5);
set(gca,'xtick',y);
set(gca,'xticklabel',y_label);
ylabel('Intensity (*10^4)');
xlabel('Potential v.s Ag/AgCl (V)');
title('20201102\_650~700 nm');
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
axis square
xlim([0 121]);
box on

figure
potential_range = [0:-0.01:-0.6 -0.59:0.01:-0.01];      
plot(potential_range,diff(I_sample1),'r','linewidth',1.5)
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
set(gca,'ytick',[]);
xlabel('Potential v.s Ag/AgCl (V)');
ylabel('\Delta Intensity (a.u.)');
title('20201102\_550~600 nm');
box on

figure
potential_range = [0:-0.01:-0.6 -0.59:0.01:-0.01];
plot(potential_range,diff(I_sample2),'r','linewidth',1.5)
set(gca,'titlefontweight','bold');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'layer','bottom');
xlabel('Potential v.s Ag/AgCl (V)');
set(gca,'ytick',[]);
ylabel('\Delta Intensity (a.u.)');
title('20201102\_650~700 nm');
box on

close all





























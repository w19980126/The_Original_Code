%% 

potential = CV_data(:,1);
current = CV_data(:,2:12);
plot(potential,current);
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
xlabel('Potential vs.Ag/AgCl (V)');
ylabel('Current (A)');
title('变扫速CV实验,溶液:250mM Na_2SO_4');
legend('50mV/s','100mV/s','200mV/s','300mV/s','400mV/s','500mV/s','600mV/s','700mV/s','800mV/s','900mV/s','1000mV/s');
set(gca,'linewidth',2);
set(h,'linewidth',2);

path = 'F:\表征\CHI\20201019\CV_data.mat';
save(path,'CV_data')

%% ip拟合

v = 0:100:600;
v(1) = 50;
i1 = [3.05 6.15 10.22 12.62 13.95 15.31 17.53];
i2 = [1.811 3.405 5.971 7.665 8.997 10.16 11.43];
i3 = [7.445 10.59 14.47 16.8 18.64 19.91 21.17];
i4 = [3.77 5.961 8.95 10.84 12.25 13.83 14.97];
p1 = polyfit(log(v),log(i1),1);
p2 = polyfit(log(v),log(i2),1);
p3 = polyfit(log(v),log(i3),1);
p4 = polyfit(log(v),log(i4),1);
figure
hold on
plot(v,i1,'s','markersize',10);
plot(v,i2,'o','markersize',10);
plot(v,i3,'<','markersize',10);
plot(v,i4,'>','markersize',10);
plot(v,exp(p1(2))*v.^(p1(1)),'linewidth',1.5);
plot(v,exp(p2(2))*v.^(p2(1)),'linewidth',1.5);
plot(v,exp(p3(2))*v.^(p3(1)),'linewidth',1.5);
plot(v,exp(p4(2))*v.^(p4(1)),'linewidth',1.5);
legend('氧化峰1','氧化峰2','还原峰1','还原峰2',...
    ['i_{Ox1} = ' num2str(exp(p1(2))) 'v^{' num2str(p1(1)) '}'],...
    ['i_{Ox2} = ' num2str(exp(p2(2))) 'v^{' num2str(p2(1)) '}'],...
    ['i_{Re1} = ' num2str(exp(p3(2))) 'v^{' num2str(p3(1)) '}'],...
    ['i_{Re2} = ' num2str(exp(p4(2))) 'v^{' num2str(p4(1)) '}']);
h_line = findobj(gcf,'type','line');
set(gca,'fontsize',15);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
xlabel('Potential vs.Ag/AgCl (V)');
ylabel('Current (a.u.)');
title('变扫速CV实验,溶液:250mM Na_2SO_4');
set(gca,'linewidth',2);
set(h,'linewidth',2);
h_legend = findobj(gcf,'type','legend');
set(gca,'ytick',[]);
set(h_legend,'fontsize',15);
path = 'F:\表征\CHI\20201019\峰电流拟合.fig';
saveas(gcf,path);
















%% AFM�߶�ͼ

close
x = A(:,1);
y = A(:,2);
figure
plot(x,y,'k','linewidth',2);
xlabel('Horizantal distance (\mum)');
ylabel('Height (nm)');
box on
grid on
xlim([min(x) max(x)]);
ylim([0 9]);
set(gca,'fontsize',15,'fontweight','bold');

%% �߶�ֱ��ͼ

close
x = A(:,1);
y = A(:,2);
figure
plot(x,y,'k','linewidth',2);
xlabel('Height (nm)');
ylabel('Percentage (%)');
box on
grid on
xlim([min(x) max(x)]);
ylim([0 40]);
set(gca,'fontsize',15,'fontweight','bold');
title('���䰵��Ʒ�߶�ֱ��ͼ','fontweight','bold')





















%% 
 v = 50:25:200;
ip = [1.193 2.121 2.48 2.996 3.179 3.639 3.755];
 x = log(v);
 y = log(ip);
 p = polyfit(x,y,1);
 
 figure
 plot(v,ip,'*','markersize',10);
 hold on
 plot(v,exp(p(2))*v.^(p(1)),'linewidth',2);
 set(gca,'fontsize',15);
 set(gca,'fontweight','bold');
 xlabel('Scan Rate (mV/s)');
 ylabel('i_p (a.u.)');
 legend('原始数据',['i_p = ' num2str(exp(p(2))) 'v^{' num2str(p(1)) '}']);
title('20201009\_zone\_1\_Gaussian\_50\_6');
%  title('20201009\_zone\_1\_smooth\_0.1');
 set(gca,'titlefontweight','bold');
 set(gca,'Ytick',[]);
 box on
 axis tight

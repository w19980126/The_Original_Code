function Value = For_Peak_Fit(Value,ScanRate_range,num,figpath)

%% ������ͨ���Բ�ͬɨ���¿ۻ��׺�ķ��������һ��������ϵõ����

% ScanRate_range��ʾɨ�ٷ�Χ����ʾΪ[min(v) max(v)]
% num��ʾ������ϵ����ݵ�ĸ���

figure
hold on
tmp = length(Value(1).V_Peak);
ScanRate = zeros(1,num);
I_peak = zeros(1,length(tmp));
legend_string = cell(1,length(tmp));

for jj = 1:tmp
        
        for ii = 1:num
            
            ScanRate(ii) = Value(ii).ScanRate;
            I_peak(ii) = Value(ii).I_peak(jj);
            
        end
        
        if jj > tmp/2
            x = log(ScanRate);
            y = log(-I_peak);
            p = polyfit(x,y,1);
            plot(ScanRate,I_peak*10^6,'o','markersize',10);
            tmp2 = ScanRate_range(1):0.1:ScanRate_range(2);
            h_fit(jj) = plot(tmp2,-exp(p(2))*tmp2.^(p(1))*10^6,'linewidth',2);
            legend_string{jj} = [num2str(exp(p(2))) 'v^{' num2str(p(1)) '}'];
            Value(jj).peakname = ['Re_Peak_' num2str(jj-3)];
        else
            x = log(ScanRate);
            y = log(I_peak);
            p = polyfit(x,y,1);
            plot(ScanRate,I_peak*10^6,'o','markersize',10);
            tmp2 = ScanRate_range(1):0.1:ScanRate_range(2);
            h_fit(jj) = plot(tmp2,exp(p(2))*tmp2.^(p(1))*10^6,'linewidth',2);
            legend_string{jj} = [num2str(exp(p(2))) 'v^{' num2str(p(1)) '}'];
            Value(jj).peakname = ['Ox_Peak_' num2str(jj)];
        end
        
        eval(['Value(jj).p_fit_' num2str(ScanRate_range(1)) '_' num2str(ScanRate_range(2)) '= p;']);
            
end


legend(h_fit,legend_string);
xlabel('Scan Rate (mV/s)');
ylabel('Current (\muA)');
title('��ͳ�绯ѧʵ���������');
box on
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
tmppath = fullfile(figpath,['ScanRate_Range_' num2str(ScanRate_range(1)) '_' num2str(ScanRate_range(2)) '.fig']);
saveas(gcf,tmppath);

end

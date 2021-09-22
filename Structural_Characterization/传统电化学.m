%% 传统电化学CV作图

% 数据都将存在Value数组中

% 需要人为修改ScanRate和SaveRoute


%% 获得最原始的数据并用来作图

CVdata(1:3,:) = [];
V = CVdata(:,1);
I = CVdata(:,2:end);
ScanRate = [50 100:100:1000];
SaveRoute = 'F:\Structural_Characterization\CHI\20201019';

figure
hold on
for ii = 1:size(I,2)
    
    plot(V,I(:,ii)*10^6,'linewidth',2);
    
    legend_string{ii} = [num2str(ScanRate(ii)) 'mV/s'];
    Value(ii).expname = [num2str(ScanRate(ii)) 'mVs'];
    Value(ii).ScanRate = ScanRate(ii);
    
end 
xlabel('Potential v.s Ag/AgCl (V)');
ylabel('Current (\muA)');
title('20201027\_250mM K_2SO_4');
legend(legend_string);
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
figpath = [SaveRoute '\变扫速CV之快扫.fig'];
saveas(gcf,figpath);
box on
axis square

%% 找到基线数据和拟合多项式的值

% 找出各组的基底并存到Value中
% 对于同一个扫速，同时有氧化基底Baseline_Ox、还原基底Baseline_Re、氧化拟合多项式p_Ox、还原拟合多项式p_Re

mkdir(fullfile(SaveRoute,'Baseline'));

n = 4;
 for ii = 1:size(I,2)
% for ii = 1:2
    
    seg_num = 1;
    [Baseline,p,choise] = Baseline_Deduction(V,I(:,ii),seg_num,n);
    
    switch choise
        case '满意'
            Value(ii).Baseline_Re = Baseline;
            Value(ii).p_Re = p;
            figpath = fullfile(SaveRoute,'Baseline',[Value(ii).expname '_Re.fig']);
            saveas(gcf,figpath);
            continue;
        case '不满意'
            close gcf
            n = input('请输入n:');
            [Baseline,p,choise] = Baseline_Deduction(V,I(:,ii),seg_num,n);
    end
            
 end

n = 7;
for ii = 1:size(I,2)
        
    seg_num = 2;
    [Baseline,p,choise] = Baseline_Deduction(V,I(:,ii),seg_num,n);
    
    switch choise
        case '满意'
            Value(ii).Baseline_Ox = Baseline;
            Value(ii).p_Ox = p;
            figpath = fullfile(SaveRoute,'Baseline',[Value(ii).expname '_Ox.fig']);
            saveas(gcf,figpath);
            continue;
        case '不满意'
            n = input('请输入n');
            [Baseline,p,choise] = Baseline_Deduction(V,I(:,ii),seg_num,n);
    end
            
end

%% 找到扣基底后的峰电流值

mkdir(fullfile(SaveRoute,'Baseline_Substrated'));

for ii = 1:size(I,2)
    for ii = 2:7:9

    [Value(ii).V_Peak,Value(ii).I_peak,Value(ii).I_peak,choise] = For_CV_Peak(V,I(:,ii),Value(ii).p_Re,Value(ii).p_Ox,ii);
    
    
    switch choise
        case '满意'
            figpath = fullfile(SaveRoute,'Baseline_Substrated',[Value(ii).expname '_BaselineSubstrated.fig']);
            saveas(gcf,figpath);
            continue;
        case '不满意'
            [Value(ii).V_Peak,Value(ii).I_peak,Value(ii).I_peak,choise] = For_CV_Peak(V,I(:,ii),Value(ii).p_Re,Value(ii).p_Ox,ii);
    end
    
end

close all

%% 利用抠背底的数据进行一阶拟合

mkdir(fullfile(SaveRoute,'Fit_Result'));
figpath = fullfile(SaveRoute,'Fit_Result');
Value = For_Peak_Fit(Value,[50 400],length(Value)-6,figpath);
save(fullfile(SaveRoute,'Value.mat'),'Value');



%% 

figure
hold on

for ii = 1:10
    
    II = I(:,ii);
    p_Re = Value(ii).p_Re;
    p_Ox = Value(ii).p_Ox;
    Base_Re = polyval(p_Re,V(1:end/2));
    Base_Ox = polyval(p_Ox,V(end/2+1:end));
    BaseSubstrated_II = II - [Base_Re;Base_Ox];
    Value(ii).BaseSubstrated_Current = BaseSubstrated_II;
    plot(V,BaseSubstrated_II*10^6,'linewidth',2);
    legend_string{ii} = Value(ii).expname;

end 
legend(legend_string);
title('20201027\_250mM K_2SO_4');
set(gca,'fontsize',20);
set(gca,'fontweight','bold');
set(gca,'titlefontweight','bold');
figpath = [SaveRoute '\变扫速CV之快扫.fig'];
saveas(gcf,figpath);
box on
axis square
xlabel('Potential v.s Ag/AgCl (V)');
ylabel('Current (\muA)');



















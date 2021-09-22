function [V_Peak,I_RawPeak,I_peak,choise] = For_CV_Peak(V,II,p_Re,p_Ox,ii)

%% 本函数是将实际测得的CV曲线和拟合得到的基线进行差减从而得到峰电流的值

% V、II:输入的电势和电流的原始数据
% p_Re/p_Ox：输入的基线的拟合值,用来重构基线从而得到抠除基线后的CV曲线
% ScanRate：扫描速率，用于对得到的Value数组进行分类
% 对于每一个扫速得到偶数对峰电流，依次是氧化峰电流还原峰电流且从左到右一一对应
% ii：第ii组被扣除的基线，用于保存图像信息

% V_peak、I_RawPeak、I_peak：通过鼠标选择到的出峰电势、原始峰电流和抠基线后的峰电流
% choise：返回满意值，如不满意则重新取点直到满意

%%

    Base_Re = polyval(p_Re,V(1:end/2));
    Base_Ox = polyval(p_Ox,V(end/2+1:end));
    BaseSubstrated_II = II - [Base_Re;Base_Ox];
    
    figure
    set(gcf,'position',get(0,'screensize'));
    
    ax1 = subplot(211);
    plot(V,II);
    hold on
    plot(V,[Base_Re;Base_Ox]);
    title(num2str(ii));
    
    ax2 = subplot(212);
    plot(V,BaseSubstrated_II);
    hold on
    [x,~] = ginput();
    x = round(x*1000)/1000;
    title(num2str(ii));
    
    for ii = 1:length(x)
        
        tmp = find(abs(V-x(ii)) < eps);
        if ii <= length(x)/2
                y(ii) = II(tmp(2));
                yy(ii) = y(ii) - polyval(p_Ox,x(ii));
        else
                y(ii) = II(tmp(1));
                yy(ii) = y(ii) - polyval(p_Re,x(ii));
        end
        
    end
    
    axes(ax1)
    plot(x,y,'*');
    axes(ax2)
    plot(x,yy,'*');
    V_Peak = x;
    I_RawPeak = y;
    I_peak = yy;
    
    
    function choice = choosedialog

        d = dialog('Position',[300 300 250 150],'Name','Select One');
        txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','满意吗');

        popup = uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[75 70 100 25],...
               'String',{'满意';'不满意'},...
               'Callback',@popup_callback);

        btn = uicontrol('Parent',d,...
               'Position',[89 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

        choice = '满意';

        % Wait for d to close before running to completion
        uiwait(d);

           function popup_callback(popup,event)
              idx = popup.Value;
              popup_items = popup.String;
              choice = char(popup_items(idx,:));
           end
    end      

    choise  = choosedialog;

end
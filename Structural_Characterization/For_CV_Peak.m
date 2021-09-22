function [V_Peak,I_RawPeak,I_peak,choise] = For_CV_Peak(V,II,p_Re,p_Ox,ii)

%% �������ǽ�ʵ�ʲ�õ�CV���ߺ���ϵõ��Ļ��߽��в���Ӷ��õ��������ֵ

% V��II:����ĵ��ƺ͵�����ԭʼ����
% p_Re/p_Ox������Ļ��ߵ����ֵ,�����ع����ߴӶ��õ��ٳ����ߺ��CV����
% ScanRate��ɨ�����ʣ����ڶԵõ���Value������з���
% ����ÿһ��ɨ�ٵõ�ż���Է�����������������������ԭ������Ҵ�����һһ��Ӧ
% ii����ii�鱻�۳��Ļ��ߣ����ڱ���ͼ����Ϣ

% V_peak��I_RawPeak��I_peak��ͨ�����ѡ�񵽵ĳ�����ơ�ԭʼ������Ϳٻ��ߺ�ķ����
% choise����������ֵ���粻����������ȡ��ֱ������

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
               'String','������');

        popup = uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[75 70 100 25],...
               'String',{'����';'������'},...
               'Callback',@popup_callback);

        btn = uicontrol('Parent',d,...
               'Position',[89 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');

        choice = '����';

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
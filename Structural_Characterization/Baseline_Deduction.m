function [Baseline_,p,choise] = Baseline_Deduction(V,II,seg_num,n)
%% �����������õ�CV���ߵĻ��߲���n�����

% V��I��ʾCV���ߵĵ��ƺ͵���
% x��ʾʹ��ginput�����õ��Ļ��ߵ�ʼĩ��
% seg_num��ʾ�ڼ��Σ���ΪCV�Ƿǵ�ֵ������������Ҫͨ��seg_num����������ĵ���ֵ
% n��ʾn�����
% Baseline��ʾ��CV�����аǵ���ʵ�ʵĵ����͵��Ƶ�����
% p��ʾ�������

%%
    
    potential_step = V(2)-V(1);
	figure;
    plot(V,II);
    set(gcf,'unit','normalized', 'position', [0,0,1,1]);
    switch seg_num
        case 1
            title('Re');
        case 2
            title('Ox');
    end
    [x,~] = ginput();
    xx = round(x/potential_step)*potential_step;
    BL_length = 0;
    close gcf
    
    for ii = 1:length(xx)
       
        tmp = find(abs(V - xx(ii)) < eps);  
        mark(ii) = tmp(seg_num);
        
        if mod(ii,2) == 1
            BL_length = BL_length;
        else 
            d_length = abs(mark(ii)-mark(ii-1));
            Baseline_(BL_length+1:BL_length+d_length+1,1) = V(min([mark(ii-1) mark(ii)]):max([mark(ii-1) mark(ii)]));
            Baseline_(BL_length+1:BL_length+d_length+1,2) = II(min([mark(ii-1) mark(ii)]):max([mark(ii-1) mark(ii)]));
            BL_length = BL_length + d_length +1;
        end
        
    end
    
%     [Baseline(:,1),B_index] = sort(Baseline(:,1));
%     tmp = Baseline(:,2);
%     Baseline(:,2) = tmp(B_index);
    
    tmp = cell(1,3);
    for ii = 1:3
        
        tmp{ii} = Baseline_(:,1)*0.25*ii;
%         eval(['tmp' num2str(ii) '=' 'Baseline_(:,1)*(0.25*' num2str(ii) ');']);
        
    end
    
    method = 'pchip';
    Baseline(:,1) = sort([Baseline_(:,1);tmp{1};tmp{2};tmp{3}]);
    Baseline(:,2) = interp1(Baseline_(:,1),Baseline_(:,2),Baseline(:,1),method);
    
    p = polyfit(Baseline(:,1),Baseline(:,2),n);
    figure
    plot(V,II,'o');
    hold on
    Potential = V((seg_num-1)*length(V)/2+1:length(V)/2*seg_num);
    plot(Potential,polyval(p,Potential),'linewidth',1.5);
    title(method);
    
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
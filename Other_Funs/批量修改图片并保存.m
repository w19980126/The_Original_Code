%% �����޸�ͼƬ������

for i = 1:length(expTab)
    
    zone = expTab(i).zone;
    
    for j = 1:zone
        
        tmp = dir(fullfile(expTab(i).saveroute,expTab(i).expname,['zone' num2str(j)],'*.fig'));
        
        for ii = 2:length(tmp)

            uiopen(fullfile(tmp(ii).folder,tmp(ii).name),1);
            axis tight
            new_folder = [expTab(i).saveroute '\' expTab(i).expname '\zone' num2str(j)];
            mkdir(new_folder);
            saveas(gcf,[new_folder '\' tmp(ii).name]);
            close
            
        end
        
    end
    
end
%% α��ɫͼƬ

for ii = 1:length(expTab)
    
    expname = expTab(ii).expname;
    tifpath = expTab(ii).tifpath;
    frame = expTab(ii).begin.frame;
    saveroute = expTab(ii).saveroute;
    value_route = fullfile(saveroute,expname,[expname '_zone1_Value.mat']);
    load(value_route);
    tifDir = Value.tifDir;
    avr = Value.avr;
    [~,loc] = max(abs(avr));
    first_fig = imread(fullfile(tifpath,tifDir(1).name));
    pseudo_color(first_fig);
    title('δ����ʱ��ͼƬ','fontsize',15);
    tmp_savepath = [saveroute '\' expname '\' expname 'δ���ʾ��ͼ.fig'];
    intercated_fig = imread(fullfile(tifpath,tifDir(loc).name))-first_fig;
    saveas(gcf,tmp_savepath);
    close;
    pseudo_color(intercated_fig);
    title('��ȫ����ʱ��ͼƬ','fontsize',15);
    tmp_savepath = [saveroute '\' expname '\' expname '��ȫ����ʾ��ͼ.fig'];
    saveas(gcf,tmp_savepath);
    close;
    
end

    
    























                    
        
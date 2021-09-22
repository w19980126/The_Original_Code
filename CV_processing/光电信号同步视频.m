%% ����ź�ͬ����Ƶ

CS_route = uigetdir('H','请打�?CS文件�?在文件夹，即_CS之类');
CS_dir = dir(fullfile(CS_route,'*.cor'));

for ii = 1:length(expTab)
    
    for jj = 3
        
        saveroute = expTab(ii).saveroute;
        expname = expTab(ii).expname;
        load(fullfile(saveroute,expname,[expname '_zone' num2str(jj) '_Value.mat']));
        T_avr = Value.T_avr;
        G_OD_avr = Value.G_OD_avr;
        dG_OD_avr = diff(G_OD_avr);

        samplerate = expTab(ii).samplerate;
        frame = Value.begin.frame;
%         tifpath = expTab(ii).tifpath;
%         tifdir = dir(fullfile(tifpath,'*.tiff'));
%         tif1 = double(imread(fullfile(tifpath,tifdir(1).name)));
%         I_bg = expTab(ii).I_background;
%         Delta_I_avr = I_bg*T_avr;

    % ---------------------------------以下，判断变亮变�?---------------------------------

            if mean(G_OD_avr) >0
                LD = 'L';
            elseif mean(G_OD_avr) <0
                LD = 'D';
            end

            if LD == 'L'
                dG_OD_avr = -dG_OD_avr;
            elseif LD == 'D'
                dG_OD_avr = dG_OD_avr;
            end

    % ---------------------------------以下，读入CS数据---------------------------------

        CS = importdata(fullfile(CS_route,CS_dir(ii).name));
        CS_potential = CS.data(1:end-1,1);
        CS_current = CS.data(1:end-1,2);
        CS_time = CS.data(1:end-1,3);

    % ---------------------------------以下，设置图片格�?---------------------------------

        temp = round(100/samplerate);

        figure
        set(gcf,'Units','normalized','position',[0.1 0.1 0.8 0.8]);

        h1 = subplot(131);
        hold on
        set(h1,'XLim',[-0.6 0]);
        set(h1,'Ylim',10^6*[min(CS_current) max(CS_current)]);
        xlabel('Potential (V vs. Ag/AgCl)');
        ylabel('Current (\muA)');
        title('Potential-Current curve','fontweight','bold');
        box on
        Fig_Standard;

        h2 = subplot(132);
        hold on
        set(h2,'XLim',[frame+1 frame+floor(length(CS_potential)/temp)]);    % 保持CS采的数据长度和相机采的数据长度一�?
        set(h2,'Ylim',[min(G_OD_avr) max(G_OD_avr)]);
        xlabel('Frames');
        ylabel('\DeltaOD');
        title('Potential-\DeltaOD curve','fontweight','bold');
        box on
        Fig_Standard;

        h3 = subplot(133);
        hold on
        set(h3,'XLim',[-0.6 0]);
        set(h3,'Ylim',[min(dG_OD_avr) max(dG_OD_avr)]);
        xlabel('Potential (V vs. Ag/AgCl)');
        set(h3,'ytick',[]);
        title('Potential-diff(\DeltaOD) curve','fontweight','bold');
        box on
        Fig_Standard;

    %     h4 = subplot(224);
    %     axis off

        myvideo = VideoWriter(fullfile(saveroute,expname,[expname '_zone' num2str(jj) '.avi']));
        myvideo.FrameRate = samplerate;
        open(myvideo);  

    % ---------------------------------以下，开始循�?---------------------------------



        for jj = 1:floor(length(CS_potential)/temp)

            plot(h1,CS_potential(temp*jj),10^6*CS_current(temp*jj),'.k','markersize',10);
            plot(h2,frame+jj,G_OD_avr(frame+jj),'.k','markersize',10);
            plot(h3,CS_potential(temp*jj),dG_OD_avr(frame+jj),'.k','markersize',10);
    %         axes(h4);
    %         I = double(imread(fullfile(tifpath,tifdir(frame+jj).name))) - tif1;
    %         I = (I - min(Delta_I_avr))/(max(Delta_I_avr) - min(Delta_I_avr));
    %         I = im2uint8(I);
    %         imshow(I);
    %         colormap parula;
    %         colorbar

            temp_frame = getframe(gcf);
            writeVideo(myvideo,temp_frame);

        end

        close(myvideo);
        close
        
    end

end
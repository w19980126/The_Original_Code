function points = w_ReadTifMaskPoint(tifpath,Value,mask)
    
    tic

    tif0 = double(imread(fullfile(tifpath,Value.tifDir(1).name)));
    
    col = sum(mask(:));
    row = length(Value.tifDir);
    loc = find(mask~=0);
    points = zeros(row,col);
    
    for i = 1:length(Value.tifDir)
%         tif = (double(imread(fullfile(tifpath,Value.tifDir(i).name))) - tif0)./tif0.*mask;    
%         �˾䣺��һ�����¾䣬����һ��
        tif = (double(imread(fullfile(tifpath,Value.tifDir(i).name))) - tif0)./tif0.*mask;    
        tmp = tif(loc);
        for j = 1:length(loc)
            points(i,j) = tmp(j);
        end
    end
    
%     tmp_savepath = [saveRoute '\' expName '\_' expName 'IntensityRange.tif'];
%     tmp_fig = imshow(points,[]);
%     xlabel('�����ص�');ylabel('֡��');
%     title('ROI�ڸ����ص��ǿ��ʱ��仯ʾ��ͼ');
%     imwrite(tmp_fig,tmp_savepath);
%     saveas(tmp_fig,tmp_savepath,'fig');
    
    toc
end

    
    
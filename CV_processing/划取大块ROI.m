%% 自动划取大块多区域ROI

TIFF_route = uigetdir();
TIFF_route_dir = dir(TIFF_route);
TIFF_route_dir(1:2) = [];
Mask_route = uigetdir('H','Mask_route,�?\_Mask');

for ii = 1:length(TIFF_route_dir)
    
    tiff_dir = dir(fullfile(TIFF_route,TIFF_route_dir(ii).name,'*.tiff'));
    
    figure
    tiff1 = double(imread(fullfile(tiff_dir(1).folder,tiff_dir(1).name)));
    imagesc(tiff1);
    [xx,yy] = ginput(2);
    close;
    xx = round(xx);
    yy = round(yy);
    
    tiff_cut_mean = zeros(size(tiff_dir));
    for jj = 1:length(tiff_dir)
        tiff_sub = double(imread(fullfile(tiff_dir(jj).folder,tiff_dir(jj).name))) - tiff1;
        tiff_cut = tiff_sub(min(yy):max(yy),min(xx):max(xx));
        tiff_cut_mean(jj) = mean(tiff_cut(:));
    end
   
    [~,loc] = max(abs(tiff_cut_mean));
    tiff_for_mask = double(imread(fullfile(tiff_dir(loc).folder,tiff_dir(loc).name))) - tiff1;
    tiff_for_mask = (tiff_for_mask - min(tiff_cut_mean))/(max(tiff_cut_mean) - min(tiff_cut_mean)); 
    % 以平均�?为基�?��行归�?��，所以不用像素点极�?为基�?��行归�?��者，容易受到噪声的干�?
    bw_for_mask = im2bw(tiff_for_mask);
    H = fspecial('gaussian',5,2);
    mask = imfilter(bw_for_mask,H);
     
    SE = strel('rectangle',[3 3]);
    
    if tiff_cut_mean(loc) > 0
            mask = imdilate(imerode(bw_for_mask,SE),SE);
    else
            mask = imerode(imdilate(bw_for_mask,SE),SE);
    end
    
%     intensity_mean = zeros(size(tiff_dir));
%     for kk = 1:length(tiff_dir)
%         tiff_cut = (double(imread(fullfile(tiff_dir(kk).folder,tiff_dir(kk).name))) - tiff1).*double(mask);
%         intensity_mean(kk) = mean(tiff_cut(:));
%     end
    
    mkdir(fullfile(Mask_route,['set' num2str(ii)]));
    mask_route = fullfile(Mask_route,['set' num2str(ii)],'mask.tiff');
    imwrite(mask,mask_route);

end
 
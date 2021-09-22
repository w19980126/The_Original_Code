%% ROI相关处理

%% 临时代码：ROI相减，大块ROI中扣除ROI，鸡肋的代码，辣鸡

tifroute = 'D:\TiS2\20200825_TiS2\_Mask\A1';
mask1 = imread([tifroute '\A1_Mask_1.tif']);
mask2 = imread([tifroute '\A1_Mask_2.tif']);
mask3 = imread([tifroute '\A1_Mask_3.tif']);

mask1 = logical(mask1);
mask2 = logical(mask2);
mask3 = logical(mask3);

mask3_ = mask3-mask2-mask1;

SE = strel('square',3);
% SE = strel('disk',1);
mask3__ = imdilate((imerode(mask3_,SE)),SE);
figure
imshow(mask3__)
figure
imshow(mask1)

imwrite(mask1,[tifroute '\A1_Mask_1.tif']);
imwrite(mask2,[tifroute '\A1_Mask_2.tif']);
imwrite(mask3__,[tifroute '\A1_Mask_3.tif']);

%% 批量修改mask文件名

% 这段脚本并没有运行成功，辣鸡

MaskTab = cell(4,2);
fields = {'sample_name' ,'mask_route'};
MaskTab = cell2struct(MaskTab,fields,2);
clear fields

tic

for jj = 1:length(MaskTab)
    
    tic
    
    mask_dir = dir([MaskTab(jj).mask_route '\*.tif']);

    parfor ii = 1:length(mask_dir)

        tmp = imread([mask_dir(ii).folder '\' mask_dir(ii).name]);
        imshow(tmp);
%         rmdir([mask_dir(ii).folder '\' MaskTab(jj).sample_name '_ROI_' num2str(ii) '.tif']);
%         rmdir([mask_dir(ii).folder '\' mask_dir(ii).name]);
        saveas(gcf,[mask_dir(ii).folder '\' MaskTab(jj).sample_name '_Mask_' num2str(ii) '.tif']);
        close

    end
    
    toc
    
end

toc
%% 将反常Mask转成正常的Mask

% 即不管在imageJ中invert与否，读入matlab中后样品所在像素都为0而非1，我们需要做的是对原Mask做”非“运算，得到正常的Mask并保存
% 判断原Mask符合条件与否，是通过比较非0的像素点多还是为0的像素点多，一般情况下非0的像素点多与为0的像素点才是正常情况，为了以防万一，
% 同时判断Mask(1,1)是否为0，一般情况下样品都是在视野中央而非角上的，所以若Mask(1,1) = 1，那么就不正常，需要做非运算。

MaskTab = cell(4,2);
fields = {'sample_name' ,'mask_route'};
MaskTab = cell2struct(MaskTab,fields,2);
clear fields

for ii = 1:length(MaskTab)
    
    tic
    
    mask_dir = dir([MaskTab(ii).mask_route '\*.tif']);
    
    for jj = 1:length(mask_dir)
        
        tmp = imread([mask_dir(jj).folder '\' mask_dir(jj).name]);
        tmp = logical(tmp);
        m = tmp(1,1);
        p = sum(tmp(:));    % 多少个像素点为1
        z = size(tmp,1)*size(tmp,2)-p;  %多少个像素点未0
        
         if m > 0 && p < z
            
            tmp = ~tmp;
            imwrite(tmp,[mask_dir(jj).folder '\' mask_dir(jj).name]);
            
        end
        
    end
    
    toc
    
end

%% 对Mask批量进行开运算

for i = 1:3
    
    figure
    
    mask = imread([expTab(i).mask '3.tif']);
    mask = logical(mask);
    if mask(1,1) == 1
        mask = ~mask;
    end
    SE = strel('disk',2);
    mask_1 = imerode(mask,SE);
    mask_2 = imdilate(mask_1,SE);
    savepath = [expTab(i).mask '3.tif'];
    imwrite(mask_2,saveroute)
    
end

%% 图片缩放

% 使用saveas保存mask图片之后，再次读入图片，发现图片格式由logical变为了uint8，且由二维矩阵变成了三维矩阵，矩阵大小也
% 发生了变化，使用此段代码对原错误mask进行缩放，得到正确的mask

for i = 1:3
    
    mask = imread([expTab(i).mask '3.tif']);
    m1 = mask(:,:,1);
    m2 = m1(46:795,136:1135);
    m3 = logical(m2);
    m4 = imresize(m3,0.64,'nearest');
    savepath = [expTab(i).mask '3.tif'];
    imwrite(m4,savepath);
    
end
    
    

    
    
    
    
    
    
    
    
    
    
    
    
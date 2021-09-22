%% ROI��ش���

%% ��ʱ���룺ROI��������ROI�п۳�ROI�����ߵĴ��룬����

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

%% �����޸�mask�ļ���

% ��νű���û�����гɹ�������

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
%% ������Maskת��������Mask

% ��������imageJ��invert��񣬶���matlab�к���Ʒ�������ض�Ϊ0����1��������Ҫ�����Ƕ�ԭMask�����ǡ����㣬�õ�������Mask������
% �ж�ԭMask�������������ͨ���ȽϷ�0�����ص�໹��Ϊ0�����ص�࣬һ������·�0�����ص����Ϊ0�����ص�������������Ϊ���Է���һ��
% ͬʱ�ж�Mask(1,1)�Ƿ�Ϊ0��һ���������Ʒ��������Ұ������ǽ��ϵģ�������Mask(1,1) = 1����ô�Ͳ���������Ҫ�������㡣

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
        p = sum(tmp(:));    % ���ٸ����ص�Ϊ1
        z = size(tmp,1)*size(tmp,2)-p;  %���ٸ����ص�δ0
        
         if m > 0 && p < z
            
            tmp = ~tmp;
            imwrite(tmp,[mask_dir(jj).folder '\' mask_dir(jj).name]);
            
        end
        
    end
    
    toc
    
end

%% ��Mask�������п�����

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

%% ͼƬ����

% ʹ��saveas����maskͼƬ֮���ٴζ���ͼƬ������ͼƬ��ʽ��logical��Ϊ��uint8�����ɶ�ά����������ά���󣬾����СҲ
% �����˱仯��ʹ�ô˶δ����ԭ����mask�������ţ��õ���ȷ��mask

for i = 1:3
    
    mask = imread([expTab(i).mask '3.tif']);
    m1 = mask(:,:,1);
    m2 = m1(46:795,136:1135);
    m3 = logical(m2);
    m4 = imresize(m3,0.64,'nearest');
    savepath = [expTab(i).mask '3.tif'];
    imwrite(m4,savepath);
    
end
    
    

    
    
    
    
    
    
    
    
    
    
    
    
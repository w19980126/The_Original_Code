%% ��bmp��ʽ��ͼ������ת����tiff��ʽ��ͼƬ
tic

tmp = dir(fullfile('D:\TiS2\200806_TiS2\A10_250mM_K2SO4_0-_0-6V_0.1Vms_100fps_BF','*.bmp'));
% �������е�
for i = 1:length(tmp)
    
    path = tmp(i).folder;
    name = tmp(i).name;
    route = fullfile(path,name);
    
    I = imread(route);
    imwrite(I,fullfile('D:\TiS2\200806_TiS2\TIFF\A10_250mM_K2SO4_0-_0-6V_0',[name '.tiff']),'tiff');
    
end

toc



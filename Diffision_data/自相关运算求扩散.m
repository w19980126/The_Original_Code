%% 自相关运算求扩散

tifDir = Value.tifDir;
mask = expTab.mask;
I0 = double(imread(fullfile(tifDir(1).folder,tifDir(1).name)));
A = double(imread(fullfile(tifDir(750).folder,tifDir(750).name)))-I0;
mask = imread(mask);
mask = logical(mask);
A = A.*mask;
crr = auto_corr2(A,A);
[raw0,col0] = ind2sub(size(A),find(crr == max(crr(:))));

parfor ii = 101:(length(tifDir)-1)
    
    B = double(imread(fullfile(tifDir(ii).folder,tifDir(ii).name)))-I0;
    B = B.*mask;
    crr = auto_corr2(A,B);
    [raw(ii),col(ii)] = ind2sub(size(A),find(crr == max(crr(:))));
    
end

Value.raw = raw;
Value.col = col;
Value.raw0 = raw0;
Value.col0 = col0;
saveroute = 'D:\TiS2\20201016_\_Reslut\E_PS\E_PS_zone1_Value.mat';
save(saveroute,'Value','-v7.3');

hist(A)
figure
imshow(A,[])













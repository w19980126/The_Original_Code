function points = ReadTifMaskPoint(tifFile, tifDir, mask)

%对每一张图片与第一张图片进行差减，归一化，并与mask作用得到结果
%每张图片中目标中的值存在points矩阵的每一行中
%每张图片每个目标点处理后的值存入points每一列中
%points包含了第一张背景图片

row = size(tifDir, 1);          %采集的图片张数

[m, ii] = find(mask ~= 0);      %mask中非0值为目标
loc = [m ii];                   %获得所有目标像素点的位置
col = sum(mask(:));             %目标中包含有col个像素点
points = zeros(row, col);       %points矩阵行数等于图片张数，列数等于mask中目标点的个数

tif0 = double(imread(fullfile(tifFile, tifDir(1).name)));   %读入第一张图片

    for ii = 1: row
        tif = (double(imread(fullfile(tifFile, tifDir(ii).name))) - tif0)./tif0.*mask;
        %每张图片与第一张图片进行差减，并以第一张为标准归一化
        %乘以mask，读取目标内数据，其余值视作背景置零
        for jj = 1:1:col
            points(ii, jj) = tif(loc(jj, 1), loc(jj, 2));   %将掩模作用后的tif图片中的每一个像素点对应的值存入points中
        end    
    end
end
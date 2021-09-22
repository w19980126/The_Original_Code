function points = ReadTifMaskPoint(tifFile, tifDir, mask)

%��ÿһ��ͼƬ���һ��ͼƬ���в������һ��������mask���õõ����
%ÿ��ͼƬ��Ŀ���е�ֵ����points�����ÿһ����
%ÿ��ͼƬÿ��Ŀ��㴦����ֵ����pointsÿһ����
%points�����˵�һ�ű���ͼƬ

row = size(tifDir, 1);          %�ɼ���ͼƬ����

[m, ii] = find(mask ~= 0);      %mask�з�0ֵΪĿ��
loc = [m ii];                   %�������Ŀ�����ص��λ��
col = sum(mask(:));             %Ŀ���а�����col�����ص�
points = zeros(row, col);       %points������������ͼƬ��������������mask��Ŀ���ĸ���

tif0 = double(imread(fullfile(tifFile, tifDir(1).name)));   %�����һ��ͼƬ

    for ii = 1: row
        tif = (double(imread(fullfile(tifFile, tifDir(ii).name))) - tif0)./tif0.*mask;
        %ÿ��ͼƬ���һ��ͼƬ���в�������Ե�һ��Ϊ��׼��һ��
        %����mask����ȡĿ�������ݣ�����ֵ������������
        for jj = 1:1:col
            points(ii, jj) = tif(loc(jj, 1), loc(jj, 2));   %����ģ���ú��tifͼƬ�е�ÿһ�����ص��Ӧ��ֵ����points��
        end    
    end
end
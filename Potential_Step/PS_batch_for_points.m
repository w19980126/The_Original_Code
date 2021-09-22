function PS_batch_for_points(expname,tifpath,begin,zone,saveroute,mask_path,I_background)

%% �ж�mask�Ƿ���ROI����Ϊ1����ROI����Ϊ0��������ǣ���mask��������

mask = logical(imread(mask_path));
tmp1 = mask(1,1);   % ���ڳ�ʶ�жϣ���һ�����ز�������ROI����tmp1 = 1����mask����
if tmp1 > 0 
    
    mask = ~mask;
    
end

% roi = mask;
% SE = strel('disk',1);
% roi_edge = edge(roi,'canny');
% roi_edge = imdilate(roi_edge,SE);
% Value.roi = roi;
% Value.roi_edge = roi_edge;
Value.mask = mask;

%% �������ݴ���Value�ṹ����

Value.tifDir = dir(fullfile(tifpath,'*.tiff'));
Value.begin = begin;

%% ���points�����avr

[Transmittance_points,OD_points] = w_ReadTifMaskPoint(tifpath,Value,mask,I_background);
Value.OD_points = OD_points;
Value.Transmittance = Transmittance_points;

T_avr = mean(Transmittance_points,2);
Value.T_avr = T_avr;
Value.OD_avr = mean(OD_points,2);

%% �����µ��ļ���������������

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % ����saveas�������޷���������

%%

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

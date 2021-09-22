function PS_batch_for_points(expname,tifpath,begin,zone,saveroute,mask_path,I_background)

%% 判断mask是否是ROI区域为1，非ROI区域为0，如果不是，对mask做非运算

mask = logical(imread(mask_path));
tmp1 = mask(1,1);   % 基于常识判断，第一个像素不可能是ROI，故tmp1 = 1表明mask不对
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

%% 将各数据存入Value结构体中

Value.tifDir = dir(fullfile(tifpath,'*.tiff'));
Value.begin = begin;

%% 获得points矩阵和avr

[Transmittance_points,OD_points] = w_ReadTifMaskPoint(tifpath,Value,mask,I_background);
Value.OD_points = OD_points;
Value.Transmittance = Transmittance_points;

T_avr = mean(Transmittance_points,2);
Value.T_avr = T_avr;
Value.OD_avr = mean(OD_points,2);

%% 创建新的文件夹用来保存数据

new_folder = [saveroute '\' expname '\zone' num2str(zone)];
mkdir(new_folder);      % 否则saveas函数将无法保存数据

%%

tmp_savepath = [saveroute '\' expname '\' expname '_zone' num2str(zone) '_Value.mat'];
save(tmp_savepath,'Value','-v7.3');

end

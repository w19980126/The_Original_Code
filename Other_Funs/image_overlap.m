function image_overlap(first_tif,maskedge)

% ��������������α��ɫ��ԭʼͼƬ��Ȧ��ROI
% ���豾������ʹ�õ�mask����������mask����ROI��Ȧ�����ص����ض���1

tmp = first_tif.*uint8(~maskedge) +  uint8(maskedge)*175;
imshow(tmp);
title('��Ȧ�еļ�ΪROI','fontsize',15)
colormap parula(256)
colorbar

end



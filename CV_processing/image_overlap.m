function image_overlap(first_tif,maskedge)

% 本函数用来从上伪彩色的原始图片中圈出ROI
% 假设本函数所使用的mask都是正常的mask，即ROI所圈的像素点像素都是1

tmp = first_tif.*uint8(~maskedge) +  uint8(maskedge)*175;
imshow(tmp);
title('所圈中的极为ROI','fontsize',15)
colormap parula(256)
colorbar

end



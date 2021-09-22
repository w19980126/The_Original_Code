function p_fig = pseudo_color(target_fig)

% 本函数是用来将目标图片target_fig上伪彩色的，图片直接从figpath中读入即可

I = double(target_fig);
I = (I-min(I(:)))/(max(I(:))-min(I(:)));
I = im2uint8(I);
I = imadjust(I);
% I = 255-I;
p_fig = I;
imshow(I)
colormap parula(256);
colorbar

end 



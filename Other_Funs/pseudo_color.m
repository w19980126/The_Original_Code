function p_fig = pseudo_color(target_fig)

% ��������������Ŀ��ͼƬtarget_fig��α��ɫ�ģ�ͼƬֱ�Ӵ�figpath�ж��뼴��

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



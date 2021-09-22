%%

I0 = imread('F:\TiS2\20201016_\TIFF\E_PS\EP_00000.raw.tiff');
I1 = imread('F:\TiS2\20201016_\TIFF\E_PS\EP_00100.raw.tiff')-I0;
I2 = imread('F:\TiS2\20201016_\TIFF\E_PS\EP_00740.raw.tiff')-I0;
I1 = double(I1);
I2 = double(I2);
mask = imread('F:\TiS2\20201016_\_Mask\E_PS\E_PS_Mask.tif');
mask = logical(mask);
I1 = I1.*mask;
I2 = I2.*mask;

figure
subplot(121)
imshow(I1,[])
subplot(122)
imshow(I2,[]);

C11 = fftshift(auto_corr2(I1,I1));
C12 = fftshift(auto_corr2(I1,I2));
figure
subplot(121)
imshow(C11,[]);
subplot(122)
imshow(C12,[]);

[r1,l1] = ind2sub(size(C11),find(C11 == max(C11(:))));
[r2,l2] = ind2sub(size(C12),find(C12 == max(C12(:))));

[r1,l1] = ind2sub(size(AB),find(AB == max(AB(:))));
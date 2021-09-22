%% 浣跨敤matlab瀹炵幇imageJ甯哥敤鐨勫垎鏋愭暟鎹殑鍔熻兘

tiffpath = uigetdir(选取tiff图片所在文件夹);

tiffpath = uigetdir('H:\TiS2\Deionization\20201228_shangwu\TIFF\A1_MgCs_125mM_0_-0_6V_20mVs_1cycles_BF');

tifdir = dir(fullfile(tiffpath,'*.tiff'));
imagesc(imread(fullfile(tiffpath,tifdir(1).name)));
[x,y] = ginput(2);
x = round(x);
y = round(y);

h_waitbar = waitbar(0,num2str(0));
for ii = 1:length(tifdir)
   
    tif = double(imread(fullfile(tiffpath,tifdir(ii).name)));
    cut_tif = tif(min(y):max(y),min(x):max(x));
    mean_roi(ii) = mean(cut_tif(:));
    waitbar(ii/length(tifdir),h_waitbar,num2str(ii/length(tifdir)));
    
end

delete(h_waitbar)

figure
subplot(211)
plot(mean_roi,'k','linewidth',2);
set(gca,'xlim',[1 length(tifdir)]);
grid on
subplot(212)
plot(diff(smooth(mean_roi,10)),'k','linewidth',2);
set(gca,'xlim',[1 length(tifdir)]);
grid on



























%% 本脚本用来生成一个伪彩色视频

tic

tifpath = 'H:\TiS2\20200924\TIFF\D1_250mM_K2SO4_0_-0_6V_150mVs_100fps_BF\';
tifobj = dir([tifpath '*.tiff']);
f_length = length(tifobj);

I0 = imread(fullfile(tifpath,tifobj(1).name));
pseudo_color(I0);

[n,m] = ginput(2);
n = round(n);
m = round(m);

myvideo = VideoWriter('20200924_TiS2_D1_CV.avi','Indexed AVI');
myvideo.Colormap = parula;
myvideo.FrameRate = 3;
open(myvideo);

hwaitbar = waitbar(0,'尚未开始');
tmp1 = imread([tifpath tifobj(1).name]);

for i = 1:(length(tifobj)-1)

    tmp2 = imread([tifpath tifobj(i+1).name]);
    tmp3 = double(tmp2)-double(tmp1);
    tmp4 = tmp3(m(1):m(2),n(1):n(2));
    tmp5 = (tmp4-min(tmp4(:)))/(max(tmp4(:))-min(tmp4(:)));
    tmp6 = im2uint8(tmp5);
    tmp7 = imadjust(tmp6);
    
    writeVideo(myvideo,tmp7);
    
    clear tmp2 tmp3 tmp4 tmp5 tmp6 tmp7
    
    waitbar(i/f_length,hwaitbar,['已完成' num2str(i/f_length)]);
    
end

close(myvideo)
delete(hwaitbar)

toc































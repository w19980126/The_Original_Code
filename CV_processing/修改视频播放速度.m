%%

videoroute = 'H:\TiS2\Deionization\20201228_shangwu\Result';
for ii = 1:6
    
    videofile = fullfile(videoroute,['set' num2str(ii)],['set' num2str(ii) '.avi']);
    myvideo = VideoReader(videofile);
    temp = read(myvideo);
    
    newpath = fullfile(videoroute,['set' num2str(ii)],['Set_' num2str(ii) '.avi']);
    newvideo = VideoWriter(newpath);
    newvideo.FrameRate = 200;
    open(newvideo);
    
    writeVideo(newvideo,temp)
    close(newvideo)
    
end










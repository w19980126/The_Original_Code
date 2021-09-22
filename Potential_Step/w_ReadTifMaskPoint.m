function [Tansmittance_points,OD_points] = w_ReadTifMaskPoint(tifpath,Value,mask,I_background)
 
    tif0 = double(imread(fullfile(tifpath,Value.tifDir(1).name)));
    
    I0 = I_background;
    col = sum(mask(:));
    row = length(Value.tifDir);
    loc = find(mask~=0);
    Tansmittance_points = zeros(row,col);
    OD_points = zeros(row,col);
    
    for i = 1:length(Value.tifDir)
  
        Delta_Transmittance = (double(imread(fullfile(tifpath,Value.tifDir(i).name)))-tif0)/I0.*mask;
        Delta_OD = log(double(imread(fullfile(tifpath,Value.tifDir(i).name)))./tif0.*mask);
        tmp1 = Delta_Transmittance(loc);
        tmp2 = Delta_OD(loc);
        for j = 1:length(loc)
            Tansmittance_points(i,j) = tmp1(j);
            OD_points(i,j) = tmp2(j);
        end
    end

end

    
    
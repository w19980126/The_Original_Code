function y_filted = Gaussianfilter(r, sigma, y)

%% 左右补齐

    % 判断y是行矩阵还是列矩阵

    [m,~] = size(y);
    if m ~= 1
        y = y';
    end
    
    close all
    % 生成一维高斯滤波模板
    GaussTemp = ones(1,r*2-1);
    for i=1 : r*2-1
        GaussTemp(i) = exp(-(i-r)^2/(2*sigma^2))/(sigma*sqrt(2*pi));
    end

    temp_add = length(GaussTemp)-1;
    new_y = ones(1,length(y)+length(GaussTemp)-1);
    half_temp = round(0.5*temp_add);
    new_y(1:half_temp) = flip(y(1:half_temp));
    new_y(half_temp+1:half_temp+length(y)) = y;
    new_y(half_temp+1+length(y):end) = flip(y(end+1-temp_add+half_temp:end));

    y_filted = y;
    for ii = 1:length(y_filted)
        y_filted(ii) = sum(new_y(ii:ii+length(GaussTemp)-1).*GaussTemp)/sum(GaussTemp);
    end

    if m~= 1
        y_filted = y_filted';
    end
    
end


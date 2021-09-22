%% 不同厚度TiS2反射

% 光线从下到上通过的依次是 SiO2|ITO|TiS2|H2O
% SiO2和水分别看成是半无限厚层
% SiO2的折射率是1.45
% ITO的折射率是2 + i*0.0043(670nm)
% TiS2的折射率选择的是2 + i*0.0003
% 水的折射率是1.33

d2 = 350/10^9;      % ITO厚度
n1 = 1.45;      % SiO2折射率
n2 = 2 + i*0.0043;  % ITO折射率
n3 = 2.6 + i*3.5;     % TiS2折射率
n4 = 1;  % 水的折射率
lambda = 670/10^9;  % 波长
d3 = (0.1:0.1:200)/10^9;    % TiS2厚度

delta2 = 2*pi*d2*n2/lambda;     % ITO层中相位延迟
delta3 = 2*pi*d3*n3/lambda;     % TiS2层中相位延迟
M2 = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)];     % ITO层的特征矩阵
Y_TiS2 = zeros(1,length(d3));       % 为ITO|TiS2|水层等效导纳预设空间
r_TiS2 = zeros(1,length(d3));       % 为ITO|TiS2|水层反射率预设空间

M3 = zeros(2,length(d3));
for ii = 1:length(d3)
    
    M3(:,ii) = M2*[cos(delta3(ii)) -i*sin(delta3(ii))/n3;...
        -i*sin(delta3(ii))*n3 cos(delta3(ii))]*[1;n4];  % TiS2层传输矩阵乘以水层相关矩阵
    Y_TiS2(ii) = M3(2,ii)/M3(1,ii);   % ITO|TiS2|水层等效导纳
    r_TiS2(ii) = (n1 - Y_TiS2(ii))/(n1 + Y_TiS2(ii));   % ITO|TiS2|水层反射率
    
end

M_ITO = M2*[1;n4];      % ITO特征矩阵乘以水层相关矩阵
Y_ITO = M_ITO(2)/M_ITO(1);  % ITO|水层等效导纳

r_ITO = (n1 - Y_ITO)/(n1 + Y_ITO);      % SiO2|ITO|水层反射率
temp = (abs(r_TiS2)/abs(r_ITO)).^2;    
plot(d3,temp);

xticks(0:40/10^9:200/10^9)
xticklabels({'0','40','80','120','160','200'})
xlabel('Thickness of TiS_2 (nm)');
ylabel('Relative Intensity (a.u.)');
set(gca,'linewidth',2)
hl = findobj(gca,'type','line');
set(hl,'linewidth',2);
set(gca,'fontsize',20,'fontweight','bold');
title('The variation trend of reflected light intensity with thickness of TiS_2','fontweight','bold')
axis square
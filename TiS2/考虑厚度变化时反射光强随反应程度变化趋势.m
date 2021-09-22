%% 不同厚度TiS2反射

% 光线从下到上通过的依次是 SiO2|ITO|TiS2|H2O
% SiO2和水分别看成是半无限厚层
% SiO2的折射率是1.45
% ITO的折射率是2 + i*0.0043(670nm)
% TiS2的折射率选择的是2 + i*0.0003
% 水的折射率是1.33

n1 = 1.45;      % SiO2折射率
n2 = 2 + i*0.0043;  % ITO折射率
n4 = 1.33;  % 水的折射率

d2 = 350/10^9;      % ITO厚度
x = 0:0.01:1;
d3 = 199*(1 + 1*x)/10^9;    % TiS2厚度
n3 = (2.6 - 0.3*x) + i*(3.5 - 2*x);     % TiS2折射率

lambda = 670/10^9;  % 波长

delta2 = 2*pi*d2*n2/lambda;     % ITO层中相位延迟
delta3 = 2*pi*d3.*n3/lambda;     % TiS2层中相位延迟

M_ITO = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)]*[1;n4]; 
Y_ITO = M_ITO(2)/M_ITO(1);
r_ITO = (n1 - Y_ITO)/(n1 + Y_ITO);

Y_TiS2 = zeros(2,length(x));
r_TiS2 = zeros(1,length(x));

for ii = 1:length(x)
    
    M = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)]*...
    [cos(delta3(ii)) -i*sin(delta3(ii))/n3(ii);...
    -i*sin(delta3(ii))*n3(ii) cos(delta3(ii))]*[1;n4];
    
    Y_TiS2(ii) = M(2)/M(1);
    r_TiS2(ii) = (n1 - Y_TiS2(ii))/(n1 + Y_TiS2(ii)); 
    
end

plot(x,(abs(r_TiS2)/abs(r_ITO)).^2);








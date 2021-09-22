%% ��ͬ���TiS2����

% ���ߴ��µ���ͨ���������� SiO2|ITO|TiS2|H2O
% SiO2��ˮ�ֱ𿴳��ǰ����޺��
% SiO2����������1.45
% ITO����������2 + i*0.0043(670nm)
% TiS2��������ѡ�����2 + i*0.0003
% ˮ����������1.33

n1 = 1.45;      % SiO2������
n2 = 2 + i*0.0043;  % ITO������
n4 = 1.33;  % ˮ��������

d2 = 350/10^9;      % ITO���
x = 0:0.01:1;
d3 = 199*(1 + 1*x)/10^9;    % TiS2���
n3 = (2.6 - 0.3*x) + i*(3.5 - 2*x);     % TiS2������

lambda = 670/10^9;  % ����

delta2 = 2*pi*d2*n2/lambda;     % ITO������λ�ӳ�
delta3 = 2*pi*d3.*n3/lambda;     % TiS2������λ�ӳ�

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








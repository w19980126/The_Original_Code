%% ��ͬ���TiS2����

% ���ߴ��µ���ͨ���������� SiO2|ITO|TiS2|H2O
% SiO2��ˮ�ֱ𿴳��ǰ����޺��
% SiO2����������1.45
% ITO����������2 + i*0.0043(670nm)
% TiS2��������ѡ�����2 + i*0.0003
% ˮ����������1.33

d2 = 350/10^9;      % ITO���
n1 = 1.45;      % SiO2������
n2 = 2 + i*0.0043;  % ITO������
n3 = 2.6 + i*3.5;     % TiS2������
n4 = 1;  % ˮ��������
lambda = 670/10^9;  % ����
d3 = (0.1:0.1:200)/10^9;    % TiS2���

delta2 = 2*pi*d2*n2/lambda;     % ITO������λ�ӳ�
delta3 = 2*pi*d3*n3/lambda;     % TiS2������λ�ӳ�
M2 = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)];     % ITO�����������
Y_TiS2 = zeros(1,length(d3));       % ΪITO|TiS2|ˮ���Ч����Ԥ��ռ�
r_TiS2 = zeros(1,length(d3));       % ΪITO|TiS2|ˮ�㷴����Ԥ��ռ�

M3 = zeros(2,length(d3));
for ii = 1:length(d3)
    
    M3(:,ii) = M2*[cos(delta3(ii)) -i*sin(delta3(ii))/n3;...
        -i*sin(delta3(ii))*n3 cos(delta3(ii))]*[1;n4];  % TiS2�㴫��������ˮ����ؾ���
    Y_TiS2(ii) = M3(2,ii)/M3(1,ii);   % ITO|TiS2|ˮ���Ч����
    r_TiS2(ii) = (n1 - Y_TiS2(ii))/(n1 + Y_TiS2(ii));   % ITO|TiS2|ˮ�㷴����
    
end

M_ITO = M2*[1;n4];      % ITO�����������ˮ����ؾ���
Y_ITO = M_ITO(2)/M_ITO(1);  % ITO|ˮ���Ч����

r_ITO = (n1 - Y_ITO)/(n1 + Y_ITO);      % SiO2|ITO|ˮ�㷴����
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
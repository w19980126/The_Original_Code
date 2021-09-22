%% ��ɢģ��

% --------------------���£����ɳ�ʼ��������Ʒ��Ũ��Ϊ0���߽�������Ũ�Ⱥ�Ϊ0--------------------

U0 = ones(50,50);   	
U0(10:40,10:25) = 0;
U0(10:25,26:40) = 0;
ind = find(U0 == 1);

% --------------------���£�����x/y/t�Ĳ����Լ��о�����ʱ�䷶Χ--------------------

dx = 1;
dy = 1;
a = 10;
x = 1:dx:50;
y = 1:dy:50;
[X,Y] = meshgrid(x,y);
dt = 0.001;
t = 0:dt:1;

% --------------------���£�����Ax��Ay����--------------------

Ax = -2*eye(length(x)) + diag(ones(1,length(x)-1),1) + diag(ones(1,length(x)-1),-1);
Ay = -2*eye(length(y)) + diag(ones(1,length(y)-1),1) + diag(ones(1,length(y)-1),-1);

% --------------------���£���ʼѭ������--------------------

U = U0;     % ��ʼ����
for ii = 1:length(t)
    
    U = U + a^2*(U*Ax/dx^2 + Ay*U/dy^2)*dt;     % ��(ii-1)ʱ�̵�Ũ�ȷֲ�����iiʱ�̵�Ũ�ȷֲ�
    U(ind) = 1;
   surf(X,Y,U);     
   axis([x(1) x(end) y(1) y(end) 0 1]);
   getframe;
   
end

%% ��ɢ����

% --------------------���£�����Mask��ѡ���ʵ�������Ϊ�о������о������ΪTemplate--------------------

maskroute = 'G:\TiS2\experiment\20210105\_Mask\set4\mask.tiff';
Mask = imread(maskroute);

if Mask(1) == 1;
    Mask = ~Mask;   % ��֤Mask����Ʒ����������Ϊ1����������Ϊ0
end

imshow(Mask);
[yy,xx] = ginput(2);    % ��ȡ����ȷ����Ʒ���ھ���������Ϊ�о����򣬲���ΪTemplate
close
xx = round(xx);
yy = round(yy);
Template = Mask(min(xx):max(xx),min(yy):max(yy));

% --------------------���£����Ҷ������ݵĲ��֣��Ұ�֮ǰ�õ������ݷ����㣬��Ͳ�������һ����--------------------

TiffRoute = 'G:\TiS2\experiment\20210105\TIFF\A4_K_250mM_0_-0_6V_break_5s_10ms_100fps_BF';
Tiffs = dir(fullfile(TiffRoute,'*.tiff'));
Tiff1 = double(imread(fullfile(TiffRoute,Tiffs(1).name)));

OD_temp = zeros(size(Tiff1,1),size(Tiff1,2),length(Tiffs));
T_temp = OD_temp;
parfor ii = 1:length(Tiffs)
    temp1 = double(imread(fullfile(TiffRoute,Tiffs(ii).name)));
    OD_temp(:,:,ii) = log(temp1./Tiff1).*Mask;
    OD(ii) = mean(mean(OD_temp(:,:,ii)));
    T_temp(:,:,ii) = (temp1 - Tiff1)/12000.*Mask;
    T(ii) = mean(mean(T_temp(:,:,ii)));
end

clear xx yy Tiffs TiffRoute Tiff1 temp1 T_temp OD_temp maskroute Mask 

%% ���㺬�вα���D��u-t��ϵ������u��Ũ�ȷֲ��Ļ��֣���һ����������

% --------------------���£�����x��y��t�Ĳ���������Ax��Ay�������沽��һ��--------------------

U0 = Template;      % ��ʼ��������Template��Template��������һ����ֵ���ľ�����Ʒ����ֵΪ1������Ϊ0
loc = find(U0 == 0);    % �ҵ�����Ʒ�������ں���������Ʒ��ʱʱ�̿���Ϊ0�����߽�����
U = U0;

dx = 1;
dy = 1;
syms D;
x = 1:dx:size(U0,2);
y = 1:dy:size(U0,1);
[X,Y] = meshgrid(x,y);
dt = 0.00002;   % ��Ϊ��֪��D���׶��������ú�С��ֹ��������ɢ
t = 0:dt:1;
syms D;
% D = 12000;

Ax = -2*eye(length(x)) + diag(ones(1,length(x)-1),1) +diag(ones(1,length(x)-1),-1); 
Ay = -2*eye(length(y)) + diag(ones(1,length(y)-1),1) +diag(ones(1,length(y)-1),-1); 

% --------------------���£���ʼѭ������--------------------

hwait = waitbar(0);
u0 = sum(U0);   % ��ʼ�����Ӻͣ��������Ĺ�һ��
u = sym('D',[1 length(t)]);     % ������һ���������������洢֮��ÿһ��ʱ�̼��������Ũ�ȷֲ��������ֵ
for ii = 1:length(t)
    
    u(ii) = sum(U(:))/u0;  % Ũ�ȷֲ�������֣���Ϊ����Ʒ����Ϊ0������ֱ��ȡ�ļӺ�
    U = U + D*(U*Ax/dx^2 + Ay*U/dy^2)*dt;
    U(loc) = 0;     % �߽�������Ϊ0
    waitbar(ii/length(t),hwait,num2str(ii/50));
    
end
u(ii+1) = sum(U(:));    
delete(hwait);
u = expand(u);  % ��u�еĶ���ʽչ��������˳��Щ

%% �������Dֵ

% �����ǣ�
% ÿ��ʱ�̶���һ�� u(ii) = ExpRes(ii)
% ����u�Ǻ��вα���D�ķ���������ExpRes�ǹ�һ�����ʵ������
% ���Ƕ���һ���º����� 
% TesFun = ��(u(ii) - ExpRes(ii))^2
% �����ϵ�TestFun��Сʱ��Ӧ��D�������Ǵ����D

ExpRes = 1 - (ExpRes - min(ExpRes))/(max(ExpRes) - min(ExpRes));

TestFun = 0;
for ii = 1:length(ExpRes)
    TestFun = TestFun + (u(ii) - ExpRes(ii))^2; % ���峢�Ժ���TestFun
end

TestFun = @(D) eval(char(TestFun));     % ������ʽתΪ�����������Ա���ΪD
k = 0;
for ii = 0:0.001:0.05
    
    k = k+1;
    err(k) = TestFun(ii*10^4);
    
    if err < 0.1   % ��������ǲ��е��ˣ��о������㵽�����ôС����ȫ������
        DiffCoe = ii*10^4;
        break
    end
    
end

plot(err)   % ������볢�Ե�D֮�������

%% ��Ԫ���λع飬�������Ҳ���в�����������

Y = OD(909:1008);
X = 0:0.01:0.99;
myfun = @(a,t,x,y) a(1)...
                 + a(2)*x + a(3)*x^2 ...
                 + a(4)*y + a(4)*y^2 ...
                 + a(5)*x*y + a(6)*t;
a = nlinfit(X,Y,myfun,[1 1 1 1 1 1]);
Y = OD_temp(:,:,909:1008);
for ii = 1:size(Y,1)
    for jj = 1:size(Y,2)
        Y(ii,jj,:) = 1-(Y(ii,jj,:) - min(Y(ii,jj,:))) ...
                     /(max(Y(ii,jj,:)) - min(Y(ii,jj,:)));
    end
end
for ii = 1:size(Y,3)
    imagesc(Y(:,:,ii));
    getframe;
end
x1 = zeros(1,480*640*100);
x2 = x1;
x3 = x1;
y = x1;
ll = 0;
for ii = 1:size(Y,1)
    for jj = 1:size(Y,2)
        for kk = 1:size(Y,3)
            ll = ll+1;
            x1(ll) = ii;
            x2(ll) = jj;
            x3(ll) = kk;
            y(ll) = Y(ii,jj,kk);
        end
    end
end
X = [ones(size(y)) ; x1.^2 ; x2.^2 ; x1.*x2 ; x1 ; x2 ; x3];
regress(y',X')

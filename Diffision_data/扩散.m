%% 扩散模拟

% --------------------以下，生成初始条件，样品区浓度为0，边界条件是浓度恒为0--------------------

U0 = ones(50,50);   	
U0(10:40,10:25) = 0;
U0(10:25,26:40) = 0;
ind = find(U0 == 1);

% --------------------以下，设置x/y/t的步长以及研究区域、时间范围--------------------

dx = 1;
dy = 1;
a = 10;
x = 1:dx:50;
y = 1:dy:50;
[X,Y] = meshgrid(x,y);
dt = 0.001;
t = 0:dt:1;

% --------------------以下，生成Ax、Ay矩阵--------------------

Ax = -2*eye(length(x)) + diag(ones(1,length(x)-1),1) + diag(ones(1,length(x)-1),-1);
Ay = -2*eye(length(y)) + diag(ones(1,length(y)-1),1) + diag(ones(1,length(y)-1),-1);

% --------------------以下，开始循环计算--------------------

U = U0;     % 初始条件
for ii = 1:length(t)
    
    U = U + a^2*(U*Ax/dx^2 + Ay*U/dy^2)*dt;     % 从(ii-1)时刻的浓度分布计算ii时刻的浓度分布
    U(ind) = 1;
   surf(X,Y,U);     
   axis([x(1) x(end) y(1) y(end) 0 1]);
   getframe;
   
end

%% 扩散数据

% --------------------以下，读入Mask并选择适当区域作为研究区域，研究区域记为Template--------------------

maskroute = 'G:\TiS2\experiment\20210105\_Mask\set4\mask.tiff';
Mask = imread(maskroute);

if Mask(1) == 1;
    Mask = ~Mask;   % 保证Mask中样品所在区域置为1，其余区域为0
end

imshow(Mask);
[yy,xx] = ginput(2);    % 点取两点确定样品所在矩形区域作为研究区域，并存为Template
close
xx = round(xx);
yy = round(yy);
Template = Mask(min(xx):max(xx),min(yy):max(yy));

% --------------------以下，是我读入数据的部分，我把之前得到的数据发给你，你就不用做这一步了--------------------

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

%% 计算含有参变量D的u-t关系，其中u是浓度分布的积分，是一个符号向量

% --------------------以下，设置x、y和t的步长、设置Ax和Ay，与上面步骤一样--------------------

U0 = Template;      % 初始条件等于Template，Template本质上是一个二值化的矩阵，样品区域值为1，其余为0
loc = find(U0 == 0);    % 找到非样品区，便于后续将非样品区时时刻刻置为0，即边界条件
U = U0;

dx = 1;
dy = 1;
syms D;
x = 1:dx:size(U0,2);
y = 1:dy:size(U0,1);
[X,Y] = meshgrid(x,y);
dt = 0.00002;   % 因为不知道D到底多大，所以设得很小防止计算结果发散
t = 0:dt:1;
syms D;
% D = 12000;

Ax = -2*eye(length(x)) + diag(ones(1,length(x)-1),1) +diag(ones(1,length(x)-1),-1); 
Ay = -2*eye(length(y)) + diag(ones(1,length(y)-1),1) +diag(ones(1,length(y)-1),-1); 

% --------------------以下，开始循环计算--------------------

hwait = waitbar(0);
u0 = sum(U0);   % 初始条件加和，方便后面的归一化
u = sym('D',[1 length(t)]);     % 与生成一个符号向量用来存储之后每一个时刻计算出来的浓度分布的面积分值
for ii = 1:length(t)
    
    u(ii) = sum(U(:))/u0;  % 浓度分布的面积分，因为非样品区域都为0，所以直接取的加和
    U = U + D*(U*Ax/dx^2 + Ay*U/dy^2)*dt;
    U(loc) = 0;     % 边界条件置为0
    waitbar(ii/length(t),hwait,num2str(ii/50));
    
end
u(ii+1) = sum(U(:));    
delete(hwait);
u = expand(u);  % 将u中的多项式展开，看着顺眼些

%% 尝试拟合D值

% 方法是：
% 每个时刻都有一个 u(ii) = ExpRes(ii)
% 其中u是含有参变量D的符号向量，ExpRes是归一化后的实验数据
% 我们定义一个新函数： 
% TesFun = ∑(u(ii) - ExpRes(ii))^2
% 理论上当TestFun最小时对应的D就是我们待求的D

ExpRes = 1 - (ExpRes - min(ExpRes))/(max(ExpRes) - min(ExpRes));

TestFun = 0;
for ii = 1:length(ExpRes)
    TestFun = TestFun + (u(ii) - ExpRes(ii))^2; % 定义尝试函数TestFun
end

TestFun = @(D) eval(char(TestFun));     % 将多项式转为匿名函数，自变量为D
k = 0;
for ii = 0:0.001:0.05
    
    k = k+1;
    err(k) = TestFun(ii*10^4);
    
    if err < 0.1   % 这个估计是不行的了，感觉很难算到误差这么小，完全碰运气
        DiffCoe = ii*10^4;
        break
    end
    
end

plot(err)   % 看误差与尝试的D之间的走势

%% 二元二次回归，这个估计也运行不出来，算了

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

%%
close 
clc
clear

H = zeros(100:100);
for ii = 1:80
    H(ii,:) = 800 - 5*ii;
end
H = H/10^9;

x = 0:0.05:1;
n1 = 1.45;   
n2 = 2 + i*0.0043;  
n3 = (2.6 - 0.3*x) + i*(3.5 - 2*x);  
n4 = 1.33; 

d2 = 350/10^9;     

lambda = 670/10^9;  
delta2 = 2*pi*d2*n2/lambda;    

M2 = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)];

Y = zeros(100,100,length(x));
r = zeros(100,100,length(x));
R = r;

for ii = 1:length(x)
    
    d3 = H*(1 + x(ii));
    delta3 = 2*pi*n3(ii)*d3/lambda;
    A = cos(delta3);
    B = -i*sin(delta3)/n3(ii);
    C = -i*sin(delta3)*n3(ii);
    D = A;
    Y(:,:,ii) = ((A + n4*B)*M2(3) + (C + n4*D)*M2(4))./((A + n4*B)*M2(1) + (C + n4*D)*M2(2));
    r(:,:,ii) = (n1 - Y(:,:,ii))./(n1 + Y(:,:,ii));
    R(:,:,ii) = (abs(r(:,:,ii))).^2;
    mesh(R(:,:,ii));
    zlim([0 1])
    m(ii) = getframe;
    
end

movie(m)
%%


H = zeros(100:100);
for ii = 1:80
    H(ii,:) = 350 - 2*ii;
end
H = H/10^9;

x = 0:0.05:1;
n1 = 1.45;   
n2 = 2 + i*0.0043;  
n3 = (2.6 - 0.3*x) + i*(3.5 - 2*x);  
n4 = 1.33; 

d2 = 350/10^9;     

lambda = 670/10^9;  
delta2 = 2*pi*d2*n2/lambda;    

M2 = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)];

Y = zeros(100,100,length(x));
r = zeros(100,100,length(x));
R = r;

for ii = 1
    
%     figure
    
    d3 = H*(1 + x(ii));
    delta3 = 2*pi*n3(ii)*d3/lambda;
    
    for jj = 1:size(H,1)
        for kk = 1:size(H,1)
            M3 = [cos(delta3(jj,kk)) -i*sin(delta3(jj,kk))/n3(ii);... 
             -i*sin(delta3(jj,kk))*n3(ii) cos(delta3(jj,kk))];
            M = M2*M3*[1;n4];
            Y(jj,kk,ii) = M(2)/M(1);
            r(jj,kk,ii) = (n1 - Y(jj,kk,ii))./(n1 + Y(jj,kk,ii));
        end
    end
    
    R(:,:,ii) = (abs(r(:,:,ii))).^2;
%     mesh(R(:,:,ii))
    
end



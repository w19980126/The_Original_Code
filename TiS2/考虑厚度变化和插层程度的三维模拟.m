%% 二维情况 

S = zeros(199,199);
h = 200;
R = S;
d = R;
for ii = 1:size(S,1)
    for jj = 1:size(S,2)
        R(ii,jj) = sqrt((ii - 100)^2 + (jj - 100)^2);
        d(ii,jj) = h - R(ii,jj)*h/sqrt((50 - 100)^2 + (50 - 100)^2);
    end
end
loc = find(d<0);
d(loc) = 0;

n1 = 1.45;      % SiO2折射率
n2 = 2 + i*0.0043;  % ITO折射率
n4 = 1.33;  % 水的折射率
d2 = 70/10^9;      % ITO厚度
lambda = 670/10^9;  % 波长
x = 0:0.01:1;
delta2 = 2*pi*d2*n2/lambda;     % ITO层中相位延迟

M2 = [cos(delta2) -i*sin(delta2)/n2;... 
    -i*sin(delta2)*n2 cos(delta2)];
M0 = M2*[1;n4];
Y0 = M0(2)/M0(1);
R0 = (abs((n1 - Y0)/(n1 + Y0)))^2;

Y = zeros(size(S,1),size(S,2),length(x));
r = zeros(size(S,1),size(S,2),length(x));
R = zeros(size(S,1),size(S,2),length(x));
for ii = 1:length(x)
    
    n3(ii) = (2.6 - 0.3*x(ii)) + i*(3.5 - 2*x(ii));
    D = d*(1 + x(ii))/10^9;
    delta3 = 2*pi*D*n3(ii)/lambda; 
    
    for jj = 1:size(S,1)
        for kk = 1:size(S,2)
            M3 = [cos(delta3(jj,kk)) -i*sin(delta3(jj,kk))/n3(ii);...
                 -i*sin(delta3(jj,kk))*n3(ii) cos(delta3(jj,kk))];
            M = M2*M3*[1;n4];
            Y(jj,kk,ii) = M(2)/M(1);
            r(jj,kk,ii) = (n1 - Y(jj,kk,ii))/(n1 + Y(jj,kk,ii));
            R(jj,kk,ii) = (abs(r(jj,kk,ii)))^2;
        end
    end
    
end


for ii = 1:length(x)
    
    subplot(121)
    
    imagesc(R(:,:,ii)/R0);
    colormap parula
    caxis([0 2.3]);
    set(gca,'xtick',[],'ytick',[],'xticklabel',[])
    axis off
    axis square
    title(['x = ' num2str(x(ii))],'fontsize',20,'fontweight','bold'); 
    
    subplot(122)
    mesh(R(:,:,ii)/R0);
    colormap parula
    caxis([0 2.3]);
    axis off
    axis square
    zlim([0 2.3])
    colorbar('fontsize',15,'fontweight','bold');
    
    set(gcf,'units','normalized','position',[0.2 0.2 0.5 0.5])
    set(0,'defaultfigurecolor','w') 
    drawnow
    
    F = getframe(gcf);
    I = frame2im(F);
    [I,map]=rgb2ind(I,256);

    if ii == 1
        imwrite(I,map,'Reflectivity varies with x.gif','gif','Loopcount',inf,'DelayTime',0.1);
    else
        imwrite(I,map,'Reflectivity varies with x.gif','gif','WriteMode','append','DelayTime',0.1);
    end

end


    
    
            
            
        
    
    
    
    


function y = lowp(x, f1, f3, rp, rs, Fs)

% 一阶切比雪夫低通滤波器

fn = Fs/2;      %奈奎斯特频率
wp = f1/fn;     %通带截止频率
ws = f3/fn;     %阻带截止频率
[n,wn] = cheb1ord(wp,ws,rp,rs,'s');   %得到切比雪夫滤波器阶数n和边界频率Wn
[b,a] = cheby1(n,rp,wn);                %得到有利传递函数分子b和分母a
y = filter(b,a,x); %对原始数据进行滤波

end

% wp = 2*pi*f1/Fs;
% ws = 2*pi*f3/Fs;

% [n, ~] = cheb1ord(wp/pi, ws/pi, rp, rs);
% [bz1, az1] = cheby1(n, rp, wp/pi);

% [h, w] = freqz(bz1, az1, 256, Fs);
% h = 20*log10(abs(h));
% figure;
% plot(w, h);
% title('Passband curve');
% grid on;

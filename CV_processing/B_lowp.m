function y = B_lowp(x, f1, f3, rp, rs, Fs)

% 巴特沃斯低通滤波器

fn = Fs/2;      %奈奎斯特频率
wp = f1/fn;     %通带截止频率
ws = f3/fn;     %阻带截止频率
[n,wn] = buttord(wp,ws,rp,rs,'s');   %得到切比雪夫滤波器阶数n和边界频率Wn
[b,a] = butter(n,wn);                %得到有利传递函数分子b和分母a
y = filter(b,a,x); %对原始数据进行滤波

end


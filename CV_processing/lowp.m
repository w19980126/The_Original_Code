function y = lowp(x, f1, f3, rp, rs, Fs)

% һ���б�ѩ���ͨ�˲���

fn = Fs/2;      %�ο�˹��Ƶ��
wp = f1/fn;     %ͨ����ֹƵ��
ws = f3/fn;     %�����ֹƵ��
[n,wn] = cheb1ord(wp,ws,rp,rs,'s');   %�õ��б�ѩ���˲�������n�ͱ߽�Ƶ��Wn
[b,a] = cheby1(n,rp,wn);                %�õ��������ݺ�������b�ͷ�ĸa
y = filter(b,a,x); %��ԭʼ���ݽ����˲�

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

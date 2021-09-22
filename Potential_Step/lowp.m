function y = lowp(x, f1, f3, rp, rs, Fs)

% Ò»½×ÇÐ±ÈÑ©·òµÍÍ¨ÂË²¨Æ÷

wp = 2*pi*f1/Fs;
ws = 2*pi*f3/Fs;
[n, ~] = cheb1ord(wp/pi, ws/pi, rp, rs);
[bz1, az1] = cheby1(n, rp, wp/pi);
% [h, w] = freqz(bz1, az1, 256, Fs);
% h = 20*log10(abs(h));
% figure;
% plot(w, h);
% title('Passband curve');
% grid on;
%
y = filter(bz1, az1, x);
end
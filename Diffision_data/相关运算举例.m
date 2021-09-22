%% 相关运算举例

A = zeros(5,5);
A(3,3) = 1;
B = zeros(5,5);
B(4,5) = 1;
figure
subplot(221)
imagesc(A)
subplot(222)
imagesc(B)

AA = xcorr2(A,A);
BB = xcorr2(B,B);
AB = xcorr2(A,B);
BA = xcorr2(B,A);
figure
subplot(221)
imagesc(AA)
title('AA')
subplot(222)
imagesc(BB)
title('BB')
subplot(223)
imagesc(AB)
title('AB')
subplot(224)
imagesc(BA)
title('BA')

figure
AA = ifft2(conj(fft2(A)).*fft2(A));
AB = ifft2(conj(fft2(A)).*fft2(B));
BB = ifft2(conj(fft2(B)).*fft2(B));
BA = ifft2(conj(fft2(B)).*fft2(A));
subplot(221)
imagesc(AA)
title('AA')
subplot(222)
imagesc(BB)
title('BB')
subplot(223)
imagesc(AB)
title('AB')
subplot(224)
imagesc(BA)
title('BA')
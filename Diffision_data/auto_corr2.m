function C = auto_corr2(A,B)

% 自相关运算

C = fftshift(ifft2(conj(fft2(A).*fft2(B))));

end
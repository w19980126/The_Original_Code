function C = auto_corr2(A,B)

% ���������

C = fftshift(ifft2(conj(fft2(A).*fft2(B))));

end
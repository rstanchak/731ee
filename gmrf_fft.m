function X = gmrf_fft(m,n,filter)
	X = randn(m,n);
	X = fft2(X);
	B = fft2(filter, m, n);
	X = X ./ sqrt(B);
	X = ifft2(X);

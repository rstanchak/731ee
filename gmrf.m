function X = gmrf(m,n,t1,t2,t3,t4)
	% lambda_s = 1-2\sum_{r \in \neighborhood(s)} \theta_r cos( 2pi/M*ry*sy + 2pi/N*rx*sx)
	% w(s) = zero mean, unit stdv white noise
	% e(s) = w(s) sqrt(lambda_s);
	% Sigma_s = 1/(N*M) \sum_{r \in \neighborhood(s)} e(r) * 
	% transform random noise into correlated noise

	w_s = randn(m,n);
	[ygrid, xgrid] = meshgrid( 1:m, 1:n );
	lambda_s = 1 - 2*t1*cos( 2*pi/m*mod(ygrid+1,m) + 2*pi/n*mod(xgrid,n) ) ...
	             - 2*t2*cos( 2*pi/m*mod(ygrid,m) + 2*pi/n*mod(xgrid+1,n) ) ...
				 - 2*t3*cos( 2*pi/m*mod(ygrid+1,m) + 2*pi/n*mod(xgrid+1,n) ) ...
				 - 2*t4*cos( 2*pi/m*mod(ygrid+1,m) + 2*pi/n*mod(xgrid-1,n) );
	real(fft2(lambda_s))
	imag(fft2(lambda_s))
	e_s = w_s .* sqrt( lambda_s );
	imagesc(e_s);

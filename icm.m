function X=icm(X0, mrf_potential);
% initial state, mrf_potential -- m x n potentials between a site and its neighbors

% pad X0 so that mrf_potential fits
[m,n] = size(mrf_potential);
m_2 = floor(m/2);
n_2 = floor(n/2);
[M,N] = size(X0);
X_pad = [zeros(m_2,N+2*n_2) ; zeros(M,n_2), X0, zeros(M,n_2) ; zeros(m_2,N+2*n_2) ];
niter = 10;

%for k=1:niter
%	for i=1:M
%		for j=1:N
%			X(i,j) = mrf_local_map(X_pad(i:i+m-1,j:j+n-1), mrf_potential, 0:255);
%		end%for
%	end%for
%	imagesc(X);
%	X_pad(m_2+1:m_2+m,n_2+1:n_2+n) = X;
%end%for

X=X0;
for k=1:niter
	max_E = zeros(M,N,2);
	max_L = X;
	for l=0:255
		filt = conv2(X0, mrf_potential, 'same');
		max_E(:,:,2) = filt + (l - X).*mrf_potential(m_2+1, n_2+1);
		[x, ix] = max(max_E,3);
		max_E(:,:,1) = x;
		idx = find( ix==2 );
		max_L(idx) = l;
	end%for
	imagesc(X);
end%for

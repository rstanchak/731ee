function [param X]= gmrf_param_lsq( im, neighbors )
% solve for gmrf parameters X
% Y = Y_n X
% where Y are image data, Y_n encodes dependencies on neighbors
[m,n] = size(im);

Y = reshape(im, m*n, 1);
Y_n = zeros( m*n, length(neighbors) );

[ygrid, xgrid] = meshgrid(1:m, 1:n);
ygrid = reshape(ygrid, m*n, 1);
xgrid = reshape(xgrid, m*n, 1);
for i=1:length(neighbors)
	nb = neighbors{i};
	idx1 = sub2ind( [m,n], mod(ygrid+nb(1)-1, m)+1, mod(xgrid+nb(2)-1, n)+1 );
	idx2 = sub2ind( [m,n], mod(ygrid+nb(3)-1, m)+1, mod(xgrid+nb(4)-1, n)+1 );
	Y_n(:,i) = reshape(im(idx1) + im(idx2), m*n, 1); 
end%for

param = pinv(Y_n)*Y;

k=floor(sqrt(length(neighbors)));
X=zeros(2*k+1, 2*k+1);
for i=1:length(neighbors)
	nb = neighbors{i};
	X(k+1+nb(1),k+1+nb(2)) = param(i);
	X(k+1+nb(3),k+1+nb(4)) = param(i);
end

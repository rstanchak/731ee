% 1. For each image pair, 
%    a. compute point correspondances
%    b. normalize image points
%    c. compute Fundamental matrix, Epipoles
% 2. Find set of points tracked in all images
%    d. compute Projective depth
% 3. Construct measurement matrix
% 4. Factor measurement matrix

if(~exist('fund_matrices') & ~exist('epipoles'))
	sfm_fm
end

% compute projective depth
% canonical depth for first img = 1
pdepth=ones( N, length(valid) );

for i=2:N
	e = epipoles{i-1}
	F = fund_matrices{i-1}
	% cross product matrix
	ecross = [ 0 -e(3) e(2); e(3) 0 -e(1); -e(2) e(1) 0 ];
	x_ip = [ pts(i-1, :) ; pts(N+i-1, :) ; ones( 1, n )];
	x_jp = [ pts(i, :) ; pts(N+i, :) ; ones(1, n ) ];
	pdepth(i,:) = pdepth(i-1,:) .* sum(x_jp.^2,1) ./ dot( ecross * x_ip, F * x_jp );
	% normalize length to sqrt(# features)
	pdepth(i,:) = pdepth(i,:) * sqrt(length(valid)) / sqrt(sum( pdepth(i,:).^2 ));
end%for

% normalize columns, then rows
for i=1:5
	pdepth = pdepth .* sqrt(size(pdepth, 1)) ./ ...
		repmat( sqrt(sum( pdepth.^2, 1 )), [size(pdepth, 1), 1] );
	pdepth = pdepth .* sqrt(size(pdepth, 2)) ./ ...
		repmat( sqrt(sum( pdepth.^2, 2 )), [1, size(pdepth, 2)] );
end

% construct measurement matrix W
W = zeros(3*N, length(valid));
W(1:3:size(W,1),:) = pts(1:N, :).*pdepth;
W(2:3:size(W,1),:) = pts(N+1:2*N, :).*pdepth;
W(3:3:size(W,1),:) = pdepth;

[u,s,v] = svd(W);
% W has rank at most 4
s1 = s(1:4, 1:4);
P = u(:, 1:4)*s1;
X1 = v(:, 1:4);
X = [X1(:,1)./X1(:,4), X1(:,2)./X1(:,4), X1(:,3)./X1(:,4)];

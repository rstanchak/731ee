% 1. For each image pair, 
%    a. compute point correspondances
%    b. normalize image points
%    c. compute Fundamental matrix, Epipoles
% 2. Find set of points tracked in all images
%    d. compute Projective depth
% 3. Construct measurement matrix
% 4. Factor measurement matrix

N = length(images);

fund_matrices={};
epipoles={};
step = 25;

img_idx = ceil(N/2);
if(~exist('pts'))
	[ygrid, xgrid, pts, valid] = correspond_one_all(images, img_idx, step); 
	pts = pts(:, valid);
end

% normalize points
[m,n] = size(pts);
c = mean(pts, 2);
s = std(pts, 0, 2);

pts = (pts - repmat(c, [1, n])) ./ repmat(s, [1, n]);
%T = [ 1/s, 0, -c1(1)/s1 0, 1/s1, -c1(2)/s1 ];

% compute fundamental matrices, epipoles
for i=2:N,
	disp(sprintf('Computing Fundamental Matrix %d', i-1));
	%[m,n] = size(images{i-1});
	%[ygrid,xgrid] = meshgrid( 1:step:m, 1:step:n );
	%pts1 = [reshape(xgrid, prod(size(xgrid)), 1), reshape(ygrid, prod(size(ygrid)), 1) ];
	%[pts2, status] = klt(images{i-1}, images{i}, pts1);
	%valid = find(status);

	%pts1 = [ pts1(valid,:), ones(length(valid),1)];
	%pts2 = [ pts2(valid,:), ones(length(valid),1)];


	[F, e] = fm_8point([pts(i-1,:)' pts(N+i-1,:)'], [pts(i,:)' pts(N+i,:)'])
	%[F1, e1] = fm_cv([pts(i-1,:)' pts(N+i-1,:)'], [pts(i,:)' pts(N+i,:)'])
	fund_matrices{i-1}=F;
	epipoles{i-1}=e; 
end

% compute projective depth
% canonical depth for first img = 1
pdepth=ones( N, n );

for i=2:N
	e = -epipoles{i-1}
	F = fund_matrices{i-1}
	% cross product matrix
	ecross = [ 0 -e(3) e(2); e(3) 0 -e(1); -e(2) e(1) 0 ];
	x_ip = [ pts(i-1, :) ; pts(N+i-1, :) ; ones( 1, n )];
	x_jp = [ pts(i, :) ; pts(N+i, :) ; ones(1, n ) ];
	pdepth(i,:) = pdepth(i-1,:) .* sum(x_jp.^2,1) ./ dot( ecross * x_ip, F * x_jp );
end%for



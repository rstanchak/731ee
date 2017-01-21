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
pdepth=ones( N, n );

% compute canonical projection matrices 
proj_matrices={};

% first proj is the identity
proj_matrices{1} = eye(3,4);

for i=2:N
	e = epipoles{i-1}
	F = fund_matrices{i-1}
	% cross product matrix
	ecross = [ 0 -e(3) e(2); e(3) 0 -e(1); -e(2) e(1) 0 ];
	P = [ -1/sum(e.^2)*(ecross*F), e ];

	proj_matrices{i} = P;
	%x_ip = [ pts(i-1, :) ; pts(N+i-1, :) ; ones( 1, n )];
	%x_jp = [ pts(i, :) ; pts(N+i, :) ; ones(1, n ) ];
	%pdepth(i,:) = pdepth(i-1,:) .* sum(x_jp.^2,1) ./ dot( ecross * x_ip, F * x_jp );
end%for

function [points3, views, images, ygrid, xgrid, points2, valid] = tk_cube( radius, numpoints, numviews )
	m2 = ceil(sqrt(numpoints/6));
	m = m2*m2;
	[gx,gy] = meshgrid(0:m2-1,0:m2-1);
	gx = reshape(gx, m, 1)./(m2-1);
	gy = reshape(gy, m, 1)./(m2-1);
	points3 = [ gx, gy, ones(m,1) ;  ...
	            gx, gy, zeros(m,1) ; ...
			   ones(m,1), gx, gy ; ... 
			   zeros(m,1), gx, gy ; ...
			  	gx, ones(m,1), gy ; ...
			   	gx, zeros(m,1), gy ]; 
	points3 = points3 .* 2*radius - radius;
	view_i = [1,0,0;rand(numviews-1, 3)];
	view_j = [0,1,0;rand(numviews-1, 3)];
	view_j(:,3) = ( view_i(:,1).*view_j(:,1) + view_i(:,2).*view_j(:,2) )./ -view_i(:,3);

	% normalize vectors
	view_i = view_i ./ repmat( sqrt(sum(view_i.^2, 2)), [1,3] );
	view_j = view_j ./ repmat( sqrt(sum(view_j.^2, 2)), [1,3] );
	view_i(1,:)=[1,0,0];
	view_j(1,:)=[0,1,0];

	view_i
	view_j

	% create projections
	points2_i = view_i * points3';
  	points2_j = view_j * points3';	

	images={};
	for i=1:numviews
	%	img = zeros(radius*2, radius*2);
	%	img( ceil(radius + points2_j(:,j)) , ceil(radius + points2_i(:,i)) ) = 1; 
	%	images{i} = img;
	end%for

	points2 = [ points2_i ; points2_j ];
	views = [ view_i ; view_j ];
	[ygrid, xgrid] = meshgrid(radius*2, radius*2);
	valid = 1:size(points2, 2);

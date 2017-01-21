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
step = 11;

img_idx = ceil(N/2);
if(~exist('pts'))
	[ygrid, xgrid, pts, valid] = correspond_one_all(images, img_idx, step); 
	pts = pts(:, valid);
end

% normalize points
[m,n] = size(pts);
c = mean(pts, 2);
s = std(pts, 0, 2);

normpts = (pts - repmat(c, [1, n])) ./ repmat(s, [1, n]);

% compute fundamental matrices, epipoles
% TODO test if T1'*F*T is correct
for i=2:N,
	disp(sprintf('Computing Fundamental Matrix %d', i-1));
	%[m,n] = size(images{i-1});
	%[ygrid,xgrid] = meshgrid( 1:step:m, 1:step:n );
	%pts1 = [reshape(xgrid, prod(size(xgrid)), 1), reshape(ygrid, prod(size(ygrid)), 1) ];
	%[pts2, status] = klt(images{i-1}, images{i}, pts1);
	%valid = find(status);

	%pts1 = [ pts1(valid,:), ones(length(valid),1)];
	%pts2 = [ pts2(valid,:), ones(length(valid),1)];


	%[F, e] = fm_8point([normpts(i-1,:)' normpts(N+i-1,:)'], [normpts(i,:)' normpts(N+i,:)'])
	[F, e] = fm_cv([normpts(i-1,:)' normpts(N+i-1,:)'], [normpts(i,:)' normpts(N+i,:)'], 'ransac')
	T1 = [ 1/s(i-1), 0, -c(i-1)/s(i-1) ; 0, 1/s(N+i-1), -c(N+i-1)/s(N+i-1) ; 0, 0, 1 ];
	T2 = [ 1/s(i), 0, -c(i)/s(i) ; 0, 1/s(N+i), -c(N+i)/s(N+i) ; 0, 0, 1 ];
	fund_matrices{i-1}=F;
	epipoles{i-1}=e; 
	%figure(1); imagesc(images{i-1});
	%figure(2); imagesc(images{i});
	%for j=1:10
	%	iplotepip(1,2,F);
	%end%for
	%plotepip(1,2, [pts(i-1,:)' pts(N+i-1,:)'], [pts(i,:)' pts(N+i,:)'],F);
	%break
end

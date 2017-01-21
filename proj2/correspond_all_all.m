function [ygrid, xgrid, points] = correspond_all( fnames, step ) 

images = {};
disp('Loading images...');
for i=1:length(fnames)
	images{i} = mean(imread(fnames{i}), 3);
end%for
im1 = images{1};
[m,n] = size(im1);
[xgrid, ygrid] = meshgrid(5:step:n, 5:step:m);
gridpts = [ reshape(xgrid, prod(size(xgrid)), 1), reshape(ygrid, prod(size(ygrid)), 1) ];
points = zeros(length(fnames), length(fnames), size(gridpts,1), size(gridpts,2));

for i=1:length(fnames)
	im2 = images{i};
	pts2 = gridpts;
	status2 = 1;
	points(i,i,:,:) = pts2;
	disp(sprintf('Computing correspondances for %s', fnames{i}));

	% track backward
	for j=1:i-1
		im1 = im2; 
		status1 = status2;
		im2 = images{j};
		pts1 = pts2;
		[pts2, status2] = klt(im1, im2, pts1);
		status2 = status2 & status1;
		points(i,j,:,:)=pts2;
		idx=find(status2==0);
		points(i,j,idx,:) = nan;
	end%for

	im2 = images{i};
	pts2 = gridpts;
	status2 = 1;

	% track forward 
	for j=i+1:length(fnames)
		im1 = im2; 
		status1 = status2;
		im2 = images{j};
		pts1 = pts2;
		[pts2, status2] = klt(im1, im2, pts1);
		status2 = status2 & status1;
		points(i,j,:,:)=pts2;
		idx=find(status2==0);
		points(i,j,idx,:) = nan;
	end%for
end%for


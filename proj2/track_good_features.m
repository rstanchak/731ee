function [points, valid] = track_good_features( images, i, maxfeatures ) 
% [points, valid] = correspond_one_all( images, i, maxfeatures ) 
% 	For an array of images, track a set of determined as 'good features'
% 	starting at index image i forwards and backwards in time

N = length(images);
im1 = images{i};
[m,n] = size(im1);

points0 = find_good_features( im1, [3,3], maxfeatures/9 );  

	im2 = images{i};
	pts2 = points0;
	status2 = 1;
	points(i,:) = pts2(:,1);
	points(N+i,:) = pts2(:,2);

	% track backward
	for j=i-1:-1:1
		im1 = im2; 
		status1 = status2;
		im2 = images{j};
		pts1 = pts2;
		[pts2, status2] = klt(im1, im2, pts1);
		status2 = status2 & status1;
		points(j,:) = pts2(:,1);
		points(j+N,:) = pts2(:,2);
		idx=find(status2==0);
		points(j,idx) = nan;
		points(j+N,idx) = nan;
	end%for

	im2 = images{i};
	pts2 = points0;

	% track forward 
	for j=i+1:N
		im1 = im2; 
		status1 = status2;
		im2 = images{j};
		pts1 = pts2;
		[pts2, status2] = klt(im1, im2, pts1);
		status2 = status2 & status1;
		points(j,:) = pts2(:,1);
		points(j+N,:) = pts2(:,2);
		idx=find(status2==0);
		points(j,idx) = nan;
		points(j+N,idx) = nan;
	end%for

%valid = find(~(isnan(points(N,:)) | isnan(points(1,:)) ));
valid = find(status2);

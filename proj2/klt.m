function [pts2, status, track_error] = klt(im1, im2, pts1)
% [pts2, status, track_error] = klt(im1, im2, pts1)
%    find coordinates corresponding to pts1 from im1 in im2 
%    using Lucas Kanade optical flow

	[m, n] = size(pts1);

	% function need pts1 to be 2xN
	if(n ~= 2)
		pts1=pts1';
	end%if

	% transpose x, y, convert to C indices
	pts1 = [ pts1(:,2)-1, pts1(:,1)-1 ]';

	% convert to single precision
	im1 = uint8(im1);
	im2 = uint8(im2);
	pts1 = single(pts1);

	[pts2, status, track_error] = cvCalcOpticalFlowPyrLK(im1, im2, pts1);

	med = median(track_error);
	med = median(track_error(find(track_error>med)));
	status = status & track_error < med;

	% transpose, convert to Matlab indices
	pts2 = [ pts2(2,:)+1; pts2(1,:)+1 ];

	% transpose to match input
	if(size(pts2,1)~=m)
		pts2 = pts2';
	end%if
	

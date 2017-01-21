function pts = good_features_to_track( im, count )
% pts = good_features_to_track(image, count)
%   Find corners with strong eigenvalues using OpenCV

size(im)
if(length(size(im))>2 & size(im,3)>1)
	im = rgb2gray(im);
end%if
if(~strcmp(class(im),'uint8'))
	im = uint8(im);
end
size(im)
pts = cvGoodFeaturesToTrack( im, count );
pts = [(pts(2,:)+1)' (pts(1,:)+1)'];

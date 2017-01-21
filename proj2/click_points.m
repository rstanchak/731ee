function [pts, xgrid, ygrid, valid] = click_points(images)

N=length(images);
npts=0;
if exist('pts')
	npts=size(pts,2)
else
	pts=zeros(N*2,1);
end
npts=npts+1;
[m,n] = size(images{1});
for i=1:length(images)
	imagesc(images{i});
	if npts>1
		hold on; plot(pts(i, :), pts(i+N,:), '+r'); hold off;
	end
	pt = ginput(1);
	hold on; plot(pt(1), pt(2), '+g'); hold off;
	pts(i, 	npts) = pt(1);
	pts(i+N, npts) = pt(2);
	pause(0.5);
end%for
[xgrid, ygrid]=meshgrid(1:n, 1:m);
valid=1:npts;

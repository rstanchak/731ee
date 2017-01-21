function [p1, p2] = click_points2(im1, im2, npts)
colors={'+g', '+r', '+b', '+k'}
figure(1);	imagesc(im1);
figure(2); imagesc(im2);
for i=1:npts
	figure(1);
	pt = ginput(1);
	hold on; plot(pt(1), pt(2), colors{ mod(i,length(colors))+1 }); hold off;
	p1(i, :) = pt;
	figure(2);
	pt = ginput(1);
	hold on; plot(pt(1), pt(2), colors{ mod(i, length(colors))+1 }); hold off;
	p2(i, :) = pt;
	pause(0.5);
end%for

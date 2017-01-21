% this script uses a 8 point correspondences to calculate the fundamental
% matrix between two images and plot the epipolar lines

% load images 
im1 = imread('castle/castle.001.jpg');
im2 = imread('castle/castle.002.jpg');

if ~exist('p1')
	clear p1
	clear p2
	[p1 p2]= click_points2(im1, im2, 8)
end

%[F,e] = fm_8pointN(p1, p2);
[F,e] = fm_cv(p1, p2,'lmeds');
%[F,e] = fm_8pointN(p1, p2);
disp('Point error:');
dot(([p1 ones(8,1)]*F)',[p2 ones(8,1)]' )

figure(1); imshow(im1); axis image; axis fill;
figure(2); imshow(im2); axis image; axis fill;
plotepip(1,2,p1,p2,F);
figure(1); saveas(gcf, 'epipolar1.png');
figure(2); saveas(gcf, 'epipolar2.png');

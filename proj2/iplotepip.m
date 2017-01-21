function iplotepip(f1,f2,F)
% e = iplotepip(I1,I2,map1,map2,p1,p2,F) Plot epipolar lines
%
% In:
%   I1, I2, map1, map2: images and colormaps for the 2 images (from 'imread').
%   p1, p2: Nx2 arrays containing correspondences' pixel coordinates by rows.
%   F: 3x3 fundamental matrix.
% Out:
%   e: 1x2 array, average error (distance-to-line) in each image.

figure(f1); p1 = ginput(1);

% calculate line equations
% p1 * F * x2 = 0
% x1 * F * p2 = 0
% get a line equation
% m1 x + m2 y + m3 = 0
% where [m1 m2 m3] = p*F or F*p
l2 = [p1 ones(size(p1,1),1)] * F;

figure(f1);
hold on; plot( p1(1), p1(2), 'r+' ); hold off;

% plot on figure 2 
figure(f2); 
[pt1, pt2] = clipline(l2(:,1), l2(:,2), l2(:,3), axis());
line( [pt1(:,1); pt2(:,1)], [pt1(:,2); pt2(:,2)] );



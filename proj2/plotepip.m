function e = plotepip(f1,f2,p1,p2,F)
% e = plotepip(I1,I2,map1,map2,p1,p2,F) Plot epipolar lines
%
% In:
%   I1, I2, map1, map2: images and colormaps for the 2 images (from 'imread').
%   p1, p2: Nx2 arrays containing correspondences' pixel coordinates by rows.
%   F: 3x3 fundamental matrix.
% Out:
%   e: 1x2 array, average error (distance-to-line) in each image.

% calculate line equations
% p1 * F * x2 = 0
% x1 * F * p2 = 0
% get a line equation
% m1 x + m2 y + m3 = 0
% where [m1 m2 m3] = p*F or F*p
l2 = [p1 ones(size(p1,1),1)] * F;
l1 = [F * [p2 ones(size(p2,1),1)]']';

%for i=1:size(p1,1)

% plot on figure 1
figure(f1);
[pt1, pt2] = clipline(l1(:,1), l1(:,2), l1(:,3), axis());
line( [pt1(:,1)'; pt2(:,1)'], [pt1(:,2)'; pt2(:,2)'] );
hold on; plot( p1(:,1), p1(:,2), 'r+' ); hold off;

% plot on figure 2 
figure(f2); 
[pt1, pt2] = clipline(l2(:,1), l2(:,2), l2(:,3), axis());
%l2(1:10,:)
%pt1(1:10,:)
%pt2(1:10,:)
%p2(1:10,:)
line( [pt1(:,1)'; pt2(:,1)'], [pt1(:,2)'; pt2(:,2)'] );
hold on; plot( p2(:,1), p2(:,2), 'r+' ); hold off;

e=zeros(1,2);
e(1) = mean(point_line_dist( l1, p1 ))
e(2) = mean(point_line_dist( l2, p2 ) )

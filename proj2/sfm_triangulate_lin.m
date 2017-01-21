function X = sfm_triangulate_lin(x, P)
% X = sfm_triangulate_lin(x,P)
%    compute 3d coordinates of point given projection in N images and their associated projection matrices P
%    from "Stereo from Uncalibrated Cameras" Richard Hartley, Rajiv Gupta and Tom Chang 1992


% 2D coordinates u,v are given by 
% w*v = p1'*X
% w*u = p2'*X
% w = p3'*X

% v*p3'*X = p1'*X
% u*p3'*X = p2'*X

% p1'X - v*p3'*X = 0
% p2'X - u*p3'*X = 0

% X=[x,y,z,k]'

% p11*x + p12*y + p13*z + p14*k - v*(p31*x + p32*y + p33*z + p34*k) = 0
% p21*x + p22*y + p23*z + p24*k - u*(p31*x + p32*y + p33*z + p34*k) = 0

% linear system ... for each view
% [ p11-v*p31  p12-v*p32  p13-v*p33  p14-v*p34 ]  
% [ p21-u*p31  p22-u*p32  p23-u*p33  p24-u*p34 ]  * X = 0
% [ ... ]

for i=1:length(P)
	A_1(i,:) = [ P(1,1)-

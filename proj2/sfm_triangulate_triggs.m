function X = sfm_triangulate_lin(x, P)
% X = sfm_triangulate_lin(x,P)
%    compute 3d coordinates of point given projection in N images and their associated projection matrices P

for i=1:length(P)
	A_1(i,:) = [ P(1,1)-

function [F, e] = fm_cv( p1, p2, method )
%function F = fm_cv( pts1, pts2 )
% compute the fundamental matrix relating corresponding 2D points in two images

[m,n] = size(p1);
if(n~=2)
	error('Expected pts1 and pts2 to be Mx2 matrices');
end%if

if(~exist('method'))
	method='lmeds';
end%if

F = cvFindFundamentalMat(p1, p2, method);

[U,S,V] = svd(F);
e = V(3,:)';

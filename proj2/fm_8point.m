function [F, e] = fm_8point( p1, p2 )
%function F = fm_8point( pts1, pts2 )
% compute the fundamental matrix relating corresponding 2D points in two images

[m,n] = size(p1);
if(n~=2)
	error('Expected pts1 and pts2 to be Mx2 matrices, where M>=8');
end%if
if(m<8)
	error('Expected at least 8 point correspondences');
end%if

A = [ p1(:,1).*p2(:,1), ...
      p1(:,1).*p2(:,2), ...
	  p1(:,1), ...
	  p1(:,2).*p2(:,1), ...
	  p1(:,2).*p2(:,2), ...
	  p1(:,2), ...
	  p2(:,1), ...
	  p2(:,2), ...
	  ones(m,1) ];

[U, S, V] = svd(A);
F = reshape(V(:,9), 3, 3);

% F' that is singular and minimizes the frobenius norm | F - F' |
[U, S, V] = svd(F);
F = U*diag([S(1,1), S(2,2), 0])*V';

e = V(3,:)';

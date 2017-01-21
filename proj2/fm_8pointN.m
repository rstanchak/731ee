function [F, e] = fm_8pointN( p1, p2 )
%function F = fm_8pointN( pts1, pts2 )
% compute the fundamental matrix relating corresponding 2D points in two images

[m,n] = size(p1);
if(n~=2)
	error('Expected pts1 and pts2 to be Mx2 matrices, where M>=8');
end%if
if(m<8)
	error('Expected at least 8 point correspondences');
end%if

c1 = mean(p1, 1);
c2 = mean(p2, 1);
s1 = std(p1, 1);
s2 = std(p2, 1);

T1 = [ 1/s1(1), 0, -c1(1)/s1(1); 0, 1/s1(2), -c1(2)/s1(2); 0, 0, 1];
T2 = [ 1/s2(1), 0, -c2(1)/s2(1); 0, 1/s2(2), -c2(2)/s2(2); 0, 0, 1];

p1 = [p1 , ones(m,1)]*T1';
p2 = [p2 , ones(m,1)]*T2';

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

Fcv = fm_cv(p1(:,1:2), p2(:,1:2), '8point') 
F = F./F(3,3)
F = T1'*F*T2;

% normalize so (3,3) element is 1

e = V(3,:)';

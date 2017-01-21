function F = fm( pts1, pts2 )
% compute the fundamental matrix relating corresponding 2D points in two images

[m,n] = size(pts1);
if(n~=2)
	error('Expected pts1 and pts2 to be Mx2 matrices');
end%if

% normalize input points 
c1 = mean( pts1, 1);
s1 = mean2( (pts1 - repmat(c1, [m, 1])).^2 );
T1 = [ 1/s1, 0, -c1(1)/s1; 0, 1/s1, -c1(2)/s1; 0, 0, 1 ];
c2 = mean( pts2, 1);
s2 = mean2( (pts2 - repmat(c2, [m, 1])).^2 );
T2 = [ 1/s2, 0, -c2(1)/s2; 0, 1/s2, -c2(2)/s2; 0, 0, 1 ];

p1 = [pts1 ones(m,1)] * T1;
p2 = [pts2 ones(m,1)] * T2;

A = [ p1(:,1).*p2(:,1), ...
      p1(:,1).*p2(:,2), ...
	  p1(:,1), ...
	  p1(:,2).*p2(:,1), ...
	  p1(:,2).*p2(:,2), ...
	  p1(:,2), ...
	  p2(:,1), ...
	  p2(:,2), ...
	  ones(m,1) ];

size(A)
[U, S, V] = svd(A);
size(V)

F = reshape(V(9,:), 3, 3);
[U, S, V] = svd(F);
F = U*diag([S(1,1), S(2,2), 0])*V';
% error = sum( sum((p1*F).*p2, 2).^2 )

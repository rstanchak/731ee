function [C, G, Q, v] = findA(Rhat, x, y)

F = size(Rhat,1)/2;

x2 = x.^2;
y2 = y.^2;

clear Q
for f=1:F,
  g = f + F;
  Q(f,:) = (zt(Rhat(f,:), Rhat(f,:)))/ (1 + x2(f)) - ...
      (zt(Rhat(g,:), Rhat(g,:))) / (1 + y2(f));
  Q(g,:) = zt(Rhat(f,:), Rhat(g,:)) - ...
      x(f) * y(f) * ((zt(Rhat(f,:), Rhat(f,:)) / (1 + x2(f))) + ...
      (zt(Rhat(g,:), Rhat(g,:)) / (1 + y2(f)))) / 2;
end
      
Q(2*F+1, :) = zt(Rhat(1,:), Rhat(1,:));
%Q(1:50, :)
  
rhs = [zeros(2*F, 1);1];
v = Q \ rhs;
B = Q*v;

% C is a symmetric 3x3 matrix such that C = G * transpose(G)
C(1,1) = v(1);                  
C(1,2) = v(2);                  
C(1,3) = v(3);                  
C(2,2) = v(4);
C(2,3) = v(5);
C(3,3) = v(6);
C(2,1) = C(1,2);
C(3,1) = C(1,3);
C(3,2) = C(2,3);

e = eig(C)
neg = 0;
if e(1) <= 0, neg = 1; end
if e(2) <= 0, neg = 1; end
if e(3) <= 0, neg = 1; end
if neg == 1, G = [];
else G = sqrtm(C);
end

  






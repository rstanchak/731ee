function d = point_line_dist(ln, pt)
% d=point_line_dist(ln, pt)
% where ln = [a b c] -- corresponds to the line equation ax+by+c=0
% and pt = [x y]
% distance is | ax + by + c| / sqrt( a^2 + b^2 )

a = ln(:,1);
b = ln(:,2);
c = ln(:,3);
x = pt(:,1);
y = pt(:,2);
d = abs(a.*x+b.*y+c)./sqrt(a.^2 + b.^2);

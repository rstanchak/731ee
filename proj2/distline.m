% d = distline(p,l) Point-to-line distance
%
% Point (x,y), line ax+by+c = 0: d = (ax+by+c)/sqrt(a²+b²).
%
% In:
%   p: Nx2 list of points by rows.
%   l: Nx3 list of line coefficients by rows.
% Out:
%   d: distance.
%
% Any non-mandatory argument can be given the value [] to force it to take
% its default value.

% Copyright (c) 2006 by Miguel A. Carreira-Perpinan

function d = distline(p,l)

d = abs(sum([p ones(size(p,1),1)].*l,2))./sqrt(sum(l(:,1:2).^2,2));


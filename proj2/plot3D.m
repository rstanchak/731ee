% plot3D(P) Plot world (3D) points
%
% In:
%   P: Nx3 matrix containing 3D points by rows.
%
% Any non-mandatory argument can be given the value [] to force it to take
% its default value.

% Copyright (c) 2006 by Miguel A. Carreira-Perpinan

function plot3D(P)

plot3(P(:,1),P(:,2),P(:,3),'bo');
xlabel('x'); ylabel('y'); zlabel('z');
set(gca,'DataAspectRatio',[1 1 1]);


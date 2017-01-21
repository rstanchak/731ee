% F = fmat8(p1,p2[,alg]) Fundamental matrix estimation
%
% Fundamental matrix estimation from correspondences by 8-point algorithm
% and optionally preconditioning.
%
% In:
%   p1, p2: Nx2 arrays containing correspondences' pixel coordinates by rows.
%   alg: 'precond' for preconditioning, otherwise no preconditioning.
% Out:
%   F: 3x3 fundamental matrix.


% F = fmat8aff(p1,p2[,alg]) Affine fundamental matrix estimation
%
% Affine fundamental matrix estimation from correspondences by 8-point
% algorithm and optionally preconditioning.
%
% In:
%   p1, p2: Nx2 arrays containing correspondences' pixel coordinates by rows.
%   alg: 'precond' for preconditioning, otherwise no preconditioning.
% Out:
%   F: 3x3 affine fundamental matrix.


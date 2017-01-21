% [M1,M2,P] = affSfM(p1,p2,F) Affine structure from motion
%
% Affine structure from motion from 2-view correspondences and affine
% fundamental matrix (algorithm in 12.2.2 in the book).
%
% In:
%   p1, p2: Nx2 arrays containing correspondences' pixel coordinates by rows.
%   F: 3x3 affine fundamental matrix.
% Out:
%   M1, M2: 2x4 camera matrices.
%   P: Nx3 world point reconstruction.


% [M1,M2,P] = affSfMtk(p1,p2) Affine structure from motion
%
% Affine structure from motion from 2-view correspondences with Tomasi-Kanade
% method.
%
% In:
%   p1, p2: Nx2 arrays containing correspondences' pixel coordinates by rows.
% Out:
%   M1, M2: 2x4 camera matrices.
%   P: Nx3 world point reconstruction.


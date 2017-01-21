% [M1,M2,P] = eucl_up(M1,M2,P) Euclidean upgrade
%
% Euclidean upgrade assuming orthographic perspective by linear
% least-squares and Cholesky decomposition.
%
% In:
%   M1, M2: 2x4 camera matrices.
%   P: Nx3 world point reconstruction.
% Out: same after Euclidean upgrade.


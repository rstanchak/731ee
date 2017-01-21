fid = fopen('200118/patches.txt');
C = textscan(fid, '%s %d %d %d %d %d');
fclose(fid);

boxes = double([ C{3}+1, C{4}+1, C{3}+C{5}+1,  C{4}+C{6}+1 ]);
m = max( boxes(:,3) );
n = max( boxes(:,4) );
M = zeros(m, n);

W = distance( boxes', boxes' );
D = diag( sum( W, 2 ) );
L = inv(D)*(D-W);

[U, S, V,] = svds(L, 10);
S = diag(S);

plot( sort(S) );

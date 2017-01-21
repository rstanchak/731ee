fid = fopen('200118/patches.txt');
C = textscan(fid, '%s %d %d %d %d %d');
fclose(fid);

%scale factor
s=50;

ul = [ C{3}+1, C{4}+1 ];
lr = [ C{3}+C{5}+1,  C{4}+C{6}+1 ];
m = max( lr(:,2) )/s + 1;
n = max( lr(:,1) )/s + 1;
M = zeros(m, n);

fnames = C{1};

X = double([ ul + (lr - ul)./2, lr(:,1)-ul(:,1), lr(:,2)-ul(:,2) ]);

M = zeros(m,n);
idx = sub2ind([m n], ceil(X(:,2)./s), ceil(X(:,1)./s));
M(idx) = X(:,3).*X(:,4)./(s*s);
imagesc(M);

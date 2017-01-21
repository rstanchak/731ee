fid = fopen('200118/patches.txt');
C = textscan(fid, '%s %d %d %d %d %d');
fclose(fid);

ul = [ C{3}+1, C{4}+1 ];
lr = [ C{3}+C{5}+1,  C{4}+C{6}+1 ];
m = max( lr(:,2) );
n = max( lr(:,1) );
M = zeros(m, n);

fnames = C{1};

X = double([ ul + (lr - ul)./2, lr(:,1)-ul(:,1), lr(:,2)-ul(:,2) ]);
X_sc = mean(X, 1);
X = X ./ repmat(X_sc, [length(X), 1]);
[U,S,V] = svd(X);
imagesc(U);
drawnow;
CV = cov(X);
X_0 = mean(X);
[V, S] = eig(CV);

[sorted_s, sorted_i] = sort(diag(S));

V=V(:, flipud(sorted_i));
clear Y;
V=V(:,1:3);
%for i=1:length(X)
%	x = X(i,:)-X_0
%	Y(i,:) = V'*x';
%	x = V*Y(i,:)'
%end

for i=1:m;
	for j=1:n;
		[i/X_sc(1), j/X_sc(2)];
		x = double([i, j, X_0(3:4)])-X_0(1:4);
		y = V'*x';
		x = (V*y + X_0') .* X_sc';
		W(i,j) = x(3);
		H(i,j) = x(4);
	end
end
figure(1);
imagesc( W );
figure(2);
imagesc( H );
%for i=1:length(lr)
	% sum squares
	%M(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) = M(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) + 1;

	%M(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) = 1;

	% outline box
	%M(ul(i,2), ul(i,1):lr(i,1)) = 1;
	%M(ul(i,2):lr(i,2), ul(i,1)) = 1;
	%M(lr(i,2), ul(i,1):lr(i,1)) = 1;
	%M(ul(i,2):lr(i,2), lr(i,1)) = 1;


%	if mod(i,10)==0
%		C{1}(i)
%		imagesc(M);
%		drawnow;
%	end;
%end

fid = fopen('200030/patches.txt');
C = textscan(fid, '%s %d %d %d %d %d');
fclose(fid);

ul = [ C{3}+1, C{4}+1 ];
lr = [ C{3}+C{5}+1,  C{4}+C{6}+1 ];
m = max( lr(:,2) );
n = max( lr(:,1) );
M = ones(m, n);
A = zeros(m, n);
W = zeros(m, n);
H = zeros(m, n);

fnames = C{1};

for i=1:length(lr)
	% sum number of incident boxes/pixel
	M(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) = M(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) + 1;

	% sum area of incident box/pixel
	A(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) = A(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) + prod(double(lr(i,:)-ul(i,:)));
	W(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) = W(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) + double(lr(i,1)-ul(i,1));
	H(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) = H(ul(i,2):lr(i,2), ul(i,1):lr(i,1)) + double(lr(i,2)-ul(i,2));

	% outline box
	%M(ul(i,2), ul(i,1):lr(i,1)) = 1;
	%M(ul(i,2):lr(i,2), ul(i,1)) = 1;
	%M(lr(i,2), ul(i,1):lr(i,1)) = 1;
	%M(ul(i,2):lr(i,2), lr(i,1)) = 1;


	continue;

	if mod(i,10)==0
		idx = find(M<5);
		C{1}(i)
		
		figure(1);
		X = A./M;
		X(idx)=0;
		%imagesc(X);
		
		figure(2);
		X = W./M;
		X(idx)=0;
		imagesc(X);

		figure(3);
		X = H./M;
		X(idx)=0;
		imagesc(X);
		
		drawnow;
	end;
end

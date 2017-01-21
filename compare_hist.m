format = '200118.%04d.jpg';
hist_ranges = { 0:.01:1, 0:.01:1 }; 

N=100;
if exist('W')~=1 | size(W,1)~=N
	clear fnames;
	clear images;
	clear histograms;
	k=1;
	W=zeros(N,N);
	sigma=128;
	for i=1:N
		fname = sprintf(format, i);
		if exist(fname)==2
			disp(fname);
			im = imread(fname);
			% chop off top 4 junk rows
			images{k} = im(5:end,:,:);
			fnames{k} = fname;
			hsv = rgb2hsv(images{k});
			sz = size(hsv);
			histograms{k}=histnd( reshape(hsv, sz(1)*sz(2), sz(3)), 0:0.01:1, 0:0, 0:0.01:1);
			histograms{k}=reshape(histograms{k},101,101);
			k=k+1;
		end
		for j=1:i;
			diff = images{i}-images{j};
			W(i,j) = exp(-norm(double(reshape(diff, prod(size(diff)), 1)))/(sigma^2));
			%W(i,j) = exp(-norm((histograms{i}-histograms{j}).^2)/sigma^2);
			W(j,i) = W(i,j);
		end
		imagesc(W);
		drawnow;
	end
end

% do spectral clustering
nclusters=4;
D = sum(W,2);
D_inv = diag(1.0./D);
L = D_inv*W;
[V,S] = eig(L);
[Y, sorted_S] = sort(diag(S));
clusters = kmeans( V(:, sorted_S(1:nclusters))', nclusters);

imagesc( clusters );
input('Press return to continue');

for i=1:nclusters
	idx = find( clusters==i );
	disp(sprintf('Images in cluster %d', i));
	for j=1:length(idx);
		imagesc( images{ idx(j) } );
		drawnow;
		pause(.1);
	end
	input('Press return to continue');
end

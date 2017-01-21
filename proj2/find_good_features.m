function pts = find_good_features(im, div, count)
[m,n,c] = size(im);
all_pts = {};
k=1;
npoints=0;
for i=1:div(1)
	for j=1:div(2)
		y1=(i-1)/div(1)*m+1;
		y2=i/div(1)*m;
		x1=(j-1)/div(2)*n+1;
		x2=j/div(2)*n;
		pt = good_features_to_track(im(y1:y2, x1:x2), count)
		all_pts{k} = [(pt(:,1)+x1-1), (pt(:,2)+y1-1)];
		k=k+1;
		npoints=npoints+size(pt,1);
	end
end
pts = zeros(npoints,2);
k=1;
for i=1:length(all_pts)
	pts(k:k+size(all_pts{i},1)-1,:)=all_pts{i};
	k=k+size(all_pts{i},1);
end;

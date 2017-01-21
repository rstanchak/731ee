function maxl=mrf_local_map(neighborhood, theta, labels)
	[m,n] = size(neighborhood);
	site = [ ceil(m/2), ceil(n/2) ];
	maxl=0;
	maxe=0;
	for i=1:length(labels)
		label = labels(i);
		neighborhood(site(1), site(2)) = label;
		e = sum(sum(neighborhood.*theta)); 
		if e>maxe
			maxe=e;
			maxl=label;
		end%if
	end%for
end%function

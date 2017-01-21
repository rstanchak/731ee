function X=movedups(fnames)
	im = 1;
	pat = '(?<dirname>.*)[\\\/]+(?<basename>[^\\\/]*)';
	for f=1:length(fnames)
		prev = im;
		im = imread(fnames{f});
		if(f>2)
			diff = im - prev;
			if(length(find(diff))==0)
				n = regexp( fnames{f}, pat, 'names');
				dest = strcat(n.dirname,'/dups/',n.basename)
				movefile(fnames{f}, dest);
			end
		end
	end

function fnames = find_image_files(dirname)

	pat = '(\.bmp|\.jpg|\.gif|\.pgm|\.pbm|\.png)$'; 

	% read filenames in directory 
	all = dir(dirname);
	all = {all.name};
	
	% filter out not-images
	j=1;
	for i=1:length(all)
		if regexpi(all{i}, pat)
			fnames{j} = all{i};
			j=j+1;
		end
	end

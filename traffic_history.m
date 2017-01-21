function traffic_history( formats )
	sz=[240 352 3];
	nhist=5;
	A = uint8(zeros( sz(1)*nhist, sz(2)*length(formats), sz(3))); 
	for i=1:1400
		for j=1:length(formats)
			fname = sprintf(formats{j}, i);
			if(exist(fname)==2)
				A(1:sz(1), sz(2)*(j-1)+1:sz(2)*j,:) = imread(fname);
			end
		end
		A(sz(1)+1:nhist*sz(1), :, :) = A(1:sz(1)*(nhist-1),:,:);
		image(A);
		drawnow;
		set(gcf, 'CurrentCharacter', 'X');
		figure(gcf);
		waitfor(gcf, 'CurrentCharacter');
		fromDir = upper(get(gcf, 'CurrentCharacter'));
	end

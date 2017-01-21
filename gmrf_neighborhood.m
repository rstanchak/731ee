function nb = gmrf_neighborhood( radius )
	k = floor(radius);
	idx=1;

	for i=0:k
		for j=0:k
			if( (i>0 | j>0) & sqrt(i^2+j^2)<=radius ),
				nb{idx} = [i j -i -j];
				idx = idx+1;
				if(i>0 & j>0)
					nb{idx} = [i, -j, -i, j];
					idx = idx+1;
				end%if
			end%if
		end%for
	end%for


		

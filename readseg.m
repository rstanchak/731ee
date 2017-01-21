function comp = readseg(fname)
% READSEG reads in ground truth for image segmentation
% 
%    SEGMENTATION = READSEG( FILENAME ) parses an image segmentation 
%    ground truth file from the Berkeley data set returns an image 
%    where pixels with the same value belong in the same segment
%
%    Data set: http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/

if (nargin ~= 1)
	   error('Not enough input arguments');
end
fid = fopen(fname, 'r');
width=-1;
height=-1;
invert=0;
flipflop=0;
not_data=1;
% read header
while not_data;
	s = fgetl(fid);
	s = split(s, ' ');
	s = cellstr(s);
	if strcmp(s{1},'width')
		width = str2num(s{2});
	elseif strcmp(s(1),'height')
		height = str2num(s{2});
	elseif strcmp(s(1),'flipflop');
		flipflop = str2num(s{2});
	elseif strcmp(s(1),'invert')
		invert = str2num(s{2});
	elseif strcmp(s(1),'data')
		not_data=0;
	end
end

%read data
if width > 0 & height > 0
	comp = -1 .* ones(height, width);
	str=fgets(fid);
	while str~=-1;
		[r, count] = sscanf(str, '%d %d %d %d');
		if count==4
			seg=r(1); c1=r(3)+1; c2=r(4); r=r(2)+1;
			comp(r, c1:c2) = seg;
		end;
		str=fgets(fid);
	end
end
fclose(fid);

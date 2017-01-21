function [p1, p2] = clipline(a, b, c, bx)
% clipline(a,b,c, [x1 x2 y1 y2])
% clip line ax+by+c=0 on the current figure using [x1 x2 y1 y2] as the 
% clipping box.

ln=zeros(length(a), 4);
lnx=zeros(length(a), 4);
lny=zeros(length(a), 4);

% find intersection w/ lines of clipping box?
% x=0 y=-c/b
lnx(:,1)=bx(1);
lny(:,1)=-(c+a.*bx(1))./b;
ln(:,1)=lny(:,1);

% y=0 x=-c/a
lnx(:,3)=-(c+b.*bx(3))./a;
lny(:,3)=bx(3);
ln(:,3)=lnx(:,3);

% x=w y=-(c+aw)/b
lnx(:,2)=bx(2);
lny(:,2)=-(c+a.*bx(2))./b;
ln(:,2)=lny(:,2);

% y=h x=-(c+bh)/a
lnx(:,4)=-(c+b.*bx(4))./a;
lny(:,4)=bx(4);
ln(:,4)=lnx(:,4);

numvalid=zeros(length(a),1);
valididx=zeros(length(a),4);

for i=1:4
	% is this intersection within the clipping box?
	if i<3
		llim=floor(bx(3));
		ulim=ceil(bx(4));
	else 
		llim=floor(bx(1));
		ulim=ceil(bx(2));
	end%if
	idx=find( ln(:,i)~=nan & ln(:,i)~=inf & ln(:,i)>=llim & ln(:,i)<=ulim);
	if length(idx)>0,
		numvalid(idx)=numvalid(idx)+1;
		idx2=sub2ind(size(valididx), idx, numvalid(idx));
		valididx(idx2)=i;
	end
end

p1 = zeros( length(a), 2 ); p2 = p1;

idx = find(numvalid >= 2);
if(length(idx)>0)
	idx1 = sub2ind( size(lnx), idx, valididx(idx, 1));
	idx2 = sub2ind( size(lnx), idx, valididx(idx, 2));
	p1(idx,:) = [lnx(idx1), lny(idx1) ];
	p2(idx,:) = [lnx(idx2), lny(idx2) ];
end

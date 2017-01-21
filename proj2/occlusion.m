% This routine is the main one to be used for recovering missing points of a 
frame sequence. Please change the name of features60frames100.txt to the file
that contains the new sequence.

load 'features60frames160.txt'
featuresping=features60frames160;
[lm,ln]=size(featuresping);
x=1:2:ln-1;
y=2:2:ln;

% Get the submatrices U and V

U = featuresping(:,x);
V = featuresping(:,y);
W = [U;V];

[m,n]=size(W);
m=m/2;

Wold = W;

counter = 0;
for i=1:m,
  for j=1:n,
   Pd = []; Fd = [];
   if (eq(U(i,j),-1))   % Undefined value.
      [vfound,Pd,Fd] = condition(U,i,j);
      Pd = [Pd;j]';
      if (eq(vfound,1))
          % display ('found and can do it'); 
           [Upos,Vpos] = getPoint(U,V,Pd,Fd,i,j);
           if (Upos ~= -1 & Vpos ~= -1) 
             [i,j];
              counter = counter + 1;
              U(i,j) = Upos;
              V(i,j) = Vpos;
           
           end;
      end
   end
  end
end


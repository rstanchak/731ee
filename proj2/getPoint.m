% This function implements the basic occlusion algorithm described in the
% Tomasi and Kanade paper. It uses the row-wise extension.

% It receives submatrices U,V, the current point position (posi,posj)
% and the indexes of the points (Pd for the points, Fd for the frames)

function [Upos,Vpos] = getPoint(U,V,Pd,Fd,posi,posj);

Upos = -1;
Vpos = -1;
e = ones(4,1);

% (4,4) is always unknown.

% --------- This generates the submatrices of U and V -------

for i=1:3,
  for j=1:4,
    Uprime(i,j) = U(Fd(i),Pd(j));
    Vprime(i,j) = V(Fd(i),Pd(j));
  end
end;

% ---------- This generates the submatrix of W(8 x 4) --------
Uunknown = []; Vunknown= [];
for j=1:3,
  Uunknown = [Uunknown, U(posi,Pd(j))];
  Vunknown = [Vunknown, V(posi,Pd(j))];
end

Uunknown(4)=0;
Vunknown(4)=0;

W = [Uprime; Uunknown; Vprime; Vunknown];


% ------------ Get the submatrix Wprime W'(6 x 4)  ----------

Wprime=[Uprime;Vprime];


% ------------ Factorize Wprime and get R t and S -----------
[R,t,S] = factor(Wprime);

% Check for non-normalized R and S.
if isempty(R) | isempty(S) 
  display ('Empty matrices R and S ');
  return;
end

% ------------- Get the centroid c (see algorithm) -----------
sumc = [0 0 0]';
for i=1:3,
  sumc = sumc + S(:,i);
end

c = sumc / 3;

%---------  Compute the projection of c in the 4th frame -----

apos =0;
bpos =0;

% Find the missing values for vector t

for j=1:3,
  apos = apos + U(posi,Pd(j));
  bpos = bpos + V(posi,Pd(j));
end

apos = apos/3;
bpos = bpos/3;

Sprime = [];
for j=1:3,
  Sprime = [Sprime,S(:,j) - c];
end

% --------------------- Find u'4p and v'4p -------------------
Up = []; Vp = [];

for j=1:3,
  Up(j) = U(posi,Pd(j)) - apos;
  Vp(j) = V(posi,Pd(j)) - bpos;
end

Up = Up/3;
Vp = Vp/3;

tempSprime=Sprime;
Sprime = floor(Sprime - 0.5);
Up = floor(Up - 0.5);
Vp = floor(Vp - 0.5);

if (det(Sprime) == 0) 
   Sprime = floor(tempSprime);
end


% ------------- Find vectors i and j for the missing point ------
VecI = Sprime\Up';
VecJ = Sprime\Vp';

Nu = ones(4,1);
Nu(4) = 0;

% ------------------------- Compute extended R -------------------
for i=1:3,
  Rcomp(i,:) = R(i,:);
end;

for i=4:6,
  Rcomp(i+1,:) = R(i,:);
end;

Rcomp(4,:) = VecI';
Rcomp(8,:) = VecJ';

% ----------------------- Compute t extended ----------------------
t = ((W - Rcomp*S)*Nu)/3;

% Get the desided point values.

Upos = abs(round(VecI' * S(:,4) + t(4)));
Vpos = abs(round(VecJ' * S(:,4) + t(8)));

% U(posi,posj) = Upos;
% V(posi,posj) = Vpos;







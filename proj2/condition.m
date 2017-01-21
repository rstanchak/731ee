% This function works as follows:
% Given a matrix U and the coordinates of a point P(i,j), determine if
% We can reconstruct this point (if this fn. returns 1) or not (if this
% function returns 0. note, this function does not implement any heuristic.

% This function has already been tested.

function [vfound,P,F] = condition(U,i,j)
% For us, the unknown values are -1
unknown = -1;

[m,n]=size(U);
vfound=0; P=[]; F=[];

% Get a vector of positions in which frame F is visible
A=[];
for k=1:n,
  if k ~=j & U(i,k)~=unknown
    A=[A,k];
  end
end
 
% Get a vector of features in which point P is visible
B=[];
for k=1:m,
  if k ~=i & U(k,j)~=unknown
    B=[B,k];
  end
end

lenA = size(A);
lenA = lenA(2);
lenB = size(B);
lenB = lenB(2);

% Check for the condition of reconstruction.
if lenA>=3 & lenB>=3
 for x1=1:lenB,
   bitx1 = ne(U(B(x1),A),unknown);
   for x2=x1+1:lenB,
     bitx2 = ne(U(B(x2),A),unknown);
     andx1x2=and(bitx1,bitx2);
     for x3=x2+1:lenB,
         bitx3 = ne(U(B(x3),A),unknown);
         andx1x2x3=and(andx1x2,bitx3);
         if (sum(andx1x2x3) >=3)
              vfound=1;
              F = [B(x1) B(x2) B(x3)];
              P = findPoint(A,andx1x2x3,lenA);
              return;
         end
      end
    end
 end
end     



% Auxiliar function that determines if we have found 3 points
% that satisfy the condition for reconstruction.
function [P] = findPoint(A,bitA,lenA)
 P=[];
 elemP=0;
 for i=1:lenA,
    if ne (bitA(i),0)
      elemP = elemP + 1;
      P=[P;A(i)];
      if elemP == 3
          return;
      end
    end
  end
  P=[];


    

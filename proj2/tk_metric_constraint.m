function Q = tk_metric_constraint(R)
% R is 2*F x 3
% R = [ i_1'
%       i_2'
%		...
%		j_1'
%		j_2'
%		... ];
% solve for Q ==> R = R'Q
% by imposing metric constraints on R
% i'QQ'i = 1
% j'QQ'j = 1
% i'QQ'j = 0

% let L = QQ'
% solve for L using linear lsq
% (see Morita, Kanade 1994)
% G*l=c
% L = [ l1, l2, l3 ; l2 l4 l5; l3 l5 l6 ]
% l = [ l1 .. l6 ] 
% G = [ g^T(i_1,i_1)
%       ...
%       g^T(i_F,i_F)
%       g^T(j_1,j_1)
%       ...
%       g^T(j_F,j_F)
%		g^T(i_1,j_1)
%		...
%		g^T(i_F,j_F) ];
% g(a,b) = [a1b1 2a1b2 2a1b3 a2b2 2a2b3 a3b3]
%c = [ 1 ... 1 1 ... 1 0 ... 0 ]

[m,n] = size(R);
F = m/2;

% 1. construct G
ri=1:F;
rj=F+1:2*F;
G = [ R(:,1).*R(:,1) 2*R(:,1).*R(:,2) 2*R(:,1).*R(:,3) ...
      R(:,2).*R(:,2) 2*R(:,2).*R(:,3) R(:,3).*R(:,3) ; ...
	  R(ri,1).*R(rj,1) 2*R(ri,1).*R(rj,2) 2*R(ri,1).*R(rj, 3) ...
	  R(ri,2).*R(rj,2) 2*R(ri,2).*R(rj,3) R(ri,3).*R(rj,3) ];
c = [ ones(2*F,1) ; zeros(F,1) ];

l = G\c;
	
L = [ l(1) l(2) l(3); l(2) l(4) l(5); l(3) l(5) l(6) ];

[U S V] = svd(L);

Q = U * sqrt(S);

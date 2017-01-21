% Assume we have image filenames (file1, file2) & correspondences (p1, p2)

% Read images
[I1,map1] = imread(file1); [I2,map2] = imread(file2);

% Two lists of correspondences, with 8 and >8 points
ind8 = [1:8];
ind = [1:size(p1,1)];

% Determine F by different algorithms
F8 = fmat8(p1(ind8,:),p2(ind8,:));		% 8-point
F = fmat8(p1(ind,:),p2(ind,:));			% >8-point
F8p = fmat8(p1(ind8,:),p2(ind8,:),'precond');	% 8-point, preconditioned
Fp = fmat8(p1(ind,:),p2(ind,:),'precond');	% >8-point, preconditioned

% Plot epipolar lines in each image
figure(1); e8 = plotepip(I1,I2,map1,map2,p1,p2,F8);
figure(3); e = plotepip(I1,I2,map1,map2,p1,p2,F);
figure(5); e8p = plotepip(I1,I2,map1,map2,p1,p2,F8p);
figure(7); ep = plotepip(I1,I2,map1,map2,p1,p2,Fp);

% 3D affine reconstruction: determine affine F and return M1,M2,P.
%affF = fmat8aff(p1(ind,:),p2(ind,:));		% Affine F by >8-point method
%figure(9); eaff = plotepip(I1,I2,map1,map2,p1,p2,affF);
%[M1,M2,P] = affSfM(p1,p2,affF);			% SfM with 2-view method
%[M1tk,M2tk,Ptk] = affSfMtk(p1,p2);		% SfM with Tomasi-Kanade method

% Euclidean upgrade
%[M1,M2,P] = eucl_up(M1,M2,P);
%[M1tk,M2tk,Ptk] = eucl_up(M1tk,M2tk,Ptk);

% 3D plot
%figure(100); plot3D(P); title('2-view algorithm')
%figure(101); plot3D(Ptk); title('Tomasi-Kanade algorithm');
%figure(102); plot3D(P); title('2-view algorithm (Euclidean upgrade)')
%figure(103); plot3D(Ptk); title('Tomasi-Kanade algorithm (Euclidean upgrade)');


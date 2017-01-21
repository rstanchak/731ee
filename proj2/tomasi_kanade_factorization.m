% measurement matrix
W = pts;
%W = points(:, valid);
[R_new,t_new,S_new] = factor(W);

% subtract mean of rows
t = mean(W,2);
W = W - repmat( t, [1, size(W,2)]);

% compute SVD
[U,D,V] = svd( W );

% extract first 3 singular values,vectors
U_1 = U(:,1:3);
V_1 = V(:,1:3);
S_1 = D(1:3, 1:3);
R_ = U_1*sqrt(S_1);
S_ = sqrt(S_1)*V_1';

Q = tk_metric_constraint( R_ );

R = R_*Q;
S = inv(Q)*S_;

% rotation matrix that aligns the reference frame with the canonical camera
R(img_idx,:)
R(img_idx+N,:)
r1 = R(img_idx,:);
r1 = r1/norm(r1)
r2 = R(img_idx+N,:);
r2 = r2/norm(r2)
r3 = cross(r1,r2);
r3 = r3/norm(r3);
P = [r1; r2; r3];
P = P';

R = R*P;
S = inv(P)*S;
R(img_idx,:)
R(img_idx+N,:)


% plot the shape
%figure(3);
%plot3(S(1,:), S(2,:), S(3,:), '+');

%idx = sub2ind(size(images{img_idx}), ceil(pts(img_idx+N,:)), ceil(pts(img_idx, :)));
%zi = repmat( nan, size(xgrid) );
zdata = S(3,:);
%zi = fillmiss(zi);
%[m,n] = size(images{img_idx});
%xdata =  [1 1 n n pts(img_idx,:)];
%ydata = [1 m m 1 pts(N+img_idx,:)];
%zdata = [0, 0, 0, 0, S(3,:)];
%mask = zeros(m,n);
%idx = sub2ind([m,n], ydata, xdata);
%mask(idx) = 1;
%mask(ydata,xdata) = 1;
%imagesc(mask);
xdata = S(1,:);
ydata = S(2,:);
%xdata = pts(img_idx, :);
%ydata = pts(N+img_idx, :);
%zdata = 
[m,n] = size(images{img_idx});
[xgrid,ygrid] = meshgrid( 1:n, 1:m );
xgrid = xgrid - t(img_idx);
ygrid = ygrid - t(img_idx+N);
zi = griddata( xdata, ydata, zdata, xgrid, ygrid );
%idx = find(isnan(zi));
%zi(idx)=0;
figure(1); 

%plot3(S(1,:),S(2,:),S(3,:), '*');
%surf(xgrid, ygrid, zi, 'facecolor', 'texturemap', 'cdata', images{img_idx}, 'edgecolor', 'none');
surf(xgrid, ygrid, ones(m,n), 'facecolor', 'texturemap', 'cdata', images{img_idx}, 'edgecolor', 'none');
axis ij;
t_img_idx=[t(img_idx), t(img_idx+N), 500];
for i=1:N
	figure(1);
	i
	t_f = [t(i), t(i+N), t_img_idx(3)];
	t_f = t_f-dot(t_img_idx,R(i,:))*R(i,:)-dot(t_img_idx,R(i+N,:))*R(i+N,:);
	set(gca, 'CameraPosition', t_f );
	set(gca, 'CameraUpVector', -R(i+N,:));
	-R(i+N,:)
	target = t_f - cross(R(i,:), R(i+N,:))
	set(gca, 'CameraTarget', target);
%	r_x = R(i,:);
%	r_y = R(i+N, :);
	figure(2); imagesc(images{i});
	pause(1.0);
end%for
%figure(2); mesh(xgrid, ygrid, zi); %, 'facecolor', 'texturemap', 'cdata', im1', 'edgecolor', 'none');
%axis ij;
%for i=0:5:360; view(i, -85); pause(0.25); drawnow; end
% for i=:5:-70; view(0, i); pause(0.25); drawnow; end


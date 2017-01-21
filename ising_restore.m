%Denoising of letter A: Ising Prior
 clear all
 close all
%-----------------figure defaults
disp('Denoising of A: Ising Prior')
lw = 2;
set(0, 'DefaultAxesFontSize', 16);
fs = 14;
msize = 5;
randn('state',3) %set the seeds (state) to have
rand ('state',3) %the constancy of results
% input matrix consisting of letter A. The body of letter
% A is made of 1's while the background is made of -1's.
F = imread('C:/lettera.bmp'); %or some other path...
[M,N] = size(F);
sigma = 3;
d = double(F); d= 2.*((d-mean(mean(d)))>0)-1; %d either -1 1
% The body of letter
% A is made of 1's while the background is made of -1's.
y = d + sigma*randn(size(d)); %y: noisy letter A, size of the noise is sigma!

%-----------------------------------------------
figure(1);
subplot(1,2,1);imagesc(d);set(gca,'Visible','off');colormap gray; axis square;
subplot(1,2,2);imagesc(y);set(gca,'Visible','off');colormap gray; axis square;
drawnow
J = 0.5; %Reciprocal Temperature...
theta = ones(M,N); %start with ones
iter=0;
figure(2);
subplot(1,2,1); hf = imagesc(theta); set(gca,'Visible','off');
colormap gray; axis square; drawnow;
mf = zeros(M,N);
subplot(1,2,2); hm = imagesc(mf); set(gca,'Visible','off');
colormap gray; axis square; drawnow;
SS = 10000;
misfit = [];
adj = [-1 1 0 0; 0 0 -1 1];
while (iter < 10000000)
ix = ceil( N * rand(1) ); iy = ceil( M * rand(1) );
pos = iy + M*(ix-1);
thetap = -theta(pos);
LikRat = exp(y(pos)*(thetap - theta(pos))/sigma.'2);
neighborhood = pos + [-1,1,-M,M];
neighborhood(find([iy==1,iy==M,ix==1,ix==N])) = [];
disagree = sum(theta(neighborhood)'=theta(pos));
disagreep = sum(theta(neighborhood)'=thetap);
DelLogPr = 2 * J * (disagree - disagreep);
alpha = exp(DelLogPr) * LikRat;
    if rand < alpha
         theta(pos) = thetap;
    end
iter = iter + 1;
    if rem(iter,SS) == 0,
          mf = mf+theta; NS = iter/SS; iter
          set(hf,'CData',theta);
          set(hm,'CData',mf); drawnow
          if iter/SS > length(misfit)
                 misfit = [misfit,zeros(100,1)];
                 misfit(iter/SS) = sum(sum((y-theta).'2))/sigma;
          end
     end
end


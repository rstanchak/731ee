%DRAWLINE    Draws a line through an image.
%   IMAGE=DRAWLINE(IMAGE,ORIGIN,ANGLE,VALUE) draws a line that goes
%   through ORIGIN and has an orientation ANGLE. The line extends
%   to the borders of the image, is one pixel thick, and has
%   grey-value VALUE.
%
%   IMAGE=DRAWLINE(IMAGE,ORIGIN,ANGLE,VALUE,THICKNESS) does the same,
%   using a line build out of a Gaussian profile, with sigma equal
%   to THICKNESS.

% (c) by Cris Luengo
% October 13, 1999

function image = drawline(image,origin,angle,value,thickness)

% Check imput
if nargin<5
   thickness = 0;
   if nargin<4
      value = 255;
      if nargin<3
         angle = pi/4;
         if nargin<2
            origin = [0,0];
            if nargin<1
               error('This function requires an input image')
            end
         end
      end
   end
end
if ~isnumeric(origin) | prod(size(origin))~=2
   error('ORIGIN must be a 2-component vector')
elseif ~isnumeric(angle) | prod(size(angle))~=1
   error('ANGLE must be a scalar')
elseif ~isnumeric(value) | prod(size(value))~=1
   error('VALUE must be a scalar')
elseif ~isnumeric(thickness) | prod(size(thickness))~=1
   error('THICKNESS must be a scalar')
end
image = double(image);
if ndims(image)~=2
   error('Only 2D images supported')
end

% WARNING: Angles are inverted! (y=0 is at top)
angle = -angle;
[ys,xs] = size(image);
y = origin(2);
x = origin(1);

if thickness==0
   %%% Build a line using a Gaussian profile. %%%

   % Find the leftmost pixel in the image. We do this by finding the coordinates
   % for x=1, and then moving so that y is inside the image. If that makes x
   % smaller than 1, the line doesn't intersect the image.
   if (round(x)~=1)
      r = (1-x)/cos(angle);
      x = x+r*cos(angle);
      y = y+r*sin(angle);
   end
   if (round(y)>ys)
      r = (ys-y)/sin(angle);
      x = x+r*cos(angle);
      y = y+r*sin(angle);
   elseif (round(y)<1)
      r = (1-y)/sin(angle);
      x = x+r*cos(angle);
      y = y+r*sin(angle);
   end
   if (round(x)>=1) & (round(x)<=xs)
      % This is about orientation:
      while (angle>=pi/2), angle = angle-pi; end
      while (angle<-pi/2), angle = angle+pi; end
      if (abs(angle)<(pi/4))
         xinc = 1;
         yinc = tan(angle);
      else
         xinc = 1/tan(angle);
         if (xinc>0)
            yinc = 1;
         else
            xinc = -xinc;
            yinc = -1;
         end
      end
      % Draw the line
      while 1
         image(round(y),round(x)) = value;
         x = x+xinc;
         y = y+yinc;
         if (round(x)>xs) | (round(y)>ys) | (round(x)<1) | (round(y)<1)
            break;
         end
      end
   end
else
   %%% Build a line using a Gaussian profile. %%%

   ix = 0:xs-1;
   iy = 0:ys-1;
   [ix,iy] = meshgrid(ix,iy);
   ca = cos(angle); sa = sin(angle);
   % The square distance of a point to the line, divided by the sigma.
   r2 = ((y*y + (iy-2*y).*iy)*ca*ca + (x*x + (ix-2*x).*ix)*sa*sa ...
      + 2*(x*iy + y*ix - ix.*iy - x*y)*ca*sa)/(2*thickness*thickness);
   line = zeros(size(r2));
   I = find(r2<3);
   % We only want to calculate exp for points that are worth it.
   %         Q: is there a way of doing the same for r2 ?
   line(I) = value*exp(-r2(I));
   image(I) = max(image(I),line(I));
end

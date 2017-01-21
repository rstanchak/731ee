function R = rotationAxis(a,rx,ry,rz)
    w=[0 -rz ry; rz 0 -rx;-ry rx 0];
    R=eye(3,3) + sin(a)*w + (1-cos(a))*w*w;
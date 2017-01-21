function X = restore_geman2( Y )
% degraded image Y is modeled as
% Y = phi( H(X) ) + N
% X -- uncorrupted image
% H -- smoothing function
% phi -- nonlinear transformation
% N -- independent sensor noise, model as gaussian N(mu,sigma)

% find X that maximizes P( X | Y )
% P( X | Y ) = P( Y | X ) P(X) / P(Y)

% maximizing X doesn't depend on P(Y), so
% P( X | Y ) = P( Y | X ) P(X)

% P( Y | X ) -- likelihood
% P( X ) -- prior
% both gibbsian

% = 1/Z exp( -U(w)/T )
% U(w) = sum_{cliques C} V_C(w) -- energy function
% V_C(w) -- clique potentials
% Z -- normalizing constant
% T -- Temperature 

% let V_C(f) = 1/3 

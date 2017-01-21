function labels = mrf_segment( im, p_y_x, p_x_N, p_x, max_iter, min_err )

% image model is
% Y = g(X) + N(mu, sigma)
[m, n] =size(im);

% initialize labeling X_0

% while iterations < max_iter && err > min_err
%     X' = MCNEXT(X_i-1)
%     evaluate P(X') using p(y|x), p(X|N) p(x)
%     if P(X') < P(X_i-1) or
%        rand() <= P(X')/P(X_i-1)
%        X_i=X'

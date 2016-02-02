function tmvnLL = tmvnpdf(x, mu, sigma, a, b)

% Calculated the truncated multivariate Gaussian at x = [x1, x2]
% mu is the mean
% sigma is the covariance matrix
% a is lower bound, b is upper bound

 
normalisingConstant = mvncdf(b, mu, sigma) - mvncdf(a, mu, sigma);

mvnLL = mvnpdf(x, mu, sigma);

tmvnLL = log(mvnLL/normalisingConstant);

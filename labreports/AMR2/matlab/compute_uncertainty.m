function sigma_dist = compute_uncertainty( rho, sigma_rho, alpha, height );

% sigma_dist = compute_uncertainty( rho, sigma_rho, alpha, height )
%
% Computes the error of the distance on the ground floor, given the error
% of the distance in the image plane using the camera model.


%--------------------------------------------------------------------------
sigma_dist = zeros(1, length(rho));
for i = 1:length(rho)
    sigma_dist(i) = height/alpha*(1 + tan(rho(i)/alpha)^2)*sigma_rho;
end

%--------------------------------------------------------------------------

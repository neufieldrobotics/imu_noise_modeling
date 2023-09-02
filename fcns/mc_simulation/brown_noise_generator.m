function brown_noise = brown_noise_generator(sigma, del_t)
% simulates brown noise given sigma and sampling period. 
% sigma: 3x1 vector
% del_t: scalar - sampling period. 
    [M, N] = size(sigma);
    
    % Random Walk:  Strength of noise due to sampling is
    % noise_density/sqrt(sampling_time)
    nb = sigma*randn(M,3)/sqrt(del_t); % Mx3
    
    % Initial bias
    b_0 = zeros(M,N);
    
    % Preallocate
    brown_noise = zeros(M,3);

    % Bias model with brown noise
    for i = 1:M
        if i == 1
            brown_noise(i,:) = b_0;
        else
            brown_noise(i, :) = brown_noise(i-1,:) + del_t*(nb(i,:));
        end
    end
end
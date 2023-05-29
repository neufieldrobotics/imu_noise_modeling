function pink_noise = pink_noise_generator(sigma,tau1,tau2, M, del_t)
%   pink_noise_generator creates a noise from summation of two 
% AR(1) processes. 

    % Preallocate
    np1 = randn(M,1);
    np2 = randn(M,1);
    
    % define sigma for t1 and t2
    sigma1 = sigma;
    sigma2 = sigma;
    sampling_rate = 1/del_t;
    bp1 = simulate_AR1_process(M, sampling_rate, sigma1, tau1);
    bp2 = simulate_AR1_process(M, sampling_rate, sigma2, tau2);
    pink_noise = bp1 + bp2;
end 
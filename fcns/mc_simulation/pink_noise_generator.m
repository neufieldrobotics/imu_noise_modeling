function pink_noise = pink_noise_generator(sigma,tau1,tau2, M, del_t)
%   pink_noise_generator creates a noise from summation of two 
% AR(1) processes. 

    % Preallocate
    np1 = randn(M,1);
    np2 = randn(M,1);
    
    % define sigma for t1 and t2
    sigma1 = sigma;
    sigma2 = sigma;
      
    T_c1 = tau1/1.89;
    q_c1 = sigma1/0.437/sqrt(T_c1);

    T_c2 = tau2/1.89;
    q_c2 = sigma2/0.437/sqrt(T_c2);

    % Initial bias
    b_0.acc = 0;
    b_0.gyro = 0;
    
    % Preallocate
    bp1 = zeros(M,1);
    bp2 = zeros(M,1);

    % Bias model with pink noise
    for i = 1:M
        if i == 1
            bp1(i) = b_0.acc;
            bp2(i) = b_0.acc;
        else
            bp1(i) = bp1(i-1) - del_t/T_c1*bp1(i-1) + del_t*q_c1*np1(i);
            bp2(i) = bp2(i-1) - del_t/T_c2*bp2(i-1) + del_t*q_c2*np2(i);
        end
    end

    pink_noise = bp1 + bp2;
end 
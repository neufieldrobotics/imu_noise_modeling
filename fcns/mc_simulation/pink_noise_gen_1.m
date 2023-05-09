function scaled_pink = pink_noise_gen1(sigma,tau1,tau2, M, del_t)
%     pn = dsp.ColoredNoise('pink',num_samples,3);
%     unscaled_pink = pn();
%     scaled_pink = BiasInstabilityTerm.*unscaled_pink;
    %del_t = 1/400;
    np1 = randn(M,1);
    np2 = randn(M,1);
         
    sigma1 = sigma;
      
    sigma2 = sigma;
      
    T_c1 = tau1/1.89
    q_c1 = sigma1/0.437/sqrt(T_c1)

    T_c2 = tau2/1.89
    q_c2 = sigma2/0.437/sqrt(T_c2)

    % Initial bias
    b_0.acc = 0;%imu_params.Accelerometer.b_on;
    b_0.gyro = 0;%imu_params.Gyroscope.b_on;

    % Preallocate
    bp1 = zeros(M,1);
    bp2 = zeros(M,1);

    % Bias model with brown and pink noise
    for i = 1:M
        if i == 1
            bp1(i) = b_0.acc;
            bp2(i) = b_0.acc;
        else
            bp1(i) = bp1(i-1) - del_t/T_c1*bp1(i-1) + del_t*q_c1*np1(i);
            bp2(i) = bp2(i-1) - del_t/T_c2*bp2(i-1) + del_t*q_c2*np2(i);
        end
    end

    scaled_pink = bp1 + bp2;
end 
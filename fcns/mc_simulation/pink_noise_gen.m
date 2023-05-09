function scaled_pink = pink_noise_gen(bias_instability_parameter,factor,tau1,tau2, M, del_t)
%     pn = dsp.ColoredNoise('pink',num_samples,3);
%     unscaled_pink = pn();
%     scaled_pink = BiasInstabilityTerm.*unscaled_pink;
    %del_t = 1/400;
    np1 = randn(M,1);
    np2 = randn(M,1);
   
%     global axis type factor sensor_name
%     if strcmp(sensor_name,'xsens')
%         tau1 = 25;
%         tau2 = 150;
%         B_acc = [6.8e-4, 5.78e-4, 4.99e-4]; 
%         B_gyro = [1.19e-4, 1.6e-4, 1.65e-4];
%     elseif strcmp(sensor_name,'vn100')
%         tau1 = 2.5;
%         tau2 = 50;
%         B_gyro = [3.06e-5, 8.03e-5, 7.00e-5];
%         B_acc = [9.32e-4, 3.65e-4, 4.89e-4]; 
%     end
    
%     if strcmp(type,'g')
%         B_ = B_gyro;
%     elseif strcmp(type,'a')
%         B_ = B_acc;
%     end
%    
%     B = B_(axis)
      
    sigma1 = factor*0.664*bias_instability_parameter;
      
    sigma2 = factor*0.664*bias_instability_parameter;
      
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

%XSENSE: Un-comment the corresponding sigma depending on which 
    % axis of which sensor you are using. tau1 and tau2 on the next two lines
    % should work well for all XSENSE axes, gyro and accel

    %tau1 = 25;
    %tau2 = 150;

    % ACC X:
    %sigma = 5.75e-3;
    % ACC Y:
    %sigma = 4.8e-3;
    % ACC Z:
    %sigma = 4.3e-3;
    % GYRO X:
    %sigma = 1e-3;
    % GYRO Y:
    %sigma = 1.2e-3;
    % GYRO Z:
    %sigma = 1.2e-3;
%         sigma1 = sigma;
%     tau2 = 50;
%     sigma2 = sigma;
%     np1 = randn(M,1);
%     np2 = randn(M,1);
    %-------------------------

    % Comment out tau1 and tau2 below if modeling XSENSE
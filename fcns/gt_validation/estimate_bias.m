function estimate_bias(gt_optitrack,... %world
                       imu_acc_measurements,... %body/world
                       freq,... % the number of samples after which we compute bias
                       t_0,...
                       t_i)
    % gt_optitrack: Nx8 (t,x,y,z,qx,qy,qz,qw)
    % imu_acc_measurements: Mx4 (t,x,y,z)
    % get imu_measurements from t_0 to t_i sampled at freq. 
    
    N = (t_i-t_0)*sample_rate/freq;
    sampled_t = zeros(N);
    sampled_acc_measurements = zeros(N,3);
    sampled_optitrack_measurements = zeros(N,3);
    sampled_indices_acc = zeros(N,1);
    
    % Subsample the measurements for bias estimation
    for index = 1:N 
        sampled_t(index) = imu_acc_measurements(index*freq,1);
        sampled_indices_acc(index) = index*freq;
        sampled_acc_measurements(index) =  imu_acc_measurements(index*freq,2:4);
        timestamp_index = gt_optitrack(:,1) > sampled_t(index);
        sampled_optitrack_measurements = gt_optitrack(index*freq,2:end); % this needs to be corrected
    end
    
    b_a = zeros(size(sampled_acc_measurements));
    options = optimoptions('fminunc','Algorithm',...
                        'trust-region',...
                        'SpecifyObjectiveGradient',true);

    problem.options = options;
    problem.x0 = b_a;
    problem.objective = @(b_a)error_objective(b_a,...
                                              imu_acc_measurements,...
                                              sampled_optitrack_measurements,...
                                              sampled_acc_measurements,...
                                              sampled_t,...
                                              sampled_indices_acc,...
                                              freq);
    problem.solver = 'fminunc';
    x = fminunc(problem); 
end
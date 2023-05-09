function error = error_objective(b_a,...
                                 imu_acc_measurements,...
                                 sampled_optitrack_measurements,...
                                 sampled_acc_measurements,...
                                 sampled_t,...
                                 sampled_indices_acc,...
                                 freq)
    % ERROR_OBJECTIVE function that computes the total error from 
    % individual measurements of optitrack measurements and imu dead-reckoning 
    % position estimate, given the biases. This error function should be 
    % minimized to compute the biases. It is a minimum norm problem

    % N : Number of aligned measurements
    % optitrack_position : Nx3 matrix
    % imu_position_est : Nx3 matrix 
    % b_a : Nx3 matrix
    b = zeros(size(imu_acc_measurements(:,2:4)));
    m_model = IMU_Model;
    sampling_rate = 400;
    del_t = 1/sampling_rate;
    time_vector = imu_acc_measurements(:,1);
    imu_position_displacements_est = zeros(length(sampled_t),3);
    for i = 1:length(sampled_t)
        % Estimate position
        time = sampled_t(i);
        p_w_0 = zeros(3,1);
        v_w_0 = zeros(3,1);
        tspan = [0,time];
        ic = [v_w_0;...        % start velocity 
              p_w_0];
        opts = odeset('RelTol',1e-2,...
                  'AbsTol',1e-4,...
                  'MaxStep',del_t,...
                  'Stats','on',...
                  'OutputFcn',[]);
        display_initial_conditions(ic);
        pause(.5);
   
        % Odometry using sampled measurements of stationary data 
        % corrupted with white noise. The imu model that is used is 
        % ideal IMU model. The dead-reckoning (odometry) solution will
        % show us the effect of white noise on IMU integration
        
        %% for bias vector 
        loc = sampled_indices(index);
        b(1:loc,1) = b_a(index,1); % column vector
        b(1:loc,2) = b_a(index,2); % column vector
        b(1:loc,3) = b_a(index,3); % column vector
        
        [t1,X1] = ode45(@(t1,X1) m_model.imu_odometry_model_rpy(t1,...
                                                       X1,...
                                                       imu_acc_measurements(:,2:4)-b,...
                                                       sampled_gt_quat_measurements,...
                                                       time_vector,...
                                                       loc),...
                                                       tspan,...
                                                       ic(1:6),...
                                                       opts);
       imu_position_displacements_est(i,:) = X(end,:);    
    end
    
    e_x = sampled_optitrack_measurements(:,1) - imu_position_displacements_est(:,1);
    e_y = sampled_optitrack_measurements(:,2) - imu_position_displacements_est(:,2);
    e_z = sampled_optitrack_measurements(:,3) - imu_position_displacements_est(:,3);
    error = sum(e_x.^2) + sum(e_y.^2) + sum(e_z.^2);
end


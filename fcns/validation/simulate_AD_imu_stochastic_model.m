function AD_curve = simulate_AD_imu_stochastic_model(stochastic_model_case,paths)
    global axis type
    imu_parameter_file = strcat('sim_test_imu_',stochastic_model_case,'.yaml');
    imu_parameter_filepath = fullfile(paths.imu_parameter_folder,imu_parameter_file);
    imu_Params = YAML.read(imu_parameter_filepath);
    Sim_Params = YAML.read(paths.sim_parameter_filepath);
    Sim_Params.TotalTime =5*60*60;
    m = 2.^(3:18);
    [AD_curve.theoretical.adev,AD_curve.theoretical.tau] = compute_theoretical_AD_curve_1(imu_Params);
    
    % With model p ; first column stores the non-matlab model
    Sim_Params.model_type = 'p';
    [t,accel_readings,gyro_readings,nw,b] = simulate_imu_motion(imu_Params,...
                                                             Sim_Params);
    if strcmp(type,'a')
        [avar,AD_curve.stochastic_model.tau] = allanvar(accel_readings(:,axis),m,Sim_Params.SamplingRate);
    elseif strcmp(type,'g')
        [avar,AD_curve.stochastic_model.tau] = allanvar(gyro_readings(:,axis),m,Sim_Params.SamplingRate);
    end
    
    AD_curve.stochastic_model.adev = sqrt(avar);
    AD_curve.comment = stochastic_model_case;
end

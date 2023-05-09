clear
global total_runs
script_paths;
config_MC_sim_p_senstivity;
%% Normal acceleration simulation with pink noise only
montecarlo_simulations(mc_sim_params,...
                       1,...
                       mc_sim_params.filepath.save_path.acc{1},...
                       "accelerometer")

%% Acceleration simulation with pink noise and tau1 shifted
delta_shift = 40;
mc_sim_params_tau_shifted = mc_sim_params
for i = 1:3 
    tau_i = mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau1(i);
    tau_f = mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau2(i);
    mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau1(i) = tau_i + delta_shift
    mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau2(i) = tau_f + delta_shift
end
montecarlo_simulations(mc_sim_params_tau_shifted,...
                       1,...
                       mc_sim_params_tau_shifted.filepath.save_path.acc{2},...
                       "accelerometer")

%% Acceleration simulation with pink noise and tau range shifted
tau_range = 100;
mc_sim_params_tau_range_extended = mc_sim_params
for i = 1:3 
    tau_i = mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau1(i);
    mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau2(i) = tau_i + tau_range
end
montecarlo_simulations(mc_sim_params_tau_range_extended,...
                       1,...
                       mc_sim_params_tau_range_extended.filepath.save_path.acc{3},...
                       "accelerometer")

%% Acceleration simulation with sigma doubled
factor = 2;
mc_sim_params_sigma_changed = mc_sim_params
for i = 1:3 
    sigma = mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.sigma(i);
    mc_sim_params_sigma_changed.imu_params{1}.Accelerometer.sigma(i) = factor*sigma
end
montecarlo_simulations(mc_sim_params_sigma_changed,...
                       1,...
                       mc_sim_params_sigma_changed.filepath.save_path.acc{4},...
                       "accelerometer")                   


%% Gyroscope simulation with sigma doubled
factor = 2;
mc_sim_params_sigma_changed = mc_sim_params
for i = 1:3 
    sigma = mc_sim_params_tau_shifted.imu_params{2}.Accelerometer.sigma(i);
    mc_sim_params_sigma_changed.imu_params{2}.Accelerometer.sigma(i) = factor*sigma
end
montecarlo_simulations(mc_sim_params_sigma_changed,...
                       index,...
                       mc_sim_params_sigma_changed.filepath.save_path.gyro{3},...
                       "gyroscope")                   

function montecarlo_simulations(mc_sim_params, index, save_path, comment_attribute)
    % montecarlo simulations performs N runs of simulations with 
    % given imu_params and sim_params, 

    for run=1:mc_sim_params.total_runs
        disp(' Gyroscope Run number = ');
        disp(run);
        mc_sim_run_data = dead_reckoning_noise_model(mc_sim_params.imu_params{index},...
                                                     mc_sim_params.sim_params);
        mc_sim_run_data.doc.comment = strcat(comment_attribute,...
                                             "pink noise simulation",...
                                             " Run - ",...
                                             num2str(run));
        mc_sim_run_data.doc.order = "x y z";
        mc_sim_run_data.doc.noise_params = mc_sim_params.imu_params;
        append_header_to_MC_data;
        save(strcat(save_path, ...
                    '_',...
                    num2str(run),...
                    '.mat'),...
                    'mc_sim_run_data');
    end
end
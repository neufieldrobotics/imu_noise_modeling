clear
global total_runs
script_paths;
config_MC_sim_p_senstivity;

%% Acceleration simulation with pink noise and tau1 shifted
disp("Performing configuration for other situations")
disp("-----Original pink noise parameters:-----")
disp(mc_sim_params.imu_params{1}.Accelerometer)

%% Tau shifted noise parameters
delta_shift = 40;
mc_sim_params_tau_shifted = mc_sim_params;
for i = 1:3 
    tau_i = mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau1(i);
    tau_f = mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau2(i);
    mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau1(i) = tau_i + delta_shift;
    mc_sim_params_tau_shifted.imu_params{1}.Accelerometer.tau2(i) = tau_f + delta_shift;
end
disp("------Tau shifted pink noise parameters:-----")
disp(mc_sim_params_tau_shifted.imu_params{1}.Accelerometer);
pause(2);

%% Acceleration simulation with pink noise and tau range shifted
tau_range = 100;
mc_sim_params_tau_range_extended = mc_sim_params;
for i = 1:3 
    tau_i = mc_sim_params_tau_range_extended.imu_params{1}.Accelerometer.tau1(i);
    mc_sim_params_tau_range_extended.imu_params{1}.Accelerometer.tau2(i) = tau_i + tau_range;
end
disp("-----Tau range changed:----")
disp(mc_sim_params_tau_range_extended.imu_params{1}.Accelerometer);
pause(2);


%% Acceleration simulation with sigma doubled
factor = 2;
mc_sim_params_sigma_changed = mc_sim_params;
for i = 1:3 
    
    sigma = mc_sim_params_sigma_changed.imu_params{1}.Accelerometer.sigma(i);
    mc_sim_params_sigma_changed.imu_params{1}.Accelerometer.sigma(i) = factor*sigma;
end
disp("----- sigma_b doubled----")
disp(mc_sim_params_sigma_changed.imu_params{1}.Accelerometer);
pause(2);
                   

%% Perform montecarlo simulations

% Normal acceleration simulation with pink noise only
montecarlo_simulations(mc_sim_params,...
                       "accelerometer",...
                       mc_sim_params.filepath.save_path.acc{1})
% tau shifted
montecarlo_simulations(mc_sim_params_tau_shifted,...
                       "accelerometer",...
                       mc_sim_params_tau_shifted.filepath.save_path.acc{2})
                   
% tau range extended      
montecarlo_simulations(mc_sim_params_tau_range_extended,...
                       "accelerometer",...
                       mc_sim_params_tau_range_extended.filepath.save_path.acc{3})

% sigma doubled
montecarlo_simulations(mc_sim_params_sigma_changed,...
                       "accelerometer",...
                       mc_sim_params_sigma_changed.filepath.save_path.acc{4})
                   
function montecarlo_simulations(mc_sim_params, comment_attribute, save_path)
    % montecarlo simulations performs N runs of simulations with 
    % given imu_params and sim_params, 
    try 
        index = 0;
        if strcmp(comment_attribute, "accelerometer")
            index = 1;
        elseif strcmp(comment_attribute, "gyroscope")
            index = 2;
        elseif strcmp(comment_attribute, "accelerometer_gyroscope")
            index = 3;
        else 
            error("Invalid selection of file parameters")
        end
    
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
    catch
        disp("Invalid selection of file parameters. Index parameter is wrong")
    end
end
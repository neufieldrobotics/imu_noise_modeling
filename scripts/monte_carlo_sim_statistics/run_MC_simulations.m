% runs Montecarlo simulations for the different configuration stored in
% config_simulations folder

% Author: Jagatpreet
% Date created: 13/07/2021 
%
if integration_model.ideal_imu_euler == 1
    ideal_imu_dead_reckoning_euler;
    save('simulation_results/ideal_imu_ideal_model_dead_reckoning_euler.mat');
end

if integration_model.ideal_imu_rk == 1
    ideal_imu_dead_reckoning_rk;
    save('simulation_results/ideal_imu_ideal_model_dead_reckoning_rk.mat');
end

if integration_model.dead_reckoning_noise_model == 1
    if simulation_case.w_acc == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_w_acc.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'w_acc',...
                                    '.mat');
        [sim_averages(1),sim_sigma(1)] = run_simulation(filepath);
    end

    if simulation_case.b_acc == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_b_acc.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'b_acc',...
                                    '.mat');
        [sim_averages(2),sim_sigma(2)] = run_simulation(filepath);
    end

    if simulation_case.p_acc == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_p_acc.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'p_acc',...
                                    '.mat');
        [sim_averages(3),sim_sigma(3)] = run_simulation(filepath);
    end


    if simulation_case.w_gyro == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_w_gyro.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'w_gyro',...
                                    '.mat');
        [sim_averages(4),sim_sigma(4)] = run_simulation(filepath);
    end


    if simulation_case.b_gyro == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_b_gyro.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'b_gyro',...
                                    '.mat');
        [sim_averages(5),sim_sigma(5)] = run_simulation(filepath);
    end


    if simulation_case.p_gyro == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_p_gyro.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'p_gyro',...
                                    '.mat');
        [sim_averages(6),sim_sigma(6)] = run_simulation(filepath);
    end


    if simulation_case.wb_acc == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_wb_acc.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'wb_acc',...
                                    '.mat');
        [sim_averages(7),sim_sigma(7)] = run_simulation(filepath);
    end


    if simulation_case.wb_acc_gyro == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_wb_acc_gyro.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'wb_acc_gyro',...
                                    '.mat');
        [sim_averages(8),sim_sigma(8)] = run_simulation(filepath);
    end


    if simulation_case.wbp_acc == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_wbp_acc.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'wbp_acc',...
                                    '.mat');
        [sim_averages(9),sim_sigma(9)] = run_simulation(filepath);
    end

    if simulation_case.wbp_acc_gyro == 1
        filepath.imu_model = 'IMU_params/test_imu_models/sim_test_imu_wbp_acc_gyro.yaml';
        filepath.save_path = strcat(savefolder,'dead_reckoning_',...
                                    num2str(total_runs),'_runs_',...
                                    'wbp_acc_gyro',...
                                    '.mat');
        [sim_averages(10),sim_sigma(10)] = run_simulation(filepath);
    end  
end

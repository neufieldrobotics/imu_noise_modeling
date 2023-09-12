clear 
close all;

%% config for reading and saving data.
root_folder = fullfile("/media/jagatpreet/Data/datasets/",...
                       "imu_modeling_paper/",...
                       "2021_MC_sim_IMU_simulation_model/",...
                       "simulation_results/");
sensor_data_folder_name = "VOXL_IMU0_mean_parameters";
simulation_folder_names = struct("stationary_imu_w_acc_100s", 1,...
                                "stationary_imu_b_acc_100s", 1,...
                                "stationary_imu_p_acc_100s", 1,...
                                "stationary_imu_w_gyro_100s", 1,...
                                "stationary_imu_b_gyro_100s", 1,...
                                "stationary_imu_p_gyro_100s", 1,...
                                "stationary_imu_wb_acc_100s", 1,...
                                "stationary_imu_wbp_acc_100s", 1,...
                                "stationary_imu_wb_gyro_100s", 1,...
                                "stationary_imu_wb_acc_gyro_100s", 1,...
                                "stationary_imu_wbp_acc_gyro_100s", 1);
suffix = 0;                           
simulation_folder_name = '';
flds = fields(simulation_folder_names);             
for i = 1:length(flds)
    f = flds(i);
    if simulation_folder_names.(f{1}) == 1
        simulation_folder_name = f{1};
        save_folder_name = "mc_sim_stats";
        N_acc_files = 100;
        N_gyro_files = 100;
        log_path = fullfile(root_folder,...
                            sensor_data_folder_name,...
                            simulation_folder_name);

        save_folder = fullfile(root_folder,...
                               sensor_data_folder_name,...
                               save_folder_name);

        if suffix
            save_filename.acc = strcat(save_folder_name,"_",...
                                   simulation_folder_name,"_",...
                                   "acc");

            save_filename.gyro = strcat(save_folder_name,"_",...
                                    simulation_folder_name,"_",...
                                    "gyro");
        else
            save_filename.acc = strcat(save_folder_name,"_",...
                                   simulation_folder_name);

            save_filename.gyro = strcat(save_folder_name,"_",...
                                    simulation_folder_name);
        end
        
        filenames = sort_filenames_natural_order(log_path,".mat");
        disp("---------------------------------")
        sprintf("Total filenames read from the log path: %d", length(filenames));

        %% Process files acclerometer
        files_to_process = filenames(1:N_acc_files); % accelerometer simulation
        % generate struct from the simulation files.
        monte_carlo_sim_struct = gen_MC_sim_struct_from_files(log_path,files_to_process);
        % get statistics of the simulation
        [mc_sim_stats.sim_averages,mc_sim_stats.sim_sigmas] = process_MC_sim_data(monte_carlo_sim_struct);
        mc_sim_stats.t = monte_carlo_sim_struct.t;
        mc_sim_stats.doc = strcat("stats: ",simulation_folder_name," accelerometer");

        % Save files
        if exist(save_folder,'dir') && length(dir(save_folder)) > 2
            save(fullfile(save_folder,save_filename.acc),'mc_sim_stats');
        else
            mkdir(save_folder);
            save(fullfile(save_folder,save_filename.acc),'mc_sim_stats');
        end

    %% process files gyroscope

        if length(filenames) > N_acc_files    
            total = N_acc_files+N_gyro_files;
            files_to_process = filenames(N_acc_files+1:total); % gyroscope simulation
            monte_carlo_sim_struct = gen_MC_sim_struct_from_files(log_path,files_to_process);
            [mc_sim_stats.sim_averages,mc_sim_stats.sim_sigmas] = process_MC_sim_data(monte_carlo_sim_struct);
            mc_sim_stats.t = monte_carlo_sim_struct.t;
            mc_sim_stats.doc = strcat("stats: ",simulation_folder_name," gyroscope");

            %% Save files
            if exist(save_folder_name,'dir') && length(dir(save_folder_name)) > 2
                save(fullfile(save_folder_name,save_filename.gyro),'mc_sim_stats');
            else
                mkdir(save_folder_name);
                save(fullfile(save_folder_name,save_filename.gyro),'mc_sim_stats');
            end
        end
    end
end
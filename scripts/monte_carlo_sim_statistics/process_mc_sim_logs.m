clear 
close all;

%% Set data read and write paths
simulation_folder = "stationary_wbp_ag_voxl_imu0_100s";
% log_path = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
%                      "2021_MC_sim_IMU_simulation_model/VN100_experimental_params_MC_sim",....
%                       simulation_folder);
% save_folder = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
%                      "2021_MC_sim_IMU_simulation_model",...
%                      "mc_sim_stats");
log_path = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
                     "2021_MC_sim_IMU_simulation_model/VN100_experimental_params_MC_sim",....
                      simulation_folder);
save_folder = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
                     "2021_MC_sim_IMU_simulation_model/VN100_experimental_params_MC_sim",...
                     "mc_sim_stats");
save_filename.acc = strcat("mc_sim_stats","_",simulation_folder,"_","acc");
save_filename.gyro = strcat("mc_sim_stats","_",simulation_folder,"_","gyro");

%% Process files acclerometer
filenames = sort_filenames_natural_order(log_path,".mat");
files_to_process = filenames(1:100); % accelerometer simulation

monte_carlo_sim_struct = gen_MC_sim_struct_from_files(log_path,files_to_process);
[mc_sim_stats.sim_averages,mc_sim_stats.sim_sigmas] = process_MC_sim_data(monte_carlo_sim_struct);
mc_sim_stats.t = monte_carlo_sim_struct.t;
mc_sim_stats.doc = strcat("stats: ",simulation_folder," accelerometer");

% Save files
if exist(save_folder,'dir') && length(dir(save_folder)) > 2
    save(fullfile(save_folder,save_filename.acc),'mc_sim_stats');
else
    mkdir(save_folder);
    save(fullfile(save_folder,save_filename.acc),'mc_sim_stats');
end

%% process files gyroscope

if length(filenames) > 100    
    files_to_process = filenames(101:200); % accelerometer simulation

    monte_carlo_sim_struct = gen_MC_sim_struct_from_files(log_path,files_to_process);
    [mc_sim_stats.sim_averages,mc_sim_stats.sim_sigmas] = process_MC_sim_data(monte_carlo_sim_struct);
    mc_sim_stats.t = monte_carlo_sim_struct.t;
    mc_sim_stats.doc = strcat("stats: ",simulation_folder," gyroscope");

    %% Save files
    if exist(save_folder,'dir') && length(dir(save_folder)) > 2
        save(fullfile(save_folder,save_filename.gyro),'mc_sim_stats');
    else
        mkdir(save_folder);
        save(fullfile(save_folder,save_filename.gyro),'mc_sim_stats');
    end
end
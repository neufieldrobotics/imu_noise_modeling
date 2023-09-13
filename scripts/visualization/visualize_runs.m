% Visualize Montecarlo simulation's each run in a 2d and 3D plot.
% @author : Jagatpreet
% Northeastern University
% Date created: Sep 9, 2023

clc
clear all
close all

%% config for paths and queries
root_folder = fullfile("/media/jagatpreet/Data/datasets/",...
                       "imu_modeling_paper/",...
                       "2021_MC_sim_IMU_simulation_model/",...
                       "simulation_results/");
sensor_data_folder_name = "vn100";
simulation_folder_name = "stationary_wbp_ag_100s";

total_files = 200;

% Many times the folder has both accelerometer and gyroscope simulation
% data.
if total_files == 200
    N_acc_files = 100;
    N_gyro_files = 100;
end

%% File search using query
sim_dir = fullfile(root_folder,...
                   sensor_data_folder_name,...
                   simulation_folder_name);
filenames = sort_filenames_natural_order(sim_dir,".mat");

if ~ isempty(filenames)
    sprintf("Data is present - %d runs are logged. Proceeding to plot", ...
        length(filenames));
end


if total_files <= 100
    disp("Only single type of simulation is done. Processing and storing");
    files_to_process = filenames(1:total_files); % accelerometer simulaend
else
    files_to_process = filenames(1:N_acc_files); % accelerometer simula
end

%% Accelerometer
monte_carlo_sim_struct = gen_MC_sim_struct_from_files(sim_dir,files_to_process);
plot_mc_sim_runs(monte_carlo_sim_struct, strcat(simulation_folder_name, "accelerometer"));
visualize_mc_sim_3d(monte_carlo_sim_struct);

%% Gyroscope
if length(filenames) > N_acc_files
    files_to_process = filenames(N_acc_files:end); % gyroscope simulation
    monte_carlo_sim_struct = gen_MC_sim_struct_from_files(sim_dir,files_to_process);
    h = plot_mc_sim_runs(monte_carlo_sim_struct,strcat(simulation_folder_name, "gyroscope"));
end






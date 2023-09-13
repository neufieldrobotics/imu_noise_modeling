clear
close all;

%% get statistics files
%"mc_sim_stats_stationary_inflated_white_100s_acc",...
close all

mean_parameter_analysis = 1;
sensor_name_1 = "vn100";
sensor_name_2 = "voxl_imu0";
if mean_parameter_analysis==1
    sim_dir_1 = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
        "2021_MC_sim_IMU_simulation_model/",...
        "simulation_results",...
        strcat(sensor_name_1,"_mean_parameters"));
    sim_dir_2 = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
        "2021_MC_sim_IMU_simulation_model/",...
        "simulation_results",...
        strcat(sensor_name_2,"_mean_parameters"));
else
    sim_dir_1 = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
        "2021_MC_sim_IMU_simulation_model/",...
        "simulation_results",...
        sensor_name_1);
    sim_dir_2 = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
        "2021_MC_sim_IMU_simulation_model/",...
        "simulation_results",...
         sensor_name_2);
end


stats_dir = 'mc_sim_stats';
% model.filenames = ["mc_sim_stats_stationary_wbp_100s_acc.mat",...
%                   "mc_sim_stats_stationary_wbp_100s_gyro.mat"];
model.filenames = ["mc_sim_stats_stationary_imu_wb_acc_100s.mat",...
                  "mc_sim_stats_stationary_imu_wb_gyro_100s.mat"];              
              
%% Load
vn100.acc = load(fullfile(sim_dir_1,stats_dir,model.filenames(1)), 'mc_sim_stats');
vn100.gyro = load(fullfile(sim_dir_1,stats_dir,model.filenames(2)), 'mc_sim_stats');

voxl_imu0.acc = load(fullfile(sim_dir_2,stats_dir,model.filenames(1)), 'mc_sim_stats');
voxl_imu0.gyro = load(fullfile(sim_dir_2,stats_dir,model.filenames(2)), 'mc_sim_stats');
t = [ .1, 0.5, 1, 2.5, 5, 7.5, 10, 15, 20, 30, 40];
time_index_list = zeros(length(t),1);
for i = 1:length(t)
    indices = find(vn100.acc.mc_sim_stats.t <= t(i));
    time_index_list(i) = indices(end);
end

value_sigma_acc = vn100.acc.mc_sim_stats.sim_sigmas.p(time_index_list,:);
value_sigma_gyro = vn100.gyro.mc_sim_stats.sim_sigmas.p(time_index_list,:);

contribution_1 = zeros(length(t), 2);
for i = 1:length(t)
    contribution_1(i, :) = [norm(value_sigma_acc(i,:)),...
                          norm(value_sigma_gyro(i,:))];
end

value_sigma_acc = voxl_imu0.acc.mc_sim_stats.sim_sigmas.p(time_index_list,:);
value_sigma_gyro = voxl_imu0.gyro.mc_sim_stats.sim_sigmas.p(time_index_list,:);

contribution_2 = zeros(length(t), 2);
for i = 1:length(t)
    contribution_2(i, :) = [norm(value_sigma_acc(i,:)),...
                          norm(value_sigma_gyro(i,:))];
end

X = categorical(["0.1s", "0.5s", "1s", "2.5s", "5s", "7.5s", "10s", "15s", "20s", "30s", "40s"])
X = reordercats(X,["0.1s", "0.5s", "1s", "2.5s", "5s", "7.5s", "10s", "15s", "20s", "30s", "40s"]);
b1 = bar(X, contribution_1,'stacked');
xlabel('Time(s)', 'FontSize', 18);
ylabel('Position Error (m)', 'FontSize', 18);
legend('accelerometer error', 'gyroscope error','FontSize', 18)
grid on
h = gca;
h.FontSize = 18;
ylim([0,10]);
title(strcat("VN100 - proportion of position error"));

figure()
b2 = bar(X, contribution_2,'stacked');
legend('accelerometer error', 'gyroscope error')
xlabel('Time(s)', 'FontSize', 18);
ylabel('Position Error (m)', 'FontSize', 18);
legend('accelerometer error', 'gyroscope error','FontSize', 18)
ylim([0,10]);
h = gca;
h.FontSize = 18;
grid on;
title(strcat("XSENS - proportion of position error"));
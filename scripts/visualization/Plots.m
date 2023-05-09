clear
close all;

%% set up folder paths and files
query = "stationary_wbp_ag_vn100_1_100s*";
% sim_dir = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
%     "20221_voxl_imu_MC_sim");
sim_dir = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
    "2021_MC_sim_IMU_simulation_model/VN100_experimental_params_MC_sim");

mc_sim_folder_query = fullfile(sim_dir,query);
mc_sim_dirs = dir(mc_sim_folder_query);
i = 1;
log_path = fullfile(sim_dir,mc_sim_dirs(i).name);
filenames = sort_filenames_natural_order(log_path,".mat");
files_to_process = filenames(1:100); % accelerometer simulation
monte_carlo_sim_struct = gen_MC_sim_struct_from_files(log_path,files_to_process);
plot_mc_sim_runs(monte_carlo_sim_struct, strcat(mc_sim_dirs(i).name, " accelerometer"));

if length(filenames) > 100
    files_to_process = filenames(101:200); % gyroscope simulation
    monte_carlo_sim_struct = gen_MC_sim_struct_from_files(log_path,files_to_process);
    h = plot_mc_sim_runs(monte_carlo_sim_struct,strcat(mc_sim_dirs(i).name, " gyroscope"));
end




%% get statistics files
%"mc_sim_stats_stationary_inflated_white_100s_acc",...
close all
sim_dir = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
     "2021_MC_sim_IMU_simulation_model/VN100_experimental_params_MC_sim");

type = 'vn100_vs_voxl_imu0'; % a, g, a-combined, g-combined, a-g, xsens_vs_vn100

if strcmp(type,'a')
    model.queries = ["mc_sim_stats_stationary_brown_100s_acc",...
                        "mc_sim_stats_stationary_pink_100s_acc",...
                        "mc_sim_stats_stationary_white_100s_acc"];
    model.legends = ["brown","pink","white"];
    model.comment = "Accelerometer - individual contribution"; 
elseif strcmp(type,'g')
    model.queries = ["mc_sim_stats_stationary_brown_100s_gyro",...
                        "mc_sim_stats_stationary_pink_100s_gyro",...
                        "mc_sim_stats_stationary_white_100s_gyro"];
    model.legends = ["brown","pink","white"];
    model.comment = "Gyroscope - individual contribution"; 
elseif strcmp(type,'a-combined')
    model.queries = ["mc_sim_stats_stationary_wb_100s_acc",...
                        "mc_sim_stats_stationary_wbp_100s_acc"];
    model.legends = ["white-brown","white-brown-pink"];
    model.comment = "Accelerometer - combined model";
elseif strcmp(type,'g-combined')
    model.queries = ["mc_sim_stats_stationary_wb_100s_gyro",...
                     "mc_sim_stats_stationary_wbp_100s_gyro"];
    model.legends = ["white-brown","white-brown-pink"];
    model.comment = "Gyroscope only - combined model";
elseif strcmp(type,'a-g')
    model.queries = ["mc_sim_stats_stationary_wb_ag_100s",...
                    "mc_sim_stats_stationary_wbp_ag_100s"];
    model.legends = ["white-brown","white-brown-pink"];
    model.comment = "Accelerometer - Gyroscope noise model";
elseif strcmp(type,'xsens_vs_vn100')
    model.queries = ["mc_sim_stats_stationary_wbp_ag_100s",...
                    "mc_sim_stats_stationary_wbp_ag_xsens_100s"];
    model.legends = ["vn100","xsens"];
    model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
elseif strcmp(type,'vn100_vs_voxl_imu0')
    model.queries = ["mc_sim_stats_stationary_wbp_ag_vn100_1",...
                    "mc_sim_stats_stationary_wbp_ag_voxl_imu0"];
    model.legends = ["vn100","voxl_imu0"];
    model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
end


% set stat folder path
query = "*stats*";
mc_sim_folder_query = fullfile(sim_dir,query);
mc_sim_dirs = dir(mc_sim_folder_query); 
mc_sim_stat_path = fullfile(sim_dir,mc_sim_dirs.name);

for i=1:length(model.queries)
    files{i} = dir(fullfile(mc_sim_stat_path,strcat('*',...
                        model.queries(i),'*')));
end

%% plot stats
for i = 1:length(files)
    load(fullfile(mc_sim_stat_path,files{i}.name),'mc_sim_stats');
    [folder,name,ext] = fileparts(fullfile(mc_sim_stat_path,files{i}.name)); 
    hdrs{i} = model.legends(i);
    sim_averages_hdrs(i) = mc_sim_stats.sim_averages;
    sim_sigmas_hdrs(i) = mc_sim_stats.sim_sigmas;
    t{i} = mc_sim_stats.t;
end
plot_mc_stats(hdrs,model.comment,t,sim_averages_hdrs,sim_sigmas_hdrs);
% filename = 'dead_reckoning_30_runs_b_acc.mat';
% dead_reckoning_results_path = fullfile(folder,filename);
% load(dead_reckoning_results_path);

% %% Mean and standard deviation plots
% simulation_case = struct('w_acc',1,... %1
%                          'b_acc',1,... %2
%                          'p_acc',1,... %3
%                          'w_gyro',1,...%4
%                          'b_gyro',1,...%5
%                          'p_gyro',1,...%6
%                          'wb_acc',1,...%7
%                          'wb_acc_gyro',1,...%8
%                          'wbp_acc',1,...%9
%                          'wbp_acc_gyro',1); %10
% 
% f = fieldnames(simulation_case);
% 
% if length(sim_averages)<=3
% % Accelerometer stationary only
%     plot_stats(f(1:3),t,sim_averages(1:3),sim_sigma(1:3)); 
% end
% 
% % Gyroscope stationary only
% if length(sim_averages)>3 && length(sim_averages)<=6
%     plot_stats(f(4:6),t,sim_averages(4:6),sim_sigma(4:6));
% end
% 
% % Accelerometer and Gyroscope only
% if length(sim_averages)>7 && length(sim_averages)<=10
%     plot_stats(f(7:10),t,sim_averages(7:10),sim_sigma(7:10));
% end


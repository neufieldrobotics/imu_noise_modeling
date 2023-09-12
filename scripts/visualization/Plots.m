clear
close all;

%% get statistics files
%"mc_sim_stats_stationary_inflated_white_100s_acc",...
close all

mean_parameter_analysis = 1;
sensor_name = "vn100";
if mean_parameter_analysis==1
    sim_dir = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
        "2021_MC_sim_IMU_simulation_model/",...
        "simulation_results",...
        strcat(sensor_name,"_mean_parameters"));
else
    sim_dir = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
        "2021_MC_sim_IMU_simulation_model/",...
        "simulation_results",...
        sensor_name);
end

sim_comparsion_dir = fullfile("/media/jagatpreet/Data/datasets/imu_modeling_paper/",...
    "2021_MC_sim_IMU_simulation_model/",...
    "IMU_comparison");
stats_dir = 'mc_sim_stats';

%% The individual sensor analysis is done for a particular sensor
% Here we generally choose VN100.
individual_noise_paramter_keys = struct('acc', 0,...
                                'gyro', 0,...
                                'acc_wb_wbp', 0,...
                                'gyro_wb_wbp', 0,...
                                'acc_gyro_wb_wbp', 0,...
                                'wbp_acc_gyro_vs_wb_inflate_acc_gyro', 0);


type = '';
flds = fields(individual_noise_paramter_keys);
sprintf("Is mean parameter analysis activated? : %d" , mean_parameter_analysis);
for i = 1:length(flds)
    if individual_noise_paramter_keys.(flds{i}) == 1
       type = flds{i};    
        if mean_parameter_analysis == 0
            switch type
                case 'acc'
                    model.queries = ["mc_sim_stats_stationary_brown_100s_acc",...
                                     "mc_sim_stats_stationary_pink_100s_acc",...
                                     "mc_sim_stats_stationary_white_100s_acc"];
                    model.legends = ["brown","pink","white"];
                    model.comment = "Accelerometer ";     
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                case 'gyro'
                    model.queries = ["mc_sim_stats_stationary_brown_100s_gyro",...
                                     "mc_sim_stats_stationary_pink_100s_gyro",...
                                    "mc_sim_stats_stationary_white_100s_gyro"];
                    model.legends = ["brown","pink","white"];
                    model.comment = "Gyroscope "; 
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                    
                case 'acc_wb_wbp'
                    model.queries = ["mc_sim_stats_stationary_wb_100s_acc",...
                                    "mc_sim_stats_stationary_wbp_100s_acc"];
                    model.legends = ["white-brown","white-brown-pink"];
                    model.comment = "Accelerometer - combined model";
                    opts.use_noise_colors = 0;
                case 'gyro_wb_wbp'
                    model.queries = ["mc_sim_stats_stationary_wb_100s_gyro",...
                                 "mc_sim_stats_stationary_wbp_100s_gyro"];
                    model.legends = ["white-brown","white-brown-pink"];
                    model.comment = "Gyroscope only - combined model";
                    opts.use_noise_colors = 0;
                case 'acc_gyro_wb_wbp'     
                    model.queries = ["mc_sim_stats_stationary_wb_ag_100s",...
                                    "mc_sim_stats_stationary_wbp_ag_100s"];
                    model.legends = ["white-brown","white-brown-pink"];
                    model.comment = "Accelerometer - Gyroscope noise model";
                    opts.use_noise_colors = 0;
                otherwise
                    sprintf("No valid choice: %s", flds{i});
            end
        elseif mean_parameter_analysis == 1
            switch type
                case 'acc'
                    model.queries = ["mc_sim_stats_stationary_imu_b_acc_100s",...
                                    "mc_sim_stats_stationary_imu_p_acc_100s",...
                                    "mc_sim_stats_stationary_imu_w_acc_100s"];
                    model.legends = ["brown","pink","white"];
                    model.comment = "Accelerometer ";
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                case 'gyro'
                    model.queries = ["mc_sim_stats_stationary_imu_b_gyro_100s",...
                                 "mc_sim_stats_stationary_imu_p_gyro_100s",...
                                 "mc_sim_stats_stationary_imu_w_gyro_100s"];
                    model.legends = ["brown","pink","white"];
                    model.comment = "Gyroscope ";
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                case 'acc_wb_wbp'
                    model.queries = ["mc_sim_stats_stationary_imu_wb_acc_100s",...
                                    "mc_sim_stats_stationary_imu_wbp_acc_100s"];
                    model.legends = ["white-brown","white-brown-pink"];
                    model.comment = "Accelerometer - combined model";
                    opts.use_noise_colors = 0;
                    opts.y_limits_mean = [];
                    opts.y_limits_sigma = [ ];
%                 case 'gyro_wb_wbp'
%                     model.queries = ["mc_sim_stats_stationary_wb_100s_gyro",...
%                                  "mc_sim_stats_stationary_wbp_100s_gyro"];
%                     model.legends = ["white-brown","white-brown-pink"];
%                     model.comment = "Gyroscope only - combined model";
                case 'acc_gyro_wb_wbp'     
                    model.queries = ["mc_sim_stats_stationary_imu_wb_acc_gyro_100s",...
                                    "mc_sim_stats_stationary_imu_wbp_acc_gyro_100s"];
                    model.legends = ["white-brown","white-brown-pink"];
                    model.comment = "Accelerometer - Gyroscope noise model";
                    opts.use_noise_colors = 0;
                    opts.y_limits_mean = [];
                    opts.y_limits_sigma = [ ];
                otherwise
                    sprintf("No valid choice: %s", flds{i});
            end
        end  
         
        % set stat folder path
        mc_sim_stat_path = fullfile(sim_dir,stats_dir);
        for j=1:length(model.queries)
            files{j} = dir(fullfile(mc_sim_stat_path,strcat('*',...
                                model.queries(j),'*')));
        end
        %% plot stats
        for k = 1:length(files)
            load(fullfile(mc_sim_stat_path,files{k}.name),'mc_sim_stats');
            [folder,name,ext] = fileparts(fullfile(mc_sim_stat_path,files{k}.name)); 
            hdrs{k} = model.legends(k);
            sim_averages_hdrs(k) = mc_sim_stats.sim_averages;
            sim_sigmas_hdrs(k) = mc_sim_stats.sim_sigmas;
            t{k} = mc_sim_stats.t;
        end

        plot_mc_stats(hdrs,model.comment,t,...
                      sim_averages_hdrs,sim_sigmas_hdrs,...
                      opts);
        type ='';
        files = {};
        model.queries = [];
    end
end

%% This analysis is to compare the performance of different sensors and
% other models.
mean_parameter_analysis = 1;
comparison_sensor_keys = struct('xsens_vs_vn100_wb', 0,...
                                'xsens_vs_vn100_wbp',0,...
                                'vn100_vs_voxl_imu0', 0,...
                                'pink_sensitivity', 1);
type = '';
flds = fields(comparison_sensor_keys);
sprintf("Is mean parameter analysis activated? : %d" , mean_parameter_analysis);
for i = 1:length(flds)
    if comparison_sensor_keys.(flds{i}) == 1
       type = flds{i};    
       if mean_parameter_analysis == 0
            switch type
                case 'xsens_vs_vn100_wb'
                    model.queries = ["mc_sim_stats_stationary_wb_ag_100s_vn100",...
                                     "mc_sim_stats_stationary_wb_ag_100s_xsense"];
                    model.legends = ["vn100","xsens"];
                    model.comment = "Comparison of xsens vs vn100 position error -wb ";     
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                case 'xsens_vs_vn100_wbp'
                    model.queries = ["mc_sim_stats_stationary_wbp_ag_100s_vn100",...
                                     "mc_sim_stats_stationary_wbp_ag_100s_xsense",...
                                    "mc_sim_stats_stationary_white_100s_gyro"];
                    model.legends = ["vn100","xsens"];
                    model.comment = "Comparison of xsens vs vn100 position error - wbp"; 
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];     
                case 'pink_sensitivity'
                    model.queries = ["mc_sim_stats_stationary_pink_original_acc_vn100",...
                                     "mc_sim_stats_stationary_pink_tau_shifted_acc_vn100",...
                                     "mc_sim_stats_stationary_pink_tau_extended_acc_vn100",...
                                     "mc_sim_stats_stationary_pink_sigma_doubled_acc_vn100"];
                    model.legends = ['$\tau1$=10, $\tau2$=163, $\sigma$=3.18e-4', ...
                                     '$\tau1$=50, $\tau2$=203, $\sigma$=3.18e-4',...
                                     '$\tau1$=10, $\tau2$=260, $\sigma$=3.18e-4',...
                                     '$\tau1$=10, $\tau2$=163, $\sigma$=2*3.18e-4'];
                    model.comment = "pink sensitivity analysis";
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                otherwise
                    sprintf("No valid choice: %s", flds{i});
            end
        elseif mean_parameter_analysis == 1
            switch type
                case 'xsens_vs_vn100_wb'
                    model.queries = ["mc_sim_stats_stationary_wb_ag_100s_vn100",...
                                     "mc_sim_stats_stationary_wb_ag_100s_xsense"];
                    model.legends = ["vn100","xsens"];
                    model.comment = "Comparison of xsens vs vn100 position error -wb ";     
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                case 'xsens_vs_vn100_wbp'
                    model.queries = ["mc_sim_stats_stationary_wbp_ag_100s_vn100",...
                                     "mc_sim_stats_stationary_wbp_ag_100s_xsense",...
                                    "mc_sim_stats_stationary_white_100s_gyro"];
                    model.legends = ["vn100","xsens"];
                    model.comment = "Comparison of xsens vs vn100 position error - wbp"; 
                    opts.use_noise_colors = 1;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                case 'pink_sensitivity'
                    model.queries = ["mc_sim_stats_stationary_pink_original_acc_vn100",...
                                     "mc_sim_stats_stationary_pink_tau_shifted_acc_vn100",...
                                     "mc_sim_stats_stationary_pink_tau_extended_acc_vn100",...
                                     "mc_sim_stats_stationary_pink_sigma_doubled_acc_vn100"];
                    model.legends = {'$\tau1$=10, $\tau2$=163, $\sigma$=3.18e-4', ...
                                     '$\tau1$=50, $\tau2$=203, $\sigma$=3.18e-4',...
                                     '$\tau1$=10, $\tau2$=260, $\sigma$=3.18e-4',...
                                     '$\tau1$=10, $\tau2$=163, $\sigma$=2*3.18e-4'};
                    model.comment = "pink sensitivity analysis";
                    opts.use_noise_colors = 0;
                    opts.y_limits_mean = [-1 1];
                    opts.y_limits_sigma = [ ];
                otherwise
                    sprintf("No valid choice: %s", flds{i});
            end
        end  
         
        % set stat folder path
        mc_sim_stat_path = fullfile(sim_comparsion_dir,stats_dir);
        for j=1:length(model.queries)
            files{j} = dir(fullfile(mc_sim_stat_path,strcat('*',...
                                model.queries(j),'*')));
        end
        %% plot stats
        for k = 1:length(files)
            load(fullfile(mc_sim_stat_path,files{k}.name),'mc_sim_stats');
            [folder,name,ext] = fileparts(fullfile(mc_sim_stat_path,files{k}.name)); 
            hdrs{k} = model.legends{k};
            sim_averages_hdrs(k) = mc_sim_stats.sim_averages;
            sim_sigmas_hdrs(k) = mc_sim_stats.sim_sigmas;
            t{k} = mc_sim_stats.t;
        end

        plot_mc_stats(hdrs,model.comment,t,...
                      sim_averages_hdrs,sim_sigmas_hdrs,...
                      opts);
        type ='';
        files = {};
        model.queries = [];
    end
end
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
% if strcmp(type,'acc')
%         model.queries = ["mc_sim_stats_stationary_brown_100s_acc",...
%                              "mc_sim_stats_stationary_pink_100s_acc",...
%                             "mc_sim_stats_stationary_white_100s_acc"];
%         model.legends = ["brown","pink","white"];
%         model.comment = "Accelerometer - individual contribution"; 
%     elseif strcmp(type,'acc_mean')
%         model.queries = ["mc_sim_stats_stationary_imu_b_acc_100s",...
%                             "mc_sim_stats_stationary_imu_p_acc_100s",...
%                             "mc_sim_stats_stationary_imu_w_acc_100s"];
%         model.legends = ["brown","pink","white"];
%         model.comment = "Accelerometer - individual contribution"; 
%     elseif strcmp(type,'gyro')
%         model.queries = ["mc_sim_stats_stationary_brown_100s_gyro",...
%                            % "mc_sim_stats_stationary_pink_100s_gyro",...
%                             "mc_sim_stats_stationary_white_100s_gyro"];
%         model.legends = ["brown","pink","white"];
%         model.comment = "Gyroscope - individual contribution"; 
%     elseif strcmp(type,'gyro_mean')
%         model.queries = ["mc_sim_stats_stationary_imu_b_gyro_100s.mat",...
%                          "mc_sim_stats_stationary_imu_p_gyro_100s",...
%                          "mc_sim_stats_stationary_imu_w_gyro_100s"];
%         model.legends = ["white","brown","pink"];
%         model.comment = "Gyroscope - individual contribution";
%     elseif strcmp(type,'acc_combined')
%         model.queries = ["mc_sim_stats_stationary_wb_100s_acc",...
%                             "mc_sim_stats_stationary_wbp_100s_acc"];
%         model.legends = ["white-brown","white-brown-pink"];
%         model.comment = "Accelerometer - combined model";
%     elseif strcmp(type,'gyro_combined')
%         model.queries = ["mc_sim_stats_stationary_wb_100s_gyro",...
%                          "mc_sim_stats_stationary_wbp_100s_gyro"];
%         model.legends = ["white-brown","white-brown-pink"];
%         model.comment = "Gyroscope only - combined model";
%     elseif strcmp(type,'acc_gyro')
%         model.queries = ["mc_sim_stats_stationary_wb_ag_100s",...
%                         "mc_sim_stats_stationary_wbp_ag_100s"];
%         model.legends = ["white-brown","white-brown-pink"];
%         model.comment = "Accelerometer - Gyroscope noise model";
%     elseif strcmp(type,'xsens_vs_vn100_wb')
%         model.queries = ["mc_sim_stats_stationary_wb_ag_100s_vn100",...
%                         "mc_sim_stats_stationary_wb_ag_100s_xsense"];
%         model.legends = ["vn100_wb","xsens_wb"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type,'xsens_vs_vn100_wbp')
%         model.queries = ["mc_sim_stats_stationary_wbp_ag_100s_vn100",...
%                         "mc_sim_stats_stationary_wbp_ag_100s_xsense"];
%         model.legends = ["vn100_wbp","xsens_wbp"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type,'vn100_vs_voxl_imu0')
%         model.queries = ["mc_sim_stats_stationary_wbp_ag_100s_vn100",...
%                         "mc_sim_stats_stationary_wbp_ag_100s_voxl_imu0"];
%         model.legends = ["vn100","voxl_imu0"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type,'vn100_wb_vs_vn100_wbp')
%         model.queries = ["mc_sim_stats_stationary_wb_ag_100s_vn100",...
%                         "mc_sim_stats_stationary_wbp_ag_100s_vn100"];
%         model.legends = ["vn100_wb","vn100_wbp"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type,'vn100_wb_vs_vn100_wbp_vs_vn100_inflatedwb')
%         model.queries = ["mc_sim_stats_stationary_wb_ag_100s_vn100",...
%                         "mc_sim_stats_stationary_wbp_ag_100s_vn100",...
%                         "mc_sim_stats_stationary_inflated_wb_ag_100s_vn100"];
%         model.legends = ["vn100_wb","vn100_wbp","vn100_inflated_wb"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type,'vn100_mean_vs_voxl_imu0_mean')
%         model.queries = ["mc_sim_stats_stationary_imu_wbp_acc_gyro_100s_voxl_imu0_mean",...
%                         "mc_sim_stats_stationary_imu_wbp_acc_gyro_100s_vn100_mean"];
%         model.legends = ["voxl_imu0_mean","vn100_mean"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type,'old_vs_new_pink')
%         model.queries = ["mc_sim_stats_stationary_pink_new_100s_acc",...
%                         "mc_sim_stats_stationary_pink_100s_acc"];
%         model.legends = ["new","old"];
%         model.comment = "Accelerometer-Gyroscope noise model for two MEMS sensors";
%     elseif strcmp(type, "pink_senstivity")
%         model.queries = ["mc_sim_stats_stationary_pink_original_acc",...
%                         "mc_sim_stats_stationary_pink_sigma_doubled_acc",...
%                         "mc_sim_stats_stationary_pink_tau_shifted_acc"];
%                      %  ,...
% 
%         model.legends = ["original","sigma doubled","tau_shifted"];
%         model.comment = "Senstivity of pink noise";
%     end


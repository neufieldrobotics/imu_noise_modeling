% This script verfies the the IMU noise model (white,brown, and pink noise) components with the theoretical AD
% curves. The script compares the two AD curves for each noise component: 
% simulated AD curves obtained by plugging in the experimentally determined 
% noise parameters in the IMU noise model and theoretical AD
% curves obtained by plugging in experimentally determined noise
% parameters.

% Created by: Jagatpreet
% Email: nir.j@northeastern.edu
% Date created: January,2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
script_paths;
config_sensor_model_verification;
stochastic_model_to_compare = parse_choices_from_simulation_case_struct(simulation_case);
fprintf(" %s - List of stochastic models evaluated:",sensor_name)
disp(stochastic_model_to_compare);

for i = 1:length(stochastic_model_to_compare)
    AD_curve{i} = simulate_AD_imu_stochastic_model(stochastic_model_to_compare{i},...
                                                    paths);
    fig = plot_simulated_AD_with_theoretical_AD(AD_curve{i});
    if save_flag
        saveas(fig,fullfile("plot_images",...
                        strcat("AD_verification-",sensor_name,'_',...
                        stochastic_model_to_compare{i},...
                        '_axis_',num2str(axis),'.jpeg')));
    end
end

if save_flag
    save('simulation_results/sensor_models_ad.mat','AD_curve');
end
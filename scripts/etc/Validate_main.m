close all
clear
script_paths;

global g_world
g_world = [0;0;-9.8098];
data_path = "/media/jagatpreet/Data/datasets/imu_modeling_paper/allan_dev_data/voxl_imu0.mat";
load(data_path)

imu_params_path = 'config_files/IMU_params/VOXL_IMU0';
% Load data from config files
sim_params = YAML.read('config_files/Sim_params/stationary.yaml');
imu_params = YAML.read(fullfile(imu_params_path,'sim_test_imu_wbp_acc_gyro.yaml'));
sensor = "Gyroscope";

% Generate AD data from simulated stationary IMU
simulated_AD_data = simulated_AD_curves(sim_params,imu_params_path,sensor);

% Initialize the theoretical AD data arrays
theor_white = zeros(length(simulated_AD_data.gyro.tau), 3);
theor_brown = zeros(length(simulated_AD_data.gyro.tau), 3);
theor_pink = zeros(length(simulated_AD_data.gyro.tau), 3);
theor_all = zeros(length(simulated_AD_data.gyro.tau), 3);

% Loop through each axis of gyro and accel (x, y, z)
for i = 1:3
% compute the theoretical AD values for each noise component
[theor_white(:,i), theor_brown(:,i), theor_pink(:,i), theor_all(:,i)] = theoretical_AD_curves(...
                       simulated_AD_data.gyro.tau, ...                       
                       imu_params.Gyroscope.NoiseDensity(i), ...
                       imu_params.Gyroscope.RandomWalk(i), ...
                       imu_params.Gyroscope.BiasInstability(i));
end

figure(1)
loglog(simulated_AD_data.gyro.tau, simulated_AD_data.gyro.adev_white(:,1), 'r','LineWidth',2)
hold on
loglog(simulated_AD_data.gyro.tau, theor_white(:,1),'b','LineWidth',2)
grid on
title('White')
legend('simulated data','theor_data')
xlabel('\tau (sec)','FontSize',14)
ylabel('\sigma(\tau) (rad/sec)','FontSize',14)

figure(2)
loglog(simulated_AD_data.gyro.tau, simulated_AD_data.gyro.adev_pink(:,1), 'r','LineWidth',2)
hold on
loglog(simulated_AD_data.gyro.tau, theor_pink(:,1),'b','LineWidth',2)
grid on
title('Pink')
legend('simulated data','theor_data')
xlabel('\tau (sec)','FontSize',14)
ylabel('\sigma(\tau) (rad/sec)','FontSize',14)

figure(3)
loglog(simulated_AD_data.gyro.tau, simulated_AD_data.gyro.adev_brown(:,1), 'r','LineWidth',2)
hold on
loglog(simulated_AD_data.gyro.tau, theor_brown(:,1),'b','LineWidth',2)
grid on
title('Brown')
legend('simulated data','theor_data')
xlabel('\tau (sec)','FontSize',14)
ylabel('\sigma(\tau) (rad/sec)','FontSize',14)

figure(4)
loglog(simulated_AD_data.gyro.tau, simulated_AD_data.gyro.adev_all(:,1), 'r','LineWidth',2)
hold on
loglog(simulated_AD_data.gyro.tau, theor_all(:,1),'b','LineWidth',2)
grid on
title('All')
legend('simulated data','theor_data')
xlabel('\tau (sec)','FontSize',14)
ylabel('\sigma(\tau) (rad/sec)','FontSize',14)

function simulated_data = simulated_AD_curves(sim_params,imu_params_path,sensor) 
% simulated_AD_curves - generates simulated stationary IMU data and returns
%                       the allan deviation values

% INPUTS:
% sim_params - (1x1 Struct) simulation parameters from the config file:
%                          'config_simulations/Sim_params/stationary.yaml'

% OUTPUTS: 
% simulated_data - (1x1 Struct) Structure containing the allan deviation
%                   values for the simulated gyro and accel. Within the
%                   simulated_data struct there are two structures: gyro
%                   and accel. Each column of data within the sub structs
%                   corresponds to a different axis of the sensor (x, y, z).

                                    
imu_noise = ["w","p","b","wbp"];
simulated_data = struct();

    
for i = 1:length(imu_noise)
    
    if strcmp(sensor,'gyroscope')
        imu_params = YAML.read(strcat(imu_params_path,'/sim_test_imu_',imu_noise(i),'_gyro.yaml'));
    elseif strcmp(sensor,'accelerometer')
        imu_params = YAML.read(strcat(imu_params_path,'/sim_test_imu_',imu_noise(i),'_acc.yaml'));
    end

    [~,accelSamples,gyroSamples,~] = simulate_imu_motion(imu_params,sim_params);

    [gyro_sim_avar, gyro_tau] = allanvar(gyroSamples,'decade',sim_params.SamplingRate);
    [accel_sim_avar, accel_tau] = allanvar(accelSamples,'decade',sim_params.SamplingRate);

    gyro_sim_adev = gyro_sim_avar.^0.5;
    accel_sim_adev = accel_sim_avar.^0.5;

    if i ==1
        simulated_data.gyro.adev_white = gyro_sim_adev;
        simulated_data.accel.adev_white = accel_sim_adev;
    elseif i ==2
        simulated_data.gyro.adev_pink = gyro_sim_adev;
        simulated_data.accel.adev_pink = accel_sim_adev;
    elseif i ==3
        simulated_data.gyro.adev_brown = gyro_sim_adev;
        simulated_data.accel.adev_brown = accel_sim_adev;
    else
        simulated_data.gyro.adev_all = gyro_sim_adev;
        simulated_data.accel.adev_all = accel_sim_adev;
    end      
end
simulated_data.gyro.tau = gyro_tau;
simulated_data.accel.tau = accel_tau;
    
end

function [adev_white, adev_brown, adev_pink, adev_all] = theoretical_AD_curves(tau, N, K, B)
% theoretical_AD_curves - Computes theoretical Allan deviation curves for
%                         different additive noises; white, brown and pink 
%                         from the paper [1]

% [1] El-Sheimy, N., Hou, H., & Niu, X. (2008). 
%     Analysis and modeling of inertial sensors using allan variance. 
%     IEEE Transactions on Instrumentation and Measurement, 57(1), 140–149.

% INPUTS:
% tau - (n x 1) Vector of tau values. When comparing theoretical AD curve to
%       simulated AD curve, use the tau values from the simulated data for easy
%       comparison
% N - (1 x 1) White noise parameter (angle/velocity random walk)
% K - (1 x 1) Brown noise parameter (rate random walk)
% B - (1 x 1) Pink noise parameter (bias instability)

% OUTPUTS:
% adev_white - (n x 1) Vector of allan deviation values when just white
%               noise is present
% adev_brown - (n x 1) Vector of allan deviation values when just brown
%               noise is present
% adev_pink - (n x 1) Vector of allan deviation values when just pink
%              noise is present
% adev_all - (n x 1) Vector of allan deviation values when all three
%             additive noises are present

%tau = [.1:.1:1000]';

adev_white = N./sqrt(tau);
adev_brown = K.*sqrt(tau/3);

adev_pink = zeros(length(tau),1);

tau_cutoff = 1;
ind = find (tau < tau_cutoff);
adev_pink(ind) = tau(ind) * 0.664*B;
ind = find(tau >= tau_cutoff) ;
adev_pink(ind) = sqrt(2*log(2)/pi)*B;  

adev_all = adev_white + adev_brown + adev_pink;

end

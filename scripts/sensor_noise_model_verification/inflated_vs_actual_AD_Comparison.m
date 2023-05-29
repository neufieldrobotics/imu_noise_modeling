close all
clear all

%% Fix this script
% PX4_Data = csvread('6hr_data.csv',1,0);
% PX_last = length(PX4_Data);
% PX4_Data = PX4_Data2(400000:(PX_last),2);
config_experimental_AD_curves

load(fullfile(data_folder_path,PX4_filename));
PX4.Data = PX4.PX4_data.Data;

load(fullfile(data_folder_path,VN100_filename));
VN100.Data = robot.vn100_imu;

% PX4 = load('PX4_data.mat');
% PX4.Data = PX4.PX4_data.Data;
% 
% VN100 = load('VN100_data.mat');
% VN100.Data = VN100.robot.imu_data;

% VN100_Fs = 400;
% PX4_Fs = 250;
%First make sure save ray data.
%save raw IMU data in structure of form:
%VN100.Data.Gyro.x  VN100.Data.Gyro.y   VN100.Data.Accel.x
imu_names = ['PX4_Data', 'VN100_Data'];
sensor_names = ['Gyroscope', 'Accelerometer'];
for i = 1:numel(imu_names)
    %sensor_names = fieldnames(imu_names(i).Data);
    for j = 1:numel(sensor_names)
        sensor_names(j) = struct();
        %% Estimate Allan Deviation and Estimate Noise Parameters
        field_names = fieldnames(imu_names(i).Data.sensor_names(j));
        for k = 1:numel(field_names)
            [tau, adev] = AD_Curves(imu_names(i).Data.sensor_names(j).field_names{k}, imu_names(i).Fs);
            [N, tauN, lineN, K, tauK, lineK, B, tauB, lineB] = noiseParams(adev, tau);
            sensor_names(j).field_names(k) = [N, K, B];
            imu_names(i) = YAML.dump(sensor_names(j))
        end
   end
end
%VN-100
[VN_tau, VN_adev, VN_avar, VN_adev_upperbound,VN_adev_lowerbound, VN_numSamples] = AD_Curves(VN100_Data,VN100_Fs);
[VN_N, VN_tauN, VN_lineN, VN_K, VN_tauK, VN_lineK, VN_B, VN_tauB, VN_lineB] = noiseParams(VN_adev, VN_tau);
[VN_avar_flicker, VN_tau_flicker,VN_tau_inflate, VN_avar_inflate, VN_avar_noflicker, VN_tau_noflicker] = SimulateIMU(VN100_Fs,VN_numSamples, VN_N, VN_K, VN_B);

%PX4
[PX_tau, PX_adev, PX_avar, PX_adev_upperbound,PX_adev_lowerbound, PX_numSamples] = AD_Curves(PX4_Data,PX4_Fs);
[PX_N, VN_tauN, PX_lineN, PX_K, PX_tauK, PX_lineK, PX_B, PX_tauB, PX_lineB] = noiseParams(PX_adev, PX_tau);
[PX_avar_flicker, PX_tau_flicker,PX_tau_inflate, PX_avar_inflate, PX_avar_noflicker, PX_tau_noflicker] = SimulateIMU(PX4_Fs, PX_numSamples, PX_N, PX_K, PX_B);

%% Plot VN-100 and PX4 actual data
figure(1)
%subplot(3,1,1)
%VN-100
h1 = loglog(VN_tau,VN_avar.^0.5,'-dk')
hold on
loglog(VN_tau,VN_adev_upperbound,'--b')
hold on
loglog(VN_tau,VN_adev_lowerbound,'--b')
hold on
%PX4
h2 = loglog(PX_tau,PX_avar.^0.5,'-dk')
hold on
loglog(PX_tau,PX_adev_upperbound,'--r')
hold on
loglog(PX_tau,PX_adev_lowerbound,'--r')
hold on
loglog(PX_N,'x')
hold on
loglog(PX_tau,PX_lineN,'-c')
hold on
loglog(PX_tau,PX_lineB,'-c')
hold on
loglog(PX_tau,PX_lineK,'-c')
grid on
axis equal 
xlabel('\tau (sec)')
ylabel('\sigma(\tau) (rad/sec)')
legend([h1,h2],'VN-100 Actual Data with confidence bounds',...
    'PX4 Actual Data with confidence bounds')
title('Allan Deviation')
%% Plot VN-100 actual data and simulated data
% Inflated noise parameters
figure(2)
h3 = loglog(VN_tau,VN_avar.^0.5,'-*k')
hold on
h4 = loglog(VN_tau_flicker,VN_avar_flicker.^0.5,'-db')
hold on
h5 = loglog(VN_tau_inflate,VN_avar_inflate.^0.5,'-*r')
hold on
h6 = loglog(VN_tau_noflicker,VN_avar_noflicker.^0.5,'-*c')
hold on

grid on
axis equal 
xlabel('\tau (sec)')
ylabel('\sigma(\tau) (rad/sec)')
legend([h3,h4,h5,h6],'Actual Data',...
    'Simulated: flicker, white, and brown noise',...
    'Simulated: inflated white and brown noise',...
    'Simulated: non-inflated white and brown noise')
title('VN-100 Allan Deviation: Actual vs inflated parameters')

%% Plot PX4 actual and simulated data
% Inflated noise parameters
figure(3)
h7 = loglog(PX_tau,PX_avar.^0.5,'-*k')
hold on
h8 = loglog(PX_tau_flicker,PX_avar_flicker.^0.5,'-db')
hold on
h9 = loglog(PX_tau_inflate,PX_avar_inflate.^0.5,'-*r')
hold on
h10 = loglog(PX_tau_noflicker,PX_avar_noflicker.^0.5,'-*c')
hold on

grid on
axis equal 
xlabel('\tau (sec)')
ylabel('\sigma(\tau) (rad/sec)')
legend([h7,h8,h9,h10],'Actual Data',...
    'Simulated: flicker, white, and brown noise',...
    'Simulated: inflated white and brown noise',...
    'Simulated: non-inflated white and brown noise')
title('PX4 Allan Deviation: Actual vs inflated parameters')


function [adev,tau] = compute_theoretical_AD_curve_2(imu_Params,type)
%simulate_motion - Computes theoretical Allan deviation curves for
%different additive noises - white, brown and pink from the paper [1]

% [1] El-Sheimy, N., Hou, H., & Niu, X. (2008). 
%     Analysis and modeling of inertial sensors using allan variance. 
%     IEEE Transactions on Instrumentation and Measurement, 57(1), 140–149. 

% Syntax:  [t,accelSamples,gyroSamples,varargout] = 
%                            compute_theoretical_AD_curve(imu_params,type)
%
% Inputs:
%    imu_params - struct that stores IMU parameters
%    type - 'a' - compute for accelerometer using imu_params
%           'g' - compute for gyroscope using imu_params

% Outputs:
%    tau - cluster time for which allan deviation is computed
%    adev - allan deviation for the noise parameters given
%    in imu_params struct
%                    

% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: None

% Subfunctions: None
% MAT-files required: none
% See also: None
% Author: Jagatpreet Nir
% Work address: Northeastern Field Robotics Lab
% email: nir.j@northeastern.edu
% Website: http://www.
% Sept 2020; Last revision: 03-Nov-2020
global type
if type == 'a'
    B = imu_Params.Accelerometer.BiasInstability;
    N = imu_Params.Accelerometer.NoiseDensity;
    K = imu_Params.Accelerometer.RandomWalk;
 elseif type == 'g'
    B = imu_Params.Gyroscope.BiasInstability;
    N = imu_Params.Gyroscope.NoiseDensity;
    K = imu_Params.Gyroscope.RandomWalk;
 else
     error('Wrong choice of sensor. Select g for gyro and a for accelerometer')
 end

% Cluster time vector
tau = .1:.01:1000;

% Assuming equal noise levels in all three axes. 
adev_white = N(1).*1./sqrt(tau); %theoretical values of AD with white noise
adev_brown = K(1).*sqrt(tau/3); %theoretical values of AD with white noise

% Preallocate
adev_pink = zeros(size(tau));
adev_pink1 = zeros(size(tau));

% Assume tau_cutoff = 1 s, where the white noise effect is prominent
tau_cutoff_start = 1; %start
tau_cutoff_end = 100

% theoretical values of AD with pink noise modeled as a straight line 
% with positive slope below tau_cutoff
ind = find (tau < tau_cutoff_start);
adev_pink(ind) = tau(ind) * 0.664*B(1);

% theoretical values of AD with pink noise modeled as a constant
% a line parallel to the x axis in AD plot above tau_cutoff

% Model 1:
ind = find(tau >= tau_cutoff_start); % model 1
adev_pink(ind) = 0.664*B(1);

%Model 2:
ind = find(tau >= tau_cutoff_start & tau >= tau_cutoff_start)  ;
adev_pink1(ind) = 0.664*B(1);
ind_white_crosses_pink = find(adev_white <= 0.664*B(1));
ind_brown_crosses_pink = find(adev_brown >= 0.664*B(1));
adev = zeros(size(tau));
adev(ind_white_crosses_pink) = adev_white(ind_white_crosses_pink);
adev(ind_brown_crosses_pink) = adev_brown(ind_brown_crosses_pink);
end
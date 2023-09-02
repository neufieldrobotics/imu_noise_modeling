% Since we have modeled pink noise as sum of two AR(1) processes, we want
% to understand the error of the pink noise when the values of the pink n
% oise parameters changes. We want to build an intuition of how the noise 
% changes the dead reckoning error of a stationary IMU. 
% The following parameters are studied: 
% 
% 1. sigma: Sigma is the allan deviation value where the IMU curve is flat.
% 2. tau1: The cluster time, when the allan deviation of an IMU starts
% going flat.
% 3. tau2: The cluster time, when the allan deviation of an IMU starts
% going up from flat.
% Note that the lowest point on allan deviation curve is 0.664*B, B - bias
% instability parameter
% We select sigma and taus in a way that | sigma - 0.664*B|/(0.664*B) <
% 0.1. These are selected manually. Here we will choose real values from
% the IMU sensor.
clear all
close all
global type
type = "a";
ad_lowest = 3.2e-4;
imu_params.Accelerometer.BiasInstability = ad_lowest;
imu_params.Accelerometer.tau1 = [20];
imu_params.Accelerometer.tau2 = [20];
imu_params.Accelerometer.sigma = [ad_lowest];
imu_params.Accelerometer.BiasInstability = [4.87e-4, 3.65e-4, 4.89e-4];
imu_params.Accelerometer.NoiseDensity = [0, 0, 0];
imu_params.Accelerometer.RandomWalk = [0,0,0];

% case 0: theoretical
[AD_curve.theoretical.adev,...
    AD_curve.theoretical.tau] = compute_theoretical_AD_curve_1(imu_params);
loglog(AD_curve.theoretical.tau, AD_curve.theoretical.adev, '--b')
grid on
grid minor


% case1: original
imu_params.Accelerometer.tau1 = 20;
imu_params.Accelerometer.tau2 = 60;
imu_params.Accelerometer.sigma = ad_lowest;

duration = 5; % hours
sampling_rate = 200; % hz
time_sec = duration*60*60;
num_samples = time_sec*sampling_rate;

x1 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         ad_lowest,...
                         imu_params.Accelerometer.tau1);


x2 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         imu_params.Accelerometer.sigma,...
                         imu_params.Accelerometer.tau2);
                     
[avar_actual, tau_actual] = allanvar(x1 + x2, 'octave', sampling_rate);
hold on
loglog(tau_actual, sqrt(avar_actual), '--k')   

% case2 : tau1 shifted
imu_params.Accelerometer.tau1 = 100;
imu_params.Accelerometer.tau2 = 140;
imu_params.Accelerometer.sigma = ad_lowest;
x1 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         ad_lowest,...
                         imu_params.Accelerometer.tau1);


x2 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         imu_params.Accelerometer.sigma,...
                         imu_params.Accelerometer.tau2);
                     
[avar_actual, tau_actual] = allanvar(x1 + x2, 'octave', sampling_rate);
hold on
loglog(tau_actual, sqrt(avar_actual), '--r')   

% case3: tau range extended
imu_params.Accelerometer.tau1 = 20;
imu_params.Accelerometer.tau2 = 120;
imu_params.Accelerometer.sigma = ad_lowest;
x1 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         ad_lowest,...
                         imu_params.Accelerometer.tau1);


x2 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         imu_params.Accelerometer.sigma,...
                         imu_params.Accelerometer.tau2);
                     
[avar_actual, tau_actual] = allanvar(x1 + x2, 'octave', sampling_rate);
hold on
loglog(tau_actual, sqrt(avar_actual), '-m')   


% case4: sigma max doubled
imu_params.Accelerometer.tau1 = 20;
imu_params.Accelerometer.tau2 = 60;
imu_params.Accelerometer.sigma = 2*ad_lowest;
x1 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         ad_lowest,...
                         imu_params.Accelerometer.tau1);


x2 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         imu_params.Accelerometer.sigma,...
                         imu_params.Accelerometer.tau2);
                     
[avar_actual, tau_actual] = allanvar(x1 + x2, 'octave', sampling_rate);
hold on
loglog(tau_actual, sqrt(avar_actual), '-b')   
ylim([10e-7 10e-1])
legend("theoretical", "original", "tau1 shifted", "tau range extended", "double sigma max")

% Verify pink noise generator function. 
figure(2)
[AD_curve.theoretical.adev,...
    AD_curve.theoretical.tau] = compute_theoretical_AD_curve_1(imu_params);
loglog(AD_curve.theoretical.tau, AD_curve.theoretical.adev, '--m')
imu_params.Accelerometer.tau1 = 20;
imu_params.Accelerometer.tau2 = 60;
pink_noise = pink_noise_generator(ad_lowest,...
                                  imu_params.Accelerometer.tau1,...
                                  imu_params.Accelerometer.tau2,...
                                  num_samples,...
                                  1/sampling_rate);
                                  
x1 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         ad_lowest,...
                         imu_params.Accelerometer.tau1);


x2 = simulate_AR1_process(num_samples,...
                         sampling_rate,...
                         ad_lowest,...
                         imu_params.Accelerometer.tau2);
                     
[avar_actual, tau_actual] = allanvar(x1 + x2, 'octave', sampling_rate);
[avar_x1, tau_actual] = allanvar(x1 , 'octave', sampling_rate);
[avar_x2, tau_actual] = allanvar(x2, 'octave', sampling_rate);

hold on;
loglog(tau_actual, sqrt((sqrt(avar_x1) > 1e-4).*avar_x1), 'b');
hold on;
loglog(tau_actual, sqrt((sqrt(avar_x2) > 1e-4).*avar_x2), 'g');
hold on
loglog(tau_actual, sqrt((sqrt(avar_x2) > 1e-4).*avar_x2 + (sqrt(avar_x1) > 1e-4).*avar_x1), 'r');
hold on;
[avar_actual, tau_actual] = allanvar(pink_noise, 'octave', sampling_rate);
hold on
loglog(tau_actual, sqrt(avar_actual), '--k')
ylim([10e-7 10e-1])
legend("theoretical", "sum of ar1", "pink-noise-generator")

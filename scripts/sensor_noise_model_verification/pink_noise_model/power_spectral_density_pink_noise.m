close all
clear all

% Orignal parameters
imu_params.Accelerometer.tau1 = [5, 10, 20];
imu_params.Accelerometer.tau2 = [20, 163, 160];
imu_params.Accelerometer.sigma = [4.68e-4,3.18e-4,3.7e-4];
imu_params.Accelerometer.BiasInstability = [6.43e-4, 3.65e-4, 4.819e-4];
imu_params.Accelerometer.NoiseDensity = [0, 0, 0];
imu_params.Accelerometer.RandomWalk = [0,0,0];
fmax = 0.1

% Understand how sum of two AR(1) process 
% create a power spectral density
T_c_1 = imu_params.Accelerometer.tau1./1.89;
T_c_2 = imu_params.Accelerometer.tau2./1.89;
Q1 = zeros(3,1);
Q2 = zeros(3,2);
f = linspace(0,fmax,1000);

for i = 1:3
    Q1(i) = imu_params.Accelerometer.sigma(i)/(0.437*sqrt(T_c_1(i)));
    Q2(i) = imu_params.Accelerometer.sigma(i)/(0.437*sqrt(T_c_2(i)));
    
    power_spectral_density1 = ((Q1(i)*T_c_1(i))^2)./(1 + (2*pi*f*T_c_1(i)).^2);
    power_spectral_density2 = ((Q2(i)*T_c_2(i))^2)./(1 + (2*pi*f*T_c_2(i)).^2);
    figure();
    plot(f, power_spectral_density1, 'r');
    hold on
    plot(f, power_spectral_density2, 'g');
    hold on
    plot(f, power_spectral_density1 + power_spectral_density2,'*');
    grid on
    xlabel('f $(Hz)$','Interpreter','latex', 'FontSize', 16);
    ylabel('PSD Ampltitude $(\frac{m}{s^2})^2/Hz$','Interpreter','latex', 'FontSize', 16);
    title(strcat("  Power Spectral Density"),'FontSize', 16);
    legend('$\mathbf{x_1}$: $\tau1=10$, $\sigma_{peak}=3.18e-4$',...
           '$\mathbf{x_2}$: $\tau2=163$, $\sigma_{peak}=3.18e-4$',...
           '$\mathbf{x_1}+\mathbf{x_2}$',...
           'Interpreter','latex');
    ax = gca;
    ax.FontSize = 16;
end


% Effect of changing tau and sigma on power spectral density parameters
% case1: tau original taken from vn100 y axis accelerometer
% case2: tau1 shifted by 40 cluster times.
% case3: tau range extended by 100 cluster times
% case4: sigma doubled
imu_params.Accelerometer.tau1 = [10, 50, 10, 10];
imu_params.Accelerometer.tau2 = [163, 203, 260, 163];
imu_params.Accelerometer.sigma = [3.18e-4,3.18e-4,3.18e-4,2*3.18e-4];
imu_params.Accelerometer.BiasInstability = [6.43e-4, 3.65e-4, 4.819e-4];
imu_params.Accelerometer.NoiseDensity = [0, 0, 0];
imu_params.Accelerometer.RandomWalk = [0,0,0];


T_c_1 = imu_params.Accelerometer.tau1./1.89;
T_c_2 = imu_params.Accelerometer.tau2./1.89;
Q1 = zeros(3,1);
Q2 = zeros(3,2);
f = linspace(0,fmax,1000);
figure()
for i = 1:4
    Q1(i) = imu_params.Accelerometer.sigma(i)/(0.437*sqrt(T_c_1(i)));
    Q2(i) = imu_params.Accelerometer.sigma(i)/(0.437*sqrt(T_c_2(i)));
    
    power_spectral_density1 = ((Q1(i)*T_c_1(i))^2)./(1 + (2*pi*f*T_c_1(i)).^2);
    power_spectral_density2 = ((Q2(i)*T_c_2(i))^2)./(1 + (2*pi*f*T_c_2(i)).^2);
    plot(f, power_spectral_density1 + power_spectral_density2,'.-');
    
    hold on
    grid on 
end
ax = gca;
ax.FontSize = 16;
xlabel('f $(Hz)$','Interpreter','latex', 'FontSize', 16);
ylabel('PSD Ampltitude $(\frac{m}{s^2})^2/Hz$','Interpreter','latex', 'FontSize', 16);
title(strcat("  Senstivity analysis"));
legend('$\tau1$=10, $\tau2$=163, $\sigma$=3.18e-4', ...
       '$\tau1$=50, $\tau2$=203, $\sigma$=3.18e-4',...
       '$\tau1$=10, $\tau2$=260, $\sigma$=3.18e-4',...
       '$\tau1$=10, $\tau2$=163, $\sigma$=2*3.18e-4',...
       'Interpreter','latex');

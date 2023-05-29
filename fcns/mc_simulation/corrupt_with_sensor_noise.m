function [accel,gyro,nw,b] = corrupt_with_sensor_noise(ideal_acc,ideal_gyro,...
                                                        w_R_i_ideal,...
                                                        imu_params,...
                                                        sim_params)
%corrupt_with_sensor_noise - corrupts the ideal measurements with different 
%noise sources
% Syntax:  [accel,gyro,nw,b] = corrupt_with_sensor_noise(ideal_acc,ideal_gyro,...
%                                                    w_R_i_ideal,...
%                                                    imu_params,...
%                                                   sim_params)
%
% Inputs:
%    ideal_acc - noise free acceleration values obtained from 
%    ideal_gyro - noise gree angular velocities values in sensor frame
%    w_R_i_ideal - noise free rotation matrix of the current position.:
%                  Current code only supports a stationary simulation of IMU
%    imu_params - struct that stores IMU parameters
%    sim_params - struct that stores simulation parameters

% Outputs:
%    accel - noise corrupted sensor acceleration measurements - column
%    vector
%    gyro - noise corrupted sensor gyroscope measurements - column vector

%    nw   - white noise signal that corrupts the ideal measurements
%           struct : nw.acc and nw.gyro. Each entry stores a 
%           [3x1] column vector for x,y and z directions. 
%    b    - bias signal due to brown+pink noise in ideal measurements.
%           struct : b.acc and b.gyro. Each entry stores a 
%           [3x1] column vector for x,y and z directions.
%
% Author: Jagatpreet Nir
% Work address: Northeastern Field Robotics Lab
% email: nir.j@northeastern.edu

    global g_world;
    [M,N] = size(ideal_acc);
    del_t = 1/sim_params.SamplingRate;

    % White noise : Strength of noise due to sampling is
    % noise_density/sqrt(sampling_time)
    nw.acc = imu_params.Accelerometer.NoiseDensity.*randn(M,3)/sqrt(del_t); % Mx3
    nw.gyro = imu_params.Gyroscope.NoiseDensity.*randn(M,3)/sqrt(del_t); % Mx3

    % Random Walk:  Strength of noise due to sampling is
    % noise_density/sqrt(sampling_time)
    nb.acc = imu_params.Accelerometer.RandomWalk.*randn(M,3)/sqrt(del_t); % Mx3
    nb.gyro = imu_params.Gyroscope.RandomWalk.*randn(M,3)/sqrt(del_t); % Mx3

    % Bias instability: Strength of noise due to sampling is
    % noise_density/sqrt(sampling_time)
    if(imu_params.Accelerometer.BiasInstability == 0)
        np.acc = zeros(M,3);
    else
        for i = 1:3                  
            np.acc(:,i) = pink_noise_generator(imu_params.Accelerometer.sigma(i),...
                                         imu_params.Accelerometer.tau1(i),...
                                         imu_params.Accelerometer.tau2(i),...
                                         M,del_t);
        end
    end

    if(imu_params.Gyroscope.BiasInstability == 0)
        np.gyro = zeros(M,3);
    else
        for i = 1:3                                
            np.gyro(:,i) = pink_noise_generator(imu_params.Gyroscope.sigma(i),...
                                 imu_params.Gyroscope.tau1(i),...
                                 imu_params.Gyroscope.tau2(i),...
                                 M,del_t);
        end
    end

    % Initial bias
    b_0.acc = imu_params.Accelerometer.b_on;
    b_0.gyro = imu_params.Gyroscope.b_on;

    % Preallocate
    b.acc = zeros(M,3);
    b.gyro = zeros(M,3);

    % Bias model with brown noise
    for i = 1:M
        if i == 1
            b.acc(i,:) = b_0.acc;
            b.gyro(i,:) = b_0.gyro;
        else
            b.acc(i,:) = b.acc(i-1,:) + del_t*(nb.acc(i,:));
            b.gyro(i,:) = b.gyro(i-1,:) + del_t*(nb.gyro(i,:));
        end
    end

    %% IMU Model
    gyro = ideal_gyro + b.gyro + nw.gyro + np.gyro;
    accel = ideal_acc + b.acc + nw.acc + np.acc + (w_R_i_ideal*g_world)';
end


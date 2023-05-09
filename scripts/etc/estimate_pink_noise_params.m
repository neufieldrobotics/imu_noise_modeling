clear

% fs_vn = 400; % VN-100
% fs_x = 180; % XSENSE
% fs_adis = 200; % ADIS

%fs = fs_adis; % change to corresponding sensor

%% SET THESES PARAMETERS
B_acc = [6.44e-4, 1.1e-3, 1.3e-3]/0.664; % [x, y, z]
B_gyro = [8.1e-5, 1e-4, 7.02e-5]/0.664; % [x, y, z]
B = [B_acc B_gyro];

M = 3000001;
fs = 200;
del_t = 1/fs; % fs_x or fs_vn

np1 = randn(M,1);
np2 = randn(M,1);

params.sigma = zeros(1,6);
params.tau1 = zeros(1,6);
params.tau2 = zeros(1,6);
%% -------------------------------------------------------------------------
%ADIS: Un-comment the corresponding sigma depending on which 
% axis of which sensor you are using. tau1 and tau2 on the next two lines
% should work well for all XSENSE axes, gyro and accel

% B_acc = [6.44e-4, 1.1e-3, 1.3e-3]/0.664; % [x, y, z]
% B_gyro = [8.1e-5, 1e-4, 7.02e-5]/0.664; % [x, y, z]
% % 
% tau1 = 5;
% tau2 = 100;

% ACC X:
% sigma = 8.5e-3;
% B = B_acc(1);
% ACC Y:
% sigma = 1.5e-2;
% B = B_acc(2);
% ACC Z:
% sigma = 1.8e-2;
% B = B_acc(3);
% GYRO X:
% sigma = 1e-3;
% B = B_gyro(1);
% GYRO Y:
% sigma = 1.3e-3;
% B = B_gyro(2);
% GYRO Z:
% sigma = 9e-4;
% B = B_gyro(3);
%-------------------------------------------------------------------------



%-------------------------------------------------------------------------
%XSENSE: Un-comment the corresponding sigma depending on which 
% axis of which sensor you are using. tau1 and tau2 on the next two lines
% should work well for all XSENSE axes, gyro and accel

% B_acc = [6.8e-4, 5.78e-4, 4.99e-4]; % [x, y, z]
% B_gyro = [1.19e-4, 1.6e-4, 1.65e-4]; % [x, y, z]
% 
% tau1 = 25;
% tau2 = 150;

% ACC X:
%sigma = 5.75e-3;
% ACC Y:
%sigma = 4.8e-3;
% ACC Z:
%sigma = 4.3e-3;
% GYRO X:
%sigma = 1e-3;
% GYRO Y:
%sigma = 1.2e-3;
% GYRO Z:
%sigma = 1.2e-3;
%-------------------------------------------------------------------------


%-------------------------------------------------------------------------
%VN-100: Un-comment the corresponding sigma depending on which 
% axis of which sensor you are using. 

% B_acc = [9.32e-4, 3.65e-4, 4.89e-4];
% B_gyro = [3.06e-5, 8.03e-5, 7.00e-5];
% 
% tau1 = 2.5;
% tau2 = 50;

% ACC X:
%sigma = 1.25e-2;
% ACC Y:
%sigma = 4.5e-3;
% ACC Z:
%sigma = 6e-3;
% GYRO X:
%sigma = 4e-4;
% GYRO Y:
%sigma = 1e-3;
% GYRO Z:
%sigma = 9e-4;
%% -------------------------------------------------------------------------

for i = 1:6
    
    % Initial Values
    if i == 1
        sigma = 1e-3;
        tau1 = 5;
        tau2 = 100;
    else
        sigma = params.sigma(i-1);
        tau1 = params.tau1(i-1);
        tau2 = params.tau2(i-1);
    end
    
    % Loop until user satisfied with values
    while 1

        scaled_pink = compute_pink_noise(sigma, tau1, tau2, del_t, M, np1, np2);

        [avar, tau] = allanvar(scaled_pink,'decade',fs);
        adev = sqrt(avar);

        figure(1)
        loglog(tau, adev)
        hold on
        loglog(tau, 0.664*B(i)*ones(1,length(tau))) % switch to correct B
        title('Allan Deviation of Simulated Flicker Noise')
        xlabel('Cluster Time (sec)')
        ylabel('\sigma(\tau)')
        grid on
        hold off

        pause(3)
        
        satisfied = input('Satisfied with parameters? [y:1 /n:0]','s');
               
        if satisfied == 'y'
            params.sigma(i) = sigma;
            params.tau1(i) = tau1;
            params.tau2(i) = tau2;
            break
            
        elseif satisfied == 'n'
            sigma = input(strcat('please enter sigma. Last value was:',{' '}, string(sigma)));
            tau1 = input(strcat('please enter tau1. Last value was: ',{' '}, string(tau1)));
            tau2 = input(strcat('please enter tau2. Last value was: ',{' '}, string(tau2)));
        else
            satisfied = input('Please enter y or n','s');
        end
       
    end
end

function scaled_pink = compute_pink_noise(sigma, tau1, tau2, del_t, M, np1, np2)
sigma1 = sigma;
sigma2 = sigma;

T_c1 = tau1/1.89;
q_c1 = sigma1/0.437/sqrt(T_c1);

T_c2 = tau2/1.89;
q_c2 = sigma2/0.437/sqrt(T_c2);

% Initial bias
b_0.acc = 0;%imu_params.Accelerometer.b_on;
b_0.gyro = 0;%imu_params.Gyroscope.b_on;

% Preallocate
bp1 = zeros(M,1);
bp2 = zeros(M,1);

% Generate the two AR(1) process data
for i = 1:M
    if i == 1
        bp1(i) = b_0.acc;
        bp2(i) = b_0.acc;
    else
        bp1(i) = bp1(i-1) - del_t/T_c1*bp1(i-1) + del_t*q_c1*np1(i);
        bp2(i) = bp2(i-1) - del_t/T_c2*bp2(i-1) + del_t*q_c2*np2(i);

    end
end

% Pink noise is the superposition of the two AR1 vectors
scaled_pink = bp1 + bp2;

end


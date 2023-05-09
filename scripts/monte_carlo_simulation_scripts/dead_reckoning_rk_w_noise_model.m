clc
close all
global del_t g_world sampled_t
g_world = [0;0;-9.8098];
%createImuYaml(); %calculate noise params from raw data and write to yaml file
%% Load sensor parameters
% 1. Load sensor model parameters obtained from datasheet
VN100_Params = YAML.read('IMU_params/test_imu_models/sim_test_imu_b.yaml');
Sim_Params = YAML.read('Sim_params/test_motion/stationary.yaml');


%% Define IMU measurement models with different stochastic models
display_imu_params(VN100_Params);
% plot_sampled_data(sampled_acc,sampled_gyro,b);

%%%%%%%%%%% VN 100 %%%%%%%%%%%%%%%%
params = extractIMUParams(VN100_Params);
tau_zero = struct('acc',[0,0,0],'gyro',[0,0,0]);
Noise_zero = struct('acc',[0,0,0],'gyro',[0,0,0]);

% Dead reckoning model
% 1. No noise - assuming ideal IMU
m_model = IMU_Model;
set(m_model,...
    'SigmaWhite',Noise_zero,...
    'SigmaBrown',Noise_zero,...
    'SigmaPink',Noise_zero,...
    'tau',tau_zero,...
    'b_on',params.b_on);
                 

display_measurement_model_params(testIMU_m_model);

%% Simulate IMU measurements
% Define imu sensor object for VN-100
% to get noisy sample values.
M = 400*Sim_Params.TotalTime(end)+1;
MonteCarloSim.runData = zeros(M,15,total_runs);

for run = 1:total_runs % total_runs is set in main.m
    
    [sampled_t,sampled_acc, sampled_gyro,nw,b] = simulate_motion(VN100_Params,...
                                                        Sim_Params);
    plot_sampled_data(sampled_acc,sampled_gyro,b);
    %% SIMULATION
    
    tspan = [0,sampled_t(end)];
    del_t = 1/Sim_Params.SamplingRate;
    % Define Initial condition
    p_w_0 = Sim_Params.InitialCondition.p_w_0';
    v_w_0 = Sim_Params.InitialCondition.v_w_0';
    w_R_i_0 = eul2rotm(deg2rad(Sim_Params.InitialCondition.eul_w_0));
    i_b_g_0 = [0;0;0];
    i_b_a_0 = [0;0;0];
    ic = [w_R_i_0(1,:)';... % first row of rotation matrix
          w_R_i_0(2,:)';... % second row of rotation matrix
          w_R_i_0(3,:)';... % third row of rotation matrix
          v_w_0;...        % start velocity 
          p_w_0;...
          i_b_g_0;...
          i_b_a_0]; % ic - 15x1 column vector
    opts = odeset('RelTol',1e-2,...
                  'AbsTol',1e-4,...
                  'MaxStep',del_t,...
                  'Stats','on',...
                  'OutputFcn',[]);
    display_initial_conditions(ic);
    disp(' Run number = ');
    disp(run);
    pause(.5);
    % Odometry using sampled measurements of stationary data 
    % corrupted with white noise. The imu model that is used is 
    % ideal IMU model. The dead-reckoning (odometry) solution will
    % show us the effect of white noise on IMU integration
    [t1,X1] = ode45(@(t1,X1) m_model.ideal_imu_odometry_model(t1,...
                                                       X1,...
                                                       sampled_acc,...
                                                       sampled_gyro),...
                                                       tspan,...
                                                       ic(1:15),...
                                                       opts);
   MonteCarloSim.runData(:,:,run) = X1;
   MonteCarloSim.t = t1;
   close all;
end
% Odometry of stationary IMU with sampled measurements corrupted with 
% white noise. The IMU model used has white noise model parameters.
% This model shows how a model correction can reduce errors.
% The integration is done using ODE methods
% [t2,X2] = ode45(@(t2,X2) testIMU_m_model.imu_odometry_model_ode(t2,...
%                                                    X2,...
%                                                    sampled_acc,...
%                                                    sampled_gyro),...
%                                                    tspan,...
%                                                    ic,...
%                                                    opts);
% 
% % Odometry of stationary IMU with sampled measurements corrupted with 
% % white noise. The IMU model used has white noise model parameters.
% % The integration is done using SDE methods.
% f = @(t3,X3)testIMU_m_model.imu_drift_model_interp(t3,X3,sampled_acc,sampled_gyro);
% g = @(t3,X3)testIMU_m_model.imu_diffusion_model_interp(t3,X3,sampled_acc,sampled_gyro);
% opts = sdeset('RandSeed',1,...
%               'SDEType','Ito');
%           
% X3 = sde_euler(f,g,sampled_t,ic,opts);
% 
% %%%%%%%%%%%
% f = @(t4,X4)m_model.imu_drift_model_interp(t4,X4,sampled_acc,sampled_gyro);
% g = @(t4,X4)m_model.imu_diffusion_model_interp(t4,X4,sampled_acc,sampled_gyro);
% opts = sdeset('RandSeed',1,...
%               'SDEType','Ito');
%           
% X4 = sde_euler(f,g,sampled_t,ic,opts);
% 
 sim.t = MonteCarloSim.t;
 X.odometry_ode = MonteCarloSim.runData(:,:,1);
%  X.corr_ode_interpolated = interp1(t2,X2,sampled_t);
%  X.corr_sde = X3;
%  X.ideal_sde = X4;

%% HELPER FUNCTIONS
function params = extractIMUParams(imu_params)
    params.SigmaWhite.gyro = imu_params.Gyroscope.NoiseDensity;
    params.SigmaWhite.acc  = imu_params.Accelerometer.NoiseDensity;
    
    
    params.SigmaBrown.gyro = imu_params.Gyroscope.RandomWalk;
    params.SigmaBrown.acc  = imu_params.Accelerometer.RandomWalk;
    
    
    params.SigmaPink.gyro = imu_params.Gyroscope.BiasInstability;
    params.SigmaPink.acc  = imu_params.Accelerometer.BiasInstability;
    
    params.tau.gyro = imu_params.Gyroscope.tau;
    params.tau.acc  = imu_params.Accelerometer.tau;
    
    params.b_on.gyro = imu_params.Gyroscope.b_on;
    params.b_on.acc = imu_params.Accelerometer.b_on;
end

function plot_sampled_data(sampled_acc,sampled_gyro,b)
    global sampled_t
    disp('Standard deviation acceleration measurements (X,Y,Z):');
    disp(std(sampled_acc));
    
    disp('Standard deviation gyroscope measurements (X,Y,Z):');
    disp(std(sampled_gyro));
    
    disp('Press any key to continue');
    pause(.5);
    
    disp('Plotting sampled measurements');
    figure
    subplot(2,2,1);
    s1 = stackedplot(sampled_t,sampled_acc);
    s1.DisplayLabels = {'X (m/s^2)','Y(m/s^2)','Z(m/s^2)'};
    s1.GridVisible ='on';
    xlabel('time(s)');
    title('Sampled accelerations vs time');
    
    subplot(2,2,2);
    s2 = stackedplot(sampled_t,sampled_gyro);
    s2.DisplayLabels = {'omega_X (rad/s)','omega_Y(rad/s)','omega_Z (rad/s)'};
    s2.GridVisible ='on';
    xlabel('time(s)');
    title('Sampled angular velocities vs time');
    
    subplot(2,2,3);
    s2 = stackedplot(sampled_t,b.gyro);
    s2.DisplayLabels = {'bias_X (rad/s)','bias_Y(rad/s)','bias_Z (rad/s)'};
    s2.GridVisible ='on';
    xlabel('time(s)');
    title('Bias gyroscope vs time');
    
    subplot(2,2,4); 
    s2 = stackedplot(sampled_t,b.acc);
    s2.DisplayLabels = {'bias_X (m/s^2)','bias_Y(m/s^2)','bias_Z(m/s^2)'};
    s2.GridVisible ='on';
    xlabel('time(s)');
    title('Bias accelerometer vs time');

    disp('Press enter to proceed. and ctrl c to terminate')
    pause(.5);
end

function display_imu_params(imu_params)
    disp(" VN 100 parameters");
    disp("Accelerometer");
    disp(imu_params.Accelerometer);

    disp("Gyroscope");
    disp(imu_params.Gyroscope);

    disp('Press enter to proceed. and ctrl c to terminate')
    pause(.5);
end

function display_measurement_model_params(testIMU)
    disp('IMU measurement model parameters')
    disp('Sigma White');
    disp(testIMU.SigmaWhite);
    
    disp('Sigma Brown:');
    disp(testIMU.SigmaBrown);
    
    disp('Sigma Pink:');
    disp(testIMU.SigmaPink);
    
    disp('tau:');
    disp(testIMU.tau);
    
    disp('b_on:');
    disp(testIMU.b_on);
    
    disp('Press any key to continue')
    pause(.5);
end

function display_initial_conditions(ic)
    disp('Euler angles')
    disp(rotm2eul(ODE_Utility.form_rotation_mat(ic)));
    
    disp('Initial velocity')
    disp(ic(10:12));
    
    disp('Initial position');
    disp(ic(13:15));
    
    if length(ic) > 15
        disp('Initial gyro bias');
        disp(ic(16:18));
        
        disp('Initial acc bias');
        disp(ic(19:21));
    end
    disp('Press any key to continue');
    pause(.5);

end


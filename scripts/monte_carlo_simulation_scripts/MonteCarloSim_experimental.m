clear
global total_runs
script_paths;
config_MC_experimental;

% configure the data and folders
% generate runs of stationary data.
%         
rng(0,'twister');
start_time_sample = 0.5*60*60*sampling_rate;
end_time_sample = 4.5*60*60*sampling_rate;
number_of_samples_to_pick = 105*sampling_rate;

% generate hundred different start times for doing montecarlo simulation. 

t0 = (end_time_sample - start_time_sample).*rand(100,1) + start_time_sample;


load(fullfile(data_folder_path,filename));
VN100.Data = robot.vn100_imu;

for run=1:total_runs
    disp(' Run number = ');
    disp(run);
    
    % sample run data
    
    % preprocess sample run data. 
    
    plot_sampled_data(sampled_acc,sampled_gyro,b);
    %% SIMULATION

    tspan = [0,sampled_t(end)];
    del_t = 1/sim_params.SamplingRate;
    % Define Initial condition
    p_w_0 = sim_params.InitialCondition.p_w_0';
    v_w_0 = sim_params.InitialCondition.v_w_0';
    w_R_i_0 = eul2rotm(deg2rad(sim_params.InitialCondition.eul_w_0));
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
   MonteCarloSim.runData = X1;
   MonteCarloSim.t = t1;
   close all;


    sim.t = MonteCarloSim.t;
    X.odometry_ode = MonteCarloSim.runData(:,:,1);
  
    mc_sim_run_data.doc.comment = strcat("Accelerometer - ",...
                            "white brown accelerometer gyro noise simulation"," Run - ", num2str(run));
    mc_sim_run_data.doc.order = "x y z";
    mc_sim_run_data.doc.noise_params = imu_params{1};
    append_header_to_MC_data;
    save(strcat(filepath.save_path,'_',num2str(run),'.mat'),'mc_sim_run_data');
end



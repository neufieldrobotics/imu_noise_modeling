function MonteCarloSim = dead_reckoning_noise_model(IMU_params, sim_params)

    clc
    close all
    global del_t g_world sampled_t 
    global n_arg                
    if sim_params.model_type == 'm'
        n_arg = 2;
    end
    g_world = [0;0;-9.8098];
    %% Define IMU measurement models with different stochastic models
    display_imu_params(IMU_params);
    % plot_sampled_data(sampled_acc,sampled_gyro,b);

    %%%%%%%%%%% VN 100 %%%%%%%%%%%%%%%%
    params = extract_IMU_params(IMU_params);
    tau_zero = struct('acc',[0,0,0],'gyro',[0,0,0]);
    Noise_zero = struct('acc',[0,0,0],'gyro',[0,0,0]);

    % Dead reckoning model
    % 1. Dead reckoning model assuming ideal IMU measurements.
    m_model = IMU_Model;
    set(m_model,...
        'SigmaWhite',Noise_zero,...
        'SigmaBrown',Noise_zero,...
        'SigmaPink',Noise_zero,...
        'tau',tau_zero,...
        'b_on',params.b_on);
    
    
%% Different stochasitic simulations of IMU
    if n_arg == 2
        [sampled_t,sampled_acc, sampled_gyro] = simulate_imu_motion(IMU_params,...
                                                        sim_params);
        nw = [];
        b = [];
    else
        [sampled_t,sampled_acc, sampled_gyro,nw,b] = simulate_imu_motion(IMU_params,...
                                                        sim_params);
    end

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
end 



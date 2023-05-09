classdef IMU_Model < matlab.mixin.SetGet
    % IMU_Model class models the IMU measurement models
    % Three different IMU measurement models are implemented:
    % 1) IDEAL IMU - NO NOISE AND BIAS
    % 2) IMU WITH NOISE AND BIAS FOR ODE NUMERICAL SCHEME
    % 3) IMU WITH NOISE AND BIAS FOR SDE NUMERICAL SCHEME
    
    % Jagatpreet S. Nir, 
    % nir.j@northeastern.edu 
    % Created 08 -23 -2020
    % Revision: 
    
    properties
        b_on
        SigmaPink
        SigmaBrown
        SigmaWhite
        tau
    end
    
    methods
        function [dX] = imu_odometry_model_rpy(obj,...
                                           t,...
                                           X,...
                                           sampled_accel,...
                                           sampled_quat)
                                                 
        
          global g_world sampled_t
          % Initialize variables
          t
          dX    = zeros(6,1); % Initialize state vector
          acc   = zeros(3,1); % interpolated acceleration values
          w_R_i = zeros(3,3); % Rotation matrix IMU with respect to world
          % Interpolate acceleration values at time t
          acc  = obj.interpolate_deterministic(sampled_t,sampled_accel,t);
          
          % INTERPOLATE INPUT ROTATION MATRIX

          if t == 0
              index = 1;
              %t_low = 0;
          elseif t == sampled_t(end)
              index = length(sampled_t) - 1;
          else
              % find function doesnt have fine enough tolerance
              [~,index] = min(abs(t - sampled_t)); 
              if t < sampled_t(index)
                  index = index - 1;
              end
          end
          
          q1 = quatnormalize(sampled_quat(index,:));
          q2 = quatnormalize(sampled_quat(index+1,:));
          
          %t_high = sampled_t(find(sampled_t > t, 1));
          %coefficient = (t - t_low) / (t_high - t_low);
          coefficient = (t-sampled_t(index))/(sampled_t(index+1)-sampled_t(index));
          quat_inter = quatinterp(q1,q2,coefficient,'slerp');
          w_R_i = quat2rotm(quat_inter);
          
          % Define variables
          % w_R_i - Rotation matrix -- IMU with respect to world, 3x3
          % v_w - velocity in world frame, 3x1
          % p_w - position in world frame, 3x1
          
          v_w     = X(1:3);
          
          % Ideal IMU kinematic model
          v_w_dot   = w_R_i*acc - g_world; %3x1
          p_w_dot   = v_w; % 3x1 
          
          % Form output dX
          dX(1:3) = v_w_dot;
          dX(4:6) = p_w_dot;
                                             
        end
        %% IDEAL IMU - NO NOISE AND BIAS
        function [dX] = ideal_imu_odometry_model(obj,...
                                                 t,...
                                                 X,...
                                                 sampled_accel,...
                                                 sampled_gyro)
          % This is an ideal imu odometry model defined in a first
          % order differential equation form to be used with ode45 based 
          % numerical scheme. The ideal imu odometry model assumes there 
          % is no noise and bias drift in the sampled measurements. So, it
          % just integrates the measurements. For an ideal IMU, the
          % odometry solution from this model has only errors associated
          % with integration which are of the order h^4 for ode45 based rk4
          % based numerical methods. This model therefore can tell us the
          % effect of correction when the IMU measurement models include
          % corrections due to white noise and bias drift models.
          
          % INPUT:
          % t - integration time, scalar
          % sampled_accel - sampled acceleration measurements in 
          % IMU frame, 3xN
          
          % sampled_gyro -  sampled angular speed measurements in 
          % IMU frame, 3xN

          % OUTPUT
          % dX(1:9) - rotation matrix derivative, 
          % dX(10:12) - velocity derivative, 3x1
          % dX(13:15) - position derivative, 3x1
          

          global sampled_t g_world 
          % Initialize variables
          t
          dX    = zeros(15,1); % Initialize state vector
          acc   = zeros(3,1); % interpolated acceleration values
          gyro  = zeros(3,1); % interpolated gyroscope values
          w_R_i = zeros(3,3); % Rotation matrix IMU with respect to world
          
          % Interpolate acceleration values at time t
          acc  = obj.interpolate_deterministic(sampled_t,sampled_accel,t);
          
          % Interpolate gyroscope values at time t
          gyro = obj.interpolate_deterministic(sampled_t,sampled_gyro,t);

          % Define variables
          % w_R_i - Rotation matrix -- IMU with respect to world, 3x3
          % v_w - velocity in world frame, 3x1
          % p_w - position in world frame, 3x1
          
          w_R_i   = ODE_Utility.form_rotation_mat(X); % 3x3
          v_w     = X(10:12);
          S_w_imu = MathFunctions.skew_mat(gyro);
          
          % Ideal IMU kinematic model
          w_R_i_dot = w_R_i*S_w_imu; %3x3 
          v_w_dot   = w_R_i*acc - g_world; %3x1
          p_w_dot   = v_w; % 3x1 
          % Form output dX
          dX(1:9)   = ODE_Utility.form_state_vector(w_R_i_dot);
          dX(10:12) = v_w_dot;
          dX(13:15) = p_w_dot;
          %pause(.1);
        end
        %% IMU WITH NOISE AND BIAS WITH ODE NUMERICAL SCHEME
        function [dX] = imu_odometry_model_ode(obj,...
                                               t,...
                                               X,...
                                               sampled_accel,...
                                               sampled_gyro)
          % This imu odometery model includes white noise and bias with
          % brown and pink noise. The IMU model object properties stores 
          % parameters related to white, brown and pink noise. The odometry
          % model is expressed as a first order differential equation
          % X_d = F(X,t). The state vector includes bias values as
          % described in the output vector below.
          % This model will be used with ODE45 based integration 
          % by treating sampled measurements as deterministic.
          % In ODE based methods, it is assumed the measurements
          % obtained are deterministic and the interpolation between two
          % measurements is also deterministic.
          
          % INPUT:
          % t - integration time, scalar
          % sampled_accel - sampled acceleration measurements in 
          % IMU frame, 3xN
          
          % sampled_gyro -  sampled angular speed measurements in 
          % IMU frame, 3xN         

          % OUTPUT
          % dX(1:9) - rotation matrix derivative, 
          % dX(10:12) - velocity derivative, 3x1
          % dX(13:15) - position derivative, 3x1
          % dX(16:18) - gyroscope bias derivative, 3x1
          % dX(19:21) - acceleration bias derivate, 3x1

          global sampled_t g_world 
          
          % Initialize variables
          t;
          dX    = zeros(21,1); % Initialize state vector
          acc   = zeros(3,1); % interpolated acceleration values
          gyro  = zeros(3,1); % interpolated gyroscope values
          w_R_i = zeros(3,3); % Rotation matrix IMU with respect to world
          
          % Interpolate the acceleration and angular rate
          % at time t
          acc  = obj.interpolate_deterministic(sampled_t,sampled_accel,t);
          gyro = obj.interpolate_deterministic(sampled_t,sampled_gyro,t);
            
          % Define variables
          %------------------
          % i_n.gyro,3x1 - white noise gyroscope
          % i_n.acc, 3x1 - white noise acclerometer
          % i_b.gyro,3x1 - gyro bias in imu frame
          % i_b.acc, 3x1 - accelerometer bias in imu frame
          % w_R_i -  3x3 - Rotation matrix -- IMU with respect to world
          % v_w -    3x1 - velocity in world frame, 
          % p_w -    3x1 - position in world frame, 

          i_n.gyro = randn(3,1).*obj.SigmaWhite.gyro'; 
          i_n.acc  = randn(3,1).*obj.SigmaWhite.acc'; 
          i_b.gyro = X(16:18); % current gyro bias in imu frame
          i_b.acc  = X(19:21); % current accelerometer bias in imu frame
          v_w      = X(10:12); % Current velocity in world frame
          w_R_i    = ODE_Utility.form_rotation_mat(X); % 3x3 current rotation matrix
          S_w_imu  = MathFunctions.skew_mat(gyro - i_b.gyro - i_n.gyro); % 
          % IMU kinematic model with bias
          w_R_i_dot = w_R_i*S_w_imu; %3x3 
          v_w_dot   = w_R_i*(acc - i_b.acc - i_n.acc) - g_world; %3x1
          p_w_dot   = v_w; % 3x1 
          i_b_dot.gyro = obj.model_imu_bias(i_b.gyro,'g');   
          i_b_dot.acc = obj.model_imu_bias(i_b.acc,'a');
          
          % Form output of function
          dX(1:9) = ODE_Utility.form_state_vector(w_R_i_dot);
          dX(10:12) = v_w_dot;
          dX(13:15) = p_w_dot;
          dX(16:18) = i_b_dot.gyro;
          dX(19:21) = i_b_dot.acc;
        end
        
        function [b_dot] = model_imu_bias(obj,bias_curr,type)
           
           % IMU bias differential equation.
           % The model takes into account bias drift due to pink and brown 
           % noise simultaneously. The following equation is modeled for 
           % gyroscope and accelerometer. The type of sensor is provided 
           % as input to function:
           %
           % b_dot = -phi*b_current + N(0,sigma_pink) + N(0,sigma_brown)
           %
           % In case, one does not want to include pink
           % noise in the bias derivative, one has to define the following
           % parameters as zero:
           % tau = 0, SigmaPink = 0 in the IMU model properties
           % For modeling bias with brown noise only, tau is defined as 
           % infinity.
           
           % INPUT:
           % bias_curr - current value of bias - required for pink noise
           % based bias model
           % type - sensor type - gyroscope ('g') or accelerometer ('a')
           
           % OUTPUT:
           % b_dot - 3x1 - bias_derivate at current time.
          
           % Get model parameters.
           mp = obj.define_model_parameters();
          
           % Which sensor
           if type == 'g'
              phi = mp.phi_g;
              sigma_p = mp.sigma_p_gyro;
              sigma_b = mp.sigma_b_gyro;
           elseif type == 'a'
              phi = mp.phi_a;
              sigma_p = mp.sigma_p_acc;
              sigma_b = mp.sigma_b_acc;
           else 
              error('Wrong Inputs. Specify g or a in type');
           end
          
           % Define bias derivative 
           b_dot = -phi.*bias_curr + ...
                  randn(3,1).*sigma_p + ...
                  randn(3,1).*sigma_b;

        end
        
        
        %% IMU WITH NOISE AND BIAS WITH SDE NUMERICAL SCHEME
        %--------------------------------------------------------%
        % Ito's Stochastic Differential equation - general form
        % dX = F(X,t)dt + G(X,t)dW
        % F - drift function
        % G - diffusion function
        %
        % NOTE: dW/dt is not defined for random variables. So, Ito's
        % general form expresses them in differential elements and not
        % derivatives.
        
        % The object functions:
        % F = imu_drift_model_interp(obj,t,X,sampled_accel,sampled_gyro)
        % G = imu_diffusion_model_interp(obj,t,X,sampled_accel,sampled_gyro)
        % computes the F and G in the Ito's SDE with sampled measurements
        % by interpolating them at t. 
        %
        % The object functions 
        % F = imu_drift_model(obj,t,X,acc,gyro)
        % G = imu_diffusion_model(obj,t,X,accel,gyro)
        % computes the F and G in the Ito's SDE at given acceleration and 
        % gyroscope values. This is used inside interpolated drift and
        % diffusion models mentioned above.
        
        %  Drift and difusion with interpolated samples
        function F = imu_drift_model_interp(obj,...
                                            t,...
                                            X,...
                                            sampled_accel,...
                                            sampled_gyro)
            global sampled_t 
            t
            %Initialize
            F = zeros(21,1);
 
            % Linear interpolation sampled measurements
            acc = obj.interpolate_deterministic(sampled_t,sampled_accel,t);
            gyro = obj.interpolate_deterministic(sampled_t,sampled_gyro,t);
            
            F = obj.imu_drift_model(t,X,acc,gyro);
            
        end
        
        function G = imu_diffusion_model_interp(obj,...
                                                t,...
                                                X,...
                                                sampled_accel,...
                                                sampled_gyro)
            global sampled_t
            acc = obj.interpolate_deterministic(sampled_t,sampled_accel,t);                               
            gyro = obj.interpolate_deterministic(sampled_t,sampled_gyro,t);
            G = obj.imu_diffusion_model(t,X,acc,gyro);
        end
        
        
        function F = imu_drift_model(obj,t,X,acc,gyro)
            
            % INPUT:
            % X    - full state vector
            % acc  - acceleration value at time t
            % gyro - gyroscope value at time t
            
            
            % OUTPUT
            % dX(1:9)   - rotation matrix derivative, 
            % dX(10:12) - velocity derivative, 3x1
            % dX(13:15) - position derivative, 3x1
            % dX(16:18) - acceleration bias derivative, 3x1
            % dX(19:21) - gyro bias derivate, 3x1
            
            global g_world
            
            % Initialize
            w_R_i = zeros(3,3); % Rotation matrix IMU with respect to world
            F = zeros(21,1);
            
            % Define variables
            i_b.gyro = X(16:18); % gyro bias in imu frame
            i_b.acc = X(19:21); % accelerometer bias in imu frame
            v_w = X(10:12); % Current velocity in world frame
            w_R_i = ODE_Utility.form_rotation_mat(X); % 3x3 rotation matrix
            S_w_imu = MathFunctions.skew_mat(gyro);
            mp = obj.define_model_parameters(); 
            phi_g = mp.phi_g;
            phi_a = mp.phi_a;
            rad2deg(rotm2eul(w_R_i));
            % IMU drift model with bias
            w_R_i_dot = w_R_i*(S_w_imu-i_b.gyro); %3x3 
            v_w_dot = w_R_i*(acc-i_b.acc) - g_world; %3x1
            p_w_dot = v_w; % 3x1
            i_b_dot.gyro = -phi_g.*i_b.gyro;
            i_b_dot.acc = -phi_a.*i_b.acc;
            
            % Define output F
            F = [ODE_Utility.form_state_vector(w_R_i_dot);...
                 v_w_dot;...
                 p_w_dot;...
                 i_b_dot.gyro;...
                 i_b_dot.acc];
        end        
        
        function G = imu_diffusion_model(obj,t,X,accel,gyro)
            
            % INPUT:
            % X - full state vector
            
            % Initialize
            w_R_i = zeros(3,3); % Rotation matrix IMU with respect to world
            G = zeros(21,1);
            
            % Define variables
            w_R_i = ODE_Utility.form_rotation_mat(X); % 3x3 rotation matrix
            S_w_imu = MathFunctions.skew_mat(gyro);
            
            % White noise
            sig_w_g = obj.SigmaWhite.gyro';
            sig_w_a = obj.SigmaWhite.acc';
            
            % Pink noise
            sig_p_a = obj.SigmaPink.acc';
            sig_p_g = obj.SigmaPink.gyro';
            
            % Brown noise
            sig_b_g = obj.SigmaBrown.gyro';
            sig_b_a = obj.SigmaBrown.acc';
            
            % Diffusion model
            G = [ODE_Utility.form_state_vector(-w_R_i*S_w_imu*sig_w_g);...
                 -w_R_i*sig_w_a;... % velocity
                 zeros(3,1);... % position
                 sig_b_g + sig_p_g;... % gyroscope
                 sig_b_a + sig_p_a];   % accelerometer
        end
        
        %% Some Helper functions
        function [mp] = define_model_parameters(obj)
            % mp - model parameters - struct 
            mp.tau_a = obj.tau.acc'; %[3x1]
            mp.sigma_p_acc = obj.SigmaPink.acc'; %[3x1]
            mp.sigma_b_acc = obj.SigmaBrown.acc'; %[3x1]

            mp.tau_g = obj.tau.gyro'; %[3x1]
            mp.sigma_p_gyro = obj.SigmaPink.gyro'; %[3x1]
            mp.sigma_b_gyro = obj.SigmaBrown.gyro'; %[3x1]
            mp.phi_a = [0;0;0]; %[3x1]
            mp.phi_g = [0;0;0]; %[3x1]
            
            for i = 1:length(mp.phi_a)
                if isinf(mp.tau_a(i)) || mp.tau_a(i) == 0
                    % brown noise model
                    mp.phi_a(i) = 0 ;
                    if(mp.sigma_p_acc(i)~=0)
                        warning("Acceleration pink noise non-zero for"+...
                                "bias modeled with only brown noise."+...
                                "Setting pink noise zero");
                        mp.sigma_p_acc(i) = 0;
                    end
                else
                    % pink noise model
                    mp.phi_a(i) = 1/(mp.tau_a(i)); % scalar
                end
            end
            
            for i = 1:length(mp.phi_g)
                if isinf(mp.tau_g(i)) || mp.tau_g(i) == 0
                    % brown noise model only
                    mp.phi_g(i) = 0;  
                    if(mp.sigma_p_gyro(i)~=0)
                        warning("Gyroscope pink noise non-zero for"+...
                                "bias modeled with only brown noise."+...
                                "Setting pink noise zero");
                        mp.sigma_p_gyro = 0;
                    end

                else
                    % pink noise model + brown noise model
                    mp.phi_g(i) = (1/(mp.tau_g(i))); % scalar
                end
            end
        end
        
        function [interpolated] = interpolate_deterministic(obj,...
                                                            sampled_t,...
                                                            sampled_values,...
                                                            t_at)
          % Deterministic linear interpolation 
          % function interpolates between sampled measurements at time t_at
          
          % INPUT:
          % sampled_t      - Nx1 - vector of sampled times
          % sampled_values - Nx3 - sampled measurements in x,y,and z
          % direction
            interpolated = zeros(3,1);
            interpolated(1) = interp1(sampled_t,sampled_values(:,1),...
                                      t_at,'linear');% x
                                  
            interpolated(2) = interp1(sampled_t,sampled_values(:,2),...
                                      t_at,'linear');% y
                                  
            interpolated(3) = interp1(sampled_t,sampled_values(:,3),...
                                      t_at,'linear');% z
        end
        
    end
end



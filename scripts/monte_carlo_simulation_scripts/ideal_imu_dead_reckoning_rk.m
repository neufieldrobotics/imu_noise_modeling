clc
clear all
close all
global g_world del_t sampled_t

%% Define ground truth variables
fs = 200; % sampling rate of IMU
T = 1; % total time for which the motion happened
w = 2*pi; % angular speed in radians/sec
R = 1; % radius of circle in m
del_t = 1/fs;

% time column vector for which motion is to be computed
sampled_t = [0:del_t:T]'; 

% the column vector that represents the angle moved
theta = wrapTo2Pi(w*sampled_t); 

% acceleration due to gravity in world coordinate frame
g_world = [0;0;-9.81]; 

% World coordinate frame
% x - x axis of window
% y - y axis of window
% z - pointing outward from the plane of x and y by right hand rule
F_W = eye(3); % World frame


%% Define initial position and orientation of body 
%  with respect to world coordinate system
% column vector
initial_position_body = [R;0;0]; % at radius vector of the body 

% This is the coordinate axis of a typical IMU 
% when kept on a flat table 
% x - forward
% z - points downward
% y - by right hand rule.
%    [0.0000,    1.0000,    0.0000;
%     1.0000,   0.0000,   0.0000;
%        0,    0.0000,   -1.0000]
% {theta_z,theta_y,theta_x} - use zyx euler angles
initial_orientation_rotmat_body = eul2rotm([pi/2,0,pi],'ZYX'); 

%% Ideal IMU model - without any noise
% Define variables for acceleration of body in IMU frame 
% simulated for the circular motion

% Initialize the variables
sampled_angVel_imu = zeros(length(sampled_t),3); % in rad/s
sampled_acc_imu = zeros(length(sampled_t),3); % in m/s^2

% w about the z of IMU which points opposite to the world Z
% angVel_imu = -w; 
% IMU is rotating in counter clockwise in world coordinate system, 
% but clockwise in IMU local coordinate system
sampled_angVel_imu(:,3) = -w; % rad/s in IMU frame

% this is the acceleration reported by IMU in y axis - IMU frame
% Offset due to acceleration due to gravity in IMU frame. 
% The IMU gives a negative value in imu z direction which means
% it experiences acceleration in upward direction. (in world frame)
% This is due to the force that is pulling the 
% mass inside IMU in upward direction. 
% The force balance equations has to be solved in
% IMU frame and the final answer must be in IMU frame. 

% Transposing to set the row vector of acceleration
% nx3 matrix - 1x3 vector = nx3 vector,
% 3x1 vector subtracted from each row. 
sampled_acc_imu(:,2) = -w^2 * R; % acceleration of the body in y axis 
sampled_acc_imu =  sampled_acc_imu + ...
                    (initial_orientation_rotmat_body*g_world)';

% Initial velocity column vector of body in IMU frame. 
init_vel_imu = [w*R; 0; 0];

%% define acceleration,velocity and position in world frame
w_R_i_0 = initial_orientation_rotmat_body;
v_w_0 = w_R_i_0*init_vel_imu;
p_w_0 = initial_position_body;

%initial_orientation = quat2eul(orientationNED(1,:))';

%% RK integration
tspan = [0,T];
opts = odeset('RelTol',1e-2,...
              'AbsTol',1e-4,...
              'MaxStep',del_t,...
              'Stats','on',...
              'OutputFcn',[]);

% Intial condition 
% ic - 15x1 column vector
ic = [w_R_i_0(1,:)';... % first row of rotation matrix
      w_R_i_0(2,:)';... % second row of rotation matrix
      w_R_i_0(3,:)';... % third row of rotation matrix
      v_w_0;...        % start velocity 
      p_w_0];          % start position
  
% State vector x is 15x1
%     X = [w_rot_i(1,:),
%          w_rot_i(2,:),
%          w_rot_i(3,:),
%          w_v,
%          w_p]
vn100 = IMU_Model;
[t,X] = ode45(@(t,X) vn100.ideal_imu_odometry_model(t,...
                                                   X,...
                                                   sampled_acc_imu,...
                                                   sampled_angVel_imu),...
                                                   tspan,...
                                                   ic,...
                                                   opts);
% w_R_i - Rotation matrix -- IMU with respect to world, 3x3
% v_w - velocity in world frame, 3x1
% p_w - position in world frame, 3x1

w_R_i = zeros(3,3,length(t));
v_w = X(:,10:12);
p_w = X(:,13:15);
for i = 1:length(t)
    w_R_i(:,:,i) = ODE_Utility.form_rotation_mat(X(i,:)');
end

euler_angle = zeros(length(t),3);
for i = 1:length(t)
    euler_angle(i,:) = rad2deg(rotm2eul(w_R_i(:,:,i)));
end

% plot the path
figure(1);
plot(p_w(:,1),p_w(:,2));
xlabel('World Frame X in m');
ylabel('World Frame Y in m');
title('Circular Motion - radius 1 m');
grid on;
grid minor
axis equal;

% plot velocity
figure(2);
plot(t,v_w);
grid on; grid minor;
legend('vx','vy','vz');
title('Velocity (m/s) in world frame - Circular motion - R - 1 m');
xlabel('time(s)');ylabel('velocity (m/s)');

% plot angle
figure(3);
plot(t,(euler_angle(:,1)));
grid on; grid minor;
legend('Theta');
title('Angle with x in world frame - Circular motion - R - 1 m');
xlabel('time(s)');ylabel('Theta (degrees)');
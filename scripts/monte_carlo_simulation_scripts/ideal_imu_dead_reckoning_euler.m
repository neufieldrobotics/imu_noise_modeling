clc
clear all
close all
%% Define ground truth variables
global g_world;
fs = 1000; % sampling rate of IMU
T = 5; % total time for which the motion happened
w = 2*pi; % angular speed in radians/sec
R = 1; % radius of circle in m
t = 0:1/fs:T; % time vector for which motion is to be computed
theta = wrapTo2Pi(w*t); % the vector that represents the angle moved
g_world = [0,0,-9.81]; % acceleration due to gravity in world coordinate frame

% World coordinate frame
% x - x axis of window
% y - y axis of window
% z - pointing outward from the plane of x and y by right hand rule
F_W = eye(3); % World frame


%% Define initial position and orientation of body 
%  with respect to world coordinate system
initial_position_body = [R,0,0]; % at radius vector of the body 

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
angVel_imu = zeros(length(t),3); % in rad/s
acc_imu = zeros(length(t),3); % in m/s^2

% w about the z of IMU which points opposite to the world Z
% angVel_imu = -w; 
% IMU is rotating in counter clockwise in world coordinate syste, 
% but clockwise in IMU local coordinate system
angVel_imu(:,3) = -w; % rad/s in IMU frame

% this is the acceleration reported by IMU in y axis - IMU frame
acc_imu(:,2) = -w^2 * R; % acceleration of the body in y axis 

% Offset due to acceleration due to gravity in IMU frame. 
% The IMU gives a negative value in z direction which means
% it experiences acceleration in upward direction. 
% This is due to the force that is pulling the 
% mass inside IMU in upward direction. 
% The force balance equations has to be solved in
% IMU frame and the final answer must be in IMU frame. 

% Transposing to set the row vector of acceleration
% nx3 matrix - 1x3 vector = nx3 vector,
% 1x3 vector subtracted from each row. 
acc_imu =  acc_imu +(initial_orientation_rotmat_body*g_world')';

% Initial velocity of body in IMU frame. 
init_vel_imu = [w*R, 0, 0];

%% Plot the intital conditions 
figure
plt = Plot_Utility;
plt.axis_length = 0.1;

% Plot world origin
plt.plot_pose3([0,0,0],...
                F_W); 

% Plot IMU origin
plt.plot_pose3(initial_position_body,...
               initial_orientation_rotmat_body);
                
viscircles([0 0],1,...
           'Color',[1 0.65 0],...
           'LineWidth',1,...
           'LineStyle',':');

axis equal 
axis([-1.25 1.25 -1.25 1.25 -.5 .5])
text(0,-0.025,0,'World')
text(initial_position_body(1),...
    initial_position_body(2)-0.025,...
    initial_position_body(3),'Imu')


%% IMU integration
del_t = 1/fs; % sample time

%% define acceleration,velocity and position in world frame
acc_wA = zeros(length(acc_imu),3);
velocity_wV = zeros(length(acc_imu),3);
position_wP = zeros(length(acc_imu),3);

rot_curr_wRi = initial_orientation_rotmat_body;
vel_curr_wV = rot_curr_wRi*init_vel_imu';
pos_curr_wP = initial_position_body';

%initial_orientation = quat2eul(orientationNED(1,:))';

%% IMU odometry model - Euler Integration
for i = 1:length(t)

[rot_curr_wRi, acc_cur, vel_curr_wV,pos_curr_wP] = imu_step(angVel_imu(i,:)',...
                                                            acc_imu(i,:)',...
                                                            rot_curr_wRi,...
                                                            vel_curr_wV,...
                                                            pos_curr_wP,...
                                                            del_t);
acc_wA(i,:) = acc_cur;
euler_angle(i,:) = rotm2eul(rot_curr_wRi);
velocity_wV(i,:) = vel_curr_wV;
position_wP(i,:) = pos_curr_wP;
end

figure
plot(position_wP(:,1),position_wP(:,2),'.')
grid on;
grid minor;
axis equal

figure
plot3(position_wP(:,1),position_wP(:,2),position_wP(:,3));
grid on;
grid minor;
axis equal 

function h = skew_mat(x)
    h=[0 -x(3) x(2) ; x(3) 0 -x(1) ; -x(2) x(1) 0 ];
end

function [rot, acc_wA,vel_wV,pos_wP] = imu_step(gyro,...
                                                accel,...
                                                rot_curr,...
                                                vel_curr,...
                                                pos_curr,...
                                                del_t)
    global g_world;
    S_w_imu = skew_mat(gyro);
    rot = rot_curr * expm(S_w_imu * del_t);
    acc_wA = rot * accel - g_world';
    vel_wV = vel_curr + acc_wA * del_t; % 
    
    % The integration of position takes previous velocity and current
    % velocity
    pos_wP = pos_curr + vel_curr * del_t+ .5 * acc_wA * del_t^2;
end



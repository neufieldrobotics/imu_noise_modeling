function [gyro, accel] = simulate_trajectory_motion(VN100_Params, Traj_Params)

%N_accel, ect are 1x3 arrays with x, y, z
N_accel = [VN100_Params.accel.x(1), VN100_Params.accel.y(1), VN100_Params.accel.z(1)]; 
K_accel = [VN100_Params.accel.x(2), VN100_Params.accel.y(2), VN100_Params.accel.z(2)];
B_accel = [VN100_Params.accel.x(3), VN100_Params.accel.y(3), VN100_Params.accel.z(3)];

N_gyro = [VN100_Params.gyro.x(1), VN100_Params.gyro.y(1), VN100_Params.gyro.z(1)]; 
K_gyro = [VN100_Params.gyro.x(2), VN100_Params.gyro.y(2), VN100_Params.gyro.z(2)];
B_gyro = [VN100_Params.gyro.x(3), VN100_Params.gyro.y(3), VN100_Params.gyro.z(3)];

%% Generate Trajectory
waypoints = Traj_Params.Trajectory.Waypoints;
toa = Traj_Params.Trajectory.toa;
trajectory = waypointTrajectory(waypoints,toa,'SampleRate',400);

position = zeros(toa(end)*trajectory.SampleRate,3);
orientation = zeros(toa(end)*trajectory.SampleRate,1,'quaternion');
velocity = zeros(toa(end)*trajectory.SampleRate,3);
acceleration = zeros(toa(end)*trajectory.SampleRate,3);
angular_velocity = zeros(toa(end)*trajectory.SampleRate,3);
count = 1;
while ~isDone(trajectory)
   [position(count,:),orientation(count,:),velocity(count,:),acceleration(count,:),angular_velocity(count,:)] = trajectory();
   count = count + 1;
end

%% Simulate Noise/Bias
del_t = toa(end)/trajectory.SampleRate;
var_white_accel = N_accel;
var_brown_accel = K_accel;
var_pink_accel = B_accel;

var_white_gyro = N_gyro;
var_brown_gyro = K_gyro;
var_pink_gyro = B_gyro;

n_a_accel = var_white_accel.*randn(length(acceleration),3);
n_ba_accel = var_brown_accel.*randn(length(acceleration),3);
n_pa_accel = var_pink_accel.*randn(length(acceleration),3);
n_a_gyro = var_white_gyro.*randn(length(acceleration),3);
n_ba_gyro = var_brown_gyro.*randn(length(acceleration),3);
n_pa_gyro = var_pink_gyro.*randn(length(acceleration),3);

tau_b_accel = 3;
phi_accel = exp(-1/tau_b_accel*del_t);
b_o_accel = (var_brown_accel*tau_b_accel/2)*randn(3);

tau_b_gyro = 3;
phi_gyro = exp(-1/tau_b_gyro*del_t);
b_o_gyro = (var_brown_gyro*tau_b_gyro/2)*randn(3);

b_accel = zeros(length(acceleration),3);
b_gyro = zeros(length(acceleration),3);



for i = 1:length(acceleration)
    
    if i == 1
        b_accel(i,:) = b_o_accel;
        b_gyro(i,:) = b_o_gyro;
    else
        b_accel(i,:) = phi_accel*b_accel(i-1,:) + n_ba_accel(i,:) + n_pa_accel(i,:);
        b_gyro(i,:) = phi_gyro*b_gyro(i-1,:) + n_ba_gyro(i,:) + n_pa_gyro(i,:);
    end
end

g_world = [0,0,9.81];
eul_orient = zeros(length(orientation),3);
for i = 1:length(orientation)
    eul_orient(i,:) = quat2eul(orientation(i,:));
end
%% IMU Model
gyro = angular_velocity + b_gyro + n_a_gyro;
accel = acceleration + b_accel + n_a_accel + eul_orient.*g_world;

figure(1)
plot(gyro)
title('Simulated Gyro Data')
legend('x','y','z')
xlabel('measurement')
ylabel('rad/sec')
figure(2)
plot(accel)
title('Simulated Accel Data')
legend('x','y','z')
xlabel('measurement')
ylabel('m/sec2')
figure(3)
plot(position(:,1),position(:,2))
title('Simulated Position')
xlabel('x (m)')
ylabel('y (m)')

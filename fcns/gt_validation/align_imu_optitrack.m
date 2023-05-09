config_gt_optitrack;

% % Load data
% if measurement_coordinate_system == 'EUROC_LEICA'
%         optitrack = read_Leica_csv(fullfile(data_folder,optitrack_file));
% elseif measurement_coordinate_system == 'NEUFR_OPTITRACK'
%         optitrack = read_optitrack_csv(optitrack_full_file,...
%                         start_time_for_optitrack);
% end

optitrack = read_optitrack_csv(optitrack_full_file,start_time_for_optitrack);
imu_data  = load(imu_data_full_file);
uncompensated_imu_data = imu_data.robot.imu_data_uncompensated;
rpy_data = imu_data.robot.rpy_data;

% find indices of optitrack data that correspond to IMU data (we may have
% left optitrack data running for multiple runs of IMU collections)
timestamps_index = find(optitrack.msg_time >= rpy_data.msg_time(100) & ...
                        optitrack.msg_time <= rpy_data.msg_time(end));
                    
% Clip optitrack data to segment matching IMU data
[t_opti, X_opti] = slice_and_form_mat(optitrack,timestamps_index);

% Transform optitrack data to World frame
% [timestamp, q, pos]
[gt_pose_transformed,quat_available] = Transform_Frame([t_opti,X_opti],W_T_M,R_T_IMU);

% Get Euler angles in World frame from optitrack quaternion
euler_angle_gt_transformed = to_euler([gt_pose_transformed(:,8),...
                                       gt_pose_transformed(:,5:7)]); %xyz

                                   
% Plotting
plot_metadata.title_3d_position = 'Movement in 3D world - actual data';
plot_metadata.title_angle = 'Optitrack - XYZ euler angle in degrees ';
plot_metadata.title_position = 'Optitrack - position in optitrack frame - y up';
plot_metadata.view_vector = [-1,0.1,.2];
plot_data(1,gt_pose_transformed(:,1),...
            gt_pose_transformed(:,2:4),...
            euler_angle_gt_transformed,...
            plot_metadata);

% time relative to first step

% temporaly align acc and rpy data
[acc_mat, rpy_mat, relative_time_acc, relative_time_rpy] = align_acc_w_rpy(rpy_data, uncompensated_imu_data);


% In euler angles, the NED frame is with z facing down. So, the angle
% measured in NED frame is negative of the angle measured in world frame
% where z is pointing up. 
% Same reasoning for y axis
% euler_angles_321_ypr = [-rpy_data.vector_z,...
%                         -rpy_data.vector_y,...
%                         rpy_data.vector_x];

% rpy_mat = [rpy_data.vector_x';rpy_data.vector_y';rpy_data.vector_z'];
% acc_mat = [uncompensated_imu_data.acceleration_x';...
%        uncompensated_imu_data.acceleration_y';...
%        uncompensated_imu_data.acceleration_z'];
%        
% relative_time_rpy = rpy_data.msg_time - rpy_data.msg_time(1);
% relative_time_acc = uncompensated_imu_data.msg_time - uncompensated_imu_data.msg_time(1);
% 
euler_angles_321_ypr = [-rpy_mat(3,:)',...%-rpy_data.vector_z,...
                        -rpy_mat(2,:)',...%-rpy_data.vector_y,...
                        rpy_mat(1,:)'];%rpy_data.vector_x];

                    
[M,N] = size(euler_angles_321_ypr);

% Transform IMU data into World frame
transformed_euler_angles_ypr_321 = zeros(M,N);
transformed_acc = zeros(M,N);
for i = 1:M
    NED_R_IMU = eul2rotm(euler_angles_321_ypr(i,:),'ZYX');
    W_R_IMU = W_T_NED(1:3,1:3)*NED_R_IMU;
    transformed_acc(i,:) = W_R_IMU(1:3,1:3)*acc_mat(:,i);
    transformed_euler_angles_ypr_321(i,:) = rotm2eul(W_R_IMU,'ZYX');
end

%X
h = figure();  
subplot(3,1,1)
plot(relative_time_rpy,...
    rad2deg(wrapTo2Pi(transformed_euler_angles_ypr_321(:,3))),...
    '-b','LineWidth',width);
hold on
plot(gt_pose_transformed(:,1)-gt_pose_transformed(1,1),...
    (euler_angle_gt_transformed(:,1)),...
    '--r','LineWidth',width);
title("YPR angles","FontSize",fontsize);
xlabel("t (s)","FontSize",fontsize);
ylabel("roll (degrees)","FontSize",fontsize)
ylim([0,360])
grid on
grid minor 
legend("euler angles IMU","euler angles GT")

%Y
subplot(3,1,2)
plot(relative_time_rpy,...
    rad2deg(transformed_euler_angles_ypr_321(:,2)),...
    '-b','LineWidth',width);
hold on
plot(gt_pose_transformed(:,1)-gt_pose_transformed(1,1),...
    unwrap(euler_angle_gt_transformed(:,2)),...
    '--r','LineWidth',width);
xlabel("t (s)","FontSize",fontsize);
ylabel("pitch (degrees)","FontSize",fontsize);
legend("euler angles IMU","euler angles GT")

grid on
grid minor 

% Z
subplot(3,1,3)
plot(relative_time_rpy,...
    rad2deg(wrapTo2Pi(transformed_euler_angles_ypr_321(:,1))),...
    '-b','LineWidth',width);
hold on
plot(gt_pose_transformed(:,1)-gt_pose_transformed(1,1),...
    euler_angle_gt_transformed(:,3),...
    '--r','LineWidth',width);
xlabel("t (s)","FontSize",fontsize);
ylabel("yaw (degrees)","FontSize",fontsize)
legend("euler angles IMU","euler angles GT")

grid on
grid minor 


h = figure();


subplot(3,1,1)
plot(relative_time_acc,transformed_acc(:,1))
title("acclerometer data")
xlabel("t (s)");
ylabel("x (m/s^2)")
grid on
grid minor 

subplot(3,1,2)
plot(relative_time_acc(1:M),transformed_acc(:,2));
xlabel("t (s)");
ylabel("y (m/s^2)")
grid on
grid minor 

subplot(3,1,3)
plot(relative_time_acc(1:M),transformed_acc(:,3))
xlabel("t (s)");
ylabel("z (m/s^2)")
grid on
grid minor 


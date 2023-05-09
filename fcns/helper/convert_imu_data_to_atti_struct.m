function imu_atti_struct = convert_imu_data_to_atti_struct(voxl_data,start_time,time_shift)
       
       % We recorded measurements in relative to local NED frame in the
       % driver. Driver used https://github.com/dawonn/vectornav/blob/master/src/main.cpp

       time_inds = find(voxl_data.robot.imu_modified_time.msg_time >= start_time);
       imu_atti_struct.comment = strcat("world-x-forward, y-left, z - up, ",...
                                   "acc_imu - accleration in imu frame, ",...
                                       "quat - [qw,qx,qy,qz]");
       
       imu_atti_struct.time = voxl_data.robot.imu_modified_time.msg_time(time_inds) - time_shift;
       imu_atti_struct.start_time = imu_atti_struct.time(1);
       imu_atti_struct.acc_imu = [voxl_data.robot.imu_modified_time.acceleration_x(time_inds),...
                                  voxl_data.robot.imu_modified_time.acceleration_y(time_inds),...
                                  voxl_data.robot.imu_modified_time.acceleration_z(time_inds)];
                              
       imu_atti_struct.orientation_quat_NED = [voxl_data.robot.imu_modified_time.orientation_quat_w(time_inds),...
                                               voxl_data.robot.imu_modified_time.orientation_quat_x(time_inds),...
                                               voxl_data.robot.imu_modified_time.orientation_quat_y(time_inds),...
                                               voxl_data.robot.imu_modified_time.orientation_quat_z(time_inds)];
       
%        % option 1 - no transform
%        rotm_same = eye(3);
%        quat_same = rotm2quat(rotm_same);
       
       % option 2 - NED to ROS
       
       %euler_angle_NED_to_ROS = [0,0,pi]; %ypr if NED is FRD. used earlier
       %gave offset.
       euler_angle_NED_to_ROS = [2*pi/3,0,pi]; %ypr if NED is FRD.
       % BUT NED is global frame 
       % There is a constant yaw offset of NED - north direction to local world.
       % also offset in the initial pitch in y and roll x need to be corrected.
       % of NED to world to zero align everything. Determined manually
       % later on but set here. 
       rotm_NED2ROS = eul2rotm(euler_angle_NED_to_ROS,'ZYX'); % equal to W_T_NED(1:3,1:3)
       quat_NED2ROS = eul2quat(euler_angle_NED_to_ROS,'ZYX');
       
%        % option 3 - ENU to ROS
%        euler_angle_ENU_to_ROS = [pi/2,0,0]; %ypr
%        rotm_ENU2ROS = eul2rotm(euler_angle_ENU_to_ROS,'ZYX'); % equal to W_T_NED(1:3,1:3)
%        quat_ENU2ROS = eul2quat(euler_angle_ENU_to_ROS,'ZYX');
       
       quat = quat_NED2ROS;
       rotm = rotm_NED2ROS;
       imu_atti_struct.orientation_quat_W = quatmultiply(quat,imu_atti_struct.orientation_quat_NED);
       imu_atti_struct.euler_angle_W_ZYX = quat2eul(imu_atti_struct.orientation_quat_W,'ZYX'); % radians
       
       % donot convert accleration to world frame here because there is offset angle in roll,pitch and yaw.      
end
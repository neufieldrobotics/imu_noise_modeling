function [b,offset_angles] = determine_bias_and_initial_angles(Data_ypr_dead_reckoning,...
                                                               t_start,t_end)
    global g_world
    imu_inds = find(Data_ypr_dead_reckoning.IMU.time >= t_start & ...
                Data_ypr_dead_reckoning.IMU.time <= t_end);
            
    gt_inds = find(Data_ypr_dead_reckoning.gt.time >= t_start & ...
                Data_ypr_dead_reckoning.gt.time <= t_end);
                
    b.x = mean(Data_ypr_dead_reckoning.IMU.acc_w(imu_inds,1));
    b.y = mean(Data_ypr_dead_reckoning.IMU.acc_w(imu_inds,2));
    b.z = mean(Data_ypr_dead_reckoning.IMU.acc_w(imu_inds,3))+g_world(3);
    % todo: Define global constants in a file like script-paths
    
    offset_angles.x = mean(Data_ypr_dead_reckoning.gt.euler_angles_w(gt_inds,1)) - ...
                      mean(Data_ypr_dead_reckoning.IMU.euler_angles_rpy_w(imu_inds,1));
                  
    offset_angles.y = mean(Data_ypr_dead_reckoning.gt.euler_angles_w(gt_inds,2)) - ...
                      mean(Data_ypr_dead_reckoning.IMU.euler_angles_rpy_w(imu_inds,2));
                  
    offset_angles.z = mean(Data_ypr_dead_reckoning.gt.euler_angles_w(gt_inds,3)) - ...
                      mean(Data_ypr_dead_reckoning.IMU.euler_angles_rpy_w(imu_inds,3));
end
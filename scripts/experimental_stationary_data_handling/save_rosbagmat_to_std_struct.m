clear all
close all
rosbagmat_path = "~/datasets/voxl_logs/stationary_imu";
filename = "voxl-static-imu-data_2022-02-13-02-42-11.mat";

fullfile_path = fullfile(rosbagmat_path,filename);
load(fullfile_path)
VOXL_IMU0 = convert_rosbagmat_to_std_struct(robot.imu_data0);
VOXL_IMU1 = convert_rosbagmat_to_std_struct(robot.imu_data1);

save("~/datasets/voxl_logs/stationary_imu/voxl_imu0.mat","VOXL_IMU0")
save("~/datasets/voxl_logs/stationary_imu/voxl_imu1.mat","VOXL_IMU1")

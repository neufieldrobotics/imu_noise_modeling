function imu_struct = convert_euroc_IMU_data_to_IMU_struct(euroc_imu_data_matrix)
    NANOSEC_TO_SEC = 1e-9;
    imu_struct.time = euroc_imu_data_matrix(:,1)*NANOSEC_TO_SEC;
    imu_struct.angular_velocity_x = euroc_imu_data_matrix(:,2);
    imu_struct.angular_velocity_y = euroc_imu_data_matrix(:,3);
    imu_struct.angular_velocity_z = euroc_imu_data_matrix(:,4);
    imu_struct.acceleration_x = euroc_imu_data_matrix(:,5);
    imu_struct.acceleration_y = euroc_imu_data_matrix(:,6);
    imu_struct.acceleration_z = euroc_imu_data_matrix(:,7);
    
end
function [TUM] = convert_TUM_to_std_struct(TUM_npy_struct)
%CONVERT_TUM_TO_STD_STRUCT Summary of this function goes here
%   Detailed explanation goes here
    TUM.fs = TUM_npy_struct.fs_hz;
    TUM.comment = strcat(num2str(TUM_npy_struct.duration_hr)," hr");
    TUM.Data.time = TUM_npy_struct.timestamp';
    TUM.Data.acceleration_x = TUM_npy_struct.accel_x';
    TUM.Data.acceleration_y = TUM_npy_struct.accel_y';
    TUM.Data.acceleration_z = TUM_npy_struct.accel_z';
    TUM.Data.angular_velocity_x = TUM_npy_struct.gyro_x';
    TUM.Data.angular_velocity_y = TUM_npy_struct.gyro_y';
    TUM.Data.angular_velocity_z = TUM_npy_struct.gyro_z';
    TUM.Data.temperature = TUM_npy_struct.temperature;
end


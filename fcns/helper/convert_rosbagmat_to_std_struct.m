function [std_struct] = convert_rosbagmat_to_std_struct(rosbagmat)
%CONVERT_EUROC_TO_STD_STRUCT Summary of this function goes here
%   Detailed explanation goes here
    total_time = rosbagmat.msg_time(end)- rosbagmat.msg_time(1);
    nrows = length(rosbagmat.msg_time);
    std_struct.fs = nrows/total_time;
    std_struct.comment = strcat(num2str(total_time/3600), ' hr');
    std_struct.Data.time = rosbagmat.msg_time;
    std_struct.Data.acceleration_x = rosbagmat.acceleration_x;
    std_struct.Data.acceleration_y = rosbagmat.acceleration_y;
    std_struct.Data.acceleration_z = rosbagmat.acceleration_z;
    std_struct.Data.angular_velocity_x = rosbagmat.angular_velocity_x;
    std_struct.Data.angular_velocity_y = rosbagmat.angular_velocity_y;
    std_struct.Data.angular_velocity_z = rosbagmat.angular_velocity_z;
end
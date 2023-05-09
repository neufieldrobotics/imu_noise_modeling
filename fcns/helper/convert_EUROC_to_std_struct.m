function [EUROC] = convert_EUROC_to_std_struct(euroc_data,type)
%CONVERT_EUROC_TO_STD_STRUCT Summary of this function goes here
%   Detailed explanation goes here
    NANOSEC_TO_SEC = 1e-9;
    [nrows,ncols] = size(euroc_data);
    total_time = (euroc_data(end,1) - euroc_data(1,1))*NANOSEC_TO_SEC;
    EUROC.fs = nrows/total_time;
    EUROC.comment = strcat(num2str(total_time/3600), ' hr');
    EUROC.Data.time = euroc_data(:,1);
    fprintf("Type of data input : %s \n",type)
    if type=="kalibr_allan"  
        EUROC.Data.acceleration_x = euroc_data(:,2);
        EUROC.Data.acceleration_y = euroc_data(:,3);
        EUROC.Data.acceleration_z = euroc_data(:,4);
        EUROC.Data.angular_velocity_x = euroc_data(:,5);
        EUROC.Data.angular_velocity_y = euroc_data(:,6);
        EUROC.Data.angular_velocity_z = euroc_data(:,7);
    elseif type=="imu-log-euroc"
        EUROC.Data.angular_velocity_x = euroc_data(:,2);
        EUROC.Data.angular_velocity_y = euroc_data(:,3);
        EUROC.Data.angular_velocity_z = euroc_data(:,4);
        EUROC.Data.acceleration_x = euroc_data(:,5);
        EUROC.Data.acceleration_y = euroc_data(:,6);
        EUROC.Data.acceleration_z = euroc_data(:,7);
    end
end


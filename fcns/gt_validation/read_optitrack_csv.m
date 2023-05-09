function optitrack_data = read_optitrack_csv(filename,start_time_string)
    t = datetime(start_time_string,...
                'InputFormat','yyyy-MM-dd hh.mm.ss.SSS a',...
                'TimeZone','local');
    t_utc = datetime(t,'TimeZone','UTC');
                
    unix_time = posixtime(t_utc); %% seconds.milliseconds
    A = readmatrix(filename);
    time_index = (~isnan(A(:,3)) | ~isnan(A(:,4)) |...
                    ~isnan(A(:,5)) | ~isnan(A(:,6)) |...
                    ~isnan(A(:,7)) | ~isnan(A(:,8)) | ...
                    ~isnan(A(:,9)));
    
    % Retrieve the data which is good
    
    good_data = A(time_index,:);
    
    % Edit time stamps 
    new_timestamp = good_data(:,2) + unix_time;
    good_data(:,2) = new_timestamp;
    optitrack_data.msg_time = new_timestamp;
    optitrack_data.position_x = good_data(:,7);
    optitrack_data.position_y = good_data(:,8);
    optitrack_data.position_z = good_data(:,9);
    optitrack_data.orientation_quat_x = good_data(:,3);
    optitrack_data.orientation_quat_y = good_data(:,4);
    optitrack_data.orientation_quat_z = good_data(:,5);
    optitrack_data.orientation_quat_w = good_data(:,6);
end
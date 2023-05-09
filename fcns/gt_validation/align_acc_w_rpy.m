% function [acc_mat, ypr_mat, relative_time_acc, relative_time_rpy] = align_acc_w_rpy(ypr_data, uncompensated_imu_data)
function [acc_mat, ypr_mat, unix_time_imu] = align_acc_w_rpy(ypr_data, uncompensated_imu_data)
% INPUT:
% rpy_data - (struct) the rpy state estimate data from VN100 output
% uncompensated_imu_data (struct) raw imu data

% OUTPUT:
% acc_mat (n x 3) x,y,z accelerometer data
% rpy_mat (n x 3) r,p,y data
% relative_time_acc

    len_acc = length(uncompensated_imu_data.msg_time);
    len_rpy = length(ypr_data.msg_time);
    if uncompensated_imu_data.msg_time(1)>=ypr_data.msg_time(1)
        time_start = uncompensated_imu_data.msg_time(1);
    else
        time_start = ypr_data.msg_time(1);
    end
    
    if uncompensated_imu_data.msg_time(end)<=ypr_data.msg_time(end)
        time_end = uncompensated_imu_data.msg_time(end);
    else
        time_end = ypr_data.msg_time(end);
    end
    
    acc_inds = find(uncompensated_imu_data.msg_time >= time_start & ...
                            uncompensated_imu_data.msg_time <= time_end);
    ypr_inds = find(ypr_data.msg_time >= time_start & ...
                            ypr_data.msg_time <= time_end);
   
    acc_mat = [uncompensated_imu_data.acceleration_x(acc_inds),...
               uncompensated_imu_data.acceleration_y(acc_inds),...
               uncompensated_imu_data.acceleration_z(acc_inds)];
           
    ypr_mat = [ypr_data.vector_z(ypr_inds),...
               ypr_data.vector_y(ypr_inds),...
               ypr_data.vector_x(ypr_inds)];
    M1 = length(acc_inds);
    M2 = length(ypr_inds);
    M = min(M1,M2);
    if M1 <= M2
        unix_time_imu = uncompensated_imu_data.msg_time(acc_inds);
    else
        unix_time_imu = ypr_data.msg_time(ypr_inds);
    end
    ypr_mat = ypr_mat(1:M,:);
    acc_mat = acc_mat(1:M,:);
%     if len_acc ~= len_rpy
%         if len_acc > len_rpy
%             % If raw imu data is longer than rpy, trim raw imu data
%             % to match rpy
%             acc_inds = find(uncompensated_imu_data.msg_time >= ypr_data.msg_time(1) & ...
%                             uncompensated_imu_data.msg_time <= ypr_data.msg_time(end));
% 
%             ypr_mat = [ypr_data.vector_z,ypr_data.vector_y,ypr_data.vector_x];
% 
%             relative_time_rpy = ypr_data.msg_time - ypr_data.msg_time(1);
% 
%             acc_mat = [uncompensated_imu_data.acceleration_x(acc_inds),...
%                uncompensated_imu_data.acceleration_y(acc_inds),...
%                uncompensated_imu_data.acceleration_z(acc_inds)];
% 
%            relative_time_acc = uncompensated_imu_data.msg_time - uncompensated_imu_data.msg_time(1);
%            relative_time_acc = relative_time_acc(acc_inds);
% 
%         else 
%             % If rpy data is longer than raw imu data, trim rpy data to match raw imu data
%             rpy_inds = find(ypr_data.msg_time >= uncompensated_imu_data.msg_time(1) & ...
%                             ypr_data.msg_time <= uncompensated_imu_data.msg_time(end));
% 
%             ypr_mat = [ypr_data.vector_z(rpy_inds),ypr_data.vector_y(rpy_inds),ypr_data.vector_x(rpy_inds)];
% 
%             relative_time_rpy = ypr_data.msg_time;
% 
%             relative_time_rpy = relative_time_rpy(rpy_inds) - relative_time_rpy(rpy_inds(1));
% 
%             acc_mat = [uncompensated_imu_data.acceleration_x,...
%                uncompensated_imu_data.acceleration_y,...
%                uncompensated_imu_data.acceleration_z];
% 
%            relative_time_acc = uncompensated_imu_data.msg_time - uncompensated_imu_data.msg_time(1);
% 
%         end
%     else
%         % If state estimate data and raw imu data are already the same length,
%         % dont trim, just save
%         ypr_mat = [ypr_data.vector_z,ypr_data.vector_y,ypr_data.vector_x];
%         acc_mat = [uncompensated_imu_data.acceleration_x,...
%                uncompensated_imu_data.acceleration_y,...
%                uncompensated_imu_data.acceleration_z];
% 
%         relative_time_rpy = ypr_data.msg_time - ypr_data.msg_time(1);
%         relative_time_acc = uncompensated_imu_data.msg_time - uncompensated_imu_data.msg_time(1);
%     end
end


function dr_struct = compile_dead_reckoning_struct(time_inds_vio,vinsmono_vio_struct,...
                                                   time_inds_mvvislam, mvvislam_struct,...
                                                   time_inds_raw_imu,raw_imu_struct,...
                                                   time_inds_atti_imu,atti_imu_struct,...
                                                   time_inds_gt,gt_data_struct)
    % todo check if they are empty
    
    if (isempty(time_inds_mvvislam) && isempty(mvvislam_struct))
        disp("no data for mv vislam, making empty struct");
        dr_struct.mv_vio = struct();
    else 
        dr_struct.mv_vio.comment = 'quaternion q - [qw,qx,qy,qz], position p - [px,py,pz], bias b - [bx,by,bz]';
        dr_struct.mv_vio.start_time = mvvislam_struct.time(time_inds_mvvislam(1));
        dr_struct.mv_vio.time_segment = mvvislam_struct.time(time_inds_mvvislam); %vector
        dr_struct.mv_vio.start_pose.p_x = mvvislam_struct.p_x(time_inds_mvvislam(1));
        dr_struct.mv_vio.start_pose.p_y = mvvislam_struct.p_y(time_inds_mvvislam(1));
        dr_struct.mv_vio.start_pose.p_z = mvvislam_struct.p_z(time_inds_mvvislam(1));
        dr_struct.mv_vio.start_pose.q_x = mvvislam_struct.q_x(time_inds_mvvislam(1));
        dr_struct.mv_vio.start_pose.q_y = mvvislam_struct.q_y(time_inds_mvvislam(1));
        dr_struct.mv_vio.start_pose.q_z = mvvislam_struct.q_z(time_inds_mvvislam(1));
        dr_struct.mv_vio.start_pose.q_w = mvvislam_struct.q_w(time_inds_mvvislam(1));
        dr_struct.mv_vio.b_g_start = mvvislam_struct.b_g(time_inds_mvvislam(1),:); %3x1 vector
        dr_struct.mv_vio.b_a_start = mvvislam_struct.b_a(time_inds_mvvislam(1),:); %3x1 vector
        dr_struct.mv_vio.v_start = mvvislam_struct.v(time_inds_mvvislam(1),:); %3x1 vector
        dr_struct.mv_vio.g_start = mvvislam_struct.g(time_inds_mvvislam(1),:); %3x1 vector
        
        %% Storing the complete vector as well.
        dr_struct.mv_vio.g_start = mvvislam_struct.g(time_inds_mvvislam,:);
        dr_struct.mv_vio.time_segment = mvvislam_struct.time(time_inds_mvvislam); %vector
        dr_struct.mv_vio.position = [mvvislam_struct.p_x(time_inds_mvvislam),...
                                    mvvislam_struct.p_y(time_inds_mvvislam),...
                                    mvvislam_struct.p_z(time_inds_mvvislam)];
        dr_struct.mv_vio.orientation_quat_W = [mvvislam_struct.q_w(time_inds_mvvislam),...
                                               mvvislam_struct.q_x(time_inds_mvvislam),...
                                               mvvislam_struct.q_y(time_inds_mvvislam),...
                                               mvvislam_struct.q_z(time_inds_mvvislam)];
                                           
        dr_struct.mv_vio.b_g = mvvislam_struct.b_g(time_inds_mvvislam,:); %3x1 vector
        dr_struct.mv_vio.b_a = mvvislam_struct.b_a(time_inds_mvvislam,:); %3x1 vector
        dr_struct.mv_vio.v = mvvislam_struct.v(time_inds_mvvislam,:); %3x1 vector
        dr_struct.mv_vio.g = mvvislam_struct.g(time_inds_mvvislam,:); %3x1 vector
        
    end
    
    if ((isempty(time_inds_vio)) && isempty(vinsmono_vio_struct))
        disp("no data for vinsmono, making empty struct");
        dr_struct.vio = struct();
    else
        dr_struct.vio.start_time = vinsmono_vio_struct.time(time_inds_vio(1));
        dr_struct.vio.time_segment = vinsmono_vio_struct.time(time_inds_vio); %vector
        dr_struct.vio.start_pose.p_x = vinsmono_vio_struct.p_x(time_inds_vio(1));
        dr_struct.vio.start_pose.p_y = vinsmono_vio_struct.p_y(time_inds_vio(1));
        dr_struct.vio.start_pose.p_z = vinsmono_vio_struct.p_z(time_inds_vio(1));
        dr_struct.vio.start_pose.q_x = vinsmono_vio_struct.q_x(time_inds_vio(1));
        dr_struct.vio.start_pose.q_y = vinsmono_vio_struct.q_y(time_inds_vio(1));
        dr_struct.vio.start_pose.q_z = vinsmono_vio_struct.q_z(time_inds_vio(1));
        dr_struct.vio.start_pose.q_w = vinsmono_vio_struct.q_w(time_inds_vio(1));
        dr_struct.vio.b_g_start = vinsmono_vio_struct.b_g(time_inds_vio(1),:); %3x1 vector
        dr_struct.vio.b_a_start = vinsmono_vio_struct.b_a(time_inds_vio(1),:); %3x1 vector
        dr_struct.vio.v_start = vinsmono_vio_struct.v(time_inds_vio(1),:); %3x1 vector
        dr_struct.vio.g_start = vinsmono_vio_struct.g(time_inds_vio(1),:); %3x1 vector
        
        % storing all the data. 
        dr_struct.vio.time_segment = vinsmono_vio_struct.time(time_inds_vio); %vector
        dr_struct.vio.position = [vinsmono_vio_struct.p_x(time_inds_vio),...
                                  vinsmono_vio_struct.p_y(time_inds_vio),...
                                  vinsmono_vio_struct.p_z(time_inds_vio)];
        dr_struct.vio.orientation_quat_W = [vinsmono_vio_struct.q_w(time_inds_vio),...
                                            vinsmono_vio_struct.q_x(time_inds_vio),...
                                            vinsmono_vio_struct.q_y(time_inds_vio),...
                                            vinsmono_vio_struct.q_z(time_inds_vio)];
                                           
        dr_struct.vio.b_g = vinsmono_vio_struct.b_g(time_inds_vio,:); %3x1 vector
        dr_struct.vio.b_a = vinsmono_vio_struct.b_a(time_inds_vio,:); %3x1 vector
        dr_struct.vio.v = vinsmono_vio_struct.v(time_inds_vio,:); %3x1 vector
        dr_struct.vio.g = vinsmono_vio_struct.g(time_inds_vio,:); %3x1 vector
    end
    
    % assign raw imu data - it is in body frame
    start_time_imu_raw = raw_imu_struct.time(time_inds_raw_imu(1));
    dr_struct.raw_imu.start_time = start_time_imu_raw;
    dr_struct.raw_imu.time_segment = raw_imu_struct.time(time_inds_raw_imu);
    dr_struct.raw_imu.angular_velocity_x = raw_imu_struct.angular_velocity_x(time_inds_raw_imu);
    dr_struct.raw_imu.angular_velocity_y = raw_imu_struct.angular_velocity_y(time_inds_raw_imu);
    dr_struct.raw_imu.angular_velocity_z = raw_imu_struct.angular_velocity_z(time_inds_raw_imu);
    dr_struct.raw_imu.acceleration_x = raw_imu_struct.acceleration_x(time_inds_raw_imu);
    dr_struct.raw_imu.acceleration_y = raw_imu_struct.acceleration_y(time_inds_raw_imu);
    dr_struct.raw_imu.acceleration_z = raw_imu_struct.acceleration_z(time_inds_raw_imu);
    
    % assign atti imu struct
    if ( isempty(atti_imu_struct) && isempty(time_inds_atti_imu))
        disp("No data for attitude available, making empty struct");
        dr_struct.atti_imu = struct();
    else 
        start_time = atti_imu_struct.time(time_inds_atti_imu(1));
        dr_struct.atti_imu.comment = 'quaternion_W - [qw,qx,qy,qz] , acc_W - [ax,ay,az], euler angle - ZYX format - Yaw pitch roll';
        dr_struct.atti_imu.start_time = start_time;
        dr_struct.atti_imu.time_segment = atti_imu_struct.time(time_inds_atti_imu);
        dr_struct.atti_imu.orientation_quat_W = atti_imu_struct.orientation_quat_W(time_inds_atti_imu,:);
        dr_struct.atti_imu.euler_angle_W_ZYX = atti_imu_struct.euler_angle_W_ZYX(time_inds_atti_imu,:);
        dr_struct.atti_imu.orientation_quat_W_offsetted = atti_imu_struct.orientation_quat_W_offsetted(time_inds_atti_imu,:);
        dr_struct.atti_imu.euler_angle_W_ZYX_offsetted = atti_imu_struct.euler_angle_W_ZYX_offsetted(time_inds_atti_imu,:);
        dr_struct.atti_imu.acc_W = atti_imu_struct.acc_W(time_inds_atti_imu,:);
        dr_struct.atti_imu.acc_imu = atti_imu_struct.acc_imu(time_inds_atti_imu,:);
    end
        dr_struct.gt.comment = "position p - [px,py,pz], quaterion q - [qw,qx,qy,qz]";
        dr_struct.gt.time_segment = gt_data_struct.time(time_inds_gt);
        dr_struct.gt.position = [gt_data_struct.p_x(time_inds_gt),...
                                 gt_data_struct.p_y(time_inds_gt),...
                                 gt_data_struct.p_z(time_inds_gt)];
        dr_struct.gt.orientation_quat_W = [gt_data_struct.q_w(time_inds_gt),...
                                           gt_data_struct.q_x(time_inds_gt),...
                                           gt_data_struct.q_y(time_inds_gt),...
                                           gt_data_struct.q_z(time_inds_gt)];
end


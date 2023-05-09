function euler_angle = trajectory_in_world_frame(t_opti,X_opti,W_T_M,W_T_IMU)
    [gt_pose_transformed_1,quat_available] = Transform_Frame_using_rot([t_opti,X_opti],W_T_M,W_T_IMU);
    euler_angle_gt_transformed_rot = quat2eul([gt_pose_transformed_2(:,8),...
                                           gt_pose_transformed_2(:,5:7)],'XYZ'); %xyz
                                       
    [M,N] = size(euler_angle_gt_transformed_rot);
    for index = 1:M
        euler_angle_gt_transformed_rot = W_T_M*euler_angle_gt_transformed_rot(i,:)';
    end
    f = figure();    
    % Plotting in optitrack frame
    plot_metadata.title_3d_position = 'Movement in 3D world - actual data Optitrack frame';
    plot_metadata.title_angle = 'Optitrack - XYZ euler angle in degrees using rot ';
    plot_metadata.title_position = 'Optitrack - position in optitrack frame - y up';
    plot_metadata.view_vector = [-1,0.1,.2];
    plot_gt_data(f,gt_pose_transformed_1(:,1),...
                gt_pose_transformed_1(:,2:4),...
                unwrap(euler_angle_gt_transformed_rot),...
                plot_metadata);
    euler_angle_gt_transformed_rot = (W_T_M*euler_angle_gt_transformed_rot)';
    
    f = figure();    
    % Plotting in optitrack frame
    plot_metadata.title_3d_position = 'Movement in 3D world - actual data Optitrack frame';
    plot_metadata.title_angle = 'Optitrack - XYZ euler angle in degrees using rot ';
    plot_metadata.title_position = 'Optitrack - position in optitrack frame - y up';
    plot_metadata.view_vector = [-1,0.1,.2];
    plot_gt_data(f,gt_pose_transformed_1(:,1),...
                gt_pose_transformed_1(:,2:4),...
                unwrap(euler_angle_gt_transformed_rot),...
                plot_metadata);
                                       
end
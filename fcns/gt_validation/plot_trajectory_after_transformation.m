function plot_trajectory_after_transformation(t_opti,X_opti,W_T_M,W_T_IMU,tag)
%PLOT_TRAJECTORY_AFTER_TRANSFORMATION Summary of this function goes here
%   Detailed explanation goes here
    [gt_pose_transformed,quat_available] = Transform_Frame_using_rot([t_opti,X_opti],W_T_M);
    euler_angle_gt_transformed_rot = quat2eul([gt_pose_transformed(:,8),...
                                           gt_pose_transformed(:,5:7)],'XYZ'); %xyz
    f = figure();    
    % Plotting in optitrack frame
    plot_metadata.title_3d_position = strcat('Movement in 3D world -',tag);
    plot_metadata.title_angle = 'XYZ euler angle in degrees';
    plot_metadata.title_position = 'Position in world (m)';
    plot_metadata.view_vector = [-1,0.1,.2];
    plot_gt_data_paper_format(f,gt_pose_transformed(:,1),...
                gt_pose_transformed(:,2:4),...
                rad2deg(unwrap(euler_angle_gt_transformed_rot)),...
                plot_metadata);
                                       
%     [gt_pose_transformed,quat_available] = Transform_Frame_using_quat([t_opti,X_opti],W_T_M,W_T_IMU);
%     euler_angle_gt_transformed_quat = quat2eul([gt_pose_transformed(:,8),...
%                                            gt_pose_transformed(:,5:7)],'XYZ'); %xyz
%     
%     f = figure();
%     plot_metadata.title_3d_position = 'Movement in 3D world - optitrack frame';
%     plot_metadata.title_angle = 'Optitrack - XYZ euler angle in degrees using quat ';
%     plot_metadata.title_position = 'Optitrack - position in optitrack frame - y up';
%     plot_metadata.view_vector = [-1,0.1,.2];
%     plot_gt_data(f,gt_pose_transformed(:,1),...
%                 gt_pose_transformed(:,2:4),...
%                 unwrap(euler_angle_gt_transformed_quat),...
%                 plot_metadata);
end


function gt_struct = convert_gt_data_to_gt_struct(gt_data_matrix)
    
    %gt file stored as t,px,py,pz,qx,qy,qz,qw - TUM format
    gt_struct.time = gt_data_matrix(:,1); % already in seconds
    gt_struct.p_x = gt_data_matrix(:,2);
    gt_struct.p_y = gt_data_matrix(:,3);
    gt_struct.p_z = gt_data_matrix(:,4);
    gt_struct.q_x = gt_data_matrix(:,5);
    gt_struct.q_y = gt_data_matrix(:,6);
    gt_struct.q_z = gt_data_matrix(:,7);
    gt_struct.q_w = gt_data_matrix(:,8);
end
function [gt_pose_transformed,quat_available] = Transform_Frame_using_quat(gt_chopped_data,W_T_M,R_T_IMU)
    [M,N] = size(gt_chopped_data);
    if N == 8
        quat_available = 1;
    else
        quat_available = 0;
    end
    w_q_m = rotm2quat(W_T_M(1:3,1:3));
    r_q_i = rotm2quat(R_T_IMU(1:3,1:3));
    gt_pose_transformed = zeros(M,8);
    for i=1:M
        if quat_available == 1
            % q = [w,x,y,z]
            q = [gt_chopped_data(i,8),gt_chopped_data(i,5:7)];
            
            quaternion_transformed = quatmultiply(q,r_q_i);
            quaternion_transformed = quatmultiply(w_q_m,quaternion_transformed);
            T = W_T_M*[eye(3),gt_chopped_data(i,2:4)';...
                                          zeros(1,3),1]*R_T_IMU;
        else
            quaternion_transformed = zeros(1,4);
            T = W_T_M*[eye(3),gt_chopped_data(i,2:4)';...
                                          zeros(1,3),1]*R_T_IMU;
        end
        position_transformed = T(1:3,end)';
        gt_pose_transformed(i,:) = [gt_chopped_data(i,1),...
                                    position_transformed,...
                                    quaternion_transformed(2:4),...
                                    quaternion_transformed(1)];
     end
        
end



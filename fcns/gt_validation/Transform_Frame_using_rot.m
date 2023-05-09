function [gt_pose_transformed,quat_available] = Transform_Frame_using_rot(gt_chopped_data,W_T_M)
    [M,N] = size(gt_chopped_data);
    if N == 8
        quat_available = 1;
    else
        quat_available = 0;
    end
    gt_pose_transformed = zeros(M,8);
    for i=1:M
        if quat_available == 1
            % q = [w,x,y,z]
            tranformation_mat = [quat2rotm([gt_chopped_data(i,8),gt_chopped_data(i,5:7)]),...
                                                  gt_chopped_data(i,2:4)';zeros(1,3),1];
        else
            tranformation_mat = [zeros(3,3),gt_chopped_data(i,2:4)';zeros(1,3),1];
        end
        
        % Converts position expressed in measurement frame to world frame
        % Here the impact of R_T_IMU is not present as the R and IMU frame
        % share the same origin as per our definition. 
        % W_T_M has the impact of changing the directions in which you move
        % in world frame due to its rotation matrix.
        
%         p_ = (tranformation_mat(1:3,4)'*R_T_IMU(1:3,1:3));
        p_ = tranformation_mat(1:3,4)'*eye(3);
        p__ = (W_T_M(1:3,1:3)*p_')';
        position_transformed = p__(1:3);
               
        %% Rotate the current frame to world frame by post-multiplying the inverse 
        % (as we want to make an opposite rotation to go into the world
        % frame)
        if quat_available == 1
            quaternion_transformed = rotm2quat(tranformation_mat(1:3,1:3)*W_T_M(1:3,1:3)');
        else
            quaternion_transformed = zeros(1,4);
        end
        % (t, x, y, z, qx, qy, qz, qw)
        gt_pose_transformed(i,:) = [gt_chopped_data(i,1),...
                                    position_transformed,...
                                    quaternion_transformed(2:4),...
                                    quaternion_transformed(1)];
    end
end


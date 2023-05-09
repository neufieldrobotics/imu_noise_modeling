function [position_w_0,quaternion_w_0,t_ind] = determine_start_pose(Data_ypr_dead_reckoning,t_start,t_end)
%DETERMINE_START_POSE Summary of this function goes here
%   Detailed explanation goes here
    gt_inds = find(Data_ypr_dead_reckoning.gt.time >= t_start & ...
                Data_ypr_dead_reckoning.gt.time <= t_end);
    position_w_0 = Data_ypr_dead_reckoning.gt.position_w(gt_inds(end),:);
    quaternion_w_0 = Data_ypr_dead_reckoning.gt.quaternion_w(gt_inds(end),:);
    t_ind = gt_inds(end);
end


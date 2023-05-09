function [optitrack_ind, optitrack_values] = find_nearest_optitrack_point(t_i, optitrack_times, optitrack_data)

% INPUTS:
% t_i - relative imu time which we seek closest optitrack data
% optitrack_times - (n x 1) vector of relative optitrack times
% optitrack_data -  (n x 7) matrix of optitrack data... pos, quat

% OUTPUTS:
% optitrack_ind - index of nearest optitrack value
% optitrack_values - optitrack data corresponding to optitrack_ind

% Check if t_i is at the end of the dataset
if t_i > optitrack_times(end)
    % If t_i is at the end of the dataset, choose the last optitrack point
    optitrack_ind = length(optitrack_times);
    optitrack_values = optitrack_data(optitrack_ind, :);
else
    % If t_i not at end of dataset, choose correct inds
    optitrack_inds = find(optitrack_times >= t_i);
    optitrack_ind = optitrack_inds(1); % nearest optitrack index greater than t_i timestamp
    optitrack_values = optitrack_data(optitrack_ind, :);
end

end


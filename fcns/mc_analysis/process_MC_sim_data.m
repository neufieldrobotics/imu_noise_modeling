function [average,sigma] = process_MC_sim_data(mc_sim_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    [M,N,P] = size(mc_sim_data.runData);

    % Statistics position
    for i = 1:3
        p_w_axis = mc_sim_data.runData(:,12+i,:);
        p_w_axis_ = permute(p_w_axis,[3,1,2]);
        average.p(:,i) = mean(p_w_axis_)'; % Store as a column vector
        sigma.p(:,i) = std(p_w_axis_)'; % Store as a column vector
    end

    tic;
    % Statistics velocity
    for i = 1:3
        v_w_axis = mc_sim_data.runData(:,9+i,:);
        v_w_axis_ = permute(v_w_axis,[3,1,2]);
        average.v(:,i) = mean(v_w_axis_); % Store as a column vector
        sigma.v(:,i) = std(p_w_axis_); % Store as a column vector
    end
    toc
    
    % Statistics orientation
    
    tic;
    euler_angles = Visualizer.to_euler_angle(mc_sim_data.runData);

    for i = 1:3
        euler_angle_axis = euler_angles(:,i,:);
        euler_angle_axis_ = permute(euler_angle_axis,[3,1,2]);
        average.theta(:,i) = mean(euler_angle_axis_); % Store as a column vector
        sigma.theta(:,i) = std(euler_angle_axis_); % Store as a column vector
    end
    toc;
end




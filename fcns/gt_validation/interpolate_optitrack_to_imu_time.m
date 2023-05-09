function [t_inter,pose,time_ind] = interpolate_optitrack_to_imu_time(unix_optitrack_time,X,unix_imu_time)

    % finds timestamps between first and last optitrack time as t_inter
    % where we will interpolate
    time_ind = find(unix_imu_time>=unix_optitrack_time(1) & unix_imu_time<=unix_optitrack_time(end));
    t_inter = unix_imu_time(time_ind); % imu time where optitrack values will be interpolated
    
    pos_inter = interp1(unix_optitrack_time,X(:,1:3),t_inter);
    [M,N] = size(X);
    if N == 7 % quaternions are present in ground truth 
        quat_inter = zeros(length(t_inter),4);
        t = unix_optitrack_time;
        for k=1:length(t_inter)

            index_first = find(t > t_inter(k));
            index_last = find (t <= t_inter(k));

            if ~isempty(index_last)
                t_floor = t(index_last(end));
            end

            if ~isempty(index_first)
                t_ceil = t(index_first(1));
            else 
                t_ceil = t(end);
            end

            if(t_ceil > t_floor && k > 1)
                coefficient = (t_inter(k)-t_floor)/(t_ceil - t_floor);
                q1 = quatnormalize(X(index_last(end),4:7));
                q2 = quatnormalize(X(index_first(1),4:7));
                quat_inter(k,:) = quatinterp(q1,q2,coefficient,'slerp');
            else
                quat_inter(k,:) = X(end,4:7);
            end
        end
    end
    if N == 7
%         pos_inter = [X(1,1:3);pos_inter;X(end,1:3)];
%         quat_inter = [X(1,4:7);quat_inter;X(end,4:7)];
%         pose = [pos_inter,quat_inter];
%         t_inter = [unix_optitrack_time(1);t_inter;unix_optitrack_time(end)];
        pose = [pos_inter,quat_inter];
    else
%         pose = [X(:,1:3);pos_inter;X(end,1:3)];
        pose = [X(:,1:3);pos_inter;X(end,1:3)];
    end
end
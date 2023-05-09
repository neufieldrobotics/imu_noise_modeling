function [t_inter,pose] = interpolate_optitrack(t,X)
    global interp_Hz
    t_inter = linspace(t(1),t(end),...
                    floor((t(end) - t(1))*interp_Hz));
    pos_interp = interp1(t,X(:,1:3),t_inter);
    [M,N] = size(X);
    if N == 7 % quaternions are present in ground truth 
        quat_inter = zeros(length(t_inter),4);
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
        pose = [pos_interp,quat_inter];
    else
        pose = pos_interp;
    end
end
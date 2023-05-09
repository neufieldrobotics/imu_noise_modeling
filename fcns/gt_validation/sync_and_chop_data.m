function [vio_estimate_chopped_data, gt_chopped_data] = ...
                        sync_and_chop_data(vio_estimate_data_runs,gt_data,...
                        percentage,seconds_to_del_at_end)
                    
        time_gt_data = gt_data(:,1);
        all_first_timestamps(1) = time_gt_data(1);
        all_last_timestamps(1) = time_gt_data(end);
        time_vio_data = cell(length(vio_estimate_data_runs),1);
        for i = 1:length(vio_estimate_data_runs)
            time_vio_data{i} = vio_estimate_data_runs{i}(:,1);
            
            % log all the starting timestamps in a row vector
            all_first_timestamps(1+i) = time_vio_data{i}(1);
            all_last_timestamps(1+i) = time_vio_data{i}(end);
        end
        
        % Find the maximum from all the starting time stamps
        t1 = max(all_first_timestamps);
        
        % always remove last segment of data - seems unreliable for
        % analysis
        t2 = min(all_last_timestamps) - seconds_to_del_at_end;
        
        delta_t = t2 - t1;
        
        % Chop using user input
        t2 = t1 + percentage*delta_t;
        %% Chop data from latest_start_timestamp to earliest_end_timestamp
        
        % Find those indices between t1 and t2
        gt_chopped_data = gt_data(time_gt_data>=t1 & ...
                                 time_gt_data <= t2,:);
        
        % Store index locations which are true to slice the data later on
        vio_estimate_chopped_data = cell(length(time_vio_data),1);
        for i = 1:length(time_vio_data)
            vio_estimate_chopped_data{i} = ...
                vio_estimate_data_runs{i}(time_vio_data{i}>=t1 & ...
                                 time_vio_data{i} <= t2,:);
        end
end
classdef Plot_Utility
    %VISUALIZE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        axis_length;
        figure_handles;
    end
    
    methods
        function obj = Visualize(inputArg1,inputArg2)
            %VISUALIZE Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function hand = plot_pose3(obj,origin, gRp)
            % Plot a 3D pose on given axis 'axes' with given 
            % 'axis_length
            hold on

            x_axis = origin + gRp(:, 1)' * obj.axis_length;
            line = [origin; x_axis];
            plot3(line(:, 1), line(:, 2), line(:, 3), 'r-')

            y_axis = origin + gRp(:, 2)' * obj.axis_length;
            line = [origin; y_axis];
            plot3(line(:, 1), line(:, 2), line(:, 3), 'g-')

            z_axis = origin + gRp(:, 3)' * obj.axis_length;
            line = [origin; z_axis];
            plot3(line(:, 1), line(:, 2), line(:, 3), 'b-')
            hold off
        end
        
        function collate_data(results_folder)
            simulation_results_files = dir(strcat(results_folder,'*.mat'));
            folder = simulation_results_files.folder;
            sim_averages = struct([]);
            sim_sigma = struct([]);
            % Collate everything
            for i = 1:length(simulation_results_files)
               filename = simulation_results_files(i).name;
               file = fullfile(folder,filename);
               load(file);
               sim_averages(i).name = filename;
               sim_averages(i) = average;
               
               sim_sigma(i).name = filename;
               sim_sigma(i) = sigma;
            end
            save('monte_carlo_simulation_stats.mat',...
                'sim_averages',...,
                'sim_sigma');
        end
    end
end


function visualize_mc_sim_runs_3d(montecarlo_sim_struct)
   % create a 3D visualization to show the data points obtained 
   % from each Montecarlo run.
   % To point out, how the mean and standard deviation looks in
   % in 3D
   % @author: Jagatpreet
   % @email: nir.j@northeastern.edu
   % Date created: Sep 9, 2023
   % Northeastern university
    num_steps = 4;
    t = montecarlo_sim_struct.t;
    step_size = (length(t)-1)/num_steps;
    indices = step_size:step_size:length(t);
    time_steps = t(indices(2:end));
    color = ['b', 'g', 'r', 'm'];
    figure()
    for j = 1:length(indices)
            x = reshape(montecarlo_sim_struct.runData(indices(j),13,:),...
                        [100,1]);
            y = reshape(montecarlo_sim_struct.runData(indices(j),14,:),...
                        [100,1]);
            z = reshape(montecarlo_sim_struct.runData(indices(j),15,:),...
                        [100,1]);
            
            hold on;
    end
    legend([strcat('Time step:', time_steps(1));...
           strcat('Time step:', time_steps(2));...
           strcat('Time step:', time_steps(3))],...
           'FontSize', 14);
    xlabel('X(m)', 'FontSize', 14);
    ylabel('Y(m)', 'FontSize', 14);
    zlabel('Z(m)', 'FontSize', 14);
    title("IMU navigation error", 'FontSize', 14);
    grid on
    grid minor
end
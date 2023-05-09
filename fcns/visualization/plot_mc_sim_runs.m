function h = plot_mc_sim_runs(MonteCarloSim,sim_name)
    % Position
    h = figure;
    y_labels = {'x(m)','y(m)','z(m)'};
    fmt.label.x = "t(s)";
    fmt.title = strcat(sim_name," position");
    [M,N,P] = size(MonteCarloSim.runData);
    position_all_runs = MonteCarloSim.runData(:,13:15,:);
    t = MonteCarloSim.t;
    for i = 1:P
        position_single_run = position_all_runs(:,:,i);
        [h1,h2,h3] = Visualizer.stacked_plot(MonteCarloSim.t,...
                                             position_single_run,...
                                             {'-','-','-'});
    end
    fmt.label.y = y_labels(1);
    Visualizer.format_plot(h1,fmt);
    
    fmt.label.y = y_labels(2);
    Visualizer.format_plot(h2,fmt);
    
    fmt.label.y = y_labels(3);
    Visualizer.format_plot(h3,fmt);
    
    % Velocity
    h2 = figure;
    y_labels = {'x(m/s)','y(m/s)','z(m/s)'};
    fmt.title = strcat(sim_name," velocity");
    fmt.label.x = "t(s)";
    vel_all_runs = MonteCarloSim.runData(:,10:12,:);
    t = MonteCarloSim.t;
    for i = 1:P
        vel_single_run = vel_all_runs(:,:,i);
        [h1,h2,h3] = Visualizer.stacked_plot(MonteCarloSim.t,...
                                             vel_single_run,...
                                             {'-','-','-'});
    end
    fmt.label.y = y_labels(1);
    Visualizer.format_plot(h1,fmt);
    
    fmt.label.y = y_labels(2);
    Visualizer.format_plot(h2,fmt);
    
    fmt.label.y = y_labels(3);
    Visualizer.format_plot(h3,fmt);
    
end
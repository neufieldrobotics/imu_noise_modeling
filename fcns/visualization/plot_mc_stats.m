function plot_mc_stats(f,comment,t,sim_averages,sim_sigma, opts)
    global total_runs
    plt_fmt.label.x = 'time(s)';
    plt_fmt.fields = f;
    plt_fmt.linespec = {'-','-','-'};
    use_noise_colors = opts.use_noise_colors
    figure();
    for i = 1:length(sim_averages)
        plt_fmt.MarkerIndices = 1:10:t{i};
        position_avg = sim_averages(i).p;
       [h1,h2,h3] = Visualizer.stacked_plot(t{i},...
                                            position_avg,...
                                            plt_fmt.linespec,...
                                            use_noise_colors);
    end
    y_limits = opts.y_limits_mean;
    plt_fmt.title = strcat('Mean - MC simulation - ',comment);
    plt_fmt.label.y = 'X(m)';
    plt_fmt.fields = f;
    Visualizer.format_plot(h1,plt_fmt,y_limits);

    plt_fmt.label.y = 'Y(m)';
    plt_fmt.title = '';
    plt_fmt.fields = f;
    Visualizer.format_plot(h2,plt_fmt,y_limits);

    plt_fmt.label.y = 'Z(m)';
    plt_fmt.title = '';
    plt_fmt.fields = f;
    Visualizer.format_plot(h3,plt_fmt,y_limits);

    plt_fmt.label.x = 'time(s)';
    plt_fmt.title = strcat('Standard deviation - MC simulation -',{' '},comment);
    plt_fmt.fields = f;
    
    % standard deviation
    figure
    for i = 1:length(sim_sigma)
       position_sigma = sim_sigma(i).p;
       [h1,h2,h3] = Visualizer.stacked_plot(t{i},position_sigma,...
                                            plt_fmt.linespec, use_noise_colors);
    end
    
    y_limits = opts.y_limits_sigma;
    plt_fmt.label.y = 'X(m)';
    plt_fmt.linespec = '-or';
    plt_fmt.title = strcat('Standard deviation ',comment);
    plt_fmt.fields = f;
    Visualizer.format_plot(h1,plt_fmt,y_limits);

    plt_fmt.label.y = 'Y(m)';
    plt_fmt.linespec = '-*m';
    plt_fmt.title = '';
    plt_fmt.fields = f;
    Visualizer.format_plot(h2,plt_fmt, y_limits);

    plt_fmt.label.y = 'Z(m)';
    plt_fmt.linespec = '-sb';
    plt_fmt.title = '';
    plt_fmt.fields = f;
    Visualizer.format_plot(h3,plt_fmt, y_limits); 
end

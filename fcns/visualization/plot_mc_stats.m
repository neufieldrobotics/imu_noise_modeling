function plot_mc_stats(f,comment,t,sim_averages,sim_sigma)
    global total_runs
    plt_fmt.label.x = 'time(s)';
    plt_fmt.title = strcat('Mean - MC simulation - ',comment);
    plt_fmt.fields = f;
    plt_fmt.linespec = {'-.','-.','-.'};
    
    figure
    for i = 1:length(sim_averages)
        plt_fmt.MarkerIndices = 1:10:t{i};
        position_avg = sim_averages(i).p;
       [h1,h2,h3] = Visualizer.stacked_plot(t{i},position_avg,plt_fmt.linespec);
    end

    plt_fmt.label.y = 'X(m)';
    Visualizer.format_plot(h1,plt_fmt);

    plt_fmt.label.y = 'Y(m)';
    Visualizer.format_plot(h2,plt_fmt);

    plt_fmt.label.y = 'Z(m)';
    Visualizer.format_plot(h3,plt_fmt);

    plt_fmt.label.x = 'time(s)';
    plt_fmt.title = strcat('Standard deviation',{' '},comment);
    plt_fmt.fields = f;
    figure
    for i = 1:length(sim_sigma)
       position_sigma = sim_sigma(i).p;
       [h1,h2,h3] = Visualizer.stacked_plot(t{i},position_sigma,plt_fmt.linespec);
    end

    plt_fmt.label.y = 'X(m)';
    plt_fmt.linespec = '-or';
    Visualizer.format_plot(h1,plt_fmt);

    plt_fmt.label.y = 'Y(m)';
    plt_fmt.linespec = '-*m';
    Visualizer.format_plot(h2,plt_fmt);

    plt_fmt.label.y = 'Z(m)';
    plt_fmt.linespec = '-sb';
    Visualizer.format_plot(h3,plt_fmt); 
end

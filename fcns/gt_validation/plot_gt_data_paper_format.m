function plot_gt_data_paper_format(figHandle,time,pose,euler_angle,plot_metadata)
    opti_data_labels = {'x','y','z'};
    
    
    % XY VIEW
    subplot(3,2,1);
    plot(pose(1,1),pose(1,2),'*',...
             'LineWidth',2,'MarkerSize',6,...
             'MarkerEdgeColor','g','MarkerFaceColor',[0 1 0]);
    hold on;
    plot(pose(:,1),pose(:,2),'.',...
         'LineWidth',2,'MarkerSize',4,...
         'MarkerEdgeColor','k','MarkerFaceColor',[1 0 0]);
         
    hold on;
    plot(pose(end,1),pose(end,2),'*',...
         'LineWidth',2,'MarkerSize',6,...
         'MarkerEdgeColor','r','MarkerFaceColor',[0 0 1]);
    xlabel('x(m)','FontSize',16)
    ylabel('y(m)','FontSize',16)
    grid on
    
    sgtitle(plot_metadata.title_3d_position,...
            'interpreter','none','FontSize',16);
    axis equal 
    
    subplot(3,2,2);
    plot(pose(1,2),pose(1,3),'*',...
             'LineWidth',2,'MarkerSize',6,...
             'MarkerEdgeColor','g','MarkerFaceColor',[0 1 0]);
    hold on;
    plot(pose(:,2),pose(:,3),'.',...
             'LineWidth',2,'MarkerSize',4,...
             'MarkerEdgeColor','k','MarkerFaceColor',[1 0 0]);
         
    hold on;
    plot(pose(end,2),pose(end,3),'*',...
             'LineWidth',2,'MarkerSize',6,...
             'MarkerEdgeColor','r','MarkerFaceColor',[0 0 1]);
    xlabel('y(m)','FontSize',16)
    ylabel('z(m)','FontSize',16)
    grid on
    axis equal
   

    subplot(3,2,[3,4]);
    set(gca, 'defaultTextInterpreter', 'latex');
    s = stackedplot(time-time(1),euler_angle,...
                'Title',plot_metadata.title_angle,...
                'DisplayLabels',{'\alpha ',...
                                  '\beta ',...
                                  '\gamma '},...
                'Marker','.',...
                'MarkerSize',2,...
                'LineStyle','none',...
                'GridVisible','on',...
                'FontSize',14);
    s_ax = s.NodeChildren(end/2+1:end);
    for K = s_ax.'; K.YLabel.Interpreter = 'tex'; end
%      for i = 1:3
%          s.AxesProperties(i).YLimits = [0,360];
%      end

    subplot(3,2,[5,6]);
    s = stackedplot(time-time(1),pose(:,1:3),...
                'Title',plot_metadata.title_position,...
                'DisplayLabels',opti_data_labels,...
                'Marker','.',...
                'MarkerSize',2,...
                'LineStyle','none',...
                'GridVisible','on',...
                 'FontSize',14);
end
